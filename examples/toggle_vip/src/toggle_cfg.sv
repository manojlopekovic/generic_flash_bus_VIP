/*-----------------------------------------------------------------
File name     : toggle_cfg.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Configuration class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class toggle_cfg extends uvm_object;

  // typedefs
  typedef enum bit[2:0] {SYNCH, ASYNCH, SYNCH_SYNCH, SYNCH_ASYNCH, ASYNCH_ASYNCH, ASYNCH_SYNCH} t_ToggleType;

  // Config parameters
  uvm_active_passive_enum is_active_agent = UVM_ACTIVE;

  // 
  rand bit active_val = 1;
  rand t_ToggleType drivingType;


  // Registration 

  `uvm_object_param_utils_begin(toggle_cfg)
    `uvm_field_enum(uvm_active_passive_enum, is_active_agent, UVM_ALL_ON)
    `uvm_field_int(active_val, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "");
    super.new(name);
  endfunction

  // Constraints
  constraint base {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    soft active_val == 1;
  }

endclass //gfb_agent_config_clas extends uvm_object