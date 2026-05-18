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

    wire [15:0] reciprocal_rom [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_rom
            if (i == 0 || i == 1) assign reciprocal_rom[i] = 16'd0; 
            else                  assign reciprocal_rom[i] = (17'd65536 + i - 1) / i;
        end
    endgenerate

    wire [15:0] c = reciprocal_rom[divisor];

    wire [15:0] p1_hi, p1_lo;
    
    dadda_8x8 mul_c_hi (.a(dividend), .b(c[15:8]), .product(p1_hi));
    dadda_8x8 mul_c_lo (.a(dividend), .b(c[7:0]),  .product(p1_lo));

    wire [23:0] mult1 = {p1_hi, 8'b0} + {8'b0, p1_lo};

    wire [7:0]  q_wire = mult1[23:16];
    wire [15:0] f_wire = mult1[15:0];

    reg [15:0] f_reg;
    reg [7:0]  div_reg;
    reg [7:0]  q_reg;
    reg [7:0]  dividend_reg; 

    always @(posedge clk) begin
        f_reg        <= f_wire; 
        div_reg      <= divisor; 
        q_reg        <= q_wire; 
        dividend_reg <= dividend;
    end

    wire [15:0] p2_hi, p2_lo;

    dadda_8x8 mul_f_hi (.a(f_reg[15:8]), .b(div_reg), .product(p2_hi));
    dadda_8x8 mul_f_lo (.a(f_reg[7:0]),  .b(div_reg), .product(p2_lo));

    wire [23:0] mult2 = {p2_hi, 8'b0} + {8'b0, p2_lo};

    assign quotient  = (div_reg == 0) ? 8'hFF :
                       (div_reg == 1) ? dividend_reg :
                       q_reg;

    assign remainder = (div_reg == 0) ? 8'h00 : 
                       (div_reg == 1) ? 8'h00 : 
                       mult2[23:16];

endmodule
