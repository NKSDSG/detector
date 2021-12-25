`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/20 15:27:33
// Design Name: 
// Module Name: fifo_wr
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


module fifo_wr(//全程在写
	input clk,
	input rstn,
	
	input almost_empty, 
	input almost_full ,
	
	input [16 : 0] fifo_rd_data_count,
	input [16 : 0] fifo_wr_data_count,
	
	//output reg fifo_rd_en,
	output reg fifo_wr_en, 
	output reg [12 : 0] fifo_wr_data,
	
	input [12 : 0] ADC_Data
);

	
//reg define
reg [1:0] state;
reg almost_empty_d0 ; 
reg almost_empty_syn ; //almost_empty 延迟两拍
reg [3:0] dly_cnt ; 	

always@( posedge clk or negedge rstn) begin
	if( !rstn ) begin
		almost_empty_d0 <= 1'b0 ;
		almost_empty_syn <= 1'b0 ;
	end
	else begin
		almost_empty_d0 <= almost_empty ;
		almost_empty_syn <= almost_empty_d0 ;
	end
end


//向fifo中写入数�?
always @(posedge clk or negedge rstn) begin
	if( !rstn ) begin
		fifo_wr_en <= 1'b0;
		fifo_wr_data <= 12'd0;
		state <= 2'd0;
		dly_cnt <= 4'd0;
	end
	else begin
		case(state)
		2'd0:begin
			if(almost_empty_syn) begin
				state <= 2'd1;
			end
			else begin
				state <= state;
			end
		end
		2'd1:begin
			if(dly_cnt == 4'd10) begin 
				dly_cnt <= 4'd0;
				state <= 2'd2;
				fifo_wr_en <= 1'b1;
			end
			else
				dly_cnt <= dly_cnt + 4'd1;
		end
		2'd2:begin
			if(almost_full) begin
				fifo_wr_en <= 1'b0; 
				fifo_wr_data <= 12'd0;
				state <= 2'd0;
			end
			else begin 
				fifo_wr_en <= 1'b1; 
				fifo_wr_data <= ADC_Data;	
			end
		end
		default : state <= 2'd0;
		endcase
	end
end


endmodule
