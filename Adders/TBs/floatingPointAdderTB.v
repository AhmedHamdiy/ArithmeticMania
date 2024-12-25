`timescale 1ns/1ns

module floatingPointAdderTB;

  parameter WIDTH = 32;
  reg clk;

  reg signed [31:0] x, y;
  wire signed [31:0] sum;
  wire carry_out;
  wire overflow_flag;


  integer success_count = 0;
  integer failure_count = 0;

  task check_adder_result;
    input signed [31:0] expected;
    input integer test_case_num;
    begin
      if (expected === sum)
      begin
        $display("TestCase#%0d: success", test_case_num);
        success_count = success_count + 1;
      end
      else
      begin
        $display("TestCase#%0d: failed with input %0d and %0d, Output %0d, and overflow status %0b", test_case_num, x, y, sum, overflow_flag);
        failure_count = failure_count + 1;
      end
    end
  endtask

  task reportResults;
    begin
      $display("Success Count: %0d", success_count);
      $display("Failure Count: %0d", failure_count);
    end
  endtask

  floatingPointAdder adder (
                       .x(x),
                       .y(y),
                       .result(sum)
                     );

  initial
  begin
    clk = 0;
    forever
    begin
      #10 clk = ~clk;
    end
  end

  initial
  begin
    // Test Case 1: Simple addition of two positive numbers
    x = 32'b00111111100000000000000000000000; // 1.0
    y = 32'b00111111100000000000000000000000; // 1.0
    #1;
    check_adder_result(32'b01000000000000000000000000000000, 1); //2.0

    // Test Case 2: Adding a positive and a negative number
    x = 32'b00111111100000000000000000000000; // 1.0
    y = 32'b10111111100000000000000000000000; // -1.0
    #1;
    check_adder_result(32'b00000000000000000000000000000000, 2); // Expected result: 0.0

    // Test Case 3: Adding two numbers with different exponents
    x = 32'b00111111000000000000000000000000; // 0.5
    y = 32'b00111111100000000000000000000000; // 1.0
    #1;
    check_adder_result(32'b00111111110000000000000000000000, 3); // Expected result: 1.5

    // Test Case 4: Adding two numbers with different exponents and signs
    x = 32'b00111111000000000000000000000000; // 0.5
    y = 32'b10111111100000000000000000000000; // -1.0
    #1;
    check_adder_result(32'b10111111000000000000000000000000, 4); // Expected result: -0.5

    // Test Case 5: Zero plus a number
    x = 32'b00000000000000000000000000000000; // 0.0
    y = 32'b00111111100000000000000000000000; // 1.0
    #1;
    check_adder_result(32'b00111111100000000000000000000000, 5); // Expected result: 1.0

    // Test Case 6: Positive infinity plus a number
    x = 32'b01111111100000000000000000000000; // +Infinity
    y = 32'b00111111100000000000000000000000; // 1.0
    #1;
    check_adder_result(32'b01111111100000000000000000000000, 6); // Expected result: +Infinity

    // Test Case 7: Negative infinity plus a number
    x = 32'b11111111100000000000000000000000; // -Infinity
    y = 32'b10111111100000000000000000000000; // -1.0
    #1;
    check_adder_result(32'b11111111100000000000000000000000, 7); // Expected result: -Infinity

    // Test Case 8: Adding two NaNs
    x = 32'b01111111110000000000000000000000; // NaN (Not a Number)
    y = 32'b01111111110000000000000000000000; // NaN (Not a Number)
    #1;
    check_adder_result(32'b01111111110000000000000000000000, 8); // Expected result: NaN

    // Test Case 9: Very small numbers (subnormal numbers)
    x = 32'b00000000000000000000000000000001; // Smallest positive subnormal number
    y = 32'b00000000000000000000000000000001; // Smallest positive subnormal number
    #1;
    check_adder_result(32'b00000000000000000000000000000010, 9); // Expected result: subnormal result

    // Test Case 10: Overflow test (adding two large numbers)
    x = 32'b01111111000000000000000000000000; // Large number
    y = 32'b01111111000000000000000000000000; // Large number
    #1;
    check_adder_result(32'b01111111100000000000000000000000, 10); // Expected result: +Infinity

    // Test Case 11: Subnormal + Normal number
    x = 32'b00000000000000000000000000000001; // Smallest subnormal
    y = 32'b00111111000000000000000000000000; // 0.5
    #1;
    check_adder_result(32'b00111111000000000000000000000000, 11); // Expected: 0.5

    // Test Case 12: Different subnormal numbers
    x = 32'b00000000000000000000000000000010; // 2nd smallest subnormal
    y = 32'b00000000000000000000000000000001; // Smallest subnormal
    #1;
    check_adder_result(32'b00000000000000000000000000000011, 12); // Expected: sum of subnormals

    // Test Case 13: Near-zero normal numbers
    x = 32'b00000000100000000000000000000000; // Very small normal
    y = 32'b10000000100000000000000000000000; // Very small negative normal
    #1;
    check_adder_result(32'b00000000000000000000000000000000, 13); // Expected: zero

    // Test Case 14: Rounding test
    x = 32'b00111111100000000000000000000001; // Just above 1.0
    y = 32'b00111111100000000000000000000001; // Just above 1.0
    #1;
    check_adder_result(32'b01000000000000000000000000000001, 14); // Expected: Just above 2.0

    // Test Case 15: Almost infinity
    x = 32'b01111111011111111111111111111111; // Largest normal number
    y = 32'b01111111011111111111111111111111; // Largest normal number
    #1
     check_adder_result(32'b01111111100000000000000000000000, 15);

    reportResults();

  end

endmodule
