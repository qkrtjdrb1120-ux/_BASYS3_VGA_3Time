`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 02:06:41 PM
// Design Name: 
// Module Name: exam02_sequential_logic
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


module retch_nor(
    input R, S, 
    output Q, Qbar);
    
    nor (Q, R, Qbar);
    nor (Qbar, S, Q);
    
endmodule

////////////////////////////////////////////////////////


//module D_flip_flop_n(
//    input d,
//    input clk, 
//    output reg q 
//);

//    always @(negedge clk)begin
//        q = d;
//    end
    
//endmodule

////////////////////////////////////////////////////////

module D_flip_flop_n(
    input d,
    input clk, reset_p, en, 
    output reg q);
    //클락은 하락엣지에서 동작
    always @(negedge clk, posedge reset_p)begin //상승엣지에서 동작 함으로else 괜찮음 엣지 에서 동작 트리거를 넣어서 괜찮음
        if(reset_p)q = 0;
        else if(en)q = d;
    end
    
endmodule


module D_flip_flop_p(
    input d,
    input clk, reset_p, en, 
    output reg q);

    always @(posedge clk, posedge reset_p)begin //상승엣지에서 동작 함으로else 괜찮음 엣지 에서 동작 트리거를 넣어서 괜찮음
        if(reset_p)q = 0;
        else if(en)q = d;
    end
    
endmodule



//module T_flip_flop_n(

//    input clk, reset_p, 
//    input en,
//    input t,
//    output reg q


//);


//    always @(negedge clk, posedge reset_p)begin
//        if(reset_p)q = 0;
//        else if(t) q = ~q;
//    end
    

//endmodule



module T_flip_flop_n(

    input clk, reset_p, 
    input en,
    input t,
    output reg q);


    always @(negedge clk, posedge reset_p)begin
        if(reset_p)q = 0;
        else if(en)begin
            if(t) q = ~q;
        end
    end
    

endmodule

////////////////////////////////////////////
module T_flip_flop_p(

    input clk, reset_p, 
    input en,
    input t,
    output reg q);



    always @(posedge clk, posedge reset_p)begin
        if(reset_p)q = 0;
//        else if(en)begin
//            if(t) q = ~q;
//         end
        else if(en & t) q = ~q;        
    end
    
endmodule

////////////////////////////////////////////
//비동기식 카운터

module up_counter_asyc(
    input clk, reset_p,
    output [3:0] count);
    
    
    T_flip_flop_n cnt0(.clk(clk), .reset_p(reset_p), .en(1), .t(1), .q(count[0]));
    T_flip_flop_n cnt1(.clk(count[0]), .reset_p(reset_p), .en(1), .t(1), .q(count[1])); 
    T_flip_flop_n cnt2(.clk(count[1]), .reset_p(reset_p), .en(1), .t(1), .q(count[2]));
    T_flip_flop_n cnt3(.clk(count[2]), .reset_p(reset_p), .en(1), .t(1), .q(count[3])); 

endmodule

//////////////////////////////////////////////////


//비동기식 카운터 
module down_counter_asyc(
    input clk, reset_p,
    output [3:0] count);
    
    
    T_flip_flop_p cnt0(.clk(clk), .reset_p(reset_p), .en(1), .t(1), .q(count[0]));
    T_flip_flop_p cnt1(.clk(count[0]), .reset_p(reset_p), .en(1), .t(1), .q(count[1])); 
    T_flip_flop_p cnt2(.clk(count[1]), .reset_p(reset_p), .en(1), .t(1), .q(count[2]));
    T_flip_flop_p cnt3(.clk(count[2]), .reset_p(reset_p), .en(1), .t(1), .q(count[3])); 

endmodule

//////////////////////////////////////

//상승엣지 동작 동기식 업 카운터 
module up_counter_p(
    input clk, reset_p,
    output reg [3:0] count);
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)count = 0;
        else count = count + 1;
    end

endmodule

//////////////////////////////////////

//상승엣지 동작 동기식 다운 카운터 
module down_counter_p(
    input clk, reset_p,
    output reg [3:0] count);
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)count = 0;
        else count = count - 1;
    end

endmodule


//////////////////////////////////////

//상승엣지 동작 동기식 다운 카운터 n
module down_counter_n(
    input clk, reset_p,
    output reg [3:0] count);
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)count = 4'b1111;
        else count = count - 1;
    end

endmodule

//////////////////////////////////////

//링카운터 
//module ring_counter(
//    input clk, reset_p,
//    output reg [3:0] q);

//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p)q = 4'b0001;
//        else begin
//            case(q)
//                4'b0001 : q = 4'b0010;
//                4'b0010 : q = 4'b0100;
//                4'b0100 : q = 4'b1000;
//                4'b1000 : q = 4'b0001;
//                default : q = 4'b0001;
//            endcase
//        end
//    end
//endmodule

//////////////////////////////////////////
//shift
//module ring_counter(
//    input clk, reset_p,
//    output reg [3:0] q);

//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p)q = 4'b0001;
//        else begin
//            if(q != 4'b0001 && q != 4'b0010 && q != 4'b0100 && q != 4'b1000) q = 4'b0001;
//            else q = {q[2:0], q[3]};
//            //결합 연산자 
//        end
//    end
//endmodule

/////////////////////////////////////////////

module ring_counter(
    input clk, reset_p,
    output reg [3:0] q);

    always @(posedge clk, posedge reset_p)begin
        if(reset_p)q = 4'b0001;
        else begin
            if(q[0] + q[1] + q[2] + q[3] != 1)q = 4'b0001;
            else q = {q[2:0], q[3]};
        end
    end
endmodule


/////////////////////////////////////////////


//module ring_counter_led(
//    input clk, reset_p,
//    output reg [15:0] led);
    
//    //분주
//    reg [31:0] clk_div;
    
//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p)clk_div = 0;
//        else begin
//            if(clk_div == 10000000)clk_div = 0;
//            else clk_div =  clk_div + 1;
//        end
//    end
    
//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p) led = 16'b0000_0000_0000_0001;
//        else begin
//            if(clk_div == 0) begin
//                led = {led[14:0], led[15]};
//            end
//        end
//    end

//endmodule



/////////////////////////////////////////////


//module ring_counter_led(
//    input clk, reset_p,
//    output reg [15:0] led);
    
//    //분주
//    reg [31:0] clk_div;
    
//    always @(posedge clk)clk_div = clk_div + 1;
        
    
//    always @(posedge clk_div[20] or posedge reset_p)begin
//        if(reset_p) led = 16'b0000_0000_0000_0001;
//        else led = {led[14:0], led[15]};
            
//    end

//endmodule

/////////////////////////////////////////////


//module ring_counter_led(
//    input clk, reset_p,
//    output reg [15:0] led);
    
//    //분주
//    reg [31:0] clk_div;
    
//    always @(posedge clk)clk_div = clk_div + 1;
        
    
//    always @(posedge clk_div[21] or posedge reset_p)begin
//        if(reset_p) led = 16'b0000_0000_0000_0001;
//        else led = {led[14:0], led[15]};
            
//    end

//endmodule

//////////////////////////////////////////////////////////////////////////////


//module edge_detector_n(
//    input clk, reset_p,
//    input cp,
//    output p_edge, n_edge);
    
    
//    reg ff_cur, ff_old;
    
//    always @(negedge clk, posedge reset_p)begin
//        if(reset_p)begin
//            ff_cur <= 0;
//            ff_old <= 0;
//        end
//        else begin
            
//            ff_cur = cp;
//            ff_old = ff_cur;
            
//        end
//    end
    
//    assign p_edge = ({ff_cur, ff_old} == 2'b10) ? 1 : 0;
//    assign n_edge = ({ff_cur, ff_old} == 2'b01) ? 1 : 0;
    
    
    
//endmodule  




//module ring_counter_led(
//    input clk, reset_p,
//    output reg [15:0] led);
    
//    //분주
//    reg [31:0] clk_div;
//    always @(posedge clk)clk_div = clk_div + 1;
    
//    reg flag;
    
//    always @(posedge clk or posedge reset_p)begin
//        if(reset_p)begin
//            led  = 16'b0000_0000_0000_0001;
//            flag = 0;    
           
//        end
//        else begin
//            if(clk_div[22] && flag == 0)begin
//                led = {led[14:0], led[15]};
//                flag = 1;
//            end
//            if(clk_div[22] == 0)flag = 0;
//        end      
//    end
//endmodule

////////////////////////////////////////////////////////////////////////////

 

//////////////////////////////////////////////////////////

module SISO(
    input clk, reset_p,
    input d,
    input en,
    output f);
    
    reg [7:0] register_siso;
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)
            register_siso = 0;
        else if(en)begin 
            register_siso = {d, register_siso[7:1]};
        end
    end
    
    assign f = register_siso[0];
    
endmodule

//////////////////////////////////////////////////////

module SIPO(
    input clk, reset_p,
    input d,
    input rd_en,
    output [7:0] q);
    
    
    reg [7:0] register_sipo;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)register_sipo = 0;        
        else register_sipo = {d, register_sipo[7:1]};
    end

    assign q = rd_en ? register_sipo : 8'bz;
    
    
endmodule



//////////////////////////////////////////////////////

//병렬 입력 직렬 출력 
module PIOS(
    input clk, reset_p,
    input [7:0] d,
    input shift_load,
    output q);
    
    
    
    reg [7:0] register_piso;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)register_piso = 0;
        else begin
            if(shift_load)register_piso = {1'b0, register_piso[7:1]};
            else register_piso = d;
        end
    end
    
    assign q = register_piso[0];
    
endmodule

///////////////////////////////////////////////////

module memory(
    input clk, reset_p,
    input [7:0] i_data,
    input [9:0] wr_addr, rd_addr,
    output reg [7:0] o_data);
    
    reg [7:0] ram [0:1023];
    always @(posedge clk)begin
        ram[wr_addr] = i_data;
        o_data = ram[rd_addr]; 
    end
    
endmodule

//wr_addr 주소 
//읽기 주소 쓰기 주소 두개존재
// 1k짜리 메모리 읽기 쓰기 둘다 동시에 가능

///////////////////////////////////////////////////
//주소 1개짜리


module memory_one_addr_bus(
    input clk, reset_p,         //클럭입력 //리셋
    input [7:0] i_data,         //CPU나 버스에서 오는 쓰기write데이터 8bit
    input wr_rd,                //쓰기/ 읽기 선택 신호 1이면 쓰기 0이면 읽기
    input [9:0] addr,           //10비트 주소 → 2^10 = 1024개 주소 가능.
    output reg [7:0] o_data);   //읽기(출력) 데이터. reg로 선언되어 always 블록에서 갱신됨
    
    reg [7:0] ram [0:1023];     //8bit 1024kb 메모리
    always @(posedge clk)begin  
        if(wr_rd)ram[addr] =  i_data;
        else o_data = ram[addr];
    end
    
endmodule

//클럭의 상승 에지에서만 실행된다(즉 동기적 동작).
//wr_rd == 1 이면: 그 시점의 addr 위치에 i_data 를 쓰기(ram[addr] = i_data).
//wr_rd == 0 이면: 그 시점의 ram[addr] 값을 o_data 에 대입(읽기).
//중요한 점: 읽기(o_data 갱신)도 posedge clk에서만 일어나므로 동기식(registered) 읽기다 — 출력이 주소를 주고 바로(조합논리로) 바뀌는 게 아니다.
//파형으로 보면:
//클럭 상승 에지 시점에 wr_rd에 따라 쓰기 또는 읽기 한 번 발생.
//읽기 모드라면 o_data는 그 상승에지에서 갱신되고, 다음 클럭 사이클까지 그 값을 유지.

/////////////////////////////////////////////////////////


module edge_detector_n(
    input clk, reset_p,
    input cp,
    output p_edge, n_edge);
    
    reg ff_cur, ff_old;
    
    always @(negedge clk, posedge reset_p)begin
        if(reset_p)begin
            ff_cur = 0;
            ff_old = 0;
        end
        else begin
            ff_old = ff_cur;
            ff_cur = cp;
            
        end
    end
    
    assign p_edge = ({ff_cur, ff_old} == 2'b10) ? 1 : 0;
    assign n_edge = ({ff_cur, ff_old} == 2'b01) ? 1 : 0;
    
endmodule   

/////////////////////////////////////////////////////////



module edge_detector_p(
    input clk, reset_p,
    input cp,
    output p_edge, n_edge);
    
    reg ff_cur, ff_old;
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            ff_cur = 0;
            ff_old = 0;
        end
        else begin
            ff_old = ff_cur;
            ff_cur = cp;
            
        end
    end
    
    assign p_edge = ({ff_cur, ff_old} == 2'b10) ? 1 : 0;
    assign n_edge = ({ff_cur, ff_old} == 2'b01) ? 1 : 0;
    
endmodule 

















