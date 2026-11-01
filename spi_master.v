`timescale 1ns / 1ps
module spi_master (
    input clk,
    input rst_n,
    input start,
    input [11:0] tx_data,
    input sclk_rise,
    input sclk_fall,
    input miso,
    
    output reg mosi,
    output reg cs_n,
    output reg [11:0] rx_data,
    output reg done,
    output reg spi_active
);

    localparam IDLE     = 2'b00;
    localparam START    = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [3:0] bit_cnt;
    reg [11:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        spi_active = 1'b0;

        case (state)
            IDLE: begin
                if (start) begin
                    next_state = START;
                end
            end
            START: begin
                spi_active = 1'b1;
                if (sclk_fall) begin
                    next_state = TRANSFER;
                end
            end
            TRANSFER: begin
                spi_active = 1'b1;
                if (bit_cnt == 4'd12) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cs_n <= 1'b1;
            mosi <= 1'b0;
            done <= 1'b0;
            bit_cnt <= 4'd0;
            shift_reg <= 12'd0;
            rx_data <= 12'd0;
        end else begin
            case (state)
                IDLE: begin
                    cs_n <= 1'b1;
                    done <= 1'b0;
                    bit_cnt <= 4'd0;
                    if (start) begin
                        shift_reg <= tx_data;
                    end
                end
                
                START: begin
                    cs_n <= 1'b0;
                    if (sclk_fall) begin
                        mosi <= shift_reg[0];
                    end
                end
                
                TRANSFER: begin
                    cs_n <= 1'b0;
                    if (sclk_rise) begin
                        shift_reg <= {miso, shift_reg[11:1]};
                        bit_cnt <= bit_cnt + 1;
                    end else if (sclk_fall) begin
                        if (bit_cnt < 4'd12) begin
                            mosi <= shift_reg[0];
                        end
                    end
                end
                
                DONE: begin
                    cs_n <= 1'b1;
                    done <= 1'b1;
                    rx_data <= shift_reg;
                end
            endcase
        end
    end

endmodule