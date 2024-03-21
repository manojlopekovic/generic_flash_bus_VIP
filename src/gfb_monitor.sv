/*-----------------------------------------------------------------
File name     : gfb_monitor.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Monitor class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

`define MASTER_IF vif.master_cb
`define SLAVE_IF vif.slave_cb

class gfb_monitor#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_monitor;

  // Config
  gfb_config cfg;

  // Properties
  virtual gfb_interface vif;

  // Registration
  `uvm_component_param_utils(gfb_monitor#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components

  // Ports

  // // Reactive slave port
  // uvm_analysis_port #(gfbgfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_port;

  // Transaction collector port
  uvm_analysis_port #(gfb_item) transaction_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // command_port = new("command_port", this);
    transaction_port = new("transaction_port", this);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);

  // Functions

  // Tasks
  extern task gfb_monitorgfb_interface_watcher();
  extern task gfb_monitor_reset_watcher();

endclass //gfb_monitor extends uvmgfb_monitor


function void gfb_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in monitor")

  if(!uvm_config_db#(gfb_config)::get(this, "", "monitor_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in monitor")

  
endfunction: build_phase


task gfb_monitor::run_phase(uvm_phase phase);
  fork
    gfb_monitorgfb_interface_watcher();
    gfb_monitor_reset_watcher();
  join
endtask: run_phase


task gfb_monitor::gfb_monitorgfb_interface_watcher();
  gfb_item temp;
  forever begin 
    temp = new("temp");
    @vif.cb;
  end
endtask: gfb_monitorgfb_interface_watcher


task gfb_monitor::gfb_monitor_reset_watcher();
  forever begin 
    @(negedge vif.FRESETn);
    @(posedge vif.FRESETn);
    uvm_event_pool::get_global("reset_happened_ev").trigger();
  end
endtask: gfb_monitor_reset_watcher
