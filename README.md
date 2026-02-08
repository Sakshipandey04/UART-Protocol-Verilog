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
<img width="526" height="361" alt="image" src="https://github.com/user-attachments/assets/98b8aa10-d2d6-4624-98a5-02079185f174" />



## UART Transmitter and Receiver FSM Description

The UART protocol is implemented using **Finite State Machines (FSMs)** for both the transmitter (TX) and receiver (RX) to ensure proper sequencing of data transmission and reception.

---

### UART Transmitter (TX) FSM

The UART Transmitter FSM controls the serial transmission of data bits over the `tx` line.

**TX FSM States:**

* **IDLE**:
  Default state where the transmitter remains idle and the TX line is held high. The FSM waits for a `tx_start` signal.

* **START**:
  When transmission is initiated, the FSM sends the start bit (`0`) for one bit duration.

* **BITS**:
  The FSM transmits 8 data bits serially (LSB first). Each bit is held for one baud interval.

* **STOP**:
  The stop bit (`1`) is transmitted to mark the end of the data frame. After this, the FSM returns to the IDLE state.

---

### UART Receiver (RX) FSM

The UART Receiver FSM manages the reception and reconstruction of serial data from the `rx` line.

**RX FSM States:**

* **IDLE**:
  The receiver monitors the RX line and waits for a falling edge indicating the start bit.

* **START**:
  The FSM validates the start bit by sampling the RX line at the mid-bit position.

* **DATA**:
  The FSM samples 8 data bits at the center of each baud interval and stores them in a shift register.

* **STOP**:
  The stop bit is checked to ensure correct frame completion.

* **DONE**:
  The received byte is made available on `rx_data`, and the `rx_done` signal is asserted before returning to IDLE.

---

### Combined UART FSM Operation

The transmitter and receiver FSMs operate independently but can be connected in **loopback mode** where the TX output is directly connected to the RX input. This allows full verification of UART functionality through simulation without external hardware.

---

### UART Frame Format

```
| Start Bit | Data Bits (8) | Stop Bit |
|     0     |   LSB → MSB   |     1    |
```


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
