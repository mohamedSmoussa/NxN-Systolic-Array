module systolic_array_tb ();
parameter DATAWIDTH = 16;
parameter N_SIZE = 5;
reg clk,rst_n,valid_in;
reg [N_SIZE*DATAWIDTH-1:0] matrix_a_in,matrix_b_in;
wire [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out;
wire valid_out;
systolic_array #(.DATAWIDTH(DATAWIDTH),.N_SIZE(N_SIZE)) DUT(clk,rst_n,valid_in,matrix_a_in,matrix_b_in,valid_out,matrix_c_out);
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
initial begin
    rst_n=0;
    valid_in=1;
    @(negedge clk);// all regs and counters  should be zero 
    rst_n=1;
        matrix_a_in = 80'h0029000300220006000c; 
        matrix_b_in = 80'h000d0009000600110004; 
        @(negedge clk);
        matrix_a_in = 80'h000500140008002d0007; 
        matrix_b_in = 80'h00030001003000000002; 
        @(negedge clk);
        matrix_a_in = 80'h000c0011001300000003; 
        matrix_b_in = 80'h000000060007000a0005; 
        @(negedge clk);
        matrix_a_in = 80'h00000021000100020019;
        matrix_b_in = 80'h000800160002000b0000;
        @(negedge clk);
        matrix_a_in = 80'h000600160004000b0009;
        matrix_b_in = 80'h002c00050003000e0001;
        @(negedge clk);

    valid_in=0;
    repeat(9) @(negedge clk);  /// last row in 3N-2  so after 5 cycles we must wait 8 but i will wait 9 to stablize output 
    $stop;
end

endmodule //systolic_array_tb