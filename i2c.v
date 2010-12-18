`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// This module receives bytes from I2c bus, then sends it to EXTMEM
// I2C START indicates beginning of session
//	First byte contains 7 bit of I2C device's address on bus and 1 bit of R/W
// Second byte has 2 parts:
// 	[msb;lsb-1] - address of memory cell in EXTMEM,
//		[lsb]       - type of EXTMEM (mask or pattern)
// Third byte is address of cell that should be used as mask/pattern
// Fourth to seventh bytes contain "payload"
// Everything after this should be but is not yet ignored
// I2C STOP signal indicates end of session
// For each parameter (mask or pattern) separate session of following type should be established
// {START} - {DEV_SIG,R/W} - {SWITCH_TO} - {ADDR,DEST} - {BYTE} - {BYTE} - {BYTE} - {BYTE} - {STOP} 
//////////////////////////////////////////////////////////////////////////////////
module I2C_SRO(SDA, SCL, EXTMEM, READ);
	inout wire SDA;
   input wire SCL;
	output wire READ;
   output wire [0:7] EXTMEM;
	parameter dev_sig = 7'b0101110;
	reg [0:7] h_buf, outmem = 0;
	reg [0:3] bitcount = 0;
	reg [0:2] msgcount = 0;
	reg [0:2] state = 3'b100;
	reg ack_flag = 1'b0;
	reg SDA_low = 0;
	reg read = 0;
	event handle_it, get_it, NEXT;
	event ACK;

always @(negedge SCL)
	if(ack_flag)
		begin
			SDA_low = 1;
			->ACK;
		end
	else
		SDA_low = 0;
		
always @(ACK)
	ack_flag = ~ack_flag;
	
always@(posedge SCL)
begin
	read=0;
	if(state ^ 3'b100)// NOT STOP
		begin
			if(bitcount ^ 4'b1000)
				begin
					bitcount <= bitcount +1;
					h_buf[bitcount] = (SDA)? 1'b1 : 1'b0;
					if(bitcount == 4'b111) 
						begin
							msgcount = msgcount + 1'b1;
							->handle_it;
							->ACK;
						end
				end
			else
				bitcount <= 4'b0; 
		end
end
	
always @(handle_it)
begin
if(state == 3'b010)          //STATE==START
	begin
		if(h_buf[0:6]^dev_sig) 
			begin
			->NEXT;
			->NEXT;             //to STOP;
			end
		else	
			->NEXT;             //to MATCH;
	end
else if(state==3'b001)       //STATE==MATCH
		begin
			outmem=h_buf;
			->get_it;
		end
		
if(msgcount == 3'b111)
	->NEXT;
	
end
	
always @(SDA)
	if(SCL)
		if(~SDA) 
			begin
			msgcount <= 0;
			case(state)        //to START
				3'b100: ->NEXT; //from STOP
				3'b001: begin   //from MATCH
							->NEXT;
							->NEXT;
						  end
			endcase
			end
		else 
			case(state)        //to STOP
				3'b001: ->NEXT; //from MATCH
				3'b010: begin   //from START
						 ->NEXT;
						 ->NEXT;
						 end
			endcase
			
always @(NEXT)
if(state ^ 3'b001)
	state = state >> 1;
else
	state = 3'b100;

always @(get_it)
	read = 1;

assign READ   = read;	
assign EXTMEM = outmem;
assign SDA = (SDA_low) ? 1'b0 : 1'bz ;
endmodule
