module oneCycleBoothMultiplier ( 
    input wire clk,  
    input wire rst,
    input [31:0] x,
    input [31:0] y,
    output [63:0] product,
);
  reg [31:0] reg_x;  
  reg [31:0] reg_y;  
  wire [63:0] product_temp;  
  reg [31:0] counter;  
  reg write_clock;
  reg [63:0] reg_product;
  assign product = reg_product;
  
  boothMultiplier mult (
    .x(reg_x),
    .y(reg_y),
    .product(product_temp)
    );
    
  always @(posedge write_clock or posedge rst) begin
    if (rst) begin
      reg_product <= 64'b0;
      reg_x <= 32'b0;
      reg_y <= 32'b0;
    end else begin
      reg_product <= product_temp;
      reg_x <= x;
      reg_y <= y;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 0;
      write_clock <= 1'b0;
    end else begin
      if (counter == 4) begin
        counter <= 0;
        write_clock <= ~write_clock; 
      end else begin
        counter <= counter+1;
      end
    end
  end
endmodule

