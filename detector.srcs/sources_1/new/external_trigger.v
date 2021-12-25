`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/24 09:31:09
// Design Name: 
// Module Name: external_ext_trigger
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


module external_trigger(

	input clk_AD,
	input sys_clk,
	input rstn,
	
	input [1:0]  trig_mode_sel,
	input [11:0] ADC_Data,
	
	output reg no_external,
	output reg ext_trigger

    );
	
//param define
reg [27:0] no_external_time;
reg [11:0] shift_reg[3:0];

//超过2S
always @(posedge sys_clk or negedge rstn) begin 
    if(!rstn) begin
        no_external <= 'd0;
		no_external_time <= 'd0;
    end
    else if(trig_mode_sel == `EXT_TRIG) begin
        if(no_external_time < 'd100000000) begin
            if(ext_trigger == 1'b1) begin 
              no_external <= 'd0;
              no_external_time <= 1'b0;
            end
            else no_external_time <= no_external_time +1'b1;
        end
        else begin
           no_external <= 1'b1;
           no_external_time <= 'd0;
        end
	end
	else  begin
        no_external <= 'd0;
		no_external_time <= 'd0;
    end
end	
	
//reg ext_trigger_flag;
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
		ext_trigger <= 1'b0;
	end
	else if(trig_mode_sel == `EXT_TRIG) begin
		if(shift_reg[0] <= `EXT_TH) begin
			if(ext_trigger == 1'b0) begin//rising edge
				if(shift_reg[0]<=shift_reg[1] && shift_reg[1]<=shift_reg[2] && shift_reg[2]<=shift_reg[3]) begin
					ext_trigger <= 1'b1;
				end
				else ext_trigger <= ext_trigger;
			end 
			else ext_trigger <= ext_trigger;
		end
		else begin
			if(ext_trigger == 1'b1) begin//rising edge
				if(shift_reg[0]>=shift_reg[1] && shift_reg[1]>=shift_reg[2] && shift_reg[2]>=shift_reg[3]) begin
					ext_trigger <= 1'b0;
				end
				else ext_trigger <= ext_trigger;				
			end		
			else ext_trigger <= ext_trigger;
		end
	end
	else ext_trigger <= 1'b0;
end	
	
	
	
	
	
	
	
	
	
	
	
endmodule
