/*-----------------------------------------------------------------
File name     : gfb_agent.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Agent class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_agent extends uvm_agent;

  // Config
  // _config_class _config;

  // Properties

  // Registration
  `uvm_component_utils(gfb_agent)

  // Components
  gfb_driver driver;
  gfb_monitor monitor;
  gfb_sequencer sequencer;
  gfb_subscriber subscriber;

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

endclass //gfb_agent extends uvmgfb_agent


function void gfb_agent::build_phase(uvm_phase phase);
  // if(!uvm_config_db#(gfbgfb_agent_config_class)::get(this, "", "_config", _config))
  //   `uvm_fatal(get_full_name(), "Failed to get config in agent")
  
  monitor = gfb_monitor::type_id::create("monitor", this);
  subscriber = gfb_subscriber::type_id::create("subscriber", this);
  if(get_is_active() == UVM_ACTIVE) begin 
    sequencer = gfb_sequencer::type_id::create("sequencer", this);
    driver = gfb_driver::type_id::create("driver", this);
  end

  
endfunction: build_phase


function void gfb_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(get_is_active() == UVM_ACTIVE) begin 
    driver.seq_item_port.connect(sequencer.seq_item_export);
    // monitor.command_port.connect(sequencer.command_export);
    monitor.transaction_port.connect(subscriber.analysis_export);
  end
  
endfunction: connect_phase

