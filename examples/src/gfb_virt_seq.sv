/*-----------------------------------------------------------------
File name     : gfb_virt_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequence
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_virt_seq#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequence; 

  // Registration
  `uvm_object_param_utils(gfb_virt_seq#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // P_seqr declaration
  `uvm_declare_p_sequencer(gfb_virt_seqr)

  // Sequences
  simple_rep_seq master_simple_rep;
  simple_rep_seq slave_simple_rep;
  
  // Constructor
  function new(string name = "gfb_virt_seq");
    super.new(name);
  endfunction //new()

  // tasks
  extern task seq_slave();
  extern task seq_master();
  
  task pre_body();
    // Creates all sequences that will be used
  endtask

  task body();
    fork
      seq_slave();
      seq_master();
    join
  endtask: body
endclass //gfb_virt_seq extends uvm_sequence


task gfb_virt_seq::seq_slave();
  slave_simple_rep = simple_rep_seq::type_id::create("slave_simple_rep");
  slave_simple_rep.randomize() with {
    numRep <= 10;
  };
  slave_simple_rep.start(p_sequencer.slave_sequencer);
endtask


task gfb_virt_seq::seq_master();
  master_simple_rep = simple_rep_seq::type_id::create("master_simple_rep");
  master_simple_rep.randomize() with {
    numRep <= 10;
  };
  master_simple_rep.start(p_sequencer.master_sequencer);
endtask