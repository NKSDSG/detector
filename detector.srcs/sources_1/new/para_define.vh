`define INT_TRIG  0
`define EXT_TRIG  1
`define STOP_TRIG 2

//threshold
`define INT_TH  2417
`define EXT_TH  1800 //3000

//去噪�?
`define HIGH_NOISE  3000
`define LOW_NOISE  300

//DLY_CNT_MSB �? SUM_CNT_MSB的具体数值要根据实际情况改正
`define DLY_CNT_MSB  3//2^4 = 16
`define SUM_CNT_MSB  7//2^8 = 256
`define TRIG_CNT_MSB 4//2^5 = 32