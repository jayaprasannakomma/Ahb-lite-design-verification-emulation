//////////////////////////////////////////////////////////////////////////////
// ahb3_top.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// top is a module which connects DUT and Testbench
// Date : 13 March 2018
// .......................................
// Description:
// top module is having all classes included and it connects DUT with the test bench, generates clk
// and contains handle of the interface 
/////////////////////////////////////////////////////////////////////////////////

// all classes of the environment are included in the top module using 'include

`include "ahb3_packet.sv"
`include "ahb3_generator.sv"
`include "ahb3_interface_tb.sv"
`include "ahb3_driver.sv"
`include "ahb3_monitor.sv"
`include "ahb3_scoreboard.sv"
`include "ahb3_env.sv"
`include "ahb3_test.sv"
`include "ahb3lite_top.sv"

// module top 
// the top of the verification environment
module ahb3_top;

logic clk,reset;

// generates clk 
// time period 10 ns
always
begin
	forever begin
		#5 clk = ~clk;	
	end
end  	

// initialize clk and reset
initial begin
    clk = 1;
	reset = 0;
	#10
	reset = 1;
    #3000;
    $stop; // to stop simulation at 3000 ns
end

intf i(clk,reset);   // interface handle to connect clock and reset

test t(i);           // test class handle, passing interface handle i

// hanle of the DUT top
// connecting DUT signals with signals present on the interface
ahb3lite_top dut(
    .HCLK(i.HCLK),
    .HRESETn(i.HRESETn),
    .i_HADDR(i.i_HADDR),
    .i_HWDATA(i.i_HWDATA),
    .i_HWRITE(i.i_HWRITE),
    .i_HTRANS(i.i_HTRANS),
    .i_HSIZE(i.i_HSIZE),
    .i_HBURST(i.i_HBURST),
    .i_HRDATA(i.i_HRDATA)
);

// to dump a file 
// needed for waveform and sometimes for gtkwave
initial begin
 	$dumpfile("dump.vcd");
 	$dumpvars;
end

endmodule
