module boothMultiplier(
    input signed [31:0] x,
    input signed [31:0] y,
    output reg signed [63:0] product
);
    reg signed [31:0] a, m;    
    reg signed [31:0] q;       
    reg signed [63:0] p;       
    reg q_1;                   
    integer count;             
    
    always @(*) begin
        m = x;
        q = y;
        a = 32'b0;
        q_1 = 1'b0;
        count = 32;
        
        repeat (count) begin
            case ({q[0], q_1})
                2'b10: a = a - m; 
                2'b01: a = a + m; 
                default: ;        
            endcase
            
            p = {a, q, q_1};
            p = p >>> 1;
            
            a = p[63:32];
            q = p[31:0];
            q_1 = p[0];
        end
        
        product = {a, q};
    end
endmodule
