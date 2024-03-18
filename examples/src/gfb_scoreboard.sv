/*-----------------------------------------------------------------
File name     : gfb_scoreboard.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Scoreboard
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_scoreboard extends uvm_scoreboard;

  // Config
  // _env_config_class _env_config;

  // Properties

  // Report numbers

  // Ports
  uvm_analysis_export #(gfb_item) masterPort;
  uvm_tlm_analysis_fifo #(gfb_item) masterFIFO;
  // uvm_analysis_export #(gfb_item #(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) slavePort;
  // uvm_tlm_analysis_fifo #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) slaveFIFO;

  // Registration
  `uvm_component_utils(gfb_scoreboard)

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

  // Tasks
  extern task _standard_scoreboard_operation();

endclass //gfb_scoreboard extends uvmgfb_scoreboard


function void gfb_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // if(!uvm_config_db#(gfb_env_config_class)::get(this, "", "_env_config", _env_config))
  //   `uvm_fatal(get_full_name(), "Failed to get env_config in env")
  
  masterPort = new("masterPort", this);
  masterFIFO = new("masterFIFO", this);
  // slavePort = new("slavePort", this);
  // slaveFIFO = new("slaveFIFO", this);
endfunction: build_phase


function void gfb_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  masterPort.connect(masterFIFO.analysis_export);
  // slavePort.connect(slaveFIFO.analysis_export);
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

endtask: _standardgfb_scoreboard_operation


