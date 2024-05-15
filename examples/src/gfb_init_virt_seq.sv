/*-----------------------------------------------------------------
File name     : gfb_init_virt_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequence
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_init_virt_seq#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequence; 

  // Registration
  `uvm_object_param_utils(gfb_init_virt_seq#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // P_seqr declaration
  `uvm_declare_p_sequencer(gfb_virt_seqr)

  // Sequences
  toggle_rise_seq rise_seq;
  toggle_fall_seq fall_seq;
  
  // Constructor
  function new(string name = "gfb_init_virt_seq");
    super.new(name);
  endfunction //new()

  // tasks
  
  task pre_body();
    // Creates all sequences that will be used
  endtask

  task body();
    rise_seq = toggle_rise_seq::type_id::create("rise_seq");
    fall_seq = toggle_fall_seq::type_id::create("fall_seq");

    rise_seq.randomize() with {
      delay_clk == 0;
      delay_after_clk == 0;
    };
    rise_seq.start(p_sequencer.toggle_sequencer);
    fall_seq.randomize() with {
      delay_clk inside {[5:10]};
      delay_after_clk inside {[5:50]};
    };
    fall_seq.start(p_sequencer.toggle_sequencer);
    rise_seq.randomize() with {
      delay_clk inside {[3:10]};
      delay_after_clk == 0;
    };
    rise_seq.start(p_sequencer.toggle_sequencer);
  endtask: body
endclass //gfb_init_virt_seq extends uvm_sequence