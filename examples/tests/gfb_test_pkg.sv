/*-----------------------------------------------------------------
File name     : gfb_test_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Test package
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

package gfb_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import gfb_pkg::*;
  import gfb_env_pkg::*;
  import gfb_seq_pkg::*;
  import toggle_pkg::*;
  
  `include "gfb_base_test.sv"
  `include "gfb_simple_rep_test.sv"
endpackage