		`timescale 1ns / 1ps

module lab4_2(// INPUTS
              input wire      mode,
              input wire[2:0] opCode,
              input wire[3:0] value,
              input clk,
              input reset,
              // OUTPUTS
              output reg[9:0] result,
              output reg cacheFull,
              output reg invalidOp,
              output reg overflow);
				  
	
	reg [2:0] opcode_array[0:31];
	reg [3:0] value_array[0:31];
	
	integer i;
	
	reg [10:0] counter;
	reg [10:0] counter2;
	
	reg [20:0] p0;
	reg [20:0] p1;
	
	reg [10:0] temp_for_p0_p1_change;	
	reg temp_for_bit_change;
	
	reg [6:0] PC;
	reg [6:0] begin_PC;
	
	reg flag;

   initial begin

		for(i=0;i<32;i=i+1) begin
			opcode_array[i] = 0;
			value_array[i] = 0;
		end

		invalidOp = 0;  
		cacheFull = 0;
		overflow = 0;
		counter = 0;	  
		counter2 = 0;	  
		p0 = 0;	  
		p1 = 0;  
		PC = 0;
		flag = 0;
		result = 0;

    end
	 
    always @(posedge clk or posedge reset) begin 
		if(reset) begin
		
			for(i=0;i<32;i=i+1)begin
				opcode_array[i] = 0;
				value_array[i] = 0;
			end

		   invalidOp = 0;  
			cacheFull = 0;
			overflow = 0;
		   counter = 0;	  
		   counter2= 0;	  
		   p0 = 0;	  
		   p1 = 0;  
		   PC = 0;
		   flag = 0;
			
		end else begin
		
			if(mode == 1) begin 
				temp_for_p0_p1_change = p0;
					
			   if(opcode_array[PC] == 0) begin		  
					p0 = p0 + value_array[PC]; 			  
			   end
			  
			   if(opcode_array[PC] == 1) begin
					p0 = p0 + p1 + value_array[PC];				  
			   end
			  
			   if(opcode_array[PC] == 2) begin
					p0 = p0 * p1 + value_array[PC];					
			   end
			  
			   if(opcode_array[PC] == 4) begin 
					counter2 = 0;
					for(i=0;i<10;i=i+1) begin			
						if(p0[i] == 1) counter2 = counter2 + 1; 						
					end			
					p0 = counter2;	  
			   end
			  
			   if(opcode_array[PC] == 5) begin
			  
					for(i=0;i<5;i=i+1) begin
					
						temp_for_bit_change = p0[i];			
						p0[i] = p0[9-i];			
						p0[9-i] = temp_for_bit_change;
						
					end
					
			   end
			  
			   if(opcode_array[PC] == 6) begin					
					begin_PC = value_array[PC];
			   end
			  
			   flag = 0;
			   for(i=10;i<21;i=i+1)begin				  
					if (p0[i] == 1) flag = 1;
					p0[i] = 0;
			   end
	  
				if(flag == 0) begin		
					overflow = 0;	
				end	
				else begin	
					overflow = 1;	
				end
											
				PC = PC + 1;
				if(PC >= counter) begin  
					PC = begin_PC;			  
				end
				
				p1 = temp_for_p0_p1_change; 
				result = p0;
				  
			end else begin 
		  
				if(opCode == 3 || opCode == 7)begin	
					invalidOp = 1;	
				end else begin			
					invalidOp = 0;	
					if(counter > 31) begin		
						cacheFull = 1;		
					end else begin	
						opcode_array[counter] = opCode;	
						value_array[counter] = value;	
						counter = counter + 1;
					end
					
				end

			end
			
		end 		
    end
endmodule
