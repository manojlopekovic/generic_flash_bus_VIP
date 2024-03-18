/*-----------------------------------------------------------------
File name     : gfb_virt_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequence
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_virt_seq extends uvm_sequence; 

  // Registration
  `uvm_object_utils(gfb_virt_seq)

  // P_seqr declaration
  `uvm_declare_p_sequencer(gfb_virt_seqr)

  // Sequences
  simple_rep_seq simple_rep_seqence;
  
  // Constructor
  function new(string name = "gfb_virt_seq");
    super.new(name);
  endfunction //new()

  
  task pre_body();
    // Creates all sequences that will be used
    simple_rep_seqence = simple_rep_seq::type_id::create("simple_rep_seq");
  endtask

  task body();
    simple_rep_seqence.randomize() with {
      numRep <= 10;
    };
    simple_rep_seqence.start(p_sequencer.sequencer);
  endtask: body
endclass //gfb_virt_seq extends uvm_sequence