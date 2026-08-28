// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;
const Vec = std.ArrayList;
const shake128 = std.crypto.hash.sha3.Shake128.hash;
const argon2 = std.crypto.pwhash.argon2;
const hmac = std.crypto.auth.hmac.sha2.HmacSha256;



fn Hex(allocator: std.mem.Allocator, bytes: []const u8) ![]u8 {
    var converted_str: std.ArrayList(u8) = .empty;
    defer converted_str.deinit(allocator);

    const hex_chars = "0123456789abcdef";
    
    for (bytes) |byte| {
        try converted_str.append(allocator, hex_chars[byte >> 4]);
        try converted_str.append(allocator, hex_chars[byte & 0x0f]);
    }
    
    return try converted_str.toOwnedSlice(allocator);
}


pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const alloc = init.gpa;
    const rng_impl: std.Random.IoSource = .{ .io = io };
    const rand = rng_impl.interface();

    var nonce: [16]u8 = undefined;
    var buffer: [1024]u8 = undefined;
    var argon2_buffer: [48]u8 = undefined;
    var input = std.Io.File.stdin().reader(io, &buffer);

    var bytes_vec: Vec(u8) = .empty;
    defer bytes_vec.deinit(alloc);

    const title =
        "The \x1b[93mreally sophisticated\x1b[0m " ++
        "\x1b[1;32mMessage Encryptor\x1b[0m " ++
        "\x1b[90mv0.0.0.0.32.0.0\x1b[0m\n";
    const very_dramatic_text = "\n\x1b[31mEncrypting\x1b[0m the \x1b[1;31mmessage\x1b[0m . . . .\n\n";

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
    
    for (message, 0..) |byte, i| {
        try bytes_vec.append(alloc, byte ^ keystream[i]);
    }

    const enc_message = bytes_vec.items;
    var hmac_stream = hmac.init(argon2_mac);
    
    hmac_stream.update(&nonce);
    hmac_stream.update(enc_message);
        
    var mac_buffer: [hmac.mac_length]u8 = undefined;
    
    hmac_stream.final(&mac_buffer);
    
    const mac = mac_buffer[0..16];
    const hex_nonce = try Hex(alloc, &nonce);
    defer alloc.free(hex_nonce);
    const hex_enc_message = try Hex(alloc, enc_message);
    defer alloc.free(hex_enc_message);
    const hex_mac = try Hex(alloc, mac);
    defer alloc.free(hex_mac);

    try io.sleep(.fromSeconds(1), .awake);
    
    print("Encrypted message: \n{s}:{s}:{s}\n", .{hex_nonce, hex_enc_message, hex_mac});
}
