`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: data_path
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ����Ƶ�ʼƵ�����ͨ·����Ҫ������Ƶ��ģ�飬���1Hz��10Hz��100Hz��1000Hz��ʱ�ӣ�
//              BCD����ģ����������ģ�飬��ɶ�������߹�����
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module data_path(
    input wire          clk,            //10MHz
    input wire          rst_n,
    input wire          fin,            //�����ź�
    input wire [1:0]    clk_sel,
    input wire          count_en,
    input wire          clear,
    input wire          latch_en,
    
    output              clk_div_out,
    output              overflow,
    output [3:0]        d0,
    output [3:0]        d1,
    output [3:0]        d2,
    output [3:0]        d3,
    output [3:0]        d4
);

    wire [3:0] q0,q1,q2,q3,q4;

    clk_div  u_clk_div (
    .clk_in                  ( clk       ),
    .rst_n                   ( rst_n     ),
    .clk_sel                 ( clk_sel   ),

    .clk_out                 (clk_div_out)
    );

    counter  u_counter (
    .fin                     ( fin        ),
    .rst_n                   ( rst_n      ),
    .en_in                   ( count_en   ),
    .clear                   ( clear      ),

    .q0                      ( q0         ),
    .q1                      ( q1         ),
    .q2                      ( q2         ),
    .q3                      ( q3         ),
    .q4                      ( q4         ),
    .overflow                ( overflow   )
    );

    latch_freq  u_latch_freq (
    .clk_in                  ( clk_div_out),
    .rst_n                   ( rst_n      ),
    .latch_en                ( latch_en   ),
    .q0                      ( q0         ),
    .q1                      ( q1         ),
    .q2                      ( q2         ),
    .q3                      ( q3         ),
    .q4                      ( q4         ),

    .d0                      ( d0         ),
    .d1                      ( d1         ),
    .d2                      ( d2         ),
    .d3                      ( d3         ),
    .d4                      ( d4         )
    );

endmodule  //data_path