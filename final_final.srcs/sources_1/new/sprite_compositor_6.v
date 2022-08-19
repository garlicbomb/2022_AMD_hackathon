`timescale 1ns / 1ps



module sprite_compositor_6( // 총알 모듈 
    input wire [15:0] i_x, // x axis 
    input wire [15:0] i_y, // y axis 
    input wire i_v_sync,    // vertical sync 
    input wire btn1, btn2, btn3,    // btn input 
    output wire [7:0] o_red,    // 8bit red 
    output wire [7:0] o_green,  // 8bit green
    output wire [7:0] o_blue,   // 8bit blue
    output wire o_sprite_hit,    // sprite 가 hit 되었을 경우를 판단하기 위한 1bit 할당 , hit시 1 , 아니면 0 
    input wire [15:0] shoot_x,  // input : shoot_ x
    input wire [15:0] shoot_y,   // input : shoot_ y
    output wire [15:0] sprite_x_pos, // 외부 모듈과 연결하기 위해 x location 선언 
    output wire [15:0] sprite_y_pos,  // 외부 모듈과 연결하기 위해 y location 선언 
    
    input wire [1:0] sw,
    input wire [2:0] projectile_image
    );
   
    reg [15:0] sprite_x     = shoot_x + 42 - 12;   // sprite image x axis, 시작점
    reg [15:0] sprite_y     = shoot_y - 32;   // sprite image y axis, 시작점
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // 외부 모듈과 연결하기 위해 x location 선언 및 본 모듈의 sprite _ x 와 연결 
    assign sprite_y_pos = sprite_y; // 외부 모듈과 연결하기 위해 y location 선언 및 본 모듈의 sprite_ y와 연결 
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y 가 active region끝에 도달했을 때를 알리기 위한 hit 1bit wire 
    wire [3:0] sprite_render_x;         // spirte render x축, 2bit, 0~3 을 표현하기 위해 
    wire [3:0] sprite_render_y;         // spirte render y축, 4bit , 0~ 16을 표현하기 위해  
   
    
    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4행 3열 data, 각 pixel 은 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00,    // RGB - 0 : black -> hexadecimal : 00 00 00                    ===> BLACK : 4'd0
        8'h90, 8'hBF, 8'hFF,    // R - 103 , G- 153 , B - 255 : sky blue -> hexadecimal : 90 BF FF       ===> SKY BLUE : 4'd1
        8'hFF, 8'hFF, 8'hFF,    // R - 255, G - 255, B - 255 : WHITE -> hexadecimal : FF FF FF  ===> WHITE : 4'd2
        8'h21, 8'h21, 8'hFF     // R - 33, G - 33, B - 255 : BLUE -> hexadecimal : 21 21 FF     ===> BLUE : 4'd3
    };
   
   // 총알 
    localparam [0:13][0:9][3:0] sprite_data0 = { //color table 0~3 으로 총 네개 (black, red, white, blue)
    // 가로는 총 4 * 2 = 8  임  
    // 세로는 총 14 * 4 = 56 
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0
    };
    localparam [0:13][0:9][3:0] sprite_data1 = { //color table 0~3 으로 총 네개 (black, red, white, blue)
    // 가로는 총 4 * 2 = 8  임  
    // 세로는 총 14 * 4 = 56 
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0
    };
    localparam [0:13][0:9][3:0] sprite_data2 = { //color table 0~3 으로 총 네개 (black, red, white, blue)
    // 가로는 총 4 * 2 = 8  임  
    // 세로는 총 14 * 4 = 56 
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,
    4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1
    };
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
    // modified !! size : 가로, x = 10 * 4 = 40
    //             size : 세로, y = 14 * 4 = 56
    
    reg finish = 1;                // 총알이 적기 끝에 다다랐음을 알리는 신호 
    
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 40) && (finish == 0);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 16
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 56) && (finish == 0);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 32
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 렌더링
    assign sprite_render_x = (i_x - sprite_x)>>2;   // sprite render x = ( x poistion - sprite x postion ) / 4, ex 64/4 = 16pixels
    assign sprite_render_y = (i_y - sprite_y)>>2;   // sprite render y = ( y poistion - sprite y postion ) / 4
    
    wire [1:0] selected_palette; // 4'd0 ~ 4'd3 을 cover하기 위해 2bit 선언 , 2bit = 00 01 10 11 -> 0~3 cover

    assign selected_palette = (projectile_image == 0) ? sprite_data0[sprite_render_y][sprite_render_x] :
                              (projectile_image == 1) ? sprite_data1[sprite_render_y][sprite_render_x] :  sprite_data2[sprite_render_y][sprite_render_x] ;
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
    
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);
    
    ///////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////////////
    always @(posedge i_v_sync) begin    // vertical sync -> 0, 1 clocking -> positive edge에서만 수행 
        // btn1 = 1 -> shoot 
        if (sprite_y == shoot_y - 32 && btn2== 1) begin
            sprite_y = shoot_y-32-1; end
        if (sprite_y == shoot_y - 30 && btn2== 1) begin
            sprite_y = shoot_y-33; end
        if ((sprite_y < shoot_y -32) && (sprite_y >= 0)) begin
            finish <= 0;
            sprite_x <= sprite_x;
            sprite_y <= sprite_y - 6; 
            end
        else begin
            finish <= 1;
            sprite_x = shoot_x + 32 - 4;// sprite image x axis, 시작점
            sprite_y = shoot_y - 32;   // sprite image y axis, 시작점
    end
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
endmodule