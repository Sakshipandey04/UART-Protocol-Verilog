
`timescale 1ns / 1ps

// Create Date: 07.02.2026 18:40:19
//Author: Sakshi Pandey
// Module Name: UART_tx_tb


module uart_tx_tb();
   reg clk;
   reg rst;
   reg tx_start;
   reg [7:0] tx_data;
   wire tx;
   wire tx_busy;
   
   uart_tx dut(
     .clk(clk),
     .rst(rst),
     .tx_start(tx_start),
     .tx_data(tx_data),
     .tx(tx),
     .tx_busy(tx_busy)
     );
     //Clock generation---100 MHz
     
     always #5 clk= ~clk;
     initial begin
         clk=0;
         rst=1;
         tx_start =0;
         tx_data= 8'h00;
         
         // hold reset
         #100; 
         rst=0;
         
         //wait
         #200;
         // send test byte 0x55
         tx_data = 8'h55;
         tx_start=1;
         #10;
         tx_start =0;
         //wait for transmission to complete
         wait(tx_busy ==0)
        
         //finish
         #100000;
         $stop;
      end
     
  
   
endmodule
