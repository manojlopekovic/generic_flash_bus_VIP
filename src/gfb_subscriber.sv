/*-----------------------------------------------------------------
File name     : gfb_subscriber.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Subscriber class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_subscriber#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_subscriber#(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH));

  // Properties
  gfb_item itemForCoverage;

  // Config
  // _config_class _config;

  // Covergroups 

  // Registration
  `uvm_component_param_utils(gfb_subscriber#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);

    // if(!uvm_config_db#(gfb_agent_config_class)::get(this, "", "_config", _config))
    //   `uvm_fatal(get_full_name(), "Failed to get config in subscriber")
  endfunction //new()

  extern virtual function void write(gfb_item t);

endclass

function void gfb_subscriber::write(gfb_item t);
  $cast(itemForCoverage, t.clone());
  // cg_Example.sample();
  `uvm_info(get_full_name(), $sformatf("SUBSCRIBER GOT ITEM : %s \n", itemForCoverage.sprint()), UVM_HIGH);
endfunction : write