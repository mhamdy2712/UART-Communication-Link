`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2023 11:14:09 PM
// Design Name: 
// Module Name: UART_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_tb(

    );
    parameter data_size=8,clk_cycle=10;
    reg clk=0,reset_n,rd_uart,wr_uart;
    wire tx_full,rx_empty;
    wire [data_size-1:0] r_data;
    reg [data_size-1:0] w_data;
    always begin
    clk=0;
    #(0.5*clk_cycle);
    clk=1;
    #(0.5*clk_cycle);
    end
    UART my_uart (
    .clk(clk),
    .reset_n(reset_n),
    .rd_uart(rd_uart),
    .wr_uart(wr_uart),
    .tx_full(tx_full),
    .rx_empty(rx_empty),
    .r_data(r_data),
    .w_data(w_data)
    );
    initial begin
        reset_n=0;
        #(clk_cycle);
        reset_n=1;
        #(clk_cycle);
        w_data = 200;
        wr_uart=1;
        #(clk_cycle);
        w_data = 'h30;
        #(clk_cycle);
        w_data = 'hc7;
        #(clk_cycle);
        w_data='hb3;
        #(clk_cycle);
        wr_uart=0;
        #(4500*1000);
        #(5);
        rd_uart=1;
        #(clk_cycle);
        rd_uart=0;
        #(10*clk_cycle);
        rd_uart=1;
        #(clk_cycle);
        rd_uart=0;
        #(10*clk_cycle);
        rd_uart=1;
        #(clk_cycle);
        rd_uart=0;
        #(10*clk_cycle);
        rd_uart=1;
        #(clk_cycle);
        rd_uart=0;
    end
endmodule
