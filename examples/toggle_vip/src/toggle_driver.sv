/*-----------------------------------------------------------------
File name     : toggle_driver.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Driver class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_driver extends uvm_driver#(toggle_item);

  // Config
  toggle_cfg cfg;

  // Properties
  virtual toggle_interface vif;

  // Registration
  `uvm_component_utils(toggle_driver)

  // Components

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);

  // Functions
  extern virtual task _send_to_if();

  // Tasks
  extern virtual task _standard_toggle_driver_operation();

endclass //_agent extends uvm_agent


function void toggle_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual toggle_interface)::get(this, "", "vif", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in driver")

  if(!uvm_config_db#(toggle_cfg)::get(this, "", "cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get config in driver")

  
endfunction: build_phase


task toggle_driver::run_phase(uvm_phase phase);

  fork
    _standard_toggle_driver_operation();
  join

endtask: run_phase

task toggle_driver::_standard_toggle_driver_operation();
  forever begin 
    seq_item_port.get_next_item(req);
    repeat(req.delay) @vif.cb;
    _send_to_if();
    // @vif.cb;
    seq_item_port.item_done();
  end
endtask : _standard_toggle_driver_operation

task toggle_driver::_send_to_if();
  if(cfg.drivingType == toggle_cfg::SYNCH_SYNCH || (cfg.drivingType == toggle_cfg::SYNCH_ASYNCH && req.data != cfg.active_val) || (cfg.drivingType == toggle_cfg::ASYNCH_SYNCH && req.data == cfg.active_val)) begin
    vif.cb.data <= req.data;
  end else begin 
    #req.delay_cb;
    vif.data <= req.data;
  end
endtask : _send_to_if
