/*-----------------------------------------------------------------
File name     : gfb_write_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Sequence with simple repetition
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class write_seq extends base_seq;

  // Properties
  rand int numRep = 1;
  rand bit[ADDR_WIDTH-1 : 0] writeAddr [];
  rand bit[WRITE_WIDTH-1 : 0] writeData []; 

  // Constraint
  constraint numRepValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    numRep >= 0;
    soft numRep <= 100;
  }

  constraint sizeValid {
    /*  solve order constraints  */
    solve numRep before writeAddr;
    solve numRep before writeData;
    /*  rand variable constraints  */
    writeAddr.size() == numRep;
    writeData.size() == numRep;
  }

  constraint dataValid {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    foreach(writeAddr[i]) {
      writeAddr[i] >= 0;
      (writeAddr[i] % 32'h4) == 32'h0;
    }
    foreach(writeData[i])
      writeData[i] >= 0;
  }

  // Registration
  `uvm_object_utils(write_seq)

  // Print numRep
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_int("numRep", numRep, $bits(numRep));
    printer.print_array_header("writeAddr", numRep);
    for(int i = 0; i < numRep; i++)
      printer.print_int($sformatf("[%d]", i), writeAddr[i], $bits(writeAddr[i]));
    printer.print_array_footer(numRep);
    printer.print_array_header("writeData", numRep);
    for(int i = 0; i < numRep; i++)
      printer.print_int($sformatf("[%d]", i), writeData[i], $bits(writeData[i]));
    printer.print_array_footer(numRep);
  endfunction : do_print
  
  // Constructor
  function new(string name="write_seq");
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

task write_seq::drive_seq();
  int i = 0;
  `uvm_info(get_full_name(), "Executing write_seq", UVM_HIGH)
  repeat(numRep) begin 
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      it_type == p_sequencer.cfg.agent_type;
      if(p_sequencer.cfg.master_abort_en == 1){ 
        abort_after inside {[0:p_sequencer.cfg.max_waits_for_abort]};
      }
      FCMD == (i == 0 && numRep > 1) ? gfb_config::ROW_WRITE : gfb_config::WRITE;
      FADDR == writeAddr[i];
      FWDATA == writeData[i];
    });
    finish_item(req);
    i++;
  end
endtask


task write_seq::wait_answers();
  repeat(numRep) begin
    get_response(rsp);
  end
endtask