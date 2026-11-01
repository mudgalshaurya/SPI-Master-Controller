`timescale 1ns / 1ps
module clk_divider (
    input clk,
    input rst_n,
    input en,
    input [15:0] clk_div_val,
    
    output reg sclk,
    output reg sclk_rise,
    output reg sclk_fall
);

    reg [15:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 16'd0;
            sclk <= 1'b0;
            sclk_rise <= 1'b0;
            sclk_fall <= 1'b0;
        end else if (en) begin
            sclk_rise <= 1'b0;
            sclk_fall <= 1'b0;
            
            if (counter == clk_div_val) begin
                counter <= 16'd0;
                sclk <= ~sclk;
                
                if (~sclk) begin
                    sclk_rise <= 1'b1;
                end else begin
                    sclk_fall <= 1'b1;
                end
            end else begin
                counter <= counter + 1'd1;
            end
        end else begin
            counter <= 16'd0;
            sclk <= 1'b0;
            sclk_rise <= 1'b0;
            sclk_fall <= 1'b0;
        end
    end

endmodule
