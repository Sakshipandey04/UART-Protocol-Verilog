`timescale 1ns / 1ps

module tb_uart_top;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;                 // matches uart_top port
    wire [7:0] rx_data;
    wire rx_done;

    // --------------------------------
    // Instantiate TOP module
    // --------------------------------
    uart_top uut (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),       
        .rx_data  (rx_data),
        .rx_done  (rx_done)
    );

    // --------------------------------
    // Clock generation: 100 MHz
    // --------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns period
    end

    // --------------------------------
    // Test sequence
    // --------------------------------
    initial begin
        $display("----- UART TOP LOOPBACK SIMULATION START -----");

        // Initial values
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;

        // Reset duration
        #100_000;
        rst = 0;
        $display("[%0t ns] Reset deasserted", $time);

        // Wait before transmission
        #200_000;

        // Send data 0x55
        tx_data = 8'h55;
        tx_start = 1;
        $display("[%0t ns] Sending byte 0x55", $time);
        #10;
        tx_start = 0;

        // Wait for RX done pulse
        @(posedge rx_done);
        $display("[%0t ns] RX DONE! Data received = 0x%02h", $time, rx_data);

        // Keep simulation alive
        #5_000_000;
        $display("----- UART TOP LOOPBACK SIMULATION END -----");
        $finish;
    end

endmodule
