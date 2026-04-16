class apb_test extends uvm_test;
	`uvm_component_utils(apb_test)
  apb_env env;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db
    env = apb_env::type_id::create("env",this);
  endfunction
endclass

class smoke_test extends apb_test;
  `uvm_component_utils(smoke_test)
  
  task run_phase;
    phase.raise_objection(this);
    apb_smoke_seq::type_id::create("seq").start(env.agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class write_read_test extends apb_test;
  `uvm_component_utils(write_read_test)
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apb_write_read_seq::type_id::create("seq").start(env.agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class back2back_test extends apb_test;
  `uvm_component_utils(back2back_test)
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apb_back2back_seq::type_id::create("seq").start(env.agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class random_test extends apb_test;
  `uvm_component_utils(random_test)
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apb_random_seq::type_id::create("seq").start(env.agt.seqr);
    phase.drop_objection(this);
  endtask
endclass
