`timescale 1ns / 1ps

module siquentialMultiplierTB2;

  // Testbench signals
  reg clk;
  reg rst;
  reg start;
  reg signed [31:0] a;
  reg signed [31:0] b;
  wire signed [63:0] result;
  wire done;

  // Instantiate the module under test
  signed_multiplier uut (
      .clk(clk),
      .rst(rst),
      .start(start),
      .a(a),
      .b(b),
      .result(result),
      .done(done)
  );

  // Clock generation (50 MHz, 20 ns period)
  initial clk = 0;
  always #10 clk = ~clk;

  // Test logic
  initial begin
    // Test vectors
    integer i;
    reg signed [31:0] test_a[0:7];
    reg signed [31:0] test_b[0:7];
    reg signed [63:0] expected_result[0:7];

    // Initialize test vectors
    test_a[0] = 32'h00000001;
    test_b[0] = 32'h00000001;
    expected_result[0] = 64'h0000000000000001;
    test_a[1] = 32'hFFFFFFFF;
    test_b[1] = 32'hFFFFFFFF;
    expected_result[1] = 64'h0000000000000001;
    test_a[2] = 32'h80000000;
    test_b[2] = 32'h00000002;
    expected_result[2] = 64'hFFFFFFFF00000000;
    test_a[3] = 32'h00000010;
    test_b[3] = 32'h00000010;
    expected_result[3] = 64'h0000000000000100;
    test_a[4] = 32'h7FFFFFFF;
    test_b[4] = 32'h00000002;
    expected_result[4] = 64'h00000000FFFFFFFE;
    test_a[5] = 32'hFFFFFFFE;
    test_b[5] = 32'hFFFFFFFE;
    expected_result[5] = 64'h0000000000000004;
    test_a[6] = 32'h0000FFFF;
    test_b[6] = 32'h0000FFFF;
    expected_result[6] = 64'h00000000FFFE0001;
    test_a[7] = 32'hFFFFFFFF;
    test_b[7] = 32'h00000001;
    expected_result[7] = 64'hFFFFFFFFFFFFFFFF;

    // Apply reset
    rst = 1;
    start = 0;
    a = 0;
    b = 0;
    #50;  // Wait for reset

    rst = 0;

    // Iterate through test cases
    for (i = 0; i < 8; i = i + 1) begin
      // Apply inputs
      a = test_a[i];
      b = test_b[i];
      start = 1;
      #2000;  // Pulse start signal
      start = 0;

      // Wait for computation to complete
      wait (done);

      // Check the result
      if (result !== expected_result[i]) begin
        $display("Test %0d FAILED: a = %0d, b = %0d, expected = %0d, got = %0d", i, a, b,
                 expected_result[i], result);
      end else begin
        $display("Test %0d PASSED: a = %0d, b = %0d, result = %0d", i, a, b, result);
      end

      #20;  // Wait before next test case
    end

    $stop;  // End simulation
  end

endmodule
