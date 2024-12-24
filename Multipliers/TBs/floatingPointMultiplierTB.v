module floatingPointMultiplierTB;

    reg signed [31:0] x, y;
    reg clk, rst, overflow;
    wire signed [31:0] product;

    integer success_count = 0;
    integer failure_count = 0;
    integer test_case = 0;

    // Task to report results
    task report_results;
        begin
            $display("Success Count: %0d", success_count);
            $display("Failure Count: %0d", failure_count);
        end
    endtask

    // Task to check multiplier result
    task check_multiplier_result;
        input signed [31:0] expected;
        input integer test_case_num;
        input expected_overflow;
        begin
          if ((expected === product) && (expected_overflow === overflow)) 				begin
                $display("TestCase#%0d: success", test_case_num);
                success_count = success_count + 1;
            end 
          else 
            begin
                $display("TestCase#%0d: failed with input %0d and %0d, Output %0d, and overflow status %0b", 
                         test_case_num, x, y, product, overflow);
                failure_count = failure_count + 1;
            end
        end
    endtask

    floatingPointMultiplier multiplier (
        .clk(clk),
        .rst(rst),
        .overflow(overflow),
        .x(x),
        .y(y),
        .product(product)
    );

    initial begin
        clk = 0;
        forever #1 clk = ~clk; // 10-time unit clock period
    end

    // Testbench operation
    initial begin
        // reset the multiplier
        rst = 1;
        #2 rst = 0;
        // Test Case 1: Multiplication of a positive and a negative number.
        x = 32'h408a2000; y = 32'hc08a2000;
        #50 check_multiplier_result(32'hc1950d08, 1, 0);

        // Test Case 2: Multiplication of two positive numbers.
        x = 32'h408aa000; y = 32'h408a2000;
        #50 check_multiplier_result(32'h41959728, 2, 0);

        // Test Case 3: Multiplication of two negative numbers.
        x = 32'hc28aa000; y = 32'hc10a2000;
        #50 check_multiplier_result(32'h44159728, 3,0);

        // Test Case 4: Multiplication of a negative and a positive number.
        x = 32'hc28aa000; y = 32'h418aa000;
        #50 check_multiplier_result(32'hc49621c8, 4,0);

        // Test Case 5: Multiplication by zero.
        x = 32'h418aa000; y = 32'h00000000;
        #50 check_multiplier_result(32'h00000000, 5,0);

        // Test Case 6: Multiplication by one.
        x = 32'h418aa000; y = 32'h3f800000;
        #50 check_multiplier_result(32'h418aa000, 6,0);

        // Test Case 7: Multiplication of random values.
        x = 32'hb9807000; y = 32'h418aa000;
        #50 check_multiplier_result(32'hbb8b194c, 7,0);

        // Test Case 8: Multiplication of random values.
        x =  32'h79807000; y = 32'h518aa000;
        #50 check_multiplier_result(32'h0b8b194c, 8,1);

        #2 report_results;
        $finish;
    end
endmodule