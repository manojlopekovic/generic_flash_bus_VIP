/*-----------------------------------------------------------------
File name     : _env.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : env file
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class _env extends uvm_env;
  
  // Config
  // _config_class env_config;

  // Properties

  // Registration
  `uvm_component_utils(_env)

  // Components
  _agent agent;
  _scoreboard scoreboard;
  _virt_seqr virt_seqr;

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

endclass: _env

function void _env::build_phase(uvm_phase phase);
  // if(!uvm_config_db#(gfb_env_config_class)::get(this, "", "env_config", env_config))
  //   `uvm_fatal(get_full_name(), "Failed to get env_config in env")

  agent = _agent::type_id::create("agent", this);
  scoreboard = _scoreboard::type_id::create("scoreboard", this);
  virt_seqr = _virt_seqr::type_id::create("virt seqr", this);
endfunction: build_phase

function void _env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  virt_seqr.sequencer = agent.sequencer;
  agent.monitor.transaction_port.connect(scoreboard.masterPort);
endfunction: connect_phase
