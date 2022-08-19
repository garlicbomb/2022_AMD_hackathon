`timescale 1ns / 1ps

module sprite_compositor(
    input wire [15:0] i_x, // x axis 
    input wire [15:0] i_y, // y axis 
    input wire i_v_sync,    // vertical sync 
    input wire btn1, btn2, btn3,  // btn input
    input wire [1:0] sw,
    output wire [7:0] o_red,    // 8bit red 
    output wire [7:0] o_green,  // 8bit green
    output wire [7:0] o_blue,   // 8bit blue
    
    ///////////////////////// enemy 가 쏜 총알 좌표 //////////////////////////////
//    input wire [15:0] enemy_shoot_x,  // input : shoot_ x
//    input wire [15:0] enemy_shoot_y,   // input : shoot_ y
    //////////////////////////////////////////////////////////////////////////////
    
    output wire o_sprite_hit,    // sprite 가 hit 되었을 경우를 판단하기 위한 1bit 할당 , hit시 1 , 아니면 0 
    output wire [15:0] sprite_x_pos, // 외부 모듈과 연결하기 위해 x location 선언 
    output wire [15:0] sprite_y_pos,  // 외부 모듈과 연결하기 위해 y location 선언  
    
    input wire [2:0] life
    );
    
    ////////////////////////// life 를 count하기 위해 설정 //////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    reg [15:0] sprite_x;   // sprite image x axis, 시작점은 active region의 시작점, 즉 display 표시되는 영역의 왼쪽 위 끝
    reg [15:0] sprite_y;   // sprite image y axis, 시작점은 active region의 시작점, 즉 display 표시되는 영역의 왼쪽 위 끝
    ////////////////////////// modified /////////////////////////
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // 외부 모듈과 연결하기 위해 x location 선언 및 본 모듈의 sprite _ x 와 연결 
    assign sprite_y_pos = sprite_y; // 외부 모듈과 연결하기 위해 y location 선언 및 본 모듈의 sprite_ y와 연결 
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
   
    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y 가 active region끝에 도달했을 때를 알리기 위한 hit 1bit wire 
    wire [4:0] sprite_render_x;         // spirte render x축, 5bit , 0~ 31 
    wire [4:0] sprite_render_y;         // spirte render y축, 5bit , 0~ 31 
    
    

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4행 3열 data, 각 pixel 은 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00,    // RGB - 0 : black -> hexadecimal : 00 00 00                    ===> BLACK : 4'd0
        8'h36, 8'h8A, 8'hFF,    // R - 54, G - 138, B - 255 : BLUE -> hexadecimal : 36 8A FF     ===> BLUE : 4'd1
        8'h46, 8'h41, 8'hD9,     // R - 70, G - 65, B - 217 : 진한  BLUE -> hexadecimal : 46 41 D9     ===> 진한 BLUE : 4'd2
        8'h5D, 8'h5D, 8'h5D     // R - 93, G - 93, B - 93 : 진한 gray 테두리-> hexadecimal : 5D 5D 5D     ===> 진한 gray : 4'd6,3
    };
   
    ////////////////////////// modified /////////////////////////
    localparam [0:20][0:20][3:0] sprite_data3 = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)
                             //color 개수                        // PLAYER 가로 21개 세로 20개
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    ////////////////////////// modified /////////////////////////
    // life 2 
    localparam [0:20][0:20][3:0] sprite_data2 = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)
                                                     // PLAYER
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    /////////////////////////////////////////////////////////////////////////
    // life 1
    localparam [0:20][0:20][3:0] sprite_data1 = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)
                                                     // PLAYER
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    // life 0
    localparam [0:20][0:20][3:0] sprite_data0 = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)
                                                     // PLAYER
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    ///////////////////////////////////////////////////btn별로 sprite data///////////////////////////////////////
    ////////////////////////btn1=1///////////////////////////////////////////////////////////////////////////////
    localparam [0:20][0:20][3:0] sprite_data4 = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)
                             //color 개수                        // PLAYER 가로 21개 세로 20개
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    ////////////////////////btn3=1///////////////////////////////////////////////////////////////////////////////
    localparam [0:20][0:20][3:0] sprite_data5 = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)
                             //color 개수                        // PLAYER 가로 21개 세로 20개
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,
    4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0
    };

    
    
    ////////////////////////// modified /////////////////////////
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 84);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 84
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 84);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 84
    
    // 렌더링
    assign sprite_render_x = (i_x - sprite_x)>>2;   // sprite render x = ( x poistion - sprite x postion ) / 4, ex 128/8 = 16pixels
    assign sprite_render_y = (i_y - sprite_y)>>2;   // sprite render y = ( y poistion - sprite y postion ) / 4
    
    wire [2:0] selected_palette; // 4'd0 ~ 4'd6 을 cover하기 위해 3bit 선언 , 3bit = 000 001 010 011 101 110 111-> 0~8 cover
    
    // sprite_x_filp = 1 && sprite_y_flip = 1 -> slected_palette = sprite_data[15-sprite_render_y][15-sprite_render_x]
    // sprite_x_filp = 1 && sprite_y_flip = 0 -> slected_palette = sprite_data[sprite_render_y][15-sprite_render_x]
    // sprite_x_filp = 0 && sprite_y_flip = 1 -> slected_palette = sprite_data[15-sprite_render_y][sprite_render_x]
    // sprite_x_filp = 0 && sprite_y_flip = 0 -> slected_palette = sprite_data[sprite_render_y][sprite_render_x]
    // sprite date의 image RGB color data는 selected_palette에서 생성됨 (color table을 선택 ) 
    
    assign selected_palette = ((btn1 != 1 ) && (btn3 != 1 ) && (life == 0)) ? sprite_data0[sprite_render_y][sprite_render_x] :
                              ((btn1 != 1 ) && (btn3 != 1 ) && (life == 1)) ? sprite_data1[sprite_render_y][sprite_render_x] : 
                              ((btn1 != 1 ) && (btn3 != 1 ) && (life == 2)) ? sprite_data2[sprite_render_y][sprite_render_x] : 
                              ((btn1 != 1 ) && (btn3 != 1 ) && (life == 3)) ? sprite_data3[sprite_render_y][sprite_render_x] :
                              ((btn1 == 1 ) && (btn3 != 1 ) && (life == 0)) ? sprite_data4[sprite_render_y][sprite_render_x] :
                              ((btn1 == 1 ) && (btn3 != 1 ) && (life == 1)) ? sprite_data4[sprite_render_y][sprite_render_x] : 
                              ((btn1 == 1 ) && (btn3 != 1 ) && (life == 2)) ? sprite_data4[sprite_render_y][sprite_render_x] : 
                              ((btn1 == 1 ) && (btn3 != 1 ) && (life == 3)) ? sprite_data4[sprite_render_y][sprite_render_x] :
                              ((btn1 != 1 ) && (btn3 == 1 ) && (life == 0)) ? sprite_data5[sprite_render_y][sprite_render_x] :
                              ((btn1 != 1 ) && (btn3 == 1 ) && (life == 1)) ? sprite_data5[sprite_render_y][sprite_render_x] : 
                              ((btn1 != 1 ) && (btn3 == 1 ) && (life == 2)) ? sprite_data5[sprite_render_y][sprite_render_x] : sprite_data5[sprite_render_y][sprite_render_x] ;
    
    // spirte_x 가 active region에 존재할 때 spirte image data가 color 가 입혀져서 나타날 수 있게 됨 
         
    // sprite hit_x && sprite_hit_y = 1 -> o_red = palette_colors[selected_palette][2]
    // sprite hit_x && sprite_hit_y = 0 -> o_red = 8'hXX                                                                     
    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    
    // sprite_hit_x && sprite_hit_y = 1 -> o_green =  palette_colors[selected_palette][1] 
    // sprite hit_x && sprite_hit_y = 0 -> o_green = 8'hXX
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    
    // sprite_hit_x && sprite_hit_y = 1 -> o_blue =  palette_colors[selected_palette][0] 
    // sprite hit_x && sprite_hit_y = 0 -> o_blue = 8'hXX
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    
    // sprite_hit_y & sprite_hit_x = 1 & selected_palette != 0 ---> o_sprite_hit = 1
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);

    initial begin
        sprite_x <= 16'd160; // 적기 3의 x 좌표와 같게 설정하면 가운데에 위치할 수 있다.
        sprite_y <= 16'd720- 16'd144;
    end
    
    always @(posedge i_v_sync) begin    // vertical sync -> 0, 1 clocking -> positive edge에서만 수행 
    
    // btn1 = 1 -> +x 축, btn2 = 1 -> -y축, btn3 = 1 -> +y축, btn4 = 1 -> -x축 진행
    ////////////////////////// modified /////////////////////////
    ///////////////// -x direction move ///////////////////////
    if (btn3 == 1) begin            // btn4 pressed     //
        if (sprite_x > 1)
            sprite_x = sprite_x - 4;   // 왼쪽으로 이동 
        else if (sprite_x == 1)   // 더이상 왼쪽으로 갈 수 없을 때
            sprite_x = sprite_x;       // 움직이지 않음  
    end
    
    ////////////////////////// modified /////////////////////////
    ///////////////// +x direction move ///////////////////////
    if (btn1 == 1) begin
        if (sprite_x < 1280-84 )      // 오른쪽 끝이 화면 오른쪽 끝에 도달하기 전까지 
            sprite_x = sprite_x + 4;   // 오른쪽으로 이동
        else if (sprite_x == 1280-84)   // 더이상 오른쪽으로 갈 수 없을 때 = 화면 오른쪽 끝일때
        // 
            sprite_x = sprite_x;       // 움직이지 않음 
    end
    ////////////////////////// modified /////////////////////////
    ///////////////// +y direction move ///////////////////////
    if (sw[0] == 1) begin
        if (sprite_y > 1 )      // 오른쪽 끝이 화면 오른쪽 끝에 도달하기 전까지 
            sprite_y = sprite_y -4;   // 오른쪽으로 이동
        else if (sprite_y <= 1)   // 더이상 오른쪽으로 갈 수 없을 때 = 화면 오른쪽 끝일때
        // 
            sprite_y = sprite_y;       // 움직이지 않음 
    end
    ////////////////////////// modified /////////////////////////
    ///////////////// -y direction move ///////////////////////
    if (sw[0] == 0) begin
        if (sprite_y < 720-84 )      // 오른쪽 끝이 화면 오른쪽 끝에 도달하기 전까지 
            sprite_y = sprite_y + 4;   // 오른쪽으로 이동
        else if (sprite_y >= 720-84)   // 더이상 오른쪽으로 갈 수 없을 때 = 화면 오른쪽 끝일때
        // 
            sprite_y = sprite_y;       // 움직이지 않음 
    end



        end
endmodule



