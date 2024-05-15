/*-----------------------------------------------------------------
File name     : _driver.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Driver class
Notes         : 
Date          : 29.08.2023.
-------------------------------------------------------------------
Copyright Veriest 
-----------------------------------------------------------------*/

class clk_driver extends uvm_driver#(clk_item);

  // Config
  clk_conf conf;

  // Properties
  virtual clk_if vif [$];


  // Registration
  `uvm_component_utils(clk_driver)


  // Components


  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction //new()


  // Phases
  //  Function: build_phase
  extern function void build_phase(uvm_phase phase);
  //  Function: run_phase
  extern task run_phase(uvm_phase phase);


  // Functions
  extern virtual function void toggle_clk(int vif_num);


  // Tasks
  extern virtual task _standard_driver_operation();

endclass //_agent extends uvm_agent


function void clk_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db#(clk_conf)::get(this, "", "clk_conf", conf))
    `uvm_fatal(get_type_name(),"Failed to get configuration in clk driver")
  for(int i = 0; i < conf.num_clk; i++) begin
    virtual clk_if temp_vif;
    if(!uvm_config_db#(virtual clk_if)::get(this, "*", $sformatf("clk_if%0d", i), temp_vif))
      `uvm_fatal(get_type_name(),$sformatf("Failed to get interface %d in clk driver", i))
    vif.push_back(temp_vif);
  end
endfunction: build_phase


task clk_driver::run_phase(uvm_phase phase);

  fork
    _standard_driver_operation();
  join

endtask: run_phase


task clk_driver::_standard_driver_operation();
  for(int i = 0; i < conf.num_clk; i++) begin
    vif[i].clk <= 0;
  end
  seq_item_port.get_next_item(req);
  seq_item_port.item_done();
  for(int i = 0; i < conf.num_clk; i++) begin
    // For every clock domain, create it's own thread that will run forever and toggle clock at the appropriate time intervals
    automatic int vif_num = i;
    fork begin
      # ((1s / conf.freq[vif_num]));
      forever begin
        toggle_clk(vif_num);
        # ((1s / conf.freq[vif_num]));
      end
    end join_none
  end
endtask : _standard_driver_operation


function void clk_driver::toggle_clk(int vif_num);
  vif[vif_num].clk <= ~vif[vif_num].clk;
endfunction : toggle_clk
