`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 11:56:16 PM
// Design Name: 
// Module Name: radix4_direct_stage
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


module radix4_direct_stage #(parameter W = 10) (
    input  wire [W-1:0] pr_in,      
    input  wire [1:0]   div_bits,   
    input  wire [W-1:0] d1,         
    input  wire [W-1:0] d2,         
    input  wire [W-1:0] d3,         
    output wire [W-1:0] pr_out,     
    output wire [1:0]   q_digit     
);
 
    wire [W-1:0] pr_curr = {pr_in[W-3:0], div_bits};
 
    wire [W:0] r1 = {1'b0, pr_curr} - {1'b0, d1};   // pr - 1D
    wire [W:0] r2 = {1'b0, pr_curr} - {1'b0, d2};   // pr - 2D
    wire [W:0] r3 = {1'b0, pr_curr} - {1'b0, d3};   // pr - 3D
 
    wire cmp1 = ~r1[W];   // pr_curr >= d1
    wire cmp2 = ~r2[W];   // pr_curr >= d2
    wire cmp3 = ~r3[W];   // pr_curr >= d3
 
    assign q_digit = cmp3 ? 2'b11 :
                     cmp2 ? 2'b10 :
                     cmp1 ? 2'b01 : 2'b00;
 
    assign pr_out  = cmp3 ? r3[W-1:0] :
                     cmp2 ? r2[W-1:0] :
                     cmp1 ? r1[W-1:0] : pr_curr;
 
endmodule