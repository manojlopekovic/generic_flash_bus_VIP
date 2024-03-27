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
  gfb_config master_cfg;
  gfb_config slave_cfg;

  // Configuration

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Phases

  //  Function: build_phase
  extern virtual function void build_phase(uvm_phase phase);
  //  Function: end_of_elaboration_phase
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  
  // Modify configuration functions
  extern virtual  function void modify_master_cfg();
  extern virtual  function void modify_slave_cfg();

endclass : base_test


function void base_test::build_phase(uvm_phase phase);

  master_cfg = gfb_config::type_id::create("master_cfg");
  slave_cfg = gfb_config::type_id::create("slave_cfg");

  modify_master_cfg();
  // modify_slave_cfg();
  // $cast(slave_cfg, master_cfg.clone());
  slave_cfg.copy(master_cfg);
  slave_cfg.agent_type = gfb_config::SLAVE;

  `uvm_info("CFG_PRINT", $sformatf("BASE TEST: \nM_CFG : \n %s \nS_CFG: \n %s", master_cfg.sprint(), slave_cfg.sprint()), UVM_NONE)
  uvm_config_db#(gfb_config)::set(this, "env", "master_cfg", master_cfg);
  uvm_config_db#(gfb_config)::set(this, "env", "slave_cfg", slave_cfg);
  

  env = gfb_env::type_id::create("env", this);
endfunction: build_phase


function void base_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
  uvm_factory::get().print();
endfunction: end_of_elaboration_phase


function void base_test::modify_master_cfg();
  master_cfg.randomize() with {
    agent_type == gfb_config::MASTER;
    slave_wait_state_en == '1;
    slave_wait_state_rate == 100;
  };
endfunction


function void  base_test::modify_slave_cfg();
  slave_cfg.randomize() with {
    agent_type == gfb_config::SLAVE;
  };
endfunction

