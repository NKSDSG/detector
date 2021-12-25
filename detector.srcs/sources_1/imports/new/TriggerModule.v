module TriggerModule
(
	input clk_AD,
	input rstn,
	
	input [12:0] ADC_Data,
	
	output trigger
	
);

//FIFO
wire fifo_wr_en ; 
wire fifo_rd_en ; 
wire [12:0] fifo_din ; 
wire [12:0] fifo_dout ; 
wire almost_full ; 
wire almost_empty ; 
wire fifo_full ; 
wire fifo_empty ; 
wire [16:0] fifo_wr_data_count ; 
wire [16:0] fifo_rd_data_count ; 

 
fifo_generator_0 trigger_fifo (
  .wr_clk(clk_AD),                // input wire wr_clk
  .rd_clk(clk_AD),                // input wire rd_clk
  
  .wr_en(fifo_wr_en),                  // input wire wr_en
  .rd_en(fifo_rd_en),                  // input wire rd_en
  
  .din(fifo_din),                      // input wire [12 : 0] din
  .dout(fifo_dout),                    // output wire [12 : 0] dout
  
  .almost_full(almost_full),      // output wire almost_full
  .almost_empty(almost_empty),    // output wire almost_empty
  .full(fifo_full),                    // output wire full
  .empty(fifo_empty),                  // output wire empty
  
  .rd_data_count(fifo_rd_data_count),  // output wire [16 : 0] rd_data_count
  .wr_data_count(fifo_wr_data_count)  // output wire [16 : 0] wr_data_count
);


pre_trigger u1_pre_trigger(
    .clk_AD	(clk_AD),
    .rstn	(rstn),
   
	.fifo_rd_en(fifo_rd_en),
	.fifo_wr_en(fifo_wr_en),
	
	.fifo_din(fifo_din),
	.fifo_dout(fifo_dout),
	
	.almost_full(almost_full),
	.almost_empty(almost_empty),
	.fifo_full(fifo_full), 
	.fifo_empty(fifo_empty),
	
	.fifo_rd_data_count(fifo_rd_data_count),
	.fifo_wr_data_count(fifo_wr_data_count),
	
	.ADC_Data(ADC_Data),
    .trigger(trigger)
	
);

simple_trigger u2_trigger(
    .sys_clk(sys_clk),
    .clk_AD	(clk_AD),
    .rstn	(rstn),
	
    .ADC_Data(ADC_Data),
    .trigger(trigger)
);

//the signal first enter a pre-trigger fifo




endmodule