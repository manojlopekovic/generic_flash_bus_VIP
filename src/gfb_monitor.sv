/*-----------------------------------------------------------------
File name     : gfb_monitor.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Monitor class
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/


class gfb_monitor#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_monitor;

  // Config
  gfb_config cfg;

  // Properties
  virtual gfb_interface vif;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) addr_phase_item;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) data_phase_item;
  
  semaphore phase_mutex;
  semaphore data_mutex;

  event monitor_transaction_exit_case_ev;

  // Registration
  `uvm_component_param_utils(gfb_monitor#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components

  // Ports

  // // Reactive slave port
  uvm_analysis_port #(gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_port;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) slave_item;

  // Transaction collector port
  uvm_analysis_port #(gfb_item) transaction_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    transaction_port = new("transaction_port", this);
    phase_mutex = new(0);
    data_mutex = new(0);
  endfunction //new()

  // Phases

  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);

  // Functions

  // Tasks
  // item collecting
  extern virtual task collect_item();
  extern virtual task collect_addr_phase();
  extern virtual task collect_data_phase();
  extern virtual task monitor_wait_exit_cases();
  extern virtual task reset_watcher();

  // Protocol checks
  extern virtual task start_protocol_checks();
  extern virtual task check_address_alignment();
  extern virtual task check_command_legal();
  extern virtual task check_phase_stability();
  extern virtual task check_error_response();
  extern virtual task check_abort_response();

  // Reactive slave
  extern virtual task handle_reactive_slave();
  extern virtual task handle_reactive_command(gfb_item it);

  // Protocol checkers

endclass //gfb_monitor extends uvm_monitor


function void gfb_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in monitor")

  if(!uvm_config_db#(gfb_config)::get(this, "", "monitor_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in monitor")
  
  if(cfg.agent_type == gfb_config::SLAVE)
    command_port = new("command_port", this);
endfunction: build_phase


task gfb_monitor::run_phase(uvm_phase phase);
  
  fork
    collect_item();
    reset_watcher();
    start_protocol_checks();
  join
  
endtask: run_phase


task gfb_monitor::collect_item();
  @(negedge `RESETn);
  @(posedge `RESETn);
  
  fork
    collect_data_phase();
    monitor_wait_exit_cases();
    if(cfg.agent_type == gfb_config::SLAVE)
      handle_reactive_slave();
  join_none
  forever begin 
    collect_addr_phase();
  end
endtask: collect_item


task gfb_monitor::collect_addr_phase();
  // uvm_event_pool::get_global("monitor_transaction_exit_case_ev").wait_trigger();
  @(monitor_transaction_exit_case_ev);
  if(data_phase_item != null)
    data_mutex.get(1);
  // If address phase of next item started, report error in address phase
  if(addr_phase_item != null && addr_phase_item.FCMD != gfb_config::IDLE && (`CLK_BLK.FREADY === 0 && `CLK_BLK.FRESP === 1)) begin
    if(`CLK_BLK.FABORT === 1)
      addr_phase_item.item_state = gfb_item::ABORT_ADDR;
    else
      addr_phase_item.item_state = gfb_item::ERROR_ADDR;
    // `uvm_info("MONCOL", $sformatf("%s monitor address phase errored item:\n%s", cfg.agent_type.name(), addr_phase_item.sprint()), UVM_MEDIUM)
  end else begin 
    addr_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("addr_phase_item");
    addr_phase_item.item_state = gfb_item::DATA_PHASE;
  end
  addr_phase_item.it_type = cfg.agent_type;
  addr_phase_item.FADDR = `CLK_BLK.FADDR;
  addr_phase_item.FCMD = `CLK_BLK.FCMD;
  data_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("data_phase_item");
  data_phase_item.copy(addr_phase_item);
  // Todo : add check how the item ended
  phase_mutex.put(1);
endtask: collect_addr_phase


task gfb_monitor::collect_data_phase();
  forever begin 
    phase_mutex.get(1);
    // uvm_event_pool::get_global("monitor_transaction_exit_case_ev").wait_trigger();
    @(monitor_transaction_exit_case_ev);
    data_phase_item.FRDATA = `CLK_BLK.FRDATA;
    data_phase_item.FWDATA = `CLK_BLK.FWDATA;
    // Todo : add check how the item ended
    // Address phase error should not change, and this item won't be sent to monitor(TBD)
    if(`CLK_BLK.FRESP === 1 && (data_phase_item.item_state != gfb_item::ERROR_ADDR && data_phase_item.item_state != gfb_item::ABORT_ADDR)) begin
      if(`CLK_BLK.FABORT === 1)
        data_phase_item.item_state = gfb_item::ABORT_DATA;
      else
        data_phase_item.item_state = gfb_item::ERROR_DATA;
    end else if(data_phase_item.item_state != gfb_item::ERROR_ADDR && data_phase_item.item_state != gfb_item::ABORT_ADDR)
      data_phase_item.item_state = gfb_item::COLLECTED_OK;
    `uvm_info("MONCOL", $sformatf("%s monitor collected item:\n%s", cfg.agent_type.name(), data_phase_item.sprint()), UVM_MEDIUM)
    // Todo : write to transaction port
    data_phase_item = null;
    data_mutex.put(1);
  end
endtask: collect_data_phase


task gfb_monitor::monitor_wait_exit_cases();
  forever begin 
    if(`CLK_BLK.FREADY !== '1) begin
      if(`CLK_BLK.FRESP !== 1) begin 
        fork
          @(posedge `CLK_BLK.FREADY);
          @(posedge `CLK_BLK.FRESP);
        join_any
        disable fork;
      end
    end
    -> monitor_transaction_exit_case_ev;
    @`CLK_BLK;
  end
endtask: collect_data_phase


task gfb_monitor::reset_watcher();
  forever begin 
    @(negedge vif.FRESETn);
    @(posedge vif.FRESETn);
    uvm_event_pool::get_global("reset_happened_ev").trigger();
  end
endtask: reset_watcher


// SLAVE

task gfb_monitor::handle_reactive_slave();
  forever begin 
    slave_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("slave_item");
    slave_item.FCMD = `SLAVE_IF.FCMD;
    slave_item.FADDR = `SLAVE_IF.FADDR;
    slave_item.it_type = gfb_config::SLAVE;
    command_port.write(slave_item);
    fork
      @(`SLAVE_IF.FCMD);
      begin
        @(monitor_transaction_exit_case_ev);
        @`CLK_BLK;
      end
    join_any
    disable fork;
    if(slave_item.FCMD != gfb_config::IDLE) begin
      fork
        handle_reactive_command(slave_item);
      join_none
    end
  end
endtask


task gfb_monitor::handle_reactive_command(gfb_item it);
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) temp = new("temp");
  temp.copy(it);
  if(`SLAVE_IF.FREADY == 1) begin 
    @(monitor_transaction_exit_case_ev);
    if(`SLAVE_IF.FREADY == 1) begin 
      case(temp.FCMD)
        gfb_config::WRITE, gfb_config::ROW_WRITE : begin 

        end
        gfb_config::ERASE : begin 

        end
        gfb_config::MASS_ERASE : begin 

        end
      endcase
    end
  end
endtask

// *****************************************************************************************
// Protocol checks
task gfb_monitor::start_protocol_checks();
  fork
    // Todo : add checker disable, as they will be implemented as assertions also
    check_address_alignment();
    check_command_legal();
    // Checkers implemented only in monitor
    check_phase_stability();
    check_error_response();
    check_abort_response();
  join
endtask


task gfb_monitor::check_address_alignment();
  forever begin
    fork
      @(`CLK_BLK.FADDR);
      @(`CLK_BLK.FCMD);
    join_any
    disable fork;
    case(`CLK_BLK.FCMD)
      gfb_config::WRITE, gfb_config::ROW_WRITE : begin 
        if(`CLK_BLK.FADDR % (WRITE_WIDTH / `BYTE))
          `uvm_error("ADDRALIGN", $sformatf("Address misalignment : %8h, should be aligned to %d bytes", `CLK_BLK.FADDR, (WRITE_WIDTH / `BYTE)))
      end
      gfb_config::READ : begin 
        if(`CLK_BLK.FADDR % (READ_WIDTH / `BYTE))
          `uvm_error("ADDRALIGN", $sformatf("Address misalignment : %8h, should be aligned to %d bytes", `CLK_BLK.FADDR, (READ_WIDTH / `BYTE)))
      end
    endcase
  end
endtask 


task gfb_monitor::check_command_legal();
  gfb_config::t_CommandType cmd;
  forever begin 
    @(`CLK_BLK.FCMD); 
    cmd = `CLK_BLK.FCMD;
    if(cmd.name() == "")
      `uvm_error("ILLCMD", $sformatf("Illegal command value : %3b", cmd));
      
  end
endtask 


task gfb_monitor::check_phase_stability();

endtask 


task gfb_monitor::check_error_response();

endtask


task gfb_monitor::check_abort_response();

endtask
// *****************************************************************************************