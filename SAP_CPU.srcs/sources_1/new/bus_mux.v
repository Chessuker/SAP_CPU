`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: bus_mux
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


module bus_mux(
    input wire ep, // enable PC
    input wire [3:0] pc_in,
    input wire ce, // enable RAM (Chip Enable)
    input wire [7:0] ram_in,
    input wire ei, //enable IR
    input wire [7:0] ir_in,
    input wire ea, //enable Accumulator
    input wire [7:0] a_in,
    input wire eu, //enable alu
    input wire [7:0] alu_in,
    output reg [7:0] bus_out
    );
    
    always @(*) begin
        if (ep) begin
            bus_out = {4'b0000, pc_in};
        end else if (ce) begin
            bus_out = ram_in;
        end else if (ei) begin
            bus_out = ir_in;
        end else if (ea) begin
            bus_out = a_in;
        end else if (eu) begin
            bus_out = alu_in;
        end else begin
            bus_out = 8'b0000_0000;
        end
    end
endmodule
