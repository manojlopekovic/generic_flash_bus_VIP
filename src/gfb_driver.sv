/*-----------------------------------------------------------------
File name     : gfb_driver.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Driver class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/


class gfb_driver#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_driver#(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH));

  // Config
  gfb_config cfg;

  // Properties
  virtual gfb_interface vif;
  logic inactive_val;

  // Master helper fields
  gfb_item addr_phase_item;
  gfb_item data_phase_item;
  gfb_item error_item;
  int data_item_finished = 1;
  gfb_item rsp_queue [$];

  semaphore phase_mutex;
  semaphore data_mutex;

  event driver_transaction_exit_case_ev;

  process proc_handle_driving;

  // Slave helper fields
  bit item_in_data_phase = 0;
  gfb_item slave_item;

  // Registration
  `uvm_component_param_utils(gfb_driver#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    phase_mutex = new(0);
    data_mutex = new(0);
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
  extern virtual function void master_drive_reset();
  extern virtual task master_wait_driver_transaction_exit_case();
  extern virtual task master_handle_addr_phase();
  extern virtual task master_drive_addr_phase();
  extern virtual task master_handle_data_phase();
  extern virtual task master_drive_data_phase();
  extern virtual task master_send_rsp(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) item); 
  extern virtual task master_send_rsp_error(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) item);
  extern virtual task master_handle_recieve_item();
  extern virtual task master_handle_reset();
  extern virtual task master_drive_abort();

  // Slave
  extern virtual task slave_send_to_if();
  extern virtual function void slave_drive_init();
  extern virtual function void slave_drive_reset();
  extern virtual task slave_handle_seq();
  extern virtual task slave_drive_error();
  extern virtual task slave_drive_response();

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
    slave_handle_seq();
endtask : std_driver_op

// MASTER OP
// ********************************************************************************************

task gfb_driver::master_send_to_if();
  fork
    // master_handle_data_phase();
    master_wait_driver_transaction_exit_case();
  join_none
  forever begin
    fork 
      master_handle_addr_phase();
      master_handle_reset();
    join_any
    // disable fork;
    master_drive_reset();
  end
endtask : master_send_to_if


task gfb_driver::master_wait_driver_transaction_exit_case();
  forever begin 
    if(`MASTER_IF.FREADY !== '1) begin 
      if(`MASTER_IF.FRESP !== '1) begin 
        fork
          @(posedge `MASTER_IF.FRESP);
          @(posedge `MASTER_IF.FREADY);
          @(negedge `RESETn);
        join_any
        disable fork;
      end
    end
    // uvm_event_pool::get_global("driver_transaction_exit_case_ev").trigger();
    ->driver_transaction_exit_case_ev; 
    wait(`RESETn == 1);
    @`CLK_BLK;
  end
endtask 


task gfb_driver::master_handle_addr_phase();
  proc_handle_driving = process::self();
  forever begin 
    wait(`RESETn == 1);
    addr_phase_item = null;
    if(data_phase_item) begin 
      fork
        begin
          @driver_transaction_exit_case_ev;
          master_handle_data_phase();
          phase_mutex.put(1);
          // master_drive_data_phase();
        end
        begin
          master_handle_recieve_item();
          phase_mutex.get(1);
          // master_drive_init();
          // master_handle_data_phase();
          master_drive_data_phase();
        end
      join
    end else begin 
      master_handle_recieve_item();
      master_handle_data_phase();
      master_drive_data_phase();
    end
  end
endtask


task gfb_driver::master_handle_recieve_item();
  seq_item_port.get_next_item(req);
  addr_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("addr_phase_item");
  addr_phase_item.copy(req);
  addr_phase_item.set_id_info(req);
  master_drive_addr_phase();
  seq_item_port.item_done();
  @driver_transaction_exit_case_ev;
  master_drive_init();
endtask


task gfb_driver::master_drive_addr_phase();
  if(`RESETn == 1) begin
    `MASTER_IF.FADDR <= addr_phase_item.FADDR;
    `MASTER_IF.FCMD <= addr_phase_item.FCMD;
  end
endtask


task gfb_driver::master_handle_data_phase();
  if(`RESETn == 1 && data_phase_item) begin 
    if(`MASTER_IF.FREADY == 1)
      data_phase_item.item_state = gfb_item::COLLECTED_OK;
    else if (`MASTER_IF.FRESP == 1) 
      if(`MASTER_IF.FABORT == 1)
        data_phase_item.item_state = gfb_item::ABORT_DATA;
      else
        data_phase_item.item_state = gfb_item::ERROR_DATA;
    else
      data_phase_item.item_state = gfb_item::RESET_DATA;
    master_send_rsp(data_phase_item);
    data_phase_item = null;
  end
endtask


task gfb_driver::master_drive_data_phase();
  if(`RESETn == 1) begin
    if(`MASTER_IF.FREADY == 1) begin 
      data_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("data_phase_item");
      data_phase_item.copy(addr_phase_item);
      data_phase_item.set_id_info(addr_phase_item);
      if(data_phase_item.FCMD != gfb_config::IDLE && cfg.master_abort_en == 1)
        master_drive_abort();
      if(addr_phase_item.FCMD == gfb_config::WRITE || addr_phase_item.FCMD == gfb_config::ROW_WRITE) begin
        `MASTER_IF.FWDATA <= addr_phase_item.FWDATA;
      end
    end else if(`MASTER_IF.FRESP == 1) begin 
      if(`MASTER_IF.FABORT == 1)
        addr_phase_item.item_state = gfb_item::ABORT_ADDR;
      else
        addr_phase_item.item_state = gfb_item::ERROR_ADDR;
      master_send_rsp_error(addr_phase_item);
    end
  end
endtask

// Todo : decide if its okay for abort not to go low. In the spec, abort must go low after correct handling of abort, but what if we want to abort new accepted instruction immediately, is it possible?
task gfb_driver::master_drive_abort();
  fork
    begin 
      fork
        @driver_transaction_exit_case_ev;
        begin 
          repeat(data_phase_item.abort_after) @`CLK_BLK;
          if(`MASTER_IF.FABORT === 0) 
            `MASTER_IF.FABORT <= 1;
        end
      join_any
      disable fork;
    end
  join_none
endtask


task gfb_driver::master_send_rsp_error(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) item);
  fork 
    begin 
      error_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("error_item");
      error_item.copy(item);
      error_item.set_id_info(item);
      @`CLK_BLK;
      master_send_rsp(error_item);
      error_item = null;
    end 
  join_none
endtask


task gfb_driver::master_send_rsp(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) item); 
  rsp = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("rsp");
  rsp.copy(item);
  rsp.set_id_info(item);
  seq_item_port.put(rsp);
endtask


function void gfb_driver::master_drive_init();
  `MASTER_IF.FADDR <= {ADDR_WIDTH{inactive_val}};
  `MASTER_IF.FCMD <= gfb_config::IDLE;
  `MASTER_IF.FWDATA <= {WRITE_WIDTH{inactive_val}};
  `MASTER_IF.FABORT <= `MASTER_IF.FABORT === '1 && `MASTER_IF.FREADY === '0 ? '1 : 0;
endfunction : master_drive_init


function void gfb_driver::master_drive_reset();
  vif.FADDR <= {ADDR_WIDTH{inactive_val}};
  vif.FCMD <= gfb_config::IDLE;
  vif.FWDATA <= {WRITE_WIDTH{inactive_val}};
  vif.FABORT <= 0;
endfunction : master_drive_init


task gfb_driver::master_handle_reset();
  @(negedge `RESETn);
  master_drive_reset();
  if(data_phase_item) begin 
    data_phase_item.item_state = gfb_item::RESET_DATA;
    master_send_rsp(data_phase_item);
    data_phase_item = null;
  end
  if(error_item) begin 
    error_item.item_state = gfb_item::RESET_ADDR;
    master_send_rsp(error_item);
  end
  if(addr_phase_item) begin 
    // seq_item_port.item_done();
    addr_phase_item.item_state = gfb_item::RESET_ADDR;
    master_send_rsp(addr_phase_item);
  end
  if(proc_handle_driving.status != process::FINISHED)
    proc_handle_driving.kill();
endtask
// ********************************************************************************************

// SLAVE OP
// ********************************************************************************************
task gfb_driver::slave_handle_seq();
  forever begin
    wait(`RESETn == 1'b1);
    fork
      begin
        forever begin
          seq_item_port.get_next_item(req);
          `uvm_info("S_DRV_REC", $sformatf("Slave driver recieved item: %s\n", req.sprint()), UVM_HIGH)
          slave_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("slave_item");
          slave_item.copy(req);
          seq_item_port.item_done(); 
          if(`RESETn == 1'b1) begin
            slave_send_to_if();
          end
        end
      end
      begin 
        @(negedge `RESETn);
        slave_drive_reset();
      end
    join_any
    disable fork;
  end
endtask


task gfb_driver::slave_send_to_if();
  `SLAVE_IF.FREADY <= 0;
  `SLAVE_IF.FRESP <= 0;
  `SLAVE_IF.FRDATA <= 'X;

  if(slave_item.item_state == gfb_item::ADDR_PHASE) begin 
    repeat(req.wait_states) @`CLK_BLK;
    `SLAVE_IF.FREADY <= 1;
  end else begin 
    if(`SLAVE_IF.FABORT === 0 || (`SLAVE_IF.FABORT === 1 && `SLAVE_IF.FREADY === 1)) begin
      fork
        if(`SLAVE_IF.FABORT === 0 || (`SLAVE_IF.FABORT === 1 && `SLAVE_IF.FREADY === 1))
          @(posedge `SLAVE_IF.FABORT);
        slave_drive_response();
      join_any
      if(`SLAVE_IF.FABORT == 1 && `SLAVE_IF.FRESP == 1)
        wait fork;
      else
        disable fork;
    end else begin 
      slave_drive_response();
    end
  end
endtask : slave_send_to_if


task gfb_driver::slave_drive_response();
  if(req.error_happening) begin 
    repeat(req.error_after) @`CLK_BLK;
    `SLAVE_IF.FRESP <= 1;
    @`CLK_BLK;
  end else 
    repeat(req.wait_states) @`CLK_BLK;
  `SLAVE_IF.FREADY <= 1;
  if(req.error_happening == 0 && slave_item.FCMD == gfb_config::READ)
    `SLAVE_IF.FRDATA <= slave_item.FRDATA;
  @`CLK_BLK;
  // `SLAVE_IF.FREADY <= 0;
  // `SLAVE_IF.FRESP <= 0;
  // `SLAVE_IF.FRDATA <= 'X;
endtask;


task gfb_driver::slave_drive_error();
  repeat(req.error_after) @`CLK_BLK;
  `SLAVE_IF.FRESP <= 1;
  @`CLK_BLK;
endtask

function void gfb_driver::slave_drive_init();
  `SLAVE_IF.FRDATA <= {READ_WIDTH{inactive_val}};
  `SLAVE_IF.FREADY <= inactive_val;
  `SLAVE_IF.FRESP <= inactive_val;
endfunction : slave_drive_init


function void gfb_driver::slave_drive_reset();
  vif.FRDATA <= {READ_WIDTH{inactive_val}};
  vif.FREADY <= 0;
  vif.FRESP <= 0;
endfunction : slave_drive_reset

// ********************************************************************************************