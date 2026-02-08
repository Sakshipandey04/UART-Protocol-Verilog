`timescale 1ns / 1ps

module uart_top (
    input  wire clk,
    input  wire rst,
    input  wire tx_start,
    input  wire [7:0] tx_data,

    output wire tx,          // UART TX line
    output wire [7:0] rx_data,
    output wire rx_done
);

    wire uart_line;

    // UART TRANSMITTER
    uart_tx tx_inst (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (uart_line),
        .tx_busy  ()
    );

    // UART RECEIVER
    uart_rx rx_inst (
        .clk     (clk),
        .rst     (rst),
        .rx      (uart_line),
        .rx_data (rx_data),
        .rx_done (rx_done)
    );

    assign tx = uart_line;

endmodule
