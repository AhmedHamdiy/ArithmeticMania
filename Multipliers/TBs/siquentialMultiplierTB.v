`timescale 1ns / 1ps

module siquentialMultiplierTB;

  // Inputs
  reg signed  [31:0] a;
  reg signed  [31:0] b;

  // Outputs
  wire signed [63:0] result;

  // Instantiate the multiplier module
  siquentialMultiplier uut (
      .a(a),
      .b(b),
      .result(result)
  );

  // Test variables
  integer i;
  reg signed [31:0] test_a[0:9];
  reg signed [31:0] test_b[0:9];
  reg signed [63:0] expected_result;

  initial begin
    // Initialize test cases
    test_a[0] = 32'd15;
    test_b[0] = 32'd10;  // Positive * Positive
    test_a[1] = -32'd7;
    test_b[1] = 32'd14;  // Negative * Positive
    test_a[2] = 32'd15;
    test_b[2] = -32'd10;  // Positive * Negative
    test_a[3] = -32'd15;
    test_b[3] = -32'd10;  // Negative * Negative
    test_a[4] = 32'd0;
    test_b[4] = 32'd10;  // Zero * Positive
    test_a[5] = 32'd10;
    test_b[5] = 32'd0;  // Positive * Zero
    test_a[6] = 32'd0;
    test_b[6] = 32'd0;  // Zero * Zero
    test_a[7] = 32'd2147483647;
    test_b[7] = 32'd2;  // Max Positive * 2
    test_a[8] = -32'd2147483648;
    test_b[8] = 32'd1;  // Min Negative * 1
    test_a[9] = -32'd1234;
    test_b[9] = 32'd5678;  // Random Negative * Positive

    for (i = 0; i < 10; i = i + 1) begin
      a = test_a[i];
      b = test_b[i];
      #10;
      expected_result = $signed(a) * $signed(b);

      if (result === expected_result) begin
        $display("Test %0d PASSED: a = %0d, b = %0d, result = %0d", i, a, b, result);
      end else begin
        $display("Test %0d FAILED: a = %0d, b = %0d, expected = %0d, got = %0d", i, a, b,
                 expected_result, result);
      end
    end

    $finish;
  end
endmodule
