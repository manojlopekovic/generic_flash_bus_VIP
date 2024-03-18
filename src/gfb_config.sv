/*-----------------------------------------------------------------
File name     : gfb_config.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Configuration class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_config extends uvm_object;

  
  // Config parameters

  uvm_active_passive_enum is_active_agent = UVM_ACTIVE;

  // Registration 

  `uvm_object_utils_begin(gfb_config)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "");
    super.new(name);
  endfunction

  // Constraints
  

endclass //gfb_agent_config_clas extends uvm_object