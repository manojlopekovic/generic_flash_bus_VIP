/*-----------------------------------------------------------------
File name     : top.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Top file
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import toggle_test_pkg::*;

  bit clk, resetn;

  always #50 clk = ~clk;

  toggle_interface intf(clk, resetn);

  initial begin 
    clk = 1'b1;
    resetn = 1'b1;

    uvm_config_db#(virtual toggle_interface)::set(uvm_root::get(),"*","intf", intf);

    run_test("base_test");
  end

  initial begin 
    #130 resetn = 1'b0;
    repeat(3) @(intf.cb) resetn = 1'b1;
  end


  initial begin 
    // uvm_event_pool::get_global("test_started").wait_trigger();

    #50000000;
    `uvm_fatal("TOP", "END OF SIMULAION")
  end

endmodule : top