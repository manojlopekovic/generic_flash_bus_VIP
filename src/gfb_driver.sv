/*-----------------------------------------------------------------
File name     : gfb_driver.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Driver class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

`define CLK_BLK vif.cb
`define MASTER_IF vif.master_cb
`define SLAVE_IF vif.slave_cb
`define RESETn vif.FRESETn

`define AGT_TYPE cfg.agent_type
`define MASTER_TYPE gfb_config::MASTER
`define SLAVE_TYPE gfb_config::SLAVE

class gfb_driver#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_driver#(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH));

  // Config
  gfb_config cfg;

  // Properties
  virtual gfb_interface vif;
  logic inactive_val;

  // Master helper fields
  gfb_item addr_phase_item;
  gfb_item data_phase_item;

  semaphore phase_mutex;

  // Slave helper fields

  // Registration
  `uvm_component_param_utils(gfb_driver#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    phase_mutex = new(0);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);

  // Functions

  // Master
  extern virtual task master_send_to_if();
  extern virtual function void master_drive_init();
  extern virtual task master_wait_transaction_exit_case();
  extern virtual task master_handle_addr_phase();
  extern virtual task master_drive_addr_phase();
  extern virtual task master_handle_data_phase();
  extern virtual task master_drive_data_phase();

  // Slave
  extern virtual task slave_send_to_if();
  extern virtual function void slave_drive_init();

  // Tasks
  extern virtual task std_driver_op();

endclass //_agent extends uvm_agent


function void gfb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in driver")

  if(!uvm_config_db#(gfb_config)::get(this, "", "driver_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in driver")

  inactive_val =  cfg.inactive_value == gfb_config::INACTIVE_ZERO ?   '0 :
                  cfg.inactive_value == gfb_config::INACTIVE_ONE  ?   '1 :
                  cfg.inactive_value == gfb_config::INACTIVE_X    ?   'X :
                                                                    'Z;

  
endfunction: build_phase


task gfb_driver::run_phase(uvm_phase phase);
  if(`AGT_TYPE == `MASTER_TYPE) 
    master_drive_init();
  else 
    slave_drive_init();

  @(negedge `RESETn);
  @(posedge `RESETn);

  std_driver_op();
endtask: run_phase

task gfb_driver::std_driver_op();
  if(`AGT_TYPE == `MASTER_TYPE) 
    master_send_to_if();
  else 
    slave_send_to_if();
endtask : std_driver_op

// MASTER OP
// ********************************************************************************************

task gfb_driver::master_send_to_if();
  fork
    master_handle_data_phase();
    master_wait_transaction_exit_case();
  join_none
  forever begin 
    master_handle_addr_phase();
  end
endtask : master_send_to_if


task gfb_driver::master_wait_transaction_exit_case();
  forever begin 
    if(`MASTER_IF.FREADY !== '1)
      @(posedge `MASTER_IF.FREADY);
    uvm_event_pool::get_global("transaction_exit_case").trigger();
    @`CLK_BLK;
  end
endtask 


task gfb_driver::master_handle_addr_phase();
  forever begin 
    wait(`RESETn == 1'b1);
    seq_item_port.get_next_item(req);
    if(`RESETn == 1'b1) begin
      master_drive_addr_phase();
    end
    seq_item_port.item_done();
  end
endtask


task gfb_driver::master_drive_addr_phase();
  addr_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("addr_phase_item");
  addr_phase_item.copy(req);
  `MASTER_IF.FADDR <= addr_phase_item.FADDR;
  `MASTER_IF.FCMD <= addr_phase_item.FCMD;
  // drive item to if
  // wait for event, blocking <- from exit case function
  // if necessary, pass item to data_phase via implemented fifo
  // return 
  uvm_event_pool::get_global("transaction_exit_case").wait_trigger();
  data_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("data_phase_item");
  data_phase_item.copy(addr_phase_item);
  phase_mutex.put(1);
endtask


task gfb_driver::master_handle_data_phase();
  forever begin 
    phase_mutex.get(1);
    master_drive_data_phase();
  end
  // forever looped
    // wait for blocking fifo -> when address phase is finished
    // master_drive_data_phase()
    // wait for event, blocking <- signal from exit case function
endtask


task gfb_driver::master_drive_data_phase();
  `MASTER_IF.FWDATA <= data_phase_item.FWDATA;
  // drive data to interface
      // this data will be write data, but also abort
  uvm_event_pool::get_global("transaction_exit_case").wait_trigger();
endtask


function void gfb_driver::master_drive_init();
  `MASTER_IF.FADDR <= {ADDR_WIDTH{inactive_val}};
  `MASTER_IF.FCMD <= {3{inactive_val}};
  `MASTER_IF.FWDATA <= {WRITE_WIDTH{inactive_val}};
  `MASTER_IF.FABORT <= inactive_val;
endfunction : master_drive_init

// ********************************************************************************************

// SLAVE OP
// ********************************************************************************************

task gfb_driver::slave_send_to_if();
  forever begin
    int wait_size;
    `SLAVE_IF.FREADY <= 0;
    std::randomize(wait_size) with { wait_size inside {[0:10]}; };
    repeat(wait_size) @`SLAVE_IF;
    `SLAVE_IF.FREADY <= 1;
    @`SLAVE_IF;
    `SLAVE_IF.FREADY <= 0;
    repeat(wait_size) @`SLAVE_IF;
    `SLAVE_IF.FREADY <= 1;
  end
endtask : slave_send_to_if


function void gfb_driver::slave_drive_init();
  `SLAVE_IF.FRDATA <= {READ_WIDTH{inactive_val}};
  `SLAVE_IF.FREADY <= inactive_val;
  `SLAVE_IF.FRESP <= inactive_val;
endfunction : slave_drive_init

// ********************************************************************************************