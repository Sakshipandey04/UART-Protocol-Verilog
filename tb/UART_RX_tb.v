`timescale 1ns / 1ps

module uart_rx_tb;

    reg        clk;
    reg        rst;
    reg        rx;
    wire [7:0] rx_data;
    wire       rx_done;

    uart_rx dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // -----------------------------------------
    // Clock-based bit timing
    // -----------------------------------------
    localparam integer BIT_CYCLES = 10416;

    task wait_bit_time;
        integer i;
        begin
            for (i = 0; i < BIT_CYCLES; i = i + 1)
                @(posedge clk);
        end
    endtask

    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            // Start bit
            rx = 1'b0;
            wait_bit_time();

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                wait_bit_time();
            end

            // Stop bit
            rx = 1'b1;
            wait_bit_time();
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        rx  = 1'b1;

        #100;
        rst = 0;

        #200;

        send_uart_byte(8'h55);
        wait (rx_done);

        #20000;

        send_uart_byte(8'hA3);
        wait (rx_done);

        #20000;
        $stop;
    end

endmodule
