module ahb3lite_decoder
(
    input logic [31:0] HADDR,
    output logic [1:0] HSEL
);

assign HSEL = HADDR[31:30];
endmodule