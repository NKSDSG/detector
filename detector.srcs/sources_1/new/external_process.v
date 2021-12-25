`timescale 1ns / 1ps
`include "para_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/21 15:02:21
// Design Name: 
// Module Name: external_process
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


module external_process(
	input clk_AD,
	input rstn,
	
	input [1:0] trig_mode_sel,
	input ext_trigger,
	
	input [11:0] ADC1_Data,
	input [11:0] ADC2_Data,

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
		trigger_d0 <= ext_trigger;
		trigger_d1 <= trigger_d0;
	end
end

reg [1:0] state;
reg [`DLY_CNT_MSB:0] dly_cnt;
reg [`SUM_CNT_MSB:0] sum_cnt;
reg [`TRIG_CNT_MSB:0] trigger_cnt;
reg [127:0] sum_result;



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
				if(trigger_falling == 1'b1) begin //�??娴嬪埌trigger,�??濮嬭绠�?綋鍓嶉珮鐢靛�?
					state <= 2'd1;
					trigger_cnt <= trigger_cnt + 1'b1;//鑴夊啿楂樼數骞宠鏁板櫒�??1
				end
				else begin
					state <= state;				
				end
			end
			2'd1:begin
				if(dly_cnt == 'd15) begin//褰撳墠楂樼數骞冲唴锛屾瘡�??2^DLY_CNT_MSB涓偣璁＄畻�??�??
				    if(ADC1_Data<`HIGH_NOISE) begin //褰撳墠閲囬泦鍒扮殑ADC鏁版嵁鍦ㄥ櫔澹拌寖鍥村唴
                        dly_cnt <= 'd0;	
                        sum_result <= sum_result + ADC1_Data;						    
                        if(sum_cnt == 'd255) begin //鍦ㄥ綋鍓嶉珮鐢靛钩鍐呭凡缁忚绠椾簡2^SUM_CNT_MSB-1涓�? 255
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
					else begin//鍚﹀垯閲囬泦涓嬩竴涓椂閽熶笅鐨凙DC鍊硷紝dly_cnt淇濇寔涓嶅彉
					    dly_cnt <= dly_cnt;
					    sum_result <= sum_result;					
					end
				end
				else begin
				    dly_cnt <= dly_cnt + 1'b1;
					state <= state;		
				end				
			end
			2'd2:begin //璁＄畻骞冲潎�??
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

 ila_0 u0_ila (
	.clk(clk_AD), // input wire clk

	.probe0(trig_mode_sel), // input wire [0:0]  probe0  
	.probe1(avg_result), // input wire [11:0]  probe1
	.probe2(ADC2_Data[11:0]), // input wire [11:0]  probe2
	.probe3(ext_trigger), // input wire [0:0]  probe3
	.probe4(sum_cnt), // input wire [11:0]  probe4
	.probe5(trigger_rising), // input wire [0:0]  probe5 
	.probe6(state), // input wire [1:0]  probe6
	.probe7(trigger_cnt) // input wire [5:0]  probe7
	
);	
	
endmodule
