const std = @import("std");
const print = std.debug.print;



pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [16]u8 = undefined;
    var input = std.Io.File.stdin().reader(io, &buf);

    print("Enter text:  ", .{});

    const str = try input.interface.takeDelimiter('\n') orelse return;

    if (str.len == 0) {
        print("You had to enter text!!!\n", .{});
        return;
    }

    print("You entered: {s}\n", .{str});
}
