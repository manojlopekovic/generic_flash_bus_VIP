/*-----------------------------------------------------------------
File name     : _virt_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequence file
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class _virt_seq extends uvm_sequence; 

  // Registration
  `uvm_object_utils(_virt_seq)

  // P_seqr declaration
  `uvm_declare_p_sequencer(_virt_seqr)

  // Sequences
  simple_rep_seq simple_rep_seqence;
  
  // Constructor
  function new(string name = "_virt_seq");
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
endclass //_virt_seq extends uvm_sequence