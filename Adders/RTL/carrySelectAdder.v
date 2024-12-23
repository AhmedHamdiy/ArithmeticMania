module carrySelectAdder (
    input  [31:0] a, b,
    input         cin,
    output [31:0] sum,
    output        cout,
    output        overflow
  );

  wire [31:0] sum0, sum1;
  wire [7:0]  c_out0, c_out1;
  wire [8:0]  carry;

  assign carry[0] = cin;

  rippleCarryAdder #(
                     .WIDTH(4)
                   ) rca_first (
                     .a(a[3:0]),
                     .b(b[3:0]),
                     .cin(cin),
                     .sum(sum[3:0]),
                     .cout(carry[1]),
                     .overflow()
                   );

  genvar i;
  generate
    for (i = 1; i < 8; i = i + 1)
    begin : CSA_BLOCKS
      rippleCarryAdder #(
                         .WIDTH(4)
                       ) rca0 (
                         .a(a[i*4 +: 4]),
                         .b(b[i*4 +: 4]),
                         .cin(1'b0),
                         .sum(sum0[i*4 +: 4]),
                         .cout(c_out0[i]),
                         .overflow()
                       );

      rippleCarryAdder #(
                         .WIDTH(4)
                       ) rca1 (
                         .a(a[i*4 +: 4]),
                         .b(b[i*4 +: 4]),
                         .cin(1'b1),
                         .sum(sum1[i*4 +: 4]),
                         .cout(c_out1[i]),
                         .overflow()
                       );

      assign sum[i*4 +: 4] = (carry[i]) ? sum1[i*4 +: 4] : sum0[i*4 +: 4];
      assign carry[i+1] = (carry[i]) ? c_out1[i] : c_out0[i];
    end
  endgenerate

  assign cout = carry[8];
  assign overflow = (a[31] & b[31] & ~sum[31]) | (~a[31] & ~b[31] & sum[31]);
endmodule
