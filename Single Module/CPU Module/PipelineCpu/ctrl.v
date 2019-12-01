`include "Defination.vh"

module ctrl (
	input   rst,
	input   stallreq_from_id,
	input   stallreq_from_ex,
	input 	Databus_busy,
	input   Databus_done,
	output reg[5:0]     stall
);


	always @ (*) begin
		if(rst) begin
			stall <= 6'b111111;	
		end
		else if(~Databus_done)begin
			stall<=6'b111111;
		end 
		else if(stallreq_from_ex == 1'b1) begin
			stall <= 6'b001111;
		end 
		else if(stallreq_from_id == 1'b1) begin
			stall <= 6'b000111;
		end 
		else begin
			stall <= 6'b000000;
		end
	end
endmodule