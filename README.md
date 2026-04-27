# FPGA-ThermAI — Real-Time Thermal Management on FPGA

A hardware-embedded machine learning system that predicts and regulates FPGA temperature in real time using VHDL-based implementation. The system demonstrates on-chip inference and adaptive thermal control without relying on external processors.

---

## Hardware

- Spartan-6 XC6SLX9 FPGA  
- On-chip and external temperature sensing (conceptual / simulated inputs)  
- Voltage and current monitoring inputs  
- PWM-controlled cooling mechanism  

---

## Key Results

- Real-time temperature prediction using hardware-implemented ML logic  
- Low-latency response due to on-chip execution  
- Adaptive PWM-based cooling control  
- Reinforcement learning-inspired state and reward mechanism  
- Demonstration of closed-loop thermal management system  

---

## Tech Stack

- VHDL  
- FPGA (Spartan-6)  
- Vivado (Simulation and Synthesis)  
- Python (Model development)  
- Scikit-learn  
- Fixed-point arithmetic implementation  

---

## System Overview

The system follows a hardware-software co-design approach:

1. A machine learning model is developed and validated in Python using a controlled synthetic dataset.  
2. The learned behavior is translated into a hardware-efficient approximation using fixed-point arithmetic.  
3. The model is implemented in VHDL and deployed on FPGA for real-time inference.  
4. PWM signals are dynamically adjusted to regulate temperature based on predicted values.  

---

## Dataset

The model is trained on a synthetically generated dataset designed to emulate FPGA thermal and power characteristics under controlled conditions.

The dataset is not included in this repository. For reproducibility, a fallback dataset is embedded within the code, allowing the project to run without external files.

---

## Model Considerations

Due to the limited size of the synthetic dataset, the machine learning model may exhibit overfitting behavior. However, the primary objective of this work is to demonstrate the integration of machine learning with FPGA hardware and validate real-time thermal control logic.

This project focuses on system-level design, hardware implementation, and real-time adaptability rather than large-scale model generalization.

---

## What Makes It Unique

- Machine learning logic deployed directly on FPGA fabric  
- No dependency on external processors or cloud-based inference  
- Hardware-efficient approximation of ML behavior using VHDL  
- Integration of prediction, control, and decision logic in a single system  
- Emphasis on real-time embedded thermal management  

---

## Future Work

- Integration with real sensor data from FPGA hardware  
- Replacement of synthetic dataset with real-time measurements  
- Deployment of more advanced ML models with optimized hardware mapping  
- Pipeline optimization and resource-aware design improvements  

---
