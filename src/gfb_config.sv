/*-----------------------------------------------------------------
File name     : gfb_config.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Configuration class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_config#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_object;

  typedef enum bit {MASTER, SLAVE} t_AgtType;
  typedef enum bit[2:0] {IDLE = 3'b000, READ = 3'b001, WRITE = 3'b010, ROW_WRITE = 3'b011, ERASE = 3'b100, MASS_ERASE = 3'b111} t_CommandType;
  typedef enum bit {NO_ABORT = 0, ABORT = 1} t_Abort;
  typedef enum bit {NOT_READY = 0, READY = 1} t_Ready;
  typedef enum bit {OKAY = 0, ERROR = 1} t_Resp; 
  typedef enum {INACTIVE_ZERO, INACTIVE_ONE, INACTIVE_X, INACTIVE_Z} t_InactiveVal;
  typedef enum {LITTLE_ENDIAN, BIG_ENDIAN} t_Endian;

  
  // Config parameters
  uvm_active_passive_enum is_active_agent = UVM_ACTIVE;
  t_InactiveVal inactive_value = INACTIVE_X;

  // #### BOTH ####
  // Specifies type of agent that gets this configuration
  rand t_AgtType agent_type;
  // Specifies weather coverage will be collected in this agent, as it is subscriber based
  rand bit coverage_on = '1;
  rand t_Endian endianness = LITTLE_ENDIAN; 
  
  // #### MASTER ####
  // Used only for row_write
  rand bit burst_en = '1;
  rand int unsigned max_burst_size;
  rand int unsigned master_rate_idle;
  rand int unsigned master_rate_write;
  rand int unsigned master_rate_row_write;
  rand int unsigned master_rate_read;
  rand int unsigned master_rate_erase;
  rand int unsigned master_rate_mass_erase;
  rand bit master_abort_en = '1;
  rand int unsigned master_abort_rate;
  rand int unsigned max_waits_for_abort;

  // #### SLAVE ####
  rand bit slave_error_en = '1;
  rand int unsigned slave_error_rate;
  rand bit slave_wait_state_en = '1;
  rand int unsigned max_wait_states_allowed;
  rand int unsigned slave_wait_state_rate;
  rand bit mem_model_exists = '1;

  // endianesss

  // Registration 

  `uvm_object_param_utils_begin(gfb_config#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))
    `uvm_field_enum(t_InactiveVal, inactive_value, UVM_ALL_ON)
    `uvm_field_enum(t_AgtType, agent_type, UVM_ALL_ON)
    `uvm_field_int(coverage_on, UVM_ALL_ON)
    `uvm_field_enum(t_Endian, endianness, UVM_ALL_ON)
    `uvm_field_int(burst_en, UVM_ALL_ON)
    `uvm_field_int(max_burst_size, UVM_ALL_ON)
    `uvm_field_int(master_rate_idle, UVM_ALL_ON)
    `uvm_field_int(master_rate_write, UVM_ALL_ON)
    `uvm_field_int(master_rate_row_write, UVM_ALL_ON)
    `uvm_field_int(master_rate_read, UVM_ALL_ON)
    `uvm_field_int(master_rate_erase, UVM_ALL_ON)
    `uvm_field_int(master_rate_mass_erase, UVM_ALL_ON)
    `uvm_field_int(master_abort_en, UVM_ALL_ON)
    `uvm_field_int(master_abort_rate, UVM_ALL_ON)
    `uvm_field_int(max_waits_for_abort, UVM_ALL_ON)
    `uvm_field_int(slave_error_en, UVM_ALL_ON)
    `uvm_field_int(slave_error_rate, UVM_ALL_ON)
    `uvm_field_int(slave_wait_state_en, UVM_ALL_ON)
    `uvm_field_int(max_wait_states_allowed, UVM_ALL_ON)
    `uvm_field_int(slave_wait_state_rate, UVM_ALL_ON)
    `uvm_field_int(mem_model_exists, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "");
    super.new(name);
  endfunction

  // Constraints
  constraint base {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    soft inactive_value == INACTIVE_X;
    soft endianness == LITTLE_ENDIAN;
    soft coverage_on == '1;
  }

  constraint base_slave {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    slave_error_rate inside {[0:100]};
    slave_wait_state_rate inside {[0:100]};
    soft max_wait_states_allowed == 1024;
  }

  constraint base_master {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    soft max_waits_for_abort == 128;
    soft max_burst_size == 1024;
    master_abort_rate inside {[0:100]};

    master_rate_idle inside {[0:100]};
    master_rate_erase inside {[0:100]};
    master_rate_mass_erase inside {[0:100]};
    master_rate_row_write inside {[0:100]};
    master_rate_write inside {[0:100]};
    master_rate_read inside {[0:100]};

    master_rate_idle + master_rate_erase + master_rate_mass_erase + master_rate_read + master_rate_row_write + master_rate_write == 100;
  }
  

endclass //gfb_agent_config_clas extends uvm_object