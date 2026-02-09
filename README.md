# File2Bus: Automated File-Driven APB Interface

## Project Overview
**File2Bus** is a hardware verification and interfacing project designed to automate data transmission from a high-level text file to an **AMBA APB (Advanced Peripheral Bus)** interface. It bridges the gap between software-defined data and hardware bus protocols using an intermediary synchronization buffer.

## Key Features
*   **Automated Data Pipeline:** Streams data directly from a `.txt` file into the hardware environment.
*   **Buffered Architecture:** Utilizes a **FIFO (First-In-First-Out)** memory buffer to decouple file-reading speeds from the APB bus clock.
*   **AMBA APB Implementation:** Features a fully functional **APB Master** that fetches data from the FIFO and executes write transactions to an **APB Slave**.
*   **Precise Timing:** Engineered to complete a full data transfer cycle in exactly **9 clock cycles**.

## Technical Specifications
| Parameter | Specification |
| :--- | :--- |
| **Clock Frequency** | 100 MHz (10ns period) |
| **Latency** | 90ns per frame (Total) |
| **Protocol** | AMBA 3 APB (PSEL, PENABLE, PWRITE, etc.) |
| **Buffer Type** | Synchronous FIFO |

## Internal Architecture & Data Flow
1.  **File Reader Module:** Parses the source `.txt` file and converts ASCII/Hex data into logic-level signals.
2.  **FIFO Buffer:** Stores the parsed data, acting as the bridge between the file-reader logic and the bus logic.
3.  **APB Master:** Monitors the FIFO status; when data is available, it initiates an APB write cycle.
4.  **APB Slave:** The end-point destination that receives and acknowledges the data transfer.

![Notes_260208_200046](https://github.com/user-attachments/assets/2860a07a-bae6-4f32-a1e1-d3996c672ccd)
