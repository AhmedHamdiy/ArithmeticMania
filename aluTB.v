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
    initial begin
        clk = 0;
        forever #1 clk = ~clk; // 2-time unit clock period
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
            if (expected_result === result && expected_overflow === overflow) begin
                $display("TestCase#%0d: success", test_case_num);
                success_count = success_count + 1;
            end else begin
                $display("TestCase#%0d: failed with input x=%0d, y=%0d, op=%0b, Output=%0d, Overflow=%0b", 
                         test_case_num, x, y, op, result, overflow);
                failure_count = failure_count + 1;
            end
        end
    endtask

    // Testbench operation
    initial begin
        // Reset the ALU
        rst = 1;
        #2 rst = 0;

        // Test Case 1: Addition of two positive numbers
        op = 0; x = 10; y = 15;
        #50 check_alu_result(25, 1, 0);

        // Test Case 2: Multiplication of two positive numbers
        op = 1; x = 3; y = 5;
        #50 check_alu_result(15, 2, 0);

        // Test Case 3: Overflow in addition
        op = 0; x = 32'h7FFFFFFF; y = 1;
        #50 check_alu_result(32'h80000000, 3, 1);

        // Test Case 4: Overflow in multiplication
        op = 1; x = 32'h7FFFFFFF; y = 2;
        #50 check_alu_result(32'hFFFFFFFE, 4, 1);

        // Test Case 5: Addition of positive and negative numbers
        op = 0; x = 50; y = -20;
        #50 check_alu_result(30, 5, 0);

        // Test Case 6: Multiplication of a positive and a negative number
        op = 1; x = 8; y = -3;
        #50 check_alu_result(-24, 6, 0);

        // Test Case 7: Multiplication by zero
        op = 1; x = 123; y = 0;
        #50 check_alu_result(0, 7, 0);

        // Test Case 8: Addition of two negative numbers
        op = 0; x = -15; y = -5;
        #50 check_alu_result(-20, 8, 0);

        // Test Case 9: Multiplication of two negative numbers
        op = 1; x = -10; y = -20;
        #50 check_alu_result(200, 9, 0);

        // Test Case 10: Addition of a negative and a positive number
        op = 0; x = -10; y = 20;
        #50 check_alu_result(10, 10, 0);

        // Test Case 11: Multiplication by one
        op = 1; x = 123; y = 1;
        #50 check_alu_result(123, 11, 0);

        // Test Case 12: Addition of zero and a number
        op = 0; x = 0; y = 123;
        #50 check_alu_result(123, 12, 0);

        // Test Case 13: Multiplication by max value
        op = 1; x = 32'h7FFFFFFF; y = 1;
        #50 check_alu_result(32'h7FFFFFFF, 13, 0);

        // Test Case 14: Addition of max value and a number
        op = 0; x = 32'h7FFFFFFF; y = 1;
        #50 check_alu_result(32'h80000000, 14, 1);

        // Finalize and report results
        #2 report_results;
        $finish;
    end

endmodule
