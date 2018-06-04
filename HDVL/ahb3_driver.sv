//////////////////////////////////////////////////////////////////////////////
// ahb3_driver.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// driver is a class based design 
// Date : 11 March 2018
// .......................................
// Description:
// driver class is used to receive packet from generator and send the packet to the scoreboard using mailbox
///////////////////////////////////////////////////////////////////////////////


// driver class to drive packet 
class driver;

    
    packet pkt;             // handle of the packet class

    mailbox #(packet)gtd;   // mailbox from generator to driver
    mailbox #(packet)dts;   // mailbox from driver to the scoreboard

    virtual intf vif;       // virtual interface, for communicatind between class and a module (static)
    

 // parameterised function new, contains mailbox and virtual interface handle vif
function new(mailbox #(packet)gtd, mailbox #(packet)dts, virtual intf vif);
        
        this.gtd = gtd;  // assign gtd from function to the gtd of this class
        this.dts = dts;  // assign dts
        this.vif = vif;  // assign vif (virtual interface handle)
       
endfunction
    
// drive task
// this task gets the packet from the generator and put 
// it on the interface
task drive;
       
     
           gtd.get(pkt);    // getting 
           dts.put(pkt);    // putting
           $display($time ,"Enter into the driver "); 
                vif.drv_cb.i_HADDR  <= pkt.i_HADDR;
                vif.drv_cb.i_HWDATA <= pkt.i_HWDATA;
                vif.drv_cb.i_HWRITE <= pkt.i_HWRITE;
                vif.drv_cb.i_HTRANS <= pkt.i_HTRANS;
                vif.drv_cb.i_HSIZE  <= pkt.i_HSIZE;
                vif.drv_cb.i_HBURST <= pkt.i_HBURST;
        
    endtask


endclass
