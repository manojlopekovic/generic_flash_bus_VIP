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

  extern virtual task drive_seq();
  extern virtual task wait_answers();

  // Body of a sequence
  virtual task body();
    fork
      drive_seq();
      wait_answers();
    join
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)

task simple_rep_seq::drive_seq();
  `uvm_info(get_full_name(), "Executing simple_rep_seq", UVM_HIGH)
  repeat(numRep) begin 
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      it_type == p_sequencer.cfg.agent_type;
      if(p_sequencer.cfg.master_abort_en == 1){ 
        abort_after inside {[0:p_sequencer.cfg.max_waits_for_abort]};
      }
    });
    finish_item(req);
  end
endtask


task simple_rep_seq::wait_answers();
  repeat(numRep) begin
    get_response(rsp);
  end
endtask