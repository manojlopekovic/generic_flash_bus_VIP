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
  logic inactive_val;

  // Properties
  virtual gfb_interface vif;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) addr_phase_item;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) data_phase_item;
  
  semaphore phase_mutex;
  semaphore data_mutex;

  event monitor_transaction_exit_case_ev;

  
  // Slave helper items
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) ap_item_cmd;
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) dp_item_cmd;

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

  // Protocol checks
  extern virtual task start_protocol_checks();
  extern virtual task check_address_alignment();
  extern virtual task check_command_legal();
  extern virtual task check_phase_stability();
  extern virtual task addr_phase_stability();
  extern virtual task data_phase_stability();
  extern virtual task check_error_response();
  extern virtual task check_abort_response();
  extern virtual task check_reset_values();
  extern virtual task check_transaction_response();

  // Reactive slave
  extern virtual task handle_reactive_slave();
  extern virtual function void handle_reactive_command();
  extern virtual function void collect_ap_item();

  // Protocol checkers

endclass //gfb_monitor extends uvm_monitor


function void gfb_monitor::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual gfb_interface)::get(this, "", "intf", vif))
    `uvm_fatal(get_type_name(),"Failed to get interface in monitor")

  if(!uvm_config_db#(gfb_config)::get(this, "", "monitor_cfg", cfg))
    `uvm_fatal(get_full_name(), "Failed to get gfb_config in monitor")
  
  if(cfg.agent_type == gfb_config::SLAVE)
    command_port = new("command_port", this);

  
  inactive_val =  cfg.inactive_value == gfb_config::INACTIVE_ZERO ?   '0 :
                  cfg.inactive_value == gfb_config::INACTIVE_ONE  ?   '1 :
                  cfg.inactive_value == gfb_config::INACTIVE_X    ?   'X :
                                                                      'Z;
endfunction: build_phase


task gfb_monitor::run_phase(uvm_phase phase);
  
  fork
    collect_item();
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
  if(`RESETn == 0) begin
    if(addr_phase_item == null)
      addr_phase_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("addr_phase_item");
    addr_phase_item.item_state = gfb_item::RESET_ADDR;
  end else if(addr_phase_item != null && addr_phase_item.FCMD != gfb_config::IDLE && (`CLK_BLK.FREADY === 0 && `CLK_BLK.FRESP === 1)) begin
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
    if(`RESETn == 0)
      data_phase_item.item_state = gfb_item::RESET_DATA;
    else if(`CLK_BLK.FRESP === 1 && (data_phase_item.item_state != gfb_item::ERROR_ADDR && data_phase_item.item_state != gfb_item::ABORT_ADDR)) begin
      if(`CLK_BLK.FABORT === 1)
        data_phase_item.item_state = gfb_item::ABORT_DATA;
      else
        data_phase_item.item_state = gfb_item::ERROR_DATA;
    end else if(data_phase_item.item_state != gfb_item::ERROR_ADDR && data_phase_item.item_state != gfb_item::ABORT_ADDR && data_phase_item.item_state != gfb_item::RESET_ADDR)
      data_phase_item.item_state = gfb_item::COLLECTED_OK;
    `uvm_info("MONCOL", $sformatf("%s monitor collected item:\n%s", cfg.agent_type.name(), data_phase_item.sprint()), UVM_MEDIUM)
    transaction_port.write(data_phase_item);
    data_phase_item = null;
    data_mutex.put(1);
  end
endtask: collect_data_phase


task gfb_monitor::monitor_wait_exit_cases();
  fork
    forever begin 
      @(negedge `RESETn);
    end 
    forever begin 
      wait(`RESETn == 1);
      if(`RESETn === 1) begin 
        if(`CLK_BLK.FREADY !== '1) begin
          if(`CLK_BLK.FRESP !== 1) begin 
            fork
              @(posedge `CLK_BLK.FREADY);
              @(posedge `CLK_BLK.FRESP);
              @(negedge `RESETn);
            join_any
            disable fork;
          end
        end
      end
      -> monitor_transaction_exit_case_ev;
      @`CLK_BLK;
    end
  join
endtask: collect_data_phase




// SLAVE
// *****************************************************************************************

task gfb_monitor::handle_reactive_slave();
  collect_ap_item();
  command_port.write(ap_item_cmd);
  @monitor_transaction_exit_case_ev;
  forever begin 
    wait(`RESETn == 1);
    if(ap_item_cmd == null) begin
      collect_ap_item();
      command_port.write(ap_item_cmd);
      @monitor_transaction_exit_case_ev;
    end
    if(`RESETn == 1) begin 
      if(ap_item_cmd.FCMD == gfb_config::IDLE && `SLAVE_IF.FCMD == gfb_config::IDLE) begin
        fork
          @(negedge `RESETn);
          @(`SLAVE_IF.FCMD);
        join_any
        disable fork;
      end else begin
        collect_ap_item();
        dp_item_cmd = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("dp_item_cmd");
        dp_item_cmd.copy(ap_item_cmd);
        dp_item_cmd.item_state = gfb_item::DATA_PHASE;
        if(`SLAVE_IF.FRESP === 0 || (`SLAVE_IF.FRESP === 1 && `SLAVE_IF.FREADY == 1)) begin
          command_port.write(dp_item_cmd);
          fork
            @monitor_transaction_exit_case_ev;
            @(negedge `RESETn);
            if(`SLAVE_IF.FABORT === 0 || (`SLAVE_IF.FABORT === 1 && `SLAVE_IF.FREADY === 1)) begin
              // @(negedge `SLAVE_IF.FABORT);
              @(posedge `SLAVE_IF.FABORT);
              if(`SLAVE_IF.FREADY)
                @monitor_transaction_exit_case_ev;
            end
          join_any
          disable fork;
          if(`RESETn == 1) begin 
            if(`SLAVE_IF.FABORT == 1 && `SLAVE_IF.FRESP == 0 && `SLAVE_IF.FREADY == 0) begin 
              dp_item_cmd.item_state = gfb_item::ABORT_DATA;
              if(`SLAVE_IF.FRESP === 0 || (`SLAVE_IF.FRESP === 1 && `SLAVE_IF.FREADY == 1)) begin
                command_port.write(dp_item_cmd);
                @monitor_transaction_exit_case_ev;
              end 
            end
            if(`SLAVE_IF.FREADY == 1) begin 
              if(dp_item_cmd.FCMD == gfb_config::WRITE || dp_item_cmd.FCMD == gfb_config::ROW_WRITE)
                dp_item_cmd.FWDATA = `SLAVE_IF.FWDATA;
              handle_reactive_command();
            end
          end
        end 
        if(`SLAVE_IF.FRESP === 1 && `SLAVE_IF.FREADY == 0)
        fork
          @monitor_transaction_exit_case_ev;
          @(negedge `RESETn);
        join_any
        disable fork;
      end
    end 
    if(`RESETn == 0) begin
      ap_item_cmd = null;
    end
  end
endtask


function void gfb_monitor::collect_ap_item();
  ap_item_cmd = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("ap_item_cmd");
  ap_item_cmd.FCMD = `SLAVE_IF.FCMD;
  ap_item_cmd.FADDR = `SLAVE_IF.FADDR;
  ap_item_cmd.it_type = gfb_config::SLAVE;
  ap_item_cmd.item_state = gfb_item::ADDR_PHASE;
endfunction


function void gfb_monitor::handle_reactive_command();
  case(dp_item_cmd.FCMD)
    gfb_config::WRITE, gfb_config::ROW_WRITE : begin 

    end
    gfb_config::ERASE : begin 

    end
    gfb_config::MASS_ERASE : begin 

    end
  endcase
endfunction

// *****************************************************************************************
// Protocol checks
task gfb_monitor::start_protocol_checks();
  @(negedge `RESETn);
  @(posedge `RESETn);
  forever begin
    wait(`RESETn == 1);
    fork
      // Todo : add checker disable, as they will be implemented as assertions also
      check_address_alignment();
      check_command_legal();
      // Checkers implemented only in monitor
      check_phase_stability();
      check_error_response();
      check_abort_response();
      check_transaction_response();
      check_reset_values();
    join_any
    disable fork;
    @`CLK_BLK;
  end
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
  forever begin 
    addr_phase_stability();
  end
endtask 


task gfb_monitor::addr_phase_stability();
  string err = "";
  if(`CLK_BLK.FREADY === '0 && `CLK_BLK.FRESP === '0) begin 
    fork
      @monitor_transaction_exit_case_ev;
      @(`CLK_BLK.FADDR) begin 
        err = "ADDRSTBL";
      end
      @(`CLK_BLK.FCMD) begin 
        err = "CMDSTBL";
      end
    join_any
    disable fork;
  end
  if(err != "") begin 
    if(err == "ADDRSTBL")
      `uvm_error(err, $sformatf("ADDRESS HAS CHANGED WHILE WAITING FOR ANSWER IN ADDRESS PHASE", ))
    else 
      `uvm_error(err, $sformatf("COMMAND HAS CHANGED WHILE WAITING FOR ANSWER IN ADDRESS PHASE", ))
  end else begin 
    @`CLK_BLK;
    fork
      data_phase_stability();
    join_none
  end
endtask


task gfb_monitor::data_phase_stability();
  string err = "";
  if(`CLK_BLK.FREADY != '1) begin 
    fork
      @monitor_transaction_exit_case_ev;
      @(`CLK_BLK.FWDATA) begin 
        err = "WDATASTBL";
      end
    join_any
    disable fork;
  end
  if(err != "" && `CLK_BLK.FRESP == '0) 
    `uvm_error(err, $sformatf("WRITE DATA HAS CHANGED WHILE WAITING FOR ANSWER IN DATA PHASE", ))
endtask


task gfb_monitor::check_error_response();
  forever begin 
    if(`CLK_BLK.FRESP !== '1)
      @(posedge `CLK_BLK.FRESP);
    if(`RESETn == 1) begin
      if((addr_phase_item.FCMD == gfb_config::IDLE && data_phase_item == null) || (data_phase_item.FCMD == gfb_config::IDLE))
        `uvm_error("IDLEERR", "IDLE TRANSACTION CANNOT BE ERRORED")
      if(`CLK_BLK.FREADY != '0)
        `uvm_error("ERR1CYC", "FREADY is HIGH in first cycle of ERROR RESPONSE");
      @`CLK_BLK;
      if(`RESETn == 1) begin
        if(`CLK_BLK.FREADY != '1)
          `uvm_error("ERR2CYC", "FREADY is LOW in second cycle of ERROR RESPONSE");
        if(`CLK_BLK.FRESP != '1)
          `uvm_error("ERR2CYC", "FRESP is LOW in second cycle of ERROR RESPONSE");
        @`CLK_BLK;    
      end
    end
  end
endtask


task gfb_monitor::check_abort_response();
  forever begin 
    wait(`RESETn == 1);
    if(`CLK_BLK.FABORT !== '1 || (`CLK_BLK.FABORT === 1 && `CLK_BLK.FREADY === 1)) begin 
      @(posedge `CLK_BLK.FABORT);
      if((addr_phase_item.FCMD == gfb_config::IDLE && data_phase_item == null) || (data_phase_item.FCMD == gfb_config::IDLE))
        `uvm_error("ABORTIDLE", "ABORT happened on IDLE command");    
    end
    if(`RESETn == 1) begin
      fork
        begin
          if(`CLK_BLK.FREADY === '0 && `CLK_BLK.FRESP === '0)
            @monitor_transaction_exit_case_ev;
            if(`CLK_BLK.FREADY !== '1)
              @(posedge `CLK_BLK.FREADY);
            if(`CLK_BLK.FABORT !== '1)
              `uvm_error("ABORTERR", "ABORT went to LOW before end of abort sequence")
        end
        begin 
          repeat(cfg.max_abort_wait)@`CLK_BLK;
          if(`CLK_BLK.FRESP === 0 && `CLK_BLK.FREADY === 0)
            `uvm_error("ABORTNORESP", "ABORT request answer wait time exceeded");        
        end
        @(negedge `RESETn);
      join_any
      disable fork;
    end
  end
endtask


task gfb_monitor::check_transaction_response();
  forever begin 
    @monitor_transaction_exit_case_ev;
    if(`RESETn == 1) begin
      if(`CLK_BLK.FCMD != gfb_config::IDLE) begin 
        fork
          begin 
            fork
              begin 
                @monitor_transaction_exit_case_ev;
              end
              begin
                repeat(cfg.max_response_wait) @`CLK_BLK;
                `uvm_error("NORESP", "MAX wait response time exceeded");
              end
              @(negedge `RESETn);
            join_any
            disable fork;
          end
        join_none
      end
    end
  end
endtask

task gfb_monitor::check_reset_values();
  @(negedge `RESETn);
  // Todo : change this implementation
  #1;
  if(vif.FCMD != gfb_config::IDLE)
    `uvm_error("RSTVAL", "Command not idle on reset");
  if(vif.FABORT != 0)
    `uvm_error("RSTVAL", "Abort asserted on reset");
  if(vif.FRESP == 1)
    `uvm_error("RSTVAL", "Resp asserted on reset");
  if(vif.FREADY == 1)
    `uvm_error("RSTVAL", "Ready asserted on reset");
  fork
    @(posedge `RESETn);
    @(vif.FCMD) begin 
      `uvm_error("RSTVAL", "FCMD changed during reset");
    end
    @(vif.FADDR) begin 
      `uvm_error("RSTVAL", "FADDR changed during reset");
    end
    @(vif.FWDATA) begin 
      `uvm_error("RSTVAL", "FWDATA changed during reset");
    end
    @(vif.FABORT) begin 
      `uvm_error("RSTVAL", "FABORT changed during reset");
    end
    @(vif.FREADY) begin 
      `uvm_error("RSTVAL", "FREADY changed during reset");
    end
    @(vif.FRESP) begin 
      `uvm_error("RSTVAL", "FRESP changed during reset");
    end
    @(vif.FRDATA) begin 
      `uvm_error("RSTVAL", "FWDATA changed during reset");
    end
  join_any
  disable fork;
endtask
// *****************************************************************************************