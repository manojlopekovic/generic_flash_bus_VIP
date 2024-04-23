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

  extern virtual task drive_seq();

  // Body of a sequence
  virtual task body();
    drive_seq();
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)

task reactive_slave_seq::drive_seq();
  `uvm_info(get_full_name(), "Executing reactive_slave_seq", UVM_HIGH)
  forever begin 
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      if(p_sequencer.cfg.slave_error_en == 1){
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
    finish_item(req);
  end
endtask
