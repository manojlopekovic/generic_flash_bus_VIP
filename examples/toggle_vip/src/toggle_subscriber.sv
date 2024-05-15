/*-----------------------------------------------------------------
File name     : _subscriber.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : File that holds all master side sequences
Notes         : 
Date          : 28.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_subscriber extends uvm_subscriber#(toggle_item);

  // Properties
  toggle_item itemForCoverage;

  // Config
  // _config_class _config;

  // Covergroups 

  // Registration
  `uvm_component_utils(toggle_subscriber)
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);

    // if(!uvm_config_db#(gfb_agent_config_class)::get(this, "", "_config", _config))
    //   `uvm_fatal(get_full_name(), "Failed to get config in subscriber")
  endfunction //new()

  extern virtual function void write(toggle_item t);

endclass

function void toggle_subscriber::write(toggle_item t);
  $cast(itemForCoverage, t.clone());
  // cg_Example.sample();
  `uvm_info(get_full_name(), $sformatf("SUBSCRIBER GOT ITEM : %s \n", itemForCoverage.sprint()), UVM_HIGH);
endfunction : write