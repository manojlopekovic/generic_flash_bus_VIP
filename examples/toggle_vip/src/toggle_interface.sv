/*-----------------------------------------------------------------
File name     : toggle_interface.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Interface class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

interface toggle_interface(input bit clk);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  logic data;

  clocking cb @(posedge clk);
    inout data;
  endclocking
  
endinterface