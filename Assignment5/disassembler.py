import sys

symbol_table = {}
data_symbol_table = {}
register_dictionary = {
0: "$zero",
2: "$v0",
4: "$a0",
8: "$t0",
9: "$t1",
10: "$t2",
11: "$t3",
12: "$t4",
13: "$t5"
}
def report_error(location, message):
    raise ValueError(f"{location}: {message}")


def get_register(register, location):
    register_number = int(register, 2)
    if register_number not in register_dictionary:
        report_error(location, f"Unsupported register number {register_number}")
    return register_dictionary[register_number]


data_address = 0x10010000
text_address = 0x00400000
input_file = 'fizzbuzz.mhc-ascii'
output_file = 'fizzbuzz_reconstructed.asm'
if len(sys.argv) > 1:
    input_file = sys.argv[1]
if len(sys.argv) > 2:
    output_file = sys.argv[2]

with open(input_file, 'rb') as file:
    file_bytes = file.read()

if len(file_bytes) == 0:
    report_error(input_file, "File is empty")

data_bytes = []
instruction_list = []

ascii_format = True
for byte in file_bytes:
    if byte != 48 and byte != 49 and byte != 10 and byte != 13:
        ascii_format = False

if ascii_format:
    print("Format: mhc-ascii")
    lines = file_bytes.decode().split("\n")
    data_line = lines[0].strip()
    if len(data_line) % 8 != 0:
        report_error("Line 1", "Data line length is not a multiple of 8 bits")
    for position in range(0, len(data_line), 8):
        data_bytes.append(int(data_line[position:position + 8], 2))
    for line_number, line in enumerate(lines[1:], start=2):
        whole_string = line.strip()
        if not whole_string:
            continue
        if len(whole_string) != 32:
            report_error(f"Line {line_number}", f"Instruction must be 32 bits, found {len(whole_string)}")
        instruction_list.append(whole_string)
else:
    print("Format: mhc-bin")
    data_length = 0
    position = 0
    while position < len(file_bytes):
        end = position
        while end < len(file_bytes) and file_bytes[end] != 0:
            end += 1
        if end >= len(file_bytes) or end == position:
            break
        valid_string = True
        for byte in file_bytes[position:end]:
            if byte < 33 or byte > 126:
                valid_string = False
        if not valid_string:
            break
        data_length = end + 1
        position = end + 1
    if (len(file_bytes) - data_length) % 4 != 0:
        report_error(input_file, "Could not find where the data section ends (instruction bytes are not a multiple of 4)")
    data_bytes = list(file_bytes[:data_length])
    for position in range(data_length, len(file_bytes), 4):
        byte1 = format(file_bytes[position], "08b")
        byte2 = format(file_bytes[position + 1], "08b")
        byte3 = format(file_bytes[position + 2], "08b")
        byte4 = format(file_bytes[position + 3], "08b")
        whole_string = byte1 + byte2 + byte3 + byte4
        instruction_list.append(whole_string)

# Split the data bytes into null terminated strings and give each one a label
data_strings = []
string_count = 0
string_start = data_address
current_string = ""
for byte in data_bytes:
    if byte == 0:
        label = "string_" + str(string_count)
        data_symbol_table[string_start] = label
        data_strings.append((label, current_string))
        string_count += 1
        data_address += len(current_string) + 1
        string_start = data_address
        current_string = ""
    else:
        if byte < 33 or byte > 126 or byte == 34:
            report_error(f"Data address {hex(data_address + len(current_string))}", f"Byte {byte} cannot be written inside a .asciiz string")
        current_string += chr(byte)
if current_string != "":
    report_error("Data section", "Last string is missing its null terminator")

# First pass: find every branch and jump target so it can get a label
instruction_addresses = []
target_list = []
skip = False
for instruction_number, whole_string in enumerate(instruction_list, start=1):
    if skip:
        skip = False
        continue
    opcode = whole_string[0:6]
    funct = whole_string[26:32]
    instruction_addresses.append(text_address)
    if opcode == "000100":
        offset = int(whole_string[16:32], 2)
        if offset >= 32768:
            offset -= 65536
        target = text_address + 4 + offset * 4
        target_list.append((target, text_address))
    elif opcode == "000010":
        target = int(whole_string[6:32], 2) * 4
        target_list.append((target, text_address))
    if opcode == "001111" or (opcode == "000000" and funct == "011010"):
        if instruction_number == len(instruction_list):
            report_error(f"Address {hex(text_address)}", "lui must be followed by ori, and div must be followed by mfhi")
        text_address += 8
        skip = True
    else:
        text_address += 4
instruction_addresses.append(text_address)

for target, branch_address in target_list:
    if target not in instruction_addresses:
        report_error(f"Address {hex(branch_address)}", f"Branch or jump target {hex(target)} is not the start of an instruction")
    symbol_table[target] = "label_" + format(target, "x")

# Second pass: write the assembly file
text_address = 0x00400000
skip = False
with open(output_file, 'w') as asm_file:
    if len(data_strings) > 0:
        asm_file.write(".data\n")
        for label, string in data_strings:
            asm_file.write(label + ': .asciiz "' + string + '"\n')
        asm_file.write("\n")
    asm_file.write(".text\n")
    for instruction_number, whole_string in enumerate(instruction_list, start=1):
        if skip:
            skip = False
            continue
        location = f"Address {hex(text_address)}"
        if text_address in symbol_table:
            asm_file.write(symbol_table[text_address] + ":\n")
        opcode = whole_string[0:6]
        if opcode == "000000":
            soureg = whole_string[6:11]
            secsoureg = whole_string[11:16]
            destreg = whole_string[16:21]
            shamt = whole_string[21:26]
            funct = whole_string[26:32]
            if funct == "001100":
                if whole_string != "00000000000000000000000000001100":
                    report_error(location, "Unsupported syscall encoding")
                asm_file.write("\tsyscall\n")
            elif funct == "100000":
                if shamt != "00000" or secsoureg != "00000":
                    report_error(location, "Unsupported add (only move, which adds $zero, is supported)")
                asm_file.write("\tmove " + get_register(destreg, location) + ", " + get_register(soureg, location) + "\n")
            elif funct == "011010":
                next_string = instruction_list[instruction_number]
                if destreg != "00000" or shamt != "00000":
                    report_error(location, "Unsupported div encoding")
                if next_string[0:6] != "000000" or next_string[26:32] != "010000" or next_string[6:16] != "0000000000" or next_string[21:26] != "00000":
                    report_error(location, "div must be followed by mfhi")
                remreg = next_string[16:21]
                asm_file.write("\trem " + get_register(remreg, location) + ", " + get_register(soureg, location) + ", " + get_register(secsoureg, location) + "\n")
                text_address += 4
                skip = True
            elif funct == "010000":
                report_error(location, "mfhi without a div before it is not supported")
            else:
                report_error(location, f"Unsupported instruction (funct {funct})")
        elif opcode == "001000":
            soureg = whole_string[6:11]
            destreg = whole_string[11:16]
            immvalue = int(whole_string[16:32], 2)
            if immvalue >= 32768:
                immvalue -= 65536
            if soureg == "00000" and immvalue >= 0:
                asm_file.write("\tli " + get_register(destreg, location) + ", " + str(immvalue) + "\n")
            else:
                asm_file.write("\taddi " + get_register(destreg, location) + ", " + get_register(soureg, location) + ", " + str(immvalue) + "\n")
        elif opcode == "001111":
            soureg = whole_string[6:11]
            destreg = whole_string[11:16]
            upper = int(whole_string[16:32], 2)
            next_string = instruction_list[instruction_number]
            if soureg != "00000":
                report_error(location, "Unsupported lui encoding")
            if next_string[0:6] != "001101" or next_string[6:11] != destreg or next_string[11:16] != destreg:
                report_error(location, "lui must be followed by ori on the same register")
            lower = int(next_string[16:32], 2)
            address = (upper << 16) | lower
            if address not in data_symbol_table:
                report_error(location, f"Address {hex(address)} is not the start of a data string")
            asm_file.write("\tla " + get_register(destreg, location) + ", " + data_symbol_table[address] + "\n")
            text_address += 4
            skip = True
        elif opcode == "001101":
            report_error(location, "ori without a lui before it is not supported")
        elif opcode == "000100":
            soureg = whole_string[6:11]
            secsoureg = whole_string[11:16]
            offset = int(whole_string[16:32], 2)
            if offset >= 32768:
                offset -= 65536
            target = text_address + 4 + offset * 4
            asm_file.write("\tbeq " + get_register(soureg, location) + ", " + get_register(secsoureg, location) + ", " + symbol_table[target] + "\n")
        elif opcode == "000010":
            target = int(whole_string[6:32], 2) * 4
            asm_file.write("\tj " + symbol_table[target] + "\n")
        else:
            report_error(location, f"Unsupported instruction (opcode {opcode})")
        text_address += 4
    if text_address in symbol_table:
        asm_file.write(symbol_table[text_address] + ":\n")

print("Wrote", output_file)