`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2023 10:47:14 PM
// Design Name: 
// Module Name: UART
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


module UART
    #(parameter data_size=8,fifo_depth=1024)(
    input clk,reset_n,
    input rd_uart,wr_uart,
    input [data_size-1:0] w_data,
    output rx_empty,
    output [data_size-1:0] r_data,
    output tx_full
    );
    wire [data_size-1:0] rx_dout,tx_din;
    wire rx_done_tick;
    wire tx_done_tick;
    wire tx_empty;
    //wire final_value = 650;
    wire s_tick;
    wire data;
    FIFO #(.data_size(data_size),.depth(fifo_depth)) rx_fifo (
    .clk(clk),      // input wire clk
    .srst(~reset_n),    // input wire srst
    .din(rx_dout),      // input wire [7 : 0] din
    .wr_en(rx_done_tick),  // input wire wr_en
    .rd_en(rd_uart),  // input wire rd_en
    .dout(r_data),    // output wire [7 : 0] dout
    .empty(rx_empty)  // output wire empty
    );
    FIFO #(.data_size(data_size),.depth(fifo_depth)) tx_fifo (
    .clk(clk),      // input wire clk
    .srst(~reset_n),    // input wire srst
    .din(w_data),      // input wire [7 : 0] din
    .wr_en(wr_uart),  // input wire wr_en
    .rd_en(tx_done_tick),  // input wire rd_en
    .dout(tx_din),    // output wire [7 : 0] dout
    .full(tx_full),    // output wire full
    .empty(tx_empty)  // output wire empty
    );
    Baud_rate_generator #(.N(10)) brg (
    .clk(clk),
    .reset_n(reset_n),
    //.final_value(final_value),
    .done(s_tick)
    );
    UART_Transmitter #(.data_size(data_size)) Transmitter (
    .clk(clk),
    .reset_n(reset_n),
    .tx(data),
    .tx_din(tx_din),
    .tx_start(~tx_empty),
    .s_tick(s_tick),
    .tx_done_tick(tx_done_tick)    
    );
    UART_Receiver #(.data_size(data_size)) Receiver (
    .clk(clk),
    .reset_n(reset_n),
    .rx(data),
    .rx_dout(rx_dout),
    .s_tick(s_tick),
    .rx_done_tick(rx_done_tick)    
    );
endmodule
