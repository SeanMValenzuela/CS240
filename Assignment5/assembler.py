with open('fizzbuzz.asm', 'r') as file:
    with open('fizzbuzz.mhc-ascii', 'w') as ascii_file, open ('fizzbuzz.mhc-bin', 'wb') as bin_file:
        for line in file:
            words = line.split()

            if not words:
                continue

            if words[0] == ".data":
                section = "data"
                continue

            if words[0] == ".text":
                section = "text"
                continue

            if words[0] == "fizz_word:" or words[0] == "buzz_word:" or words[0] == "fizzbuzz_word:":
                label = words[0].replace(":", "")
                string = words[2].strip('"')
                
                print("Label:", label)
                print("String:", string)

                for character in string:
                    ascii_file.write(format(ord(character), '08b'))
                    bin_file.write(bytes([ord(character)]))

                ascii_file.write('00000000')
                bin_file.write(b'\x00')

            if words[0] == "li" or words[0] == "la" or words[0] == "move" or words[0] == "rem":
                instruction = words[0]
                destreg = words[1].strip(',')
                if instruction == "li":
                    immvalue = words[2]
                elif instruction == "la":
                    label = words[2]
                elif instruction == "move":
                    soureg = words[2]
                elif instruction == "rem":
                    soureg = words[2].strip(',')
                    operand = words[3]

            if words[0] == "beq" or words[0] == "addi" or words[0] == "j" or words[0] == "syscall":
