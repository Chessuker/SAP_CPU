`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 06:33:44 PM
// Design Name: 
// Module Name: dadda_8x8
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


module dadda_8x8 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [15:0] product
);

    wire [7:0] pp [7:0];
    genvar i, j;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                assign pp[i][j] = a[i] & b[j];
            end
        end
    endgenerate

    // Stage 1
    wire s1_l1_cout [14:4];
    wire s1_l2_cout [14:6];
    wire s1_c4 [3:0], s1_c5 [3:0], s1_c6 [3:0], s1_c7 [3:0], s1_c8 [3:0];
    wire s1_c9 [3:0], s1_c10 [3:0], s1_c11 [3:0], s1_c12 [3:0], s1_c13 [2:0], s1_c14 [1:0];

    compressor_4to2 c4_l1 (
        .x1(pp[0][4]), .x2(pp[1][3]), .x3(pp[2][2]), .x4(pp[3][1]), .cin(1'b0),
        .sum(s1_c4[0]), .carry(s1_c5[3]), .cout(s1_l1_cout[4])
    );
    assign s1_c4[1] = pp[4][0];
    
    assign s1_c4[2] = 1'b0;
    assign s1_c4[3] = 1'b0;
    assign s1_c6[2] = 1'b0;
    assign s1_c12[3] = 1'b0;

    compressor_4to2 c5_l1 (
        .x1(pp[0][5]), .x2(pp[1][4]), .x3(pp[2][3]), .x4(pp[3][2]), .cin(s1_l1_cout[4]),
        .sum(s1_c5[0]), .carry(s1_c6[3]), .cout(s1_l1_cout[5])
    );
    assign s1_c5[1] = pp[4][1];
    assign s1_c5[2] = pp[5][0];

    compressor_4to2 c6_l1 (
        .x1(pp[0][6]), .x2(pp[1][5]), .x3(pp[2][4]), .x4(pp[3][3]), .cin(s1_l1_cout[5]),
        .sum(s1_c6[0]), .carry(s1_c7[2]), .cout(s1_l1_cout[6])
    );
    
    compressor_4to2 c6_l2 (
        .x1(pp[4][2]), .x2(pp[5][1]), .x3(pp[6][0]), .x4(1'b0), .cin(1'b0),
        .sum(s1_c6[1]), .carry(s1_c7[3]), .cout(s1_l2_cout[6])
    );
    
    compressor_4to2 c7_l1 (
        .x1(pp[0][7]), .x2(pp[1][6]), .x3(pp[2][5]), .x4(pp[3][4]), .cin(s1_l1_cout[6]),
        .sum(s1_c7[0]), .carry(s1_c8[2]), .cout(s1_l1_cout[7])
    );
    
    compressor_4to2 c7_l2 (
        .x1(pp[4][3]), .x2(pp[5][2]), .x3(pp[6][1]), .x4(pp[7][0]), .cin(s1_l2_cout[6]),
        .sum(s1_c7[1]), .carry(s1_c8[3]), .cout(s1_l2_cout[7])
    );

    compressor_4to2 c8_l1 (
        .x1(pp[1][7]), .x2(pp[2][6]), .x3(pp[3][5]), .x4(pp[4][4]), .cin(s1_l1_cout[7]),
        .sum(s1_c8[0]), .carry(s1_c9[2]), .cout(s1_l1_cout[8])
    );
    
    compressor_4to2 c8_l2 (
        .x1(pp[5][3]), .x2(pp[6][2]), .x3(pp[7][1]), .x4(1'b0), .cin(s1_l2_cout[7]),
        .sum(s1_c8[1]), .carry(s1_c9[3]), .cout(s1_l2_cout[8])
    );

    compressor_4to2 c9_l1 (
        .x1(pp[2][7]), .x2(pp[3][6]), .x3(pp[4][5]), .x4(pp[5][4]), .cin(s1_l1_cout[8]),
        .sum(s1_c9[0]), .carry(s1_c10[2]), .cout(s1_l1_cout[9])
    );
    
    compressor_4to2 c9_l2 (
        .x1(pp[6][3]), .x2(pp[7][2]), .x3(1'b0), .x4(1'b0), .cin(s1_l2_cout[8]),
        .sum(s1_c9[1]), .carry(s1_c10[3]), .cout(s1_l2_cout[9])
    );

    compressor_4to2 c10_l1 (
        .x1(pp[3][7]), .x2(pp[4][6]), .x3(pp[5][5]), .x4(pp[6][4]), .cin(s1_l1_cout[9]),
        .sum(s1_c10[0]), .carry(s1_c11[2]), .cout(s1_l1_cout[10])
    );
    
    compressor_4to2 c10_l2 (
        .x1(pp[7][3]), .x2(1'b0), .x3(1'b0), .x4(1'b0), .cin(s1_l2_cout[9]),
        .sum(s1_c10[1]), .carry(s1_c11[3]), .cout(s1_l2_cout[10])
    );

    compressor_4to2 c11_l1 (
        .x1(pp[4][7]), .x2(pp[5][6]), .x3(pp[6][5]), .x4(pp[7][4]), .cin(s1_l1_cout[10]),
        .sum(s1_c11[0]), .carry(s1_c12[2]), .cout(s1_l1_cout[11])
    );
    
    assign s1_c11[1] = 1'b0; 

    compressor_4to2 c12_l1 (
        .x1(pp[5][7]), .x2(pp[6][6]), .x3(pp[7][5]), .x4(1'b0), .cin(s1_l1_cout[11]),
        .sum(s1_c12[0]), .carry(s1_c13[2]), .cout(s1_l1_cout[12])
    );
    assign s1_c12[1] = 1'b0;

    compressor_4to2 c13_l1 (
        .x1(pp[6][7]), .x2(pp[7][6]), .x3(1'b0), .x4(1'b0), .cin(s1_l1_cout[12]),
        .sum(s1_c13[0]), .carry(s1_c14[1]), .cout(s1_l1_cout[13])
    );
    assign s1_c13[1] = 1'b0;

    wire product_msb_carry;
    
    compressor_4to2 c14_l1 (
        .x1(pp[7][7]), .x2(1'b0), .x3(1'b0), .x4(1'b0), .cin(s1_l1_cout[13]),
        .sum(s1_c14[0]), .carry(product_msb_carry), .cout(s1_l1_cout[14])
    );

    // Stage 2
    wire [15:0] row_a;
    wire [15:0] row_b;
    
    wire s2_cout [14:2]; 

    assign row_a[0] = pp[0][0];
    assign row_b[0] = 1'b0;
    assign row_a[1] = pp[0][1];
    assign row_b[1] = pp[1][0];

    compressor_4to2 c2_s2 (
        .x1(pp[0][2]), .x2(pp[1][1]), .x3(pp[2][0]), .x4(1'b0), .cin(1'b0),
        .sum(row_a[2]), .carry(row_b[3]), .cout(s2_cout[2])
    );
    assign row_b[2] = 1'b0;
    
    compressor_4to2 c3_s2 (
        .x1(pp[0][3]), .x2(pp[1][2]), .x3(pp[2][1]), .x4(pp[3][0]), .cin(s2_cout[2]),
        .sum(row_a[3]), .carry(row_b[4]), .cout(s2_cout[3])
    );

    compressor_4to2 c4_s2 (
        .x1(s1_c4[0]), .x2(s1_c4[1]), .x3(s1_c4[2]), .x4(s1_c4[3]), .cin(s2_cout[3]),
        .sum(row_a[4]), .carry(row_b[5]), .cout(s2_cout[4])
    );

    compressor_4to2 c5_s2 (
        .x1(s1_c5[0]), .x2(s1_c5[1]), .x3(s1_c5[2]), .x4(s1_c5[3]), .cin(s2_cout[4]),
        .sum(row_a[5]), .carry(row_b[6]), .cout(s2_cout[5])
    );

    compressor_4to2 c6_s2 (
        .x1(s1_c6[0]), .x2(s1_c6[1]), .x3(s1_c6[2]), .x4(s1_c6[3]), .cin(s2_cout[5]),
        .sum(row_a[6]), .carry(row_b[7]), .cout(s2_cout[6])
    );

    compressor_4to2 c7_s2 (
        .x1(s1_c7[0]), .x2(s1_c7[1]), .x3(s1_c7[2]), .x4(s1_c7[3]), .cin(s2_cout[6]),
        .sum(row_a[7]), .carry(row_b[8]), .cout(s2_cout[7])
    );

    compressor_4to2 c8_s2 (
        .x1(s1_c8[0]), .x2(s1_c8[1]), .x3(s1_c8[2]), .x4(s1_c8[3]), .cin(s2_cout[7]),
        .sum(row_a[8]), .carry(row_b[9]), .cout(s2_cout[8])
    );

    compressor_4to2 c9_s2 (
        .x1(s1_c9[0]), .x2(s1_c9[1]), .x3(s1_c9[2]), .x4(s1_c9[3]), .cin(s2_cout[8]),
        .sum(row_a[9]), .carry(row_b[10]), .cout(s2_cout[9])
    );

    compressor_4to2 c10_s2 (
        .x1(s1_c10[0]), .x2(s1_c10[1]), .x3(s1_c10[2]), .x4(s1_c10[3]), .cin(s2_cout[9]),
        .sum(row_a[10]), .carry(row_b[11]), .cout(s2_cout[10])
    );

    compressor_4to2 c11_s2 (
        .x1(s1_c11[0]), .x2(s1_c11[1]), .x3(s1_c11[2]), .x4(s1_c11[3]), .cin(s2_cout[10]),
        .sum(row_a[11]), .carry(row_b[12]), .cout(s2_cout[11])
    );

    compressor_4to2 c12_s2 (
        .x1(s1_c12[0]), .x2(s1_c12[1]), .x3(s1_c12[2]), .x4(s1_c12[3]), .cin(s2_cout[11]),
        .sum(row_a[12]), .carry(row_b[13]), .cout(s2_cout[12])
    );

    compressor_4to2 c13_s2 (
        .x1(s1_c13[0]), .x2(s1_c13[1]), .x3(s1_c13[2]), .x4(1'b0), .cin(s2_cout[12]),
        .sum(row_a[13]), .carry(row_b[14]), .cout(s2_cout[13])
    );

    wire dummy_cout;
    compressor_4to2 c14_s2 (
        .x1(s1_c14[0]), .x2(s1_c14[1]), .x3(1'b0), .x4(1'b0), .cin(s2_cout[13]),
        .sum(row_a[14]), .carry(row_b[15]), .cout(dummy_cout)
    );

    assign row_a[15] = product_msb_carry;

    // KSA
    kogge_stone_16bit final_adder (
        .a(row_a),
        .b(row_b),
        .cin(1'b0),
        .sum(product),
        .cout()
    );

endmodule
