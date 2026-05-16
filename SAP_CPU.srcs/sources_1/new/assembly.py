# ==========================================
# SAP-1 Pipelined CPU - Custom Assembler
# ==========================================

# 1. กำหนดตาราง Opcode (Instruction Set Architecture)
OPCODES = {
    "LDA": 0x0,
    "ADD": 0x1,
    "SUB": 0x2,
    "MUL": 0x3,
    "DIV": 0x4,
    "AND": 0x5,
    "OR":  0x6,
    "XOR": 0x7,
    "OUT": 0xE,
    "HLT": 0xF
}

# 2. เขียนโปรแกรมของคุณตรงนี้! (Assembly Code)
source_code = [
    "LDA val1",    # โหลด 30 เข้า A
    "SUB val2",    # A = 30 - 20 = 10
    "MUL val3",    # A = 10 * 15
    "DIV val2",    # A = (10 * 15) / 20
    "MUL val4",    # A = (10 * 15) AND 255
    "OUT",         # ส่งออกหน้าจอ
    "HLT"          # หยุดทำงาน
]

# 3. กำหนดค่าข้อมูล (Data Variables)
variables = {
    "val4": 2,
    "val1": -10,
    "val2": 20,
    "val3": 15,
    "mask": 255    # ใช้ทำ Bitwise AND หรือใช้ทำ NOT (ด้วยการ XOR 255)
}

def assemble():
    ram = [0x00] * 16
    var_map = {}
    
    # วางตัวแปรไว้ท้าย RAM (เริ่มจากช่อง F ถอยหลังลงมา)
    data_addr = 15
    for var_name, val in variables.items():
        var_map[var_name] = data_addr
        ram[data_addr] = val & 0xFF # บังคับให้เป็น 8-bit
        data_addr -= 1

    # แปลงโค้ดเป็นภาษาเครื่อง (Machine Code)
    pc = 0
    for line in source_code:
        parts = line.strip().split()
        if not parts: continue
        
        op_str = parts[0].upper()
        if op_str not in OPCODES:
            print(f"Error: ไม่รู้จักคำสั่ง '{op_str}'")
            return
        
        opcode = OPCODES[op_str]
        operand = 0
        
        if len(parts) > 1: # ถ้ามีตัวแปรต่อท้าย (เช่น LDA val1)
            var_name = parts[1]
            if var_name in var_map:
                operand = var_map[var_name]
            else:
                print(f"Error: ไม่รู้จักตัวแปร '{var_name}'")
                return
                
        # นำ Opcode ไว้ 4 บิตบน และ Operand ไว้ 4 บิตล่าง
        ram[pc] = (opcode << 4) | (operand & 0x0F)
        pc += 1

    # สร้างไฟล์ program.hex
    with open("program.hex", "w") as f:
        for val in ram:
            f.write(f"{val:02X}\n")
            
    print("✅ Compile Success! สร้างไฟล์ 'program.hex' เรียบร้อยแล้ว")
    print("โครงสร้าง RAM (Instruction + Data):")
    for i, val in enumerate(ram):
        print(f"{val:02X}")

if __name__ == "__main__":
    assemble()