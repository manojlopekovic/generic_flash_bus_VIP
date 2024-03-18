/*-----------------------------------------------------------------
File name     : gfb_base_test.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Base test, with virtual functions for configuration setting
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class base_test extends uvm_test;

  // Registration
  `uvm_component_utils(base_test)

  // Components
  gfb_env env;

  // Configuration

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: end_of_elaboration_phase
  extern function void end_of_elaboration_phase(uvm_phase phase);
  
  //Modify configuration functions


endclass : base_test

function void base_test::build_phase(uvm_phase phase);
  env = gfb_env::type_id::create("env", this);
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
  uvm_factory::get().print();
endfunction: end_of_elaboration_phase


