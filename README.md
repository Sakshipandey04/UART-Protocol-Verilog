# UART-Protocol-Verilog
UART TX/RX design and simulation using Verilog and Vivado

## Overview
This project implements a Universal Asynchronous Receiver Transmitter (UART) protocol using Verilog HDL. 
The design includes separate Transmitter (TX) and Receiver (RX) modules and a top-level loopback module for verification.

## Features
- UART Transmitter and Receiver
- FSM-based design
- Configured for 8 data bits, 1 start bit, 1 stop bit
- Loopback testing (TX connected to RX)
- Verified using behavioral simulation in Xilinx Vivado
## FSM State
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/4adb728c-fe81-4f23-94c8-56ccec35ab52" />

Image shows Tx FSM state

## Tools Used
- Verilog HDL
- Xilinx Vivado
- Vivado Simulator (xsim)

## Project Structure
- `rtl/` : UART TX, RX, and Top module
- `tb/`  : Testbench for top module
- `docs/`: Simulation waveform screenshots (optional)

## Verification
The design was verified through behavioral simulation.  
Successful transmission and reception of data (0x55) was observed using loopback testing.

## Status
✔ RTL Design  
✔ Testbench  
✔ Simulation Verified  
✔ Loopback Tested  

## Author
Sakshi Pandey
sakshipan14@gmail.com
