// zig version 0.16.0

const std = @import("std");
const tern = @import("ternlib.zig");
const print = std.debug.print;



const TernPlanes = tern.TernPlanes(u42);
    
fn get_tribble(planes: TernPlanes, shift: usize) i32 {
    var value: i32 = 0;
    var weight: i32 = 1;

    for (0..3) |i| {
        const bit = @as(u42, 1) << @as(u6, @intCast(shift + i));

        var trit: i32 = 0;
        
        if (planes.p & bit != 0) {
            trit = 1;
        
        } else if (planes.n & bit != 0) {
            trit = -1;
        }
        
        value += trit * weight;
        weight *= 3;
    }
    
    return value;
}

fn formatToHEP(num_planes: TernPlanes, buf: *[14]u8) void {
    const digits = "mlkjihgfedcba=ABCDEFGHIJKLM";

    for (0..14) |i| {
        const shift: u6 = @intCast((13 - i) * 3);
        const value = get_tribble(num_planes, shift);

        buf[i] = digits[@intCast(value + 13)];
    }
}


fn step(num_planes: TernPlanes) TernPlanes {
    var state: TernPlanes = undefined;

    state = tern.addMod(num_planes, tern.shl(num_planes, 9));
    state = tern.addMod(state, tern.shr(state, 22));
    state = tern.addMod(state, tern.shl(state, 7));

    return tern.rotl(state, 1);
}



pub fn main(init: std.process.Init) !void {
    const io = init.io;
    
    const title =
        "The \x1b[93mmost niche\x1b[0m " ++
        "\x1b[1;32mTernXoroShift42\x1b[0m " ++
        "\x1b[90mv42.14.7-ternlib\x1b[0m\n";
        
    var buf: [14]u8 = undefined;
    var state = TernPlanes{
        .p = 0b100001,
        .n = 0b011010,
    };
    
    print("{s}\n", .{title});

    try io.sleep(.fromMilliseconds(200), .awake);

    formatToHEP(state, &buf);
    print(
        "\x1b[93mInitial number:\x1b[0m \x1b[1;31m{s}\x1b[0m\n\n",
        .{buf},
    );

    try io.sleep(.fromMilliseconds(250), .awake);

    for (0..20) |i| {
        try io.sleep(.fromMilliseconds(100), .awake);
        
        state = step(state);
        
        formatToHEP(state, &buf);
        
        print(
            "\x1b[90mstep:\x1b[0m \x1b[1;33m{d:>2}\x1b[0m  "
            ++ "\x1b[90mnum:\x1b[0m \x1b[1;32m{s}\x1b[0m\n", 
            .{ i + 1, buf },
        );
    }
}
