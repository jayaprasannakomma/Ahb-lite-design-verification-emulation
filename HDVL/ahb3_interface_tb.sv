//////////////////////////////////////////////////////////////////////////////
// ahb3_interface_tb.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// interface is having a signals of the DUT for AHBlite, used for the resuability of the environment design 
// verification
// Date : 11 March 2018
// .......................................
// Description:
// It is having all the signals to use in the design verification and these signals are the same as the input to th DUT. 
// After randomization in the genarator, i_HDATA and other signals are updated in Interface
//////////////////////////////////////////////////////////////////////////////

interface intf(input logic HCLK, HRESETn);

// Interface signals used in DUT and also in the design verification environment
    logic [31:0] i_HADDR; 
    logic [31:0] i_HWDATA;
    logic i_HWRITE;
    logic [1:0] i_HTRANS;
    logic [2:0] i_HSIZE;
    logic [2:0] i_HBURST;
    
    logic [31:0] i_HRDATA;

//     /////////////////////clocking block////////////////////////////
// /////////////////////// driver clocking block ////////////////////
 clocking drv_cb @(posedge HCLK);
 	//default input #1 output #1;
	
 	output i_HADDR;
 	output i_HWDATA;
 	output i_HWRITE;
 	output i_HTRANS;
      output i_HSIZE;
 	output i_HBURST;
 endclocking

// //////////////////////// monitor clocking block ////////////////////

 clocking mon_cb @(posedge HCLK);
      // default input #1 output #1;
       input i_HRDATA;
 endclocking 
  		
// //////////////////////endclocking//////////////////////////////


// /////////////////// modport ////////////////////////////
      modport drv (clocking drv_cb, input HCLK, HRESETn); // driver
      modport mon (clocking mon_cb, input HCLK, HRESETn); // monitor

endinterface

