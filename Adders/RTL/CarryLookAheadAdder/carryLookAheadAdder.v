module carryLookAheadAdder #(
    parameter WIDTH = 32
  )(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output             cout,
    output             overflow
  );

  wire [WIDTH-1:0] g; // Generate signals
  wire [WIDTH-1:0] p; // Propagate signals
  wire [WIDTH:0]   c; // Carry signals

  // Generate and propagate signals
  assign g = a & b;
  assign p = a ^ b;

  // Carry computation
  assign c[0] = cin;
  genvar i;
  generate
    for (i = 1; i <= WIDTH; i = i + 1)
    begin : carry_gen
      assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
  endgenerate

  // Sum computation
  assign sum = p ^ c[WIDTH-1:0];

  // Final carry-out
  assign cout = c[WIDTH];

  // Overflow detection
  assign overflow = c[WIDTH] ^ c[WIDTH-1];

endmodule
