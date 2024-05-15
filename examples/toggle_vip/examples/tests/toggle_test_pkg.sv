/*-----------------------------------------------------------------
File name     : _test_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all neccessary tests
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package toggle_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import toggle_pkg::*;
  import toggle_env_pkg::*;
  import toggle_seq_pkg::*;

  
  
  `include "toggle_base_test.sv"
  `include "toggle_simple_rep_test.sv"
endpackage