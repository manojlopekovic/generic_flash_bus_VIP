/*-----------------------------------------------------------------
File name     : gfb_config.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : GFB package
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

package gfb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "gfb_types_defines.sv"

  `include "gfb_config.sv"
  `include "gfb_item.sv"
  `include "gfb_monitor.sv"
  `include "gfb_sequencer.sv"
  `include "gfb_driver.sv"
  `include "gfb_subscriber.sv"
  `include "gfb_agent.sv"

endpackage