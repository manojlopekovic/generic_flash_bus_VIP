/*-----------------------------------------------------------------
File name     : _base_test.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that represents base test 
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class base_test extends uvm_test;

  // Registration
  `uvm_component_utils(base_test)

  // Components
  toggle_env env;

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
  env = toggle_env::type_id::create("env", this);
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
  uvm_factory::get().print();
endfunction: end_of_elaboration_phase


