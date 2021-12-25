`timescale 1ns / 1ps
`include "para_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/23 11:47:03
// Design Name: 
// Module Name: data_process
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


module internal_process(
	input clk_AD,
	input rstn,
	
	input [1:0]  trig_mode_sel,
	input [11:0] ADC1_Data,
	
	input trigger,
//    output trigger,
//	output no_signal,
	output reg [11:0] avg_result,
	output reg avg_done
);

reg trigger_d0;
reg trigger_d1;
wire trigger_rising;
wire trigger_falling;

assign trigger_rising  = trigger_d0 & (~trigger_d1);
assign trigger_falling = trigger_d1 & (~trigger_d0);

always@(posedge clk_AD or negedge rstn) begin
	if(!rstn) begin
		trigger_d0 <= 1'b0;
		trigger_d1 <= 1'b0;
	end
	else begin
		trigger_d0 <= trigger;
		trigger_d1 <= trigger_d0;
	end
end

(* DONT_TOUCH = "TRUE" *)reg [1:0] state;
(* DONT_TOUCH = "TRUE" *)reg [`DLY_CNT_MSB:0] dly_cnt;
(* DONT_TOUCH = "TRUE" *)reg [`SUM_CNT_MSB:0] sum_cnt;
(* DONT_TOUCH = "TRUE" *)reg [`TRIG_CNT_MSB:0] trigger_cnt;
(* DONT_TOUCH = "TRUE" *)reg [127:0] sum_result;

always@(posedge clk_AD or negedge rstn) begin
	if(!rstn) begin
		avg_done <= 1'b0;
		state <= 2'd0;
		dly_cnt <= 0;
		sum_cnt <= 0;
		trigger_cnt <= 0;
		sum_result <= 0;
		avg_result <= 0;
	end
	else begin
		case(state)
			2'd0: begin		
				if(trigger_rising == 1'b1) begin //�?测到trigger,�?始计算当前高电平
					state <= 2'd1;
					trigger_cnt <= trigger_cnt + 1'b1;//脉冲高电平计数器�?1
				end
				else begin
					state <= state;				
				end
			end
			2'd1:begin
				if(dly_cnt == 'd15) begin//当前高电平内，每�?2^DLY_CNT_MSB个点计算�?�?
				    if(ADC1_Data<`HIGH_NOISE & ADC1_Data>`LOW_NOISE) begin //当前采集到的ADC数据在噪声范围内
                        dly_cnt <= 'd0;	
                        sum_result <= sum_result + ADC1_Data;						    
                        if(sum_cnt == 'd255) begin //在当前高电平内已经计算了2^SUM_CNT_MSB-1个点 255
                            sum_cnt <= 'd0;
                            if(trigger_cnt == 'd31) begin //31
                                avg_result <= 'd0;                               
                                avg_done <= 1'b0;
                                state <= 2'd2;
                            end
                            else state <= 2'd0;
                        end
                        else 
                            sum_cnt <= sum_cnt + 1'b1;			
					end	
					else begin//否则采集下一个时钟下的ADC值，dly_cnt保持不变
					    dly_cnt <= dly_cnt;
					    sum_result <= sum_result;					
					end
				end
				else begin
				    dly_cnt <= dly_cnt + 1'b1;
					state <= state;		
				end				
			end
			2'd2:begin //计算平均�?
				avg_result <= (sum_result >> (`SUM_CNT_MSB + `TRIG_CNT_MSB + 2));
				avg_done <= 1'b1;
				sum_result <= 'd0;
				sum_cnt <= 'd0;
				trigger_cnt <= 'd0;	
				state <= 2'd0;		
			end
		default : state <= 2'd0;
	    endcase
	end	
end


	
//int_trig internal_trigger(
// .sys_clk(sys_clk),
// .clk_AD(clk_AD),
// .rstn(rstn),
 
// .trig_mode_sel(trig_mode_sel),
// .ADC_Data(ADC1_Data),
 
// .no_signal(no_signal),
// .trigger(trigger)

//);
endmodule


