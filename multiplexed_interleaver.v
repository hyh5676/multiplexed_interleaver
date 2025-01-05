module multiplexed_interleaver (
    input clk,               // 时钟信号
    input reset,             // 重置信号
    input [7:0] data_in,     // 输入8位数据
    input data_valid,        // 输入数据有效信号
    input [11:0]length,
    output reg [7:0] data_out, // 输出交织后的数据
    output reg data_out_valid // 输出数据有效信号
);
    // 定义交织器的尺寸
    wire [11:0] ReadRow;
    wire [11:0] ReadCol;
  
    assign ReadRow = length/8;
    assign ReadCol = 4'h8;
    
    // 存储交织器的内存数组
    reg [7:0] interleaver_mem [0:2712-1];
    
    // 读写指针，负责交织操作
    reg [11:0] write_ptr;  // 写指针
    reg [11:0] read_ptr;   // 读指针
    reg [11:0] read_count,read_count_row;
    

    // 信号：是否已满
    reg buffer_full;

    // 控制输出有效信号
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_ptr <= 12'b0;
            read_ptr <= 12'b0;
            buffer_full <= 0;
            data_out_valid <= 0;
            data_out <= 8'b0;
            data_out_valid <= 0;
            read_count<=12'b0;
            read_count_row<=12'h001;
            
        end else if (data_valid && !buffer_full) begin
            // 写入数据到交织器存储器
            interleaver_mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            data_out_valid <= 0;
            // 检查是否已填充完交织器
            if (write_ptr == length - 1) begin
                buffer_full <= 1;
                write_ptr<=12'b0;
            end
        end else if (buffer_full) begin
            if(read_count==ReadRow-1) begin
                read_ptr<=read_count_row;
                read_count_row<=read_count_row+1;
                read_count<=0;
                data_out <= interleaver_mem[read_ptr];
            end else begin
                data_out <= interleaver_mem[read_ptr];
                data_out_valid <= 1;
                read_ptr <= read_ptr + ReadCol;
                read_count<=read_count+1;
            end
            // 在读取完数据后，重置交织器
            if (read_ptr == length - 1) begin
                buffer_full <= 0;
                read_ptr <= 0; 
                read_count_row<=0;
            end
        end 
    end


    

endmodule
