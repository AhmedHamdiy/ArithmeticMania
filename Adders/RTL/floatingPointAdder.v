module floatingPointAdder (
    input signed [31:0] x,   // Replaced A with x
    input signed [31:0] y,   // Replaced B with y
    output signed [31:0] result
  );

  reg sign1, sign2;
  reg [7:0] exponent1, exponent2;
  reg signed [22:0] fraction1, fraction2;
  reg signed [31:0] fraction1_32, fraction2_32, fraction1_32neg, fraction2_32neg;
  wire signed [31:0] result_fraction_add, result_fraction_sub12, result_fraction_sub21;
  reg signed [22:0] result_fraction;
  reg signed [7:0] result_exponent;
  reg result_sign;
  reg [21:0] temp_fraction;
  integer i;
  wire cout, cin;
  assign cin = 0;
  reg signed [7:0] exponent_diff;

  // Module instantiations for the carry bypass adder
  carryLookAheadAdder fraction_add(
                        .a(fraction1_32),
                        .b(fraction2_32),
                        .cin(cin),
                        .sum(result_fraction_add),
                        .cout(cout),
                        .overflow()
                      );
  carryLookAheadAdder fraction_sub12(
                        .a(fraction1_32),
                        .b(fraction2_32neg),
                        .cin(cin),
                        .sum(result_fraction_sub12),
                        .cout(cout),
                        .overflow()
                      );
  carryLookAheadAdder fraction_sub21(
                        .a(fraction1_32neg),
                        .b(fraction2_32),
                        .cin(cin),
                        .sum(result_fraction_sub21),
                        .cout(cout),
                        .overflow()
                      );

  always @*
  begin
    sign1 = x[31];   // Changed A to x
    sign2 = y[31];   // Changed B to y
    exponent1 = x[30:23];   // Changed A to x
    exponent2 = y[30:23];   // Changed B to y
    fraction1 = x[22:0];   // Changed A to x
    fraction2 = y[22:0];   // Changed B to y
    exponent_diff = exponent1 - exponent2;

    // Align exponents and adjust fractions accordingly
    if (exponent_diff < 0)
    begin
      exponent_diff = -exponent_diff;
      fraction1 = $signed(fraction1) >>> exponent_diff;
      result_exponent = exponent2;
      result_sign = sign2;
    end
    else
    begin
      fraction2 = $signed(fraction2) >>> exponent_diff;
      result_exponent = exponent1;
      result_sign = sign1;
    end

    // Convert fractions to 32-bit signed numbers with implicit leading 1
    fraction1_32 = { {9{fraction1[22]}}, fraction1 };
    fraction2_32 = { {9{fraction2[22]}}, fraction2 };

    // Add or subtract fractions based on signs
    if (sign1 == sign2)
    begin
      result_fraction = result_fraction_add[22:0];
    end
    else
    begin
      if (fraction1 > fraction2)
      begin
        fraction2_32neg = -fraction2_32;
        result_fraction = result_fraction_sub12[22:0];
        result_sign = sign1;
      end
      else
      begin
        fraction1_32neg = -fraction1_32;
        result_fraction = result_fraction_sub21[22:0];
        result_sign = sign2;
      end
    end

    // Normalize the result fraction
    temp_fraction = result_fraction[21:0];
    if (result_fraction == 23'b0)
    begin
      temp_fraction = 22'b0;
    end
    else
    begin
      for(i = 0; i < 22; i = i + 1)
      begin
        if(temp_fraction[21]==0)
        begin
          temp_fraction = temp_fraction << 1;
          result_exponent = result_exponent - 1;
        end
      end
    end
    result_fraction[21:0] = temp_fraction;
  end

  // Construct the result
  assign result = {result_sign, result_exponent, result_fraction};

endmodule
