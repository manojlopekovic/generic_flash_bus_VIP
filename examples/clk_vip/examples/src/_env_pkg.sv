/*-----------------------------------------------------------------
File name     : _env_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all environment components
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package _env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import _pkg::*;
  import _seq_pkg::*;
  
  `include "/project/users/manojlop/training/uvm_struct_folder/examples/src/_scoreboard.sv"
  `include "/project/users/manojlop/training/uvm_struct_folder/examples/src/_virt_seqr.sv"
  `include "/project/users/manojlop/training/uvm_struct_folder/examples/src/_virt_seq.sv"
  `include "/project/users/manojlop/training/uvm_struct_folder/examples/src/_env.sv"
  
endpackage