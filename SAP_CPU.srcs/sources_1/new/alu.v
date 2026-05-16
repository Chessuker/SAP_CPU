`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input wire        clk,
    input wire [7:0]  a,
    input wire [7:0]  b,
    input wire [2:0]  alu_op,    
    output reg [15:0] result,    
    output reg [7:0]  remainder, 
    output wire       zero,
    output wire       div_zero      
);
    
    wire [7:0]  w_add_sub_res;
    wire        w_add_sub_cout;
    wire [15:0] w_mul_res;
    wire [7:0]  w_div_q;
    wire [7:0]  w_div_r;

    // ADD/SUB
    add_sub_8bit_csla u_add_sub (
        .a(a), .b(b),
        .sub(alu_op == 3'b001), 
        .result(w_add_sub_res), .cout(w_add_sub_cout)
    );

    // MUL
    dadda_8x8 u_mul (
        .a(a), .b(b), .product(w_mul_res)
    );

    // DIV (Pipelined +1 Clock Cycle)
    divider_8bit u_div (
        .clk(clk),              
        .dividend(a),
        .divisor(b),
        .quotient(w_div_q),
        .remainder(w_div_r)
    );

    always @(*) begin
        result    = 16'd0;
        remainder = 8'd0;

        case (alu_op)
            3'b000: result = {8'd0, w_add_sub_res}; // ADD
            3'b001: result = {8'd0, w_add_sub_res}; // SUB
            3'b010: result = w_mul_res;             // MUL
            3'b011: begin                           // DIV
                        result    = {8'd0, w_div_q};
                        remainder = w_div_r;        
                    end
            3'b100: result = {8'd0, (a & b)};       // AND
            3'b101: result = {8'd0, (a | b)};       // OR
            3'b110: result = {8'd0, (a ^ b)};       // XOR
            default: result = 16'd0;
        endcase
    end

    assign zero = (result == 16'd0);
    assign div_zero = (alu_op == 3'b011) && (b == 8'd0);

endmodule
