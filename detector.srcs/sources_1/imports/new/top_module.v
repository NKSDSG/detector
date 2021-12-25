`timescale 1ns / 1ps
`include "para_define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/23 16:18:14
// Design Name: 
// Module Name: top_module
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

module top_module(
	input sys_clk,
	input rstn,
	
	input [12:0] IO_data,
	input [12:0] PULSE_data,
	
	input uart_rxd,
	output uart_txd,
	
	output clk_AD1,
	output clk_AD2
);


(* DONT_TOUCH = "TRUE" *) wire [12:0]ADC1_Data;
(* DONT_TOUCH = "TRUE" *) wire [12:0]ADC2_Data;
(* DONT_TOUCH = "TRUE" *) wire       trigger;
(* DONT_TOUCH = "TRUE" *) wire [11:0]avg_result;
(* DONT_TOUCH = "TRUE" *) wire       avg_done;
(* DONT_TOUCH = "TRUE" *) wire [7:0] trig_mode_host;
(* DONT_TOUCH = "TRUE" *) wire [1:0] tri_mode;
(* DONT_TOUCH = "TRUE" *) wire no_signal;
(* DONT_TOUCH = "TRUE" *) wire uart_recv_done;

reg  [1:0]no_detect;
wire no_external;
wire ext_trigger;

//PLL outputs
wire pll_260M;
wire pll_locked;
wire clk_10MHz;

// freq_top Outputs
reg  fin;
wire  [19:0]  freq;                 //5位BCD码频率输出
wire  Hz_1;                         //单位为1Hz
wire  Hz_10;                        //单位为10Hz
wire  Hz_100;                       //单位为100Hz
wire  Hz_1000;                      //单位为1000Hz
wire  over_range;                   //超出量程

always@(*) begin
    if(tri_mode == `STOP_TRIG) fin = 0;
    else if(tri_mode == `INT_TRIG) fin = trigger;
    else fin = ext_trigger;
end

always@(*) begin
    if(tri_mode == `STOP_TRIG) no_detect = 'd2;
    else if(tri_mode == `INT_TRIG) no_detect = no_signal;
    else no_detect = no_external ;
end
//assign fin = (tri_mode == `INT_TRIG)? trigger: ext_trigger;
//assign no_detect = (tri_mode == `INT_TRIG)? no_signal: no_external;

clk_wiz_0 pll_260m
(
// Clock out ports
.clk_out1(clk_AD1),     // output clk_out1
.clk_out2(clk_AD2),     // output clk_out2
.clk_out3(clk_10MHz),     // output clk_out3
// Status and control signals
.reset(~rstn), // input reset
.locked(pll_locked),       // output locked
// Clock in ports
.clk_in1(sys_clk) // input clk_in1
);   
  

//***************************************
//根据上位机指令选择触发模式
//tri_mode 0:内部 1:外部 2:停止工作
uart_recv recv_trig_mode(
    .sys_clk(sys_clk),
    .sys_rst_n(rstn),
    .uart_rxd(uart_rxd),
    
    .uart_done(uart_recv_done),
    .uart_data(trig_mode_host)
);

Triggermode_Select trig_sel(
    .sys_clk(sys_clk),
    .rstn(rstn),
    .host_inst(trig_mode_host),
    .recv_done(uart_recv_done),
    
    .trigger_mode(tri_mode)
);


//***************************************
//触发波形，暂未使用
//TriggerModule u_triggermodule(
//    .clk_AD	(clk_AD),
//    .rstn	(rstn),
//	.ADC_Data (ADC1_Data),
//	.trigger (trigger)

//);

//***************************************
data_trigger u_data_trigger(
    
    .sys_clk(sys_clk),
    .clk_AD1(clk_AD1),
	.clk_AD2(clk_AD2),
    .rstn	(rstn),
    
    .ADC1_Data(ADC1_Data[11:0]),
	.ADC2_Data(ADC2_Data[11:0]),
	
    .trig_mode_sel(tri_mode),
	
    .no_signal(no_signal),
    .no_external(no_external),
    .trigger(trigger),
	.ext_trigger(ext_trigger)
    
);
//internal_trigger u_int_trigger(
//    .sys_clk(sys_clk),
//    .clk_AD(clk_AD1),
 
//    .rstn	(rstn),
    
//    .ADC_Data(ADC1_Data[11:0]),

//    .trig_mode_sel(tri_mode),
//    .no_signal(no_signal),
    
//    .trigger(trigger)
//);

//external_trigger u_ext_trigger(
//    .sys_clk(sys_clk),
//    .clk_AD(clk_AD2),
 
//    .rstn	(rstn),
    
//    .ADC_Data(ADC2_Data[11:0]),

//    .trig_mode_sel(tri_mode),
//    .no_external(no_external),
    
//    .ext_trigger(ext_trigger)
//);

//simple_trigger u2_trigger(
//    .sys_clk(sys_clk),
//    .clk_AD	(clk_AD1),
//    .rstn	(rstn),
    
//    .ADC_Data(ADC1_Data),
//    .trig_mode_sel(tri_mode),
    
//    .no_signal(no_signal),
//    .trigger(trigger)
//);
//***************************************
//内部触发和外部触发
data_process u_data_process(
    .sys_clk (sys_clk),
    .clk_AD1 (clk_AD1),
    .clk_AD2 (clk_AD2),
    .rstn	(rstn),
    
    .trig_mode_sel(tri_mode),
    .trigger (trigger),
    .ext_trigger(ext_trigger),
//    .no_signal(no_signal),
	.ADC1_Data (ADC1_Data[11:0]),
	.ADC2_Data (ADC2_Data[11:0]),
	
	.avg_done(avg_done),
	.avg_result(avg_result)
);

//***************************************
//输出最终结果平均值
top_uart_send send_packdata(
    .sys_clk(clk_AD1),
    .sys_rst_n(rstn),
    
    .avg_done(avg_done),
    .avg_result(avg_result),
    .freq(freq),
    .no_detect(no_detect),
    
    .uart_txd(uart_txd)
 );
 
 //***************************************
 //频率测量模块
 freq_top  u_freq_top (
    .clk                     ( clk_10MHz    ),
    .rst_n                   ( rstn         ),
    .fin                     ( fin          ),

    .freq                    ( freq         ),
    .Hz_1                    ( Hz_1         ),
    .Hz_10                   ( Hz_10        ),
    .Hz_100                  ( Hz_100       ),
    .Hz_1000                 ( Hz_1000      ),
    .over_range              ( over_range   )
);
 
 ila_2 ila2 (
	.clk(clk_10MHz), // input wire clk

	.probe0(freq), // input wire [19:0]  probe0  
	.probe1(trigger), // input wire [0:0]  probe1 
	.probe2(ext_trigger), // input wire [0:0]  probe2
	.probe3(no_signal), // input wire [0:0]  probe3 
	.probe4(no_external), // input wire [0:0]  probe4
	.probe5(no_detect),
	.probe6(tri_mode)
	
);
    
//***************************************
//ADC的驱动程序，包括ADC1和ADC2
//ADC1对应IO_data，读取检波器的数据
//ADC2对应pulse_data，读取外部脉冲的数据
AD9220_ReadTEST u_adc_read(
    .sys_clk(sys_clk),
    .rstn(rstn),
    
    .clk_AD1(clk_AD1),
    .clk_AD2(clk_AD2),
    
    .IO_data(IO_data),//模块数据管脚 最高位定义为OTR
    .PULSE_data(PULSE_data),
    
    .ADC1_Data(ADC1_Data), //ADC_OTR + 12位ADC数据
    .ADC2_Data(ADC2_Data) //ADC_OTR + 12位ADC数据
);





endmodule
