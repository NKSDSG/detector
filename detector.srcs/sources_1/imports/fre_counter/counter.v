`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: bcd_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 5个BCD计数器的级联模块，同时输出溢出信号
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counter(
    input wire                      fin,         //频率待测信号
    input wire                      rst_n,
    input wire                      en_in,       //输入使能信号
    input wire                      clear,

    output [3:0]                    q0,
    output [3:0]                    q1,
    output [3:0]                    q2,
    output [3:0]                    q3,
    output [3:0]                    q4,
    output reg                      overflow
);

    wire en_out_0,en_out_1,en_out_2,en_out_3;
    wire en_out_overflow;

    counter_10  u_counter_q0 (
    .en_in                   ( en_in    ),
    .rst_n                   ( rst_n    ),
    .clear                   ( clear    ),
    .fin                     ( fin      ),

    .en_out                  ( en_out_0 ),
    .q                       ( q0       )
    );

    counter_10  u_counter_q1 (
    .en_in                   ( en_out_0 ),
    .rst_n                   ( rst_n    ),
    .clear                   ( clear    ),
    .fin                     ( fin      ),

    .en_out                  ( en_out_1 ),
    .q                       ( q1       )
    );

    counter_10  u_counter_q2 (
    .en_in                   ( en_out_1 ),
    .rst_n                   ( rst_n    ),
    .clear                   ( clear    ),
    .fin                     ( fin      ),

    .en_out                  ( en_out_2 ),
    .q                       ( q2       )
    );

    counter_10  u_counter_q3 (
    .en_in                   ( en_out_2 ),
    .rst_n                   ( rst_n    ),
    .clear                   ( clear    ),
    .fin                     ( fin      ),

    .en_out                  ( en_out_3 ),
    .q                       ( q3       )
    );

    counter_10  u_counter_q4 (
    .en_in                   ( en_out_3 ),
    .rst_n                   ( rst_n    ),
    .clear                   ( clear    ),
    .fin                     ( fin      ),

    .en_out                  ( en_out_overflow ),
    .q                       ( q4       )
    );

    always @(posedge fin or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            overflow <= 1'b0;
        end
        else begin
            if(clear == 1'b1) begin
                overflow <= 1'b0;
            end
            else if(en_out_overflow == 1'b1) begin
                overflow <= 1'b1;
            end
            else begin
                overflow <= overflow;
            end
        end
    end

endmodule  //module_name