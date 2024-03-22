/*-----------------------------------------------------------------
File name     : gfb_simple_rep_test.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Simple repetition test
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class simple_rep_test extends base_test;

  //Components
  simple_rep_seq simple_rep_sequence;

  // Registration
  `uvm_component_utils(simple_rep_test)
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);
  
endclass //_simple_rep_test extends base_test


function void simple_rep_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  simple_rep_sequence = simple_rep_seq::type_id::create("simple_rep_sequence", this);
endfunction: build_phase


task simple_rep_test::run_phase(uvm_phase phase);
  gfb_virt_seq v_seq;
  super.run_phase(phase);
  v_seq = gfb_virt_seq::type_id::create("v_seq");
  phase.raise_objection(this);
  `uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_NONE)

  uvm_event_pool::get_global("reset_happened_ev").wait_trigger();
  `uvm_info(get_full_name(), "Initial reset happened", UVM_NONE)
  

  v_seq.start(env.virt_seqr);
  

  phase.drop_objection(this);
  `uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_NONE)
endtask: run_phase

