// zig version 0.16.0

const std = @import("std");
const print = std.debug.print;



/// each trit is represented by two planes:
/// p is the positive plane for +1
/// n is the negative plane for -1
///
/// if p = 1 and n = 0 then +
/// if p = 0 and n = 1 then -
/// if p = 0 and n = 0 then 0
const TernPlanes = struct {
    p: u27,
    n: u27,
};


fn get_tribble(planes: TernPlanes, shift: u5) i32 {
    var value: i32 = 0;
    var weight: i32 = 1;

    for (0..3) |i| {
        const bit_position = shift + @as(u5, @intCast(i));
        const bit = @as(u27, 1) << bit_position;

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

fn formatToHEP(num_planes: TernPlanes, buf: *[9]u8) void {
    const digits = "mlkjihgfedcba=ABCDEFGHIJKLM";

    for (0..9) |i| {
        const shift: u5 = @intCast((8 - i) * 3);
        const value = get_tribble(num_planes, shift);

        buf[i] = digits[@intCast(value + 13)];
    }
}


fn xor(num1: TernPlanes, num2: TernPlanes) TernPlanes {
    const num1_zero = ~(num1.p | num1.n);
    const num2_zero = ~(num2.p | num2.n);

    var result: TernPlanes = undefined;

    result.p = (num1.p & num2_zero) | (num2.p & num1_zero) | (num1.n & num2.n);
    result.n = (num1.n & num2_zero) | (num2.n & num1_zero) | (num1.p & num2.p);

    return result;
}

fn shl(num_planes: TernPlanes, shift: u5) TernPlanes {
    var result: TernPlanes = undefined;

    result.p = num_planes.p << shift;
    result.n = num_planes.n << shift;

    return result;
}

fn shr(num_planes: TernPlanes, shift: u5) TernPlanes {
    var result: TernPlanes = undefined;

    result.p = num_planes.p >> shift;
    result.n = num_planes.n >> shift;

    return result;
}

fn neg(num_planes: TernPlanes) TernPlanes {
    var result: TernPlanes = undefined;

    result.p = num_planes.n;
    result.n = num_planes.p;

    return result;
}


fn step(num_planes: TernPlanes) TernPlanes{
    var state: TernPlanes = undefined;
    
    state = xor(num_planes, shl(num_planes, 2));
    state = xor(state, shr(state, 7));
    state = xor(state, shl(state, 4));

    return neg(state);
}



pub fn main(init: std.process.Init) !void {
    const io = init.io;
    
    const title =
        "The \x1b[93mmost niche\x1b[0m " ++
        "\x1b[1;32mTernXorShift27\x1b[0m " ++
        "\x1b[90mv27.9.3\x1b[0m\n";
        
    var buf: [9]u8 = undefined;
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
