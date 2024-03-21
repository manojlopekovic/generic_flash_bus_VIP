/*-----------------------------------------------------------------
File name     : gfb_agent.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Agent class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_agent#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_agent;

  // Config
  gfb_config cfg;

  // Properties

  // Registration
  `uvm_component_param_utils(gfb_agent#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

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
  if(!uvm_config_db#(gfb_config)::get(this, "", "agt_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in agent")
  
  uvm_config_db#(gfb_config)::set(this, "monitor", "monitor_cfg", cfg);
  monitor = gfb_monitor::type_id::create("monitor", this);
  subscriber = gfb_subscriber::type_id::create("subscriber", this);
  if(get_is_active() == UVM_ACTIVE) begin 
    
    uvm_config_db#(gfb_config)::set(this, "sequencer", "sequencer_cfg", cfg);
    uvm_config_db#(gfb_config)::set(this, "driver", "driver_cfg", cfg);

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

