module simpleMultiplier (
    input wire signed [31:0] x,
    input wire signed [31:0] y,
    output wire signed [63:0] product
);

    assign product = x * y;
    
endmodule