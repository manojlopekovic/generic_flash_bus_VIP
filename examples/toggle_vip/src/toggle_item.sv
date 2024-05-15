/*-----------------------------------------------------------------
File name     : toggle_item.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that holds item - transaction object
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_item extends uvm_sequence_item;

  // Random Properties
  rand bit data;
  rand int delay;
  rand int delay_cb;

  // Non-random properties

  // Control knobs

  // Registration
  `uvm_object_utils_begin(toggle_item)
    `uvm_field_int(data, UVM_ALL_ON + UVM_DEC)
  `uvm_object_utils_end

  
  constraint delay_val {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    soft delay inside {[0:50]};
    soft delay_cb inside {[0:50]};
  }

  constraint delay_base {
    soft delay == 0;
    soft delay_cb == 0;
  }

  // Components

  // Constructor
  function new (string name = "toggle_item");
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