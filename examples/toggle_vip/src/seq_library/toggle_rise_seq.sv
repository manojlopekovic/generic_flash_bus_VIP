/*-----------------------------------------------------------------
File name     : toggle_rise_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Base sequence
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class toggle_rise_seq extends base_seq;

  // // Properties
  rand int delay_clk;
  rand int delay_after_clk;

  // Registration
  `uvm_object_utils(toggle_rise_seq)

  // p_sequencer
  `uvm_declare_p_sequencer(toggle_sequencer)

  constraint delay_val {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    soft delay_clk inside {[1:50]};
    soft delay_after_clk inside {[0:50]};
  }

  constraint delay_base {
    soft delay_clk == 0;
    soft delay_after_clk == 0;
  }
  

  // Print numRep
  virtual function void do_print(uvm_printer printer);
    // super.do_print(printer);
    // printer.print_int("numRep", numRep, $bits(numRep));
  endfunction : do_print
  
  // Constructor
  function new(string name="toggle_rise_seq");
    super.new(name);
  endfunction

  // Body of a sequence
  virtual task body();
    `uvm_info(get_full_name(), "Executing toggle_rise_seq", UVM_HIGH)
    `uvm_create(req);
    start_item(req);
    assert(req.randomize() with {
      data == 1; 
      delay == delay_clk; delay_cb == delay_after_clk;
    });
    finish_item(req);
  endtask: body

  
endclass //base_seq extends uvm_sequence(_item)