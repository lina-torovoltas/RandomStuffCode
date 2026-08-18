const std = @import("std");



const Timespec = extern struct {
    sec: i64,
    nsec: i64,
};


fn get_random(buf: []u8) void {
    _ = asm volatile ("syscall"
        : [ret] "={rax}" (-> usize),
        : [num] "{rax}" (318),
          [buf] "{rdi}" (buf.ptr),
          [len] "{rsi}" (buf.len),
          [flags] "{rdx}" (@as(usize, 0)),
        : .{
            .rcx = true, 
            .r11 = true, 
            .memory = true 
            }
    );
}

fn delay_sec(sec: i64) void {
    var ts = Timespec{ .sec = sec, .nsec = 0 };
    
        _ = asm volatile ("syscall"
        : [ret] "={rax}" (-> usize),
        : [num] "{rax}" (35),
          [req] "{rdi}" (&ts),
          [rem] "{rsi}" (@as(usize, 0)),
        : .{ 
            .rcx = true,
            .r11 = true, 
            .memory = true 
            }
    );
}

fn rand_range(lo: u64, hi: u64) u64 {
    var raw: u64 = undefined;
    get_random(std.mem.asBytes(&raw));
    const range = hi - lo + 1;
    
    return lo + (raw % range);
}


pub fn main() void {
    var progress: u64 = 0;
    
    while (progress < 100) {
        const max = @min(progress + 20, 100);
        progress = rand_range(progress + 1, max);
        
        std.debug.print("Pentagon hack progress: {}%\n", .{progress});
        
        delay_sec(1);
    }

    if (rand_range(1, 30) > 20) {
        std.debug.print("Pentagon hack: Completed successfully.\n", .{});
        
    } else {
        std.debug.print("Pentagon hack: Failed.\n", .{});
    }
}
