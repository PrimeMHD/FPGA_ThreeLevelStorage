module DIV(
        input signed [31:0] dividend,
        input signed [31:0] divisor,
        input start,
        input clock,
        input reset,
        output reg over,
        output reg busy,
        output [31:0] q,
        output reg [31:0] r);
        
    reg [5:0] count; 
    reg [31:0] reg_q; 
    reg [31:0] reg_r; 
    reg [31:0] reg_b; 
    reg r_sign; 
    
    wire [32:0] sub_add = r_sign?({reg_r,q[31]} + {1'b0,reg_b}):({reg_r,q[31]} - {1'b0,reg_b}); 

    assign q = reg_q;     
    
    always @ (posedge clock or posedge reset)
        if (reset) begin
            count    <= 0; 
            busy    <= 0;
            over    <= 0;
        end
        else begin
            if (start) begin
                reg_r    <= 0; 
                r_sign    <= 0; 
                if(dividend<0)    
                    reg_q <= -dividend;
                else             
                    reg_q <= dividend;
                if(divisor<0)     
                    reg_b <= -divisor; 
                else             
                    reg_b <= divisor; 
                count    <= 0; 
                busy    <= 1; 
            end 
            else if(busy) begin
                if(count<=31) begin 
                    reg_r    <= sub_add[31:0]; 
                    r_sign    <= sub_add[32]; 
                    reg_q    <= {reg_q[30:0],~sub_add[32]};
                    count    <= count + 1; 
                end
                else begin
                    if(dividend[31]^divisor[31])
                        reg_q<=-reg_q;
                    if(!dividend[31])
                        r<=r_sign? reg_r + reg_b : reg_r;
                    else
                        r<=-(r_sign? reg_r + reg_b : reg_r);
                    busy <= 0;
                    over <= 1;
                end
            end            
        end
endmodule