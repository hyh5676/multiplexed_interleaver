module multiplexed_interleaver (
    input clk,               // ʱ���ź�
    input reset,             // �����ź�
    input [7:0] data_in,     // ����8λ����
    input data_valid,        // ����������Ч�ź�
    input [11:0]length,
    output reg [7:0] data_out, // �����֯�������
    output reg data_out_valid // ���������Ч�ź�
);
    // ���彻֯���ĳߴ�
    wire [11:0] ReadRow;
    wire [11:0] ReadCol;
  
    assign ReadRow = length/8;
    assign ReadCol = 4'h8;
    
    // �洢��֯�����ڴ�����
    reg [7:0] interleaver_mem [0:2712-1];
    
    // ��дָ�룬����֯����
    reg [11:0] write_ptr;  // дָ��
    reg [11:0] read_ptr;   // ��ָ��
    reg [11:0] read_count,read_count_row;
    

    // �źţ��Ƿ�����
    reg buffer_full;

    // ���������Ч�ź�
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
            // д�����ݵ���֯���洢��
            interleaver_mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            data_out_valid <= 0;
            // ����Ƿ�������꽻֯��
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
            // �ڶ�ȡ�����ݺ����ý�֯��
            if (read_ptr == length - 1) begin
                buffer_full <= 0;
                read_ptr <= 0; 
                read_count_row<=0;
            end
        end 
    end


    

endmodule
