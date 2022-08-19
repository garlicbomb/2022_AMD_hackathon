`timescale 1ns / 1ps



module sprite_compositor_stage3_e5(//���� �밢������ �������� enemy
    input wire [15:0] i_x, // x axis 
    input wire [15:0] i_y, // y axis 
    input wire i_v_sync,    // vertical sync 
    output wire [7:0] o_red,    // 8bit red 
    output wire [7:0] o_green,  // 8bit green
    output wire [7:0] o_blue,   // 8bit blue
    input wire [15:0] shoot_x,  // input : shoot_ x
    input wire [15:0] shoot_y,   // input : shoot_ y
    output wire o_sprite_hit,    // sprite �� hit �Ǿ��� ��츦 �Ǵ��ϱ� ���� 1bit �Ҵ� , hit�� 1 , �ƴϸ� 0 
    output wire [15:0] sprite_x_pos, // �ܺ� ���� �����ϱ� ���� x location ���� 
    output wire [15:0] sprite_y_pos,  // �ܺ� ���� �����ϱ� ���� y location ���� 
    output wire score,          // �ܺθ��� �����ϱ� ���� score
    
    input wire hit_sig,
    input wire [15:0] player_x_pos, //player�� x,y��ǥ
    input wire [15:0] player_y_pos
    );

    reg [15:0] sprite_x;   // sprite image x axis
    reg [15:0] sprite_y;   // sprite image y axis
    reg sprite_x_direction = 1;
    /////////////////////////////// enemy projectile shoot signal /////////////////////////////////////
//    reg shoot = 0;
//    assign shoot_control = shoot;
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // �ܺ� ���� �����ϱ� ���� x location ���� �� �� ����� sprite _ x �� ���� 
    assign sprite_y_pos = sprite_y; // �ܺ� ���� �����ϱ� ���� y location ���� �� �� ����� sprite_ y�� ���� 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    reg sprite_x_flip       = 0;        // sprite�� x�� �ü� ���� 
    reg sprite_y_flip       = 0;        // sprite�� y�� �ü� ���� 
    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y �� active region���� �������� ���� �˸��� ���� hit 1bit wire 
    wire [3:0] sprite_render_x;         // spirte render x��, 4bit , 0~15
    wire [3:0] sprite_render_y;         // spirte render y��, 4bit , 0~ 15 
    
    //////////////////////////////////////////score///////////////////////////////////////////////////
    reg cnt = 0;                // score count�� ���� �ڷ��� ����
    assign score = cnt;         // gfx ���� �����ϱ� ���� ���� 
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4�� 3�� data, �� pixel �� 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00,    // RGB - 0 : black -> hexadecimal : 00 00 00                    ===> BLACK : 4'd0
        8'hFF, 8'h00, 8'h00,    // R - 255 , G- 0 , B - 0 : RED -> hexadecimal : FF 00 00       ===> RED : 4'd1
        8'h21, 8'hFF, 8'h21,    // R - 33, G - 255, B - 33 : GREEN -> hexadecimal : 21 FF 21  ===> GREEN : 4'd2
        8'hFF, 8'hFF, 8'h21     // R - 255, G - 255, B - 33 : BLUE -> hexadecimal : 21 21 FF     ===> YELLOW : 4'd3
    };
   
    localparam [0:15][0:15][3:0] sprite_data = {     // pixel data 16 X 16 ( data ������ 15 �� 16 �� ( 16 X 15 ) ������ color table 0~3 ���� �� �װ� (black, red, white, blue)

    // ��1--------------------------------------------------------------------<- ��1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd0,4'd3,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd3,4'd0,4'd3,4'd0,4'd0, 
    4'd0,4'd0,4'd3,4'd0,4'd3,4'd0,4'd1,4'd1,4'd1,4'd1,4'd0,4'd3,4'd0,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd0,4'd3,4'd0,4'd1,4'd2,4'd2,4'd1,4'd0,4'd3,4'd0,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd3,4'd2,4'd1,4'd2,4'd2,4'd1,4'd2,4'd3,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd3,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd3,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd0,4'd1,4'd2,4'd1,4'd0,4'd0,4'd1,4'd2,4'd1,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd1,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd1,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
    // modified !! size : ����, x = 16 * 4 = 64
    //             size : ����, x = 16 * 4 = 64 ( �״�� )
    
    // �浹�� notcollision = 0 , �浹 �� notcollision = 2, 1 ; -> 1�� ���ҽ��� 0�� �Ǹ� hit ���� 
    
    reg notcollision = 1; 
    // �浹�ϸ� notcollision = 0 �̵Ǿ� sprite_hit_x, y �� 0���� ����� ��µ��� �ʵ��� �� 
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 64) && (notcollision != 0) && (hit_sig == 1);  // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 64
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 64) && (notcollision != 0) && (hit_sig == 1);  // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 64

    // ������
    assign sprite_render_x = (i_x - sprite_x)>>2;   // sprite render x = ( x poistion - sprite x postion ) / 4, ex 64/4 = 16pixels
    assign sprite_render_y = (i_y - sprite_y)>>2;   // sprite render y = ( y poistion - sprite y postion ) / 4
    
    wire [1:0] selected_palette; // 4'd0 ~ 4'd3 �� cover�ϱ� ���� 2bit ���� , 2bit = 00 01 10 11 -> 0~3 cover
    
    assign selected_palette = sprite_x_flip ? (sprite_y_flip ? sprite_data[15-sprite_render_y][15-sprite_render_x]: sprite_data[sprite_render_y][15-sprite_render_x])
                                            : (sprite_y_flip ? sprite_data[15-sprite_render_y][sprite_render_x]   : sprite_data[sprite_render_y][sprite_render_x]);
    
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // spirte_x �� active region�� ������ �� spirte image data�� color �� �������� ��Ÿ�� �� �ְ� �� 
         
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
        sprite_x <= 16'd1280; // x��ǥ 1280���� ����

        sprite_y <= 16'd0;           // y���� ������ 0 ����ŭ ������ ���� 
        
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @(posedge i_v_sync) begin    // ���Ⱑ �Ѿ˿� �ε������� �˻�, notcollision signal�� �߻���Ŵ
    if(hit_sig==1) begin
       sprite_y <= sprite_y+2;        // �������� ���� setting, y�࿡�� 1�� �ӵ��� ������, x�࿡�� 2�� �ӵ��� �������ΰ�
       sprite_x <= sprite_x-3; 
            if ((notcollision != 0)&&(((shoot_x > sprite_x) && (shoot_x < sprite_x + 64) && (shoot_y <= sprite_y-64))
                ||((player_x_pos + 84 > sprite_x) && (player_x_pos < sprite_x + 64) && (player_y_pos + 84 > sprite_y) && (player_y_pos < sprite_y + 64)))) begin 
                // ���� 1�� �浹�ϴ� ����, player�� �浿�ϴ� ���� notcollision = 0�� �Ǿ� hit �߻� x
                notcollision <= 0;  // �ε����� notcollision = 0�� �� -> ������ ǥ�õ��� ����  
                cnt<=1;         // �ܺ� ���� ����Ǵ� cnt�� 1�� �Ҵ� -> score count
                end
            else if (sprite_y == 16'd720 || sprite_x == -16'd64) begin
                sprite_x <= 16'd1280;
                sprite_y <= 16'd0;
                end   
            end
        // stage 3������ �Ѿ��� �ι��� �߻��ϵ��� 
//        else if (sprite_x == 1100 && notcollision == 2)       // shoot signal 
//            shoot <= notcollision - 1;                        // enemy�� ����ִٸ� �Ѿ��� �߻������� �׷��� �ʴٸ� �Ѿ� �߻� x -> notcollision = 0 : �浹�����̹Ƿ� 
//        else if (sprite_x == 1100 && notcollision != 2)      
//            shoot <= notcollision;                          // not collision�� 1 �Ǵ� 0�϶� , shoot signal�� ���. ���Ⱑ �μ����� notcollision = 0�̹Ƿ� shoot signal�� �߻����� �ʴ´�. 
//        else
//            shoot <= 0;    
        end
endmodule
