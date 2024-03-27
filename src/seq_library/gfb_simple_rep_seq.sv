/*-----------------------------------------------------------------
File name     : gfb_simple_rep_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence with simple repetition
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class simple_rep_seq extends base_seq;

  // Properties
  rand int numRep = 5;

  // Constraint
  constraint numRepValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    numRep >= 0;
  }

  // Registration
  `uvm_object_utils(simple_rep_seq)

  // Print numRep
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_int("numRep", numRep, $bits(numRep));
  endfunction : do_print
  
  // Constructor
  function new(string name="simple_rep_seq");
    super.new(name);
  endfunction

  // Body of a sequence
  virtual task body();
    `uvm_info(get_full_name(), "Executing simple_rep_seq", UVM_HIGH)
    repeat(numRep) begin 
      `uvm_create(req);
      start_item(req);
      assert(req.randomize() with {
        solve it_type before abort_happening;
        solve it_type before error_happening;
        solve it_type before wait_happening;
        it_type == p_sequencer.cfg.agent_type;
        if(it_type == gfb_config::MASTER){
          if(p_sequencer.cfg.master_abort_en == 1){ 
            abort_happening dist {1:= p_sequencer.cfg.master_abort_rate, 0 := (100 - p_sequencer.cfg.master_abort_rate)};
            abort_after inside {[0:p_sequencer.cfg.max_waits_for_abort]};
          } else {
            abort_happening == '0;
          }
        } else if(it_type == gfb_config::SLAVE){
          if(p_sequencer.cfg.slave_error_en == 1){
            error_happening dist {1:= p_sequencer.cfg.slave_error_rate, 0 := (100 - p_sequencer.cfg.slave_error_rate)};
            abort_after inside {[0:p_sequencer.cfg.max_wait_states_allowed]};
          } else {
            error_happening == '0;
          }
          if(p_sequencer.cfg.slave_wait_state_en == 1){
            wait_happening dist {1:= p_sequencer.cfg.slave_wait_state_rate, 0 := (100 - p_sequencer.cfg.slave_wait_state_rate)};
            wait_states inside {[0:p_sequencer.cfg.max_wait_states_allowed]};
          } else {
            wait_happening == '0;
          }
        }
      });
      finish_item(req);
    end
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)