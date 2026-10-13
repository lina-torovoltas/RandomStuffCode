// zig version 0.16.0

const std = @import("std");



/// each trit is represented by two planes:
/// p is the positive plane for +1
/// n is the negative plane for -1
///
/// if p = 1 and n = 0 then +
/// if p = 0 and n = 1 then -
/// if p = 0 and n = 0 then 0
pub fn TernPlanes(comptime PlaneInt: type) type {
    const Planes = struct {
        p: PlaneInt,
        n: PlaneInt,
    };

    return Planes;
}


// Unary 
pub fn neg(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = num_planes.n;
    result.n = num_planes.p;

    return result;
}

pub fn inc(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = ~(num_planes.p | num_planes.n);
    result.n = num_planes.p;

    return result;
}

pub fn dec(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = num_planes.n;
    result.n = ~(num_planes.p | num_planes.n);

    return result;
}

//

pub fn zeroingN(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = num_planes.p;
    result.n = 0;

    return result;
}

pub fn zeroingP(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = 0;
    result.n = num_planes.n;

    return result;
}

pub fn abs(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = num_planes.p | num_planes.n;
    result.n = 0;

    return result;
}

//

pub fn isZero(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = ~(num_planes.p | num_planes.n);
    result.n = 0;

    return result;
}

pub fn isPos(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = num_planes.p;
    result.n = 0;

    return result;
}

pub fn isNeg(num_planes: anytype) @TypeOf(num_planes) {
    var result: @TypeOf(num_planes) = undefined;

    result.p = num_planes.n;
    result.n = 0;

    return result;
}


// Binary

pub fn addMod(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    const num1_zero = ~(num1.p | num1.n);
    const num2_zero = ~(num2.p | num2.n);

    var result: @TypeOf(num1) = undefined;

    result.p = (num1.p & num2_zero) | (num2.p & num1_zero) | (num1.n & num2.n);
    result.n = (num1.n & num2_zero) | (num2.n & num1_zero) | (num1.p & num2.p);

    return result;
}

pub fn subMod(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    const num1_zero = ~(num1.p | num1.n);
    const num2_zero = ~(num2.p | num2.n);

    var result: @TypeOf(num1) = undefined;

    result.p = (num1.p & num2_zero) | (num2.n & num1_zero) | (num1.n & num2.p);
    result.n = (num1.n & num2_zero) | (num2.p & num1_zero) | (num1.p & num2.n);

    return result;
}

pub fn mulMod(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    var result: @TypeOf(num1) = undefined;

    result.p = (num1.p & num2.p) | (num1.n & num2.n);
    result.n = (num1.p & num2.n) | (num1.n & num2.p);

    return result;
}

//

pub fn min(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    var result: @TypeOf(num1) = undefined;

    result.p = num1.p & num2.p;
    result.n = num1.n | num2.n;

    return result;
}

pub fn max(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    var result: @TypeOf(num1) = undefined;

    result.p = num1.p | num2.p;
    result.n = num1.n & num2.n;

    return result;
}

pub fn intersect(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    var result: @TypeOf(num1) = undefined;

    result.p = num1.p & num2.p;
    result.n = num1.n & num2.n;

    return result;
}

pub fn webb(num1: anytype, num2: @TypeOf(num1)) @TypeOf(num1) {
    var result: @TypeOf(num1) = undefined;

    result.p = ~(num1.p | num2.p | (num1.n & num2.n));
    result.n = num1.p | num2.p;

    return result;
}

//

pub fn shl(num_planes: anytype, shift: usize) @TypeOf(num_planes) {
    const PlaneInt = @TypeOf(num_planes.p);
        
    var result: @TypeOf(num_planes) = undefined;
    
    result.p = std.math.shl(PlaneInt, num_planes.p, shift);
    result.n = std.math.shl(PlaneInt, num_planes.n, shift);
    
    return result;
}

pub fn shr(num_planes: anytype, shift: usize) @TypeOf(num_planes) {
    const PlaneInt = @TypeOf(num_planes.p);
    
    var result: @TypeOf(num_planes) = undefined;

    result.p = std.math.shr(PlaneInt, num_planes.p, shift);
    result.n = std.math.shr(PlaneInt, num_planes.n, shift);

    return result;
}


//

pub fn rotl(num_planes: anytype, shift: usize) @TypeOf(num_planes) {
    const PlaneInt = @TypeOf(num_planes.p);
    
    var result: @TypeOf(num_planes) = undefined;

    result.p = std.math.rotl(PlaneInt, num_planes.p, shift);
    result.n = std.math.rotl(PlaneInt, num_planes.n, shift);

    return result;
}

pub fn rotr(num_planes: anytype, shift: usize) @TypeOf(num_planes) {
    const PlaneInt = @TypeOf(num_planes.p);
    
    var result: @TypeOf(num_planes) = undefined;

    result.p = std.math.rotr(PlaneInt, num_planes.p, shift);
    result.n = std.math.rotr(PlaneInt, num_planes.n, shift);

    return result;
}
