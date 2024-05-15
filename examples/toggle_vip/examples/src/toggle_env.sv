/*-----------------------------------------------------------------
File name     : toggle_env.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : env file
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_env extends uvm_env;
  
  // Config
  // _config_class env_config;

  // Properties

  // Registration
  `uvm_component_utils(toggle_env)

  // Components
  toggle_agent agent;
  toggle_scoreboard scoreboard;
  toggle_virt_seqr virt_seqr;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);  
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: connect_phase
  extern function void connect_phase(uvm_phase phase);
  

  // Functions

endclass: toggle_env

function void toggle_env::build_phase(uvm_phase phase);
  // if(!uvm_config_db#(gfb_env_config_class)::get(this, "", "env_config", env_config))
  //   `uvm_fatal(get_full_name(), "Failed to get env_config in env")

  agent = toggle_agent::type_id::create("agent", this);
  scoreboard = toggle_scoreboard::type_id::create("scoreboard", this);
  virt_seqr = toggle_virt_seqr::type_id::create("virt seqr", this);
endfunction: build_phase

function void toggle_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  virt_seqr.sequencer = agent.sequencer;
  agent.monitor.transaction_port.connect(scoreboard.masterPort);
endfunction: connect_phase
