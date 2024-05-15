/*-----------------------------------------------------------------
File name     : clk_item.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that holds item - transaction object
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class clk_item extends uvm_sequence_item;

  // Random Properties
  rand t_Command command;

  // Non-random properties

  // Control knobs

  // Registration
  `uvm_object_utils_begin(clk_item)
    `uvm_field_enum(t_Command, command, UVM_ALL_ON)
  `uvm_object_utils_end

  // Components

  // Constructor
  function new (string name = "clk_item");
    super.new(name);
  endfunction : new

  // Constraints

  // Functions
  function void post_randomize();

  endfunction: post_randomize

  
  function void pre_randomize();

  endfunction: pre_randomize

  // Tasks
endclass //_item extends uvm_sequence_item