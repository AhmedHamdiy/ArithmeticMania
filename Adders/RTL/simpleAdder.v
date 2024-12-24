module simpleAdder (
    input wire signed [31:0] x,
    input wire signed [31:0] y,
    output wire signed [31:0] sum,
    output wire carry,
    output wire overflow
);

    assign {carry, sum} = x + y;
    assign overflow = (x[31] & y[31] & ~sum[31]) | (~x[31] & ~y[31] & sum[31]);

endmodule

