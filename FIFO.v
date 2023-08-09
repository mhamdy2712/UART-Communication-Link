`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2023 01:58:19 PM
// Design Name: 
// Module Name: FIFO
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


module FIFO
    #(parameter data_size=8,depth=1024)(
    input clk,
    input srst,
    input [data_size-1:0] din,
    input wr_en,
    input rd_en,
    output [data_size-1:0] dout,
    output full,
    output empty
    );
    localparam sizee = $clog2(depth);
    integer k;
    reg [sizee:0] wr,wr_next,rd,rd_next;
    reg [data_size-1:0] fifo [0:depth-1];
    reg emptyreg,fullreg;
    always @(posedge clk)
    begin
        if(wr_en&&~fullreg) begin 
            fifo[wr] <= din;
            wr <= wr_next;
            emptyreg<=0;
            if(wr_next == rd)
                fullreg <= 1;
        end
        if(rd_en && ~emptyreg) begin
            rd <= rd_next;
            fullreg <=0;
            if(wr == rd_next)
                emptyreg<=1;
        end
    end
    always @(posedge srst) begin
            wr <= 0;
            rd <= 0;
            fullreg <= 0;
            emptyreg <=1;
    end
    always @(*)
    begin
        rd_next = rd;
        wr_next = wr;
        if(wr_en&&~fullreg) begin
            wr_next = wr+1;
            if(wr == depth-1)
                wr_next = 0;
        end
        if(rd_en && ~emptyreg) begin
            rd_next = rd+1;
            if(rd == depth-1) 
                rd_next = 0;
        end
    end
    assign dout = emptyreg ? 'b0:fifo[rd];
    assign empty = emptyreg;
    assign full = fullreg;
endmodule
