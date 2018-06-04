
////////////////////////////////////////////////////////////////////////////////////////////////
// ahb3lite_pkg.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer, Sai Tawale, Raveena Khandelwal
// 
// Date : 12 March 2018
// .......................................
// Description:
// AHBlite package to containing all parameters, enum and logic
/////////////////////////////////////////////////////////////////////////////////////////////////   

package ahb3lite_pkg;
    
   
    typedef enum logic [1:0] { single_okay, single_error  } state_single;

    typedef enum logic [1:0]{ BURST_CHECK , LOOP  } state_burst;
  
    typedef enum logic [1:0] { OKAY_state , ERROR_state } state_resp;

    parameter HTRANS_IDLE    = 2'b00;
    parameter HTRANS_BUSY    = 2'b01; 
    parameter HTRANS_NONSEQ  = 2'b10;
    parameter HTRANS_SEQ     = 2'b11;

    parameter SINGLE   = 3'b000;
    parameter INCR     = 3'b001;
    parameter WRAP4    = 3'b010;
    parameter INCR4    = 3'b011;
    parameter WRAP8    = 3'b100;
    parameter INCR8    = 3'b101;
    parameter WRAP16   = 3'b110;
    parameter INCR16   = 3'b111;
    

    parameter ERROR = 1'b1;
    parameter OKAY = 1'b0;

    parameter WORD = 3'b010;



endpackage 
