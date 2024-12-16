module rippleCarryAdder(
    input [31:0] a, b,
    input cin,
    output [31:0] sum,
    output cout,
    output overflow
);
    wire [31:0] carry;
    wire [31:0] a_signed, b_signed;

    assign a_signed = a;
    assign b_signed = b;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : RCA
            if (i == 0) begin
                fullAdder FA (
                    .a(a_signed[i]), .b(b_signed[i]), .cin(cin),
                    .sum(sum[i]), .cout(carry[i])
                );
            end else begin
                fullAdder FA (
                    .a(a_signed[i]), .b(b_signed[i]), .cin(carry[i-1]),
                    .sum(sum[i]), .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[31];

    assign overflow = (a_signed[31] & b_signed[31] & ~sum[31]) |
                      (~a_signed[31] & ~b_signed[31] & sum[31]);
endmodule