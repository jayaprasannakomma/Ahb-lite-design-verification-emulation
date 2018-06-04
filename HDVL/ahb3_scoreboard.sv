//////////////////////////////////////////////////////////////////////////////
// ahb3_scoreboard.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// scoreboard is a class used to compare the result from monitor and from driver 
// Date : 14 March 2018
// .......................................
// Description:
// scoreboard is class containing checkers/assertions, it gets the packet from monitor and the driver 
// , compares results and display the message based on the correctness of the packets received 
//////////////////////////////////////////////////////////////////////////////

// scoreboard 
class scoreboard;

packet pkt1, pkt2;            // packet class handle 

mailbox #(packet) dts;        // mailbox from driver to scoreboard
mailbox #(packet) mts;        // mailbox from monitor to scoreboard
logic [11:0] temp_addr;       // temporary variable of 12 bits

// function new parameterised
function new(mailbox #(packet)dts, mailbox #(packet) mts); 
    
    $display("scoreboard function");
    this.dts = dts;
    this.mts = mts;

endfunction

logic [11:0] mem_tb [4096]; // memory of 4096 locations each of 12 bits

// task data_write 
// it works as a checker in the scoreboard. it receives address from the driver
// and stores in the temporary address. and also receives data from the driver and
// put it into the address, address +1, address +2, address + 3.
task data_write();

    $display("scoreboard check...");
    
    dts.get(pkt1);     // driver to scoreboard
    mts.get(pkt2);     // monitor to scoreboard

    if (pkt1.i_HTRANS == 2'b10 || pkt1.i_HTRANS == 2'b00)
    begin   
        temp_addr = pkt1.i_HADDR[11:0];
    end
    
    else 
    begin
        temp_addr =  temp_addr +4; // incremental address
    end

     
    // writing data on the address 
    {mem_tb[temp_addr[11:0]], mem_tb[temp_addr[11:0] + 1], mem_tb[temp_addr[11:0] +2], mem_tb[temp_addr[11:0] +3]} = pkt1.i_HWDATA;
    
    $display("HADDR from input packet \t %h", temp_addr);
    
    $display("HWDATA FROM input packet \t %h", pkt1.i_HWDATA);
    
    $display(" Data in the memory %h" , {mem_tb[temp_addr[11:0]], mem_tb[temp_addr[11:0] + 1], mem_tb[temp_addr[11:0] +2], mem_tb[temp_addr[11:0] +3]} );
    

    // assertion to check if data is written correctly 
    assert (pkt1.i_HWDATA == {mem_tb[temp_addr[11:0]], mem_tb[temp_addr[11:0] + 1], mem_tb[temp_addr[11:0] +2], mem_tb[temp_addr[11:0] +3]})
   	    $display("Data has been wriiten successfully");	
	else  
		$error("Data failed to write");

$display("");
endtask


// task data_read
// it works as a checker in the scoreboard. it receives address from the driver
// and stores in the temporary address. and also receives data from the monitor and
// put it into the address, address +1, address +2, address + 3.

task data_read();

    $display("Scoreboard read ");
  
    dts.get(pkt1);
    mts.get(pkt2);
   
    if (pkt1.i_HTRANS == 2'b10 || pkt1.i_HTRANS == 2'b00)
    begin    
        temp_addr = pkt1.i_HADDR[11:0];
    end
    else 
    begin
        temp_addr =  temp_addr +4;
    end

    $display("temp address = %h", temp_addr);

    $display("Read data from DUT %h", pkt2.i_HRDATA); // data from monitor/DUT

    $display("DATA from TB memory %h", {mem_tb[temp_addr], mem_tb[temp_addr + 1], mem_tb[temp_addr +2], mem_tb[temp_addr +3] } );
	

    // assertion to check and read the data from the memory 
    assert (pkt2.i_HRDATA == {mem_tb[temp_addr[11:0]], mem_tb[temp_addr[11:0] + 1], mem_tb[temp_addr[11:0] +2], mem_tb[temp_addr[11:0] +3]})
 		$display("Data read successfully and it matches");
	else
		$error("Data reading failed");

    
$display("");

endtask



endclass
