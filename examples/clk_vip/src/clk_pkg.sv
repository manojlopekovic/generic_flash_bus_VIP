/*-----------------------------------------------------------------
File name     : pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all neccessary components
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package clk_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "clk_types_defines.sv"


  `include "clk_conf.sv"
  `include "clk_item.sv"
  `include "clk_monitor.sv"
  `include "clk_sequencer.sv"
  `include "clk_driver.sv"
  `include "clk_subscriber.sv"
  `include "clk_agent.sv"

endpackage