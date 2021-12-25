// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Nov 20 18:21:28 2021
// Host        : LAPTOP-HLA83F6G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/shixi/fpga_prj/vivado/trigger/TriggerModule/TriggerModule.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2019.2" *)
module fifo_generator_0(wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  almost_full, empty, almost_empty, rd_data_count, wr_data_count)
/* synthesis syn_black_box black_box_pad_pin="wr_clk,rd_clk,din[12:0],wr_en,rd_en,dout[12:0],full,almost_full,empty,almost_empty,rd_data_count[12:0],wr_data_count[12:0]" */;
  input wr_clk;
  input rd_clk;
  input [12:0]din;
  input wr_en;
  input rd_en;
  output [12:0]dout;
  output full;
  output almost_full;
  output empty;
  output almost_empty;
  output [12:0]rd_data_count;
  output [12:0]wr_data_count;
endmodule
