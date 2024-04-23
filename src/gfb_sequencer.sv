/*-----------------------------------------------------------------
File name     : gfb_sequencer.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequencer class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_sequencer#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequencer#(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH));

  // Config
  gfb_config cfg;

  // Properties

  // Registration
  `uvm_component_param_utils(gfb_sequencer#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Ports
  // // Reactive slave ports and FIFO
  uvm_analysis_export #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_export;
  uvm_tlm_analysis_fifo #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_fifo;

  // Components

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

endclass //_monitor extends uvm_monitor


function void gfb_sequencer::build_phase(uvm_phase phase);
  if(!uvm_config_db#(gfb_config)::get(this, "", "sequencer_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in sequencer")

  if(cfg.agent_type == gfb_config::SLAVE) begin
    command_fifo = new("command_fifo", this);
    command_export = new("command_export", this);
  end
  
endfunction: build_phase


function void gfb_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(cfg.agent_type == gfb_config::SLAVE)
    command_export.connect(command_fifo.analysis_export);
endfunction: connect_phase


