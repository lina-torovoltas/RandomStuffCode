// zig version 0.16.0

const std = @import("std");
const tern = @import("ternlib");

const print = std.debug.print;
const NonaVerbum = tern.types.NonaVerbum;
const addMod = tern.dyadic.addMod;
const shl = tern.shifts.shl;
const shr = tern.shifts.shr;
const neg = tern.monadic.neg;
const formatToHEP = tern.formats.encodeHEP;



// Shift parameters
const A = 53;
const B = 84;
const C = 28;


const step_text =
    "\x1b[90mstep:\x1b[0m \x1b[1;33m{d:>2}\x1b[0m  " ++ 
    "\x1b[90mnum:\x1b[0m \x1b[1;32m{s}\x1b[0m\n";

const title =
    "The \x1b[93mmost niche\x1b[0m " ++
    "\x1b[1;32mTern-AddShiftNeg243\x1b[0m " ++
    "\x1b[90mv243.81.27\x1b[0m\n";
    
const init_text = "\x1b[93mInitial number:\x1b[0m \x1b[1;31m{s}\x1b[0m\n\n";


var init_num = NonaVerbum{
    .p = 0b100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100_100,
    .n = 0b001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001_001,
};


fn step(num_planes: NonaVerbum) NonaVerbum {
    var state: NonaVerbum = undefined;
    
    state = addMod(num_planes, shl(num_planes, A));
    state = addMod(state, shr(state, B));
    state = addMod(state, shl(state, C));

    return neg(state);
}



pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var buf: [81]u8 = undefined;
        
    print("{s}\n", .{title});
    try io.sleep(.fromMilliseconds(200), .awake);
    
    print(init_text, .{formatToHEP(init_num, &buf)});
    var state = init_num;
    try io.sleep(.fromMilliseconds(250), .awake);

    for (0..50) |i| {
        try io.sleep(.fromMilliseconds(100), .awake);
        
        state = step(state);
        
        print(step_text, .{ i + 1, formatToHEP(state, &buf)});
    }
}
