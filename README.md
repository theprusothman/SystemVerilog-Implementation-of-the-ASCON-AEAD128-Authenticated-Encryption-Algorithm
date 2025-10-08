# SystemVerilog Implementation of the ASCON-AEAD128 Algorithm

## 🔒 Overview
This project implements the **ASCON-AEAD128 authenticated encryption algorithm** using **SystemVerilog**.  
ASCON, recently standardized by **NIST** as part of the Lightweight Cryptography competition, is designed to provide strong **confidentiality** and **authenticity** while maintaining **low hardware complexity**.

The objective of this work is to model and simulate the ASCON algorithm in hardware through a modular and verifiable digital architecture.

---

## 🧩 Project Objectives
- Design a complete hardware model of the **ASCON-AEAD128** algorithm.  
- Implement the **320-bit state permutation** (PC, PS, PL) and its control logic.  
- Develop a **Finite State Machine (FSM)** to coordinate all encryption stages.  
- Validate the design through **SystemVerilog testbenches** using reference test vectors.

---

## ⚙️ Architecture Overview
The hardware architecture is composed of several functional blocks:

- **Permutation Block (Permutation_XOR)**  
  Implements the three layers of ASCON:  
  - `PC`: Round constant addition  
  - `PS`: Non-linear substitution (S-box)  
  - `PL`: Linear diffusion through bit rotations and XOR operations  

- **XOR Modules**  
  - `Xor_Begin`: Injects associated data or plaintext into the state  
  - `Xor_End`: Produces the final tag or intermediate transformations  

- **Finite State Machine (FSM)**  
  Controls all stages of the algorithm — initialization, associated data, plaintext processing, and finalization — as well as synchronization and signal activation.

- **State and Output Registers**  
  - 320-bit register for the internal state `S`  
  - Registers for ciphertext (`C1`, `C2`, `C3`) and authentication tag (`T`)

---

## 🧠 Algorithm Summary
ASCON-AEAD128 operates on a **320-bit state**, divided into five 64-bit registers `{S0, S1, S2, S3, S4}`.  
It follows four main phases:

1. **Initialization** – Combines key, nonce, and initialization vector (IV), followed by permutation `p12`.  
2. **Associated Data Processing** – Integrates associated data with the state using `p8`.  
3. **Plaintext Encryption** – XORs plaintext blocks with the state to produce ciphertext.  
4. **Finalization** – Applies a final permutation `p12` and computes the authentication tag `T`.

---

## 🧪 Simulation and Validation
- Simulated with **ModelSim** (or any compatible HDL simulator).  
- Testbenches provided for:
  - Individual modules (`PC`, `PS`, `PL`, `XOR`, `FSM`)
  - Full system integration (`ascon_top`)
- Expected results match the **reference outputs** provided in the official ASCON specification:
