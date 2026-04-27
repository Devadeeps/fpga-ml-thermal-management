# FPGA-ThermAI — Real-Time Thermal Management on FPGA

A fully hardware-embedded machine learning system that predicts and controls FPGA temperature in real time — no external processor, no software dependency, complete inference on-chip.


## Hardware

- Spartan-6 XC6SLX9 FPGA  
- On-chip and external temperature sensors  
- Voltage and current sensing modules  
- PWM-controlled cooling fan  


## Key Results

- Real-time temperature prediction with high accuracy and minimal deviation  
- Low-latency thermal control through direct FPGA execution  
- Efficient PWM-based adaptive cooling mechanism  
- Stable reinforcement learning policy for power optimization  
- Reduced thermal stress and improved energy efficiency  


## Tech Stack

- VHDL  
- FPGA (Spartan-6)  
- Vivado  
- Python  
- Scikit-learn  
- Fixed-Point Arithmetic  
- Embedded Machine Learning  


## What Makes It Unique

- Direct ML deployment on FPGA fabric — eliminates external CPU/GPU dependency  
- Hardware-level inference using VHDL for ultra-low latency response  
- Hybrid ML approach combining regression, classification, and reinforcement learning  
- Custom fixed-point implementation optimized for FPGA resource constraints  
- Adaptive cooling driven by predictive analytics instead of static threshold-based control  
