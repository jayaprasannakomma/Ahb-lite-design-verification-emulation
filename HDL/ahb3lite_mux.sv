
////////////////////////////////////////////////////////////////////////////////////////////////
// ahb3lite_mux.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer, Sai Tawale, Raveena Khandelwal
// 
// Date : 12 March 2018
// .......................................
// Description:
// AHBlite mux selects the slave from the first two bits ofs address and passes the data to the master
/////////////////////////////////////////////////////////////////////////////////////////////////

module ahb3lite_mux(
    input logic [31:0] HADDR,
    
    input logic [31:0] HRDATA_1, HRDATA_2 ,HRDATA_3,HRDATA_4,
    input logic HRESP_1 , HRESP_2, HRESP_3 , HRESP_4,
    input logic HREADYOUT_1, HREADYOUT_2, HREADYOUT_3, HREADYOUT_4,


    output logic [31:0] HRDATA,
    output logic HRESP,
    output logic HREADY
);

localparam ERROR = 1'b1;
localparam OKAY = 1'b0;

always_comb
begin
    case(HADDR[31:30])

    2'b00: begin
        HRDATA = HRDATA_1;
        HRESP  = HRESP_1;
        HREADY = HREADYOUT_1;
    end
    
    2'b01: begin
        HRDATA = HRDATA_2;
        HRESP  = HRESP_2;
        HREADY = HREADYOUT_2;
    end

    2'b10: begin
        HRDATA = HRDATA_3;
        HRESP  = HRESP_3;
        HREADY = HREADYOUT_3;
    end

    2'b11: begin
        HRDATA = HRDATA_4;
        HRESP  = HRESP_4;
        HREADY = HREADYOUT_4;
    end    
    
    default: begin
        HRDATA = HRDATA_1;
        HRESP  = HRESP_1;
        HREADY = HREADYOUT_1;
    end

    endcase
end

always_comb
begin
    
end
endmodule