/////////////////////////////////////////////////////////////////////


module test_master();

logic [31:0]    i_HADDR;
logic [31:0]    i_HWDATA;
logic           i_HWRITE;
logic [1:0]     i_HTRANS;
logic [2:0]     i_HSIZE;
logic [2:0]     i_HBURST;
bit             HCLK;
logic           HRESETn;
//logic           HREADY;

top top_ahb(.HCLK(HCLK), .HRESETn(HRESETn), .i_HADDR(i_HADDR), .i_HWDATA(i_HWDATA), .i_HWRITE(i_HWRITE),
     .i_HTRANS(i_HTRANS),.i_HSIZE(i_HSIZE),.i_HBURST(i_HBURST));// , .HREADY(HREADY));

    localparam HTRANS_IDLE    = 2'b00;
    localparam HTRANS_BUSY    = 2'b01; 
    localparam HTRANS_NONSEQ  = 2'b10;
    localparam HTRANS_SEQ     = 2'b11;

    localparam SINGLE   = 3'b000;
    localparam INCR     = 3'b001;
    localparam WRAP4    = 3'b010;
    localparam INCR4    = 3'b011;
    localparam WRAP8    = 3'b100;
    localparam INCR8    = 3'b101;
    localparam WRAP16   = 3'b110;
    localparam INCR16   = 3'b111;
    
     localparam WRITE = 1'b1;
    localparam READ = 1'b0;

    localparam ERROR = 1'b1;
    localparam OKAY = 1'b0;

    localparam WORD = 3'b010;

initial
begin
    forever
        #5 HCLK = ~HCLK;
end 

always
begin
    
    @(posedge HCLK)
    begin
        HRESETn = 0;
    end
    
        

    @(posedge HCLK)
        HRESETn     =   1;
        i_HTRANS    <= HTRANS_IDLE;
        i_HSIZE     <= WORD;
        //i_HADDR     <= 8'h24;
        i_HWDATA    <= 32'h1010_1010;
        i_HBURST    <= SINGLE;
        i_HWRITE    <= WRITE;
    
    @(posedge HCLK);
        i_HTRANS    <= HTRANS_IDLE;
        i_HSIZE     <= WORD;
        i_HADDR     <= 8'h24;
        i_HWDATA    <= 32'h1010_1010;
        i_HBURST    <= SINGLE;
        i_HWRITE    <= WRITE;

    @(posedge HCLK)
        i_HADDR     <= 8'h28;
        // i_HWDATA    <= 32'h1010_1010;
        i_HWDATA    <= 32'h2020_2020;
        i_HWRITE    <= WRITE;

    // @(posedge HCLK);
    //      //i_HWDATA    <= 32'h2020_2020;

    @(posedge HCLK)
        i_HADDR     <= 8'h24;
        i_HWRITE    <= READ;
    
    @(posedge HCLK)
        i_HADDR     <= 8'h28;
        i_HWRITE    <= READ;

     @(posedge HCLK);

    @(posedge HCLK)
        i_HADDR     <= 8'h32;
        i_HWRITE    <= WRITE;
        i_HTRANS    <= HTRANS_NONSEQ;
        i_HWDATA    <= 32'h3030_3030; 
        i_HBURST    <= INCR;

    repeat(10)
    begin    
        @(posedge HCLK)
            i_HTRANS <= HTRANS_SEQ;
            i_HWDATA <= i_HWDATA + 16;
    end

    @(posedge HCLK)
        i_HADDR     <= 8'h32;
        i_HWRITE    <= READ;
        i_HTRANS    <= HTRANS_NONSEQ;
        //i_HWDATA    <= 32'h3030_3030; 
        i_HBURST    <= INCR;

    repeat(10)
    begin    
        @(posedge HCLK)
            i_HTRANS <= HTRANS_SEQ;
            i_HWDATA <= i_HWDATA + 16;
    end

    @(posedge HCLK);

    @(posedge HCLK)
        i_HADDR     <= 12'h0ff;
        i_HWRITE    <= WRITE;
        i_HTRANS    <= HTRANS_NONSEQ;
        i_HWDATA    <= 32'h1111_1212; 
        i_HBURST    <= WRAP4;

    repeat(10)
    begin    
        @(posedge HCLK)
            i_HTRANS <= HTRANS_SEQ;
            i_HWDATA <= i_HWDATA + 16;
    end

 #10;
$stop;

end

endmodule