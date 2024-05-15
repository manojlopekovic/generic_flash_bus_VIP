/*-----------------------------------------------------------------
File name     : clk_seq_pkg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents package of all neccessary sequences
Notes         : 
Date          : 12.09.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

package clk_seq_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import clk_pkg::*;

  `include "/project/users/manojlop/training/labs/lab6_vip_design/clk_vip/src/seq_library/clk_base_seq.sv"
  `include "/project/users/manojlop/training/labs/lab6_vip_design/clk_vip/src/seq_library/clk_start_seq.sv"

endpackage