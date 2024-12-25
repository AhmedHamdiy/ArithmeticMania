module alu (
    input wire clk, rst,
    input wire signed [31:0] x, y,
    input wire op,
    output wire overflow,
    output wire signed [31:0] result
);
    reg [31:0] reg_x;
    reg [31:0] reg_y;
    reg [31:0] reg_result;
    reg reg_overflow;
    reg [31:0] multiplier_result;
    reg multiplier_overflow;
    reg [31:0] adder_result;
    reg adder_overflow;
    

    floatingPointMultiplier multiplier(
        .clk(clk),
        .rst(rst),
        .x(reg_x),
        .y(reg_y),
        .product(multiplier_result),
        .overflow(multiplier_overflow)
    );
    floatingPointAdder adder(
        .clk(clk),
        .rst(rst),
        .x(reg_x),
        .y(reg_y),
        .result(adder_result),
        .overflow(adder_overflow)
    );



always @(posedge clk) begin
    if (rst) begin
        reg_x <= 32'b0;
        reg_y <= 32'b0;
        reg_result <= 31'b0;
        reg_overflow <= 1'b0;
    end
    else begin
        reg_x<= x;
        reg_y<= y;
        if (op == 1'b0) begin // add
            reg_result <= adder_result;
            reg_overflow <= adder_overflow;
        end
        else begin // multiply
            reg_result <= multiplier_result;
            reg_overflow <= multiplier_overflow;
        end
        result<= reg_result;
        overflow<= reg_overflow;
    end

   
end
endmodule
