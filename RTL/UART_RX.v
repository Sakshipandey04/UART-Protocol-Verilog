`timescale 1ns / 1ps

module uart_rx (
    input  wire       clk,       // 100 MHz clock
    input  wire       rst,       // active-high reset
    input  wire       rx,        // UART RX line
    output reg [7:0]  rx_data,   // received byte
    output reg        rx_done    // pulses HIGH when byte received
);

    // --------------------------------------------------
    // Fixed baud timing
    // --------------------------------------------------
    localparam integer BAUD_COUNT      = 10416;
    localparam integer HALF_BAUD_COUNT = 5208;

    // --------------------------------------------------
    // FSM states
    // --------------------------------------------------
    localparam IDLE  = 3'b000;
    localparam START = 3'b001;
    localparam DATA  = 3'b010;
    localparam STOP  = 3'b011;
    localparam DONE  = 3'b100;

    reg [2:0] state;

    // --------------------------------------------------
    // Registers
    // --------------------------------------------------
    reg [13:0] baud_cnt;
    reg [2:0]  bit_cnt;
    reg [7:0]  shift_reg;

    // --------------------------------------------------
    // UART RX FSM
    // --------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            baud_cnt  <= 14'd0;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            rx_data   <= 8'd0;
            rx_done   <= 1'b0;
        end
        else begin
            rx_done <= 1'b0;  // default

            case (state)

                // ---------------- IDLE ----------------
                IDLE: begin
                    baud_cnt <= 14'd0;
                    bit_cnt  <= 3'd0;

                    if (rx == 1'b0) begin  // detect start bit
                        state <= START;
                    end
                end

                // ---------------- START ----------------
                START: begin
                    if (baud_cnt == HALF_BAUD_COUNT - 1) begin
                        baud_cnt <= 14'd0;
                        if (rx == 1'b0) begin
                            state <= DATA; // valid start bit
                        end
                        else begin
                            state <= IDLE; // false start
                        end
                    end
                    else begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end
                end

                // ---------------- DATA ----------------
             
              DATA: begin
              if (baud_cnt == BAUD_COUNT - 1) begin
                  baud_cnt <= 14'd0;

               // store bit directly by index (LSB first)
               shift_reg[bit_cnt] <= rx;

              if (bit_cnt == 3'd7) begin
                  bit_cnt <= 3'd0;
                  state <= STOP;
                 end
             else begin
                bit_cnt <= bit_cnt + 1'b1;
             end
          end
        else begin
            baud_cnt <= baud_cnt + 1'b1;
        end
      end


                // ---------------- STOP ----------------
                STOP: begin
                    if (baud_cnt == BAUD_COUNT - 1) begin
                        baud_cnt <= 14'd0;
                        if (rx == 1'b1) begin
                            rx_data <= shift_reg;
                            state <= DONE;
                        end
                        else begin
                            state <= IDLE; // framing error (ignored)
                        end
                    end
                    else begin
                        baud_cnt <= baud_cnt + 1'b1;
                    end
                end

                // ---------------- DONE ----------------
                DONE: begin
                    rx_done <= 1'b1; // 1-clock pulse
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
