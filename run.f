/*-----------------------------------------------------------------
File name     : run.f
Description   : git config credential.helper store
Notes         : 
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
-----------------------------------------------------------------*/

-timescale 1us/1ns
// 64 bit option for AWS labs
-access +rwc
-disable_sem2009
-warn_multiple_driver
-64

//  -uvmhome $UVMHOME

  -uvmhome /tools/cdnc/xcelium/20.03.001/tools/methodology/UVM/CDNS-1.2



// include directories
//*** add incdir include directories here
+incdir+${TRAINING_HOME}/src/
+incdir+${TRAINING_HOME}/src/seq_library
+incdir+${TRAINING_HOME}/examples/src/
+incdir+${TRAINING_HOME}/examples/tests/
+incdir+${TRAINING_HOME}/examples/tb/

// compile files
//*** add compile files here
-sv ${TRAINING_HOME}/src/gfb_interface.sv
-sv ${TRAINING_HOME}/src/gfb_pkg.sv
-sv ${TRAINING_HOME}/src/seq_library/gfb_seq_pkg.sv
-sv ${TRAINING_HOME}/examples/src/gfb_env_pkg.sv
-sv ${TRAINING_HOME}/examples/tests/gfb_test_pkg.sv
-sv ${TRAINING_HOME}/examples/tb/top.sv
// -seed random

-LINEDEBUG

// +UVM_TESTNAME=simple_rep_test
// +UVM_VERBOSITY=UVM_HIGH
// +UVM_NO_RELNOTES


// +SVSEED=RANDOM

