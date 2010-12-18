`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:52:25 12/14/2010
// Design Name:   I2C_SRO
// Module Name:   C:/Verilog projects/DataFlowAnalyzer/i2c_ack_test.v
// Project Name:  DataFlowAnalyzer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: I2C_SRO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module i2c_ack_test;

	// Inputs
	reg SCL;

	// Outputs
	wire [0:7] EXTMEM;
	wire READ;

	// Bidirs
	wire SDA;
	reg SDA_low = 0;
	pullup(SDA);
	// Instantiate the Unit Under Test (UUT)
	I2C_SRO uut (
		.SDA(SDA), 
		.SCL(SCL), 
		.EXTMEM(EXTMEM), 
		.READ(READ)
	);

	initial begin
		// Initialize Inputs
		SCL = 1;

		// Wait 100 ns for global reset to finish
		#50;
		#2; SDA_low=1; #3;//start
								// clock cycle is #10
		#2; SDA_low=1; #8;//dev_sig start
		#2; SDA_low=0; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=0; #8;
		#2; SDA_low=0; #8;
		#2; SDA_low=0; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8; //dev_sig end
			 SDA_low=0;
			 #10;
			 
		#2; SDA_low=1; #8; //dest start
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=0; #8;
		#2; SDA_low=0; #8; //dest end (mask to 0x0000001)
			 #10;
			 
		#2; SDA_low=1; #8; //switch_to start
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8; //switch_to end (switch to 0x0000001)
			 SDA_low=0;
			 #10;
			 
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8; //end of 1st byte=00000000
			 SDA_low=0;
			 #10;
			 
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8; //end of 2st byte=00000000
			 SDA_low=0;
			 #10;
			 
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8; //end of 3rd byte=00000000
			 SDA_low=0;
			 #10;
			 
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=1; #8;
		#2; SDA_low=0; #8;
		#2; SDA_low=0; #8;
		#2; SDA_low=0; #8; //end of 4th byte=00000111
		#10;
			 
			 
	end
assign SDA = (SDA_low) ? 1'b0: 1'bz;
always #5 SCL = ~SCL;  

endmodule

