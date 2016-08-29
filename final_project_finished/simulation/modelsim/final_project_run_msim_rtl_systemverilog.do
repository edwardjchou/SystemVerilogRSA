transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/ejchou2/workspace/final_project_501v4/final_project {C:/Users/ejchou2/workspace/final_project_501v4/final_project/multiplier_sm.sv}
vlog -sv -work work +incdir+C:/Users/ejchou2/workspace/final_project_501v4/final_project {C:/Users/ejchou2/workspace/final_project_501v4/final_project/modular.sv}
vlog -sv -work work +incdir+C:/Users/ejchou2/workspace/final_project_501v4/final_project {C:/Users/ejchou2/workspace/final_project_501v4/final_project/generate_d.sv}
vlog -sv -work work +incdir+C:/Users/ejchou2/workspace/final_project_501v4/final_project {C:/Users/ejchou2/workspace/final_project_501v4/final_project/modular_multiplication.sv}
vlib final_project_soc
vmap final_project_soc final_project_soc

vlog -sv -work work +incdir+C:/Users/ejchou2/workspace/final_project_501v4/final_project {C:/Users/ejchou2/workspace/final_project_501v4/final_project/testbench_gend.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L final_project_soc -voptargs="+acc"  testbench_gend

add wave *
view structure
view signals
run 10000 ns
