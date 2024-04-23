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

  event monitor_transaction_exit_case;

  // Registration
  `uvm_component_param_utils(gfb_monitor#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // Components

  // Ports

  // // Reactive slave port
  // uvm_analysis_port #(gfbgfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)) command_port;

  // Transaction collector port
  uvm_analysis_port #(gfb_item) transaction_port;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // command_port = new("command_port", this);
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

  // Protocol checkers

endclass //gfb_monitor extends uvmgfb_monitor


function void gfb_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in monitor")

  if(!uvm_config_db#(gfb_config)::get(this, "", "monitor_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in monitor")

  
endfunction: build_phase


task gfb_monitor::run_phase(uvm_phase phase);
  
  fork
    collect_item();
    reset_watcher();
  join
endtask: run_phase


task gfb_monitor::collect_item();
  @(negedge `RESETn);
  @(posedge `RESETn);
  
  fork
    collect_data_phase();
    monitor_wait_exit_cases();
  join_none
  forever begin 
    collect_addr_phase();
  end
endtask: collect_item


task gfb_monitor::collect_addr_phase();
  // uvm_event_pool::get_global("monitor_transaction_exit_case").wait_trigger();
  @(monitor_transaction_exit_case);
  if(data_phase_item != null)
    data_mutex.get(1);
  // If address phase of next item started, report error in address phase
  if(addr_phase_item != null && addr_phase_item.FCMD != gfb_config::IDLE && (`CLK_BLK.FREADY === 0 && `CLK_BLK.FRESP === 1)) begin
    addr_phase_item.item_state = gfb_item::ERROR_ADDR;
    // `uvm_info("MONCOL", $sformatf("%s monitor address phase errored item:\n%s", cfg.agent_type.name(), addr_phase_item.sprint()), UVM_MEDIUM)
  end else begin 
    addr_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("addr_phase_item");
  end
  addr_phase_item.FADDR = `CLK_BLK.FADDR;
  addr_phase_item.FCMD = `CLK_BLK.FCMD;
  data_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("data_phase_item");
  data_phase_item.copy(addr_phase_item);
  data_phase_item.item_state = addr_phase_item.item_state == gfb_item::ERROR_ADDR ? gfb_item::ERROR_ADDR : gfb_item::DATA_PHASE;
  // Todo : add check how the item ended
  phase_mutex.put(1);
endtask: collect_addr_phase


task gfb_monitor::collect_data_phase();
  forever begin 
    phase_mutex.get(1);
    // uvm_event_pool::get_global("monitor_transaction_exit_case").wait_trigger();
    @(monitor_transaction_exit_case);
    data_phase_item.FRDATA = `CLK_BLK.FRDATA;
    data_phase_item.FWDATA = `CLK_BLK.FWDATA;
    // Todo : add check how the item ended
    // Address phase error should not change, and this item won't be sent to monitor(TBD)
    if(`CLK_BLK.FRESP === 1 && data_phase_item.item_state != gfb_item::ERROR_ADDR) begin
      data_phase_item.item_state = gfb_item::ERROR_DATA;
    end else if(data_phase_item.item_state != gfb_item::ERROR_ADDR)
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
    -> monitor_transaction_exit_case;
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
