`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input wire clk,
    input wire clr, //asynchronous reset
    input wire cp, //count
    output reg [3:0] pc_out
    );
    
    always @(posedge clk or posedge clr) begin
        if(clr) begin
            pc_out <= 4'b0000;
        end else if(cp) begin
            pc_out <= pc_out + 1;
        end
    end
endmodule
