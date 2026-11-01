`timescale 1ns / 1ps

module tb_spi_master;

    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] clk_div_val;
    reg [11:0] tx_data;
    reg miso;

    wire mosi;
    wire cs_n;
    wire sclk;
    wire [11:0] rx_data;
    wire done;

    top_level uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .clk_div_val(clk_div_val),
        .tx_data(tx_data),
        .miso(miso),
        .mosi(mosi),
        .cs_n(cs_n),
        .sclk(sclk),
        .rx_data(rx_data),
        .done(done)
    );

    always #5 clk = ~clk;

    reg [11:0] slave_data;
    integer i;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        clk_div_val = 16'd2;
        tx_data = 12'h000;
        miso = 1'b0;
        slave_data = 12'hA5A;

        #25;
        rst_n = 1'b1;
        #25;

        tx_data = 12'hC3C;
        start = 1'b1;
        
        #10;
        start = 1'b0;

        @(negedge cs_n);

        for (i = 0; i < 12; i = i + 1) begin
            miso = slave_data[i];
            @(negedge sclk);
        end

        @(posedge done);
        
        #100;
        $finish;
    end

endmodule