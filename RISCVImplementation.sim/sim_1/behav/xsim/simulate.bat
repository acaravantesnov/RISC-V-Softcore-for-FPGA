@echo off
REM ****************************************************************************
REM Vivado (TM) v2022.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Tue May 30 20:02:43 +0200 2023
REM SW Build 3671981 on Fri Oct 14 05:00:03 MDT 2022
REM
REM IP Build 3669848 on Fri Oct 14 08:30:02 MDT 2022
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim RISCV_CPU_TB_behav -key {Behavioral:sim_1:Functional:RISCV_CPU_TB} -tclbatch RISCV_CPU_TB.tcl -view C:/Users/acara/OneDrive/Escritorio/TFG/RISCV_CPU_TB_behav1.wcfg -log simulate.log"
call xsim  RISCV_CPU_TB_behav -key {Behavioral:sim_1:Functional:RISCV_CPU_TB} -tclbatch RISCV_CPU_TB.tcl -view C:/Users/acara/OneDrive/Escritorio/TFG/RISCV_CPU_TB_behav1.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
