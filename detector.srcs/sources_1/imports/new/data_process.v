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


module data_process(
    input sys_clk,
	input clk_AD1,
	input clk_AD2,
	input rstn,
	
	input [1:0] trig_mode_sel,
	input trigger,
	input ext_trigger,
//	output trigger,
//	output no_signal,
	
	input [11:0] ADC1_Data,
	input [11:0] ADC2_Data,

	output [11:0] avg_result,
	output avg_done
);

wire avg_done1;
wire avg_done2;
wire [11:0] avg_result1;
wire [11:0] avg_result2;

//assign avg_done = (trig_mode_sel==`INT_TRIG)? avg_done1:avg_done1;
//assign avg_result = (trig_mode_sel==`INT_TRIG)? avg_result1:avg_result1;

assign avg_done = (trig_mode_sel==`INT_TRIG)? avg_done1:avg_done2;
assign avg_result = (trig_mode_sel==`INT_TRIG)? avg_result1:avg_result2;

internal_process u_int_pro(
    .clk_AD	(clk_AD1),
    .rstn	(rstn),
	
	.trigger (trigger),
	.trig_mode_sel(trig_mode_sel),
	//.no_signal(no_signal),
	
	.ADC1_Data (ADC1_Data),
	
	.avg_done(avg_done1),
	.avg_result(avg_result1)

);

external_process u_ext_pro(
    .clk_AD	(clk_AD2),
    .rstn	(rstn),
	
	.ext_trigger(ext_trigger),
	.trig_mode_sel(trig_mode_sel),
	
	.ADC1_Data (ADC1_Data),
	.ADC2_Data (ADC2_Data),
	
	.avg_done(avg_done2),
	.avg_result(avg_result2)

);


endmodule


