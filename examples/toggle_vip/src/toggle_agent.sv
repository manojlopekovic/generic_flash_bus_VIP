/*-----------------------------------------------------------------
File name     : toggle_agent.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Agent class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_agent extends uvm_agent;

  // Config
  toggle_cfg cfg;

  // Properties

  // Registration
  `uvm_component_utils(toggle_agent)

  // Components
  toggle_driver driver;
  toggle_monitor monitor;
  toggle_sequencer sequencer;
  toggle_subscriber subscriber;

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

  // Tasks

endclass //toggle_agent extends uvmtoggle_agent


function void toggle_agent::build_phase(uvm_phase phase);
  if(!uvm_config_db#(toggle_cfg)::get(this, "", "cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get config in agent")

  uvm_config_db#(toggle_cfg)::set(this, "*", "cfg", cfg);
  
  monitor = toggle_monitor::type_id::create("monitor", this);
  subscriber = toggle_subscriber::type_id::create("subscriber", this);
  if(get_is_active() == UVM_ACTIVE) begin 
    sequencer = toggle_sequencer::type_id::create("sequencer", this);
    driver = toggle_driver::type_id::create("driver", this);
  end

  
endfunction: build_phase


function void toggle_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(get_is_active() == UVM_ACTIVE) begin 
    driver.seq_item_port.connect(sequencer.seq_item_export);
    // monitor.command_port.connect(sequencer.command_export);
    monitor.transaction_port.connect(subscriber.analysis_export);
  end
  
endfunction: connect_phase

