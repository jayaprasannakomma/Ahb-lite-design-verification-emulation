
//////////////////////////////////////////////////////////////////////////////
// ahb3_generator.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// generator is a class used to generate different signals based on the specification and it drives Driver
// Date : 11 March 2018
// .......................................
// Description:
// generator is a class based design to generate different patterns of the address and the data, after generating signals\
// it drives these signals to the driver using mailbox.
/////////////////////////////////////////////////////////////////////////////////


class generator;

    packet pkt;            // handle of a packet class     
    mailbox #(packet)gtd;  // mailbox of packet type, from generator to the driver
	logic [31:0] temp_addr;// temporary variable  
    logic [11:0] addr_array [6] =  {8'h11, 8'h22, 12'h33, 12'h44 , 12'h001, 12'h005}; // Address array
    logic [11:0] addr_burst[2] = { 12'hab , 12'hde}; // burst
    int i =0;

    // function new, a parameterised constructor 
     function new(mailbox #(packet)gtd);
        this.gtd   = gtd;
   
     endfunction
  
    // write task 
    // This task sends value to the driver using pkt of the mailbox and for a write
    task write_gen();
        $display($time," %d ,, task write generator", i);
        pkt = new();                       // object of pkt created
            pkt.i_HADDR = addr_array[i];
            pkt.i_HWDATA = $urandom;
            pkt.i_HWRITE = 1;
            pkt.i_HSIZE = 3'b010;            
            pkt.i_HBURST = 3'b000;
            pkt.i_HTRANS = 2'b00;
            gtd.put(pkt);                 // sending packet from generator to the driver
            i++;
            if (i == 6) i=0;
    endtask

    // read task
    // This task sends value to the driver using pkt of the mailbox and for a read
     task read_gen ();
        $display($time, "   task read in generator");
        pkt = new();                       // object created
            pkt.i_HADDR = addr_array[i];
            pkt.i_HWRITE = 0;
            pkt.i_HSIZE = 3'b010;
            pkt.i_HBURST = 3'b000;
            pkt.i_HTRANS = 2'b00;
      
            gtd.put(pkt);                // sending packet from generator to the driver
            i++;
            if (i == 6) i=0;
    endtask
    

    // write Burst increment 
	task write_burst_gen();
	$display($time, "   write burst in generator");
        pkt = new();
            pkt.i_HADDR = addr_burst[i];
            pkt.i_HWRITE = 1;
            pkt.i_HSIZE = 3'b010;
            pkt.i_HBURST = 3'b001;
            pkt.i_HTRANS = 2'b10;
		    pkt.i_HWDATA = $urandom();

            gtd.put(pkt);
            i++;
            if (i == 2) i=0;
	endtask
	

    // Loop mode 
    // for write on incremental address (+4)
	task write_loop_gen();
	$display($time, "   write burst in generator loop");
		pkt = new();
	
		pkt.i_HADDR = addr_burst[i]; 
		pkt.i_HWRITE = 1;
		pkt.i_HTRANS = 2'b11;
		pkt.i_HSIZE = 3'b010;
        pkt.i_HBURST = 3'b001;
		pkt.i_HWDATA = $urandom();
		gtd.put(pkt);
	    i++;
        if (i == 2) i=0;
	endtask
     
    // read for the burst mode
	task read_burst_gen();
	    $display($time, "   Read burst in generator");
        
        pkt = new();
        pkt.i_HADDR = addr_burst[i];
        pkt.i_HWRITE = 0;
        pkt.i_HSIZE = 3'b010;
        pkt.i_HBURST = 3'b001;
        pkt.i_HTRANS = 2'b10;
		
		temp_addr = pkt.i_HADDR;
            
        gtd.put(pkt);
        i++;
        if (i == 2) i=0;
	endtask
	
    // read mode for the loop
    // read on the incremental address (+4)
	task read_loop_gen();
	    $display($time, "     Read burst in generator loop");
		
        pkt = new(); 
		pkt.i_HWRITE = 0;
		pkt.i_HTRANS = 2'b11;
		pkt.i_HSIZE = 3'b010;
        pkt.i_HBURST = 3'b001;
		
        gtd.put(pkt);
        i++;
        if (i == 2) i=0;
	endtask
    
endclass 
