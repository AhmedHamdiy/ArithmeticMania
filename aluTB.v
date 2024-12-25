`timescale 1ns / 1ps

module aluTB;

  reg clk, rst, op;
  reg signed [31:0] x, y;
  wire signed [31:0] result;
  wire overflow;

  // Counters for test results
  integer success_count = 0;
  integer failure_count = 0;

  // Instantiate the ALU module
  alu uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .op(op),
        .overflow(overflow),
        .result(result)
      );

  // Clock generation
  initial
  begin
    clk = 0;
    forever
      #1 clk = ~clk; // 2-time unit clock period
  end

  // Task to report results
  task report_results;
    begin
      $display("Success Count: %0d", success_count);
      $display("Failure Count: %0d", failure_count);
    end
  endtask

  // Task to check ALU result
  task check_alu_result;
    input signed [31:0] expected_result;
    input integer test_case_num;
    input expected_overflow;
    begin
      if (expected_result === result && expected_overflow === overflow)
      begin
        $display("TestCase#%0d: success", test_case_num);
        success_count = success_count + 1;
      end
      else
      begin
        $display("TestCase#%0d: failed with input x=%0d, y=%0d, op=%0b, Output=%0d, Overflow=%0b",
                 test_case_num, x, y, op, result, overflow);
        failure_count = failure_count + 1;
      end
    end
  endtask

  // Testbench operation
  initial
  begin
    // Reset the ALU
    rst = 1;
    #2 rst = 0;

    // Test Case 1: Addition of two positive numbers
    op = 0;
    x = 32'b00111111100000000000000000000000; // 1.0
    y = 32'b00111111100000000000000000000000; // 1.0
    #50 check_alu_result(32'b01000000000000000000000000000000, 1, 0);

    // Test Case 2: Multiplication of two positive numbers
    op = 1;
    x = 32'h408aa000;
    y = 32'h408a2000;
    #50 check_alu_result(32'h41959728, 2, 0);

    // Test Case 3: Adding two large numbers causing overflow
    op = 0;
    x = 32'b01111111000000000000000000000000; // Large number
    y = 32'b01111111000000000000000000000000; // Large number
    #50 check_alu_result(32'b01111111100000000000000000000000, 3, 1);

    // Test Case 5: Addition of positive and negative numbers
    op = 0;
    x = 32'b00111111100000000000000000000000; // 1.0
    y = 32'b10111111100000000000000000000000; // -1.0
    #50 check_alu_result(32'b00000000000000000000000000000000, 5, 0);

    // Test Case 6: Multiplication of a positive and a negative number
    op = 1;
    x = 32'hc28aa000;
    y = 32'h418aa000;
    #50 check_alu_result(32'hc49621c8, 6, 0);

    // Test Case 7: Multiplication by zero
    op = 1;
    x = 32'h418aa000;
    y = 32'h00000000;
    #50 check_alu_result(32'h00000000, 7, 0);

    // Test Case 8: Addition of two negative numbers
    op = 0;
    x = 32'b11000001011100000000000000000000; //-15.0
    y = 32'b11000000101000000000000000000000; //-5.0
    #50 check_alu_result(32'b11000001101000000000000000000000, 8, 0); //-20.0

    // Test Case 9: Multiplication of two negative numbers
    op = 1;
    x = 32'hc28aa000;
    y = 32'hc10a2000;
    #50 check_alu_result(32'h44159728, 9, 0);

    // Test Case 10: Addition of a negative and a positive number
    op = 0;
    x = 32'b00111111100000000000000000000000; // 1.0
    y = 32'b10111111100000000000000000000000; // -1.0
    #50 check_alu_result(32'b00000000000000000000000000000000, 10, 0);

    // Test Case 11: Multiplication by one
    op = 1;
    x = 32'h418aa000;
    y = 32'h3f800000;
    #50 check_alu_result(32'h418aa000, 11, 0);

    // Test Case 12: Addition of zero and a number
    op = 0;
    x = 32'b00000000000000000000000000000000; // 0.0
    y = 32'b00111111100000000000000000000000; // 1.0
    #50 check_alu_result(32'b00111111100000000000000000000000, 12, 0);

    // Test Case 14: Addition of infinity and a number
    op = 0;
    x = 32'b01111111100000000000000000000000; // +Infinity
    y = 32'b00111111100000000000000000000000; // 1.0
    #50 check_alu_result(32'b01111111100000000000000000000000, 14, 0);

    // Finalize and report results
    #2 report_results;
  end

endmodule
