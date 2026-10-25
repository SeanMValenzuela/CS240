# Assignment 5: MIPS FizzBuzz Assembler and Disassembler

Requires Python 3 (no extra libraries).

## Files

| File | Purpose |
|---|---|
| `assembler.py` | Reads `fizzbuzz.asm`, writes `fizzbuzz.mhc-ascii` and `fizzbuzz.mhc-bin` |
| `disassembler.py` | Reads either output format, writes `fizzbuzz_reconstructed.asm` |
| `fizzbuzz.asm` | Original FizzBuzz source |
| `fizzbuzz.mhc-ascii` | Machine code as readable 0/1 text |
| `fizzbuzz.mhc-bin` | Machine code as raw bytes |
| `fizzbuzz_reconstructed.asm` | Source rebuilt by the disassembler |

## How to run

Run everything from the folder containing the files.

```
python3 assembler.py                          # fizzbuzz.asm -> .mhc-ascii and .mhc-bin
python3 disassembler.py                       # reads fizzbuzz.mhc-ascii
python3 disassembler.py fizzbuzz.mhc-bin      # reads the binary instead
python3 disassembler.py <input> <output.asm>  # choose the output name
```

The disassembler detects the input format from the file contents, not the extension.

### Verify the round trip

`assembler.py` always reads `fizzbuzz.asm`, so assemble the reconstructed file in a separate folder:

```
mkdir verify
cp fizzbuzz_reconstructed.asm verify/fizzbuzz.asm
cp assembler.py verify/
(cd verify && python3 assembler.py)
cmp verify/fizzbuzz.mhc-bin fizzbuzz.mhc-bin && cmp verify/fizzbuzz.mhc-ascii fizzbuzz.mhc-ascii && echo IDENTICAL
```

No output from `cmp` means the files match.

## Supported features

- **Directives:** `.data`, `.text`, `.asciiz` (one line, no spaces in the string)
- **Instructions:** `li`, `la`, `move`, `rem`, `beq`, `addi`, `j`, `syscall`
- **Expansions:** `li` becomes `addi`, `move` becomes `add`, `la` becomes `lui` + `ori`, `rem` becomes `div` + `mfhi`
- **Registers:** `$zero`, `$v0`, `$a0`, `$t0`-`$t5`
- **Labels:** `name:` at the start of a line
- **Comments:** `#` in the text section

## Addresses and byte order

- Data starts at `0x10010000`; text starts at `0x00400000`.
- Output is **big-endian**: each 32-bit instruction is written most significant byte first.

## File layout

- **`.mhc-ascii`:** line 1 holds the data bytes as 8-bit binary text (strings end in a zero byte). Each following line is one 32-bit instruction.
- **`.mhc-bin`:** the data bytes first (19 for FizzBuzz), then 4 bytes per instruction (50 instructions), 219 bytes in total. There is no separator, so the disassembler finds the end of the data by reading null-terminated strings until the bytes stop looking like text.

## Errors

Both programs stop with a message that includes a line number (assembler) or address (disassembler). Covered cases include unsupported instructions, invalid registers, undefined or duplicate labels, missing operands, malformed data lines, and truncated or malformed input files.

## Limitations

- Only the instructions, directives and registers listed above are supported.
- Escape sequences inside strings are not decoded; only `li reg, '\n'` is handled.
- The disassembler does not recover label names or comments. It generates labels such as `string_0` and `label_400010`.