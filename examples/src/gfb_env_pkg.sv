/*-----------------------------------------------------------------
File name     : gfb_env_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Example environment package
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

package gfb_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import gfb_pkg::*;
  import gfb_seq_pkg::*;
  
  `include "gfb_scoreboard.sv"
  `include "gfb_virt_seqr.sv"
  `include "gfb_virt_seq.sv"
  `include "gfb_env.sv"
  
endpackage