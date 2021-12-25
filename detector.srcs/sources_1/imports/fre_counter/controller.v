`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 数字频率计的控制通路，主要根据越界信号调整参考时钟，并输出计数器使能信号，
//              计数器清零信号，锁存使能信号，参考时钟选择信号，频率单位输出以及是否越界。
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module controller(
    input wire              clk,
    input wire              rst_n,
    input wire              overflow,

    output reg              count_en,
    output reg              clear,
    output reg              latch_en,
    output reg [1:0]        clk_sel,

    output reg              Hz_1,
    output reg              Hz_10,
    output reg              Hz_100,
    output reg              Hz_1000,
    output reg              over_range
);

    reg [4:0] curr_state;
    reg [4:0] next_state;

    localparam IDLE         = 5'd0;
    localparam OVERRANGE    = 5'd1;
    localparam COUNT_1      = 5'd2;
    localparam ONE_2_TEN    = 5'd3;
    localparam COUNT_10     = 5'd4;
    localparam TEN_2_HUN    = 5'd5;
    localparam COUNT_100    = 5'd6;
    localparam HUN_2_THO    = 5'd7;
    localparam COUNT_1000   = 5'd8;
    localparam DONE_1       = 5'd9;
    localparam DONE_10      = 5'd10;
    localparam DONE_100     = 5'd11;
    localparam DONE_1000    = 5'd12;
    localparam LATCH_1      = 5'd13;
    localparam LATCH_10     = 5'd14;
    localparam LATCH_100    = 5'd15;
    localparam LATCH_1000   = 5'd16;

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= next_state;
        end
    end

    always @(*) begin
        case (curr_state)
            IDLE:       next_state = COUNT_1;
            COUNT_1:    next_state = overflow ? ONE_2_TEN : DONE_1;
            ONE_2_TEN:  next_state = COUNT_10;
            COUNT_10:   next_state = overflow ? TEN_2_HUN : DONE_10;
            TEN_2_HUN:  next_state = COUNT_100;
            COUNT_100:  next_state = overflow ? HUN_2_THO : DONE_100;
            HUN_2_THO:  next_state = COUNT_1000;
            COUNT_1000: next_state = overflow ? OVERRANGE : DONE_1000;
            DONE_1:     next_state = LATCH_1;
            DONE_10:    next_state = LATCH_10;
            DONE_100:   next_state = LATCH_100;
            DONE_1000:  next_state = LATCH_1000;
            LATCH_1:    next_state = IDLE;
            LATCH_10:   next_state = IDLE;
            LATCH_100:  next_state = IDLE;
            LATCH_1000: next_state = IDLE;
            OVERRANGE:  next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            count_en    <= 1'b0;
            clear       <= 1'b1;
            latch_en    <= 1'b0;
            clk_sel     <= 2'b00;
            Hz_1        <= 1'b0;
            Hz_10       <= 1'b0;
            Hz_100      <= 1'b0;
            Hz_1000     <= 1'b0;
            over_range  <= 1'b0;
        end
        else begin
            count_en    <= 1'b0;
            clear       <= 1'b0;
            latch_en    <= 1'b0;
            clk_sel     <= 2'b00;
            Hz_1        <= 1'b0;
            Hz_10       <= 1'b0;
            Hz_100      <= 1'b0;
            Hz_1000     <= 1'b0;
            over_range  <= 1'b0;
            case(next_state)
                IDLE: begin
                    clear   <= 1'b1;
                    clk_sel <= 2'b00;
                end   
                COUNT_1: begin
                    clk_sel     <= 2'b00;
                    count_en    <= 1'b1;
                end
                ONE_2_TEN: begin
                    clear   <= 1'b1;
                    clk_sel <= 2'b01;
                end
                COUNT_10: begin
                    clk_sel  <= 2'b01;
                    count_en <= 1'b1;
                end
                TEN_2_HUN: begin
                    clear   <= 1'b1;
                    clk_sel <= 2'b10;
                end
                COUNT_100: begin
                    clk_sel <= 2'b10;
                    count_en<= 1'b1;
                end
                HUN_2_THO: begin
                    clk_sel <= 2'b11;
                    clear   <= 1'b1;
                end
                COUNT_1000: begin
                    clk_sel <= 2'b11;
                    count_en<= 1'b1;
                end
                DONE_1: begin
                    latch_en <= 1'b1;
                end
                LATCH_1: begin
                    Hz_1     <= 1'b1;
                end
                DONE_10: begin
                    latch_en <= 1'b1;
                end
                LATCH_10: begin
                    Hz_10     <= 1'b1;
                end
                DONE_100: begin
                    latch_en <= 1'b1;
                end
                LATCH_100: begin
                    Hz_100   <= 1'b1; 
                end
                DONE_1000: begin
                    latch_en <= 1'b1;
                end
                LATCH_1000: begin
                    Hz_1000  <= 1'b1; 
                end
                OVERRANGE: begin
                    over_range <= 1'b1; 
                end
                default:begin
                    count_en    <= 1'b0;
                    clear       <= 1'b0;
                    latch_en    <= 1'b0;
                    clk_sel     <= 2'b00;
                    Hz_1        <= 1'b0;
                    Hz_10       <= 1'b0;
                    Hz_100      <= 1'b0;
                    Hz_1000     <= 1'b0;
                    over_range  <= 1'b0;
                end 
            endcase
        end
    end

endmodule  //controller