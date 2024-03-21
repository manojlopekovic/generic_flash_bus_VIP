/*-----------------------------------------------------------------
File name     : gfb_item.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence item
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_item#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequence_item;

  // Interface properties
  // Master properties
  rand bit [ADDR_WIDTH-1:0] FADDR;
  rand gfb_config::t_CommandType FCMD;
  rand bit [WRITE_WIDTH-1:0] FWDATA;
  rand gfb_config::t_Abort FABORT;

  // Slave properties
  rand bit [READ_WIDTH-1:0] FRDATA;
  rand gfb_config::t_Ready FREADY;
  rand gfb_config::t_Resp FRESP;

  // Non-random properties

  // Control properties

  // Registration
  `uvm_object_param_utils_begin(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))
    `uvm_field_int(FADDR, UVM_ALL_ON)
    `uvm_field_enum(gfb_config::t_CommandType, FCMD, UVM_ALL_ON)
    `uvm_field_int(FWDATA, UVM_ALL_ON)
    `uvm_field_enum(gfb_config::t_Abort, FABORT, UVM_ALL_ON)
    `uvm_field_int(FRDATA, UVM_ALL_ON)
    `uvm_field_enum(gfb_config::t_Ready, FREADY, UVM_ALL_ON)
    `uvm_field_enum(gfb_config::t_Resp, FRESP, UVM_ALL_ON)
  `uvm_object_utils_end

  // Components

  // Constructor
  function new (string name = "gfb_item");
    super.new(name);
  endfunction : new

  // Constraints

  // Functions
  function void post_randomize();

  endfunction: post_randomize

  
  function void pre_randomize();

  endfunction: pre_randomize

  // Tasks
endclass //gfb_item extends uvm_sequencegfb_item