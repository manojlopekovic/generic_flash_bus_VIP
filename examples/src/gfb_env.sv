/*-----------------------------------------------------------------
File name     : gfb_env.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Environment
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_env extends uvm_env;
  
  // Config
  // _config_class env_config;

  // Properties

  // Registration
  `uvm_component_utils(gfb_env)

  // Components
  gfb_agent agent;
  gfb_scoreboard scoreboard;
  gfb_virt_seqr virt_seqr;

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

endclass: gfb_env

function void gfb_env::build_phase(uvm_phase phase);
  // if(!uvm_config_db#(gfbgfb_env_config_class)::get(this, "", "env_config", env_config))
  //   `uvm_fatal(get_full_name(), "Failed to get env_config in env")

  agent = gfb_agent::type_id::create("agent", this);
  scoreboard = gfb_scoreboard::type_id::create("scoreboard", this);
  virt_seqr = gfb_virt_seqr::type_id::create("virt seqr", this);
endfunction: build_phase

function void gfb_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  virt_seqr.sequencer = agent.sequencer;
  agent.monitor.transaction_port.connect(scoreboard.masterPort);
endfunction: connect_phase
