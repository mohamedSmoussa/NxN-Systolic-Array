NxN Systolic Array 🚀
=====================

.. image:: https://img.shields.io/badge/HDL-SystemVerilog-blue
.. image:: https://img.shields.io/badge/FPGA-Synthesis-green
.. image:: https://img.shields.io/badge/Application-AI%20Accelerator-red

Author: **Mohamed Shaban Moussa**  
📧 `mohamedmouse066@gmail.com <mailto:mohamedmouse066@gmail.com>`_  
🔗 `GitHub Repository <https://github.com/mohamedSmoussa/NxN-Systolic-Array>`_

Project Overview
----------------
This repository implements a **parameterizable NxN systolic array** for **matrix multiplication** in **SystemVerilog**.  
Systolic arrays are the backbone of **AI accelerators (e.g., TPUs)**, enabling efficient **multiply-accumulate (MAC)** operations for:

- Neural network inference (Dense & Convolution layers)  
- Digital Signal Processing (DSP)  
- Scientific computing  

Architecture
------------
**Top Module: ``systolic_array``**

- Handles input pipelining and output validation.  
- Uses counters to capture output rows at correct clock cycles.  
- Asserts ``valid_out`` when results are ready.  

**Pipelining Module: ``REG``**

- Parameterized delay-line registers.  
- Supports dynamic delay stages per input.  
- Ensures proper timing for systolic data flow.  

**PE Grid: ``PEs_GRID``**

- Dynamically builds an ``N_SIZE × N_SIZE`` systolic mesh.  
- Uses nested generate loops for scalability.  
- Connects PEs in a 2D mesh (top→down, left→right).  

**Processing Element (PE)**

- Performs Multiply-Accumulate (MAC).  
- Forwards results diagonally through the systolic array.  
- Ensures correct propagation for lower PEs.  

Features
--------
- ✅ Parameterizable ``N_SIZE`` (3×3, 5×5, 7×7, 10×10, …)  
- ✅ Configurable ``DATAWIDTH`` (8/16 bits for quantized AI ops)  
- ✅ Fully synchronous systolic pipeline  
- ✅ Modular design with reusable PEs  
- ✅ FPGA & ASIC synthesis-ready  
- ✅ Verified with Python/NumPy reference models  

Repository Structure
--------------------
::

   ├── src/                   # RTL source code  
   │   ├── systolic_array.sv  # Top-level NxN systolic array  
   │   ├── pe.sv              # Processing Element  
   │   ├── reg.sv             # Parametric delay registers  
   │   └── grid.sv            # PE grid generator  
   │
   ├── tb/                    # Testbenches  
   │   ├── systolic_tb.sv     # Main testbench  
   │   └── vectors/           # Example test inputs/outputs  
   │
   ├── docs/                  # Documentation, schematics & waveforms  
   │
   └── README.rst             # This file  

How to Run
----------
**Simulation (Icarus Verilog)**::

   # Compile design + testbench
   iverilog -g2012 -o systolic_tb.vvp tb/systolic_tb.sv src/*.sv

   # Run simulation
   vvp systolic_tb.vvp

   # View waveforms
   gtkwave systolic_tb.vcd

**FPGA Synthesis**

1. Import ``src/`` into Vivado / Quartus.  
2. Configure ``N_SIZE`` and ``DATAWIDTH``.  
3. Generate bitstream and program FPGA.  

Timing Behavior
---------------
- Output ready after ``(3N – 2) cycles``  
- Row-by-row completion:  
  - First row → cycle ``(2N – 1)``  
  - Last row → cycle ``(3N – 2)``  

✅ Verified for ``N_SIZE = 3, 5, 7, 10``.  

Challenges & Solutions
----------------------
- Manual register instantiation → solved with parametric ``REG``.  
- Manual PE instantiation → solved with nested generate loops.  
- Signal width mismatches → solved by overwriting parameters (``DATAWIDTH``).  

Documentation & Results
-----------------------
- Schematics for N=3, 5, 7, 10  
- Simulation waveforms showing row-wise output  
- Test cases confirm matrix multiplication correctness  

License
-------
MIT License – Free to use for **learning, research, and AI accelerator development**.  

✨ This project can serve as a **building block for TPU-style AI accelerators** or as a **standalone systolic array engine** for matrix operations.  
