module systolic_array #(
parameter DATAWIDTH = 16,
parameter N_SIZE = 5)(
input clk,rst_n,valid_in,
input [N_SIZE*DATAWIDTH-1:0] matrix_a_in,matrix_b_in,
output reg valid_out,
output reg [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out
);

reg [N_SIZE] clk_cycles;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clk_cycles <= 0;
    end
    else clk_cycles <= clk_cycles + 1;
end
wire [DATAWIDTH-1:0] a_reg[0:N_SIZE-1];
wire [DATAWIDTH-1:0] b_reg[0:N_SIZE-1];
assign a_reg[0]= (valid_in || clk_cycles == N_SIZE-1) ? matrix_a_in[DATAWIDTH-1 : 0] : {DATAWIDTH{1'b0}};
assign b_reg[0]= (valid_in || clk_cycles == N_SIZE-1) ? matrix_b_in[DATAWIDTH-1 : 0] : {DATAWIDTH{1'b0}};

genvar i, j;
generate
    for (i = 1; i < N_SIZE; i = i + 1) begin 
        wire [DATAWIDTH-1:0] a_input = (valid_in || clk_cycles == N_SIZE-1) ? matrix_a_in[(i+1)*DATAWIDTH-1 -: DATAWIDTH] : {DATAWIDTH{1'b0}};
        REG #(.DATAWIDTH(DATAWIDTH), .DELAY_STAGES(i)) A(
            clk,
            rst_n,
            a_input,
            a_reg[i]
        );
    end
    for (j = 1; j < N_SIZE; j = j + 1) begin
        wire [DATAWIDTH-1:0] b_input = (valid_in || clk_cycles == N_SIZE-1) ? matrix_b_in[(j+1)*DATAWIDTH-1 -: DATAWIDTH] : {DATAWIDTH{1'b0}};
        REG #(.DATAWIDTH(DATAWIDTH), .DELAY_STAGES(j)) B(
            clk,
            rst_n,
            b_input,
            b_reg[j]
        );
    end
endgenerate
wire   [2*DATAWIDTH-1:0] matrix_elments [0:N_SIZE-1][0:N_SIZE-1];
wire   [DATAWIDTH-1:0] a_delayed     [0:N_SIZE-1][0:N_SIZE-1];
wire   [DATAWIDTH-1:0] b_delayed      [0:N_SIZE-1][0:N_SIZE-1];
generate
    for (i = 0; i < N_SIZE; i = i + 1) begin 
    for (j = 0; j < N_SIZE; j = j + 1) begin 
 PE #(.data_size(DATAWIDTH)) pe(clk,rst_n,(j == 0) ? a_reg[i] : a_delayed[i][j-1] ,(i == 0) ? b_reg[j] : b_delayed[i-1][j]
    , matrix_elments[i][j], a_delayed[i][j],b_delayed[i][j]);
        end
    end
endgenerate
integer r;
always @(*) begin
    if (clk_cycles >= 2*N_SIZE - 1 && clk_cycles <= 3*N_SIZE - 2) begin
        valid_out = 1'b1;
        for (r = 0; r < N_SIZE; r = r + 1) begin
        matrix_c_out[(N_SIZE - r)*2*DATAWIDTH -1 -: 2*DATAWIDTH] = 
        matrix_elments[clk_cycles - (2*N_SIZE - 1)][r];
       end
        end
        else begin
        matrix_c_out = 'b0;
        valid_out = 1'b0;
    end
end

endmodule

module REG #(parameter DATAWIDTH = 16,DELAY_STAGES = 1) (
    input clk,
    input wire rst_n,
    input wire [DATAWIDTH-1:0] d,
    output wire [DATAWIDTH-1:0] q
);
    reg [DATAWIDTH-1:0] register [0:DELAY_STAGES-1];
    integer i;
     assign q = register[DELAY_STAGES - 1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <DELAY_STAGES; i = i + 1)
                register[i] <= '0;
        end else begin
            register[0] <= d;
            for (i = 1; i <DELAY_STAGES; i = i + 1)
                register[i] <= register[i - 1];
        end
    end
   
endmodule
 module PE#(parameter data_size=16)(
 input wire clk,rst_n,
 input wire [data_size-1:0] left_in,top_in,
 output reg [2*data_size-1:0] accumualtor,
 output reg [data_size-1:0] right_out,down_out
 );
 always @(posedge clk or negedge rst_n)begin
 if(!rst_n) begin
 right_out <= 0;
 down_out <= 0;
 accumualtor <= 0;
 end else begin
 accumualtor <= accumualtor + left_in*top_in;
 right_out <=left_in;
 down_out <=top_in;
 end
 end
 endmodule