`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2023 09:08:12 PM
// Design Name: 
// Module Name: UART_Transmitter
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


module UART_Transmitter
    #(parameter data_size=8)(
    input [data_size:0] tx_din,
    input tx_start,
    input clk,
    input s_tick,
    input reset_n,
    output reg tx,
    output reg tx_done_tick
    );
    reg [3:0] ticksn,ticksn_next;
    reg [data_size-1:0] datan,datan_next;
    reg [1:0] curr_state,next_state;
    localparam idle=0, start=1 ,data=2 ,stop=3;
    always @(posedge clk, negedge reset_n) 
    begin
        if(~reset_n)
        begin
            curr_state <= idle;
            datan <= 0;
            tx <= 1;
            ticksn <= 0;
        end
        else begin
            curr_state <= next_state;
            ticksn <= ticksn_next;
            datan <= datan_next;
        end
    end
    always @(*)
    begin
    if(s_tick)
        if(ticksn!=15)
            ticksn_next = ticksn+1;
        else
            ticksn_next = 0;
    else
        ticksn_next = ticksn;
        case(curr_state)
            idle:
            begin
                tx_done_tick = 0;
                datan_next=0;
                ticksn_next=0;
                tx = 1;
                if(tx_start==1)
                    next_state=start;
                else
                    next_state=idle;
            end
            start:
            begin
                datan_next=0;
                tx=0;
                if(ticksn==15&&s_tick) begin
                    next_state=data;
                end
                else
                    next_state= start;
            end
            data:
            begin
                tx = tx_din[datan];
                if(ticksn==15&&s_tick)
                begin
                    datan_next =datan+1;
                    next_state = datan_next==data_size ? stop : data;
                end
                else begin
                    next_state = data;
                    datan_next = datan;
                end                   
            end
            stop:
            begin
                tx=1;
                datan_next=0;
                if(ticksn==15&&s_tick) begin
                    next_state=idle;
                    tx_done_tick = 1;
                end
                else begin
                    next_state=stop;
                    tx_done_tick = 0;
                end
            end
        endcase
    end    
endmodule
