/*-----------------------------------------------------------------
File name     : gfb_env.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Environment
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_env#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_env;
  
  // Config
  gfb_config slave_cfg;
  gfb_config master_cfg;

  // Properties

  // Registration
  `uvm_component_param_utils(gfb_env#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components
  gfb_agent slave_agent;
  gfb_agent master_agent;
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
  if(!uvm_config_db#(gfb_config)::get(this, "", "slave_cfg", master_cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in env")
  if(!uvm_config_db#(gfb_config)::get(this, "", "master_cfg", slave_cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in env")

  uvm_config_db#(gfb_config)::set(this, "slave_agent", "agt_cfg", slave_cfg);
  uvm_config_db#(gfb_config)::set(this, "master_agent", "agt_cfg", master_cfg);
  slave_agent = gfb_agent::type_id::create("slave_agent", this);
  master_agent = gfb_agent::type_id::create("master_agent", this);

  scoreboard = gfb_scoreboard::type_id::create("scoreboard", this);
  
  uvm_config_db#(gfb_config)::set(this, "virt_seqr", "master_seqr_cfg", master_cfg);
  uvm_config_db#(gfb_config)::set(this, "virt_seqr", "slave_seqr_cfg", slave_cfg);
  virt_seqr = gfb_virt_seqr::type_id::create("virt_seqr", this);
endfunction: build_phase

function void gfb_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  virt_seqr.master_sequencer = master_agent.sequencer;
  virt_seqr.slave_sequencer = slave_agent.sequencer;
  master_agent.monitor.transaction_port.connect(scoreboard.masterPort);
  slave_agent.monitor.transaction_port.connect(scoreboard.slavePort);
endfunction: connect_phase
