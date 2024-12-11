module mulitplierTB;

reg signed [31:0] x, y;
reg signed [63:0] product;

integer success_count = 0;
integer failure_count = 0;
integer test_case = 0;



task reportResults;
    begin
        $display("Success Count: %0d", success_count);
        $display("Failure Count: %0d", failure_count);
    end
endtask


task check_adder_result;
    input signed [63:0] expected;
    input integer test_case_num;
    begin
        if (expected === product) begin
            $display("TestCase#%0d: success", test_case_num);
            success_count = success_count + 1;
        end else begin
            $display("TestCase#%0d: failed with input %0d and %0d, Output %0d, and overflow status 0", test_case_num, x, y, product);
            failure_count = failure_count + 1;
        end
    end
endtask

boothMultiplier multiplier (
    .x(x),
    .y(y),
    .product(product)
);


initial begin
    // You need minmial delay between the inputs and checking the output in combinational logic but not instantaneous check
    
    // Test Case 1 : Multiplication of a positive and a negative number.
    x = 2; y = -1;
    #1 check_adder_result(-2, 1);
    // Test Case 2 : Multiplication of two positive numbers.
    x = 2; y = 1;
    #1 check_adder_result(2, 2);
    // Test Case 3 : Multiplication of two negative numbers.
    x = -2; y = -1;
    #1 check_adder_result(2, 3);
    // Test Case 4 : Multiplication of a negative and a positive number.
    x = -2; y = 1;
    #1 check_adder_result(-2, 4);
    // Test Case 5 : Multiplication by zero.
    x = 2; y = 0;
    #1 check_adder_result(0, 5);
    // Test Case 6 : Multiplication by one.
    x = 2; y = 1;
    #1 check_adder_result(2, 6);
    // Test Case 7 : Multiplication by max value.
    x = -2; y = 65535;
    #1 check_adder_result(−131070, 7);
    // Test Case 8 : Multiplication to get max value.
    x = -65535; y = 65535;
    #1 check_adder_result(-4294836225, 8);
end
endmodule 