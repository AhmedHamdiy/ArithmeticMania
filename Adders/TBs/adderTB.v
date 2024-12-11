`timescale 1ns/1ns

module adderTB;

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

simpleAdder adder (
    .x(x),
    .y(y),
    .sum(sum),
    .carry(carry_out),
    .overflow(overflow_flag)
);

initial begin
    clk = 0;  
    forever begin
        #10 clk = ~clk;  
    end
end



initial begin

    // You need minmial delay between the inputs and checking the output in combinational logic but not instantaneous check
    // x = 0; y = 0; #1 //TestCase 1
    // check_adder_result(0, 1);


    reportResults();

end



    
endmodule 