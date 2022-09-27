`timescale 1ns / 1ps
module lab4ROM (input [3:0] romAddr, output reg[4:0] romOutput);

reg [4:0] data[15:0];

initial begin
    
    data[0] = 5'b00000;
    data[1] = 5'b00001;
    data[2] = 5'b00110;
    data[3] = 5'b00111;
    data[4] = 5'b01011;
    data[5] = 5'b01100;
    data[6] = 5'b01101;
    data[7] = 5'b01110;
    data[8] = 5'b11101;
    data[9] = 5'b11110;
    data[10] = 5'b11111;
    data[11] = 5'b10000;
    data[12] = 5'b10111;
    data[13] = 5'b11000;
    data[14] = 5'b11001;
    data[15] = 5'b11010;
    
end

always @(romAddr)
romOutput = data[romAddr];

endmodule


module lab4RAM (
	input ramMode, //0:read, 1:write
	input [3:0] ramAddr, 
	input [4:0] ramInput,
	input  ramOp, //0:polynomial, 1:derivative
	input [1:0] ramArg,  //00:+1, 01:+2, 10:-1, 11:-2
	input CLK, 
	output reg [8:0] ramOutput);

/*Write your code here*/

reg[8:0] register[0:15];
integer j;
integer temp_arguman;

reg[8:0] formul_katsayilari[4:0];

reg[8:0] formule_koyulacak_sayi;


initial begin
		for(j = 0; j < 16; j = j+ 1) begin
			register[j] = 9'b000_000_000;
		end
		ramOutput = 9'b000_000_000;
	end

always @(ramMode)begin

	if(ramMode == 	0)begin

	/*Not senkron burası*/
	
	ramOutput = register[ramAddr];

	end
	
end



always @(posedge CLK)begin

    if(ramMode == 1)begin

		for(j=0; j<5; j = j+ 1)begin
		
			if(ramInput[j] == 1)begin
		
			formul_katsayilari[j] = -1;
			
			end
			
			else begin	
				formul_katsayilari[j] = 1;
				end
		end
		
	end	
		
		
	    if(ramArg == 0)begin
				
			formule_koyulacak_sayi = +1;
			
	    end

		if(ramArg == 1)begin
				
				formule_koyulacak_sayi = +2;
			
		end

		if(ramArg == 2)begin
				
				formule_koyulacak_sayi = -1;
			
		end

		if(ramArg == 3)begin
				
				formule_koyulacak_sayi = -2;
			
		end		

		if(ramOp == 0)begin /* Burada yaptıgımız normal eval*/
		
		register[ramAddr] =  
		
		formule_koyulacak_sayi*formule_koyulacak_sayi*formule_koyulacak_sayi*formule_koyulacak_sayi*formul_katsayilari[4]+
		formule_koyulacak_sayi*formule_koyulacak_sayi*formule_koyulacak_sayi*formul_katsayilari[3]+
		formule_koyulacak_sayi*formule_koyulacak_sayi*formul_katsayilari[2]+
		formule_koyulacak_sayi*formul_katsayilari[1]+
		formul_katsayilari[0];
		
		
		end
		
		
		
		else if(ramOp == 1)begin
		
		register[ramAddr] =  
		
		formule_koyulacak_sayi*formule_koyulacak_sayi*formule_koyulacak_sayi*4*formul_katsayilari[4]+
		formule_koyulacak_sayi*formule_koyulacak_sayi*3*formul_katsayilari[3]+
		formule_koyulacak_sayi*2*formul_katsayilari[2]+
		formul_katsayilari[1];
		
		end
		
		if (register[ramAddr][8] == 1)begin
			
			register[ramAddr]= register[ramAddr]*(-1);
			
			register[ramAddr][8] = 1;
			
		end

end		


endmodule
