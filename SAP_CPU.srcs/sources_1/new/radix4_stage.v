`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 10:38:13 PM
// Design Name: 
// Module Name: radix4_stage
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


module radix4_stage #(parameter W = 10) (
    input  wire signed [W-1:0] pr_in,       // เศษจากด่านที่แล้ว (Partial Remainder)
    input  wire        [1:0]   div_bits,    // บิตตัวตั้ง 2 บิตที่จะดึงลงมาผสม
    input  wire        [7:0]   d_norm,      // ตัวหารที่จัดรูปแล้ว (Normalized Divisor)
    output wire signed [W-1:0] pr_out,      // เศษส่งให้ด่านต่อไป
    output wire        [2:0]   q_digit      // ผลหารรอบนี้ที่เดาได้
);

    // 1. หัวใจสำคัญที่แก้บั๊ก Overflow: 
    // ดันเศษเดิมไปทางซ้าย 2 ตำแหน่ง แล้วเอาบิตตัวตั้ง 2 บิตมาเสียบแทนที่รูโบ๋
    wire signed [W-1:0] pr_shifted;
    assign pr_shifted = {pr_in[W-3:0], div_bits}; 

    // 2. ป้อน 5 บิตบนเข้าสมองกล QDS (สมองกลนี้ทำงานเสถียรแล้ว เพราะค่าไม่ล้น)
    qds_logic brain (
        .pr_top(pr_shifted[W-1 : W-5]),
        .q_digit(q_digit)
    );

    // 3. MUX: เลือก D หรือ 2D
    wire [W-1:0] d_ext = {2'b00, d_norm}; 
    reg  [W-1:0] mux_out;
    
    always @(*) begin
        case(q_digit[1:0]) // ดูแค่ Magnitude
            2'b00: mux_out = {W{1'b0}};      
            2'b01: mux_out = d_ext;          
            2'b10: mux_out = d_ext << 1;     
            default: mux_out = {W{1'b0}};
        endcase
    end

    // 4. วงจรบวกลบ
    wire q_sign = q_digit[2];
    assign pr_out = (q_sign) ? (pr_shifted + mux_out) : (pr_shifted - mux_out);

endmodule