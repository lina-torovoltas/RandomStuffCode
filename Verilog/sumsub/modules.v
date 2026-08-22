module full_adder (
    input wire a,
    input wire b,
    input wire cry_in,
    
    output wire sum,
    output wire cry_out
    );
    
    assign sum  = a ^ b ^ cry_in;
    assign cry_out = (a & b) | (cry_in & (a ^ b));
endmodule


module full_subtractor (
    input wire a,
    input wire b,
    input wire bor_in,
    
    output wire diff,
    output wire bor_out
    );
    
    assign diff = a ^ b ^ bor_in;
    assign bor_out = (~a & b) | (bor_in & ~(a ^ b));
endmodule
