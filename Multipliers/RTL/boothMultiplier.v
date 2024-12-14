module boothMultiplier  (
    input [31:0] x,
    input [31:0] y,
    output [63:0] product
);
    integer i;
    reg [64:0] product_temp;
    reg [31:0] x_temp;
    always @(*) begin
        product_temp = 65'b0;
        product_temp[32:1] = y;
        x_temp = x;
        for (i = 0; i < 32; i = i + 1) begin
            if (product_temp[1:0] == 2'b01) begin
                product_temp[64:33] = product_temp[64:33] + x_temp;
            end
            else if (product_temp[1:0] == 2'b10) begin
                product_temp[64:33] = product_temp[64:33] - x_temp;
            end
            product_temp = {product_temp[64], product_temp[64:1]};
        end
    end
    assign product = product_temp[64:1];
endmodule