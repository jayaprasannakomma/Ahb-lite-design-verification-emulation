//////////////////////////////////////////////////////////////////////////////
// ahb3_packet.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// packet class is used to declare the signals which are used in DUT and in the verification environment
// Date : 11 March 2018
// .......................................
// Description:
// It is having all the signals to use in the design verification and these signals are the same as the input to th DUT. 
// Inputs are declared as rand to be randomized and contraint is also used
//////////////////////////////////////////////////////////////////////////////////////////

class packet;

    // input signals taken to drive values at output
    
    randc logic [31:0] i_HADDR;     // cyclic randomization, input address
    rand logic [31:0] i_HWDATA;     // rand (not cyclic), input data to write
    rand logic i_HWRITE;            // write operation
    rand logic [1:0] i_HTRANS;      // type of transsaction, IDLE, BUSY, SEQ, NONSEQ
    logic [2:0] i_HSIZE;            // Size of the BURST
    rand logic [2:0] i_HBURST;      // Mode of the BURST
                             
    logic [31:0] i_HRDATA;          // output data to read         


 // Constraint 
    constraint address {
        i_HADDR[31:12] == 'b0;  // putting constraint on 31:12 bits to be 0     
        i_HSIZE == 3'b010;      // 32 bit
         };
endclass
