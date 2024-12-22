module rippleCarryAdder #(
    parameter WIDTH = 32
) (
    input  [WIDTH-1:0] a, b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output             overflow
);
    wire [WIDTH-1:0] carry;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : RCA
            if (i == 0) begin
                fullAdder FA (
                    .a(a[i]), .b(b[i]), .cin(cin),
                    .sum(sum[i]), .cout(carry[i])
                );
            end else begin
                fullAdder FA (
                    .a(a[i]), .b(b[i]), .cin(carry[i-1]),
                    .sum(sum[i]), .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[WIDTH-1];

    assign overflow = (a[WIDTH-1] & b[WIDTH-1] & ~sum[WIDTH-1]) |
                      (~a[WIDTH-1] & ~b[WIDTH-1] & sum[WIDTH-1]);
endmodule
