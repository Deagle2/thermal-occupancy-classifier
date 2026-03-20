# thermal-occupancy-classifier

## Abstract
This project implements an FPGA-based room occupancy detector with fully on-device inference.
- Implements a static INT8 inference engine
- An 8×8 thermal frame is streamed over SPI and classified using a fixed-cycle perceptron (MAC-based)
- The final decision directly drives an LED in real time.
- 64-cycle MAC loop per frame

## System Overview

The data path is:

Thermal Camera (8×8) → SPI Stream → FPGA Perceptron Core → LED

### Development
- FPGA board: Vicharak Shrike Lite  
- MCU: RP2040 (SPI frame source)  
- Runtime: fully edge (no cloud / CPU inference)  
- Verification: synthetic frame streaming  

---

<p align="center">
  <img src="https://github.com/user-attachments/assets/41e32d41-80a9-4b3a-bc47-ea65c40b2a3c" width="400"/>
</p>

<p align="center"><em>Thermal frame (8×8) : *Red pixels = warm, blue pixels = cold*</em></p>

---
