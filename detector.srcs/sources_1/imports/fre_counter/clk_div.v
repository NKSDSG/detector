`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: clk_div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: input 10MHz clk_in
//              output clk_out:1Hz clk_1;10Hz clk_10;100Hz clk_100£»1000Hz clk_1000
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module clk_div(
    input                           clk_in,         //10MHz
    input                           rst_n,
    input [1:0]                     clk_sel,
    output reg                      clk_out     
);

    reg clk_1,clk_10,clk_100,clk_1000;
    reg [31:0] cnt_1,cnt_10,cnt_100,cnt_1000;

    //1Hz
    always @(posedge clk_in or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_1 <= 'd0;
            clk_1 <= 1'b0;
        end
        else begin
            if(cnt_1 == 32'd4999999) begin
                cnt_1 <= 'd0;
                clk_1 <= ~clk_1;
            end
            else begin
                cnt_1 <= cnt_1 + 1'b1;
                clk_1 <= clk_1;
            end
        end
    end

    //10Hz
    always @(posedge clk_in or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_10 <= 'd0;
            clk_10 <= 1'b0;
        end
        else begin
            if(cnt_10 == 32'd499999) begin
                cnt_10 <= 'd0;
                clk_10 <= ~clk_10;
            end
            else begin
                cnt_10 <= cnt_10 + 1'b1;
                clk_10 <= clk_10;
            end
        end
    end

    //100Hz
    always @(posedge clk_in or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_100 <= 'd0;
            clk_100 <= 1'b0;
        end
        else begin
            if(cnt_100 == 32'd49999) begin         //ori = 49999
                cnt_100 <= 'd0;
                clk_100 <= ~clk_100;
            end
            else begin
                cnt_100 <= cnt_100 + 1'b1;
                clk_100 <= clk_100;
            end
        end
    end

    //1000Hz
    always @(posedge clk_in or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            cnt_1000 <= 'd0;
            clk_1000 <= 1'b0;
        end
        else begin
            if(cnt_1000 == 32'd4999) begin
                cnt_1000 <= 'd0;
                clk_1000 <= ~clk_1000;
            end
            else begin
                cnt_1000 <= cnt_1000 + 1'b1;
                clk_1000 <= clk_1000;
            end
        end
    end

    always @(*) begin
        case(clk_sel)
            2'b00:  clk_out = clk_1;
            2'b01:  clk_out = clk_10;
            2'b10:  clk_out = clk_100;
            2'b11:  clk_out = clk_1000;
            default:clk_out = clk_1;
        endcase
    end

endmodule  //module_name