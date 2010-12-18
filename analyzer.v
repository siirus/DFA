`timescale 1ns / 1ps
module analyzer(DATA, START, CLK, RESULT, SDA, SCL);
	 inout  wire SDA;
	 input  wire SCL;
	 input  wire [0:31] DATA;
    input  wire START;
    input  wire CLK;
	 output wire RESULT;
	 wire [0:7] EXTMEM;
	 wire [0:15] tick;
	 reg result;
	 reg obtained;
	 reg [0:2] cntr;
	 reg [0:47] i2c_buff;
	 reg [0:31] mask    [0:MEM_SIZE];
	 reg [0:31] pattern [0:MEM_SIZE];
	 reg [0:319] data;
	 reg [0:7] mem_ptr [0:1];
	 parameter offset   = 16'b000000000000000100;
	 parameter MEM_SIZE = 10;
	 event ready;
	 
I2C_SRO i2c(.SDA(SDA), .SCL(SCL), .EXTMEM(EXTMEM), .READ(READ));	 
Counter tick_cntr(.clk(CLK), .start(START), .cnt(tick));
initial
	begin
		mem_ptr[0] = 8'b0;// mask memory pointer
		mem_ptr[1] = 8'b0;// pattern memory pointer
		cntr       = 3'b000;
		obtained   = 0;
		result     = 0;
		mask[0]    = 32'b00000000000000000000000000000011;
		pattern[0] = 32'b00000000000000000000000000000110;
	end
	
always @(posedge READ)
begin
	i2c_buff[40:47] = EXTMEM;
	cntr = cntr + 1'b1;
	if(cntr ^ 3'b110)
		i2c_buff = i2c_buff << 8;
	else
		begin
			-> ready;
			cntr = 0;
		end
end

always @(ready)
	obtained = ~obtained;
	
always @(posedge CLK)
	begin
	data = data >> 32;
	data[0:31] = DATA;
		if(obtained)
			begin
			if(i2c_buff[7])//mask
				begin
					mask[i2c_buff[0:6]]  = i2c_buff[16:47];
					mem_ptr[0]           = i2c_buff[8:15];
				end
			else//pattern
				begin
					pattern[i2c_buff[0:6]] = i2c_buff[16:47];
					mem_ptr[1]             = i2c_buff[8:15];
				end
			->ready;
			end
		result = 0;
		//$display("expr= %b | pat&mask= %b | pat&data= %b | patt= %b | mask= %b | data= %b", ( (DATA & pattern[mem_ptr[1]] ) == ( pattern[mem_ptr[1]] & mask[mem_ptr[0]] )), ( pattern[mem_ptr[1]] & mask[mem_ptr[0]] ), (DATA & pattern[mem_ptr[1]] ), pattern[mem_ptr[1]], mask[mem_ptr[0]], DATA );
		if((tick == offset) && ( (data[0:31] & mask[mem_ptr[0]] ) == ( pattern[mem_ptr[1]] & mask[mem_ptr[0]] )))
				result = 1;
	end 
	
assign RESULT  = result;
endmodule
