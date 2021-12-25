module AD9220_ReadModule(
input sys_clk,
input rstn,

input clk_AD,
//input clk_260m,
input [12:0] data,


output reg [12:0]ADC_Data
);

`define clkOutPeriod  4		//????????¨¬clk_driver = clk/4 = 260M/4 = 65M
reg [2:0] clkCnt;
reg clk_driver;


//always @(posedge clk_260m or negedge rstn)
//	if(!rstn) 
//		clkCnt <= 3'd0;
//	else if(clkCnt == (`clkOutPeriod-1)) begin
//		clkCnt <= 3'd0;
//	end
//	else begin
//		clkCnt <= clkCnt + 3'd1;
//	end
	
//always @(posedge clk_260m or negedge rstn) begin
//	if(!rstn) begin
//		clk_driver <= 1'd0;
//		ADC_Data <= 13'd0;
//	end
//	else if(clkCnt == `clkOutPeriod/2-1) begin
//		clk_driver <= 1'd1;
//		ADC_Data <= ADC_Data;
//	end
//	else if(clkCnt == `clkOutPeriod-1) begin
//		clk_driver <= 1'd0;
//		ADC_Data <= ADC_Data;
//	end
//	else begin
//		clk_driver <= clk_driver;
//		ADC_Data <= ADC_Data;
//	end
//end

always @(posedge clk_AD or negedge rstn) begin
	if(!rstn) begin
		ADC_Data <= 13'd0;
	end
	else begin
		ADC_Data <= data;
	end
end

 
 

endmodule
