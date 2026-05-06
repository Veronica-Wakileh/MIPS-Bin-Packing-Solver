# Bin Packing Problem Solver in MIPS Assembly

A MIPS Assembly implementation of the Bin Packing Problem using two classic heuristics: **First Fit (FF)** and **Best Fit (BF)**. The program reads item sizes from an input text file, packs them into unit-capacity bins using the chosen heuristic, and writes the result to an output file.

## Course Information

- **University:** Birzeit University
- **Course:** ENCS4370 – Computer Architecture
- **Semester:** Spring 2024/2025
- **Project:** Project #1 – Bin Packing Problem Solution Using MIPS Assembly
- **Language:** MIPS Assembly

## Project Description

Given a list of items `I1, I2, ..., In` with floating-point sizes `S1, S2, ..., Sn` where `0 < Si ≤ 1`, the goal is to pack all items into the minimum number of bins of unit capacity (capacity = 1).

The solver supports two heuristics, both of which process items in the order they appear in the input file.

## Features

- Interactive menu that loops until the user chooses to quit.
- Reads item sizes from a user-specified input text file.
- Validates the file (existence and content format) before processing.
- Case-insensitive selection of heuristic algorithm.
- Writes the result to an output text file (`output.txt`) including the algorithm used, the number of bins, and the items inside each bin.
- Clear error messages for invalid file paths, invalid file content, and invalid menu input.

## Algorithms Implemented

### 1. First Fit (FF)
Bins are indexed sequentially `1, 2, 3, ...`. For each item `Ii`, the algorithm scans bins in order and places the item in the **first** bin whose remaining capacity is at least `Si`. If no existing bin fits, a new bin is opened.

### 2. Best Fit (BF)
For each item `Ii`, the algorithm scans all currently open bins and places the item in the **fullest** bin that still has enough remaining capacity (i.e. the bin that, after insertion, will have the least leftover space). If no existing bin fits, a new bin is opened.

## How the Program Works

1. The program prints a welcome message and shows the main menu.
2. The user chooses to either read an input file (`R`/`r`) or quit (`Q`/`q`).
3. The user enters the path to the input file. The program validates the file and its contents.
4. After a successful read, the user chooses a heuristic:
   - `F`/`f` → First Fit
   - `B`/`b` → Best Fit
   - `Q`/`q` → Quit
5. The selected heuristic runs and the user can then save the result to `output.txt` (`P`/`p`), go back (`Z`/`z`), or quit (`Q`/`q`).
6. The menu continues to loop until the user explicitly quits.

## Input File Format

- A plain text file (`.txt`).
- Each line contains a single floating-point item size in the range `(0, 1]`.
- Sizes use a decimal point (e.g. `0.42`).
- Empty lines and non-numeric content are treated as invalid.

Example (`input.txt`):
```
0.5
0.7
0.3
0.2
0.8
0.4
```

## Output File Description

The program writes the result to `output.txt` in the working directory. The output contains:

- The name of the heuristic that was used.
- The total number of bins required.
- A list of bins with the items packed into each one.

Example (`output.txt`):
```
- The algorithm used is : First Fit
- The number of bins used is : 3
____________________________________________
Bin: 1
Items: 0.5 0.3 0.2
____________________________________________
Bin: 2
Items: 0.7
____________________________________________
Bin: 3
Items: 0.8 0.4
```

## How to Run

The project runs on any standard MIPS simulator. The recommended options are **MARS** and **QtSPIM**.

### Using MARS
1. Open MARS.
2. Go to **File → Open** and select `Project1.asm`.
3. Assemble the program: **Run → Assemble** (or `F3`).
4. Run the program: **Run → Go** (or `F5`).
5. Interact with the program through the **Run I/O** console.

> **Note:** Make sure the input file is placed in a path accessible to MARS. By default, MARS uses the directory from which it was launched as the working directory. The output file `output.txt` will be created in that same directory.

### Using QtSPIM
1. Open QtSPIM.
2. Load the file via **File → Reinitialize and Load File** and select `Project1.asm`.
3. Run the program from the simulator console and follow the on-screen menu.

## File Structure

```
├── Project1.asm        # Main MIPS Assembly source file
└── README.md           # Project documentation
```

## Validation and Error Handling

The program handles the following cases:

- **File not found / cannot be opened:** an error message is printed and the user is returned to the menu.
- **Invalid file content:** if the file contains non-numeric values, values outside the range `(0, 1]`, or malformed lines, the program prints an "invalid input in the file" message and returns to the menu.
- **Invalid menu input:** any character other than the expected options triggers an "invalid choice" message, and the user is prompted to re-enter a valid option.
- **Case insensitivity:** all menu inputs accept both uppercase and lowercase letters.

## Skills Demonstrated

- Programming in MIPS Assembly (data segment, text segment, syscalls, branching, loops).
- File I/O in MIPS using system calls (open, read, write, close).
- Manual parsing of ASCII input into floating-point values.
- Floating-point arithmetic and comparison using FPU registers.
- Working with arrays and a 2D structure to represent bins and their items.
- Implementing greedy heuristic algorithms (First Fit and Best Fit).
- Designing an interactive menu-driven user interface in low-level code.
- Input validation and structured error handling at the assembly level.

## Partners

- Shahd Sbaih – 1220060
- Veronica Wakileh – 1220245

---

*Submitted for ENCS4370 – Computer Architecture, Birzeit University, Spring 2024/2025.*
