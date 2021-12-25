`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 17:53:26
// Design Name: 
// Module Name: pre_trigger
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


module pre_trigger(
	input clk_AD,
	input rstn,
	
	output fifo_rd_en,
	output fifo_wr_en,
	
	output [12 : 0] fifo_din,
	input  [12 : 0] fifo_dout,
	
	input almost_full,
	input almost_empty,
	input fifo_full, 
	input fifo_empty,
	
	input [16 : 0] fifo_rd_data_count,
	input [16 : 0] fifo_wr_data_count,
	
	input [12 : 0] ADC_Data,
	input trigger
);
	

fifo_wr u_fifo_wr(
    .clk ( clk_AD ), 
    .rstn ( rstn ), 
    
	.almost_empty ( almost_empty ), 
    .almost_full ( almost_full ),
	
    .fifo_rd_data_count(fifo_rd_data_count),
	.fifo_wr_data_count(fifo_wr_data_count),
	
    .fifo_wr_en ( fifo_wr_en ) , 
    .fifo_wr_data ( fifo_din ) , 
    
	.ADC_Data(ADC_Data)
);


fifo_rd u_fifo_rd(
    .clk ( clk_AD ), 
    .rstn ( rstn ), 
	
    .almost_empty ( almost_empty ), 
    .almost_full ( almost_full ) ,
	
    .fifo_rd_data_count(fifo_rd_data_count),
	.fifo_wr_data_count(fifo_wr_data_count),
	
    .fifo_rd_en ( fifo_rd_en ), 
    .fifo_dout ( fifo_dout ), 
    
    .trigger(trigger)

);
	
	
	
endmodule
