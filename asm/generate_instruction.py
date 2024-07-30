def read_file_lines(file_path):
    lines = []
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()  # 去除行末尾的换行符和空白字符
            lines.append(line)
    return lines

# 指定要读取的文件路径
file_path = 'mq.txt'

# 调用函数读取文件行
lines = read_file_lines(file_path)

with open('instructions.txt',"w") as file:
    for i,line in enumerate(lines):
        file.write(f"8'd{i}:   Instruction <= 32'h{line};\n")