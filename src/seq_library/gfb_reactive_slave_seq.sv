/*-----------------------------------------------------------------
File name     : gfb_reactive_slave_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence with simple repetition
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class reactive_slave_seq extends base_seq;

  // Properties

  // Constraint

  // Registration
  `uvm_object_utils(reactive_slave_seq)

  // Print numRep
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
  endfunction : do_print
  
  // Constructor
  function new(string name="reactive_slave_seq");
    super.new(name);
  endfunction

  extern virtual task drive_reactive_seq();

  // Body of a sequence
  virtual task body();
    drive_reactive_seq();
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)

task reactive_slave_seq::drive_reactive_seq();
  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) transaction_item;
  `uvm_info(get_full_name(), "Executing reactive_slave_seq", UVM_HIGH)
  transaction_item = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("transaction_item");
  forever begin 
    p_sequencer.command_fifo.get(transaction_item);
    `uvm_create(req);
    req.copy(transaction_item);
    start_item(req);
    if(req.FCMD == gfb_config::READ) begin 
      if(p_sequencer.cfg.mem_model_exists == '1)
        req.FRDATA = req.FADDR;
        // req.FRDATA = p_sequencer.memory.read(req.FADDR);
    end
    if(req.item_state == gfb_item::ABORT_DATA) begin 
      assert(req.randomize(error_happening, error_after, wait_happening, wait_states) with {
        solve error_happening before error_after;
        solve error_happening before wait_happening;
        error_happening dist {1 := p_sequencer.cfg.slave_abort_rate, 0 := (100 - p_sequencer.cfg.slave_abort_rate)};
        if(error_happening == 1) {
          error_after inside {[0:p_sequencer.cfg.max_abort_wait-1]};
        } else if(p_sequencer.cfg.slave_wait_state_en == 1){
          wait_happening dist {1:= p_sequencer.cfg.slave_wait_state_rate, 0 := (100 - p_sequencer.cfg.slave_wait_state_rate)};
          wait_states inside {[0:p_sequencer.cfg.max_abort_wait-1]};
        } else {
          wait_happening == '0;
        }
      });
    end else begin 
      assert(req.randomize(error_happening, error_after, wait_happening, wait_states) with {
        if(p_sequencer.cfg.slave_error_en == 1 && req.FCMD != gfb_config::IDLE){
          error_happening dist {1:= p_sequencer.cfg.slave_error_rate, 0 := (100 - p_sequencer.cfg.slave_error_rate)};
          error_after inside {[0:p_sequencer.cfg.max_wait_states_allowed]};
        } else {
          error_happening == '0;
        }
        if(p_sequencer.cfg.slave_wait_state_en == 1){
          wait_happening dist {1:= p_sequencer.cfg.slave_wait_state_rate, 0 := (100 - p_sequencer.cfg.slave_wait_state_rate)};
          wait_states inside {[0:p_sequencer.cfg.max_wait_states_allowed]};
        } else {
          wait_happening == '0;
        }
      });
    end
    finish_item(req);
  end
endtask
