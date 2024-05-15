/*-----------------------------------------------------------------
File name     : _base_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Base sequence
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class base_seq extends uvm_sequence#(toggle_item);

  // Properties

  // Registration
  `uvm_object_utils(base_seq)
  
  // Constructor
  function new(string name="gfb_m_base_seq");
    super.new(name);
  endfunction

  // Objection handling

  // task pre_body();
  //   uvm_phase phase;
  //   `ifdef UVM_VERSION_1_2
  //     // in UVM1.2, get starting phase from method
  //     phase = get_starting_phase();
  //   `else
  //     phase = starting_phase;
  //   `endif
  //   if (phase != null) begin
  //     phase.raise_objection(this, get_type_name());
  //     `uvm_info(get_type_name(), "Base seq raise objection", UVM_MEDIUM)
  //   end
  // endtask : pre_body

  // task post_body();
  //   uvm_phase phase;
  //   `ifdef UVM_VERSION_1_2
  //     // in UVM1.2, get starting phase from method
  //     phase = get_starting_phase();
  //   `else
  //     phase = starting_phase;
  //   `endif
  //   if (phase != null) begin
  //     phase.drop_objection(this, get_type_name());
  //     `uvm_info(get_type_name(), "Base seq drop objection", UVM_MEDIUM)
  //   end
  // endtask : post_body

  
endclass //base_seq extends uvm_sequence(_item)