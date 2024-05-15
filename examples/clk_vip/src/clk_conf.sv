/*-----------------------------------------------------------------
File name     : spi2ahb_conf.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : spi2ahb config
Notes         : 
Date          : 12.09.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class clk_conf extends uvm_object;

  // typedefs

  // Num clocks
  rand int num_clk = 1;
  rand int freq [];

  // Registration
  `uvm_object_utils_begin(clk_conf);
    `uvm_field_int(num_clk, UVM_ALL_ON)
    `uvm_field_array_int(freq, UVM_ALL_ON)
  `uvm_object_utils_end
 
  // Constructor
  function new(string name = "clk_conf"); 
    super.new(name);
  endfunction

  // Constraints
  
endclass //spi2ahb_conf extends uvm_object