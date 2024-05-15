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
  toggle_cfg toggle_cfg;
  clk_conf clk_cfg;

  // Properties

  // Interfaces to pack
  virtual toggle_interface rst_n_if;

  // Registration
  `uvm_component_param_utils(gfb_env#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components
  // Todo : add clock agent
  toggle_agent reset_agent;
  clk_agent clock_agent;
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
  if(!uvm_config_db#(gfb_config)::get(this, "", "master_cfg", master_cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in env")
  if(!uvm_config_db#(gfb_config)::get(this, "", "slave_cfg", slave_cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in env")

  if(!uvm_config_db#(toggle_cfg)::get(this, "", "toggle_cfg", toggle_cfg))
    `uvm_fatal(get_full_name(), "Failed to get toggle_cfg in env")

  if(!uvm_config_db#(clk_conf)::get(this, "", "clk_cfg", clk_cfg))
    `uvm_fatal(get_full_name(), "Failed to get clk_cfg in env")

  if(!uvm_config_db#(virtual toggle_interface)::get(this, "", "rst_inf", rst_n_if))
    `uvm_fatal(get_full_name(), "Failed to get rst_inf in env")

  uvm_config_db#(clk_conf)::set(this, "clock_agent.*", "clk_conf", clk_cfg);
  clock_agent = clk_agent::type_id::create("clock_agent", this);

  uvm_config_db#(virtual toggle_interface)::set(this, "reset_agent.driver", "vif", rst_n_if);
  uvm_config_db#(virtual toggle_interface)::set(this, "reset_agent.monitor", "vif", rst_n_if);
  uvm_config_db#(toggle_cfg)::set(this, "reset_agent", "cfg", toggle_cfg);
  reset_agent = toggle_agent::type_id::create("reset_agent", this);

  uvm_config_db#(gfb_config)::set(this, "slave_agent", "agt_cfg", slave_cfg);
  uvm_config_db#(gfb_config)::set(this, "master_agent", "agt_cfg", master_cfg);
  slave_agent = gfb_agent::type_id::create("slave_agent", this);
  master_agent = gfb_agent::type_id::create("master_agent", this);

  scoreboard = gfb_scoreboard::type_id::create("scoreboard", this);
  
  uvm_config_db#(gfb_config)::set(this, "virt_seqr", "master_seqr_cfg", master_cfg);
  uvm_config_db#(gfb_config)::set(this, "virt_seqr", "slave_seqr_cfg", slave_cfg);
  uvm_config_db#(toggle_cfg)::set(this, "virt_seqr", "toggle_cfg", toggle_cfg);
  uvm_config_db#(clk_conf)::set(this, "virt_seqr", "clk_conf", clk_cfg);
  virt_seqr = gfb_virt_seqr::type_id::create("virt_seqr", this);
endfunction: build_phase

function void gfb_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  virt_seqr.master_sequencer = master_agent.sequencer;
  virt_seqr.slave_sequencer = slave_agent.sequencer;
  virt_seqr.toggle_sequencer = reset_agent.sequencer;
  virt_seqr.clock_sequencer = clock_agent.sequencer;

  master_agent.monitor.transaction_port.connect(scoreboard.masterPort);
  slave_agent.monitor.transaction_port.connect(scoreboard.slavePort);
  // Todo : check if reset port connection is needed in scoreboard

endfunction: connect_phase
