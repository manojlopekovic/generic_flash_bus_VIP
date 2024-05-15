/*-----------------------------------------------------------------
File name     : pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all neccessary components
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package toggle_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "toggle_types_defines.sv"

  `include "toggle_cfg.sv"
  `include "toggle_item.sv"
  `include "toggle_monitor.sv"
  `include "toggle_sequencer.sv"
  `include "toggle_driver.sv"
  `include "toggle_subscriber.sv"
  `include "toggle_agent.sv"

endpackage