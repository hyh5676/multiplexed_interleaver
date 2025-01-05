`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/31 11:16:17
// Design Name: 
// Module Name: tb_multiplexed_interleaver
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


module tb_multiplexed_interleaver(

    );
reg clk,reset,data_valid;
reg [7:0] data_in;    
reg [11:0] length;

wire [7:0]data_out;
wire data_out_valid;    

integer i;




initial begin
    reset=1;
    clk=0;
    i=0;
    length=904;
    #20;
    reset=0;
    data_valid=1;
    #40000
    if(data_out_valid==0)begin
        length=920;
    end
    #40000
    if(data_out_valid==0)begin
        length=1848;
    end
    #80000
    if(data_out_valid==0)begin
       length=2712;
    end
end

always begin 
    #10
    clk=~clk;
    i=i+1;
    data_in=i;
end










multiplexed_interleaver multiplexed_interleaver(
.clk(clk),
.reset(reset),
.data_valid(data_valid),
.data_in(data_in),
.length(length),

.data_out(data_out),
.data_out_valid(data_out_valid)
);
endmodule
