module enemy_big_red_green_3( //보호하는친구2, 촟을 쏴야함
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
    output wire score,          // 외부모듈과 연결하기 위한 score
    output wire shoot_control,
    input wire hit_sig,
    input wire [15:0] player_x_pos, //player의 x,y좌표
    input wire [15:0] player_y_pos
    );
    
    reg sprite_x_direction = 1;
    /////////////////////////////// enemy projectile shoot signal /////////////////////////////////////
    reg shoot = 0;
    assign shoot_control = shoot;
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    reg [15:0] sprite_x;   // sprite image x axis
    reg [15:0] sprite_y;   // sprite image y axis
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // 외부 모듈과 연결하기 위해 x location 선언 및 본 모듈의 sprite _ x 와 연결 
    assign sprite_y_pos = sprite_y; // 외부 모듈과 연결하기 위해 y location 선언 및 본 모듈의 sprite_ y와 연결 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y 가 active region끝에 도달했을 때를 알리기 위한 hit 1bit wire 
    wire [5:0] sprite_render_x;         // spirte render x축, 6bit , 0~63
    wire [4:0] sprite_render_y;         // spirte render y축, 5bit , 0~ 31 
    
    //////////////////////////////////////////score///////////////////////////////////////////////////
    reg cnt = 0;                // score count를 위한 자료형 선언
    assign score = cnt;         // gfx 모듈과 연결하기 위해 선언 
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4행 3열 data, 각 pixel 은 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00,    // RGB - 0 : black -> hexadecimal : 00 00 00                    ===> BLACK : 4'd0
        8'hFF, 8'h00, 8'h00,    // R - 255 , G- 0 , B - 0 : RED -> hexadecimal : FF 00 00       ===> RED : 4'd1(main 뱅기 색)
        8'h21, 8'hFF, 8'h21,    // R - 33, G - 255, B - 33 : Yellow -> hexadecimal : FF FF 21  ===> GREEN : 4'd2(죽어야 하는 뱅기 표시)
        8'h5D, 8'h5D, 8'h5D    // R - 93, G - 93, B - 93 : gray -> hexadecimal : 93 93 93     ===> GRAY : 4'd3(테두리)
    };
   
    localparam [0:28][0:58][3:0] sprite_data = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)

    // 적1--------------------------------------------------------------------<- 적1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd3,
    4'd3,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd3,
    4'd0,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0
    
    
    };
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
    // modified !! size : 가로, x = 16 * 4 = 64
    //             size : 세로, x = 16 * 4 = 64 ( 그대로 )
    
    // 충돌시 notcollision = 0 , 충돌 전 notcollision = 1, player의 총에 맞으면 0이 되어 사라짐.
    
    reg [2:0] notcollision = 5; 
    // 충돌하면 notcollision = 0 이되어 sprite_hit_x, y 를 0으로 만들어 출력되지 않도록 함 
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 236) && (notcollision != 0) && (hit_sig == 1);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 64
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 116) && (notcollision != 0) && (hit_sig == 1);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 64

    // 렌더링
    assign sprite_render_x = (i_x - sprite_x)>>2;   // sprite render x = ( x poistion - sprite x postion ) / 4, ex 64/4 = 16pixels
    assign sprite_render_y = (i_y - sprite_y)>>2;   // sprite render y = ( y poistion - sprite y postion ) / 4
    
    wire [1:0] selected_palette; // 4'd0 ~ 4'd3 을 cover하기 위해 2bit 선언 , 2bit = 00 01 10 11 -> 0~3 cover
    
    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];
    
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
        sprite_x <= 16'd640 + 16'd120; // 1280 가로의 중간인 640 에서 적들 5개 이미지의 1/2 값인 190을 뺌
        //-> 적들이 가운데에 위치할 수 있도록 
        sprite_y <= 16'd0;           // y축은 위에서 0 값만큼 내려온 상태 
        
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @(posedge i_v_sync) begin    // 적기가 총알에 부딪히는지 검사, notcollision signal을 발생시킴
        if (hit_sig == 1 && (notcollision != 0)) begin
        shoot <= 1; end
        else begin
        shoot <= 0; end
        if(hit_sig==1) begin
            sprite_y <= sprite_y+6;        // 움직임을 위한 setting, y축에서 1의 속도로 내려옴
            sprite_x <= sprite_x; 
                if ((notcollision != 0) && ((shoot_x > sprite_x) && (shoot_x < sprite_x + 236) && (shoot_y <= sprite_y + 116) && (shoot_y > sprite_y + 110))) begin 
                // 적기 1와 충돌하는 순간, player와 충동하는 순간 notcollision = 0이 되어 hit 발생 x
                notcollision <= notcollision - 1;end
                if (notcollision == 0)begin  // 부딪히면 notcollision = 0이 됨 -> 전투기 표시되지 않음  
                cnt<=1;     end    // 외부 모듈과 연결되는 cnt에 1을 할당 -> score count
                 
                if (sprite_y == 16'd288) begin
                    sprite_x <= sprite_x + (sprite_x_direction ? -5 : 5);
                    sprite_y <= sprite_y;
                    if (sprite_x == 16'd640 + 16'd120 + 16'd490)
                        sprite_x_direction <=1;
                    else if (sprite_x == 16'd640 + 16'd120 - 16'd490)
                        sprite_x_direction <=0;
                end 
            end  
        end
        
        

        //else (sprite_x  == 640 - 190 + 450 - 64)
          //  sprite_x_direction <= 1;                            
            // stage 3에서는 총알을 두번씩 발사하도록 
     //   else if (sprite_x == 300 && notcollision == 2)       // shoot signal 
          //  shoot <= notcollision - 1;                        // enemy가 살아있다면 총알을 발사하지만 그렇지 않다면 총알 발사 x -> notcollision = 0 : 충돌상태이므로 
       // else if (sprite_x == 300 && notcollision != 2)      
         //   shoot <= notcollision;                          // not collision이 1 또는 0일때 , shoot signal로 출력. 적기가 부셔지면 notcollision = 0이므로 shoot signal도 발생하지 않는다. 
      //  else
         //   shoot <= 0;    
     


endmodule
