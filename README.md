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

---

## Recent Update: Multi-Source Data Fusion

The project has been upgraded from a single-stream bridge to a **Dual-Source Data Processing Pipeline**. It now synchronizes data from two different file formats, performs hardware-level arithmetic, and transmits the computed results via APB.

### New Features
* **Dual-Stream Parsing:** Simultaneous ingestion of `.txt` (Binary) and `.csv` (Data) files.
* **Hardware Arithmetic:** Integrated a **Ripple Carry Adder (RCA)** to perform real-time data fusion.
* **Bit-Slicing Logic:** Logic to extract specific bit-fields from the binary stream before addition.
* **Multi-FIFO Synchronization:** Dual-buffer architecture to decouple independent file-reading rates from the processing core.



### Updated Data Flow
1. **Extraction:** `File_Reader_A` (.txt) and `File_Reader_B` (.csv) push data into independent Synchronous FIFOs.
2. **Processing:** The system **bit-slices** the binary data and feeds it into the **Ripple Carry Adder** along with the CSV data.
3. **Transmission:** The **APB Master** fetches the *summation result* from the adder and executes the standard 9-cycle APB write transaction.

### Technical Specs (Updated)
| Feature | Specification |
| :--- | :--- |
| **Input Sources** | 1x Binary (.txt), 1x Spreadsheet (.csv) |
| **Arithmetic Unit** | Parameterized Ripple Carry Adder |
| **Buffer Type** | Dual Synchronous FIFOs |
| **Bus Protocol** | AMBA 3 APB |

![Notes_260211_094620](https://github.com/user-attachments/assets/2e0a7916-1357-45da-99bd-262813c7b700)

---
