module carryBypassAdder(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout,
    output overflow
  );

  parameter BLOCK_SIZE = 4;
  localparam NUM_BLOCKS = 32 / BLOCK_SIZE;

  wire [NUM_BLOCKS:0] carry;
  wire [NUM_BLOCKS-1:0] propagate;
  assign carry[0] = cin;

  genvar i;
  generate
    for (i = 0; i < NUM_BLOCKS; i = i + 1)
    begin : BLOCKS
      wire [BLOCK_SIZE-1:0] block_sum;
      wire block_cout;
      wire block_propagate;

      rippleCarryAdder #(.WIDTH(BLOCK_SIZE)) rca (
                         .a(a[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE]),
                         .b(b[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE]),
                         .cin(carry[i]),
                         .sum(sum[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE]),
                         .cout(block_cout),
                         .overflow()
                       );

      assign block_propagate = &(
               a[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE] ^ b[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE]
             );

      assign carry[i+1] = block_propagate ? carry[i] : block_cout;

    end
  endgenerate

  assign cout = carry[NUM_BLOCKS];
  assign overflow = (a[31] & b[31] & ~sum[31]) | (~a[31] & ~b[31] & sum[31]);

endmodule
