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
    input expected_overflow;
    begin
      if (expected === sum && expected_overflow === overflow_flag)
      begin
        $display("TestCase#%0d: success", test_case_num);
        success_count = success_count + 1;
      end
      else
      begin
        $display("TestCase#%0d: failed with input %0d and %0d, Output %0d, Overflow status %0b (expected %0b)",
                 test_case_num, x, y, sum, overflow_flag, expected_overflow);
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
                       .result(sum),
                       .overflow(overflow_flag)
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
    check_adder_result(32'b01000000000000000000000000000000, 1, 0); // 2.0, No overflow

    // Test Case 2: Adding a positive and a negative number
    x = 32'b00111111100000000000000000000000; // 1.0
    y = 32'b10111111100000000000000000000000; // -1.0
    #1;
    check_adder_result(32'b00000000000000000000000000000000, 2, 0); // 0.0, No overflow

    // Test Case 3: Overflow test (adding two large numbers)
    x = 32'b01111111000000000000000000000000; // Large number
    y = 32'b01111111000000000000000000000000; // Large number
    #1;
    check_adder_result(32'b01111111100000000000000000000000, 3, 1); // +Infinity, Overflow

    // Test Case 4: Positive infinity plus a number
    x = 32'b01111111100000000000000000000000; // +Infinity
    y = 32'b00111111100000000000000000000000; // 1.0
    #1;
    check_adder_result(32'b01111111100000000000000000000000, 4, 0); // +Infinity, No overflow

    // Test Case 5: Negative infinity plus a number
    x = 32'b11111111100000000000000000000000; // -Infinity
    y = 32'b10111111100000000000000000000000; // -1.0
    #1;
    check_adder_result(32'b11111111100000000000000000000000, 5, 0); // -Infinity, No overflow

    // Test Case 6: Adding two NaNs
    x = 32'b01111111110000000000000000000000; // NaN (Not a Number)
    y = 32'b01111111110000000000000000000000; // NaN (Not a Number)
    #1;
    check_adder_result(32'b01111111110000000000000000000000, 6, 0); // NaN, No overflow

    // Test Case 7: Overflow test (almost infinity)
    x = 32'b01111111011111111111111111111111; // Largest normal number
    y = 32'b01111111011111111111111111111111; // Largest normal number
    #1;
    check_adder_result(32'b01111111100000000000000000000000, 7, 1); // +Infinity, Overflow

    reportResults();
  end

endmodule
