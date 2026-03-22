`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 09:39:03 AM
// Design Name: 
// Module Name: exam03_var_odule
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

//edgr detector add work

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


module watch(
    input clk, reset_p,
    input [2:0] btn, 
    output reg [7:0] sec, min);
    
    reg set_watch;
     
    wire btn_p_1, btn_p_2, btn_p_3;
    
    edge_detector_p ed_1( .clk(clk), .reset_p(reset_p), .cp(btn[0]), .p_edge(btn_p_1));
    edge_detector_p ed_2( .clk(clk), .reset_p(reset_p), .cp(btn[1]), .p_edge(btn_p_2));
    edge_detector_p ed_3( .clk(clk), .reset_p(reset_p), .cp(btn[2]), .p_edge(btn_p_3));
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)set_watch = 0;
        else if(btn_p_1)set_watch = ~set_watch;
    end
    
    
    integer cnt_sysclk;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk = 0;
            sec = 0;
            min = 0;
        end
        else begin
            if(set_watch)begin
                if(btn_p_2)begin
                    if(sec >= 59)sec = 0;
                    else sec = sec + 1;
                end
                if(btn_p_3)begin
                    if(min >= 59)min = 0;
                    else min = min + 1;
                end
            
            end
            else begin
                
                if(cnt_sysclk == 27'd99_999_999)begin
                    cnt_sysclk = 0;
                    if(sec >= 59) begin
                        sec = 0;
                        if(min >= 59) min = 0;
                        else min = min + 1;
                    end
                    else sec = sec + 1;
                end
                else cnt_sysclk = cnt_sysclk + 1;
            end
            
        end
    end
endmodule

///////////////////////////////////////////////

module cook_timer(
    input clk, reset_p,
    input btn_start, inc_sec, inc_min, alarm_off,        
    output reg [7:0] sec, min,
    output reg alarm);
    
    //스위치 1번째 사용 
    
    reg [7:0] set_sec, set_min;
    
    reg dcnt_set;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin            //리셋 
            dcnt_set = 0;
            alarm = 0;
            set_sec = 0;    //1 수정 
            set_min = 0;    //1 수정 
        end
        else begin
            if(btn_start)begin
                dcnt_set = ~dcnt_set;          //버튼 누를시 자동 모드 실행 
                set_sec = sec;    //1 수정 
                set_min = min;    //1 수정 
                
            end
            if(sec == 0 && min == 0 && dcnt_set )begin     //0분 0초 알람 켜짐 
                dcnt_set = 0;
                alarm = 1;
            end
            if(alarm_off || inc_sec || inc_min)alarm = 0;  

          //버튼 누를시 말람 꺼짐 기능
        end

    end
    integer cnt_sysclk;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk = 0;
            sec = 0;
            min = 0;
        end
        else  begin
            if(dcnt_set)begin       //동작 자동모드 dcnt_set 설정 
                if(cnt_sysclk >= 99_999_999)begin
                    cnt_sysclk = 0;
                    if(sec == 0 && min)begin
                        sec = 59;
                        min = min - 1;
                    end
                    else sec = sec - 1;
                end
                else cnt_sysclk = cnt_sysclk + 1;
             end
//             else if(alarm && (alarm_off || inc_sec || inc_min))begin    //1 수정 
////                sec = set_sec;    //1 수정 
////                min = set_min;    //1 수정 
//             end    //1 수정 
             //중간 
             else begin             //수동 설정모드 
                if(inc_sec)begin
                    if(sec >= 59)sec = 0;
                    else sec = sec + 1;
                end
                if(inc_min)begin
                   if(min >= 59)min = 0;
                   else min = min + 1;
                end
            end
        end
    end

endmodule

///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////
///////////////////////////////////////////////

//버튼 제어구간 


//module stop_watch_timer(

// input clk, reset_p,
//    input btn_start_and_stop, Lap_save, clear, Lap,        
//    output reg [7:0] set_sec, set_min,
//    output reg alarm);
    
//    //스위치 1번째 사용 
    
//    reg [7:0] cur_sec, cur_min;
//    reg [7:0] Lap_sec, Lap_min;
//    reg dcnt_set;
//    reg Lap_set;
//    reg old_Lap_set;
    
//    always @(posedge clk, posedge reset_p)begin // 실제동작 제어 전 정보전달 레지스터 
//        if(reset_p)begin            
//            dcnt_set <= 0;       //자동모드 수동모드 
//            alarm <= 0;        
//            Lap_set <= 0;    //기록 Lap의 저장 기능
//            old_Lap_set <=0;
            
//        end
//        else begin  //리셋아닐때 
//            if(btn_start_and_stop)begin
//                dcnt_set <= ~dcnt_set;          //버튼 누를시 자동 모드 실행 처음0
                
//            end
            
//            old_Lap_set <= Lap_set;
            
//            if(Lap)begin     //Lap 구간 기록 시스템 켜기                 
//                //작업 추가
////                old_Lap_set = Lap_set;
//                Lap_set <= ~Lap_set; 
//            end    
                
//            if(old_Lap_set == 0 && Lap_set == 1) begin
//                    // Lap_set이 0→1로 변경되는 순간에만 시간 저장
//                Lap_sec <= cur_sec;
//                Lap_min <= cur_min;
//            end
//        end
//    end

//    //레지스터 제어구간
    
//    integer cnt_sysclk;
//    always @(posedge clk, posedge reset_p)begin //실제 동작 구현 로직 
//        if(reset_p)begin
//            cnt_sysclk <= 0; //시간 초기화 기능
//            cur_sec <= 0;
//            cur_min <= 0;
//            Lap_sec <= 0;
//            Lap_min <= 0;
//            set_sec <= 0;
//            set_min <= 0;
            
//        end       
//        else  begin
//            if(dcnt_set)begin       //동작 자동모드 
                
//                if(cnt_sysclk >= 999_999)begin   //1초마다 숫자 증가
//                    cnt_sysclk <= 0;
//                    if(cur_sec >= 99 )begin
//                        cur_sec <= 0;
//                        if(cur_min >= 59)begin
//                            cur_min = 0;
//                        end
//                        else begin
//                            cur_min <= cur_min + 1;
//                        end
//                    end
//                    else begin
//                        cur_sec <= cur_sec + 1;
//                    end
//                end
                    
//                else begin
//                    cnt_sysclk <= cnt_sysclk + 1;
                    
//                end

//             end

//             if(Lap_set)begin   //버튼을 누를시 저장기능on/off 기능 
//                set_sec <= Lap_sec;
//                set_min <= Lap_min;
                          
//             end
             
//             else begin
//                set_sec <= cur_sec;     //기록 시간 sw반영 초 
//                set_min <= cur_min;     //기록 시간 sw반영 분 
//             end         
//        end
//    end
//endmodule

////////////////////////////////////////////////

//module stop_watch_timer(
//    input clk, reset_p,
//    input btn_start_and_stop, Lap_save, clear, Lap,        
//    output reg [7:0] set_sec, set_min,
//    output reg alarm);
    
//    reg [7:0] cur_sec, cur_min;
//    reg [7:0] Lap_sec, Lap_min;
//    reg dcnt_set;
//    reg Lap_set;
    
//    // ---------------------------
//    // 상태 제어 레지스터 블록
//    // ---------------------------
//    always @(posedge clk, posedge reset_p) begin
//        if(reset_p) begin
//            dcnt_set <= 0;
//            alarm <= 0;
//            Lap_set <= 0;
//            Lap_sec <= 0;
//            Lap_min <= 0;
//        end
//        else begin
            
//            if(btn_start_and_stop)
//                dcnt_set <= ~dcnt_set;

//            if(Lap) begin
                
//                if(Lap_set <= 0) begin
//                    Lap_sec <= cur_sec;
//                    Lap_min <= cur_min;
//                end
                
//                Lap_set <= ~Lap_set;
//            end
//        end
//    end


//    // ---------------------------
//    // 실제 카운터 및 출력 로직
//    // ---------------------------
//    integer cnt_sysclk;
//    always @(posedge clk, posedge reset_p) begin
//        if(reset_p) begin
//            cnt_sysclk <= 0;
//            cur_sec <= 0;
//            cur_min <= 0;
//            set_sec <= 0;
//            set_min <= 0;
//        end       
//        else begin            
//            // 자동 카운트 모드
//            if(dcnt_set) begin
//                if(cnt_sysclk >= 999_999) begin
//                    cnt_sysclk <= 0;

//                    if(cur_sec >= 99) begin
//                        cur_sec <= 0;
//                        if(cur_min >= 59)
//                            cur_min <= 0;
//                        else
//                            cur_min <= cur_min + 1;
//                    end
//                    else
//                        cur_sec <= cur_sec + 1;
//                end
//                else begin
//                    cnt_sysclk <= cnt_sysclk + 1;
//                end
//            end

            
//            if(Lap_set) begin
//                set_sec <= Lap_sec;
//                set_min <= Lap_min;
//            end
            
//            else begin
//                set_sec <= cur_sec;
//                set_min <= cur_min;
//            end
//        end
//    end
//endmodule

////////////////////////////////////////////////





module stop_watch(
    input clk, reset_p,
    input btn_start, btn_lap, btn_clear,        
    output reg [7:0] fnd_sec, fnd_csec,
    output reg start_stop, lap);
 
    // ---------------------------
    // 상태 제어 레지스터 블록
    // ---------------------------
    always @(posedge clk, posedge reset_p) begin
        if(reset_p) begin
            start_stop = 0;
        
        end
        else begin
            if(btn_start)start_stop = ~start_stop;
            else if(btn_clear)start_stop = 0;
        end
    end
    
    reg [7:0] sec, csec, lap_sec, lap_csec;
    integer cnt_sysclk;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk = 0;
            sec = 0;
            csec = 0;
        end
        else begin
            if(start_stop)begin
                if(cnt_sysclk >= 999_999)begin
                    cnt_sysclk = 0;
                    if(csec >= 99 )begin
                        csec = 0;
                        if(sec>=59)begin
                            sec = 0;
                        end
                        else sec = sec + 1;
                    end
                    else csec = csec + 1;
                end
                else cnt_sysclk = cnt_sysclk + 1;
            end
            if(btn_clear)begin
                sec = 0;
                csec = 0;
                cnt_sysclk = 0;
            end
        end
    end
    
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            lap_sec = 0;
            lap_csec = 0;
            lap = 0;
        end
        else begin
            if(btn_lap)begin
                if(start_stop)lap = ~lap;
                lap_sec = sec;
                lap_csec = csec;
            end
            if(btn_clear)begin
                lap = 0;
                lap_sec = 0;
                lap_csec = 0;
            end
        end
    end
    
    
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            fnd_sec = 0;
            fnd_csec = 0;
        end
        else begin
            if(lap)begin
                fnd_sec = lap_sec;
                fnd_csec = lap_csec;
            end
            else begin
                fnd_sec = sec;
                fnd_csec = csec;  
            end
        end
    end
endmodule


















