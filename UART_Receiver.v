`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2023 08:10:12 PM
// Design Name: 
// Module Name: UART_Receiver
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
/////////////////////////////////////////////////////////////////////////////////


module UART_Receiver
    #(parameter data_size=8) (
    input rx,
    input s_tick,
    input clk, reset_n,
    output [data_size-1:0] rx_dout,
    output reg rx_done_tick
    );
    reg [3:0] ticksn,ticksn_next;
    reg [data_size-1:0] cdata ,cdata_next, datan,datan_next;
    reg [1:0] curr_state,next_state;
    localparam idle=0, start=1 ,data=2 ,stop=3;
    always @(posedge clk, negedge reset_n) 
    begin
        if(~reset_n)
        begin
            curr_state <= idle;
            cdata <= 0;
            datan <= 0;
            ticksn <= 0;
        end
        else begin
            curr_state <= next_state;
            ticksn <= ticksn_next;
            datan <= datan_next;
            cdata <= cdata_next;

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
                rx_done_tick = 0;
                ticksn_next=0;
                cdata_next = cdata;
                datan_next = 0;
                if(rx==0)
                    next_state=start;
                else
                    next_state=idle;
            end
            start:
            begin
                cdata_next = 0;
                datan_next = 0;
                if(ticksn==7&&s_tick)
                    next_state=data;
                else
                    next_state= start;
            end
            data:
            begin
                if(ticksn==7&&s_tick)
                begin
                    cdata_next = cdata;
                    cdata_next[datan] = rx;
                    datan_next=datan+1;
                    next_state = datan_next==data_size ? stop : data;
                end
                else begin
                    datan_next = datan;
                    cdata_next = cdata;
                    next_state = data;
                end
            end
            stop:
            begin
                cdata_next = cdata;
                datan_next = 0;
                if(ticksn==7&&s_tick) begin
                    next_state=idle;
                    rx_done_tick = 1;
                end
                else begin
                    next_state=stop;
                    rx_done_tick = 0;
                end
            end

        endcase
    end
    assign rx_dout = cdata;
endmodule
