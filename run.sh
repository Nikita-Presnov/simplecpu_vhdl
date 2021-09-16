#!/bin/bash
echo "analys rv32.vhd"
ghdl -a --std=08 -fsynopsys rv32.vhd
echo "elaborate rv32.vhd" 
ghdl -e --std=08 -fsynopsys rv32
echo "run rv32.vhd"
ghdl -r --std=08 -fsynopsys rv32
echo "analys rv32_tb.vhd"
ghdl -a --std=08 -fsynopsys rv32_tb.vhd
echo "elaborate rv32_tb.vhd" 
ghdl -e --std=08 -fsynopsys rv32_tb
echo "run sim"
ghdl -r --std=08 -fsynopsys rv32_tb --vcd=output.vcd --stop-time=200ns
# gtkwave output.vcd > /dev/null 2>&1
