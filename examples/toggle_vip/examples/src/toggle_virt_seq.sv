/*-----------------------------------------------------------------
File name     : _virt_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequence file
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_virt_seq extends uvm_sequence; 

  // Registration
  `uvm_object_utils(toggle_virt_seq)

  // P_seqr declaration
  `uvm_declare_p_sequencer(toggle_virt_seqr)

  // Sequences
  simple_rep_seq simple_rep_seqence;
  toggle_rise_seq rise_seq;
  toggle_fall_seq fall_seq;
  
  // Constructor
  function new(string name = "toggle_virt_seq");
    super.new(name);
  endfunction //new()

  
  task pre_body();
    // Creates all sequences that will be used
    simple_rep_seqence = simple_rep_seq::type_id::create("simple_rep_seq");
    fall_seq = toggle_fall_seq::type_id::create("fall_seq");
    rise_seq = toggle_rise_seq::type_id::create("rise_seq");
  endtask

  task body();
    // simple_rep_seqence.randomize() with {
    //   numRep <= 10;
    // };
    // simple_rep_seqence.start(p_sequencer.sequencer);
    randcase 
      1 : begin
        fall_seq.start(p_sequencer.sequencer);
      end
      1 : begin
        rise_seq.start(p_sequencer.sequencer);
      end
    endcase
  endtask: body
endclass //_virt_seq extends uvm_sequence