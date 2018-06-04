//////////////////////////////////////////////////////////////////////////////
// ahb3_env.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// environment is a class used to connect generator, driver and the monitor
// Date : 13 March 2018
// .......................................
// Description:
// environment is a class based design and it creates handle fotr the classes generator, driver, monitor, scoreboard
// and it creates objects of the classes and calls the required function and task

// class environment

class environment;

    mailbox #(packet)gtd;  // mailbox from generator to driver
    mailbox #(packet)dts;  // mailbox from driver to the scoreboard
    mailbox #(packet)mts;  // mailbox from monitor to the scoreboard

    generator gen;         // generator class handle
    driver driv;           // driver class handle
    monitor moni;          // monitor class handle
    scoreboard sb;         // scoreboard class handle


    virtual intf vif;      // virtula interface 

    // parameterised function new to get an interface 
    function new(virtual intf vif);
        this.vif = vif;
    endfunction

   // function create to create an object for generator, driver, monitor and scoreboard
   function create();
        gtd = new();
        dts = new();
        mts = new();

        gen     = new (gtd);
        driv    = new (gtd , dts, vif);
        moni    = new (mts , vif);
        sb      = new(dts , mts);

    endfunction
    
    // task write
    // calling function usign  handle gen, driv, moni, sb
    task write;
        begin     
            gen.write_gen();
            driv.drive();
            moni.watch();
            sb.data_write();
        end
    endtask

   // task read
    task read;
       begin        
        gen.read_gen();
        driv.drive();
        moni.watch();
        sb.data_read();
       end
    endtask
    
     // burst write task
	task burst_write;
		
		gen.write_burst_gen();
		driv.drive();
        moni.watch();
        sb.data_write();
       
	endtask

	// burst write loop mode
	task burst_write_loop;
		
        gen.write_loop_gen();
		driv.drive();
        moni.watch();
        sb.data_write(); 
    
	endtask

    // task read for the burst mode
    task burst_read;
	
		gen.read_burst_gen();
		driv.drive();
        moni.watch();
        sb.data_read(); 
      
	endtask
	
    // task read for the loop mode
	task burst_read_loop;
		gen.read_loop_gen();
		driv.drive();
        moni.watch();
        sb.data_read(); 
    endtask

endclass

