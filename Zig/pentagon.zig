const std = @import("std");



pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const rng_impl: std.Random.IoSource = .{ .io = io };
    const rand = rng_impl.interface();
    
    var progress: u64 = 0;
    
    while (progress < 100) {
        const max = @min(progress + 20, 100);
        progress = rand.intRangeAtMost(u64, progress + 1, max);
        
        std.debug.print("Pentagon hack progress: {}%\n", .{progress});
        
        try io.sleep(.fromSeconds(1), .awake);
    }

    if (rand.intRangeAtMost(u8, 1, 30) > 20) {
        std.debug.print("Pentagon hack: Completed successfully.\n", .{});
        
    } else {
        std.debug.print("Pentagon hack: Failed.\n", .{});
    }
}
