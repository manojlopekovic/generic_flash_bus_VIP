/*-----------------------------------------------------------------
File name     : gfb_item.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence item
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_item#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequence_item;

  typedef enum {ADDR_PHASE, DATA_PHASE, COLLECTED_OK, ERROR_ADDR, ERROR_DATA} t_ItemState;

  // Interface properties
  rand gfb_config::t_AgtType it_type;

  // Master properties
  rand bit [ADDR_WIDTH-1:0] FADDR;
  rand gfb_config::t_CommandType FCMD;
  rand bit [WRITE_WIDTH-1:0] FWDATA;
  rand bit abort_happening;
  rand int unsigned abort_after;
  rand bit burst_happening;
  rand int unsigned burst_size;


  // Slave properties
  rand bit [READ_WIDTH-1:0] FRDATA;
  rand bit error_happening;
  rand int unsigned error_after;
  rand bit wait_happening;
  rand int unsigned wait_states;

  // Non-random properties

  // Monitor properties
  t_ItemState item_state = ADDR_PHASE;

  // Registration
  `uvm_object_param_utils_begin(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))
    `uvm_field_enum(gfb_config::t_AgtType, it_type, UVM_ALL_ON)
    `uvm_field_enum(t_ItemState, item_state, UVM_ALL_ON)
    `uvm_field_int(FADDR, UVM_ALL_ON)
    `uvm_field_enum(gfb_config::t_CommandType, FCMD, UVM_ALL_ON)
    `uvm_field_int(FWDATA, UVM_ALL_ON)
    `uvm_field_int(abort_happening, UVM_ALL_ON)
    `uvm_field_int(abort_after, UVM_ALL_ON)
    `uvm_field_int(burst_happening, UVM_ALL_ON)
    `uvm_field_int(burst_size, UVM_ALL_ON)
    `uvm_field_int(FRDATA, UVM_ALL_ON)
    `uvm_field_int(error_happening, UVM_ALL_ON)
    `uvm_field_int(error_after, UVM_ALL_ON)
    `uvm_field_int(wait_happening, UVM_ALL_ON)
    `uvm_field_int(wait_states, UVM_ALL_ON)
  `uvm_object_utils_end

  // Components

  // Constructor
  function new (string name = "gfb_item");
    super.new(name);
  endfunction : new

  // Constraints
  constraint master_constr {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    if(it_type == gfb_config::MASTER){
      soft FRDATA == '0;
      soft error_happening == '0;
      soft error_after == '0;
      soft wait_happening == '0;
      soft wait_states == '0;
    }
    if(abort_happening == 0){
      abort_after == 0;
    }
    abort_after >= 0;
  }

  constraint slave_constr {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    if(it_type == gfb_config::SLAVE){
      soft FADDR == '0;
      soft FCMD == '0;
      soft FWDATA == '0;
      soft abort_happening == '0;
      soft abort_after == '0;
      soft burst_happening == '0;
      soft burst_size == '0;
    }
    if(error_happening == 0){
      error_after == 0;
    }
    if(wait_happening == 0){
      wait_states == 0;
    }
    error_after >= 0;
    wait_states >= 0;
  }
  

  // Functions
  function void post_randomize();

  endfunction: post_randomize

  
  function void pre_randomize();

  endfunction: pre_randomize

  // Tasks
endclass //gfb_item extends uvm_sequencegfb_item