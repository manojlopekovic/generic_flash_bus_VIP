/*-----------------------------------------------------------------
File name     : top.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Top
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

module top;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import gfb_test_pkg::*;
  import toggle_pkg::*;

  bit clk, resetn;

  assign resetn = rst_n_if.data;
  toggle_interface rst_n_if(clk);
  

  gfb_interface intf(clk, resetn);


  always #50 clk = ~clk;


  initial begin 
    uvm_config_db#(virtual toggle_interface)::set(uvm_root::get(), "*", "rst_inf", rst_n_if);
    uvm_config_db#(virtual gfb_interface)::set(uvm_root::get(),"*","intf", intf);

    run_test("base_test");
  end


  // initial begin 
  //   // uvm_event_pool::get_global("test_started").wait_trigger();

  //   #50000000;
  //   `uvm_fatal("TOP", "END OF SIMULAION")
  // end

endmodule : top