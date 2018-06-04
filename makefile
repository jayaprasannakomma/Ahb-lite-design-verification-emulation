 
#Specify the mode- could be either puresim or veloce
#Always make sure that everything works fine in puresim before changing to veloce

MODE ?=veloce

#make all does everything
all: work build run

#Create respective work libs and map them 
work:
	vlib work.$(MODE)
	vmap work work.$(MODE)
	
#Compile/synthesize the environment
build:

ifeq ($(MODE),puresim)		
	#	vlog ahb3lite_master.sv				
	#	vlog ahb3lite_slave.sv	
	#	vlog ahb3lite_mux.sv		
	#	vlog ahb3lite_decoder.sv
		vlog ahb3lite_top.sv				
	#	vlog ahb3_packet.sv
	#	vlog ahb3_generator.sv
	#	vlog ahb3_interface_tb.sv
	#	vlog ahb3_driver.sv
	#	vlog ahb3_monitor.sv
	#	vlog ahb3_scoreboard.sv
	#	vlog ahb3_env.sv
	#	vlog ahb3_test.sv
		vlog ahb3_top.sv
		vlog top_hdl.sv
		vlog AHBInterface.sv
		velhvl -sim $(MODE)
else
	velanalyze ahb3lite_master.sv				
	velanalyze ahb3lite_slave.sv	
	velanalyze ahb3lite_mux.sv		
	velanalyze ahb3lite_decoder.sv
	velanalyze top.sv									
	velanalyze top_hdl.sv
	velanalyze AHBInterface.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_packet.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_generator.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_interface_tb.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_driver.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_monitor.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_scoreboard.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_env.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_test.sv
	velanalyze -hdl verilog -extract_hvl_info ahb3_top.sv
	vlog ahb3_top.sv
	velcomp -top top_hdl	#Synthesize!              
	velhvl -sim $(MODE) 
endif

run:
	vsim -c -novopt -do "run -all;exit" ahb3_top

run_em:
	vsim -c -novopt -do "run -all" top_hdl ahb3_top TbxSvManager	          #Run all 
	cp transcript transcript.$(MODE)		                          #Record transcript 	
	

clean:
	rm -rf tbxbindings.h modelsim.ini transcript.veloce transcript.puresim work work.puresim work.veloce transcript *~ vsim.wlf *.log dgs.dbg dmslogdir veloce.med veloce.wave veloce.map velrunopts.ini edsenv 