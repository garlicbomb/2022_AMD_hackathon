`timescale 1ns / 1ps


module gfx(
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire btn1, btn2, btn3, // moving , shooting control
    
    input wire [1:0] sw,    // sw[0]=1:+y 방향 , sw[0]=0:-y 방향
    
    output reg [7:0] o_red,
    output reg [7:0] o_green,
    output reg [7:0] o_blue,
    
    output wire enemy_shoot_e1, enemy_shoot_e2,enemy_shoot_e3, enemy_shoot_e4, enemy_shoot_e5,enemy_shoot_stage4_e1, enemy_shoot_stage4_e2,enemy_shoot_stage4_e3,
    output wire item_1_get, item_2_get,
    output wire [4:0] total_score,
    output wire [2:0] life // player life 
    
    );
    wire bg_hit;

    //////////////////////////// timer ///////////////////////
    wire clear_hit_sig;
    
     ///////////////////////// enemy hit signal ////////////////////////////(code:24~27)
    reg s0_hit_sig = 0;
    reg s1_hit_sig = 0;
    reg s2_hit_sig = 0;
    reg s3_hit_sig = 0;
    reg s4_hit_sig = 0;
    reg s5_hit_sig = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////////


    //////////////////////////// score 를 위해 생성 //////////////////////////
    ////////////// stage 1 //////////////////
    wire score_e1 ; // 총알이 적에 닿았음을 알리는 신호 
    wire score_e2 ; // 총알이 적에 닿았음을 알리는 신호 
    wire score_e3 ; // 총알이 적에 닿았음을 알리는 신호 
    wire score_e4 ; // 총알이 적에 닿았음을 알리는 신호 
    wire score_e5 ; // 총알이 적에 닿았음을 알리는 신호 
    ////////////// stage 2 //////////////////
    wire score_stage2_e1 ;
    wire score_stage2_e2 ;
    wire score_stage2_e3 ;
    wire score_stage2_e4 ;
    wire score_stage2_e5 ;
    wire score_stage2_e6 ;
    wire score_stage2_e7 ;
    wire score_stage2_e8 ;
    wire score_stage2_e9 ;
    /////////////// stage 3 //////////////////////
    wire score_stage3_e1 ;
    wire score_stage3_e2 ;
    wire score_stage3_e3 ;
    wire score_stage3_e4 ;
    wire score_stage3_e5 ;
    wire score_enemy_big_red_1;
      /////////////////////stage 4 ////////////////////////(code:53~64)
    wire score_stage4_e1;
    wire score_stage4_e2;
    wire score_stage4_e3;
    ///////////////////// stage 5 //////////////////////////
    wire score_stage5_boss;
    ///////////////////////////////////////////////////
//    wire [4:0] total_score ;    // 총 스코어에 따른 스코어 이미지 변경 
    /////////// calculate total score //////////////////////  
    assign total_score = score_e1 + score_e2 + score_e3 + score_e4 + score_e5 
    + score_stage2_e1 + score_stage2_e2 + score_stage2_e3 + score_stage2_e4 + score_stage2_e5 + score_stage2_e6 + score_stage2_e7 + 
    score_stage2_e8 + score_stage2_e9 + score_stage3_e1 + score_stage3_e2 + score_stage3_e3 + score_stage3_e4 + score_stage3_e5
    + score_enemy_big_red_1 + score_stage4_e1 + score_stage4_e2 + score_stage4_e3;  // 총 스코어에 따른 스코어 이미지 변경 위함 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    reg item1_get = 0;  assign item_1_get = item1_get;
    reg item2_get = 0;  assign item_2_get = item2_get;
    
    //////////////////////// player life를 위해 생성 //////////////////////////////////////////////////////////////
//    wire [2:0] life;    // player 로 입력되는 life signal 
    
    reg [2:0] life_control = 3; // gfx 모듈내에서 life를 contorl 하기 위한 변수 선언 
   
    /////////////////////////////// item //////////////////////////////////////// gfx line 78~ 97
    wire sprite_hit_item1;
    wire [7:0] sprite_red_item1;
    wire [7:0] sprite_green_item1;
    wire [7:0] sprite_blue_item1;
    wire [15:0] sprite_item1_x;   
    wire [15:0] sprite_item1_y;  
    wire [15:0] shoot_item1_x;     
    wire [15:0] shoot_item1_y;     
    wire item1_begin;
       
    wire sprite_hit_item2;
    wire [7:0] sprite_red_item2;
    wire [7:0] sprite_green_item2;
    wire [7:0] sprite_blue_item2;
    wire [15:0] sprite_item2_x;   
    wire [15:0] sprite_item2_y;  
    wire [15:0] shoot_item2_x;     
    wire [15:0] shoot_item2_y;     
    wire item2_begin;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// BACK GROUND COLOR - > test card simple , 앞선 주차에서 했던 무지개색 band 출력을 위한 R G B 8bit color 
    wire [7:0] bg_red;
    wire [7:0] bg_green;
    wire [7:0] bg_blue;
    
    ////////////////////////////// player /////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    // 아군 전투기  -> 전투기 모양의 캐릭터 출력을 위한 R G B 8bit color 
    wire sprite_hit_p1;
    wire [7:0] sprite_red_p1;
    wire [7:0] sprite_green_p1;
    wire [7:0] sprite_blue_p1;
    //////////////////////////////////////////////////////// 연결
    wire [15:0] sprite_p1_x;
    wire [15:0] sprite_p1_y;
    ///////////////////////////////////////////////////////// 연결 
    /////////////// stage 0 //////////////////////////////////
    wire s0_enemy_hit_sig;
       // 적군 전투기 1
    wire sprite_hit_e1;
    wire [7:0] sprite_red_e1;
    wire [7:0] sprite_green_e1;
    wire [7:0] sprite_blue_e1;
    wire [15:0] sprite_e1_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_e1_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_e1_x;     // input 되는 총알 좌표
    wire [15:0] shoot_e1_y;     // input 되는 총알 좌표 
    wire shoot_signal_e1;       // output 되는 총알 발사 신호 
    
    // 적군 전투기 2
    wire sprite_hit_e2;
    wire [7:0] sprite_red_e2;
    wire [7:0] sprite_green_e2;
    wire [7:0] sprite_blue_e2;
    wire [15:0] sprite_e2_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_e2_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_e2_x;     // input 되는 총알 좌표
    wire [15:0] shoot_e2_y;     // input 되는 총알 좌표 
    wire shoot_signal_e2;       // output 되는 총알 발사 신호 
    
        // 기존 stage2  enemy1 
    wire sprite_hit_stage2_e1;
    wire [7:0] sprite_red_stage2_e1;
    wire [7:0] sprite_green_stage2_e1;
    wire [7:0] sprite_blue_stage2_e1;
    wire [15:0] sprite_stage2_e1_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e1_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e1_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e1_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e1; 
    // 기존 stage2 enemy2 
    wire sprite_hit_stage2_e2;
    wire [7:0] sprite_red_stage2_e2;
    wire [7:0] sprite_green_stage2_e2;
    wire [7:0] sprite_blue_stage2_e2;
    wire [15:0] sprite_stage2_e2_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e2_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e2_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e2_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e2;       // output 되는 총알 발사 신호 
    // 기존 stage2 enemy3
    wire sprite_hit_stage2_e3;
    wire [7:0] sprite_red_stage2_e3;
    wire [7:0] sprite_green_stage2_e3;
    wire [7:0] sprite_blue_stage2_e3;
    wire [15:0] sprite_stage2_e3_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e3_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e3_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e3_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e3; 


    ////////////////////////////// stage 1 enemy /////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    wire s1_enemy_hit_sig;
  
    // 적군 전투기 3
    wire sprite_hit_e3;
    wire [7:0] sprite_red_e3;
    wire [7:0] sprite_green_e3;
    wire [7:0] sprite_blue_e3;
    wire [15:0] sprite_e3_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_e3_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_e3_x;     // input 되는 총알 좌표
    wire [15:0] shoot_e3_y;     // input 되는 총알 좌표 
    wire shoot_signal_e3;       // output 되는 총알 발사 신호 
    
       // 기존 stage2 enemy4
    wire sprite_hit_stage2_e4;
    wire [7:0] sprite_red_stage2_e4;
    wire [7:0] sprite_green_stage2_e4;
    wire [7:0] sprite_blue_stage2_e4;
    wire [15:0] sprite_stage2_e4_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e4_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e4_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e4_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e4;       // output 되는 총알 발사 신호
    // 기존 stage2 enmey5
    wire sprite_hit_stage2_e5;
    wire [7:0] sprite_red_stage2_e5;
    wire [7:0] sprite_green_stage2_e5;
    wire [7:0] sprite_blue_stage2_e5;
    wire [15:0] sprite_stage2_e5_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e5_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e5_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e5_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e5; 
    // 기존 stage2 enmey 6
    wire sprite_hit_stage2_e6;
    wire [7:0] sprite_red_stage2_e6;
    wire [7:0] sprite_green_stage2_e6;
    wire [7:0] sprite_blue_stage2_e6;
    wire [15:0] sprite_stage2_e6_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e6_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e6_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e6_y;     // input 되는 총알 좌표
    wire shoot_signal_stage2_e6;       // output 되는 총알 발사 신호 
    // 기존 stage2 enemy 7
    wire sprite_hit_stage2_e7;
    wire [7:0] sprite_red_stage2_e7;
    wire [7:0] sprite_green_stage2_e7;
    wire [7:0] sprite_blue_stage2_e7;
    wire [15:0] sprite_stage2_e7_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e7_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e7_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e7_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e7; 

      
    ////////////////////////////// stage 2 enemy /////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
   wire s2_enemy_hit_sig;
    // 적군 전투기 4
    wire sprite_hit_e4;
    wire [7:0] sprite_red_e4;
    wire [7:0] sprite_green_e4;
    wire [7:0] sprite_blue_e4;
    wire [15:0] sprite_e4_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_e4_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_e4_x;     // input 되는 총알 좌표
    wire [15:0] shoot_e4_y;     // input 되는 총알 좌표 
    wire shoot_signal_e4;       // output 되는 총알 발사 신호 
    
    // 적군 전투기 5
    wire sprite_hit_e5;
    wire [7:0] sprite_red_e5;
    wire [7:0] sprite_green_e5;
    wire [7:0] sprite_blue_e5;
    wire [15:0] sprite_e5_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_e5_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_e5_x;     // input 되는 총알 좌표
    wire [15:0] shoot_e5_y;     // input 되는 총알 좌표 
    wire shoot_signal_e5;       // output 되는 총알 발사 신호 

     // 기존 stage2 enemy 8
    wire sprite_hit_stage2_e8;
    wire [7:0] sprite_red_stage2_e8;
    wire [7:0] sprite_green_stage2_e8;
    wire [7:0] sprite_blue_stage2_e8;
    wire [15:0] sprite_stage2_e8_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e8_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e8_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e8_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e8;       // output 되는 총알 발사 신호 
    // 기존 stage 2 enemy 9
    wire sprite_hit_stage2_e9;
    wire [7:0] sprite_red_stage2_e9;
    wire [7:0] sprite_green_stage2_e9;
    wire [7:0] sprite_blue_stage2_e9;
    wire [15:0] sprite_stage2_e9_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage2_e9_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage2_e9_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage2_e9_y;     // input 되는 총알 좌표 
    wire shoot_signal_stage2_e9; 
    ////////////////////////////// stage 3 enemy /////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    wire s3_enemy_hit_sig;
    // stage 3 enemy 1 
    wire sprite_hit_stage3_e1;
    wire [7:0] sprite_red_stage3_e1;
    wire [7:0] sprite_green_stage3_e1;
    wire [7:0] sprite_blue_stage3_e1;
    wire [15:0] sprite_stage3_e1_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage3_e1_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage3_e1_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage3_e1_y;     // input 되는 총알 좌표 
    
  //   wire shoot_signal_stage3_e1;       // output 되는 총알 발사 신호 
    
    // stage 3 enemy 2 
    wire sprite_hit_stage3_e2;
    wire [7:0] sprite_red_stage3_e2;
    wire [7:0] sprite_green_stage3_e2;
    wire [7:0] sprite_blue_stage3_e2;
    wire [15:0] sprite_stage3_e2_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage3_e2_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage3_e2_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage3_e2_y;     // input 되는 총알 좌표 
    
    // stage 3 enemy 3 
    wire sprite_hit_stage3_e3;
    wire [7:0] sprite_red_stage3_e3;
    wire [7:0] sprite_green_stage3_e3;
    wire [7:0] sprite_blue_stage3_e3;
    wire [15:0] sprite_stage3_e3_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage3_e3_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage3_e3_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage3_e3_y;     // input 되는 총알 좌표 
    
 //   wire shoot_signal_stage3_e3;       // output 되는 총알 발사 신호 
    
    // stage 3 enemy 4 
    wire sprite_hit_stage3_e4;
    wire [7:0] sprite_red_stage3_e4;
    wire [7:0] sprite_green_stage3_e4;
    wire [7:0] sprite_blue_stage3_e4;
    wire [15:0] sprite_stage3_e4_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage3_e4_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage3_e4_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage3_e4_y;     // input 되는 총알 좌표 
    
    // stage 3 enemy 5 
    wire sprite_hit_stage3_e5;
    wire [7:0] sprite_red_stage3_e5;
    wire [7:0] sprite_green_stage3_e5;
    wire [7:0] sprite_blue_stage3_e5;
    wire [15:0] sprite_stage3_e5_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage3_e5_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage3_e5_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage3_e5_y;     // input 되는 총알 좌표 
    
 //   wire shoot_signal_stage3_e5;       // output 되는 총알 발사 신호 
   
        /////////////////////enemy_big_red///////////////////////////////(code:313~362)
    wire sprite_hit_enemy_big_red_1;
    wire [7:0] sprite_red_enemy_big_red_1;
    wire [7:0] sprite_green_enemy_big_red_1;
    wire [7:0] sprite_blue_enemy_big_red_1; 
    wire [15:0] sprite_enemy_big_red_1_x; //output되는 적군 좌표
    wire [15:0] sprite_enemy_big_red_1_y; //output되는 적군 좌표
    wire [15:0] shoot_enemy_big_red_1_x; //input 되는 총알 좌표
    wire [15:0] shoot_enemy_big_red_1_y; //input 되는 총알 좌표
    
 //   wire shoot_signal_enemy_big_red_1; //output 되는 총알 발사 신호
    
    /////////////////////////////////////////////////////stage 4/////////////////////////////////
    wire s4_enemy_hit_sig;
    // stage4 enemy 1
    wire sprite_hit_stage4_e1;
    wire [7:0] sprite_red_stage4_e1;
    wire [7:0] sprite_green_stage4_e1;
    wire [7:0] sprite_blue_stage4_e1;
    wire [15:0] sprite_stage4_e1_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage4_e1_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage4_e1_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage4_e1_y;     // input 되는 총알 좌표 
    
    wire shoot_signal_stage4_e1;       // output 되는 총알 발사 신호 

    // stage4 enemy 2
    wire sprite_hit_stage4_e2;
    wire [7:0] sprite_red_stage4_e2;
    wire [7:0] sprite_green_stage4_e2;
    wire [7:0] sprite_blue_stage4_e2;
    wire [15:0] sprite_stage4_e2_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage4_e2_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage4_e2_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage4_e2_y;     // input 되는 총알 좌표 
    
    wire shoot_signal_stage4_e2;       // output 되는 총알 발사 신호 

    // stage4 enemy 3
    wire sprite_hit_stage4_e3;
    wire [7:0] sprite_red_stage4_e3;
    wire [7:0] sprite_green_stage4_e3;
    wire [7:0] sprite_blue_stage4_e3;
    wire [15:0] sprite_stage4_e3_x;    // output 되는 적군 좌표 
    wire [15:0] sprite_stage4_e3_y;    // output 되는 적군 좌표 
    wire [15:0] shoot_stage4_e3_x;     // input 되는 총알 좌표
    wire [15:0] shoot_stage4_e3_y;     // input 되는 총알 좌표 
    
    wire shoot_signal_stage4_e3;       // output 되는 총알 발사 신호 

//////////////////// stage 5 ///////////////////////////////////////////////////////////////////////////////////////
//    wire s5_enemy_hit_sig;
//    // stage5 boss
//    wire sprite_hit_stage5_boss;
//    wire [7:0] sprite_red_stage5_boss;
//    wire [7:0] sprite_green_stage5_boss;
//    wire [7:0] sprite_blue_stage5_boss;
//    wire [15:0] sprite_stage5_boss_x;    // output 되는 적군 좌표 
//    wire [15:0] sprite_stage5_boss_y;    // output 되는 적군 좌표 
//    wire [15:0] shoot_stage5_boss_x;     // input 되는 총알 좌표
//    wire [15:0] shoot_stage5_boss_y;     // input 되는 총알 좌표 
    
//    wire shoot_signal_stage5_boss;       // output 되는 총알 발사 신호 
   
    ////////////////////// stage signal assign /////////////////////////
    
    
    ///////////////////////////////////////////////////////////////////////////////
    
    // 학번
    wire sprite_hit3;
    wire [7:0] sprite_red3;
    wire [7:0] sprite_green3;
    wire [7:0] sprite_blue3;
    
    //////////////////////////////// score ///////////////////////////////////////////
   // score
    wire sprite_hit4;
    wire [7:0] sprite_red4;
    wire [7:0] sprite_green4;
    wire [7:0] sprite_blue4;
   
   // score = 1
    wire sprite_hit_s1;
    wire [7:0] sprite_red_s1;
    wire [7:0] sprite_green_s1;
    wire [7:0] sprite_blue_s1;
    
    // score = 2
    wire sprite_hit_s2;
    wire [7:0] sprite_red_s2;
    wire [7:0] sprite_green_s2;
    wire [7:0] sprite_blue_s2;
    
    // score = 3
    wire sprite_hit_s3;
    wire [7:0] sprite_red_s3;
    wire [7:0] sprite_green_s3;
    wire [7:0] sprite_blue_s3;
    
    // score = 4
    wire sprite_hit_s4;
    wire [7:0] sprite_red_s4;
    wire [7:0] sprite_green_s4;
    wire [7:0] sprite_blue_s4;
    
    // score = 5
    wire sprite_hit_s5;
    wire [7:0] sprite_red_s5;
    wire [7:0] sprite_green_s5;
    wire [7:0] sprite_blue_s5;
   
   // score = 6
    wire sprite_hit_s6;
    wire [7:0] sprite_red_s6;
    wire [7:0] sprite_green_s6;
    wire [7:0] sprite_blue_s6;
   
   // score = 7
    wire sprite_hit_s7;
    wire [7:0] sprite_red_s7;
    wire [7:0] sprite_green_s7;
    wire [7:0] sprite_blue_s7;   
    
    // score = 8
    wire sprite_hit_s8;
    wire [7:0] sprite_red_s8;
    wire [7:0] sprite_green_s8;
    wire [7:0] sprite_blue_s8;   
    
    // score = 9
    wire sprite_hit_s9;
    wire [7:0] sprite_red_s9;
    wire [7:0] sprite_green_s9;
    wire [7:0] sprite_blue_s9;   
    
    // score = 10
    wire sprite_hit_s10;
    wire [7:0] sprite_red_s10;
    wire [7:0] sprite_green_s10;
    wire [7:0] sprite_blue_s10;   
    
    // score = 11
    wire sprite_hit_s11;
    wire [7:0] sprite_red_s11;
    wire [7:0] sprite_green_s11;
    wire [7:0] sprite_blue_s11;   
    
    // score = 12
    wire sprite_hit_s12;
    wire [7:0] sprite_red_s12;
    wire [7:0] sprite_green_s12;
    wire [7:0] sprite_blue_s12;   
    
    // score = 13
    wire sprite_hit_s13;
    wire [7:0] sprite_red_s13;
    wire [7:0] sprite_green_s13;
    wire [7:0] sprite_blue_s13;   
    
    // score = 14
    wire sprite_hit_s14;
    wire [7:0] sprite_red_s14;
    wire [7:0] sprite_green_s14;
    wire [7:0] sprite_blue_s14;   
    
    // score = 15
    wire sprite_hit_s15;
    wire [7:0] sprite_red_s15;
    wire [7:0] sprite_green_s15;
    wire [7:0] sprite_blue_s15;   
    
    // score = 16
    wire sprite_hit_s16;
    wire [7:0] sprite_red_s16;
    wire [7:0] sprite_green_s16;
    wire [7:0] sprite_blue_s16;   
    
    // score = 17
    wire sprite_hit_s17;
    wire [7:0] sprite_red_s17;
    wire [7:0] sprite_green_s17;
    wire [7:0] sprite_blue_s17;   
    
    // score = 18
    wire sprite_hit_s18;
    wire [7:0] sprite_red_s18;
    wire [7:0] sprite_green_s18;
    wire [7:0] sprite_blue_s18;   
    
    // score = 19
    wire sprite_hit_s19;
    wire [7:0] sprite_red_s19;
    wire [7:0] sprite_green_s19;
    wire [7:0] sprite_blue_s19;
    
    // score = 20
    wire sprite_hit_s20;
    wire [7:0] sprite_red_s20;
    wire [7:0] sprite_green_s20;
    wire [7:0] sprite_blue_s20;
    
    // score = 21
    wire sprite_hit_s21;
    wire [7:0] sprite_red_s21;
    wire [7:0] sprite_green_s21;
    wire [7:0] sprite_blue_s21;
    
    // score = 22
    wire sprite_hit_s22;
    wire [7:0] sprite_red_s22;
    wire [7:0] sprite_green_s22;
    wire [7:0] sprite_blue_s22;
    
    // score = 23
    wire sprite_hit_s23;
    wire [7:0] sprite_red_s23;
    wire [7:0] sprite_green_s23;
    wire [7:0] sprite_blue_s23;    
    
     ////////////////////////////////////////////////////////////////////////////
  
   ////////////////////////////////////// life/////////////////////////////
   
   // life : 3
    wire sprite_hit_life3;
    wire [7:0] sprite_red_life3;
    wire [7:0] sprite_green_life3;
    wire [7:0] sprite_blue_life3;
    
   
   // life : 2
    wire sprite_hit_life2;
    wire [7:0] sprite_red_life2;
    wire [7:0] sprite_green_life2;
    wire [7:0] sprite_blue_life2;
    
   // life : 1 
    wire sprite_hit_life1;
    wire [7:0] sprite_red_life1;
    wire [7:0] sprite_green_life1;
    wire [7:0] sprite_blue_life1;
    
   // life : 0
    wire sprite_hit_life0;
    wire [7:0] sprite_red_life0;
    wire [7:0] sprite_green_life0;
    wire [7:0] sprite_blue_life0;
   
   ////////////////////////////////////////////////////////////////////////////
   //////////////////////////////////// projectile ///////////////////////////
   //////////////////////////////////// projectile /////////////////////////// gfx line : 558~ 570 
   ///// player's projectile //////
   // shoot projectile , player 
    wire sprite_hit_shoot_p;
    wire [7:0] sprite_red_shoot_p;
    wire [7:0] sprite_green_shoot_p;
    wire [7:0] sprite_blue_shoot_p;
    wire [15:0] shoot_x_p;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_p;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_p;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_p;     // output되는 총알의 좌표 
    wire [2:0] projectile_image;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
   ////////////////////////////////////////////////////////////////////////
    
    ///// enemy's projectile //////
    ////// stage 1 //////
    // shoot projectile, enemy1 
    wire sprite_hit_shoot_e1;
    wire [7:0] sprite_red_shoot_e1;
    wire [7:0] sprite_green_shoot_e1;
    wire [7:0] sprite_blue_shoot_e1;
    wire [15:0] shoot_x_e1;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_e1;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_e1;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_e1;     // output되는 총알의 좌표 
//    wire enemy_shoot_e1;               // input 되는 총알을 보내라는 신호 
    
     // shoot projectile, enemy2 
    wire sprite_hit_shoot_e2;
    wire [7:0] sprite_red_shoot_e2;
    wire [7:0] sprite_green_shoot_e2;
    wire [7:0] sprite_blue_shoot_e2;
    wire [15:0] shoot_x_e2;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_e2;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_e2;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_e2;     // output되는 총알의 좌표 
//    wire enemy_shoot_e2;               // input 되는 총알을 보내라는 신호 
   
    // shoot projectile, enemy3 -> stage1 e3와 mapping 
    wire sprite_hit_shoot_e3;
    wire [7:0] sprite_red_shoot_e3;
    wire [7:0] sprite_green_shoot_e3;
    wire [7:0] sprite_blue_shoot_e3;
    wire [15:0] shoot_x_e3;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_e3;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_e3;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_e3;     // output되는 총알의 좌표 
//    wire enemy_shoot_e3;               // input 되는 총알을 보내라는 신호 
    
     // shoot projectile, enemy4
    wire sprite_hit_shoot_e4;
    wire [7:0] sprite_red_shoot_e4;
    wire [7:0] sprite_green_shoot_e4;
    wire [7:0] sprite_blue_shoot_e4;
    wire [15:0] shoot_x_e4;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_e4;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_e4;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_e4;     // output되는 총알의 좌표 
//    wire enemy_shoot_e4;               // input 되는 총알을 보내라는 신호 
    
    // shoot projectile, enemy5 -> stage1 e5와 mapping 
    wire sprite_hit_shoot_e5;
    wire [7:0] sprite_red_shoot_e5;
    wire [7:0] sprite_green_shoot_e5;
    wire [7:0] sprite_blue_shoot_e5;
    wire [15:0] shoot_x_e5;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_e5;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_e5;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_e5;     // output되는 총알의 좌표 
 //   wire enemy_shoot_e5;               // input 되는 총알을 보내라는 신호 
    
    ///// stage 2 /////
    // stage 2 enemy1 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e1;
    wire [7:0] sprite_red_shoot_stage2_e1;
    wire [7:0] sprite_green_shoot_stage2_e1;
    wire [7:0] sprite_blue_shoot_stage2_e1;
    wire [15:0] shoot_x_stage2_e1;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e1;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e1;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e1;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e1;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy2 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e2;
    wire [7:0] sprite_red_shoot_stage2_e2;
    wire [7:0] sprite_green_shoot_stage2_e2;
    wire [7:0] sprite_blue_shoot_stage2_e2;
    wire [15:0] shoot_x_stage2_e2;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e2;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e2;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e2;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e2;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy3 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e3;
    wire [7:0] sprite_red_shoot_stage2_e3;
    wire [7:0] sprite_green_shoot_stage2_e3;
    wire [7:0] sprite_blue_shoot_stage2_e3;
    wire [15:0] shoot_x_stage2_e3;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e3;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e3;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e3;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e3;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy4 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e4;
    wire [7:0] sprite_red_shoot_stage2_e4;
    wire [7:0] sprite_green_shoot_stage2_e4;
    wire [7:0] sprite_blue_shoot_stage2_e4;
    wire [15:0] shoot_x_stage2_e4;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e4;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e4;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e4;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e4;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy5 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e5;
    wire [7:0] sprite_red_shoot_stage2_e5;
    wire [7:0] sprite_green_shoot_stage2_e5;
    wire [7:0] sprite_blue_shoot_stage2_e5;
    wire [15:0] shoot_x_stage2_e5;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e5;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e5;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e5;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e5;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy6 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e6;
    wire [7:0] sprite_red_shoot_stage2_e6;
    wire [7:0] sprite_green_shoot_stage2_e6;
    wire [7:0] sprite_blue_shoot_stage2_e6;
    wire [15:0] shoot_x_stage2_e6;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e6;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e6;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e6;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e6;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy7 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e7;
    wire [7:0] sprite_red_shoot_stage2_e7;
    wire [7:0] sprite_green_shoot_stage2_e7;
    wire [7:0] sprite_blue_shoot_stage2_e7;
    wire [15:0] shoot_x_stage2_e7;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e7;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e7;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e7;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e7;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy8 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e8;
    wire [7:0] sprite_red_shoot_stage2_e8;
    wire [7:0] sprite_green_shoot_stage2_e8;
    wire [7:0] sprite_blue_shoot_stage2_e8;
    wire [15:0] shoot_x_stage2_e8;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e8;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e8;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e8;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e8;               // input 되는 총알을 보내라는 신호 
    
    // stage 2 enemy9 -> shoot projectile 
    wire sprite_hit_shoot_stage2_e9;
    wire [7:0] sprite_red_shoot_stage2_e9;
    wire [7:0] sprite_green_shoot_stage2_e9;
    wire [7:0] sprite_blue_shoot_stage2_e9;
    wire [15:0] shoot_x_stage2_e9;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage2_e9;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage2_e9;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage2_e9;     // output되는 총알의 좌표 
    wire enemy_shoot_stage2_e9;               // input 되는 총알을 보내라는 신호 
    
 
/////////////////////////////////////////////stage 4//////////////////////////////////////////////////////////////////
    // stage 4 enemy1 -> shoot projectile 
    wire sprite_hit_shoot_stage4_e1;
    wire [7:0] sprite_red_shoot_stage4_e1;
    wire [7:0] sprite_green_shoot_stage4_e1;
    wire [7:0] sprite_blue_shoot_stage4_e1;
    wire [15:0] shoot_x_stage4_e1;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage4_e1;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage4_e1;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage4_e1;     // output되는 총알의 좌표 
//    wire enemy_shoot_stage4_e1;               // input 되는 총알을 보내라는 신호 

    // stage 4 enemy2 -> shoot projectile 
    wire sprite_hit_shoot_stage4_e2;
    wire [7:0] sprite_red_shoot_stage4_e2;
    wire [7:0] sprite_green_shoot_stage4_e2;
    wire [7:0] sprite_blue_shoot_stage4_e2;
    wire [15:0] shoot_x_stage4_e2;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage4_e2;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage4_e2;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage4_e2;     // output되는 총알의 좌표 
//    wire enemy_shoot_stage4_e2;               // input 되는 총알을 보내라는 신호 
    
    // stage 4 enemy3 -> shoot projectile 
    wire sprite_hit_shoot_stage4_e3;
    wire [7:0] sprite_red_shoot_stage4_e3;
    wire [7:0] sprite_green_shoot_stage4_e3;
    wire [7:0] sprite_blue_shoot_stage4_e3;
    wire [15:0] shoot_x_stage4_e3;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] shoot_y_stage4_e3;          // input되는 shoot 을 해야하는 위치 좌표 
    wire [15:0] sprite_shoot_x_stage4_e3;     // output되는 총알의 좌표 
    wire [15:0] sprite_shoot_y_stage4_e3;     // output되는 총알의 좌표 
//    wire enemy_shoot_stage4_e3;               // input 되는 총알을 보내라는 신호 

/////////////////////////////////// stage 5 ////////////////////////////////////
//    // stage 5 boss -> shoot projectile 
//    wire sprite_hit_shoot_stage5_boss;
//    wire [7:0] sprite_red_shoot_stage5_boss;
//    wire [7:0] sprite_green_shoot_stage5_boss;
//    wire [7:0] sprite_blue_shoot_stage5_boss;
//    wire [15:0] shoot_x_stage5_boss;          // input되는 shoot 을 해야하는 위치 좌표 
//    wire [15:0] shoot_y_stage5_boss;          // input되는 shoot 을 해야하는 위치 좌표 
//    wire [15:0] sprite_shoot_x_stage5_boss;     // output되는 총알의 좌표 
//    wire [15:0] sprite_shoot_y_stage5_boss;     // output되는 총알의 좌표 
//    wire enemy_shoot_stage5_boss;               // input 되는 총알을 보내라는 신호 


    ///////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////// clear stage //////////////////////////////////////////
    // clear stage
    wire sprite_hit_clear;
    wire [7:0] sprite_red_clear;
    wire [7:0] sprite_green_clear;
    wire [7:0] sprite_blue_clear;
    
    // clear stage2
    wire sprite_hit_clear2;
    wire [7:0] sprite_red_clear2;
    wire [7:0] sprite_green_clear2;
    wire [7:0] sprite_blue_clear2;
    
    // complete stage, clear stage 3
    wire sprite_hit_clear3;
    wire [7:0] sprite_red_clear3;
    wire [7:0] sprite_green_clear3;
    wire [7:0] sprite_blue_clear3;
    ////////////////////////////////////////////////////////////////////////////////////
    
   // 배경 
   test_card_simple test_card_simple_1(
            .i_x (i_x),
            .o_red      (bg_red),
            .o_green    (bg_green),
            .o_blue     (bg_blue),
            .o_bg_hit   (bg_hit)
            );
            
    ///////////////////////////// 적기 /////////////////////////////////////////////////////       
    // 아군 전투기 
      // 아군 전투기 
     sprite_compositor player (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .sw(sw),
        .o_red      (sprite_red_p1),
        .o_green    (sprite_green_p1),
        .o_blue     (sprite_blue_p1),
        .o_sprite_hit   (sprite_hit_p1),
        //////////////////////////////////////////////////////// 연결
        .sprite_x_pos(sprite_p1_x), // player의 output 좌표 
        .sprite_y_pos(sprite_p1_y),  // player 의 output 좌표 
        //////////////////////////////////////////////////////// 연결
        .life (life)
    );


    // 적군 전투기 1
    sprite_compositor_e1 enemy1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_e1),
        .o_green    (sprite_green_e1),
        .o_blue     (sprite_blue_e1),
        .o_sprite_hit   (sprite_hit_e1),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_e1_x),
        .shoot_y (shoot_e1_y),
        /////////////////모듈에 output 되는 x, y 좌표 //////////////////// 연결 
        .sprite_x_pos(sprite_e1_x),
        .sprite_y_pos(sprite_e1_y),
        //////////////////////////////////////////////////////// score
        .score(score_e1),
        .shoot_control(shoot_signal_e1),
        .hit_sig(s0_enemy_hit_sig)
    );
    
    // 적군 전투기 2
    sprite_compositor_e2 enemy2 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_e2),
        .o_green    (sprite_green_e2),
        .o_blue     (sprite_blue_e2),
        .o_sprite_hit   (sprite_hit_e2),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_e2_x),
        .shoot_y (shoot_e2_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_e2_x),
        .sprite_y_pos(sprite_e2_y),
        //////////////////////////////////////////////////////// score
        .score(score_e2),
        .shoot_control(shoot_signal_e2),
        ////////////////////////////////////////////////// 연결
        .hit_sig(s0_enemy_hit_sig)
    );
    
    // 적군 전투기 3
    sprite_compositor_e3 enemy3 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_e3),
        .o_green    (sprite_green_e3),
        .o_blue     (sprite_blue_e3),
        .o_sprite_hit   (sprite_hit_e3),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_e3_x),
        .shoot_y (shoot_e3_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_e3_x),
        .sprite_y_pos(sprite_e3_y),
        //////////////////////////////////////////////////////// score
        .score(score_e3),
        ////////////////////////////////////////////////// 연결
        .shoot_control(shoot_signal_e3),
        .hit_sig(s1_enemy_hit_sig)
    );
    
    // 적군 전투기 4
    sprite_compositor_e4 enemy4 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_e4),
        .o_green    (sprite_green_e4),
        .o_blue     (sprite_blue_e4),
        .o_sprite_hit   (sprite_hit_e4),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_e4_x),
        .shoot_y (shoot_e4_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_e4_x),
        .sprite_y_pos(sprite_e4_y),
        //////////////////////////////////////////////////////// score
        .score(score_e4),
        .shoot_control(shoot_signal_e4),
        ////////////////////////////////////////////////// 연결
        .hit_sig(s2_enemy_hit_sig)
    );
    
    // 적군 전투기 5
    sprite_compositor_e5 enemy5 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_e5),
        .o_green    (sprite_green_e5),
        .o_blue     (sprite_blue_e5),
        .o_sprite_hit   (sprite_hit_e5),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_e5_x),
        .shoot_y (shoot_e5_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_e5_x),
        .sprite_y_pos(sprite_e5_y),
        //////////////////////////////////////////////////////// score
        .score(score_e5),
        ////////////////////////////////////////////////// 연결
        .shoot_control(shoot_signal_e5),
        .hit_sig(s2_enemy_hit_sig)
    );
    
    ///////////////////////// STAGE 2 ///////////////////////////////////////
    ///////////////////////// stage 2 적군 전투기 ////////////////////////////
    // s2 적군 1 
    sprite_compositor_stage2_e1 stage2_enemy1 ( 
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e1),
        .o_green    (sprite_green_stage2_e1),
        .o_blue     (sprite_blue_stage2_e1),
        .o_sprite_hit   (sprite_hit_stage2_e1),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e1_x),
        .shoot_y (shoot_stage2_e1_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e1_x),
        .sprite_y_pos(sprite_stage2_e1_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e1),
        .hit_sig(s0_enemy_hit_sig),                     
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e1)
    );

    // s2 적군 2
    sprite_compositor_stage2_e2 stage2_enemy2 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e2),
        .o_green    (sprite_green_stage2_e2),
        .o_blue     (sprite_blue_stage2_e2),
        .o_sprite_hit   (sprite_hit_stage2_e2),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e2_x),
        .shoot_y (shoot_stage2_e2_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e2_x),
        .sprite_y_pos(sprite_stage2_e2_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e2),
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e2),
        .hit_sig(s0_enemy_hit_sig) 
    );
    // s2 적군 3
    sprite_compositor_stage2_e3 stage2_enemy3 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e3),
        .o_green    (sprite_green_stage2_e3),
        .o_blue     (sprite_blue_stage2_e3),
        .o_sprite_hit   (sprite_hit_stage2_e3),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e3_x),
        .shoot_y (shoot_stage2_e3_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e3_x),
        .sprite_y_pos(sprite_stage2_e3_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e3),
        .hit_sig(s0_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e3)
    );
    // s2 적군 4
    sprite_compositor_stage2_e4 stage2_enemy4 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e4),
        .o_green    (sprite_green_stage2_e4),
        .o_blue     (sprite_blue_stage2_e4),
        .o_sprite_hit   (sprite_hit_stage2_e4),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e4_x),
        .shoot_y (shoot_stage2_e4_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e4_x),
        .sprite_y_pos(sprite_stage2_e4_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e4),
        .hit_sig(s1_enemy_hit_sig) ,
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e4)
        
    );
    
    // s2 적군 5
    sprite_compositor_stage2_e5 stage2_enemy5 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e5),
        .o_green    (sprite_green_stage2_e5),
        .o_blue     (sprite_blue_stage2_e5),
        .o_sprite_hit   (sprite_hit_stage2_e5),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e5_x),
        .shoot_y (shoot_stage2_e5_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e5_x),
        .sprite_y_pos(sprite_stage2_e5_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e5),
        .hit_sig(s1_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e5)
    );
    
    // s2 적군 6
    sprite_compositor_stage2_e6 stage2_enemy6 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e6),
        .o_green    (sprite_green_stage2_e6),
        .o_blue     (sprite_blue_stage2_e6),
        .o_sprite_hit   (sprite_hit_stage2_e6),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e6_x),
        .shoot_y (shoot_stage2_e6_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e6_x),
        .sprite_y_pos(sprite_stage2_e6_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e6),
        .hit_sig(s1_enemy_hit_sig) ,
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e6)
    );
    
    // s2 적군 7
    sprite_compositor_stage2_e7 stage2_enemy7 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e7),
        .o_green    (sprite_green_stage2_e7),
        .o_blue     (sprite_blue_stage2_e7),
        .o_sprite_hit   (sprite_hit_stage2_e7),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e7_x),
        .shoot_y (shoot_stage2_e7_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e7_x),
        .sprite_y_pos(sprite_stage2_e7_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e7),
        .hit_sig(s1_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e7)
    );
    
    // s2 적군 8
    sprite_compositor_stage2_e8 stage2_enemy8 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e8),
        .o_green    (sprite_green_stage2_e8),
        .o_blue     (sprite_blue_stage2_e8),
        .o_sprite_hit   (sprite_hit_stage2_e8),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e8_x),
        .shoot_y (shoot_stage2_e8_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e8_x),
        .sprite_y_pos(sprite_stage2_e8_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e8),
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e8),
        .hit_sig(s2_enemy_hit_sig)
    );
    
    // s2 적군 9 
    sprite_compositor_stage2_e9 stage2_enemy9 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage2_e9),
        .o_green    (sprite_green_stage2_e9),
        .o_blue     (sprite_blue_stage2_e9),
        .o_sprite_hit   (sprite_hit_stage2_e9),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage2_e9_x),
        .shoot_y (shoot_stage2_e9_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage2_e9_x),
        .sprite_y_pos(sprite_stage2_e9_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage2_e9),
        .hit_sig(s2_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        .shoot_control(enemy_shoot_stage2_e9)
    );
    
    //////////////////////// STAGE 3 ////////////////////////////////////////////(code:938~1044)
    //////////////////////// stage3 enemy /////////////////////////////////////////
    // s3 적군 1 
    sprite_compositor_stage3_e1 stage3_enemy1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage3_e1),
        .o_green    (sprite_green_stage3_e1),
        .o_blue     (sprite_blue_stage3_e1),
        .o_sprite_hit   (sprite_hit_stage3_e1),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage3_e1_x),
        .shoot_y (shoot_stage3_e1_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage3_e1_x),
        .sprite_y_pos(sprite_stage3_e1_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage3_e1),
        .hit_sig(s3_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
//        .shoot_control(enemy_shoot_stage3_e1)
       //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );
    
    // s3 적군 2 
    sprite_compositor_stage3_e2 stage3_enemy2 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage3_e2),
        .o_green    (sprite_green_stage3_e2),
        .o_blue     (sprite_blue_stage3_e2),
        .o_sprite_hit   (sprite_hit_stage3_e2),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage3_e2_x),
        .shoot_y (shoot_stage3_e2_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage3_e2_x),
        .sprite_y_pos(sprite_stage3_e2_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage3_e2),
        .hit_sig(s3_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );
    
    // s3 적군 3 
    sprite_compositor_stage3_e3 stage3_enemy3 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage3_e3),
        .o_green    (sprite_green_stage3_e3),
        .o_blue     (sprite_blue_stage3_e3),
        .o_sprite_hit   (sprite_hit_stage3_e3),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage3_e3_x),
        .shoot_y (shoot_stage3_e3_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage3_e3_x),
        .sprite_y_pos(sprite_stage3_e3_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage3_e3),
        ////////////////////////////////////////////////// 연결
   //     .shoot_control(enemy_shoot_stage3_e3),
        /////////////////////////////////////////////////////
        .hit_sig(s3_enemy_hit_sig),
         //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)
 
    );
    
    // s3 적군 4 
    sprite_compositor_stage3_e4 stage3_enemy4 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage3_e4),
        .o_green    (sprite_green_stage3_e4),
        .o_blue     (sprite_blue_stage3_e4),
        .o_sprite_hit   (sprite_hit_stage3_e4),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage3_e4_x),
        .shoot_y (shoot_stage3_e4_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage3_e4_x),
        .sprite_y_pos(sprite_stage3_e4_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage3_e4),
        ///////////////////////////////////////////////////////////
        .hit_sig(s3_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );
    
    // s3 적군 5
    sprite_compositor_stage3_e5 stage3_enemy5 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage3_e5),
        .o_green    (sprite_green_stage3_e5),
        .o_blue     (sprite_blue_stage3_e5),
        .o_sprite_hit   (sprite_hit_stage3_e5),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage3_e5_x),
        .shoot_y (shoot_stage3_e5_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage3_e5_x),
        .sprite_y_pos(sprite_stage3_e5_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage3_e5),
     //   .shoot_control(enemy_shoot_stage3_e5),
     /////////////////////////////////////////////////////////
        .hit_sig(s3_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );
    
    ////////////////////// enemy big red ///////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////(code:1091~1117)
    //enemy_big_red_1
     enemy_big_red_1 enemy_big_red_1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_enemy_big_red_1),
        .o_green    (sprite_green_enemy_big_red_1),
        .o_blue     (sprite_blue_enemy_big_red_1),
        .o_sprite_hit   (sprite_hit_enemy_big_red_1),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_enemy_big_red_1_x),
        .shoot_y (shoot_enemy_big_red_1_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_enemy_big_red_1_x),
        .sprite_y_pos(sprite_enemy_big_red_1_y),
        //////////////////////////////////////////////////////// score
        .score(score_enemy_big_red_1),
     //   .shoot_control(enemy_shoot_stage3_e5),
     /////////////////////////////////////////////////////////
        .hit_sig(s3_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );  
 /////////////////////////////////stage 4//////////////////////////////////////////(code:1198~1277)
    // s4 적군 1
   enemy_big_red_green_1 stage4_enemy1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage4_e1),
        .o_green    (sprite_green_stage4_e1),
        .o_blue     (sprite_blue_stage4_e1),
        .o_sprite_hit   (sprite_hit_stage4_e1),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage4_e1_x),
        .shoot_y (shoot_stage4_e1_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage4_e1_x),
        .sprite_y_pos(sprite_stage4_e1_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage4_e1),
        .shoot_control(enemy_shoot_stage4_e1),
     /////////////////////////////////////////////////////////
        .hit_sig(s4_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    ); 
    // s4 적군 2
    enemy_big_red_green_2 stage4_enemy2 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage4_e2),
        .o_green    (sprite_green_stage4_e2),
        .o_blue     (sprite_blue_stage4_e2),
        .o_sprite_hit   (sprite_hit_stage4_e2),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage4_e2_x),
        .shoot_y (shoot_stage4_e2_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage4_e2_x),
        .sprite_y_pos(sprite_stage4_e2_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage4_e2),
        .shoot_control(enemy_shoot_stage4_e2),
     /////////////////////////////////////////////////////////
        .hit_sig(s4_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );
    // s4 적군 3
    enemy_big_red_green_3 stage4_enemy3 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_stage4_e3),
        .o_green    (sprite_green_stage4_e3),
        .o_blue     (sprite_blue_stage4_e3),
        .o_sprite_hit   (sprite_hit_stage4_e3),
        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_stage4_e3_x),
        .shoot_y (shoot_stage4_e3_y),
        ////////////////////////////////////////////////// 연결 
        .sprite_x_pos(sprite_stage4_e3_x),
        .sprite_y_pos(sprite_stage4_e3_y),
        //////////////////////////////////////////////////////// score
        .score(score_stage4_e3),
        .shoot_control(enemy_shoot_stage4_e3),
     /////////////////////////////////////////////////////////
        .hit_sig(s4_enemy_hit_sig), 
        ////////////////////////////////////////////////// 연결
        //////////////////player의 x,y좌표//////////////////////////
        .player_x_pos(sprite_p1_x),
        .player_y_pos(sprite_p1_y)

    );
///////////////////////////////////// boss 5 /////////////////////////////////////////////////////////////////////////////////
//    boss stage5_enemy_boss (
//        .i_x        (i_x),
//        .i_y        (i_y),
//        .i_v_sync   (i_v_sync),
//        .o_red      (sprite_red_stage5_boss),
//        .o_green    (sprite_green_stage5_boss),
//        .o_blue     (sprite_blue_stage5_boss),
//        .o_sprite_hit   (sprite_hit_stage5_boss),
//        ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
//        .shoot_x (shoot_stage5_boss_x),
//        .shoot_y (shoot_stage5_boss_y),
//        ////////////////////////////////////////////////// 연결 
//        .sprite_x_pos(sprite_stage5_boss_x),
//        .sprite_y_pos(sprite_stage5_boss_y),
//        //////////////////////////////////////////////////////// score
//        .score(score_stage5_boss),
//        .shoot_control(enemy_shoot_stage5_boss),
//     /////////////////////////////////////////////////////////
//        .hit_sig(s5_enemy_hit_sig), 
//        ////////////////////////////////////////////////// 연결
//        //////////////////player의 x,y좌표//////////////////////////
//        .player_x_pos(sprite_p1_x),
//        .player_y_pos(sprite_p1_y)

//    );
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////

    
    // 학번
    sprite_compositor_3 id (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .o_red      (sprite_red3),
        .o_green    (sprite_green3),
        .o_blue     (sprite_blue3),
        .o_sprite_hit   (sprite_hit3)
    );
    
    ///////////////////////////////////////// score ///////////////////////////////////////////////////
    // score = 0 
    sprite_compositor_4 score0 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .o_red      (sprite_red4),
        .o_green    (sprite_green4),
        .o_blue     (sprite_blue4),
        .o_sprite_hit   (sprite_hit4)
    );
    
    // score = 1 
    sprite_compositor_score_1 score1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s1),
        .o_green    (sprite_green_s1),
        .o_blue     (sprite_blue_s1),
        .o_sprite_hit   (sprite_hit_s1)
    );
    
    // score = 2 
    sprite_compositor_score_2 score2 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s2),
        .o_green    (sprite_green_s2),
        .o_blue     (sprite_blue_s2),
        .o_sprite_hit   (sprite_hit_s2)
    );
    
    // score = 3 
    sprite_compositor_score_3 score3 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s3),
        .o_green    (sprite_green_s3),
        .o_blue     (sprite_blue_s3),
        .o_sprite_hit   (sprite_hit_s3)
    );
    
    // score = 4 
    sprite_compositor_score_4 score4 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s4),
        .o_green    (sprite_green_s4),
        .o_blue     (sprite_blue_s4),
        .o_sprite_hit   (sprite_hit_s4)
    );
    
    // score = 5 
    sprite_compositor_score_5 score5 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s5),
        .o_green    (sprite_green_s5),
        .o_blue     (sprite_blue_s5),
        .o_sprite_hit   (sprite_hit_s5)
    );
    
    // score = 6
    sprite_compositor_score_6 score6 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s6),
        .o_green    (sprite_green_s6),
        .o_blue     (sprite_blue_s6),
        .o_sprite_hit   (sprite_hit_s6)
    );
    
    // score = 7
    sprite_compositor_score_7 score7 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s7),
        .o_green    (sprite_green_s7),
        .o_blue     (sprite_blue_s7),
        .o_sprite_hit   (sprite_hit_s7)
    );
    
    // score = 8
    sprite_compositor_score_8 score8 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s8),
        .o_green    (sprite_green_s8),
        .o_blue     (sprite_blue_s8),
        .o_sprite_hit   (sprite_hit_s8)
    );
    
    // score = 9
    sprite_compositor_score_9 score9 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s9),
        .o_green    (sprite_green_s9),
        .o_blue     (sprite_blue_s9),
        .o_sprite_hit   (sprite_hit_s9)
    );
    
    // score = 10
    sprite_compositor_score_10 score10 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s10),
        .o_green    (sprite_green_s10),
        .o_blue     (sprite_blue_s10),
        .o_sprite_hit   (sprite_hit_s10)
    );
    
    // score = 11
    sprite_compositor_score_11 score11 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s11),
        .o_green    (sprite_green_s11),
        .o_blue     (sprite_blue_s11),
        .o_sprite_hit   (sprite_hit_s11)
    );
    
    // score = 12
    sprite_compositor_score_12 score12 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s12),
        .o_green    (sprite_green_s12),
        .o_blue     (sprite_blue_s12),
        .o_sprite_hit   (sprite_hit_s12)
    );
    
    // score = 13
    sprite_compositor_score_13 score13 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s13),
        .o_green    (sprite_green_s13),
        .o_blue     (sprite_blue_s13),
        .o_sprite_hit   (sprite_hit_s13)
    );
    
    // score = 14
    sprite_compositor_score_14 score14 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s14),
        .o_green    (sprite_green_s14),
        .o_blue     (sprite_blue_s14),
        .o_sprite_hit   (sprite_hit_s14)
    );
    
    // score = 15
    sprite_compositor_score_15 score15 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s15),
        .o_green    (sprite_green_s15),
        .o_blue     (sprite_blue_s15),
        .o_sprite_hit   (sprite_hit_s15)
    );
    
    // score = 16
    sprite_compositor_score_16 score16 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s16),
        .o_green    (sprite_green_s16),
        .o_blue     (sprite_blue_s16),
        .o_sprite_hit   (sprite_hit_s16)
    );
    
    // score = 17
    sprite_compositor_score_17 score17 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s17),
        .o_green    (sprite_green_s17),
        .o_blue     (sprite_blue_s17),
        .o_sprite_hit   (sprite_hit_s17)
    );
    
    // score = 18
    sprite_compositor_score_18 score18 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s18),
        .o_green    (sprite_green_s18),
        .o_blue     (sprite_blue_s18),
        .o_sprite_hit   (sprite_hit_s18)
    );
    
    // score = 19
    sprite_compositor_score_19 score19 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s19),
        .o_green    (sprite_green_s19),
        .o_blue     (sprite_blue_s19),
        .o_sprite_hit   (sprite_hit_s19)
    );
    
    // score = 20
    sprite_compositor_score_20 score20 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s20),
        .o_green    (sprite_green_s20),
        .o_blue     (sprite_blue_s20),
        .o_sprite_hit   (sprite_hit_s20)
    );
    
    // score = 21
    sprite_compositor_score_21 score21 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s21),
        .o_green    (sprite_green_s21),
        .o_blue     (sprite_blue_s21),
        .o_sprite_hit   (sprite_hit_s21)
    );
    
    // score = 22
    sprite_compositor_score_22 score22 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s22),
        .o_green    (sprite_green_s22),
        .o_blue     (sprite_blue_s22),
        .o_sprite_hit   (sprite_hit_s22)
    );
    
    // score = 23
    sprite_compositor_score_23 score23 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_s23),
        .o_green    (sprite_green_s23),
        .o_blue     (sprite_blue_s23),
        .o_sprite_hit   (sprite_hit_s23)
    );
    ///////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////// life ////////////////////////////////////////////////
    // life:3
    sprite_compositor_5 life3 ( // life : 3 인상태 
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_life3),
        .o_green    (sprite_green_life3),
        .o_blue     (sprite_blue_life3),
        .o_sprite_hit   (sprite_hit_life3)
    );
    // life:2
    sprite_compositor_life2 life2 ( // life : 2 인상태 
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_life2),
        .o_green    (sprite_green_life2),
        .o_blue     (sprite_blue_life2),
        .o_sprite_hit   (sprite_hit_life2)
    );
    // life:1
    sprite_compositor_life1 life1 ( // life : 1 인상태 
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_life1),
        .o_green    (sprite_green_life1),
        .o_blue     (sprite_blue_life1),
        .o_sprite_hit   (sprite_hit_life1)
    );
    // life:0
    sprite_compositor_life0 life0 ( // life : 0 인상태 
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_life0),
        .o_green    (sprite_green_life0),
        .o_blue     (sprite_blue_life0),
        .o_sprite_hit   (sprite_hit_life0)
    );
    ///////////////////// shoot projectile ///////////////////////////////////////////////////
    ///////////////////////// shoot projectile player //////////////////////////
    sprite_compositor_6 player_projectile (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_p),
        .o_green    (sprite_green_shoot_p),
        .o_blue     (sprite_blue_shoot_p),
        .o_sprite_hit   (sprite_hit_shoot_p),
        .btn2             (btn2),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_p),
        .sprite_y_pos(sprite_shoot_y_p),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_p),
        .shoot_y (shoot_y_p),
        .projectile_image(projectile_image)
        ///////////////////////////////////////////////////////// 연결 
        
    );
    /////////////////// enemy shoot projectile ///////////////////////
    ////////////////// stage 1 //////////////////////
    // shoot projectile stage 1 enemy 1
    enemy_stage1_projectile enemy_projectile1(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_e1),
        .o_green    (sprite_green_shoot_e1),
        .o_blue     (sprite_blue_shoot_e1),
        .o_sprite_hit   (sprite_hit_shoot_e1),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_e1),
        .sprite_y_pos(sprite_shoot_y_e1),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_e1),
        .shoot_y (shoot_y_e1),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_e1)
    );
    
    enemy_stage1_projectile enemy_projectile2(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_e2),
        .o_green    (sprite_green_shoot_e2),
        .o_blue     (sprite_blue_shoot_e2),
        .o_sprite_hit   (sprite_hit_shoot_e2),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_e2),
        .sprite_y_pos(sprite_shoot_y_e2),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_e2),
        .shoot_y (shoot_y_e2),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_e2)
    );
    
     // shoot projectile stage 1 enemy 3
    enemy_stage1_projectile enemy_projectile3(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_e3),
        .o_green    (sprite_green_shoot_e3),
        .o_blue     (sprite_blue_shoot_e3),
        .o_sprite_hit   (sprite_hit_shoot_e3),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_e3),
        .sprite_y_pos(sprite_shoot_y_e3),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_e3),
        .shoot_y (shoot_y_e3),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_e3)
    );
     // shoot projectile stage 1 enemy 4
    enemy_stage1_projectile enemy_projectile4(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_e4),
        .o_green    (sprite_green_shoot_e4),
        .o_blue     (sprite_blue_shoot_e4),
        .o_sprite_hit   (sprite_hit_shoot_e4),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_e4),
        .sprite_y_pos(sprite_shoot_y_e4),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_e4),
        .shoot_y (shoot_y_e4),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_e4)
    );
     // shoot projectile stage 1 enemy 5
    enemy_stage1_projectile enemy_projectile5(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_e5),
        .o_green    (sprite_green_shoot_e5),
        .o_blue     (sprite_blue_shoot_e5),
        .o_sprite_hit   (sprite_hit_shoot_e5),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_e5),
        .sprite_y_pos(sprite_shoot_y_e5),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_e5),
        .shoot_y (shoot_y_e5),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_e5)
    );
    
    ////////////////// stage 2 //////////////////////
     // shoot projectile stage 2 enemy 1
     sprite_compositor_e_projectile enemy_projectile2_1(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e1),
        .o_green    (sprite_green_shoot_stage2_e1),
        .o_blue     (sprite_blue_shoot_stage2_e1),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e1),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e1),
        .sprite_y_pos(sprite_shoot_y_stage2_e1),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e1),
        .shoot_y (shoot_y_stage2_e1),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e1)
    );
    
     // shoot projectile stage 2 enemy 2
     sprite_compositor_e_projectile enemy_projectile2_2(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e2),
        .o_green    (sprite_green_shoot_stage2_e2),
        .o_blue     (sprite_blue_shoot_stage2_e2),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e2),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e2),
        .sprite_y_pos(sprite_shoot_y_stage2_e2),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e2),
        .shoot_y (shoot_y_stage2_e2),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e2)
    );
    
     // shoot projectile stage 2 enemy 3
     sprite_compositor_e_projectile enemy_projectile2_3(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e3),
        .o_green    (sprite_green_shoot_stage2_e3),
        .o_blue     (sprite_blue_shoot_stage2_e3),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e3),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e3),
        .sprite_y_pos(sprite_shoot_y_stage2_e3),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e3),
        .shoot_y (shoot_y_stage2_e3),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e3)
    );
    
    // shoot projectile stage 2 enemy 4
     sprite_compositor_e_projectile enemy_projectile2_4(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e4),
        .o_green    (sprite_green_shoot_stage2_e4),
        .o_blue     (sprite_blue_shoot_stage2_e4),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e4),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e4),
        .sprite_y_pos(sprite_shoot_y_stage2_e4),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e4),
        .shoot_y (shoot_y_stage2_e4),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e4)
    );
     // shoot projectile stage 2 enemy 5
     sprite_compositor_e_projectile enemy_projectile2_5(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e5),
        .o_green    (sprite_green_shoot_stage2_e5),
        .o_blue     (sprite_blue_shoot_stage2_e5),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e5),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e5),
        .sprite_y_pos(sprite_shoot_y_stage2_e5),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e5),
        .shoot_y (shoot_y_stage2_e5),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e5)
    );
    // shoot projectile stage 2 enemy 6
     sprite_compositor_e_projectile enemy_projectile2_6(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e6),
        .o_green    (sprite_green_shoot_stage2_e6),
        .o_blue     (sprite_blue_shoot_stage2_e6),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e6),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e6),
        .sprite_y_pos(sprite_shoot_y_stage2_e6),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e6),
        .shoot_y (shoot_y_stage2_e6),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e6)
    );
     // shoot projectile stage 2 enemy 7
     sprite_compositor_e_projectile enemy_projectile2_7(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e7),
        .o_green    (sprite_green_shoot_stage2_e7),
        .o_blue     (sprite_blue_shoot_stage2_e7),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e7),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e7),
        .sprite_y_pos(sprite_shoot_y_stage2_e7),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e7),
        .shoot_y (shoot_y_stage2_e7),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e7)
    );
    
    // shoot projectile stage 2 enemy 8
     sprite_compositor_e_projectile enemy_projectile2_8(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e8),
        .o_green    (sprite_green_shoot_stage2_e8),
        .o_blue     (sprite_blue_shoot_stage2_e8),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e8),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e8),
        .sprite_y_pos(sprite_shoot_y_stage2_e8),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e8),
        .shoot_y (shoot_y_stage2_e8),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e8)
    );
     // shoot projectile stage 2 enemy 9
     sprite_compositor_e_projectile enemy_projectile2_9(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage2_e9),
        .o_green    (sprite_green_shoot_stage2_e9),
        .o_blue     (sprite_blue_shoot_stage2_e9),
        .o_sprite_hit   (sprite_hit_shoot_stage2_e9),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage2_e9),
        .sprite_y_pos(sprite_shoot_y_stage2_e9),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage2_e9),
        .shoot_y (shoot_y_stage2_e9),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage2_e9)
    );
        ////////////////// stage 4 //////////////////////(code:1541~1608)
    // shoot projectile stage 4 enemy 1
     sprite_compositor_s4_projectile enemy_projectile4_1(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage4_e1),
        .o_green    (sprite_green_shoot_stage4_e1),
        .o_blue     (sprite_blue_shoot_stage4_e1),
        .o_sprite_hit   (sprite_hit_shoot_stage4_e1),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage4_e1),
        .sprite_y_pos(sprite_shoot_y_stage4_e1),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage4_e1),
        .shoot_y (shoot_y_stage4_e1),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage4_e1)
    );
    
        // shoot projectile stage 2 enemy 9
     sprite_compositor_s4_projectile enemy_projectile4_2(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage4_e2),
        .o_green    (sprite_green_shoot_stage4_e2),
        .o_blue     (sprite_blue_shoot_stage4_e2),
        .o_sprite_hit   (sprite_hit_shoot_stage4_e2),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage4_e2),
        .sprite_y_pos(sprite_shoot_y_stage4_e2),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage4_e2),
        .shoot_y (shoot_y_stage4_e2),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage4_e2)
    );
    
        // shoot projectile stage 2 enemy 9
     sprite_compositor_s4_projectile enemy_projectile4_3(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_shoot_stage4_e3),
        .o_green    (sprite_green_shoot_stage4_e3),
        .o_blue     (sprite_blue_shoot_stage4_e3),
        .o_sprite_hit   (sprite_hit_shoot_stage4_e3),
        ///// 총알 output 좌표 /////
        .sprite_x_pos(sprite_shoot_x_stage4_e3),
        .sprite_y_pos(sprite_shoot_y_stage4_e3),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        .shoot_x (shoot_x_stage4_e3),
        .shoot_y (shoot_y_stage4_e3),
        ///////////////////////////////////////////////////////// 연결 
        .enemy_shoot_signal (enemy_shoot_stage4_e3)
    );
    
//    /////////////////////////////// stage 5 ///////////////////////////////
//        // shoot projectile stage 2 enemy 9
//     sprite_compositor_boss_projectile enemy_projectile5_boss(
//        .i_x        (i_x),
//        .i_y        (i_y),
//        .i_v_sync   (i_v_sync),
//        .o_red      (sprite_red_shoot_stage5_boss),
//        .o_green    (sprite_green_shoot_stage5_boss),
//        .o_blue     (sprite_blue_shoot_stage5_boss),
//        .o_sprite_hit   (sprite_hit_shoot_stage5_boss),
//        ///// 총알 output 좌표 /////
//        .sprite_x_pos(sprite_shoot_x_stage5_boss),
//        .sprite_y_pos(sprite_shoot_y_stage5_boss),
//         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
//        .shoot_x (shoot_x_stage5_boss),
//        .shoot_y (shoot_y_stage5_boss),
//        ///////////////////////////////////////////////////////// 연결 
//        .enemy_shoot_signal (enemy_shoot_stage5_boss)
//    );
    

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// item ///////////////////////////////////////////////////////// gfx line 1910~1943
    item item1 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_item1),
        .o_green    (sprite_green_item1),
        .o_blue     (sprite_blue_item1),
        .o_sprite_hit   (sprite_hit_item1),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결
        /////////////////모듈에 output 되는 x, y 좌표 //////////////////// 연결 
        .sprite_x_pos(sprite_item1_x),
        .sprite_y_pos(sprite_item1_y),
        .item_begin(item1_begin)
    );
    
    item2 item2 (
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_item2),
        .o_green    (sprite_green_item2),
        .o_blue     (sprite_blue_item2),
        .o_sprite_hit   (sprite_hit_item2),
         ////////////////모듈에 input 되는 x, y 좌표///////////////////////////////// 연결

        /////////////////모듈에 output 되는 x, y 좌표 //////////////////// 연결 
        .sprite_x_pos(sprite_item2_x),
        .sprite_y_pos(sprite_item2_y),
        .item_begin(item2_begin)
    );
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////// clear stage ////////////////////////////////////////////
    // clear stage1
    sprite_compositor_clear game_over(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_clear),
        .o_green    (sprite_green_clear),
        .o_blue     (sprite_blue_clear),
        .o_sprite_hit   (sprite_hit_clear),
        .hit_signal (clear_hit_sig)
        );
        
    // clear stage2
    sprite_compositor_clear2 clear_stage2(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_clear2),
        .o_green    (sprite_green_clear2),
        .o_blue     (sprite_blue_clear2),
        .o_sprite_hit   (sprite_hit_clear2),
        .sw (sw)
        );
        
    // clear stage3 , -> complete game
    sprite_compositor_clear3 complete_stage(
        .i_x        (i_x),
        .i_y        (i_y),
        .i_v_sync   (i_v_sync),
        .o_red      (sprite_red_clear3),
        .o_green    (sprite_green_clear3),
        .o_blue     (sprite_blue_clear3),
        .o_sprite_hit   (sprite_hit_clear3),
        .sw (sw)
        );
        
      ////////////////////////////////// item ////////////////////////////////////	gfx line 2147~ 2151
    reg item_1_begin = 0;   assign item1_begin = item_1_begin;
    reg item_2_begin = 0;   assign item2_begin = item_2_begin;
    reg [2:0] projectile_img_select = 0; assign projectile_image = projectile_img_select;   
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////    
    assign shoot_x_p = sprite_p1_x;    // 플레이어 x좌표 인스턴스화 한 값 연결 
    assign shoot_y_p = sprite_p1_y;    // 플레이어 y좌표 인스턴스화 한 값 연결 
    
    /////////////////적기와 총알 충돌, 총알 좌표를 적기 모듈의 input 값으로 연결해준다 ///////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    // stage 1 //  // 각 적기 모듈 내에서 독립적으로 동작 정의함. input으로 player 총알의위치 값을 넣어줘서 모듈내에서 각 독립적으로 동작 정의 
    assign shoot_e1_x = sprite_shoot_x_p; // shoot_e1_x = projectile 의 위치 적기 모듈에서 input값 -> 이를 input으로 받아 적기 모듈에서 적기의 위치범위내 있으면 적기를 사라지게 한다.
                                          // sprite_shoot_x_p = player가 쏜 총알의 위치 output 값 
    assign shoot_e1_y = sprite_shoot_y_p;
    assign shoot_e2_x = sprite_shoot_x_p;
    assign shoot_e2_y = sprite_shoot_y_p;
    assign shoot_e3_x = sprite_shoot_x_p;
    assign shoot_e3_y = sprite_shoot_y_p;
    assign shoot_e4_x = sprite_shoot_x_p;
    assign shoot_e4_y = sprite_shoot_y_p;
    assign shoot_e5_x = sprite_shoot_x_p;
    assign shoot_e5_y = sprite_shoot_y_p;
    
    // stage 2 // 
    assign shoot_stage2_e1_x = sprite_shoot_x_p;
    assign shoot_stage2_e1_y = sprite_shoot_y_p;
    assign shoot_stage2_e2_x = sprite_shoot_x_p;
    assign shoot_stage2_e2_y = sprite_shoot_y_p;
    assign shoot_stage2_e3_x = sprite_shoot_x_p;
    assign shoot_stage2_e3_y = sprite_shoot_y_p;
    assign shoot_stage2_e4_x = sprite_shoot_x_p;
    assign shoot_stage2_e4_y = sprite_shoot_y_p;
    assign shoot_stage2_e5_x = sprite_shoot_x_p;
    assign shoot_stage2_e5_y = sprite_shoot_y_p;
    assign shoot_stage2_e6_x = sprite_shoot_x_p;
    assign shoot_stage2_e6_y = sprite_shoot_y_p;
    assign shoot_stage2_e7_x = sprite_shoot_x_p;
    assign shoot_stage2_e7_y = sprite_shoot_y_p;
    assign shoot_stage2_e8_x = sprite_shoot_x_p;
    assign shoot_stage2_e8_y = sprite_shoot_y_p;
    assign shoot_stage2_e9_x = sprite_shoot_x_p;
    assign shoot_stage2_e9_y = sprite_shoot_y_p;
    
    // stage 3 // 
    assign shoot_stage3_e1_x = sprite_shoot_x_p;
    assign shoot_stage3_e1_y = sprite_shoot_y_p;
    assign shoot_stage3_e2_x = sprite_shoot_x_p;
    assign shoot_stage3_e2_y = sprite_shoot_y_p;
    assign shoot_stage3_e3_x = sprite_shoot_x_p;
    assign shoot_stage3_e3_y = sprite_shoot_y_p;
    assign shoot_stage3_e4_x = sprite_shoot_x_p;
    assign shoot_stage3_e4_y = sprite_shoot_y_p;
    assign shoot_stage3_e5_x = sprite_shoot_x_p;
    assign shoot_stage3_e5_y = sprite_shoot_y_p;
    
    // satge // 
    assign shoot_enemy_big_red_1_x = sprite_shoot_x_p;
    assign shoot_enemy_big_red_1_y = sprite_shoot_y_p;
    
    // stage 4 //    
    assign shoot_stage4_e1_x = sprite_shoot_x_p;
    assign shoot_stage4_e1_y = sprite_shoot_y_p;
    assign shoot_stage4_e2_x = sprite_shoot_x_p;
    assign shoot_stage4_e2_y = sprite_shoot_y_p;
    assign shoot_stage4_e3_x = sprite_shoot_x_p;
    assign shoot_stage4_e3_y = sprite_shoot_y_p;
   
//    //stage 5//
//    assign shoot_stage5_boss_x = sprite_shoot_x_p;
//    assign shoot_stage5_boss_y = sprite_shoot_y_p;
    
    ////////// enemy projectile /////////////////////////// // enemy projectile 은 projectile에 player가 hit 되는 조건 및 동작을 gfx에서 정의함. 
    // stage 1 //// 
    assign enemy_shoot_e1 = shoot_signal_e1;    // enemy 에게 총알을 보내라는 신호를 assign 
    assign shoot_x_e1 = sprite_e1_x;            // 좌항이 enemy projectile에 보내는 신호이고 우항이 적기의 좌표 
    assign shoot_y_e1 = sprite_e1_y;            // 즉 enemy projectile에 적기의 현재 위치를 보내고 그 자리에서 총알을 쏘게 함 
    
    assign enemy_shoot_e2 = shoot_signal_e2;
    assign shoot_x_e2 = sprite_e2_x;
    assign shoot_y_e2 = sprite_e2_y;
    
    assign enemy_shoot_e3 = shoot_signal_e3;    // stage1,2,3 동일 
    assign shoot_x_e3 = sprite_e3_x;
    assign shoot_y_e3 = sprite_e3_y;
    
    assign enemy_shoot_e4 = shoot_signal_e4;
    assign shoot_x_e4 = sprite_e4_x;
    assign shoot_y_e4 = sprite_e4_y;
    
    assign enemy_shoot_e5 = shoot_signal_e5;
    assign shoot_x_e5 = sprite_e5_x;
    assign shoot_y_e5 = sprite_e5_y;
    
    // stage 2 //
    assign enemy_shoot_stage2_e1 = shoot_signal_stage2_e1;
    assign shoot_x_stage2_e1 = sprite_stage2_e1_x;  // shoot_x_stage2_e2
    assign shoot_y_stage2_e1 = sprite_stage2_e1_y;
    
    assign enemy_shoot_stage2_e2 = shoot_signal_stage2_e2;
    assign shoot_x_stage2_e2 = sprite_stage2_e2_x;  // shoot_x_stage2_e2
    assign shoot_y_stage2_e2 = sprite_stage2_e2_y;
    
    assign enemy_shoot_stage2_e3 = shoot_signal_stage2_e3;
    assign shoot_x_stage2_e3 = sprite_stage2_e3_x;  // shoot_x_stage2_e2
    assign shoot_y_stage2_e3 = sprite_stage2_e3_y;

    assign enemy_shoot_stage2_e4 = shoot_signal_stage2_e4;
    assign shoot_x_stage2_e4 = sprite_stage2_e4_x;  // shoot_x_stage2_e4
    assign shoot_y_stage2_e4 = sprite_stage2_e4_y;
    
    assign enemy_shoot_stage2_e5 = shoot_signal_stage2_e5;
    assign shoot_x_stage2_e5 = sprite_stage2_e5_x;  // shoot_x_stage2_e2
    assign shoot_y_stage2_e5 = sprite_stage2_e5_y;
    
    assign enemy_shoot_stage2_e6 = shoot_signal_stage2_e6;
    assign shoot_x_stage2_e6 = sprite_stage2_e6_x;  // shoot_x_stage2_e6
    assign shoot_y_stage2_e6 = sprite_stage2_e6_y;
    
    assign enemy_shoot_stage2_e7 = shoot_signal_stage2_e7;
    assign shoot_x_stage2_e7 = sprite_stage2_e7_x;  // shoot_x_stage2_e2
    assign shoot_y_stage2_e7 = sprite_stage2_e7_y;
    
    assign enemy_shoot_stage2_e8 = shoot_signal_stage2_e8;
    assign shoot_x_stage2_e8 = sprite_stage2_e8_x;  // shoot_x_stage2_e8
    assign shoot_y_stage2_e8 = sprite_stage2_e8_y;
    
    assign enemy_shoot_stage2_e9 = shoot_signal_stage2_e9;
    assign shoot_x_stage2_e9 = sprite_stage2_e9_x;  // shoot_x_stage2_e2
    assign shoot_y_stage2_e9 = sprite_stage2_e9_y;
    
    /////////////////////////// stage 4 ////////////////////////
    assign enemy_shoot_stage4_e1 = shoot_signal_stage4_e1;
    assign shoot_x_stage4_e1 = sprite_stage4_e1_x;  // shoot_x_stage2_e2
    assign shoot_y_stage4_e1 = sprite_stage4_e1_y;

    assign enemy_shoot_stage4_e2 = shoot_signal_stage4_e2;
    assign shoot_x_stage4_e2 = sprite_stage4_e2_x;  // shoot_x_stage2_e2
    assign shoot_y_stage4_e2 = sprite_stage4_e2_y;

    assign enemy_shoot_stage4_e3 = shoot_signal_stage4_e3;
    assign shoot_x_stage4_e3 = sprite_stage4_e3_x;  // shoot_x_stage2_e2
    assign shoot_y_stage4_e3 = sprite_stage4_e3_y;

////////////////////////////////////stage 5////////////////////////////////
//    assign enemy_shoot_stage5_boss = shoot_signal_stage5_boss;
//    assign shoot_x_stage5_boss = sprite_stage5_boss_x;  // shoot_x_stage2_e2
//    assign shoot_y_stage5_boss = sprite_stage5_boss_y;


/////////////////////////////////// stage 0 ////////////////////////////////////////////
    assign s0_enemy_hit_sig = s0_hit_sig;
    
    ///////////////////////////////// stage 1 /////////////////////////////////////////
    assign s1_enemy_hit_sig = s1_hit_sig;
    
    ///////////////////////////////// stage 2 /////////////////////////////////////////
    assign s2_enemy_hit_sig = s2_hit_sig;
    
    //////////////////////////// stage 3///////////////////////////////////////////////////////
    assign s3_enemy_hit_sig = s3_hit_sig;
    
    ///////////////////////////// stage 4 ////////////////////////////////////////////////////////////////////////(code:1985~1986)
    assign s4_enemy_hit_sig = s4_hit_sig;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////// stage 5 ////////////////////////////////////////////////////////////////
//    assign s5_enemy_hit_sig = s5_hit_sig;
    ///////////////////////////////////////////////////////////////////
    
  // stage 3 //(code:1727~1738)
//    assign enemy_shoot_stage3_e1 = shoot_signal_stage3_e1;
//    assign shoot_x_stage3_e1 = sprite_stage3_e1_x;  // shoot_x_stage3_e1
//    assign shoot_y_stage3_e1 = sprite_stage3_e1_y;
    
 //   assign enemy_shoot_stage3_e3 = shoot_signal_stage3_e3;
 //   assign shoot_x_stage3_e3 = sprite_stage3_e3_x;  // shoot_x_stage3_e3
 //   assign shoot_y_stage3_e3 = sprite_stage3_e3_y;
    
//    assign enemy_shoot_stage3_e5 = shoot_signal_stage3_e5;
 //   assign shoot_x_stage3_e5 = sprite_stage3_e5_x;  // shoot_x_stage3_e5
 //   assign shoot_y_stage3_e5 = sprite_stage3_e5_y;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    //////////////////////////////// enemy display /////////////////////////
    //////////////////////////////// enemy display !!! ///////////////////////////
//    reg e1_image_hitsig = 0; assign e1_image_hit = e1_image_hitsig;
//    reg e2_image_hitsig = 0; assign e2_image_hit = e2_image_hitsig;
//    reg e3_image_hitsig = 0; assign e3_image_hit = e3_image_hitsig;
//    reg e4_image_hitsig = 0; assign e4_image_hit = e4_image_hitsig;
//    reg e5_image_hitsig = 0; assign e5_image_hit = e5_image_hitsig;
    
//    reg s2_e1_image_hitsig = 0; assign s2_e1_image_hit = s2_e1_image_hitsig;
//    reg s2_e2_image_hitsig = 0; assign s2_e2_image_hit = s2_e2_image_hitsig;
//    reg s2_e3_image_hitsig = 0; assign s2_e3_image_hit = s2_e3_image_hitsig;
//    reg s2_e4_image_hitsig = 0; assign s2_e4_image_hit = s2_e4_image_hitsig;
//    reg s2_e5_image_hitsig = 0; assign s2_e5_image_hit = s2_e5_image_hitsig;
//    reg s2_e6_image_hitsig = 0; assign s2_e6_image_hit = s2_e6_image_hitsig;
//    reg s2_e7_image_hitsig = 0; assign s2_e7_image_hit = s2_e7_image_hitsig;
//    reg s2_e8_image_hitsig = 0; assign s2_e8_image_hit = s2_e8_image_hitsig;
//    reg s2_e9_image_hitsig = 0; assign s2_e9_image_hit = s2_e9_image_hitsig;
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//    ////////////// life ////////////////
    assign life = life_control;
    //////////////////// life calculate ///////////////////////////////////////////////////////////////////////////////////////////
    // life 계산을 위한 플레이어 모듈의 좌표를 불러오고, 이것이 적이 쏜 총알이랑 위치가 맞을 때 life_control을 1 감소시킴 -> life_control은 life와 assign 됨 
    // -> player 모듈에서 플레이어의 색을 정하는데 사용됨 (selected pallette)
    always@(posedge i_v_sync) begin
     // enemy 1 shoot 
    
    // stage 0 //
    if ((s0_hit_sig ==1) && (sprite_shoot_x_e1 > sprite_p1_x+ 32 ) && (sprite_shoot_x_e1 < sprite_p1_x+52) && (sprite_shoot_y_e1 + 28 > sprite_p1_y) && (sprite_shoot_y_e1 +28 < sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;             
    else if ((s0_hit_sig ==1) && (sprite_shoot_x_e2 >= sprite_p1_x + 32) && (sprite_shoot_x_e2 < sprite_p1_x+52) && (sprite_shoot_y_e2 + 28 >= sprite_p1_y) && (sprite_shoot_y_e2 +28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;               
    else if ((s0_hit_sig ==1) && (sprite_shoot_x_stage2_e1 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e1 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e1 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e1 +28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;
    else if ((s0_hit_sig ==1) && (sprite_shoot_x_stage2_e2 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e2 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e2 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e2 + 28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;
    else if ((s0_hit_sig ==1) && (sprite_shoot_x_stage2_e3 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e3 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e3 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e3 + 28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;       
        
       // stage 1 //
    else if ((s1_hit_sig ==1) && (sprite_shoot_x_e3 > sprite_p1_x+ 32 ) && (sprite_shoot_x_e3 < sprite_p1_x+52) && (sprite_shoot_y_e3 + 28 > sprite_p1_y) && (sprite_shoot_y_e3 +28 < sprite_p1_y +6) && (life_control != 0))
        life_control = life_control - 1 ;             
    else if ((s1_hit_sig ==1) && (sprite_shoot_x_stage2_e4 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e4 < sprite_p1_x+52) && (sprite_shoot_y_stage2_e4 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e4 +28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;               
    else if ((s1_hit_sig ==1) && (sprite_shoot_x_stage2_e5 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e5 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e5 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e5 +28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;
    else if ((s1_hit_sig ==1) && (sprite_shoot_x_stage2_e6 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e6 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e6 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e6 + 28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;
    else if ((s1_hit_sig ==1) && (sprite_shoot_x_stage2_e7 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e7 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e7 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e7 + 28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;  
        
        
     // stage 2 //
    else if ((s2_hit_sig ==1) && (sprite_shoot_x_e4 > sprite_p1_x+ 32 ) && (sprite_shoot_x_e4 < sprite_p1_x+52) && (sprite_shoot_y_e4 + 28 > sprite_p1_y) && (sprite_shoot_y_e4 +28 < sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;             
    else if ((s2_hit_sig ==1) && (sprite_shoot_x_e5 >= sprite_p1_x + 32) && (sprite_shoot_x_e5 < sprite_p1_x+52) && (sprite_shoot_y_e5 + 28 >= sprite_p1_y) && (sprite_shoot_y_e5 +28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;               
    else if ((s2_hit_sig ==1) && (sprite_shoot_x_stage2_e8 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e8 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e8 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e8 +28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;
    else if ((s2_hit_sig ==1) && (sprite_shoot_x_stage2_e8 >= sprite_p1_x + 32) && (sprite_shoot_x_stage2_e9 < sprite_p1_x+ 52) && (sprite_shoot_y_stage2_e9 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage2_e9 + 28 <sprite_p1_y +3) && (life_control != 0))
        life_control = life_control - 1 ;
           
 
   // stage 3 //(code:1770~1790) // 수정시에 total score가 0~ 14 일때 발생하는 signal = 1 로 두고 이게 1이 아닐 때 랑 s3_hit_ sig 랑 && 
   else if ((s3_hit_sig == 1) && (sprite_stage3_e1_x < sprite_p1_x + 84 ) && (sprite_stage3_e1_x + 64 > sprite_p1_x) 
        && (sprite_stage3_e1_y + 64 > sprite_p1_y ) && (sprite_p1_y + 84 > sprite_stage3_e1_y) && (life_control != 0))
        life_control = life_control - 1;
   else if (( s3_hit_sig == 1) && (sprite_stage3_e2_x < sprite_p1_x + 84 ) && (sprite_stage3_e2_x + 64 > sprite_p1_x) 
        && (sprite_stage3_e2_y + 64 > sprite_p1_y ) && (sprite_p1_y + 84 > sprite_stage3_e2_y) && (life_control != 0))
        life_control = life_control - 1;   
   else if ((s3_hit_sig == 1) && (sprite_stage3_e3_x < sprite_p1_x + 84 ) && (sprite_stage3_e3_x + 64 > sprite_p1_x) 
        && (sprite_stage3_e3_y + 64 > sprite_p1_y ) && (sprite_p1_y + 84 > sprite_stage3_e3_y) && (life_control != 0))
        life_control = life_control - 1;   
   else if ((s3_hit_sig == 1) && (sprite_stage3_e4_x < sprite_p1_x + 84 ) && (sprite_stage3_e4_x + 64 > sprite_p1_x) 
        && (sprite_stage3_e4_y + 64 > sprite_p1_y ) && (sprite_p1_y + 84 > sprite_stage3_e4_y) && (life_control != 0))
        life_control = life_control - 1;   
   else if ((s3_hit_sig == 1) && (sprite_stage3_e5_x < sprite_p1_x + 84 ) && (sprite_stage3_e5_x + 64 > sprite_p1_x) 
        && (sprite_stage3_e5_y + 64 > sprite_p1_y ) && (sprite_p1_y + 84 > sprite_stage3_e5_y) && (life_control != 0))
        life_control = life_control - 1;   
   
             // stage 4 //            
    else if ((s4_hit_sig ==1) && (sprite_shoot_x_stage4_e1 >= sprite_p1_x + 32) && (sprite_shoot_x_stage4_e1 < sprite_p1_x+52) && (sprite_shoot_y_stage4_e1 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage4_e1 +28 <sprite_p1_y +6) && (life_control != 0))
        life_control = life_control - 1 ;               
    else if ((s4_hit_sig ==1) && (sprite_shoot_x_stage4_e2 >= sprite_p1_x + 32) && (sprite_shoot_x_stage4_e2 < sprite_p1_x+ 52) && (sprite_shoot_y_stage4_e2 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage4_e2 +28 <sprite_p1_y +6) && (life_control != 0))
        life_control = life_control - 1 ;
    else if ((s4_hit_sig ==1) && (sprite_shoot_x_stage4_e3 >= sprite_p1_x + 32) && (sprite_shoot_x_stage4_e3 < sprite_p1_x+ 52) && (sprite_shoot_y_stage4_e3 + 28 >= sprite_p1_y) && (sprite_shoot_y_stage4_e3 + 28 <sprite_p1_y +6) && (life_control != 0))
        life_control = life_control - 1 ;

//        //stage 5//
//    else if ((s5_hit_sig ==1) && (sprite_shoot_x_stage5_boss >= sprite_p1_x + 32) && (sprite_shoot_x_stage5_boss < sprite_p1_x+ 52) && (sprite_shoot_y_stage5_boss + 28 >= sprite_p1_y) && (sprite_shoot_y_stage5_boss + 28 <sprite_p1_y +6) && (life_control != 0))
//        life_control = life_control - 1 ;
        
        ///////////////////////////////// item //////////////////////////////////////// gfx line : 2196~2200
 
   else if ((item_1_begin == 1) && (sprite_item1_x >= sprite_p1_x && sprite_item1_x < sprite_p1_x + 84) && (sprite_item1_y >= sprite_p1_y && sprite_item1_y < sprite_p1_y + 84)) begin
        item1_get <= 1;
        projectile_img_select <= 1; end
   else if ((item_2_begin == 1) && (sprite_item2_x >= sprite_p1_x && sprite_item2_x < sprite_p1_x + 84) && (sprite_item2_y >= sprite_p1_y && sprite_item2_y < sprite_p1_y + 84)) begin
        item2_get <= 1;
        projectile_img_select <= 2;
end
        
         end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// stage 1 /////////////////////////////////
//    // enemy 1 shoot 
//    else if (sprite_hit_shoot_e1==1) begin  // enemy 1 shoot 
//        o_red = sprite_red_shoot_e1;
//        o_green = sprite_green_shoot_e1;
//        o_blue = sprite_blue_shoot_e1;
//    end
    
//    else if (sprite_hit_shoot_e2 == 1) begin
//        o_red = sprite_red_shoot_e1;
//        o_green = sprite_green_shoot_e1;
//        o_blue = sprite_blue_shoot_e1;
//    end
    
//    /// enemy 3 shoot /// 
//    else if (sprite_hit_shoot_e3==1 ) begin  // enemy 1 shoot 
//        o_red = sprite_red_shoot_e3;
//        o_green = sprite_green_shoot_e3;
//        o_blue = sprite_blue_shoot_e3;
//    end
    
//    else if (sprite_hit_shoot_e4 == 1) begin
//        o_red = sprite_red_shoot_e1;
//        o_green = sprite_green_shoot_e1;
//        o_blue = sprite_blue_shoot_e1;
//    end
    
//    /// enemy 5 shoot ///
//    else if (sprite_hit_shoot_e5==1) begin  // enemy 1 shoot 
//        o_red = sprite_red_shoot_e5;
//        o_green = sprite_green_shoot_e5;
//        o_blue = sprite_blue_shoot_e5;
//   end
  // end
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////// 
    // 아군 전투기 표시  // always 
    ////////////////////////////// stage 0 ////////////////////////////////
    always@(*) begin
    if (total_score >= 0 && total_score <= 5) begin
        s0_hit_sig <=1;
        end
    else begin
        s0_hit_sig <=0;
        end
  //////////////////////////// stage 1 ///////////////////////////////////
   if (total_score >= 5 && total_score <= 10) begin
        s1_hit_sig <=1;
        end
    else begin
        s1_hit_sig <=0;
        end
        
  //////////////////////// stage 2 ////////////////////////////////////
   if (total_score >= 10 && total_score <= 14) begin
        s2_hit_sig <=1;
        end
    else begin
        s2_hit_sig <=0;
        end
   ////////////////////////// stage 3 ///////////////////////////////
   if (total_score >= 14 && total_score <= 19) begin
        s3_hit_sig <= 1;
        end
   else begin
        s3_hit_sig<=0;
        end
   ///////////////////////////// stage 4 /////////////////////////(code:2145~2150)
   if (total_score >= 19 && total_score <= 22) begin
        s4_hit_sig <= 1;
        end
    else begin
        s4_hit_sig <= 0;
        end
 
/////////////////////////////// stage 5 ///////////////////////////////////////////////////////////////
    if (total_score >= 22) begin
        s5_hit_sig <= 1; end
    else begin
        s5_hit_sig <= 0;
        end
    
////////////////////////////////////item////////////////////////////////////
if (total_score == 6) begin
        item_1_begin <= 1;
    end
   
    if (total_score == 15) begin
        item_2_begin <= 1; 
    end

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    if(sprite_hit_p1==1) begin // if sprite_hit == 1 -> spirte_x <= i_x < sprite_x + 64 일 경우에는,
    o_red=sprite_red_p1;       
    o_green=sprite_green_p1;
    o_blue=sprite_blue_p1;
    end
    
        ///////////////////// stage 0 적 전투기 ///////////////////////
    // 적군 전투기 표시 1 
    else if(sprite_hit_e1 == 1 && s0_hit_sig ==1) begin 
        o_red=sprite_red_e1;       
        o_green=sprite_green_e1;
        o_blue=sprite_blue_e1;
    end
    
    // 적군 전투기 표시 2
    else if(sprite_hit_e2 == 1 && s0_hit_sig ==1) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
    o_red=sprite_red_e2;       
    o_green=sprite_green_e2;
    o_blue=sprite_blue_e2;
    end
    
        //기존 stage 2 적 1
    else if((sprite_hit_stage2_e1 == 1) && s0_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e1;       
        o_green=sprite_green_stage2_e1;
        o_blue=sprite_blue_stage2_e1;
    end
    
    //기존 stage 2 적 2
    else if((sprite_hit_stage2_e2 == 1) && s0_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e2;       
        o_green=sprite_green_stage2_e2;
        o_blue=sprite_blue_stage2_e2;
    end
    
    //기존 stage 2 적 3
    else if((sprite_hit_stage2_e3 == 1) && s0_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e3;       
        o_green=sprite_green_stage2_e3;
        o_blue=sprite_blue_stage2_e3;
    end
    
   

    
    ///////////////////////score///////////////////////////////////
       // score0
    else if((total_score == 0) && (sprite_hit4 == 1)) begin 
    o_red=sprite_red4;       // sprite image data output RGB에 mapping 
    o_green=sprite_green4;
    o_blue=sprite_blue4;
    end
    
    // score1
    else if((total_score == 1) && (sprite_hit_s1 == 1)) begin 
    o_red=sprite_red_s1;       // sprite image data RGB에 mapping 
    o_green=sprite_green_s1;
    o_blue=sprite_blue_s1;
    end
    
    // score2
    else if((total_score == 2) && (sprite_hit_s2 == 1)) begin 
    o_red=sprite_red_s2;       // sprite image data output RGB에 mapping 
    o_green=sprite_green_s2;
    o_blue=sprite_blue_s2;
    end
    
    // score3
    else if((total_score == 3) && (sprite_hit_s3 == 1)) begin 
    o_red=sprite_red_s3;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s3;
    o_blue=sprite_blue_s3;
    end
    
    // score4
    else if((total_score == 4) && (sprite_hit_s4 == 1)) begin  
    o_red=sprite_red_s4;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s4;
    o_blue=sprite_blue_s4;
    end
    
    // score5
    else if((total_score == 5) && (sprite_hit_s5 == 1)) begin  
    o_red=sprite_red_s5;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s5;
    o_blue=sprite_blue_s5;
    end
  
      
    // score6
    else if((total_score == 6) && (sprite_hit_s6 == 1)) begin 
    o_red=sprite_red_s6;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s6;
    o_blue=sprite_blue_s6;
    end
    
    // score7
    else if((total_score == 7) && (sprite_hit_s7 == 1)) begin 
    o_red=sprite_red_s7;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s7;
    o_blue=sprite_blue_s7;
    end
    
    // score8
    else if((total_score == 8) && (sprite_hit_s8 == 1)) begin 
    o_red=sprite_red_s8;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s8;
    o_blue=sprite_blue_s8;
    end
    
    // score9
    else if((total_score == 9) && (sprite_hit_s9 == 1)) begin 
    o_red=sprite_red_s9;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s9;
    o_blue=sprite_blue_s9;
    end
    
    // score10
    else if((total_score == 10) && (sprite_hit_s10 == 1)) begin 
    o_red=sprite_red_s10;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s10;
    o_blue=sprite_blue_s10;
    end
    
    // score11
    else if((total_score == 11) && (sprite_hit_s11 == 1)) begin 
    o_red=sprite_red_s11;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s11;
    o_blue=sprite_blue_s11;
    end
    
    // score12
    else if((total_score == 12) && (sprite_hit_s12 == 1)) begin 
    o_red=sprite_red_s12;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s12;
    o_blue=sprite_blue_s12;
    end
    
    // score13
    else if((total_score == 13) && (sprite_hit_s13 == 1)) begin 
    o_red=sprite_red_s13;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s13;
    o_blue=sprite_blue_s13;
    end
    
    // score14
    else if((total_score == 14) && (sprite_hit_s14 == 1)) begin 
    o_red=sprite_red_s14;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s14;
    o_blue=sprite_blue_s14;
    end
    
    // score15
    else if((total_score == 15) && (sprite_hit_s15 == 1)) begin 
    o_red=sprite_red_s15;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s15;
    o_blue=sprite_blue_s15;
    end
    
    // score16
    else if((total_score == 16) && (sprite_hit_s16 == 1)) begin 
    o_red=sprite_red_s16;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s16;
    o_blue=sprite_blue_s16;
    end
    
    // score17
    else if((total_score == 17) && (sprite_hit_s17 == 1)) begin 
    o_red=sprite_red_s17;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s17;
    o_blue=sprite_blue_s17;
    end
    
    // score18
    else if((total_score == 18) && (sprite_hit_s18 == 1)) begin 
    o_red=sprite_red_s18;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s18;
    o_blue=sprite_blue_s18;
    end
    
    // score19
    else if((total_score == 19) && (sprite_hit_s19 == 1)) begin 
    o_red=sprite_red_s19;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s19;
    o_blue=sprite_blue_s19;
    end
    
    // score20
    else if((total_score == 20) && (sprite_hit_s20 == 1)) begin 
    o_red=sprite_red_s20;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s20;
    o_blue=sprite_blue_s20;
    end
    
    // score21
    else if((total_score == 21) && (sprite_hit_s21 == 1)) begin 
    o_red=sprite_red_s21;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s21;
    o_blue=sprite_blue_s21;
    end
    
    // score22
    else if((total_score == 22) && (sprite_hit_s22 == 1)) begin 
    o_red=sprite_red_s22;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s22;
    o_blue=sprite_blue_s22;
    end
    
    // score23
    else if((total_score == 23) && (sprite_hit_s23 == 1)) begin 
    o_red=sprite_red_s23;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_s23;
    o_blue=sprite_blue_s23;
    end
    
        
    // Team name
    else if(sprite_hit3 == 1) begin 
    o_red=sprite_red3;       // sprite image data output RGB에 mapping 
    o_green=sprite_green3;
    o_blue=sprite_blue3;
    end
    
           ////////////////////// stage 1 //////////////////////////////////////////
    
    // 적군 전투기 표시 3
    else if(sprite_hit_e3 == 1 && s1_hit_sig ==1) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
    o_red=sprite_red_e3;    
    o_green=sprite_green_e3;
    o_blue=sprite_blue_e3;
    end
   
      //stage 2 적 4
    else if((sprite_hit_stage2_e4 == 1) && s1_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e4;       
        o_green=sprite_green_stage2_e4;
        o_blue=sprite_blue_stage2_e4;
    end
    
    //stage 2 적 5
    else if((sprite_hit_stage2_e5 == 1) && s1_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e5;       
        o_green=sprite_green_stage2_e5;
        o_blue=sprite_blue_stage2_e5;
    end
    
    //stage 2 적 6
    else if((sprite_hit_stage2_e6 == 1) && s1_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e6;       
        o_green=sprite_green_stage2_e6;
        o_blue=sprite_blue_stage2_e6;
    end
    
    //stage 2 적 7
    else if((sprite_hit_stage2_e7 == 1) && s1_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e7;       
        o_green=sprite_green_stage2_e7;
        o_blue=sprite_blue_stage2_e7;
    end 

    ////////////////////////////// stage 2 ////////////////////////////////////////////////////////
    // 적군 전투기 표시 4
    else if(sprite_hit_e4 == 1 && s2_hit_sig ==1) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
    o_red=sprite_red_e4;       
    o_green=sprite_green_e4;
    o_blue=sprite_blue_e4;
    end
    
    // 적군 전투기 표시 5
    else if(sprite_hit_e5 == 1 && s2_hit_sig ==1) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
    o_red=sprite_red_e5;       // sprite image data output RGB에 mapping 
    o_green=sprite_green_e5;
    o_blue=sprite_blue_e5;
    end
    
        //stage 2 적 8
    else if((sprite_hit_stage2_e8 == 1) && s2_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e8;       
        o_green=sprite_green_stage2_e8;
        o_blue=sprite_blue_stage2_e8;
    end
    
    //stage 2 적 9
    else if((sprite_hit_stage2_e9 == 1) && s2_hit_sig ==1) begin 
        o_red=sprite_red_stage2_e9;       
        o_green=sprite_green_stage2_e9;
        o_blue=sprite_blue_stage2_e9;
    end
    
    //////////////////////////////////////////////////////////
   
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////// clear stage 1 ///////////////////////
//    else if((total_score == 5) && (sprite_hit_clear == 1)) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
//    o_red=sprite_red_clear;       // sprite image data 를 output RGB에 mapping 
//    o_green=sprite_green_clear;
//    o_blue=sprite_blue_clear;
//    end
    
//    //////////////////////// clear stage 2 ////////////////////////
//    else if((total_score == 14) && (sprite_hit_clear2 == 1)) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
//    o_red=sprite_red_clear2;       // sprite image data 를 output RGB에 mapping 
//    o_green=sprite_green_clear2;
//    o_blue=sprite_blue_clear2;
//    end
    
    ////////////////////////// clear stage 3///////////////////////////
    else if((total_score == 22) && (sprite_hit_clear3 == 1)) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 
    o_red=sprite_red_clear3;       // sprite image data 를 output RGB에 mapping 
    o_green=sprite_green_clear3;
    o_blue=sprite_blue_clear3;
    end
    
    /////////////////////////////// stage 3 적 /////////////////////////////////////
    // stage 3 적 1 
    else if((sprite_hit_stage3_e1 == 1) && s3_hit_sig ==1) begin 
        o_red=sprite_red_stage3_e1;       
        o_green=sprite_green_stage3_e1;
        o_blue=sprite_blue_stage3_e1;
    end
    
    // stage 3 적 2 
    else if((sprite_hit_stage3_e2 == 1) && s3_hit_sig ==1) begin 
        o_red=sprite_red_stage3_e2;       
        o_green=sprite_green_stage3_e2;
        o_blue=sprite_blue_stage3_e2;
    end
    
    // stage 3 적 3 
    else if((sprite_hit_stage3_e3 == 1) && s3_hit_sig ==1) begin 
        o_red=sprite_red_stage3_e3;       
        o_green=sprite_green_stage3_e3;
        o_blue=sprite_blue_stage3_e3;
    end
    
    // stage 3 적 4 
    else if((sprite_hit_stage3_e4 == 1) && s3_hit_sig ==1) begin 
        o_red=sprite_red_stage3_e4;       
        o_green=sprite_green_stage3_e4;
        o_blue=sprite_blue_stage3_e4;
    end
    
    // stage 3 적 5 
    else if((sprite_hit_stage3_e5 == 1) && s3_hit_sig ==1) begin 
        o_red=sprite_red_stage3_e5;       
        o_green=sprite_green_stage3_e5;
        o_blue=sprite_blue_stage3_e5;
    end
    
    /////////////////////enemy_big_red 적//////////////////////////////////////////////////////////////////////(code:2230~2236)
     else if((sprite_hit_enemy_big_red_1 == 1) && s3_hit_sig ==1) begin 
        o_red=sprite_red_enemy_big_red_1;       
        o_green=sprite_green_enemy_big_red_1;
        o_blue=sprite_blue_enemy_big_red_1;
    end
       ///////////////// stage 4 적 ///////////////////////////////////////////////////////////////(code:2474~2494)
    // stage 4 적 1
    else if((sprite_hit_stage4_e1 == 1) && s4_hit_sig ==1) begin 
        o_red=sprite_red_stage4_e1;       
        o_green=sprite_green_stage4_e1;
        o_blue=sprite_blue_stage4_e1;
    end
    // stage 4 적 2
    else if((sprite_hit_stage4_e2 == 1) && s4_hit_sig ==1) begin 
        o_red=sprite_red_stage4_e2;       
        o_green=sprite_green_stage4_e2;
        o_blue=sprite_blue_stage4_e2;
    end
    // stage 4 적 3
    else if((sprite_hit_stage4_e3 == 1) && s4_hit_sig ==1) begin 
        o_red=sprite_red_stage4_e3;       
        o_green=sprite_green_stage4_e3;
        o_blue=sprite_blue_stage4_e3;
    end

//    ///////////// stage 5 ////////////////////////////////////////////////////////////////
//    else if ((sprite_hit_stage5_boss == 1) && s5_hit_sig ==1) begin
//        o_red = sprite_red_stage5_boss;
//        o_green = sprite_green_stage5_boss;
//        o_blue = sprite_blue_stage5_boss;
//    end

 //            ///////////////////////////////// enemy projectile ///////////////////////////////////////
    /// stage 0 /////////////////////////////////
   else if (sprite_hit_shoot_e1==1) begin  // 카키 enemy 1 shoot 
        o_red = sprite_red_shoot_e1;
        o_green = sprite_green_shoot_e1;
        o_blue = sprite_blue_shoot_e1;
    end
    
    else if (sprite_hit_shoot_e2 == 1) begin //카키 enemy2
        o_red = sprite_red_shoot_e2;
        o_green = sprite_green_shoot_e2;
        o_blue = sprite_blue_shoot_e2;
    end
    
        // enemy 1 shoot 
    else if (sprite_hit_shoot_stage2_e1==1) begin  // 쪼끄미 enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e1;
        o_green = sprite_green_shoot_stage2_e1;
        o_blue = sprite_blue_shoot_stage2_e1;
    end
    // enemy 2 shoot 
    else if (sprite_hit_shoot_stage2_e2==1) begin  // 쪼꼬미 enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e2;
        o_green = sprite_green_shoot_stage2_e2;
        o_blue = sprite_blue_shoot_stage2_e2;
    end
    // enemy 3 shoot 
    else if (sprite_hit_shoot_stage2_e3==1) begin  // 쪼꼬미 enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e3;
        o_green = sprite_green_shoot_stage2_e3;
        o_blue = sprite_blue_shoot_stage2_e3;
    end
    
 //////////////////////////////////////////////////////////////////////////////////////
    /// stage 1/////////////////////////////////////
        /// enemy 3 shoot /// 
    else if (sprite_hit_shoot_e3==1 ) begin  //카키 enemy 3 shoot 
        o_red = sprite_red_shoot_e3;
        o_green = sprite_green_shoot_e3;
        o_blue = sprite_blue_shoot_e3;
    end

    // enemy 4 shoot 
    else if (sprite_hit_shoot_stage2_e4==1) begin  // 쪼꼬미enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e4;
        o_green = sprite_green_shoot_stage2_e4;
        o_blue = sprite_blue_shoot_stage2_e4;
    end
    // enemy 5 shoot 
    else if (sprite_hit_shoot_stage2_e5==1) begin  // 쪼꼬미 enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e5;
        o_green = sprite_green_shoot_stage2_e5;
        o_blue = sprite_blue_shoot_stage2_e5;
    end
    // enemy 6 shoot 
    else if (sprite_hit_shoot_stage2_e6==1) begin  // 쪼꼬미 enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e6;
        o_green = sprite_green_shoot_stage2_e6;
        o_blue = sprite_blue_shoot_stage2_e6;
    end
    // enemy 7 shoot 
    else if (sprite_hit_shoot_stage2_e7==1) begin  // 쪼꼬미 enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e7;
        o_green = sprite_green_shoot_stage2_e7;
        o_blue = sprite_blue_shoot_stage2_e7;
    end
   
    
    ///////////////////// stage 2 ///////////////////////////////
    
    else if (sprite_hit_shoot_e4 == 1) begin//카키 enemy4
        o_red = sprite_red_shoot_e4;
        o_green = sprite_green_shoot_e4;
        o_blue = sprite_blue_shoot_e4;
    end
    
       /// enemy 5 shoot ///
    else if (sprite_hit_shoot_e5==1) begin  // 카키 enemy 5 shoot 
        o_red = sprite_red_shoot_e5;
        o_green = sprite_green_shoot_e5;
        o_blue = sprite_blue_shoot_e5;
    end
    
    // enemy 8 shoot 
    else if (sprite_hit_shoot_stage2_e8==1 ) begin  // enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e8;
        o_green = sprite_green_shoot_stage2_e8;
        o_blue = sprite_blue_shoot_stage2_e8;
    end
    // enemy 9 shoot 
    else if (sprite_hit_shoot_stage2_e9==1) begin  // enemy 1 shoot 
        o_red = sprite_red_shoot_stage2_e9;
        o_green = sprite_green_shoot_stage2_e9;
        o_blue = sprite_blue_shoot_stage2_e9;
    end

    /////////////////////////////////////stage4/////////////////////////////////////////////////////////
    
        // enemy 1 shoot 
    else if (sprite_hit_shoot_stage4_e1==1 ) begin  // enemy 1 shoot 
        o_red = sprite_red_shoot_stage4_e1;
        o_green = sprite_green_shoot_stage4_e1;
        o_blue = sprite_blue_shoot_stage4_e1;
    end

    // enemy 2 shoot 
    else if (sprite_hit_shoot_stage4_e2==1 ) begin  // enemy 1 shoot 
        o_red = sprite_red_shoot_stage4_e2;
        o_green = sprite_green_shoot_stage4_e2;
        o_blue = sprite_blue_shoot_stage4_e2;
    end

    // enemy 3 shoot 
    else if (sprite_hit_shoot_stage4_e3==1 ) begin  // enemy 1 shoot 
        o_red = sprite_red_shoot_stage4_e3;
        o_green = sprite_green_shoot_stage4_e3;
        o_blue = sprite_blue_shoot_stage4_e3;
    end

//////////////////////////////////////stage 5////////////////////////
//    // boss shoot 
//    else if (sprite_hit_shoot_stage5_boss==1 ) begin  // enemy 1 shoot 
//        o_red = sprite_red_shoot_stage5_boss;
//        o_green = sprite_green_shoot_stage5_boss;
//        o_blue = sprite_blue_shoot_stage5_boss;
//    end


    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// life //////////////////////////////////////////////////////////////  
     // life 3
    else if ((life_control==3) && (sprite_hit_life3 == 1)) begin
    o_red = sprite_red_life3;
    o_green = sprite_green_life3;
    o_blue = sprite_blue_life3;
    end
    
    // life 2
    else if ((life_control == 2) && (sprite_hit_life2== 1)) begin
    o_red = sprite_red_life2;
    o_green = sprite_green_life2;
    o_blue = sprite_blue_life2;
    end
    
    // life 1
    else if ((life_control == 1) && (sprite_hit_life1== 1)) begin
    o_red = sprite_red_life1;
    o_green = sprite_green_life1;
    o_blue = sprite_blue_life1;
    end
    
    // life 0
    else if ((life_control == 0) && (sprite_hit_life0== 1)) begin;
    o_red = sprite_red_life0;
    o_green = sprite_green_life0;
    o_blue = sprite_blue_life0;
    end
     
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// projectile ////////////////////////////////////////////////////////////
    // player projectile
    else if(sprite_hit_shoot_p == 1) begin // if sprite_hit2 == 1 -> spirte_x <= i_x < sprite_x + 64 // hit6 = player projectile
        o_red=sprite_red_shoot_p;       // sprite image data 를 output RGB에 mapping 
        o_green=sprite_green_shoot_p;
        o_blue=sprite_blue_shoot_p;
        end
  ////////////////////////////////////////////////////////////////////////////////// gfx line 2770~2781

    else if(sprite_hit_item1 == 1) begin
        o_red = sprite_red_item1;
        o_green = sprite_green_item1;
        o_blue = sprite_blue_item1;
        end
    
    else if(sprite_hit_item2 == 1) begin
        o_red = sprite_red_item2;
        o_green = sprite_green_item2;
        o_blue = sprite_blue_item2;
        end
    
     // game over 
    else if ((life_control == 0) && (sprite_hit_clear == 1)) begin
        o_red = sprite_red_clear;
        o_green= sprite_green_clear;
        o_blue = sprite_blue_clear;
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // background image
    else begin              // if sprite_hit == 0 -> NOT!!  (spirte_x <= i_x < sprite_x + 64 ) 
    o_red=bg_red;           // background image data output RGB에 mapping 
    o_green=bg_green;
    o_blue=bg_blue;
    end
     //////////////////////////////// 적기 출현 결정 /////////////////////////////////////
  /////////////////////////////// 적기 출현 결정 //////////////////////////////////////  
   
    end
    
endmodule