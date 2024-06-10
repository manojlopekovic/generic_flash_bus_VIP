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
  rand bit wait_resp = 0; 
  int transaction_ids [];

  event trans_id_collected;

  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH) item; 

  // Constraint
  constraint numRepValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    numRep > 0;
    soft numRep <= 100;
    soft wait_resp == 0;
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
  extern virtual task wait_answer(int j);

  // Body of a sequence
  virtual task body();
    transaction_ids = new[numRep];
    rsp = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("rsp");
    // if(wait_resp == 0) begin 
    //   fork
    //     wait_answers();
    //   join_none
    //   drive_seq();
    // end else begin 
    //   fork
    //     drive_seq();
    //     wait_answers();
    //   join
    // end
    drive_seq();
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)

task erase_seq::drive_seq();
  int i = 0;
  item =  gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("item");
  `uvm_info(get_full_name(), "Executing erase_seq", UVM_HIGH)
  repeat(numRep) begin 
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      it_type == p_sequencer.cfg.agent_type;
      if(p_sequencer.cfg.master_abort_en == 1){ 
        abort_after inside {[0:p_sequencer.cfg.max_waits_for_abort]};
      }
      if(massErase == 1)
        FCMD == gfb_config::MASS_ERASE;
      else
        FCMD == gfb_config::ERASE;
      // FCMD == massErase == 0 ? gfb_config::MASS_ERASE : gfb_config::ERASE;
      FADDR == eraseAddr[i];
    });
    item.copy(req);
    finish_item(req);
    transaction_ids[i] = req.get_transaction_id();
    wait_answer(i);
    // ->trans_id_collected;
    i++;
  end
  if(wait_resp)
    wait fork;
endtask


task erase_seq::wait_answer(int j);
  fork
    begin 
      $display("GET: %0d | %0d", j, transaction_ids[j]);
      `uvm_info("REQ", $sformatf("GET trans id: %0d, write: %s\n", transaction_ids[j], item.sprint()), UVM_LOW)
      get_response(rsp, transaction_ids[j]);
      `uvm_info("GETRSP", $sformatf("Recieved rsp trans id: %0d, write: %s\n", transaction_ids[j], rsp.sprint()), UVM_LOW)
      $display("GOTTEN: %0d | %0d", j, transaction_ids[j]);
    end
  join_none
endtask