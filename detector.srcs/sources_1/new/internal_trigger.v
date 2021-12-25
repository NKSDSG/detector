`timescale 1ns / 1ps
`include "para_define.vh"

module internal_trigger(

	input clk_AD,
	input sys_clk,
	input rstn,
	
	input [1:0]  trig_mode_sel,
	input [11:0] ADC_Data,
	
	output reg no_signal,
	output reg trigger

);


//param define
reg [27:0] no_signal_time;
reg [11:0] shift_reg[3:0];

//超过2S
always @(posedge sys_clk or negedge rstn) begin 
    if(!rstn) begin
        no_signal <= 'd0;
		no_signal_time <= 'd0;
    end
    else if(trig_mode_sel == `INT_TRIG) begin
        if(no_signal_time < 'd100000000) begin
            if(trigger == 1'b1) begin 
              no_signal <= 'd0;
              no_signal_time <= 1'b0;
            end
            else no_signal_time <= no_signal_time +1'b1;
        end
        else begin
           no_signal <= 1'b1;
           no_signal_time <= 'd0;
        end
	end
	else  begin
        no_signal <= 'd0;
		no_signal_time <= 'd0;
    end
end



//reg trigger_flag;
always@(posedge clk_AD or negedge rstn) begin
	if(!rstn) begin
		shift_reg[0] <= 12'd0;
		shift_reg[1] <= 12'd0;
		shift_reg[2] <= 12'd0;
		shift_reg[3] <= 12'd0;		
	end                 
	else begin          
		shift_reg[0] <= ADC_Data;
		shift_reg[1] <= shift_reg[0];
		shift_reg[2] <= shift_reg[1];
		shift_reg[3] <= shift_reg[2];
	end
end

always@(posedge clk_AD or negedge rstn) begin
	if(!rstn) begin
		trigger <= 1'b0;
	end
	else if(trig_mode_sel == `INT_TRIG) begin
		if(shift_reg[0] >= `INT_TH) begin
			if(trigger == 1'b0) begin//rising edge
				if(shift_reg[0]>=shift_reg[1] && shift_reg[1]>=shift_reg[2] && shift_reg[2]>=shift_reg[3]) begin
					trigger <= 1'b1;
				end
				else trigger <= trigger;
			end 
			else trigger <= trigger;
		end
		else begin
			if(trigger == 1'b1) begin//falling edge
				if(shift_reg[0]<=shift_reg[1] && shift_reg[1]<=shift_reg[2] && shift_reg[2]<=shift_reg[3]) begin
					trigger <= 1'b0;
				end
				else trigger <= trigger;				
			end		
			else trigger <= trigger;
		end
	end
	else trigger <= 1'b0;
end


endmodule