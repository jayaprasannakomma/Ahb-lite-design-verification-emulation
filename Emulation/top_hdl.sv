// Author- Raveena Khandelwal
// Top level HDL - Intantiates DUT, IF, BFM and generates clock and resets. Runs on the emulator. 
// The pragma below specifies that this module is an xrtl module 
/// include all the RTL files 
module top_hdl;
//pragma attribute top_hdl partition_module_xrtl


bit clk,reset;

//instantiate AHB interface
AHBInterface AHB_BFM(.HCLK(clk),.HRESETn(reset));
//Instantiate DUT
top DUT (top);
	
// tbx clkgen
initial begin
	clk = 0;
	forever begin
	  #10 clk = ~clk;
	end
end

// tbx clkgen
initial begin
	reset = 1;
end

endmodule:top_hdl

