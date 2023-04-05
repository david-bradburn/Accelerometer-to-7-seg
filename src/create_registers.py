
with open("./src/instruction_set.txt") as fd:
    raw_input = fd.readlines()

input_no_header = raw_input[1:]
clean_split_input = [i.strip("\n").split(" ") for i in input_no_header]

instr_dict = {"N": 0, "R": 1, "W": 2}

print(input_no_header)
print(clean_split_input)

pc = 3
for data in clean_split_input:
    instr = instr_dict[data[0]]
    # print(data[])
    instr_hex = f"{instr:#0{4}x}"[2:]
    dev_add = f"{int(data[1], 16):#0{4}x}"[2:]
    reg_add = f"{int(data[2], 16):#0{4}x}"[2:]
    # print(dev_add)
    # print(reg_add)
    pc_hex_str = f"{pc:#0x}"[2:]

    match instr:
        case 1:
            print(f"8'h{pc_hex_str}: read_data <= 32'h{instr_hex}{dev_add}{reg_add}00")
        case 2:
            write_data = f"{int(data[3], 16):#0{4}x}"[2:]
            print(f"8'h{pc_hex_str}: read_data <= 32'h{instr_hex}{dev_add}{reg_add}{write_data}")

    pc += 1
# def write_instructions():
#     print("") 