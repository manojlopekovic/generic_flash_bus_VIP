/*-----------------------------------------------------------------
File name     : gfb_config.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Configuration class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_config#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_object;

  typedef enum {MASTER, SLAVE} t_AgtType;
  typedef enum bit[2:0] {IDLE = 3'b000, READ = 3'b001, WRITE = 3'b010, ROW_WRITE = 3'b011, ERASE = 3'b100, MASS_ERASE = 3'b111} t_CommandType;
  typedef enum bit {NO_ABORT = 0, ABORT = 1} t_Abort;
  typedef enum bit {NOT_READY = 0, READY = 1} t_Ready;
  typedef enum bit {OKAY = 0, ERROR = 1} t_Resp; 
  
  // Config parameters
  uvm_active_passive_enum is_active_agent = UVM_ACTIVE;
  rand t_AgtType agent_type;

  // endianesss

  // Registration 

  `uvm_object_param_utils_begin(gfb_config#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))
    `uvm_field_enum(t_AgtType, agent_type, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "");
    super.new(name);
  endfunction

  // Constraints
  

endclass //gfb_agent_config_clas extends uvm_object