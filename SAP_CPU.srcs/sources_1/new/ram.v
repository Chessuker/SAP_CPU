`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 03:19:18 PM
// Design Name: 
// Module Name: ram
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


module ram(
    input wire ce, //chip eanable
    input wire [3:0] addr,
    output reg [7:0] data_out
    );
    
    reg [7:0] memory [0:15];
    
    initial begin
        $readmemh("D:/OpalFolder/KMUTT/2-2/CPE223/SAP_CPU/SAP_CPU.srcs/sources_1/new/program.hex", memory);
    end
    
    always @(*) begin
        if (ce) begin
            data_out = memory[addr];
        end else begin
            data_out = 8'b0000_0000;
        end
    end
endmodule
