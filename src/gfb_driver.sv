/*-----------------------------------------------------------------
File name     : gfb_driver.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Driver class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_driver extends uvm_driver#(gfb_item);

  // Config
  // _config_class _config;

  // Properties
  virtual gfb_interface vif;

  // Registration
  `uvm_component_utils(gfb_driver)

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
  extern virtual function void _send_to_if();

  // Tasks
  extern virtual task _standardgfb_driver_operation();

endclass //_agent extends uvm_agent


function void gfb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in driver")

  // if(!uvm_config_db#(_config_class)::get(this, "", "_config", _config))
  //   `uvm_fatal(get_full_name(), "Failed to get config in driver")

  
endfunction: build_phase


task gfb_driver::run_phase(uvm_phase phase);

  fork
    _standardgfb_driver_operation();
  join

endtask: run_phase

task gfb_driver::_standardgfb_driver_operation();
  @(negedge vif.resetn);
  @(posedge vif.resetn);
  forever begin 
    seq_item_port.get_next_item(req);
    if(vif.resetn == 1'b1) _send_to_if();
    @vif.cb;
    seq_item_port.item_done();
  end
endtask : _standardgfb_driver_operation

function void gfb_driver::_send_to_if();
  vif.cb.data <= req.data;
endfunction : _send_to_if
