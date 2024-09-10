module LFSR (

input  wire       Clock, Reset , Enable , OUT_Enable,
input  wire [7:0] Seed,
output reg        OUT, Valid 
);

reg[7:0] LFSR;         // declare 8-bit register

integer N ;
parameter [7:0] Taps = 8'b10101010;     // taps defines the sequence 

wire Bits0_6, Feedback ;

assign Bits0_6  = ~| LFSR[6:0];
assign Feedback = Bits0_6 ^ LFSR [7] ;


always@(posedge Clock or negedge Reset)
begin
	if (!Reset) 
		begin
			LFSR <= Seed;
			OUT <= 1'b0;
			Valid <= 1'b0;
		end
	else if(Enable)
		begin	 
			LFSR[0] <= Feedback; 	 
			for (N=7; N>=1; N=N-1) 
			if (Taps[N] == 1) 
				LFSR[N] <= LFSR[N-1] ^ Feedback; 
			else 
				LFSR[N] <= LFSR[N-1]; 

		end
	else if(OUT_Enable)
	    begin
			{LFSR[6:0],OUT} <= LFSR ;
			Valid <= 1'b1;
			
		end
end
		   



endmodule