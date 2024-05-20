/*-----------------------------------------------------------------
File name     : gfb_read_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence with simple repetition
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class read_seq extends base_seq;

  // Properties
  rand int numRep = 1;
  rand bit[ADDR_WIDTH-1 : 0] readAddr [];
  rand bit wait_resp = 0;

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
    solve numRep before readAddr;
    /*  rand variable constraints  */
    readAddr.size() == numRep;
  }

  constraint dataValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    foreach(readAddr[i]) {
      readAddr[i] >= 0;
      (readAddr[i] % 32'h4) == 32'h0;
    }
  }

  // Registration
  `uvm_object_utils(read_seq)

  // Print numRep
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_int("numRep", numRep, $bits(numRep));
    printer.print_array_header("readAddr", numRep);
    for(int i = 0; i < numRep; i++)
      printer.print_int($sformatf("[%d]", i), readAddr[i], $bits(readAddr[i]));
    printer.print_array_footer(numRep);
  endfunction : do_print
  
  // Constructor
  function new(string name="read_seq");
    super.new(name);
  endfunction

  extern virtual task drive_seq();
  extern virtual task wait_answers();

  // Body of a sequence
  virtual task body();
    rsp = gfb_item#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH)::type_id::create("rsp");
    if(wait_resp == 0) begin 
      fork
        begin 
          while(rsp.FCMD != gfb_config::READ)
            get_response(rsp);
          wait_answers();
        end
      join_none
      drive_seq();
    end else begin 
      fork
        drive_seq();
        begin 
          while(rsp.FCMD != gfb_config::READ)
            get_response(rsp);
          wait_answers();
        end
      join
    end
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)

task read_seq::drive_seq();
  int i = 0;
  `uvm_info(get_full_name(), "Executing read_seq", UVM_HIGH)
  repeat(numRep) begin 
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      it_type == p_sequencer.cfg.agent_type;
      if(p_sequencer.cfg.master_abort_en == 1){ 
        abort_after inside {[0:p_sequencer.cfg.max_waits_for_abort]};
      }
      FCMD == gfb_config::READ;
      FADDR == readAddr[i];
    });
    finish_item(req);
    i++;
  end
endtask


task read_seq::wait_answers();
  repeat(numRep - 1) begin
    get_response(rsp);
    `uvm_info("GETRSP", $sformatf("Recieved rsp: %s\n", rsp.sprint()), UVM_DEBUG)
  end
endtask