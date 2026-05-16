`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 10:41:38 PM
// Design Name: 
// Module Name: lzc_8bit
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


module lzc_8bit(
    input wire [7:0] in,
    output reg [2:0] shift_amt
    );
    always @(*) begin
        if      (in[7]) shift_amt = 3'd0;
        else if (in[6]) shift_amt = 3'd1;
        else if (in[5]) shift_amt = 3'd2;
        else if (in[4]) shift_amt = 3'd3;
        else if (in[3]) shift_amt = 3'd4;
        else if (in[2]) shift_amt = 3'd5;
        else if (in[1]) shift_amt = 3'd6;
        else            shift_amt = 3'd7;
    end
endmodule
