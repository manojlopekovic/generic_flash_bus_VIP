/*-----------------------------------------------------------------
File name     : toggle_monitor.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Monitor class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_monitor extends uvm_monitor;

  // Config
  toggle_cfg cfg;

  // Properties
  virtual toggle_interface vif;

  // Registration
  `uvm_component_utils(toggle_monitor)

  // Components

  // Ports

  // // Reactive slave port
  // uvm_analysis_port #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_port;

  // Transaction collector port
  uvm_analysis_port #(toggle_item) transaction_port;

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
  extern task _monitor_interface_watcher();

endclass //_monitor extends uvm_monitor


function void toggle_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual toggle_interface)::get(this, "", "vif", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in monitor")
  if(!uvm_config_db#(toggle_cfg)::get(this, "", "cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get config in monitor")

  
endfunction: build_phase


task toggle_monitor::run_phase(uvm_phase phase);
  fork
    _monitor_interface_watcher();
  join
endtask: run_phase


task toggle_monitor::_monitor_interface_watcher();
  toggle_item temp;
  forever begin 
    temp = toggle_item::type_id::create("temp");
    temp.data = vif.cb.data;
    `uvm_info(get_full_name(), $sformatf("Item on the interface : \n %s", temp.sprint()), UVM_HIGH)
    transaction_port.write(temp);
    @vif.cb.data;
  end
endtask: _monitor_interface_watcher

