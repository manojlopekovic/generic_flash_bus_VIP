/*-----------------------------------------------------------------
File name     : gfb_item.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence item
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_item#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequence_item;

  // Random Properties
  rand bit [31:0] data;

  // Non-random properties

  // Control knobs

  // Registration
  `uvm_object_param_utils_begin(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))
    `uvm_field_int(data, UVM_ALL_ON + UVM_DEC)
  `uvm_object_utils_end

  // Components

  // Constructor
  function new (string name = "gfb_item");
    super.new(name);
  endfunction : new

  // Constraints

  // Functions
  function void post_randomize();

  endfunction: post_randomize

  
  function void pre_randomize();

  endfunction: pre_randomize

  // Tasks
endclass //gfb_item extends uvm_sequencegfb_item