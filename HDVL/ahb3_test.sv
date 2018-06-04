//////////////////////////////////////////////////////////////////////////////
// ahb3_test.sv
// Author: Kirtan Mehta, Mohammad Suheb Zameer
// test is a program block to create different pattern for the environment
// Date : 13 March 2018
// .......................................
// Description:
// test program block contains handle of environment class and it repaets the pattern as per the requirement
// using repeat and class the write, read, burst, loop functions 
//////////////////////////////////////////////////////////////////////////////


// program block to avoid race around condition
program test(intf i);

environment env; // environment class handle env

initial 
begin
    env =new(i);   // creating object and passing an interface handle i
    env.create();  // create function is called using environment handle env

	#20;
	
    repeat(6)         // repeating the sequence 6 times
    begin 
      env.write();    // write function is called 
    end 
    
	repeat(6)        // repeating the sequence 6 times 
    begin 
      env.read();    // read function is called using environment class handle env
    end 
	
	repeat(2)        // repeating the sequence 2 times
	begin	 
		env.burst_write(); // calling burst write 

		repeat(10)       
		begin
			env.burst_write_loop(); // looping into the increment write on the address
		end 	
	end
	
	repeat(2) 
	begin
		env.burst_read();   // calling read 2 
		repeat(10)
		begin
			env.burst_read_loop(); // burst read loop function of an environment is called
		end 
	end
    
	
	$display($time, "WE ARE DONE .. GO HOME AND SLEEP!!! .. ACTUALLY NOT YET .. ");  
end

endprogram

