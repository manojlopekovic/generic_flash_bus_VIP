/*-----------------------------------------------------------------
File name     : _monitor.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Monitor class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class clk_monitor extends uvm_monitor;

  // Config
  // _config_class _config;

  // Properties
  virtual clk_if vif;

  // Registration
  `uvm_component_utils(clk_monitor)

  // Components

  // Ports

  // // Reactive slave port
  // uvm_analysis_port #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_port;

  // Transaction collector port
  uvm_analysis_port #(clk_item) transaction_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // command_port = new("command_port", this);
    transaction_port = new("transaction_port", this);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);

  // Functions

  // Tasks

endclass //_monitor extends uvm_monitor


function void clk_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual clk_if)::get(this, "", "clk_if", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in clk monitor")
  // if(!uvm_config_db#(_config_class)::get(this, "", "_config", _config))
  //   `uvm_fatal(get_full_name(), "Failed to get config in monitor")
endfunction: build_phase
