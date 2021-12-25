`timescale 1ns / 1ps
`include "para_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/21 09:19:31
// Design Name: 
// Module Name: Triggermode_Select
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


module Triggermode_Select(
	input sys_clk,
	input rstn,	
	
	input [7:0] host_inst,
	input recv_done,
	
	output reg[1:0] trigger_mode
    );

parameter S0 = 5'b00000;
parameter S1 = 5'b00001;
parameter S2 = 5'b00010;

reg [2:0] state;


//reg define
reg recv_done_d0;
reg recv_done_d1;

//wire define
wire recv_done_flag;

//*****************************************************
//**                    main code
//*****************************************************

//捕获recv_done上升沿，得到一个时钟周期的脉冲信号
assign recv_done_flag = (~recv_done_d1) & recv_done_d0;
                                                 
//对发送使能信号recv_done延迟两个时钟周期
always @(posedge sys_clk or negedge rstn) begin         
    if (!rstn) begin
        recv_done_d0 <= 1'b0;                                  
        recv_done_d1 <= 1'b0;
    end                                                      
    else begin                                               
        recv_done_d0 <= recv_done;                               
        recv_done_d1 <= recv_done_d0;                            
    end
end

always@(posedge sys_clk or negedge rstn) begin
	if(!rstn) begin
		state <= S0;
		trigger_mode <= `EXT_TRIG;
	end
	else begin
	 if(recv_done_flag) begin
		case(state)
			S0: if(host_inst == "J") 
					state <= S1;
				else 
					state <= S0;
			S1: if(host_inst == "B") 
					state <= S2;
				else 
					state <= S0;
			S2: 
				if(host_inst == "I") begin
					trigger_mode <= `INT_TRIG;
					state <= S0;
				end
				else if(host_inst == "E") begin
					trigger_mode <= `EXT_TRIG;
					state <= S0;
				end
				else if(host_inst == "S") begin
					trigger_mode <= `STOP_TRIG;
					state <= S0;
				end
				else begin
					trigger_mode <= trigger_mode;
					state <= S0;
				end
			default: begin
					trigger_mode <= trigger_mode;
					state <= S0;
				end
		endcase
	   end
	   else trigger_mode <= trigger_mode;
	end
end

//ila_1 u1_ila1 (
//	.clk(sys_clk), // input wire clk


//	.probe0(host_inst), // input wire [1:0]  probe0  
//	.probe1(trigger_mode), // input wire [0:0]  probe1 
//	.probe2(recv_done), // input wire [0:0]  probe2 
//	.probe3(recv_done_flag), // input wire [0:0]  probe3 
//	.probe4(state) // input wire [0:0]  probe4
//);
	
endmodule
