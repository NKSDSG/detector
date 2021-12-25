`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: freq_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 数字频率计顶层例化模块
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module freq_top(
    input  wire                     clk,        //10MHz
    input  wire                     rst_n,
    input  wire                     fin,

    output [19:0]                   freq,
    output                          Hz_1,
    output                          Hz_10,
    output                          Hz_100,
    output                          Hz_1000,
    output                          over_range
);

    wire clk_div_out;               //分频器参考时钟
    wire overflow;
    wire count_en;                  //计数器使能信号
    wire clear;                     //计数器清零信号
    wire latch_en;                  //锁存器使能信号
    wire [1 : 0] clk_sel;           //分频器参考时钟选择信号
    wire [3 : 0] d0,d1,d2,d3,d4;    //输出频率的BCD码
    reg  [19 : 0] d0_reg,d1_reg,d2_reg,d3_reg,d4_reg;
    
   // assign freq = {d4,d3,d2,d1,d0};
    assign freq = {d0_reg + d1_reg*10 + d2_reg*100 + d3_reg*1000 + d4_reg*10000};
    always@(posedge clk) begin
        case(d0)
        4'b0000: d0_reg <= 0;
        4'b0001: d0_reg <= 1;
        4'b0010: d0_reg <= 2;
        4'b0011: d0_reg <= 3;
        4'b0100: d0_reg <= 4;
        4'b0101: d0_reg <= 5;
        4'b0110: d0_reg <= 6;
        4'b0111: d0_reg <= 7;
        4'b1000: d0_reg <= 8;
        4'b1001: d0_reg <= 9;
        4'b1010: d0_reg <= 10;
        4'b1011: d0_reg <= 11;
        4'b1100: d0_reg <= 12;
        4'b1101: d0_reg <= 13;
        4'b1110: d0_reg <= 14;
        4'b1111: d0_reg <= 15;
        default: ; 
        endcase
    end
    
    always@(posedge clk) begin
        case(d1)
        4'b0000: d1_reg <= 0;
        4'b0001: d1_reg <= 1;
        4'b0010: d1_reg <= 2;
        4'b0011: d1_reg <= 3;
        4'b0100: d1_reg <= 4;
        4'b0101: d1_reg <= 5;
        4'b0110: d1_reg <= 6;
        4'b0111: d1_reg <= 7;
        4'b1000: d1_reg <= 8;
        4'b1001: d1_reg <= 9;
        4'b1010: d1_reg <= 10;
        4'b1011: d1_reg <= 11;
        4'b1100: d1_reg <= 12;
        4'b1101: d1_reg <= 13;
        4'b1110: d1_reg <= 14;
        4'b1111: d1_reg <= 15;
        default: ; 
        endcase
    end
    
    always@(posedge clk) begin
        case(d2)
        4'b0000: d2_reg <= 0;
        4'b0001: d2_reg <= 1;
        4'b0010: d2_reg <= 2;
        4'b0011: d2_reg <= 3;
        4'b0100: d2_reg <= 4;
        4'b0101: d2_reg <= 5;
        4'b0110: d2_reg <= 6;
        4'b0111: d2_reg <= 7;
        4'b1000: d2_reg <= 8;
        4'b1001: d2_reg <= 9;
        4'b1010: d2_reg <= 10;
        4'b1011: d2_reg <= 11;
        4'b1100: d2_reg <= 12;
        4'b1101: d2_reg <= 13;
        4'b1110: d2_reg <= 14;
        4'b1111: d2_reg <= 15;
        default: ; 
        endcase
    end
    
    always@(posedge clk) begin
        case(d3)
        4'b0000: d3_reg <= 0;
        4'b0001: d3_reg <= 1;
        4'b0010: d3_reg <= 2;
        4'b0011: d3_reg <= 3;
        4'b0100: d3_reg <= 4;
        4'b0101: d3_reg <= 5;
        4'b0110: d3_reg <= 6;
        4'b0111: d3_reg <= 7;
        4'b1000: d3_reg <= 8;
        4'b1001: d3_reg <= 9;
        4'b1010: d3_reg <= 10;
        4'b1011: d3_reg <= 11;
        4'b1100: d3_reg <= 12;
        4'b1101: d3_reg <= 13;
        4'b1110: d3_reg <= 14;
        4'b1111: d3_reg <= 15;
        default: ; 
        endcase
    end
    
     always@(posedge clk) begin
        case(d4)
        4'b0000: d4_reg <= 0;
        4'b0001: d4_reg <= 1;
        4'b0010: d4_reg <= 2;
        4'b0011: d4_reg <= 3;
        4'b0100: d4_reg <= 4;
        4'b0101: d4_reg <= 5;
        4'b0110: d4_reg <= 6;
        4'b0111: d4_reg <= 7;
        4'b1000: d4_reg <= 8;
        4'b1001: d4_reg <= 9;
        4'b1010: d4_reg <= 10;
        4'b1011: d4_reg <= 11;
        4'b1100: d4_reg <= 12;
        4'b1101: d4_reg <= 13;
        4'b1110: d4_reg <= 14;
        4'b1111: d4_reg <= 15;
        default: ; 
        endcase
    end
    
   ila_3 ila3 (
	.clk(clk), // input wire clk


	.probe0(d0_reg), // input wire [3:0]  probe0  
	.probe1(d1_reg), // input wire [3:0]  probe1 
	.probe2(d2_reg), // input wire [3:0]  probe2 
	.probe3(d3_reg), // input wire [3:0]  probe3 
	.probe4(d4_reg) // input wire [3:0]  probe4
);

    controller  u_controller (
    .clk                     ( clk_div_out  ),
    .rst_n                   ( rst_n        ),
    .overflow                ( overflow     ),

    .count_en                ( count_en     ),
    .clear                   ( clear        ),
    .latch_en                ( latch_en     ),
    .clk_sel                 ( clk_sel      ),
    .Hz_1                    ( Hz_1         ),
    .Hz_10                   ( Hz_10        ),
    .Hz_100                  ( Hz_100       ),
    .Hz_1000                 ( Hz_1000      ),
    .over_range              ( over_range   )
    );

    data_path  u_data_path (
    .clk                     ( clk           ),
    .rst_n                   ( rst_n         ),
    .fin                     ( fin           ),
    .clk_sel                 ( clk_sel       ),
    .count_en                ( count_en      ),
    .clear                   ( clear         ),
    .latch_en                ( latch_en      ),

    .clk_div_out             ( clk_div_out   ),
    .overflow                ( overflow      ),
    .d0                      ( d0            ),
    .d1                      ( d1            ),
    .d2                      ( d2            ),
    .d3                      ( d3            ),
    .d4                      ( d4            )
    );

endmodule  //freq_top