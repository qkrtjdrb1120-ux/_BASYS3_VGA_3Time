`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2025 03:32:10 PM
// Design Name: 
// Module Name: controller
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


module FND_cntr(
    input clk, reset_p,
    input [15:0] fnd_value,
    output [7:0] seg,
    output reg [3:0] com);
    
    reg [16:0] clk_div;
    always @(posedge clk)clk_div = clk_div + 1;
    
    wire clk_div_ed;
    edge_detector_n ed_com(.clk(clk), .reset_p(reset_p),
                    .cp(clk_div[16]), .p_edge(clk_div_ed));
    
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)com = 4'b1110;
        else if(clk_div_ed)begin
            if(com[0] + com[1] + com[2] + com[3] != 3) com = 4'b1110;
            else com = {com[2:0], com[3]};
        end
    end
    reg [3:0] digit_value;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)digit_value = 0;
        else begin
            case(com)
                4'b1110: digit_value = fnd_value[3:0];
                4'b1101: digit_value = fnd_value[7:4];
                4'b1011: digit_value = fnd_value[11:8];
                4'b0111: digit_value = fnd_value[15:12];
            endcase
        end
    end
    seg_decoder dec(.hex_value(digit_value), .seg(seg));
    
endmodule

module button_cntr(
    input clk, reset_p, btn,
    output btn_pedge, btn_nedge);
    
    reg [15:0] cnt_sysclk;
    reg debounced_btn;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk = 0;
            debounced_btn = 0;
        end
        else begin
            if(cnt_sysclk[15])begin
                debounced_btn = btn;
                cnt_sysclk = 0;
            end
            else cnt_sysclk = cnt_sysclk + 1;
        end
    end
    
    edge_detector_n ed(.clk(clk), .reset_p(reset_p),
                       .cp(debounced_btn), .p_edge(btn_pedge), .n_edge(btn_nedge));
endmodule















