`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: latch_freq
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 锁存器，完成结果的锁存
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module latch_freq(
    input wire          clk_in,
    input wire          rst_n,
    input wire          latch_en,
    input wire [3:0]    q0,
    input wire [3:0]    q1,
    input wire [3:0]    q2,
    input wire [3:0]    q3,
    input wire [3:0]    q4,

    output reg [3:0]    d0,
    output reg [3:0]    d1,
    output reg [3:0]    d2,
    output reg [3:0]    d3,
    output reg [3:0]    d4
);

    always @(posedge clk_in or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            d0 <= 'd0;
            d1 <= 'd0;
            d2 <= 'd0;
            d3 <= 'd0;
            d4 <= 'd0; 
        end
        else if(latch_en == 1'b1) begin
            d0 <= q0;
            d1 <= q1;
            d2 <= q2;
            d3 <= q3;
            d4 <= q4;
        end
        else begin
            d0 <= d0;
            d1 <= d1;
            d2 <= d2;
            d3 <= d3;
            d4 <= d4;
        end
    end

endmodule