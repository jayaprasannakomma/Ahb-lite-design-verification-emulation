
////////////////////////////////////////////////////////////////////////////////////////////////
// ahb3lite_master.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer, Sai Tawale, Raveena Khandelwal
// AHBlite master send the address and control signals to the slaves and decoder
// Date : 12 March 2018
// .......................................
// Description:
// AHBlite master takes the data from user aand pass it on to slave selected in variious modes 
/////////////////////////////////////////////////////////////////////////////////////////////////

import ahb3lite_pkg::* ;

module ahb3lite_master(

            // AHB protocol inputs and ouptuts
                input logic HRESETn,
                input logic HREADY,
                input logic HRESP,
                input logic HREADYOUT,
                input logic [31:0] HRDATA,
                input bit HCLK,
                
                output logic [31:0] HADDR,
                output logic [31:0] HWDATA,
                output logic HWRITE,
                output logic [2:0] HSIZE,
                output logic [2:0] HBURST,
                output logic [1:0] HTRANS,
                output logic [1:0] HSEL,

                // USER inputs and outputs

                input   logic   [31:0]  i_HADDR,
                input   logic   [31:0]  i_HWDATA, 
                input   logic           i_HWRITE,
                input   logic   [1:0]   i_HTRANS,
                input   logic   [2:0]   i_HSIZE,                   
                input   logic   [2:0]   i_HBURST,

                output  logic   [31:0]  i_HRDATA
    );
    

    logic [31:0] temp_addr;
    logic flag, data_flag;

    // States in single and INCR, WRAPx, INCRx modes
    state_single next_state, current_state;

    state_burst next_state_2, current_state_2;

    
    logic [31:0] ff_HADDR;

    int counter, temp_count;
    
    // assign the AHB inputs and outputs to AHB inputs outputs
    assign  HSIZE   = i_HSIZE;
    assign  HTRANS  = (!HRESETn)? HTRANS_IDLE : i_HTRANS;
    assign  HBURST  = i_HBURST;
    assign  HWRITE  = i_HWRITE;
    assign  i_HRDATA  = HRDATA;
    
    assign HSEL = i_HADDR[31:30];

    
    assign HADDR =  ( HRESP == OKAY && i_HBURST == SINGLE && HRESETn ) | 
                    ( HRESP == OKAY && i_HTRANS == HTRANS_NONSEQ ) ?i_HADDR : 
                    ( HRESP == OKAY && i_HTRANS == HTRANS_SEQ  ) ? temp_addr : HADDR ;
    
   
    assign HWDATA =     (HRESP == OKAY && i_HBURST == SINGLE && HRESETn) |
                        (HRESP == OKAY && i_HTRANS == HTRANS_NONSEQ  &&  i_HWRITE == 1 ) |
                        (HRESP == OKAY && i_HTRANS == HTRANS_SEQ  &&  i_HWRITE == 1 ) ? i_HWDATA :HWDATA;

    //----------------------------------------------------------------------------------------------------------------

    always_ff@(posedge HCLK)
    begin
        if (HREADY == 1) begin
            ff_HADDR <= i_HADDR;
        end

        else if (HREADY == 0)
        begin
            ff_HADDR <= ff_HADDR;
        end
    end

    // Sequential block for the Single Burst mode.
     always_ff@(posedge  HCLK )
    begin
        if(!HRESETn)
            begin
                current_state <= single_okay;    
            end
        else
            current_state <= next_state;
    end
    // Combinational block for the Single burst mode 
    always_comb
    begin
        
        if(i_HBURST == SINGLE)
        begin
            case(current_state)
            
            single_okay: begin
            data_flag = 0;
                if( HREADY == 1 && i_HWRITE == 1 && HRESP == OKAY )
                begin
                    next_state = single_okay; 
                    data_flag = 1;   
                end
                
                else if (HREADY == 0 || HRESP == ERROR)
                begin
                    next_state = single_error;
                    data_flag = 0;
                end
            end
            
            single_error: begin
                if (HREADY == 1 && HRESP == OKAY)
                begin
                    next_state = single_okay;
                    data_flag = 1;
                end

                else if (HREADY == 0 || HRESP == ERROR)
                begin
                    next_state = single_error;
                    data_flag = 0;
                end
            end
            
            default: begin
                next_state = single_okay;
            end


            endcase
            
        end
    end


//------------------------------------------------------------------------------------------------------------------------------------

//Sequential block and Combinational block for the burst mode: INCR, WRAPx and INCRx

always_ff@(posedge HCLK)
begin
    
    if (i_HTRANS == HTRANS_NONSEQ && (i_HBURST == INCR || i_HBURST == INCR4 || i_HBURST == INCR8 || i_HBURST == INCR16))
    begin
        temp_addr <= i_HADDR +4;
    end
    
    else if (i_HTRANS == HTRANS_NONSEQ && (i_HBURST == WRAP4 || i_HBURST == WRAP8 || i_HBURST == WRAP16 ) )
    begin
        temp_addr <= {i_HADDR[15:12] ,i_HADDR[7:0] +4};
    end
    
    else if (i_HTRANS == HTRANS_SEQ && (i_HBURST == INCR || i_HBURST == INCR4 || i_HBURST == INCR8 || i_HBURST == INCR16) )
        temp_addr <= temp_addr +4;
    
    else if (i_HTRANS == HTRANS_SEQ && (i_HBURST == WRAP4 || i_HBURST == WRAP8 || i_HBURST == WRAP16 ) )
            temp_addr <= {temp_addr[15:12] ,temp_addr[7:0] +4};
                
end

    always_ff@(posedge  HCLK)
    begin
        if(! HRESETn)
            begin
                current_state_2 <= BURST_CHECK;
            end
        else
            current_state_2 <= next_state_2;
    end

    always_comb
    begin
        if (i_HBURST != SINGLE)
        begin
            case(current_state_2)
            
            BURST_CHECK: begin                              // Checks the initialization of the burst
                if(i_HTRANS == HTRANS_NONSEQ  && HREADY)
                begin
                    flag = 1;
                    next_state_2 = LOOP;

                end
            end

            LOOP: begin                                     // Goes into the increment of adress  
           
                if(i_HTRANS == HTRANS_SEQ && HREADY)
                begin
                    if(i_HBURST == INCR)                     // Infinite increment of address till htans is non sequential
                    begin
                        next_state_2 = LOOP;
                        flag = 1;
                    end

                    else if (!(i_HBURST == SINGLE || i_HBURST == INCR))    // Increment of address for htrans other than single or incr        
                    begin
                    
                        if(temp_count < counter  && temp_count != 0)
                        begin
                            flag = 1;
                            next_state_2 = LOOP;
                        end

                        else
                        begin
                            flag =0;
                            next_state_2 = BURST_CHECK;
                        end
                    end
                   
                    else
                    begin    
                        next_state_2 = BURST_CHECK;
                        flag = 0;
                    end
                end
            end

            default: begin
                next_state_2 = BURST_CHECK;
                flag =0;
            end

            endcase
        end
        
        else
        begin
            next_state_2 = BURST_CHECK;
        end
        
    end

    //Decrement Counter value for the WRAPx and INCRx
        
    always_ff@(posedge HCLK)
    begin
        if (i_HTRANS == HTRANS_NONSEQ && HREADY)
            temp_count <= counter -1;
        else if (i_HTRANS == HTRANS_SEQ && HREADY)
            temp_count <= temp_count -1;
        else
            temp_count <= temp_count;
    end

        //Counter value for the WRAPx and INCRx

    always_comb
    begin
        case(i_HBURST)
            
            WRAP4: counter = 4;
            INCR4: counter = 4;
            WRAP8: counter = 8;
            INCR8: counter = 8;
            WRAP16: counter = 16;
            INCR16: counter = 16;

        endcase
    end

endmodule
