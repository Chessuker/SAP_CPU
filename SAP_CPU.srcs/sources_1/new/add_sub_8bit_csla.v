`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 09:13:23 PM
// Design Name: 
// Module Name: add_sub_8bit_csla
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


module add_sub_8bit_csla(
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sub,
    output wire [7:0] result,
    output wire       cout    
    );
    
    wire [7:0] b_eff;
    assign b_eff = b ^ {8{sub}};

    wire cout_lower;
    
    cla_4bit cla_lower (
        .a(a[3:0]), 
        .b(b_eff[3:0]), 
        .cin(sub),
        .sum(result[3:0]), 
        .cout(cout_lower)
    );

    wire [3:0] sum_upper_0, sum_upper_1;
    wire       cout_upper_0, cout_upper_1;

    cla_4bit cla_upper_0 (
        .a(a[7:4]), 
        .b(b_eff[7:4]), 
        .cin(1'b0),
        .sum(sum_upper_0), 
        .cout(cout_upper_0)
    );

    cla_4bit cla_upper_1 (
        .a(a[7:4]), 
        .b(b_eff[7:4]), 
        .cin(1'b1),
        .sum(sum_upper_1), 
        .cout(cout_upper_1)
    );

    assign result[7:4] = (cout_lower == 1'b1) ? sum_upper_1  : sum_upper_0;
    assign cout        = (cout_lower == 1'b1) ? cout_upper_1 : cout_upper_0;
endmodule
