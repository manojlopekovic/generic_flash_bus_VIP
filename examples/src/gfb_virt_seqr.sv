/*-----------------------------------------------------------------
File name     : gfb_virt_seqr.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequencer
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_virt_seqr#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequencer;

  // Properties
  // gfb_env_config_class env_config;
  gfb_config master_cfg;
  gfb_config slave_cfg;
  toggle_cfg toggle_cfg;
  clk_conf clk_cfg;
  
  // Virtual interface
  virtual gfb_interface vif;

  // Sequencers
  gfb_sequencer master_sequencer;
  gfb_sequencer slave_sequencer;
  toggle_sequencer reset_sequencer;
  clk_sequencer clock_sequencer;

  // Registration
  `uvm_component_param_utils(gfb_virt_seqr#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction //new()

  // Phases
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(gfb_config)::get(this, "", "master_seqr_cfg", master_cfg))
      `uvm_fatal(get_full_name(), "Failed to get master gfb_config in virtual sequencer")
    if(!uvm_config_db#(gfb_config)::get(this, "", "slave_seqr_cfg", slave_cfg))
      `uvm_fatal(get_full_name(), "Failed to get slave gfb_config in virtual sequencer")
    if(!uvm_config_db#(toggle_cfg)::get(this, "", "toggle_cfg", toggle_cfg))
      `uvm_fatal(get_full_name(), "Failed to get  toggle_cfg in virtual sequencer")
    if(!uvm_config_db#(clk_conf)::get(this, "", "clk_conf", clk_cfg))
      `uvm_fatal(get_full_name(), "Failed to get clk_cfg in virtual sequencer")

    if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
      `uvm_fatal(get_type_name(),"Failed to get interface in driver")


  endfunction: build_phase
  

endclass //gfbgfb_virt_seqr extends uvm_sequencer