/*-----------------------------------------------------------------
File name     : gfb_types defines.sv
Owner         : Manojlo Pekovic - manojlop@veriests.com
Description   : Types, enums, defines
Notes         : 
Date          : 18.03.2023.
-----------------------------------------------------------------*/

`define MASTER_IF vif.master_cb
`define SLAVE_IF vif.slave_cb
`define CLK_BLK vif.cb
`define RESETn vif.FRESETn

`define AGT_TYPE cfg.agent_type
`define MASTER_TYPE gfb_config::MASTER
`define SLAVE_TYPE gfb_config::SLAVE

`define BYTE 8 