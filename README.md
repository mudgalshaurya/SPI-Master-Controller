# 12-Bit SPI Master Controller

**Author:** Shaurya Mudgal

This repository contains the complete hardware RTL design for a parametrized, 12-bit Serial Peripheral Interface (SPI) Master Controller. It is designed to establish reliable, synchronous serial communication with peripheral slave devices.

## 📌 Project Overview

The core objective of this project is to manage the strict timing and data frame transmission required by the SPI protocol. The design translates parallel data into a serial bitstream and manages the necessary clocking and chip-select signaling.

Key architectural features include:
1. **12-bit Data Transfer:** Configured to accurately send and receive custom 12-bit data payloads.
2. **LSB-First Format:** Systematically shifts data out Least Significant Bit first, aligning with specific peripheral requirements.
3. **Custom Clock Divider:** A dedicated hardware block that steps down the main system clock to generate a stable, synchronized Serial Clock (SCLK).
4. **4-State FSM:** A highly optimized Finite State Machine (Idle, Start, Transfer, Done) that dictates frame timing, drives the active-low chip select (`cs_n`), and triggers a completion flag.

## 🗂️ File Structure

The repository focuses strictly on the RTL components and the simulation environment used for verification.

### 1. Hardware (RTL) - Verilog
*   `top_level.v`: The uppermost structural module that instantiates and wires the core SPI logic and the clock generator together.
*   `spi_master.v`: The main control block housing the 4-state FSM, parallel-to-serial shift registers, and the LSB-first transfer logic.
*   `clk_divider.v`: The timing block responsible for generating SCLK and its corresponding internal rising/falling edge triggers.

### 2. Verification Environment - Verilog
*   `tb_spi_master.v`: The behavioral testbench used to drive the clock, assert the reset sequence, simulate a slave device response, and verify the transaction logic on the `mosi` and `miso` lines.

## 🚀 Project Status & Milestones

**Hardware Design & Integration (Completed)**
*   Engineered core RTL components from scratch using standard Verilog.
*   Successfully implemented clock division logic to generate a reliable SCLK independent of the main system clock speed.
*   Constructed a robust FSM to prevent data corruption during frame start and stop conditions.

**Simulation & Verification (Completed)**
*   Developed a Verilog testbench to simulate real-world master-slave interactions.
*   Compiled and executed behavioral simulations using Xilinx Vivado.
*   Validated the complete 12-bit transaction lifecycle, confirming accurate data shifting and precise `cs_n` assertion.

## 🛠️ Tools and Technologies

*   **Hardware Description Language:** Verilog
*   **Simulation & Synthesis:** Xilinx Vivado (Behavioral Simulation)
