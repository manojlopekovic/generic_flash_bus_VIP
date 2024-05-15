/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : 
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-access +rwc
-disable_sem2009
-warn_multiple_driver
-64

//  -uvmhome $UVMHOME

  -uvmhome /tools/cdnc/xcelium/20.03.001/tools/methodology/UVM/CDNS-1.2



// include directories
//*** add incdir include directories here
+incdir+${TRAINING_HOME}/vip_lib/toggle_vip/src/
+incdir+${TRAINING_HOME}/vip_lib/toggle_vip/examples/tests/
+incdir+${TRAINING_HOME}/vip_lib/toggle_vip/examples/src/

// compile files
//*** add compile files here
-sv ${TRAINING_HOME}/vip_lib/toggle_vip/src/toggle_interface.sv
-sv ${TRAINING_HOME}/vip_lib/toggle_vip/src/toggle_pkg.sv
-sv ${TRAINING_HOME}/vip_lib/toggle_vip/src/toggle_seq_pkg.sv
-sv ${TRAINING_HOME}/vip_lib/toggle_vip/examples/src/toggle_env_pkg.sv
-sv ${TRAINING_HOME}/vip_lib/toggle_vip/examples/tests/toggle_test_pkg.sv
-sv ${TRAINING_HOME}/vip_lib/toggle_vip/examples/tests/top.sv
-seed random

-LINEDEBUG

+UVM_TESTNAME=simple_rep_test
+UVM_VERBOSITY=UVM_HIGH
+UVM_NO_RELNOTES


// +SVSEED=RANDOM

