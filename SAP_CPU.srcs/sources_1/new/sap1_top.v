`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 12:04:07 PM
// Design Name: 
// Module Name: sap1_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sap1_top(
    input  wire clk,
    input  wire clr,
    output wire [7:0] out_port
);

    wire [7:0] main_bus;

    wire ep, lm, ce, li, ei, la, ea, eu, lb, lo, cp;
    wire [2:0] alu_op; // รหัสคำสั่งที่จะส่งให้ ALU

    wire [3:0]  pc_out;
    wire [3:0]  mar_out;
    wire [7:0]  ram_out;
    wire [7:0]  ir_out;
    wire [7:0]  a_out;
    wire [7:0]  b_out;
    wire [15:0] alu_result;
    wire [7:0]  alu_remainder;
    wire        alu_zero;
    wire        alu_div_zero;

    program_counter u_pc (
        .clk(clk), .clr(clr), .cp(cp), .pc_out(pc_out)
    );

    mar u_mar (
        .clk(clk), .lm(lm), .bus_in(main_bus[3:0]), .mar_out(mar_out)
    );

    ram u_ram (
        .ce(ce), .addr(mar_out), .data_out(ram_out)
    );

    instruction_register u_ir (
        .clk(clk), .clr(clr), .li(li), .bus_in(main_bus), .ir_out(ir_out)
    );

    accumulator u_a (
        .clk(clk), .clr(clr), .la(la), .bus_in(main_bus), .a_out(a_out)
    );

    b_register u_b (
        .clk(clk), .clr(clr), .lb(lb), .bus_in(main_bus), .b_out(b_out)
    );

    alu u_alu (
        .clk(clk),
        .a(a_out), 
        .b(b_out), 
        .alu_op(alu_op),
        .result(alu_result), 
        .remainder(alu_remainder),
        .zero(alu_zero), 
        .div_zero(alu_div_zero)
    );

    output_register u_out (
        .clk(clk), .clr(clr), .lo(lo), .bus_in(main_bus), .out_out(out_port)
    );

    bus_mux u_bus (
        .ep(ep), .pc_in(pc_out),
        .ce(ce), .ram_in(ram_out),
        .ei(ei), .ir_in(ir_out),
        .ea(ea), .a_in(a_out),
        .eu(eu), .alu_in(alu_result[7:0]), // ดึงแค่ 8 บิตล่างของผลลัพธ์ลง Bus
        .bus_out(main_bus)
    );

    latchcontrol_unit u_cu (
        .clk(clk),
        .clr(clr),
        .ir_opcode(ir_out[7:4]), // สมมติว่า 4 บิตบนของ IR คือ Opcode
        // Output Control Signals
        .ep(ep), .lm(lm), .ce(ce), .li(li), .ei(ei), 
        .la(la), .ea(ea), .eu(eu), .lb(lb), .lo(lo), .cp(cp),
        .alu_op(alu_op) 
    );

endmodule
