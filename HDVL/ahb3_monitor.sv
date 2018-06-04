
//////////////////////////////////////////////////////////////////////////////
// ahb3_monitor.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer, Sai Tawale, Raveena Khandelwal
// monitor is a class based design used to communicate packet between monitor and the scoreboard
// Date : 12 March 2018
// .......................................
// Description:
// monitor is a class based design which receives signal from interface and senfd it to the scoreboard 
// using mailbox
//////////////////////////////////////////////////////////////////////////////

// class monitor

class monitor;

    packet pkt;                  // handle of the packet class
    mailbox #(packet)mts;        // mailbox from monitor to the scoreboard
   
    virtual intf vif;            // virtual interface handle 

 // prameterised function new for passing mailbox and virtual interface handle 
    function new(mailbox #(packet)mts, virtual intf vif);
        this.mts = mts;
        this.vif = vif;
    endfunction


// task watch 
// used for sending packet from interface to the scoreboard
task watch;
    $display($time, "   enter monitor task");
    pkt = new();
    mts.put(pkt);
    
    fork
        @(vif.mon_cb)
        pkt.i_HRDATA    = vif.mon_cb.i_HRDATA; // data at the output is sent to scoreboard
    
    join
endtask

endclass
