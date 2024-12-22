`timescale 1ns/1ns

module rippleCarryAdderTB;

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
        if (expected === sum) begin
            $display("TestCase#%0d: success", test_case_num);
            success_count = success_count + 1;
        end else begin
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

rippleCarryAdder adder (
    .a(x),
    .b(y),
    .sum(sum),
    .cin(1'b0),
    .cout(carry_out),
    .overflow(overflow_flag)
);

initial begin
    clk = 0;  
    forever begin
        #10 clk = ~clk;  
    end
end

initial begin
    // Test Case 1: Overflow of positive numbers
    x = 2147483647; y = 1; #1
    check_adder_result(-2147483648, 1); // Expected: Overflow

    // Test Case 2: Overflow of negative numbers
    x = -2147483648; y = -1; #1
    check_adder_result(2147483647, 2); // Expected: Overflow

    // Test Case 3: Addition of a positive and a negative number
    x = 100; y = -50; #1
    check_adder_result(50, 3); // Expected: 50

    // Test Case 4: Addition of two positive numbers
    x = 200; y = 150; #1
    check_adder_result(350, 4); // Expected: 350

    // Test Case 5: Addition of two negative numbers
    x = -100; y = -200; #1
    check_adder_result(-300, 5); // Expected: -300

    // Test Case 6: Additional random test case 1
    x = 50; y = 75; #1
    check_adder_result(125, 6); // Expected: 125

    // Test Case 7: Additional random test case 2
    x = -50; y = 50; #1
    check_adder_result(0, 7); // Expected: 0

    // Test Case 8: Additional random test case 3
    x = -100; y = 100; #1
    check_adder_result(0, 8); // Expected: 0

    reportResults();

end

endmodule 
