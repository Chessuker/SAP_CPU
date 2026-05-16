`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 10:36:09 PM
// Design Name: 
// Module Name: qds_logic
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


module qds_logic(
    input wire signed [4:0] pr_top,
    output reg [2:0] q_digit
    );
    
    always @(*) begin
        if      (pr_top >=  5'sd3) q_digit = 3'b010; // +2
        else if (pr_top >=  5'sd1) q_digit = 3'b001; // +1
        else if (pr_top <= -5'sd4) q_digit = 3'b110; // -2
        else if (pr_top <= -5'sd2) q_digit = 3'b101; // -1
        else                       q_digit = 3'b000; //  0
    end
endmodule