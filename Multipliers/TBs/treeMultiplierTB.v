module treeMultiplierTB;
  reg signed [31:0] A, B;
  wire signed [63:0] z;
  
  // Instantiate the multiplier
  treeMultiplier uut (.in_A(A), .in_B(B), .out_Z(z));
  
  initial begin
    // Test Cases
    $monitor("A = %d, B = %d, Expected = %d, Result = %d", A, B, $signed(A) * $signed(B), z);
    
    // Test case 1: A is negative, B is positive
    A = -31'd25; B = 31'd4; #10;  // Expected = -100
    
    // Test case 2: A is negative, B is zero
    A = 32'd15; B = 32'd3; #10;  // Expected = 0
    
    // Test case 3: A is negative, B is negative
    A = -32'd13; B = -32'd7; #10;  // Expected = -91
    
    // Test case 4: A is negative, B is large positive
    A = -32'd1234; B = 32'd5678; #10;  // Expected = -7006652
    
    // Test case 5: A is negative, B is small positive
    A = -32'd1; B = 32'd1; #10;  // Expected = -1

    $stop;
  end
endmodule
