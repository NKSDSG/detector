`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/23 21:49:16
// Design Name: 
// Module Name: data_trigger
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


module data_trigger(
	input sys_clk,
	input rstn,
	
	input clk_AD1,
	input clk_AD2,
	
	input [1:0]  trig_mode_sel,
	input [11:0] ADC1_Data,
	input [11:0] ADC2_Data,
	
	output  no_signal,
	output	no_external,
	output  trigger,
	output  ext_trigger
    );
 
internal_trigger u_int_trigger(
    .sys_clk(sys_clk),
    .clk_AD(clk_AD1),
 
    .rstn	(rstn),
    
    .ADC_Data(ADC1_Data),

    .trig_mode_sel(trig_mode_sel),
    .no_signal(no_signal),
    
    .trigger(trigger)
);

external_trigger u_ext_trigger(
    .sys_clk(sys_clk),
    .clk_AD(clk_AD2),
 
    .rstn	(rstn),
    
    .ADC_Data(ADC2_Data),

    .trig_mode_sel(trig_mode_sel),
    .no_external(no_external),
    
    .ext_trigger(ext_trigger)
); 
    
endmodule
