/*-----------------------------------------------------------------
File name     : _sequencer.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequencer class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class clk_sequencer extends uvm_sequencer#(clk_item);

  // Config
  // _config_class _config;

  // Properties

  // Registration
  `uvm_component_utils(clk_sequencer)

  // Ports
  // // Reactive slave ports and FIFO
  // uvm_analysis_export #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_export;
  // uvm_tlm_analysis_fifo #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_fifo;

  // Components

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // command_fifo = new("command_fifo", this);
    // command_export = new("command_export", this);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: connect_phase
  extern function void connect_phase(uvm_phase phase);

  // Functions

  // Tasks

endclass //_monitor extends uvm_monitor


function void clk_sequencer::build_phase(uvm_phase phase);
  // if(!uvm_config_db#(_config_class)::get(this, "", "_config", _config))
  //   `uvm_fatal(get_full_name(), "Failed to get config in sequencer")
  
endfunction: build_phase


function void clk_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  // command_export.connect(command_fifo.analysis_export);
endfunction: connect_phase


