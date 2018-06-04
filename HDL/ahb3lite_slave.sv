
////////////////////////////////////////////////////////////////////////////////////////////////
// ahb3lite_slave.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer, Sai Tawale, Raveena Khandelwal
// 
// Date : 12 March 2018
// .......................................
// Description:
// AHBlite slave sends the data from the slave to the master depending upon the inputs.
/////////////////////////////////////////////////////////////////////////////////////////////////    
import ahb3lite_pkg::* ;

    module ahb3lite_slave(
                        
                input logic HRESETn,
                input logic HREADY,
                input bit HCLK,
                input logic [31:0] HADDR,
                input logic [31:0] HWDATA,
                input logic HWRITE,
                input logic [2:0] HSIZE,
                input logic [2:0] HBURST,
                input logic [1:0] HTRANS,
                input logic [1:0] HSEL,
                
                output logic HREADYOUT,
                output logic HRESP,
                output logic [31:0] HRDATA
                
    );
  
    // FSM to decide the okay response or error response

    state_resp current_state , next_state;

    logic write_flag,read_flag;

    // Memory taken as a slave to write and read data 
    bit	[11:0]  Memory [4096];
    
    //-----------------------------------------------------------------------------------------------------

    logic [11:0] temp_addr;
    
    always_ff@(posedge HCLK )
    begin
        if (HRESETn)begin
            current_state <= OKAY_state;
          end  
        else
            current_state <= next_state;
    end

// combinational block to write the date into the memory.
   
    always_comb
    begin
        if (write_flag == 1)
            {Memory[temp_addr], Memory[temp_addr + 1], Memory[temp_addr +2], Memory[temp_addr +3]} = HWDATA;
        else if(read_flag == 1)
            HRDATA = {Memory[temp_addr], Memory[temp_addr + 1], Memory[temp_addr +2], Memory[temp_addr +3]};
    end
    
    // combinational block for okay and error response in the slave
    always_comb
    begin
        case(current_state)

            OKAY_state: begin                           // Okay state to show that the slave is ready for next transfer
                read_flag = 0;
                write_flag = 0;
                if (HREADY == 1)
                begin
                    HRESP = OKAY;
                    next_state = OKAY_state;
                    temp_addr = HADDR[11:0];
                    if(HWRITE == 1)
                    begin
                        write_flag = 1;
                        read_flag = 0;
                        
                        HREADYOUT = 1; 
                    end
                    else if(HWRITE == 0) begin
                        read_flag = 1;
                        write_flag = 0;
                    
                        HREADYOUT = 1;
                     end

                end
                
                else if (HREADY ==0) 
                begin
                    HRESP = OKAY;
                    next_state = ERROR_state;
                    HREADYOUT = 0;    
                end
            end

            ERROR_state: begin                         // Error state to show that the slave is in not ready for next transfer
                if (HREADY == 0)
                begin
                    HRESP = ERROR;
                    next_state = ERROR_state;
                    HREADYOUT = 1;
                end

                else if(HREADY == 1)
                begin
                    next_state = OKAY_state;
                    HRESP = OKAY;
                    HREADYOUT = 1;
                end
            end
            
            default: begin
                next_state = OKAY_state;
                HRESP = OKAY;
                HREADYOUT = 1;
            end
        endcase
    end

    endmodule