`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/20 15:28:05
// Design Name: 
// Module Name: fifo_rd
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 预触发深度写满前,只写不读,fifo_rd_en = 0
// 预触发深度写满后,边写边读,fifo_rd_en = 1
// �?测到触发信号�?,停止读取,fifo_rd_en = 0
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_rd(
	input clk , 
	input rstn ,
	
	input almost_full , 
	input almost_empty ,

	input [16 : 0] fifo_rd_data_count,
	input [16 : 0] fifo_wr_data_count,
	
	output reg fifo_rd_en,
	
	input [12 : 0] fifo_dout ,
	input trigger
	 
);

parameter pretrigger_counter = 16'd32768;

//reg define
reg [1:0] state ;
reg almost_full_d0 ; 
reg almost_full_syn ;
reg [3:0] dly_cnt ; 


always@( posedge clk or negedge rstn) begin
	if( !rstn ) begin
		almost_full_d0 <= 1'b0 ;
		almost_full_syn <= 1'b0 ;
	end
	else begin
		almost_full_d0 <= almost_full ;
		almost_full_syn <= almost_full_d0 ;
	end
end


always @(posedge clk or negedge rstn) begin
	if(!rstn) begin
		fifo_rd_en <= 1'b0;
		state <= 2'd0;
//		dly_cnt <= 4'd0;
	end
	else begin
		case(state)
			2'd0: begin
				if(fifo_wr_data_count == pretrigger_counter) begin 
					//计数完成前，触发模块不进行判�?											
					//预触发深度写满后,边写边读
					fifo_rd_en <= 1'b1;
					state <= 2'd1;
				end	
				else begin
					fifo_rd_en <= 1'b0;	
				end
			end
			2'd1: begin
				if(trigger) begin
					// �?测到触发信号�?,停止读取
					fifo_rd_en <= 1'b0;  			
				end
				else if(almost_empty) begin
					fifo_rd_en <= 1'b0;
					state <= 2'd0;
				end
				else begin
					fifo_rd_en <= fifo_rd_en;					
				end
			end
		default : state <= 2'd0;
	    endcase
	end
end

endmodule
