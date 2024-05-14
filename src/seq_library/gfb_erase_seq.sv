/*-----------------------------------------------------------------
File name     : gfb_erase_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence with simple repetition
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class erase_seq extends base_seq;

  // Properties
  rand int numRep = 1;
  rand bit massErase = 0;
  rand bit[ADDR_WIDTH-1 : 0] eraseAddr[];

  // Constraint
  constraint numRepValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    numRep >= 0;
    soft numRep <= 100;
  }

  constraint sizeValid {
    /*  solve order constraints  */
    solve numRep before eraseAddr;
    /*  rand variable constraints  */
    eraseAddr.size() == numRep;
  }

  constraint dataValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    foreach(eraseAddr[i])
      eraseAddr[i] >= 0;
    soft massErase == 0;
  }

  // Registration
  `uvm_object_utils(erase_seq)

  // Print numRep
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_int("numRep", numRep, $bits(numRep));
    printer.print_array_header("eraseAddr", numRep);
    for(int i = 0; i < numRep; i++)
      printer.print_int($sformatf("[%d]", i), eraseAddr[i], $bits(eraseAddr[i]));
    printer.print_array_footer(numRep);
  endfunction : do_print
  
  // Constructor
  function new(string name="erase_seq");
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

task erase_seq::drive_seq();
  int i = 0;
  `uvm_info(get_full_name(), "Executing erase_seq", UVM_HIGH)
  repeat(numRep) begin 
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      it_type == p_sequencer.cfg.agent_type;
      if(p_sequencer.cfg.master_abort_en == 1){ 
        abort_after inside {[0:p_sequencer.cfg.max_waits_for_abort]};
      }
      FCMD == massErase == 0 ? gfb_config::MASS_ERASE : gfb_config::ERASE;
      FADDR == eraseAddr[i];
    });
    finish_item(req);
    i++;
  end
endtask


task erase_seq::wait_answers();
  repeat(numRep) begin
    get_response(rsp);
  end
endtask