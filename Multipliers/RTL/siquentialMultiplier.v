module siquentialMultiplier (
    input  [31:0] a,
    input  [31:0] b,
    output [63:0] result
);

  integer i;
  reg [31:0] op1;
  reg [63:0] op2;
  reg [63:0] acc;
  wire signA, signB;

  assign signA = a[31];
  assign signB = b[31];

  always @(*) begin
    // Initialize regs
    op1 = (signA) ? ~a + 1 : a;
    op2 = {{32{1'b0}}, (signB) ? ~b + 1 : b};

    acc = 0;

    for (i = 0; i < 32; i = i + 1) begin
      if (op1[i] == 1'b1) begin
        acc = acc + op2;
      end
      op2 = op2 << 1;
    end
  end

  assign result = (signA ^ signB) ? ~acc[63:0] + 1 : acc[63:0];

endmodule
