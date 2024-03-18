/*-----------------------------------------------------------------
File name     : gfb_interface.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Interface module
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

interface gfb_interface(input bit clk, resetn);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  logic [3:0] data;

  clocking cb @(posedge clk);
    inout data;
  endclocking
  
endinterface