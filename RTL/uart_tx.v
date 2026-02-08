`timescale 1ns / 1ps
 
// Create Date: 07.02.2026 18:39:31
//Author: Sakshi Pandey
// Module Name: UART_tx


module uart_tx(
    input wire clk, //100 MHz clock
    input wire rst,  //active high reset
    input wire tx_start,   //start transmission 
    input wire [7:0] tx_data, // byte to transmit
    output reg tx,        // UART TX line
    output reg tx_busy   // high while transmitting
    );
    
    localparam integer BAUD_COUNT = 10416; // 100 MHz /9600/ baud rare
    
    //FSM States
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg [1:0] state;
    
    //Registers
    
    reg [13:0] baud_cnt; // count up to 10416
    reg [2:0] bit_cnt;  // count 0 to 7
    reg [7:0] shift_reg; //shift data
     
     // UART Tx FSM
     
     always@(posedge clk or posedge rst) begin
     if(rst) begin
        state <= IDLE;
        tx  <= 1'b1; //UART idle state is high
        tx_busy <= 1'b0;
        baud_cnt <= 14'd0;
        bit_cnt <= 3'd0;
        shift_reg <= 8'd0;
     end
     else begin
        case(state)
            // IDLE-----
            IDLE: begin
               tx <= 1'b1;
               tx_busy <= 1'b0;
               baud_cnt <= 14'd0;
               bit_cnt <= 3'd0;
               
               if(tx_start) begin
               shift_reg <= tx_data;
               tx_busy <= 1'b1;
               state <= START;
               end
           end
          
          //START----
            START: begin
            tx<= 1'b0; //start bit
            if(baud_cnt == BAUD_COUNT -1) begin
               baud_cnt <= 14'd0;
               state <= DATA;
             end
             else begin
                baud_cnt <= baud_cnt + 1'b1;
             end
           end
           
      //DATA---
           DATA: begin
           tx <= shift_reg[0]; //LSB first
           if(baud_cnt == BAUD_COUNT -1) begin
             baud_cnt <= 14'd0;
             shift_reg <= shift_reg >> 1;
           
              if(bit_cnt == 3'd7)begin
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
         //STOP ----
         STOP: begin
           tx<= 1'b1; // stop bit
           if(baud_cnt == BAUD_COUNT -1) begin
               baud_cnt <= 14'd0;
               state <= IDLE;
             end
           else begin
               baud_cnt <= baud_cnt + 1'b1;
            end
          end
        default : state <= IDLE;
        
      endcase
    end
  end
        
           
                     
endmodule
