`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: mar
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


module mar(
    input wire clk,
    input wire lm, // load mar
    input wire [3:0] bus_in,
    output reg [3:0] mar_out
    );
    
    always @(posedge clk) begin
        if (lm) begin
            mar_out <= bus_in;
        end
    end   
endmodule
