module AD9220_ReadTEST(
input sys_clk,
input rstn,

input clk_AD1,
input clk_AD2,
//input pll_260M,

input [12:0] IO_data,//ģ�����ݹܽ� ���λ����ΪOTR
input [12:0] PULSE_data,

output [12:0] ADC1_Data ,//ADC_OTR + 12λADC����
output [12:0] ADC2_Data  //ADC_OTR + 12λADC����

);



    

//ADC1��ȡ����
AD9220_ReadModule ADC1_ReadModule(
.sys_clk(sys_clk),
.rstn(rstn),

.clk_AD(clk_AD1),
//.clk_260m(pll_260M),

.data(IO_data),

.ADC_Data(ADC1_Data)
);

//ADC2��ȡ����
AD9220_ReadModule ADC2_ReadModule(
.sys_clk(sys_clk),
.rstn(rstn),

.clk_AD(clk_AD2),
//.clk_260m(pll_260M),

.data(PULSE_data),

.ADC_Data(ADC2_Data)
);

endmodule
