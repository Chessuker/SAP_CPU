`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: latchcontrol_unit
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


module latchcontrol_unit(
    input  wire clk,
    input  wire clr,
    input  wire [3:0] ir_opcode,
    
    output reg ep, lm, ce, li, ei, la, ea, eu, lb, lo, cp,
    output reg [2:0] alu_op
);

    localparam S0_FETCH      = 3'd0;
    localparam S1_DECODE     = 3'd1;
    localparam S2_OP_ADDR    = 3'd2;
    localparam S3_OP_FETCH   = 3'd3;
    localparam S4_EXEC       = 3'd4;
    localparam S5_DIV_WAIT   = 3'd5;
    localparam S6_HALT       = 3'd6;

    localparam OP_LDA = 4'b0000;
    localparam OP_ADD = 4'b0001;
    localparam OP_SUB = 4'b0010;
    localparam OP_MUL = 4'b0011;
    localparam OP_DIV = 4'b0100;
    localparam OP_OUT = 4'b1110;
    localparam OP_HLT = 4'b1111;
    localparam OP_AND = 4'b0101;
    localparam OP_OR  = 4'b0110;
    localparam OP_XOR = 4'b0111;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge clr) begin
        if (clr) state <= S0_FETCH;
        else     state <= next_state;
    end

    always @(*) begin
        case (state)
            S0_FETCH: next_state = S1_DECODE;
            
            S1_DECODE: next_state = S2_OP_ADDR;
            
            S2_OP_ADDR: begin
                if (ir_opcode == OP_HLT)      next_state = S6_HALT; 
                else if (ir_opcode == OP_OUT) next_state = S4_EXEC;
                else                          next_state = S3_OP_FETCH;
            end
            
            S3_OP_FETCH: begin
                if (ir_opcode == OP_LDA) next_state = S0_FETCH; 
                else                     next_state = S4_EXEC;  
            end
            
            S4_EXEC: begin
                if (ir_opcode == OP_DIV) next_state = S5_DIV_WAIT; 
                else                     next_state = S0_FETCH;
            end

            S5_DIV_WAIT: next_state = S0_FETCH;

            S6_HALT: next_state = S6_HALT; 

            default: next_state = S0_FETCH;
        endcase
    end

    always @(*) begin
        ep = 0; lm = 0; ce = 0; li = 0; ei = 0; la = 0; 
        ea = 0; eu = 0; lb = 0; lo = 0; cp = 0;
        alu_op = 3'b000; 

        case (state)
            S0_FETCH: begin
                ep = 1; lm = 1; // MAR <- PC
            end
            
            S1_DECODE: begin
                ce = 1; li = 1; // IR <- RAM
                cp = 1;
            end

            S2_OP_ADDR: begin
                ei = 1; lm = 1; // MAR <- IR[3:0]
            end

            S3_OP_FETCH: begin
                if (ir_opcode == OP_LDA) begin
                    ce = 1; la = 1; // A <- RAM
                end else begin
                    ce = 1; lb = 1; // B <- RAM
                end
            end

            S4_EXEC: begin
                if (ir_opcode == OP_OUT) begin
                    ea = 1; lo = 1; // OUT <- A
                end else if (ir_opcode == OP_ADD) begin
                    eu = 1; la = 1; alu_op = 3'b000;
                end else if (ir_opcode == OP_SUB) begin
                    eu = 1; la = 1; alu_op = 3'b001;
                end else if (ir_opcode == OP_MUL) begin
                    eu = 1; la = 1; alu_op = 3'b010;
                end else if (ir_opcode == OP_DIV) begin
                    alu_op = 3'b011; // DIV Pipelined
                end else if (ir_opcode == OP_AND) begin
                    eu = 1; la = 1; alu_op = 3'b100;
                end else if (ir_opcode == OP_OR) begin
                    eu = 1; la = 1; alu_op = 3'b101;
                end else if (ir_opcode == OP_XOR) begin
                    eu = 1; la = 1; alu_op = 3'b110;
                end
            end

            S5_DIV_WAIT: begin
                if (ir_opcode == OP_DIV) begin
                    eu = 1; la = 1; alu_op = 3'b011;
                end
            end
            
            S6_HALT: begin
            end
        endcase
    end
endmodule
