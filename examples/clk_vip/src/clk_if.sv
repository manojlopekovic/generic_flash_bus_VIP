/*-----------------------------------------------------------------
File name     : clk_if.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Interface class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

interface clk_if();
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  logic clk;
  
endinterface