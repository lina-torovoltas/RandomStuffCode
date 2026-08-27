// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;
const Vec = std.ArrayList;
const hash = std.crypto.hash.sha3.Shake128.hash;



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

    var buffer: [1024]u8 = undefined;
    var input = std.Io.File.stdin().reader(io, &buffer);

    const title =
        "The \x1b[93mreally sophisticated\x1b[0m " ++
        "\x1b[1;32mMessage Encryptor\x1b[0m " ++
        "\x1b[90mv0.0.0.0.32.0.0\x1b[0m\n";

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

    const very_dramatic_text = "\n\x1b[31mEncrypting\x1b[0m the \x1b[1;31mmessage\x1b[0m . . . .\n\n";
    
    for (very_dramatic_text) |char| {
        print("{c}", .{char});
        
        try io.sleep(.fromMilliseconds(100), .awake);
    }
    
    const keystream = try alloc.alloc(u8, message.len);
    defer alloc.free(keystream);
    hash(key, keystream, .{});
    
    var bytes_vec: Vec(u8) = .empty;
    defer bytes_vec.deinit(alloc);
    
    for (message, 0..) |byte, i| {
        try bytes_vec.append(alloc, byte ^ keystream[i]);
    }
    
    const encrypted_message = try Hex(alloc, bytes_vec.items);
    defer alloc.free(encrypted_message);

    const hex_keystream = try Hex(alloc, keystream);
    defer alloc.free(hex_keystream);

    try io.sleep(.fromSeconds(1), .awake);
    
    print("Encrypted message: {s}\n", .{encrypted_message});
    print("Keystream in hex: {s}\n", .{hex_keystream});
}
