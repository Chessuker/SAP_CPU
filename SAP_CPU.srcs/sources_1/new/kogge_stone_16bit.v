`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 06:29:16 PM
// Design Name: 
// Module Name: kogge_stone_16bit
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


module kogge_stone_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        cin,   
    output wire [15:0] sum,
    output wire        cout
);

    wire [15:0] p0, g0;
    
    assign p0 = a ^ b;  
    assign g0 = a & b;  

    genvar i;

    wire [15:0] p1, g1;
    assign p1[0] = p0[0];
    assign g1[0] = g0[0];
    
    generate
        for (i = 1; i < 16; i = i + 1) begin : LEVEL_1
            assign p1[i] = p0[i] & p0[i-1];
            assign g1[i] = g0[i] | (p0[i] & g0[i-1]); 
        end
    endgenerate

    wire [15:0] p2, g2;
    assign p2[1:0] = p1[1:0];
    assign g2[1:0] = g1[1:0];
    
    generate
        for (i = 2; i < 16; i = i + 1) begin : LEVEL_2
            assign p2[i] = p1[i] & p1[i-2];
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
        end
    endgenerate

    wire [15:0] p3, g3;
    assign p3[3:0] = p2[3:0];
    assign g3[3:0] = g2[3:0];
    
    generate
        for (i = 4; i < 16; i = i + 1) begin : LEVEL_3
            assign p3[i] = p2[i] & p2[i-4];
            assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
        end
    endgenerate
    
    wire [15:0] p4, g4;
    assign p4[7:0] = p3[7:0];
    assign g4[7:0] = g3[7:0];
    
    generate
        for (i = 8; i < 16; i = i + 1) begin : LEVEL_4
            assign p4[i] = p3[i] & p3[i-8];
            assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
        end
    endgenerate
    
    wire [15:0] c;
    
    assign c[0] = cin;
    assign c[15:1] = g4[14:0] | (p4[14:0] & {15{cin}});
    assign sum  = p0 ^ c;
    assign cout = g4[15] | (p4[15] & cin);

endmodule