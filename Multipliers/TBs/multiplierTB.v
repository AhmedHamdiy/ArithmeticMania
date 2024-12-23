module mulitplierTB;

reg signed [31:0] x, y;
wire signed [63:0] product;

integer success_count = 0;
integer failure_count = 0;
integer test_case = 0;



task report_results;
    begin
        $display("Success Count: %0d", success_count);
        $display("Failure Count: %0d", failure_count);
    end
endtask


task check_multiplier_result;
    input signed [63:0] expected;
    input integer test_case_num;
    begin
        if (expected === product) begin
            $display("TestCase#%0d: success", test_case_num);
            success_count = success_count + 1;
        end else begin
            $display("TestCase#%0d: failed with input %0d and %0d, Output %0d", test_case_num, x, y, product);
            failure_count = failure_count + 1;
        end
    end
endtask

simpleMultiplier multiplier (
    .x(x),
    .y(y),
    .product(product)
);


initial begin
    // You need minmial delay between the inputs and checking the output in combinational logic but not instantaneous check
    
          // Test Case 1: Multiplication of a positive and a negative number.
        x = 2; y = -5;
        #2 check_multiplier_result(-1*64'd10, 1);

        // Test Case 2: Multiplication of two positive numbers.
        x = 12; y = 5;
        #2 check_multiplier_result(64'd60, 2);

        // Test Case 3: Multiplication of two negative numbers.
        x = -20; y = -11;
        #2 check_multiplier_result(64'd220, 3);

        // Test Case 4: Multiplication of a negative and a positive number.
        x = -3; y = 21;
        #2 check_multiplier_result(-1*64'd63, 4);

        // Test Case 5: Multiplication by zero.
        x = 100; y = 0;
        #2 check_multiplier_result(64'd0, 5);

        // Test Case 6: Multiplication by one.
        x = 65535; y = 1;
        #2 check_multiplier_result(64'd65535, 6);

        // Test Case 7: Multiplication by max value.
        x = -4; y = -2147483648;
        #2 check_multiplier_result(64'sd8589934592, 7);

        // Test Case 8: Multiplication of max value by max value.
        x = 2147483647; y = -2147483648;
        #2 check_multiplier_result(-1*64'sd4611686016279904256, 8); 

        #2 report_results;
end
endmodule 