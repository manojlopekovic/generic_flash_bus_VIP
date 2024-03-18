/*-----------------------------------------------------------------
File name     : gfb_seq_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence package
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

package gfb_seq_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import gfb_pkg::*;

  `include "gfb_base_seq.sv"
  `include "gfb_simple_rep_seq.sv"

endpackage