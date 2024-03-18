/*-----------------------------------------------------------------
File name     : gfb_virt_seqr.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequencer
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_virt_seqr extends uvm_sequencer;

  // Properties
  // gfb_env_config_class env_config;
  // gfb_agent_config_class agt_config_m;
  // gfb_agent_config_class agt_config_s;

  // Sequencers
  gfb_sequencer sequencer;

  // Registration
  `uvm_component_utils(gfb_virt_seqr)

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction //new()

  // Phases
  function void build_phase(uvm_phase phase);
    // if(!uvm_config_db#(gfb_env_config_class)::get(this, "", "env_config", env_config))
    //   `uvm_fatal(get_full_name(), "Failed to get env_config in virtual sequencer")
    // if(!uvm_config_db#(gfb_agent_config_class)::get(this, "", "agent_config_m", agt_config_m))
    //   `uvm_fatal(get_full_name(), "Failed to get agentConfig in virtual sequencer")
    // if(!uvm_config_db#(gfb_agent_config_class)::get(this, "", "agent_config_s", agt_config_s))
    //   `uvm_fatal(get_full_name(), "Failed to get agentConfig in virtual sequencer")
  endfunction: build_phase
  

endclass //gfbgfb_virt_seqr extends uvm_sequencer