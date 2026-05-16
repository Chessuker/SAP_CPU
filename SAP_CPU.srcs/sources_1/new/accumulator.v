`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: alu
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


module accumulator(
    input wire clk,
    input wire clr,
    input wire la, //load A
    input wire [7:0] bus_in,
    output reg [7:0] a_out
    );
    always @(posedge clk or posedge clr) begin
        if(clr) begin
            a_out <= 8'b0000_0000;
        end else if (la) begin
            a_out <= bus_in;
        end
    end
endmodule
