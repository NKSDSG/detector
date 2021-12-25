`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/23 16:25:36
// Design Name: 
// Module Name: tb_topmodule
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


module tb_topmodule();

logic sys_clk;
logic clk_AD;
logic rstn;

logic uart_txd;
logic [12:0] IO_data;

// clock generation
initial begin 
  sys_clk <= 0;
  forever begin
    #10 sys_clk <= !sys_clk;
  end
end

// reset trigger
initial begin 
  rstn <= 0;
  repeat(10) @(posedge sys_clk);
  rstn <= 1;
end

// txt
parameter data_num = 163840;
logic [11:0] Read_Data[data_num-1];
logic [0:0] otr [data_num-1];
integer i;
initial begin
	$readmemb("D:/shixi/matlab/FPGA/adc_data.txt",Read_Data);
	$readmemb("D:/shixi/matlab/FPGA/adc_otr.txt",otr);
	wait(rstn == 1);
	for (i=0;i<data_num;i++) begin
		IO_data = {otr[i],Read_Data[i]};
		@(posedge clk_AD); 
	end
	#1000000000
	#1000000000
	#1000000000
	#1000000000
	#1000000000
	#1000000000
	#1000000000
    $stop;
end

top_module u_top_module(
    .sys_clk(sys_clk),
	.rstn    (rstn),
	
	.IO_data(IO_data),
	.clk_AD  (clk_AD),
	.uart_txd(uart_txd)
);

endmodule
