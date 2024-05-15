/*-----------------------------------------------------------------
File name     : clk_start_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Base sequence
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class start_seq extends base_seq;

  // Properties
  rand t_Command cmd = START_CLK;

  // Constraint

  // Registration
  `uvm_object_utils(start_seq)
  
  // Constructor
  function new(string name="start_seq");
    super.new(name);
  endfunction

  // Body of a sequence
  virtual task body();
    `uvm_info(get_full_name(), "Executing start_seq", UVM_HIGH)
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {command == cmd;});
    finish_item(req);
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)