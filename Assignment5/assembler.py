section = "none"
symbol_table = {}
register_dictionary = {
"$zero": 0,
"$v0": 2,
"$a0": 4,
"$t0": 8,
"$t1": 9,
"$t2": 10,
"$t3": 11,
"$t4": 12,
"$t5": 13
}
opcode_dictionary = {
"beq": "000100",
"add" : "000000",   
"addi": "001000",
"j": "000010",
"syscall": "000000",
"lui" : "001111",
"ori" : "001101",
"div" : "000000",
"mfhi" : "000000"
}
def report_error(line_number, message):
    raise ValueError(f"Line {line_number}: {message}")


def get_register(register, line_number):
    if register not in register_dictionary:
        report_error(line_number, f"Invalid register '{register}'")
    return register_dictionary[register]


def get_label(label, line_number):
    if label not in symbol_table:
        report_error(line_number, f"Undefined label '{label}'")
    return symbol_table[label]


def check_operands(words, expected, line_number):
    if len(words) != expected:
        report_error(
            line_number,
            f"Instruction '{words[0]}' expects {expected - 1} operand(s)"
        )
instructions = ["li", "la", "move", "rem", "beq", "addi", "j", "syscall"]
data_address = 0x10010000
text_address = 0x00400000
with open('fizzbuzz.asm', 'r') as file:
    for line_number, line in enumerate(file, start=1):
        words = (line if section == "data" else line.split('#')[0]).split()
        
        if not words:
            continue

        if words[0] == ".data":
            section = "data"
            continue

        if words[0] == ".text":
            section = "text"
            continue
        
        if section == "data":
            if not words[0].endswith(":"):
                report_error(line_number, f"Unsupported data line '{words[0]}' (expected 'label: .asciiz \"text\"')")
            label = words[0].strip(":")
            if len(words) < 3 or words[1] != ".asciiz":
                report_error(line_number, f"Unsupported data directive for '{label}' (only .asciiz is supported: 'label: .asciiz \"text\"')")
            if len(words) != 3:
                report_error(line_number, f"String for '{label}' must be a single quoted word with no spaces")
            if len(words[2]) < 2 or not (words[2].startswith('"') and words[2].endswith('"')):
                report_error(line_number, f"String for '{label}' must be enclosed in double quotes")
            if label in symbol_table:
                report_error(line_number, f"Duplicate label '{label}'")
            actual_string = words[2].strip('"')
            symbol_table[label] = data_address
            data_address += len(actual_string) + 1
            continue

        if section == "text":
            if words[0].endswith(":"):
                label = words[0].strip(":")
                if label in symbol_table:
                    report_error(line_number, f"Duplicate label '{label}'")
                symbol_table[label] = text_address
                continue
            if words[0] not in instructions:
                report_error(line_number, f"Unsupported instruction '{words[0]}'")
            if words[0] == "la" or words[0] == "rem":
                    text_address +=8
            elif words[0] in instructions:
                    text_address += 4
section = "none"
text_address = 0x00400000   
with open('fizzbuzz.asm', 'r') as file:
    with open('fizzbuzz.mhc-ascii', 'w') as ascii_file, open ('fizzbuzz.mhc-bin', 'wb') as bin_file:
        for line_number, line in enumerate(file, start=1):
            words = (line if section == "data" else line.split('#')[0]).split()

            if not words:
                continue

            if words[0] == ".data":
                section = "data"
                continue

            if words[0] == ".text":
                section = "text"
                ascii_file.write("\n")
                continue

            if section == "data" and words[0].endswith(":"):
                label = words[0].replace(":", "")
                string = words[2].strip('"')
                
                print("Label:", label)
                print("String:", string)

                for character in string:
                    ascii_file.write(format(ord(character), '08b'))
                    bin_file.write(bytes([ord(character)]))

                ascii_file.write('00000000')
                bin_file.write(b'\x00')
            if section == "text":
                if words[0].endswith(":"):
                    label = words[0].strip(":")
                    if symbol_table[label] != text_address:
                        report_error(line_number, f"Address mismatch for label '{label}': first pass said {hex(symbol_table[label])}, second pass is at {hex(text_address)}")
                    continue
                if words[0] == "li" or words[0] == "la" or words[0] == "move" or words[0] == "rem":
                    instruction = words[0]
                    if instruction == "li":
                        check_operands(words, 3, line_number)
                        destreg = words[1].strip(',')
                        if words[2].isdigit():
                            immvalue = words[2]
                            ascii_file.write(opcode_dictionary["addi"])
                            ascii_file.write(format(register_dictionary["$zero"], "05b"))
                            ascii_file.write(format(get_register(destreg, line_number), "05b"))
                            ascii_file.write(format(int(immvalue) & 0xFFFF, "016b"))
                            ascii_file.write("\n")
                            whole_string = opcode_dictionary["addi"] + format(register_dictionary["$zero"], "05b") + format(get_register(destreg, line_number), "05b") + format(int(immvalue) & 0xFFFF, "016b")
                            byte1 = whole_string[0:8]
                            byte2 = whole_string[8:16]
                            byte3 = whole_string[16:24]
                            byte4 = whole_string[24:32]
                            byte1converted = int(byte1, 2)
                            byte2converted = int(byte2, 2)
                            byte3converted = int(byte3, 2)
                            byte4converted = int(byte4, 2)
                            bin_file.write(bytes([byte1converted]))
                            bin_file.write(bytes([byte2converted]))
                            bin_file.write(bytes([byte3converted]))
                            bin_file.write(bytes([byte4converted]))
                        else:
                            charvalue = words[2].strip("'")
                            if charvalue == "\\n":
                                charvalue = "\n"
                            ascii_file.write(opcode_dictionary["addi"])
                            ascii_file.write(format(register_dictionary["$zero"], "05b"))
                            ascii_file.write(format(get_register(destreg, line_number), "05b"))
                            ascii_file.write(format(ord(charvalue), "016b"))
                            ascii_file.write("\n")
                            whole_string = opcode_dictionary["addi"] + format(register_dictionary["$zero"], "05b") + format(get_register(destreg, line_number), "05b") + format(ord(charvalue), "016b")
                            byte1 = whole_string[0:8]
                            byte2 = whole_string[8:16]
                            byte3 = whole_string[16:24]
                            byte4 = whole_string[24:32]
                            byte1converted = int(byte1, 2)
                            byte2converted = int(byte2, 2)
                            byte3converted = int(byte3, 2)
                            byte4converted = int(byte4, 2)
                            bin_file.write(bytes([byte1converted]))
                            bin_file.write(bytes([byte2converted]))
                            bin_file.write(bytes([byte3converted]))
                            bin_file.write(bytes([byte4converted]))
                    elif instruction == "la":
                        check_operands(words, 3, line_number)
                        destreg = words[1].strip(",")
                        label = words[2]
                        address = get_label(label, line_number)
                        upper = (address >> 16) & 0xFFFF
                        lower = address & 0xFFFF
                        ascii_file.write(opcode_dictionary["lui"])
                        ascii_file.write(format(register_dictionary["$zero"], "05b"))
                        ascii_file.write(format(get_register(destreg, line_number), "05b"))
                        ascii_file.write(format(upper, "016b"))
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary["lui"] + format(0, "05b") + format(get_register(destreg, line_number), "05b") + format(upper, "016b")
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                        ascii_file.write(opcode_dictionary["ori"])
                        ascii_file.write(format(get_register(destreg, line_number), "05b"))
                        ascii_file.write(format(get_register(destreg, line_number), "05b"))
                        ascii_file.write(format(lower, "016b"))
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary["ori"] + format(get_register(destreg, line_number), "05b") + format(get_register(destreg, line_number), "05b") + format(lower, "016b")                     
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                    elif instruction == "move":
                        check_operands(words, 3, line_number)
                        destreg = words[1].strip(",")
                        soureg = words[2]
                        ascii_file.write(opcode_dictionary["add"])
                        ascii_file.write(format(get_register(soureg, line_number), "05b"))
                        ascii_file.write(format(register_dictionary["$zero"], "05b"))
                        ascii_file.write(format(get_register(destreg, line_number), "05b"))
                        ascii_file.write("00000")
                        ascii_file.write("100000")
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary["add"] + format(get_register(soureg, line_number), "05b") + format(register_dictionary["$zero"], "05b") + format(get_register(destreg, line_number), "05b") + "00000" + "100000"
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))                
                    elif instruction == "rem":
                        check_operands(words, 4, line_number)
                        destreg = words[1].strip(',')
                        soureg = words[2].strip(',')
                        operand = words[3].strip(',')
                        if operand.isdigit():
                            raise ValueError("Error: rem requires a register for its third operand.")
                        ascii_file.write(opcode_dictionary["div"])
                        ascii_file.write(format(get_register(soureg, line_number), "05b"))
                        ascii_file.write(format(get_register(operand, line_number), "05b"))
                        ascii_file.write("00000")
                        ascii_file.write("00000")
                        ascii_file.write("011010")
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary["div"] + format(get_register(soureg, line_number), "05b") + format(get_register(operand, line_number), "05b") + "00000" + "00000" + "011010"
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                        ascii_file.write(opcode_dictionary["mfhi"])
                        ascii_file.write("00000")
                        ascii_file.write("00000")
                        ascii_file.write(format(get_register(destreg, line_number), "05b"))
                        ascii_file.write("00000")
                        ascii_file.write("010000")
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary["mfhi"] + "00000" + "00000" + format(get_register(destreg, line_number), "05b") + "00000" + "010000"
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                if words[0] == "beq" or words[0] == "addi" or words[0] == "j" or words[0] == "syscall":
                    instruction = words[0]
                    if instruction == "beq":
                        check_operands(words, 4, line_number)
                        soureg = words[1].strip(',')
                        secsoureg = words[2].strip(',')
                        label = words[3]
                        ascii_file.write(opcode_dictionary[instruction])
                        ascii_file.write(format(get_register(soureg, line_number), "05b"))
                        ascii_file.write(format(get_register(secsoureg, line_number), "05b"))
                        offset = (get_label(label, line_number) - (text_address + 4)) // 4
                        ascii_file.write(format(offset & 0xFFFF, "016b"))
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary[instruction] + format(get_register(soureg, line_number), "05b") + format(get_register(secsoureg, line_number), "05b") + format(offset & 0xFFFF, "016b")
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                    elif instruction == "addi":
                        check_operands(words, 4, line_number)
                        destreg = words[1].strip(',')
                        soureg = words[2].strip(',')
                        immvalue = words[3]
                        ascii_file.write(opcode_dictionary[instruction])
                        ascii_file.write(format(get_register(soureg, line_number), "05b"))
                        ascii_file.write(format(get_register(destreg, line_number), "05b"))
                        ascii_file.write(format(int(immvalue) & 0xFFFF, "016b"))
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary[instruction] + format(get_register(soureg, line_number), "05b") + format(get_register(destreg, line_number), "05b") + format(int(immvalue) & 0xFFFF, "016b")
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                    elif instruction == "j":
                        check_operands(words, 2, line_number)
                        label = words[1]
                        ascii_file.write(opcode_dictionary[instruction])
                        target_field = get_label(label, line_number) // 4
                        ascii_file.write(format(target_field, "026b"))
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary[instruction] + format(target_field, "026b")
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                    elif instruction == "syscall":
                        check_operands(words, 1, line_number)
                        ascii_file.write(opcode_dictionary[instruction])
                        ascii_file.write("00000000000000000000")
                        ascii_file.write("001100")
                        ascii_file.write("\n")
                        whole_string = opcode_dictionary[instruction] + "00000000000000000000" + "001100"
                        byte1 = whole_string[0:8]
                        byte2 = whole_string[8:16]
                        byte3 = whole_string[16:24]
                        byte4 = whole_string[24:32]
                        byte1converted = int(byte1, 2)
                        byte2converted = int(byte2, 2)
                        byte3converted = int(byte3, 2)
                        byte4converted = int(byte4, 2)
                        bin_file.write(bytes([byte1converted]))
                        bin_file.write(bytes([byte2converted]))
                        bin_file.write(bytes([byte3converted]))
                        bin_file.write(bytes([byte4converted]))
                
                print(words[0], bin_file.tell())

                if words[0] == "la" or words[0] == "rem":
                    text_address +=8
                elif words[0] in instructions:
                    text_address += 4
        print(symbol_table)