module mulitplierTB;

reg signed [31:0] x, y;
wire signed [63:0] product;

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

simpleMultiplier multiplier (
    .x(x),
    .y(y),
    .product(product)
);


initial begin
    
    // You need minmial delay between the inputs and checking the output in combinational logic but not instantaneous check
    // x = 0; y = 0;
    // #1 check_adder_result(0, 1);


end



    
endmodule 