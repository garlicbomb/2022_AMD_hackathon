module boss ( //stage 5 boss
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
    output wire shoot_control,
    input wire hit_sig,
    input wire [15:0] player_x_pos, //player�� x,y��ǥ
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
    assign sprite_x_pos = sprite_x; // �ܺ� ���� �����ϱ� ���� x location ���� �� �� ����� sprite _ x �� ���� 
    assign sprite_y_pos = sprite_y; // �ܺ� ���� �����ϱ� ���� y location ���� �� �� ����� sprite_ y�� ���� 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y �� active region���� �������� ���� �˸��� ���� hit 1bit wire 
    wire [6:0] sprite_render_x;         // spirte render x��, 7bit , 0~127
    wire [5:0] sprite_render_y;         // spirte render y��, 6bit , 0~ 63 
    
    //////////////////////////////////////////score///////////////////////////////////////////////////
    reg cnt = 0;                // score count�� ���� �ڷ��� ����
    assign score = cnt;         // gfx ���� �����ϱ� ���� ���� 
    //////////////////////////////////////////////////////////////////////////////////////////////////

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4�� 3�� data, �� pixel �� 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00,    // RGB - 0 : black -> hexadecimal : 00 00 00                    ===> BLACK : 4'd0
        8'h8F, 8'h5E, 8'h00,    // R - 135 , G- 94 , B - 0 : Brown -> hexadecimal : 8F 00 00       ===> BROWN : 4'd1(main ��� ��)
        8'hFF, 8'hFF, 8'hFF,    // R - 255, G - 255, B - 255 : White -> hexadecimal : FF FF FF  ===> WHITE : 4'd2(�׾�� �ϴ� ��� ǥ��)
        8'h5D, 8'h5D, 8'h5D    // R - 93, G - 93, B - 93 : gray -> hexadecimal : 93 93 93     ===> GRAY : 4'd3(�׵θ�)
    };
   
    localparam [0:56][0:100][3:0] sprite_data = {     // pixel data 16 X 16 ( data ������ 15 �� 16 �� ( 16 X 15 ) ������ color table 0~3 ���� �� �װ� (black, red, white, blue)

    // ��1--------------------------------------------------------------------<- ��1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd1,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd1,4'd1,4'd1,4'd1,4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd2,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd3,4'd3,4'd3,4'd3,4'd3,4'd3,4'd8,4'd3,4'd3,4'd3,4'd3,4'd3,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0
    };
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
    // modified !! size : ����, x = 16 * 4 = 64
    //             size : ����, x = 16 * 4 = 64 ( �״�� )
    
    // �浹�� notcollision = 0 , �浹 �� notcollision = 1, player�� �ѿ� ������ 0�� �Ǿ� �����.
    
    reg [5:0] notcollision = 50;  //50�� ������ ������
    // �浹�ϸ� notcollision = 0 �̵Ǿ� sprite_hit_x, y �� 0���� ����� ��µ��� �ʵ��� �� 
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 404) && (notcollision != 0) && (hit_sig == 1);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 64
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 228) && (notcollision != 0) && (hit_sig == 1);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 64

    // ������
    assign sprite_render_x = (i_x - sprite_x)>>2;   // sprite render x = ( x poistion - sprite x postion ) / 4, ex 64/4 = 16pixels
    assign sprite_render_y = (i_y - sprite_y)>>2;   // sprite render y = ( y poistion - sprite y postion ) / 4
    
    wire [1:0] selected_palette; // 4'd0 ~ 4'd3 �� cover�ϱ� ���� 2bit ���� , 2bit = 00 01 10 11 -> 0~3 cover
    
    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];
    
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
        sprite_x <= 16'd640 ; // 1280 ������ �߰��� 640 ���� ���� 5�� �̹����� 1/2 ���� 190�� ��
        //-> ������ ����� ��ġ�� �� �ֵ��� 
        sprite_y <= 16'd0;           // y���� ������ 0 ����ŭ ������ ���� 
        
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @(posedge i_v_sync) begin    // ���Ⱑ �Ѿ˿� �ε������� �˻�, notcollision signal�� �߻���Ŵ
        if (hit_sig == 1 && (notcollision != 0)) begin
        shoot <= 1; end
        else begin
        shoot <= 0; end
        if(hit_sig==1) begin
            sprite_y <= sprite_y+2;        // �������� ���� setting, y�࿡�� 1�� �ӵ��� ������
            sprite_x <= sprite_x; 
                if ((notcollision != 0) && ((shoot_x > sprite_x) && (shoot_x < sprite_x + 404) && (shoot_y <= sprite_y + 228) && (shoot_y > sprite_y + 222))) begin 
                // ���� 1�� �浹�ϴ� ����, player�� �浿�ϴ� ���� notcollision = 0�� �Ǿ� hit �߻� x
                notcollision = notcollision - 1;
                if ( notcollision == 0);  // �ε����� notcollision = 0�� �� -> ������ ǥ�õ��� ����  
                cnt<=1;         // �ܺ� ���� ����Ǵ� cnt�� 1�� �Ҵ� -> score count
                 
                if (sprite_y == 16'd228) begin
                    sprite_x <= sprite_x + (sprite_x_direction ? 1 : -1);
                    sprite_y <= sprite_y;
                    if (sprite_x == 640-80)
                        sprite_x_direction <=1;
                    else if (sprite_x == 640+80)
                        sprite_x_direction <=0;
                        end
            end   
        end
        
        

        //else (sprite_x  == 640 - 190 + 450 - 64)
          //  sprite_x_direction <= 1;                            
            // stage 3������ �Ѿ��� �ι��� �߻��ϵ��� 
     //   else if (sprite_x == 300 && notcollision == 2)       // shoot signal 
          //  shoot <= notcollision - 1;                        // enemy�� ����ִٸ� �Ѿ��� �߻������� �׷��� �ʴٸ� �Ѿ� �߻� x -> notcollision = 0 : �浹�����̹Ƿ� 
       // else if (sprite_x == 300 && notcollision != 2)      
         //   shoot <= notcollision;                          // not collision�� 1 �Ǵ� 0�϶� , shoot signal�� ���. ���Ⱑ �μ����� notcollision = 0�̹Ƿ� shoot signal�� �߻����� �ʴ´�. 
      //  else
         //   shoot <= 0;    
     end


endmodule