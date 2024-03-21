/*-----------------------------------------------------------------
File name     : gfb_driver.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Driver class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

`define MASTER_IF vif.master_cb
`define SLAVE_IF vif.slave_cb

class gfb_driver#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_driver#(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH));

  // Config
  gfb_config cfg;

  // Properties
  virtual gfb_interface vif;

  // Registration
  `uvm_component_param_utils(gfb_driver#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

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

  if(!uvm_config_db#(gfb_config)::get(this, "", "driver_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in driver")

  
endfunction: build_phase


task gfb_driver::run_phase(uvm_phase phase);

  fork
    _standardgfb_driver_operation();
  join

endtask: run_phase

task gfb_driver::_standardgfb_driver_operation();
  @(negedge vif.FRESETn);
  @(posedge vif.FRESETn);
  forever begin 
    seq_item_port.get_next_item(req);
    if(vif.FRESETn == 1'b1) _send_to_if();
    @vif.cb;
    seq_item_port.item_done();
  end
endtask : _standardgfb_driver_operation

function void gfb_driver::_send_to_if();

endfunction : _send_to_if
