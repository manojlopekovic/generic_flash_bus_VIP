/*-----------------------------------------------------------------
File name     : gfb_virt_seq.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Virtual sequence
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

class gfb_virt_seq#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32) extends uvm_sequence; 

  // Properties
  rand bit on_the_fly_reset = 0;

  // Registration
  `uvm_object_param_utils(gfb_virt_seq#(ADDR_WIDTH, WRITE_WIDTH, READ_WIDTH))

  // P_seqr declaration
  `uvm_declare_p_sequencer(gfb_virt_seqr)

  // Sequences
  write_seq seq_write;
  read_seq seq_read;
  erase_seq seq_erase;
  reactive_slave_seq slave_reactive;
  
  // Constraints
  constraint base_vals {
    /*  solve order constraints  */
  
    /*  rand variable constraints  */
    soft on_the_fly_reset == 0;
  }
  

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
    join_none
    seq_master();
  endtask: body
endclass //gfb_virt_seq extends uvm_sequence


task gfb_virt_seq::seq_slave();
  slave_reactive = reactive_slave_seq::type_id::create("slave_reactive");
  slave_reactive.start(p_sequencer.slave_sequencer);
endtask


task gfb_virt_seq::seq_master();
  seq_write = write_seq::type_id::create("write_seq");
  seq_read = read_seq::type_id::create("read_seq");
  seq_erase = erase_seq::type_id::create("erase_seq");

  fork
    begin
      int i = 0;
      int n = 0;
      std::randomize(n) with {n inside {[5:20]};};
      repeat(n) begin 
        randcase
          40 : begin 
            seq_write.randomize() with {
              numRep < 20; 
              if(i == (n-1))
                wait_resp == 1;
              else 
                wait_resp == 0;
            };
            seq_write.start(p_sequencer.master_sequencer);
          end
          40 : begin 
            seq_read.randomize() with {
              numRep < 20; 
              if(i == (n-1))
                wait_resp == 1;
              else 
                wait_resp == 0;
            };
            seq_read.start(p_sequencer.master_sequencer);
          end 
          20 : begin 
            seq_erase.randomize() with {
              numRep < 20; 
              if(i == (n-1))
                wait_resp == 1;
              else 
                wait_resp == 0;
            };
            seq_erase.start(p_sequencer.master_sequencer);
          end
        endcase
        i++;
      end
    end
    if(on_the_fly_reset == 1) begin 
      toggle_fall_seq fall_seq = toggle_fall_seq::type_id::create("fall_seq");
      toggle_rise_seq rise_seq = toggle_rise_seq::type_id::create("rise_seq");

      // Todo : add assert to all randomizations
      fall_seq.randomize() with {delay_clk >= 1;};
      fall_seq.start(p_sequencer.reset_sequencer);
      rise_seq.randomize() with {delay_clk inside {[1:10]};};
      rise_seq.start(p_sequencer.reset_sequencer);
    end
  join 
   
endtask