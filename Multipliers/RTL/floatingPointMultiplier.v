
module floatingPointMultiplier(
  input wire clk,
  input wire rst,
  input wire [31:0] x,
  input wire [31:0] y,
  output wire [31:0] product,
  output wire overflow
);

  reg [31:0] reg_x;
  reg [31:0] reg_y;
  reg [31:0] reg_product;
  reg reg_overflow;
  wire [31:0] product_out;
  wire overflow_out;


  always @(posedge clk) begin
    if (rst) begin
        reg_x <= 32'b0;
        reg_y <= 32'b0;
        reg_product <= 32'b0;
        reg_overflow <= 32'b0;
    end
    else begin
        reg_x <= x;
        reg_y <= y;
        reg_product <= product_out;
        reg_overflow <= overflow_out;
    end
  end

  assign product = reg_product;
  assign overflow = reg_overflow;



reg sign_x, sign_y, sign_product;
reg [7:0] exp_x, exp_y, exp_product;
reg [7:0] temp_exp_x, temp_exp_y, temp_exp_product;
reg [22:0] mantissa_x, mantissa_y, mantissa_product;
reg [23:0] temp_mantissa_x, temp_mantissa_y;
reg [47:0] temp_mantissa_product;
reg [31:0] temp_product;
reg temp_overflow;

always @(*) begin
    if (reg_x == 0 || reg_y == 0) begin
        temp_product = 0;
        temp_overflow = 0;
    end
    else begin
        {sign_x, exp_x, mantissa_x} = reg_x;
        {sign_y, exp_y, mantissa_y} = reg_y;
        temp_mantissa_x = {1'b1, mantissa_x};
        temp_mantissa_y = {1'b1, mantissa_y};
        temp_exp_y = exp_x - 127;
        temp_exp_x = exp_y - 127;
        sign_product = sign_x ^ sign_y;
        temp_exp_product = temp_exp_x + temp_exp_y;
        temp_mantissa_product = temp_mantissa_x * temp_mantissa_y;
        if (temp_mantissa_product[22]) begin
            temp_mantissa_product = temp_mantissa_product + 1;
        end
        if (temp_mantissa_product[47]) begin
            mantissa_product = temp_mantissa_product[46:24];
            exp_product = temp_exp_product + 128;
            temp_product = {sign_product, exp_product, mantissa_product};
        end
        else begin
            mantissa_product = temp_mantissa_product[45:23];
            exp_product = temp_exp_product + 127;
            temp_product = {sign_product, exp_product, mantissa_product};
        end
        if (exp_x[7] == exp_y[7] && exp_x[7] != exp_product[7]) begin
            if (exp_x[7] == 0) begin
                temp_overflow = 0;
            end
            else begin
                temp_overflow = 1;
            end
        end
        else begin
            temp_overflow = 0;
        end
    end
end

assign overflow_out = temp_overflow;
assign product_out = temp_product;
endmodule