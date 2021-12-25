`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/30 10:53:21
// Design Name: 
// Module Name: top_uart_send
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


module top_uart_send(
    input   sys_clk,//65M
    input   sys_rst_n,
    
    input   avg_done,
    input   [11:0] avg_result,
    input   [19:0] freq,
    input   [1:0] no_detect,
    
    output  uart_txd
 );

reg uart_en;
reg [7:0] uart_din; 
reg [7:0] count;
wire uart_tx_busy;

reg uart_tx_done0;
reg uart_tx_done1;
wire uart_tx_done;
wire tx_done;

assign tx_done = (~uart_tx_done1) & uart_tx_done0;
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if(!sys_rst_n) begin
        uart_tx_done0 <= 'd0;
        uart_tx_done1 <= 'd0;
    end
    else begin
        uart_tx_done0 <= uart_tx_done;
        uart_tx_done1 <= uart_tx_done0;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin 
    if(!sys_rst_n) begin
        uart_en <= 1'b0;
        count <= 8'd0;
    end
    else if(no_detect != 2) begin
        if(tx_done == 1'b1) begin //检测到uart_tx_done上升沿
                uart_en <= 1'b0;             
                if(count == 'd7)  count<= 'd0;
                else count <= count + 1'b1;   
        end
        else if(!uart_tx_busy && avg_done) uart_en <= 1'b1;
        else  uart_en <= uart_en;  
    end
    else begin
         uart_en <= 1'b0; 
         count<= 'd0;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin 
    if(!sys_rst_n) begin
        uart_din <= 8'd0;
    end
    else if(uart_en == 1'b1) begin 
         case(count)
            'd0: uart_din <=  "J";
            'd1: uart_din <=  "B";
            'd2: if(no_detect== 0) uart_din <= {4'h0,avg_result[11:8]};//或者外部触发并且没有触发信号
                 else uart_din <= 'd0;
            'd3: if(no_detect== 0) uart_din <= avg_result[7:0];
                 else uart_din <= 'd0;
            'd4: if(no_detect== 0) uart_din <= {4'h0,freq[19:16]};
                 else uart_din <= 'd0;
            'd5: if(no_detect== 0) uart_din <= freq[15:8];
                 else uart_din <= 'd0;
            'd6: if(no_detect== 0) uart_din <= freq[7:0];
                 else uart_din <= 'd0;                                                                   
            'd7: uart_din <=  "\n";
            default: ; 
        endcase
    end
    else uart_din <= uart_din;
end

uart_send u_send(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    
    .uart_en(uart_en),
    .uart_tx_busy(uart_tx_busy),
    .uart_din(uart_din),
    
    .uart_tx_done(uart_tx_done),
    .uart_txd(uart_txd)

);
endmodule
