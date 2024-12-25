module floatingPointAdder (
    input wire clk, rst,
    input wire [31:0] x,
    input wire [31:0] y,
    output reg [31:0] result
  );
  wire sign_x = x[31];
  wire sign_y = y[31];
  wire [7:0] exp_x = x[30:23];
  wire [7:0] exp_y = y[30:23];
  wire [22:0] mant_x = x[22:0];
  wire [22:0] mant_y = y[22:0];

  wire [24:0] full_mant_x = {1'b0, (exp_x == 0) ? 1'b0 : 1'b1, mant_x};
  wire [24:0] full_mant_y = {1'b0, (exp_y == 0) ? 1'b0 : 1'b1, mant_y};

  wire [8:0] exp_diff = (exp_x > exp_y) ? (exp_x - exp_y) : (exp_y - exp_x);
  wire [8:0] larger_exp = (exp_x > exp_y) ? exp_x : exp_y;

  wire [24:0] shifted_mant = (exp_x > exp_y) ? (full_mant_y >> exp_diff) : (full_mant_x >> exp_diff);
  wire [24:0] unshifted_mant = (exp_x > exp_y) ? full_mant_x : full_mant_y;

  wire do_subtract = sign_x ^ sign_y;
  wire [24:0] op_y = do_subtract ? (~shifted_mant + 1) : shifted_mant;

  wire [24:0] sum;
  wire cout, overflow;

  carryLookAheadAdder #(
                        .WIDTH(25)
                      ) mantissa_adder (
                        .a(unshifted_mant),
                        .b(op_y),
                        .cin(1'b0),
                        .sum(sum),
                        .cout(cout),
                        .overflow(overflow)
                      );

  reg [24:0] normalized_sum;
  reg [7:0] final_exp;
  reg final_sign;

  always @(*)
  begin
    if (exp_x == exp_y)
    begin
      final_sign = (mant_x >= mant_y) ? sign_x : sign_y;
      if (mant_x == mant_y && do_subtract)
        final_sign = 1'b0;
    end
    else
    begin
      final_sign = (exp_x > exp_y) ? sign_x : sign_y;
    end

    if (exp_x == 0 && exp_y == 0)
    begin
      normalized_sum = sum;
      final_exp = 0;
      result = {final_sign, 8'h00, normalized_sum[22:0]};
    end
    else
    begin
      casez (sum)
        25'b1????????????????????????:
        begin
          normalized_sum = sum >> 1;
          final_exp = larger_exp + 1;
        end
        25'b01???????????????????????:
        begin
          normalized_sum = sum;
          final_exp = larger_exp;
        end
        default:
        begin
          normalized_sum = sum << 1;
          final_exp = larger_exp - 1;
        end
      endcase

      if ((exp_x == 8'hFF && mant_x != 0) || (exp_y == 8'hFF && mant_y != 0))
        result = 32'h7FC00000;
      else if (exp_x == 8'hFF)
        result = {sign_x, 8'hFF, 23'b0};
      else if (exp_y == 8'hFF)
        result = {sign_y, 8'hFF, 23'b0};
      else if (sum == 0)
        result = 32'b0;
      else if (final_exp == 0)
        result = {final_sign, 8'h00, normalized_sum[22:0]};
      else if (final_exp >= 8'hFF)
        result = {final_sign, 8'hFF, 23'b0};
      else
        result = {final_sign, final_exp, normalized_sum[22:0]};
    end
  end
endmodule
