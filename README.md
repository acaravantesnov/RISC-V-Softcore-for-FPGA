# RV32I_Core

This repository contains the design in VHDL of a single-core RISC-V microprocessor (RV32I). It can execute up to 43 different instructions, manage peripherals and handle exceptions.
This core has been implemented on an Artix 7 XC7A35T FPGA.

- "20230602_TFG_AlbertoC" is the documentation of this project. It is a file written in Spanish that has been handed to University Carlos III de Madrid as my final capstone project.
- "srcs" folder contains all the VHDL design files. This includes components, packages and testbenches. The top module entity is RISCV_CPU.
- "Compiler" folder contains the C++ compiler I have coded in order to generate machine code from RISC-V assembly instructions. It is compiled with the use of a Makefile and its execution follows the followoing structure ./ensamblador_riscv <inputfile.s>
- "Algorithm" folder contains 3 different algorithms used as examples. They are coded in C, RISC-V Assembly and machine code formats.
