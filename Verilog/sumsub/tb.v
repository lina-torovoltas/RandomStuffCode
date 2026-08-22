`timescale 1ns/1ps

module testbench;

    reg  num1, num2, cry_in, bor_in;
    wire sum, cry_out, diff_bor_out;

    full_adder u_adder (
        .a(num1), .b(num2), .cry_in(cry_in),
        .sum(sum), .cry_out(cry_out)
    );

    full_subtractor u_sub (
        .a(num1), .b(num2), .bor_in(bor_in),
        .diff(diff), .bor_out(bor_out)
    );

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, testbench);

        {num1, num2, cry_in, bor_in} = 4'b0000; #10;
        {num1, num2, cry_in, bor_in} = 4'b0011; #10;
        {num1, num2, cry_in, bor_in} = 4'b0101; #10;
        {num1, num2, cry_in, bor_in} = 4'b0111; #10;
        {num1, num2, cry_in, bor_in} = 4'b1001; #10;
        {num1, num2, cry_in, bor_in} = 4'b1011; #10;
        {num1, num2, cry_in, bor_in} = 4'b1101; #10;
        {num1, num2, cry_in, bor_in} = 4'b1111; #10;

        $finish;
    end

endmodule
