`timescale 1ns / 1ps
module top_level (
    input clk,
    input rst_n,
    input start,
    input [15:0] clk_div_val,
    input [11:0] tx_data,
    input miso,
    
    output mosi,
    output cs_n,
    output sclk,
    output [11:0] rx_data,
    output done
);

    wire sclk_rise;
    wire sclk_fall;
    wire spi_active;

    clk_divider clk_div_inst (
        .clk(clk),
        .rst_n(rst_n),
        .en(spi_active),
        .clk_div_val(clk_div_val),
        .sclk(sclk),
        .sclk_rise(sclk_rise),
        .sclk_fall(sclk_fall)
    );

    spi_master spi_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_data(tx_data),
        .sclk_rise(sclk_rise),
        .sclk_fall(sclk_fall),
        .miso(miso),
        .mosi(mosi),
        .cs_n(cs_n),
        .rx_data(rx_data),
        .done(done),
        .spi_active(spi_active)
    );

endmodule


