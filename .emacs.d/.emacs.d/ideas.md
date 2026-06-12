# Project Execution Idea: Makefile & CMake Integration for Emacs Runner

## Overview

This document describes a simple and practical approach to integrating build systems like Makefile and CMake into a generic execution system (e.g. Emacs runner-mode).

The goal is not to re-implement build systems, but to detect and delegate execution to them correctly, similar to how modern IDEs work.

---

## Core Idea

Instead of parsing build scripts, we:

> Detect project type → delegate execution to the native build tool → optionally use generated metadata

---

## Supported Build Systems

### Makefile

GNU Make — build automation tool

:contentReference[oaicite:0]{index=0}

#### Detection
- Presence of `Makefile` in project root

#### Execution strategy
```text
make
make run
make test
```

#### Key idea
Make already defines execution targets. No parsing required.

---

### CMake

CMake — cross-platform build system

:contentReference[oaicite:1]{index=1}

#### Detection
- Presence of `CMakeLists.txt`

#### Execution strategy

Configure:
```bash
cmake -S . -B build
```

Build:
```bash
cmake --build build
```

Optional:
```bash
cmake --build build --target run
```

---

## Advanced CMake Integration

Instead of parsing `CMakeLists.txt`, use:

### compile_commands.json

Generated via:
```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
```

#### Purpose

Contains real compilation commands:

```json
{
  "file": "main.cpp",
  "command": "g++ -I... -D... main.cpp -o main"
}
```

#### Why it matters

- real compiler flags
- include paths resolved
- no need to interpret CMake DSL

---

## Execution Strategy (Unified Model)

All systems reduce to:

```
project → detect backend → run command
```

### Decision flow

```
if Cargo.toml → cargo run
if Makefile → make
if CMakeLists.txt → cmake build
if compile_commands.json → use exact compile command
else → manual runner config
```

---

## Key Principle

Do NOT parse build systems.  
Do NOT interpret DSL logic.  
DO delegate execution to tools themselves.

---

## Why this works

### Makefile
- already defines execution targets

### CMake
- generates build system
- produces compile_commands.json

### compile_commands.json
- canonical compilation database
- used by IDEs and LSP (e.g. clangd)

---

## Benefits

- no fragile parsing logic
- cross-platform
- matches real IDE behavior
- integrates with LSP tooling
- easy to extend (Cargo, npm, etc.)

---

## Future Extensions

- Cargo (Rust)
- npm scripts (Node.js)
- per-project caching
- Emacs compile integration
- smarter F5 run system

---

## Conclusion

Build systems are not parsed — they are executed.

Runner system responsibility:

- detect project type
- choose backend
- trigger execution
```





















;;; project-runner.el --- simple project execution router -*- lexical-binding: t; -*-

(require 'project)
(require 'compile)

;;; -----------------------------
;;; detection
;;; -----------------------------

(defun pr--project-root ()
  (when-let ((p (project-current)))
    (project-root p)))

(defun pr--file-exists-in-root (file)
  (let ((root (pr--project-root)))
    (when root
      (file-exists-p (expand-file-name file root)))))

(defun pr--detect-backend ()
  (cond
   ((pr--file-exists-in-root "Cargo.toml") 'cargo)
   ((pr--file-exists-in-root "Makefile") 'make)
   ((pr--file-exists-in-root "CMakeLists.txt") 'cmake)
   (t 'manual)))

;;; -----------------------------
;;; commands
;;; -----------------------------

(defun pr--command ()
  (pcase (pr--detect-backend)

    ('cargo
     "cargo run")

    ('make
     "make")

    ('cmake
     "cmake --build build")

    (_
     (read-string "Run command: "))))

;;; -----------------------------
;;; main entry
;;; -----------------------------

(defun pr-run ()
  "Run current project (like IDE run button)."
  (interactive)

  (let ((default-directory (or (pr--project-root)
                               default-directory)))

    (compile (pr--command))))

;;; -----------------------------
;;; keybinding (optional)
;;; -----------------------------

(global-set-key (kbd "<f5>") #'pr-run)

(provide 'project-runner)
;;; project-runner.el ends here
