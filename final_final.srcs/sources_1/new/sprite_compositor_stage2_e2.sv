`timescale 1ns / 1ps



module sprite_compositor_stage2_e2(
    input wire [15:0] i_x, // x axis 
    input wire [15:0] i_y, // y axis 
    input wire i_v_sync,    // vertical sync 
    output wire [7:0] o_red,    // 8bit red 
    output wire [7:0] o_green,  // 8bit green
    output wire [7:0] o_blue,   // 8bit blue
    input wire [15:0] shoot_x,  // input : shoot_ x
    input wire [15:0] shoot_y,   // input : shoot_ y
    output wire o_sprite_hit,    // sprite 가 hit 되었을 경우를 판단하기 위한 1bit 할당 , hit시 1 , 아니면 0 
    output wire [15:0] sprite_x_pos, // 외부 모듈과 연결하기 위해 x location 선언 
    output wire [15:0] sprite_y_pos,  // 외부 모듈과 연결하기 위해 y location 선언 
    output wire score,
    
    output wire shoot_control,        // 총을 발사하라는 신호를 총알 module에 전달 
    input wire hit_sig                 // 적기 hit signal
    );

    reg [15:0] sprite_x;   // sprite image x axis
    reg [15:0] sprite_y;   // sprite image y axis
    reg sprite_x_direction = 1;
    
    /////////////////////////////// enemy projectile shoot signal /////////////////////////////////////
    reg shoot = 0;
    assign shoot_control = shoot;
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // 외부 모듈과 연결하기 위해 x location 선언 및 본 모듈의 sprite _ x 와 연결 
    assign sprite_y_pos = sprite_y; // 외부 모듈과 연결하기 위해 y location 선언 및 본 모듈의 sprite_ y와 연결 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    reg sprite_x_flip       = 0;        // sprite의 x축 시선 방향 
    reg sprite_y_flip       = 0;        // sprite의 y축 시선 방향 
    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y 가 active region끝에 도달했을 때를 알리기 위한 hit 1bit wire 
    wire [3:0] sprite_render_x;         // spirte render x축, 4bit , 0~15
    wire [3:0] sprite_render_y;         // spirte render y축, 4bit , 0~ 15 
    
    //////////////////////////////////////////score///////////////////////////////////////////////////
    reg cnt = 0;
    assign score = cnt; 
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4행 3열 data, 각 pixel 은 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00,    // RGB - 0 : black -> hexadecimal : 00 00 00                    ===> BLACK : 4'd0
        8'hFF, 8'h00, 8'h00,    // R - 255 , G- 0 , B - 0 : RED -> hexadecimal : FF 00 00       ===> RED : 4'd1
        8'hFF, 8'hFF, 8'hFF,    // R - 255, G - 255, B - 255 : WHITE -> hexadecimal : FF FF FF  ===> WHITE : 4'd2
        8'h21, 8'h21, 8'hFF     // R - 33, G - 33, B - 255 : BLUE -> hexadecimal : 21 21 FF     ===> BLUE : 4'd3
    };

    localparam [0:15][0:15][3:0] sprite_data = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)

    // 적1--------------------------------------------------------------------<- 적1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0, 
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd2,4'd0,4'd2,4'd1,4'd2,4'd2,4'd1,4'd2,4'd0,4'd2,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd1,4'd0,4'd2,4'd2,4'd1,4'd1,4'd2,4'd2,4'd0,4'd1,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd1,4'd2,4'd2,4'd2,4'd1,4'd1,4'd2,4'd2,4'd2,4'd1,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd2,4'd1,4'd2,4'd2,4'd1,4'd2,4'd2,4'd1,4'd2,4'd2,4'd1,4'd2,4'd0,4'd0,
    4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,
    4'd0,4'd0,4'd2,4'd0,4'd2,4'd2,4'd2,4'd0,4'd0,4'd2,4'd2,4'd2,4'd0,4'd2,4'd0,4'd0,
    4'd0,4'd0,4'd2,4'd0,4'd2,4'd2,4'd2,4'd0,4'd0,4'd2,4'd2,4'd2,4'd0,4'd2,4'd0,4'd0,
    4'd0,4'd0,4'd2,4'd0,4'd2,4'd2,4'd2,4'd0,4'd0,4'd2,4'd2,4'd2,4'd0,4'd2,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd0,4'd0,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
    // modified !! size : 가로, x = 16 * 4 = 64
    //             size : 세로, x = 16 * 4 = 64 ( 그대로 )
    // 충돌시 collision = 1 , 충돌 전 collision = 0;
    
    reg notcollision = 1; 
    // 충돌하면 notcollision = 0 이되어 sprite_hit_x, y 를 0으로 만들어 출력되지 않도록 함 
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 64) && (notcollision == 1) && (hit_sig == 1);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 64
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 64) && (notcollision == 1) && (hit_sig == 1);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 64

    // 렌더링
    assign sprite_render_x = (i_x - sprite_x)>>2;   // sprite render x = ( x poistion - sprite x postion ) / 4, ex 64/4 = 16pixels
    assign sprite_render_y = (i_y - sprite_y)>>2;   // sprite render y = ( y poistion - sprite y postion ) / 4
    
    wire [1:0] selected_palette; // 4'd0 ~ 4'd3 을 cover하기 위해 2bit 선언 , 2bit = 00 01 10 11 -> 0~3 cover
    
    assign selected_palette = sprite_x_flip ? (sprite_y_flip ? sprite_data[15-sprite_render_y][15-sprite_render_x]: sprite_data[sprite_render_y][15-sprite_render_x])
                                            : (sprite_y_flip ? sprite_data[15-sprite_render_y][sprite_render_x]   : sprite_data[sprite_render_y][sprite_render_x]);
    
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
     initial begin
        sprite_x <= 16'd400; // 초기값 설정 
        //-> 적들이 가운데에 위치할 수 있도록 
        sprite_y <= 16'd200;           // y축은 위에서 144 값만큼 내려온 상태 
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @(posedge i_v_sync) begin    // 적기가 총알에 부딪히는지 검사, notcollision signal을 발생시킴
        if (hit_sig == 1 && (notcollision == 1)) begin
        shoot <= 1; end
        else begin
        shoot <= 0; end 
        if ((notcollision == 1) && (hit_sig == 1) && (shoot_x > sprite_x) && (shoot_x < sprite_x + 64) && (shoot_y <= sprite_y)) begin// 적기 1와 충돌하는 순간 notcollision = 0이 되어 hit 발생 x
            notcollision <= 0;
            cnt<=1; end
        sprite_x <= sprite_x + (sprite_x_direction ? 2 : -2);       // 움직임을 위한 setting, x_direction = 1 이면 -1선택(-x), 1아니면 1선택(+x)
        sprite_y <= sprite_y;
        if (sprite_x == 1200 ) begin
            sprite_x_direction <= 0; end 
        else if (sprite_x == 100) begin  
            sprite_x_direction <= 1; end
       
     end
endmodule