// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;
const Vec = std.ArrayList;
const shake128 = std.crypto.hash.sha3.Shake128.hash;
const argon2 = std.crypto.pwhash.argon2;
const hmac = std.crypto.auth.hmac.sha2.HmacSha256;



fn Base58(allocator: std.mem.Allocator, bytes: []const u8) ![]u8 {
    if (bytes.len == 0) {
        return try allocator.alloc(u8, 0);
    }

    const alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
    var zeroes: usize = 0;
    
    for (bytes, 0..) |byte, index| {
        if (byte != 0) {
            zeroes = index;
            break;
        }
    } else {
        zeroes = bytes.len;
    }
    
    const input = try allocator.alloc(u8, bytes.len);
    @memcpy(input, bytes);
    defer allocator.free(input);

    var converted_str: std.ArrayListUnmanaged(u8) = .empty;
    errdefer converted_str.deinit(allocator); 

    var start = zeroes;
    
    while (start < input.len) {
        var remainder: u32 = 0;
        var i = start;
        
        while (i < input.len) : (i += 1) {
            const acc: u32 = @as(u32, input[i]) + (remainder << 8);
            
            input[i] = @intCast(acc / 58);
            remainder = acc % 58;
        }
        
        if (input[start] == 0) {
            start += 1;
        }
        
        try converted_str.append(allocator, alphabet[remainder]);
    }

    try converted_str.appendNTimes(allocator, alphabet[0], zeroes);

    const result = try converted_str.toOwnedSlice(allocator);
    
    std.mem.reverse(u8, result);
    
    return result;
}


pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const alloc = init.gpa;
    const rng_impl: std.Random.IoSource = .{ .io = io };
    const rand = rng_impl.interface();
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var nonce: [16]u8 = undefined;
    var buffer: [1024]u8 = undefined;
    var argon2_buffer: [48]u8 = undefined;
    var input = std.Io.File.stdin().reader(io, &buffer);
    var save_path: ?[]const u8 = null;

    var bytes_vec: Vec(u8) = .empty;
    defer bytes_vec.deinit(alloc);

    const title =
        "The \x1b[93mreally sophisticated\x1b[0m " ++
        "\x1b[1;32mMessage Encryptor\x1b[0m " ++
        "\x1b[90mv0.0.0.0.32.0.0\x1b[0m\n";
    const very_dramatic_text = "\n\x1b[31mEncrypting\x1b[0m the \x1b[1;31mmessage\x1b[0m . . . .\n\n";

    {
        var i: usize = 1;
        
        while (i < args.len) : (i += 1) {
            const arg = args[i];
    
            if (!std.mem.eql(u8, arg, "-s")) {
                print("Unknown argument: {s}\n", .{arg});
                return;
            }
    
            if (save_path != null) {
                print("Error: -s given more than once\n", .{});
                return;
            }
        
            i += 1;
            
            if (i >= args.len) {
                print("Error: -s requires a filename\n", .{});
                return;
            }
            
            save_path = args[i];
        }
    }

    print("{s}\n", .{title});
    
    try io.sleep(.fromMilliseconds(200), .awake);

    print("Enter the message: ", .{});

    var str = try input.interface.takeDelimiter('\n') orelse return;

    if (str.len == 0) {
        print("You had to enter message!!!\n", .{});
        return;
    }
    
    const message = try alloc.dupe(u8, str);
    defer alloc.free(message);

    print("Enter the key: ", .{});
    str = try input.interface.takeDelimiter('\n') orelse return;

    if (str.len == 0) {
        print("You had to enter key!!!\n", .{});
        return;
    }
    
    const key = try alloc.dupe(u8, str);
    defer alloc.free(key);
    
    for (very_dramatic_text) |char| {
        print("{c}", .{char});
        
        try io.sleep(.fromMilliseconds(100), .awake);
    }

    rand.bytes(&nonce);

    try argon2.kdf(alloc, &argon2_buffer, key, &nonce, .{ .t = 3, .m = 65536, .p = 1 }, .argon2id, io);
    
    const argon2_keystream = argon2_buffer[0..32];
    const argon2_mac = argon2_buffer[32..48];
    const keystream = try alloc.alloc(u8, message.len);
    defer alloc.free(keystream);
    
    shake128(argon2_keystream, keystream, .{});

    {
        for (message, 0..) |byte, i| {
            try bytes_vec.append(alloc, byte ^ keystream[i]);
        }
    }
    
    const enc_message = bytes_vec.items;
    var hmac_stream = hmac.init(argon2_mac);
    
    hmac_stream.update(&nonce);
    hmac_stream.update(enc_message);
        
    var mac_buffer: [hmac.mac_length]u8 = undefined;
    
    hmac_stream.final(&mac_buffer);
    
    const mac = mac_buffer[0..16];
    const comp_nonce = try Base58(alloc, &nonce);
    defer alloc.free(comp_nonce);
    const comp_enc_message = try Base58(alloc, enc_message);
    defer alloc.free(comp_enc_message);
    const comp_mac = try Base58(alloc, mac);
    defer alloc.free(comp_mac);

    try io.sleep(.fromSeconds(1), .awake);

    print("Encrypted message: \n{s}:{s}:{s}\n", .{comp_mac, comp_nonce, comp_enc_message});

    if (save_path) |path| {
        const out_file = try std.Io.Dir.cwd().createFile(io, path, .{});
        defer out_file.close(io);
        
        try out_file.writeStreamingAll(io, mac);
        try out_file.writeStreamingAll(io, &nonce);
        try out_file.writeStreamingAll(io, enc_message);
    
        print("Saved to {s}\n", .{path});
    }
}
