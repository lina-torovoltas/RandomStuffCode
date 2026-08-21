// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;



pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const rand = (std.Random.IoSource{ .io = io }).interface();
    
    var progress: u7 = 0;
    
    while (progress < 100) {
        const max = @min(progress + 20, 100);
        progress = rand.intRangeAtMost(u7, progress + 1, max);
        
        print("Pentagon hack progress: {}%\n", .{progress});
        
        try io.sleep(.fromSeconds(1), .awake);
    }

    if (rand.intRangeAtMost(u5, 1, 30) > 20) {
        print("Pentagon hack: Completed successfully.\n", .{});
        
    } else {
        print("Pentagon hack: Failed.\n", .{});
    }
}
