module two_complement_converter (
    input      [31:0] num,           // 32-bit input number
    input             convertOrNot,  // Flag to decide whether to convert or not
    output reg [31:0] result         // 32-bit output
);

  always @(*) begin
    if (convertOrNot) begin
      result = ~num + 1;  // Two's complement if convertOrNot is set
    end else begin
      result = num;  // Return the number as it is if not converting
    end
  end

endmodule



module treeMultiplier (
    input  [31:0] in_A,
    in_B,
    output [63:0] out_Z
);
  wire [63:0] p[31:0];
  wire [31:0] A, B;
  wire [63:0] Z;

  two_complement_converter comp_1 (
      in_A,
      in_A[31],
      A
  );
  two_complement_converter comp_2 (
      in_B,
      in_B[31],
      B
  );


  genvar i;
  generate
    for (i = 0; i < 32; i++) begin
      assign p[i] = ({{(32 - i) {1'b0}}, A} << i) & {64{B[i]}};
    end
  endgenerate

  // Stage 1
  genvar k1;
  wire [63:0] result1[15:0];

  generate
    for (k1 = 0; k1 < 16; k1++) begin
      assign result1[k1] = p[k1*2] + p[k1*2+1];
    end
  endgenerate

  // Stage 2
  genvar k2;
  wire [63:0] result2[7:0];

  generate
    for (k2 = 0; k2 < 8; k2++) begin
      assign result2[k2] = result1[k2*2] + result1[k2*2+1];
    end
  endgenerate

  // Stage 3
  genvar k3;
  wire [63:0] result3[3:0];

  generate
    for (k3 = 0; k3 < 4; k3++) begin
      assign result3[k3] = result2[k3*2] + result2[k3*2+1];
    end
  endgenerate

  // Stage 4
  genvar k4;
  wire [63:0] result4[1:0];

  generate
    for (k4 = 0; k4 < 2; k4++) begin
      assign result4[k4] = result3[k4*2] + result3[k4*2+1];
    end
  endgenerate

  assign Z = result4[0] + result4[1];

  assign out_Z = (in_A[31] ^ in_B[31]) ? (~Z + 1) : Z;

endmodule
