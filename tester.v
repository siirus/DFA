`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:43:30 12/14/2010
// Design Name:   analyzer
// Module Name:   C:/Verilog projects/DataFlowAnalyzer/tester.v
// Project Name:  DataFlowAnalyzer
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: analyzer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tester;

	// Inputs
	reg [0:31] DATA;
	reg START;
	reg CLK;
	reg SCL;

	// Outputs
	wire RESULT;

	// Bidirs
	wire SDA;
	reg SDA_low = 0;
	pullup(SDA);

	// Instantiate the Unit Under Test (UUT)
	analyzer uut (
		.DATA(DATA), 
		.START(START), 
		.CLK(CLK), 
		.RESULT(RESULT), 
		.SDA(SDA), 
		.SCL(SCL)
	);

		initial begin
		// Initialize Inputs
		DATA = 0;
		START = 0;
		CLK = 1;
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
		#2; SDA_low=1; #8; //switch_to end (switch to 0x0000000)
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
		#2; SDA_low=0; #3; //end of 4th byte=00000111
			 SDA_low=0;
			 #10;
			 
		#1; SDA_low=0;#9;
		START=1;
		#1;
		START=0;
		DATA=32'b00000000000000000000000000000110;

	end
always #5 SCL=~SCL;
always #5 CLK=~CLK;
assign SDA = (SDA_low) ? 1'b0: 1'bz;
endmodule

