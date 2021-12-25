module AD9220_ReadTEST(
input sys_clk,
input rstn,

input clk_AD1,
input clk_AD2,
//input pll_260M,

input [12:0] IO_data,//模块数据管脚 最高位定义为OTR
input [12:0] PULSE_data,

output [12:0] ADC1_Data ,//ADC_OTR + 12位ADC数据
output [12:0] ADC2_Data  //ADC_OTR + 12位ADC数据

);



    

//ADC1读取数据
AD9220_ReadModule ADC1_ReadModule(
.sys_clk(sys_clk),
.rstn(rstn),

.clk_AD(clk_AD1),
//.clk_260m(pll_260M),

.data(IO_data),

.ADC_Data(ADC1_Data)
);

//ADC2读取数据
AD9220_ReadModule ADC2_ReadModule(
.sys_clk(sys_clk),
.rstn(rstn),

.clk_AD(clk_AD2),
//.clk_260m(pll_260M),

.data(PULSE_data),

.ADC_Data(ADC2_Data)
);

endmodule
