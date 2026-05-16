`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 06:08:08 PM
// Design Name: 
// Module Name: tb_sap_cpu
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



module tb_sap_cpu;

    reg clk;
    reg clr;
    wire [7:0] out_port;

    sap1_top uut (
        .clk(clk),
        .clr(clr),
        .out_port(out_port)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("\n==================================================");
        $display("          BOOTING UP SAP-1 PIPELINED CPU          ");
        $display("==================================================\n");

        clr = 1;
        #15; 
        clr = 0;

        wait(uut.u_cu.state == 3'd6 || $time > 1000);
        #10;

        $display("\n==================================================");
        $display("              EXECUTION COMPLETED                 ");
        $display("--------------------------------------------------");
        $display(" Actual out_port  : %0d", out_port);
        $display("==================================================\n");
        $finish;
    end

    always @(posedge clk) begin
        if (!clr) begin
            $display("[Time: %0t] PC: %h | IR: %h | State: %0d | A: %3d | B: %3d | OUT: %3d",
                     $time, uut.pc_out, uut.ir_out, uut.u_cu.state, uut.a_out, uut.b_out, out_port);
        end
    end

endmodule
