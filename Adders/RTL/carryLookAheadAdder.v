module carryLookAheadAdder (
    input  [31:0] a,
    input  [31:0] b,
    input         cin,
    output [31:0] sum,
    output        cout,
    output        overflow
  );

  wire [31:0] g;
  wire [31:0] p;
  wire [31:0] c;

  assign g = a & b;
  assign p = a ^ b;

  assign c[0] = cin;
  genvar i;
  generate
    for (i = 1; i < 32; i = i + 1)
    begin : carry_gen
      assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
  endgenerate

  assign sum = p ^ c;
  assign cout = g[31] | (p[31] & c[31]);
  assign overflow = c[31] ^ cout;

endmodule
