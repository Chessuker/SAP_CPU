`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 10:59:39 PM
// Design Name: 
// Module Name: divider_8bit
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


module divider_8bit (
    input  wire        clk,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    output wire [7:0]  quotient,
    output wire [7:0]  remainder
);

    wire [16:0] reciprocal_rom [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_rom
            if (i == 0) assign reciprocal_rom[i] = 17'd0;
            else        assign reciprocal_rom[i] = (17'd65536 + i - 1) / i;
        end
    endgenerate

    wire [16:0] c = reciprocal_rom[divisor];

    (* use_dsp = "yes" *)
    wire [24:0] mult1 = dividend * c;
    
    wire [7:0]  q_wire = mult1[23:16];
    wire [15:0] f_wire = mult1[15:0];

    reg [15:0] f_reg;
    reg [7:0]  div_reg;
    reg [7:0]  q_reg;

    always @(posedge clk) begin
        f_reg   <= f_wire; 
        div_reg <= divisor; 
        q_reg   <= q_wire; 
    end

    (* use_dsp = "yes" *)
    wire [23:0] mult2 = f_reg * div_reg;

    assign quotient  = q_reg;
    assign remainder = mult2[23:16];

endmodule
