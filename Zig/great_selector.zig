// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;
const Vec = std.ArrayList;
const shuffle = std.Random.shuffle;



pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const alloc = init.gpa;
    const rng_impl: std.Random.IoSource = .{ .io = io };
    const rand = rng_impl.interface();

    var buffer: [1024]u8 = undefined;
    var input = std.Io.File.stdin().reader(io, &buffer);
    var options_list: Vec([]const u8) = .empty;

    const title =
        "\x1b[93mThe super pretentious\x1b[0m " ++
        "\x1b[1;32mGreat Selector\x1b[0m " ++
        "\x1b[90mv0.0.0.0.16.0.0\x1b[0m\n";

    print("{s}\n", .{title});

    try io.sleep(.fromSeconds(1), .awake);

    defer {
        for (options_list.items) |item| {
            alloc.free(item);
        }

        options_list.deinit(alloc);
    }

    print("Enter the options (empty line to finish):\n", .{});

    while (true) {
        const option = try input.interface.takeDelimiter('\n') orelse break;

        if (option.len == 0) {
            break;
        }

        const copy = try alloc.dupe(u8, option);
        
        try options_list.append(alloc, copy);
    }

    const num_options = options_list.items.len;

    if (num_options < 2) {
        print("You had to enter at least two options!!!\n", .{});

        return;
    }

    const very_dramatic_text = "The \x1b[31mdie\x1b[0m is \x1b[1;31mcast\x1b[0m . . . .\n\n";

    for (very_dramatic_text) |char| {
        print("{c}", .{char});

        try io.sleep(.fromMilliseconds(100), .awake);
    }

    try io.sleep(.fromSeconds(1), .awake);

    shuffle(rand, []const u8, options_list.items);
    
    const rand_index = rand.uintLessThan(u64, num_options);
    const choice = options_list.items[rand_index];

    print("Random option: {s}\n", .{choice});
}
