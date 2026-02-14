# StellaSwift — Type Checker for the Stella Language

StellaSwift is a **type checker** for the teaching language **Stella**, implemented in **Swift** using **ANTLR**.  
It reads a Stella program, builds an **Abstract Syntax Tree (AST)**, and performs **static type checking** according to the assignment specification for:

- core Stella (booleans, natural numbers, functions);
- unit type;
- tuples and records;
- let-bindings;
- type ascriptions;
- sum types and variants;
- built-in lists;
- fixpoint combinator.

The tool is designed to be **command-line only** and to work correctly with **stdin / stdout / stderr** so it can be used by automated checkers.

---

## 1. Project Structure

- `Sources/StellaSwift/AST.swift` — AST definitions for Stella (types, expressions, patterns, etc.).
- `Sources/StellaSwift/ASTBuilder.swift` — ANTLR-based visitor that converts the parse tree into the AST.
- `Sources/StellaSwift/TypeChecker.swift` — bidirectional type checker with all required error codes.
- `Sources/StellaSwift/StellaSwift.swift` — main entry point, CLI, stdin/stdout/stderr handling, flags.
- `examples/` — sample Stella programs:
  - correct programs;
  - programs that trigger specific type errors.

---

## 2. What This Package Does

- **Input**: a Stella program, provided either:
  - via a **file** passed as a command-line argument, or
  - via **stdin** (pipe or input redirection).
- **Processing**:
  1. Optional printing of the **original source** (`--source`).
  2. Optional printing of the **ANTLR parse tree** (`--parse-tree`).
  3. Building a **high-level AST** from the parse tree.
  4. Running the **type checker** on the AST.
- **Output**:
  - If the program is **well-typed**:
    - produces no output;
    - exits with code **0**.
  - If a **type error** is found:
    - prints **one error message** to **stderr** (with one of the specified error codes, e.g. `ERROR_UNEXPECTED_TYPE_FOR_EXPRESSION`);
    - exits with a **non-zero** code (1).


---

## 3. Requirements

In practice, you just need a working **Swift toolchain** for your platform — nothing more:

- **macOS**
  - Install **Xcode** from the App Store, or the official Swift toolchain from `swift.org`.
  - This gives you `swift`, `swift build`, and Swift Package Manager out of the box.

- **Linux**
  - Install Swift from `swift.org` following the instructions for your distribution.
  - After installation, you should have the `swift` and `swift build` commands available.

- **Windows**
  - Recommended: install **WSL2** with a Linux distribution (e.g. Ubuntu).
  - Inside WSL, install Swift exactly as on Linux and use the same commands.

Notes:

- The ANTLR runtime for Swift is pulled automatically as a Swift Package dependency — you do **not** need to install ANTLR manually.
- The first `swift build` may require internet access to download dependencies; subsequent builds can run offline.

---

## 4. Building the Project (Any Platform)

From the project root:

```bash
swift build
```

---

## 5. CLI Usage and Examples

All commands below are executed from the project root.

### 5.1 Basic usage

```bash
swift run StellaSwift [options] [file]
swift run StellaSwift < input.stella
echo "language core; fn main(n : Nat) -> Nat { return n }" | swift run StellaSwift
```

### 5.2 Options

- `-h`, `--help` — show help message.
- `--parse-tree` — show ANTLR parse tree before type checking.
- `--ast` — show Abstract Syntax Tree before type checking.
- `--source` — show original Stella source code before analysis.

### 5.3 Examples (from `StellaSwift.swift`)

```bash
# 1. Build
swift build

# 2. Simple run
swift run StellaSwift examples/01_simple.stella

# 3. With AST
swift run StellaSwift --ast examples/03_with_tuples.stella

# 4. With parse tree
swift run StellaSwift --parse-tree examples/04_with_records.stella

# 5. With source code
swift run StellaSwift --source examples/01_simple.stella

# 6. All debug flags
swift run StellaSwift --source --parse-tree --ast examples/03_with_tuples.stella

# 7. Running default test program (uses built-in sample)
swift run StellaSwift
```
