/*-----------------------------------------------------------------
File name     : gfb_scoreboard.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Scoreboard
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_scoreboard#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_scoreboard;

  // Config
  // _env_config_class _env_config;

  // Properties
  int numTransactions;

  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) masterItem;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) slaveItem;

  // Report numbers

  // Ports
  uvm_analysis_export #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) masterPort;
  uvm_tlm_analysis_fifo #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) masterFIFO;
  uvm_analysis_export #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) slavePort;
  uvm_tlm_analysis_fifo #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) slaveFIFO;

  // Registration
  `uvm_component_param_utils(gfb_scoreboard#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Constructor
  function new(string name="gfbgfb_scoreboard",uvm_component parent);
    super.new(name,parent);
  endfunction : new

  // Phases
  
  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: connect_phase
  extern function void connect_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);
  //  Function: report_phase
  extern function void report_phase(uvm_phase phase);
  //  Function: check_phase
  extern function void check_phase(uvm_phase phase);
  //  Function: shutdown_phase
  extern task shutdown_phase(uvm_phase phase);
  
  // Functions
  extern function void compare_items();

  // Tasks
  extern task _standard_scoreboard_operation();

endclass //gfb_scoreboard extends uvmgfb_scoreboard


function void gfb_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // if(!uvm_config_db#(gfb_env_config_class)::get(this, "", "_env_config", _env_config))
  //   `uvm_fatal(get_full_name(), "Failed to get env_config in env")
  
  masterPort = new("masterPort", this);
  masterFIFO = new("masterFIFO", this);
  slavePort = new("slavePort", this);
  slaveFIFO = new("slaveFIFO", this);
endfunction: build_phase


function void gfb_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  masterPort.connect(masterFIFO.analysis_export);
  slavePort.connect(slaveFIFO.analysis_export);
endfunction: connect_phase


task gfb_scoreboard::run_phase(uvm_phase phase);
  _standard_scoreboard_operation();
endtask: run_phase


task gfb_scoreboard::shutdown_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_name(), "<shutdown_phase> started, objection raised.", UVM_NONE)

  // #1000;

  phase.drop_objection(this);
  `uvm_info(get_name(), "<shutdown_phase> finished, objection dropped.", UVM_NONE)
endtask: shutdown_phase



function void gfb_scoreboard::check_phase(uvm_phase phase);
  super.check_phase(phase);
  
endfunction: check_phase


function void gfb_scoreboard::report_phase(uvm_phase phase);
  super.report_phase(phase);
  
endfunction: report_phase


task gfb_scoreboard::_standard_scoreboard_operation();
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) hlpItem1;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) hlpItem2;
  
  numTransactions = 0;
  
  hlpItem1 = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("hlpItem1");
  hlpItem1 = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("hlpItem2");
  masterItem = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("masterItem");
  slaveItem = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("slaveItem");

  forever begin
    // Todo : this fork should be in function 
    fork
      begin 
        masterFIFO.get(hlpItem1);
        $cast(masterItem, hlpItem1.clone());
        `uvm_info(get_full_name(), $sformatf("SCOREBOARD MASTER ITEM : \n %s", masterItem.sprint()), UVM_LOW)
      end
      begin 
        slaveFIFO.get(hlpItem2);
        $cast(slaveItem, hlpItem2.clone());
        `uvm_info(get_full_name(), $sformatf("SCOREBOARD SLAVE ITEM : \n %s", slaveItem.sprint()), UVM_LOW)
      end
    join
    compare_items();
    numTransactions++;
    // Todo : reference model checks
  end
endtask: _standardgfb_scoreboard_operation


function void gfb_scoreboard::compare_items();

endfunction

