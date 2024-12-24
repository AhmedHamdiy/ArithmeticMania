module siquentialMultiplier2 (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [63:0] result,
    output reg         done
);

  reg [63:0] multiplicand;
  reg [31:0] multiplier;
  reg [63:0] accumulator;
  reg [ 5:0] count;
  reg [31:0] counter;
  reg        negative;
  reg        slow_clock;

  always @(posedge slow_clock or posedge rst) begin
    if (rst) begin

      multiplicand <= 0;
      multiplier <= 0;
      accumulator <= 0;
      result <= 0;
      count <= 0;
      done <= 0;
      negative <= 0;
    end else if (start) begin
      // Initialization on start signal
      multiplicand <= {{32{1'b0}}, a[31] ? ~a + 1 : a};  // Convert to magnitude
      multiplier   <= b[31] ? ~b + 1 : b;  // Convert to magnitude
      accumulator  <= 0;
      count        <= 0;
      done         <= 0;
      negative     <= a[31] ^ b[31];  // Determine the sign of the result
    end else if (!done) begin
      if (count < 32) begin
        // Check the least significant bit of the multiplier
        if (multiplier[0]) begin
          accumulator <= accumulator + multiplicand;  // Add partial product
        end
        multiplier <= multiplier >> 1;  // Shift multiplier to the right
        multiplicand <= multiplicand << 1;  // Shift multiplicand to the left
        count <= count + 1;
      end else begin
        // Finalize the result
        result <= negative ? ~accumulator + 1 : accumulator;  // Apply sign
        done   <= 1;
      end
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 0;
      slow_clock <= 1'b0;
    end else begin
      if (counter == 4) begin
        counter <= 0;
        slow_clock <= ~slow_clock;
      end else begin
        counter <= counter + 1;
      end
    end
  end
endmodule
