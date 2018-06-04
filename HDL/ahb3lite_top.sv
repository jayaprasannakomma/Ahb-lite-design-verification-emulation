
////////////////////////////////////////////////////////////////////////////////////////////////
// ahb3lite_top.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer, Sai Tawale, Raveena Khandelwal
// 
// Date : 12 March 2018
// .......................................
// Description:
// AHBlite top is the top module consisting of all master, slaves and mux and decoders
/////////////////////////////////////////////////////////////////////////////////////////////////
 
 `include "ahb3lite_package.sv"
 `include "ahb3lite_master.sv"
 `include "ahb3lite_slave.sv"
 `include "ahb3lite_mux.sv"
 `include "ahb3lite_decoder.sv"

module ahb3lite_top(
                input   logic   [31:0]  i_HADDR,
                input   logic   [31:0]  i_HWDATA, 
                input   logic           i_HWRITE,
                input   logic   [1:0]   i_HTRANS,
                input   logic   [2:0]   i_HSIZE,                   
                input   logic   [2:0]   i_HBURST,
                
                input   logic           HCLK, 
                input   logic           HRESETn,

                output  logic   [31:0]  i_HRDATA
);

                
                wire                    HREADYw;
                wire                    HRESPw;
                wire                    HREADYOUTw;
                wire            [31:0]  HRDATAw;
                                
                wire logic      [31:0]  HADDRw;
                wire logic      [31:0]  HWDATAw;
                wire logic              HWRITEw;
                wire logic      [2:0]   HSIZEw;
                wire logic      [2:0]   HBURSTw;
                wire logic      [1:0]   HTRANSw;
                wire logic      [1:0]   HSELw;

                wire logic      [31:0]  HRDATA_1w,   HRDATA_2w,   HRDATA_3w,   HRDATA_4w;
                wire logic              HRESP_1w,   HRESP_2w,    HRESP_3w ,   HRESP_4w;
                wire logic              HREADYOUT_1w,HREADYOUT_2w,HREADYOUT_3w,HREADYOUT_4w;


ahb3lite_master master(
                        .HCLK(HCLK), 
                        .HRESETn(HRESETn), 
                        .HADDR(HADDRw), 
                        .HWDATA(HWDATAw), 
                        .HWRITE(HWRITEw), 
                        .HTRANS(HTRANSw),
                        .HSIZE(HSIZEw),
                        .HBURST(HBURSTw) , 
                        .HREADY(HREADYw), 
                        .HRDATA(HRDATAw), 
                        .HREADYOUT(HREADYOUTw),
                        .HRESP(HRESPw),

                        .i_HADDR(i_HADDR),
                        .i_HBURST(i_HBURST),
                        .i_HSIZE(i_HSIZE),
                        .i_HTRANS(i_HTRANS),
                        .i_HWDATA(i_HWDATA),
                        .i_HWRITE(i_HWRITE),
                        .i_HRDATA(i_HRDATA)
);


ahb3lite_slave slave(
                        .HCLK(HCLK), 
                        .HRESETn(HRESETn), 
                        .HADDR(HADDRw), 
                        .HWDATA(HWDATAw), 
                        .HWRITE(HWRITEw), 
                        .HTRANS(HTRANSw),
                        .HSIZE(HSIZEw),
                        .HBURST(HBURSTw) , 
                        .HREADY(HREADYw), 
                        .HRDATA(HRDATA_1w), 
                        .HSEL(HSELw),
                        .HRESP(HRESP_1w),
                        .HREADYOUT(HREADYOUT_1w)
);

ahb3lite_decoder    decoder(
                        .HADDR(HADDRw),
                        .HSEL(HSELw)

);

ahb3lite_mux    mux (
                        .HADDR(HADDRw),
                        .HRDATA(HRDATAw),
                        .HRDATA_1(HRDATA_1w),
                        .HRDATA_2(HRDATA_2w),
                        .HRDATA_3(HRDATA_3w),
                        .HRDATA_4(HRDATA_4w),
                        .HRESP(HRESPw),
                        .HRESP_1(HRESP_1w),
                        .HRESP_2(HRESP_2w),
                        .HRESP_3(HRESP_3w),
                        .HRESP_4(HRESP_4w),
                        .HREADY(HREADYw),
                        .HREADYOUT_1(HREADYOUT_1w),
                        .HREADYOUT_2(HREADYOUT_2w),
                        .HREADYOUT_3(HREADYOUT_3w),
                        .HREADYOUT_4(HREADYOUT_4w)
);



endmodule
