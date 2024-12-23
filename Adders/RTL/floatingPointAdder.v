module floatingPointAdder (
    input wire clk, rst,
    input wire signed [31:0] x, y,
    output wire signed [31:0] result,
    output wire overflow
);
    // add the implementation here
    assign result = x + y;
    assign overflow = (x[31] == y[31] && result[31] != x[31]) ? 1 : 0;
endmodule