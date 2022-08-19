quietly set ACTELLIBNAME ProASIC3E
quietly set PROJECT_DIR "C:/VHDL/Baudgen"

if {[file exists ../designer/impl1/simulation/postlayout/_info]} {
   echo "INFO: Simulation library ../designer/impl1/simulation/postlayout already exists"
} else {
   file delete -force ../designer/impl1/simulation/postlayout 
   vlib ../designer/impl1/simulation/postlayout
}
vmap postlayout ../designer/impl1/simulation/postlayout
vmap proasic3e "C:/Microsemi/Libero_SoC_v11.9/Designer/lib/modelsim/precompiled/vhdl/proasic3e"

vcom -2008 -explicit  -work postlayout "${PROJECT_DIR}/designer/impl1/main_circuit_ba.vhd"
vcom -2008 -explicit  -work postlayout "${PROJECT_DIR}/hdl/baud_gen.vhd"
vcom -2008 -explicit  -work postlayout "${PROJECT_DIR}/hdl/transmitter.vhd"
vcom -2008 -explicit  -work postlayout "${PROJECT_DIR}/hdl/uart_receiver.vhd"
vcom -2008 -explicit  -work postlayout "${PROJECT_DIR}/hdl/UART.vhd"
vcom -2008 -explicit  -work postlayout "${PROJECT_DIR}/stimulus/my_test_bench.vhd"

vsim -L proasic3e -L postlayout  -t 1ps -sdfmax /main_circuit_0=${PROJECT_DIR}/designer/impl1/main_circuit_ba.sdf postlayout.my_test_bench
add wave /my_test_bench/*
run 1000ns


