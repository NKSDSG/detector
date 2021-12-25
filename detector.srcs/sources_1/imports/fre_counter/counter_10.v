`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date: 2021/04/28 21:01:25
// Design Name: 
// Module Name: bcd_counter_10
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: BCD计数器，从0-9计数
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counter_10(
    input wire en_in,       //输入使能信号    
    input wire rst_n,         //复位信号    
    input wire clear,       //清零信号    
    input wire fin,         //待测信号    
    output reg en_out,      //输出使能，用于控制下一个计数器的状态，当输出使能有效时，下一个模10计数器计数加1    
    output reg [3:0] q      //计数器的输出，4位BCD码输出  
);
    
always@  (posedge fin or negedge rst_n) begin   //输入待测信号的上升沿作为敏感信号
    if(rst_n == 1'b0) begin
        en_out <= 1'b0;
        q      <=  'd0; 
    end
    else if(en_in == 1'b1) begin
        if(q == 4'b1001) begin
            q      <= 4'b0;
            en_out <= 1'b1;
        end
        else begin
            q      <= q + 1'b1;
            en_out <= 1'b0;
        end
    end
    else if(clear == 1'b1) begin
        en_out <= 1'b0;
        q      <=  'd0;
    end
    else begin
        en_out <= 1'b0;
        q      <=    q;
    end
end

    
    
endmodule