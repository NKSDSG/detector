检波器数字采样技术
基于xilinx平台，vivado软件
主要文件夹
1. srcs.sources_1.imports
fre_counter: 数字频率计数器
new: V1.0原始部分 其中TriggerModule没有用到

2. new
para_define.vh : 宏定义
Triggermode_Select.v : 选择系统工作模式：外部触发、内部触发、停止工作
data_trigger.v : external_trigger.v internal_trigger.v
data_process.v : external_process.v internal_process.v
