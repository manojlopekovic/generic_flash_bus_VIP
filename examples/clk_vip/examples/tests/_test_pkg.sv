/*-----------------------------------------------------------------
File name     : _test_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all neccessary tests
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package _test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import _pkg::*;
  import _env_pkg::*;
  import _seq_pkg::*;
  
  `include "/project/users/manojlop/training/uvm_struct_folder/examples/tests/_base_test.sv"
  `include "/project/users/manojlop/training/uvm_struct_folder/examples/tests/_simple_rep_test.sv"
endpackage