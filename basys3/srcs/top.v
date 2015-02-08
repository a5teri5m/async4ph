
`default_nettype none
module top (
    input  wire       clk,
    input  wire       reset,
    input  wire [3:0] flashair_data,
    output wire       flashair_ack,
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an
);

    wire clk_100MHz;
    wire [15:0] value;
    wire [1:0] fifo_data;
    wire fifo_en;
  

    clk_wiz_100MHz u_clk_wiz_100MHz (
        .clk_in1(clk),
        .clk_out1(clk_100MHz),
        .reset(reset)
    );     


    seg7 u_seg7 (
        .clk(clk_100MHz),
        .reset(reset),
        .value(value),
        .seg(seg),
        .dp(dp),
        .an(an)
    );
    

    async u_async (
        .clk(clk_100MHz),
        .reset(reset),
        .async_data(flashair_data),
        .async_ack(flashair_ack),
        .sync_data(fifo_data),
        .sync_en(fifo_en)
    );


    fifo u_fifo (
        .clk(clk_100MHz),
        .reset(reset),
        .i_data(fifo_data),
        .en(fifo_en),
        .o_data(value)
    );

endmodule
`default_nettype wire

