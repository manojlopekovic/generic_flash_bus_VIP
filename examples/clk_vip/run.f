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
+incdir+/project/users/manojlop/training/uvm_struct_folder/src/
+incdir+/project/users/manojlop/training/uvm_struct_folder/examples/src/

// compile files
//*** add compile files here
-sv /project/users/manojlop/training/uvm_struct_folder/src/_interface.sv
-sv /project/users/manojlop/training/uvm_struct_folder/src/_pkg.sv
-sv /project/users/manojlop/training/uvm_struct_folder/src/_seq_pkg.sv
-sv /project/users/manojlop/training/uvm_struct_folder/examples/src/_env_pkg.sv
-sv /project/users/manojlop/training/uvm_struct_folder/examples/tests/_test_pkg.sv
-sv /project/users/manojlop/training/uvm_struct_folder/examples/tests/top.sv
-seed random

-LINEDEBUG

+UVM_TESTNAME=simple_rep_test
+UVM_VERBOSITY=UVM_HIGH
+UVM_NO_RELNOTES


// +SVSEED=RANDOM

