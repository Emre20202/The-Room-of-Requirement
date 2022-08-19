quietly set ACTELLIBNAME ProASIC3E
quietly set PROJECT_DIR "C:/Users/EMRE/Desktop/Baudgen"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap proasic3e "D:/Drivers/Designer/lib/modelsim/precompiled/vhdl/proasic3e"

vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/basic_arithmetic.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/main_logic.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/baud_gen.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/transmitter.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/uart_receiver.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/UART.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/main_circuit.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/stimulus/my_test_bench.vhd"

vsim -L proasic3e -L presynth  -t 1ps presynth.my_test_bench
add wave /my_test_bench/*
run 1000ns
