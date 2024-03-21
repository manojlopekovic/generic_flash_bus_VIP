#UVM TEST NAME
test_name = simple_rep_test
#UVM VERBOSITY
uvm_verbosity = UVM_LOW 
#UVM RNG SEED
rand_seed = random
# quit count for uvm
quit_count = 1
# message for git commit
msg = ""

all: clean run
all_gui : clean run_gui
all_debug : clean run_debug
all_reset : clean run_reset
all_reset_gui : clean run_reset_gui
all_reset_debug : clean run_reset_debug
all_cov : clean run_cov


clean : 
	@rm -rf xcelium.d xrun* simv* *.txt *.trn *.dsn *.ini *.opt *.vstf *.wlf csrc* *.tar.gz *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *~ transcript work/ INCA_libs/ xcelium.* xrun.* waves* *.err cov_*
run : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count)
run_gui : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count) -gui
run_debug : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count) -gui - LINEDEBUG
run_reset : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count) +define+RST_EN
run_reset_gui : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count) +define+RST_EN -gui
run_reset_debug : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count) +define+RST_EN -gui -LINEDEBUG
run_cov : 
	@xrun -f ${TRAINING_HOME}/run.f +UVM_TESTNAME=$(test_name) +UVM_VERBOSITY=$(uvm_verbosity) -seed $(rand_seed) +UVM_MAX_QUIT_COUNT=$(quit_count) -coverage all


add_commit: add commit
add_commit_pull: add commit pull
add:
	git add ../../.
commit: 
	git commit -m "${msg}"
pull:
	git pull
push:
	git push
status:
	git status