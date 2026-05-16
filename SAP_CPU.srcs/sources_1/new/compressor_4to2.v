`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 06:22:39 PM
// Design Name: 
// Module Name: compressor_4to2
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


module compressor_4to2(
    input wire x1,
    input wire x2,
    input wire x3,
    input wire x4,
    input wire cin,
    output wire cout,
    output wire carry,
    output wire sum
    );
    wire w;
    
    assign w   = x1 ^ x2 ^ x3;
    assign sum = w ^ x4 ^ cin;
    assign cout = (x1 & x2) | (x3 & (x1 ^ x2));
    assign carry = (x4 & cin) | ((x4 ^ cin) & w);
endmodule
