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
// Description: BCD����������0-9����
//              
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counter_10(
    input wire en_in,       //����ʹ���ź�    
    input wire rst_n,         //��λ�ź�    
    input wire clear,       //�����ź�    
    input wire fin,         //�����ź�    
    output reg en_out,      //���ʹ�ܣ����ڿ�����һ����������״̬�������ʹ����Чʱ����һ��ģ10������������1    
    output reg [3:0] q      //�������������4λBCD�����  
);
    
always@  (posedge fin or negedge rst_n) begin   //��������źŵ���������Ϊ�����ź�
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