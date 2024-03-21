/*-----------------------------------------------------------------
File name     : gfb_interface.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Interface module
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

interface gfb_interface#(ADDR_WIDTH = 12, WRITE_WIDTH = 32, READ_WIDTH = 32)(input bit FCLK, FRESETn);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Maser driven signals
  logic [ADDR_WIDTH-1:0] FADDR;         // Must be aligned to READ/WRITE data width
  logic [2:0] FCMD;                     // IDLE(0x000), READ(0x001), WRITE(0x010), ROW_WRITE(0x011), ERASE(0x100), MASS_ERASE(0x111), 0x101 & 0x110 are invalid 
  logic [WRITE_WIDTH-1:0] FWDATA;       //
  logic FABORT;                         // Request to cancel previously accepted command

  // Slave driven signals
  logic [READ_WIDTH-1:0] FRDATA;        //
  logic FREADY;                         // Signals acceptance and finish of command
  logic FRESP;                          // Error indication, for previously accepted command, two cycle, (READY, RESP) = (0, 1), (READY, RESP) = (1, 1)

  clocking cb @(posedge FCLK);
    inout FRDATA, FREADY, FRESP;
    inout FADDR, FCMD, FWDATA, FABORT;
  endclocking

  clocking master_cb @(posedge FCLK);
    input FRDATA, FREADY, FRESP;
    output FADDR, FCMD, FWDATA, FABORT;
  endclocking

  
  clocking slave_cb @(posedge FCLK);
    output FRDATA, FREADY, FRESP;
    input FADDR, FCMD, FWDATA, FABORT;
  endclocking
  
endinterface