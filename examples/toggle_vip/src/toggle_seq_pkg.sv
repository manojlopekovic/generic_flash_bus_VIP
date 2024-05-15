/*-----------------------------------------------------------------
File name     : _seq_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all neccessary components
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package toggle_seq_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import toggle_pkg::*;

  `include "/seq_library/toggle_base_seq.sv"
  `include "/seq_library/toggle_simple_rep_seq.sv"
  `include "/seq_library/toggle_rise_seq.sv"
  `include "/seq_library/toggle_fall_seq.sv"

endpackage