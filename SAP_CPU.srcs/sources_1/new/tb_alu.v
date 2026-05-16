`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 11:15:30 PM
// Design Name: 
// Module Name: tb_alu
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


module tb_alu;

    reg        clk;
    reg  [7:0] a;
    reg  [7:0] b;
    reg  [2:0] alu_op;
    
    wire [15:0] result;
    wire [7:0]  remainder;
    wire        zero;
    wire        div_zero;

    integer cycle_count = 0;
    integer i;
    reg [23:0] op_name; 

    initial clk = 0;
    always #5 clk = ~clk; 

    always @(posedge clk) begin
        cycle_count = cycle_count + 1;
    end

    alu uut (
        .clk(clk), .a(a), .b(b), .alu_op(alu_op),
        .result(result), .remainder(remainder), 
        .zero(zero), .div_zero(div_zero)
    );

    always @(*) begin
        case(alu_op)
            3'b000: op_name = "ADD";
            3'b001: op_name = "SUB";
            3'b010: op_name = "MUL";
            3'b011: op_name = "DIV";
            3'b100: op_name = "AND";
            3'b101: op_name = " OR";
            3'b110: op_name = "XOR";
            default: op_name = "UNK";
        endcase
    end

    initial begin
        $display("\n===============================================================");
        $display("         STARTING DETAILED CALCULATION BENCHMARK                 ");
        $display("===============================================================\n");

        a = 8'd0; b = 8'd0; alu_op = 3'b000;
        #20; 

        for (i = 1; i <= 10000; i = i + 1) begin
            @(posedge clk);
            
            a = $random;
            b = $random;
            alu_op = $random % 7; 

            if (alu_op == 3'b011) begin
                @(posedge clk);
            end
            
            #1;

            $display("[Time: %8t ns | Cycle: %5d] #%0d | OP: %s | A: %3d | B: %3d || Res: %5d | Rem: %3d | Z: %b", 
                     $time, cycle_count, i, op_name, a, b, result, remainder, zero);
        end

        #50;

        $display("\n===============================================================");
        $display("               BENCHMARK COMPLETED SUCCESSFULLY                ");
        $display("---------------------------------------------------------------");
        $display("  => Total Operations Ran    : %0d OPs", i-1);
        $display("  => Total Clock Cycles Used : %0d Cycles", cycle_count);
        $display("  => Total Simulation Time   : %0t ns", $time);
        $display("===============================================================\n");
        
        $finish;
    end

endmodule