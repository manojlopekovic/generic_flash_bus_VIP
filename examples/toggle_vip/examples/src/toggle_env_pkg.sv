/*-----------------------------------------------------------------
File name     : toggle_env_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all environment components
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package toggle_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import toggle_pkg::*;
  import toggle_seq_pkg::*;
  
  `include "toggle_scoreboard.sv"
  `include "toggle_virt_seqr.sv"
  `include "toggle_virt_seq.sv"
  `include "toggle_env.sv"
  
endpackage