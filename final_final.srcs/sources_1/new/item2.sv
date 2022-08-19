module item2(    // item
    input wire [15:0] i_x, // x axis 
    input wire [15:0] i_y, // y axis 
    input wire i_v_sync,    // vertical sync 
    output wire [7:0] o_red,    // 8bit red 
    output wire [7:0] o_green,  // 8bit green
    output wire [7:0] o_blue,   // 8bit blue
    ///////////////////////////////////////////////////////////////////
    output wire o_sprite_hit,    // sprite �� hit �Ǿ��� ��츦 �Ǵ��ϱ� ���� 1bit �Ҵ� , hit�� 1 , �ƴϸ� 0 
    output wire [15:0] sprite_x_pos, // �ܺ� ���� �����ϱ� ���� x location ���� 
    output wire [15:0] sprite_y_pos,  // �ܺ� ���� �����ϱ� ���� y location ���� 
    
    input wire item_begin             // item begin signal 
    );
    
    reg [15:0] sprite_x;   // sprite image x axis
    reg [15:0] sprite_y;   // sprite image y axis

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // �ܺ� ���� �����ϱ� ���� x location ���� �� �� ����� sprite _ x �� ���� 
    assign sprite_y_pos = sprite_y; // �ܺ� ���� �����ϱ� ���� y location ���� �� �� ����� sprite_ y�� ���� 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y �� active region���� �������� ���� �˸��� ���� hit 1bit wire 
    wire [3:0] sprite_render_x;         // spirte render x��, 5bit , 0~15
    wire [3:0] sprite_render_y;         // spirte render y��, 5bit , 0~15 

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4�� 3�� data, �� pixel �� 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00, // black       4'd0
        8'hBD, 8'hBD, 8'hBD,  // GRAY    4'd1
        8'h3F, 8'h00, 8'h99,    // purple  4'd2
        8'hFF, 8'hF4, 8'h00     // yellow   4'd3
    };
   
    localparam [0:8][0:12][3:0] sprite_data = {     // pixel data 16 X 16 ( data ������ 15 �� 16 �� ( 16 X 15 ) ������ color table 0~3 ���� �� �װ� (black, red, white, blue)

    // ��1--------------------------------------------------------------------<- ��1
    4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,
    4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd2,
    4'd0,4'd0,4'd0,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd0,4'd0,4'd2,4'd2,
    4'd0,4'd0,4'd2,4'd1,4'd1,4'd3,4'd3,4'd3,4'd1,4'd2,4'd2,4'd1,4'd2,
    4'd2,4'd2,4'd1,4'd1,4'd1,4'd1,4'd3,4'd1,4'd1,4'd2,4'd1,4'd1,4'd2,
    4'd0,4'd0,4'd2,4'd1,4'd1,4'd1,4'd3,4'd1,4'd1,4'd2,4'd2,4'd1,4'd2,
    4'd0,4'd0,4'd0,4'd2,4'd1,4'd1,4'd1,4'd1,4'd2,4'd0,4'd0,4'd2,4'd2,
    4'd0,4'd0,4'd0,4'd0,4'd2,4'd2,4'd2,4'd2,4'd0,4'd0,4'd0,4'd0,4'd2
    };
    /////////////////////////////////////////// modified ////////////////////////////////////////////////////////////////////////////////////
    reg notcollision = 1; 
    reg [1:0] item_true=2;

    // �浹�ϸ� notcollision = 0 �̵Ǿ� sprite_hit_x, y �� 0���� ����� ��µ��� �ʵ��� �� 
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 52) && (item_begin == 1) && (item_true == 1);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 64
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 36) && (item_begin == 1) && (item_true == 1);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 64

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
        sprite_x <= 16'd650; // 1280 ������ �߰��� 640 ���� ���� 5�� �̹����� 1/2 ���� 190�� ��
        //-> ������ ����� ��ġ�� �� �ֵ��� 
        sprite_y <= 0;           // 
    end
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
     always @(posedge i_v_sync) begin    
          if ((item_begin == 1 )&& (item_true != 0)) begin
               item_true <= 1;
               sprite_y <= sprite_y +1;
               if (sprite_y == 720) item_true <= 0;
          end
        
        end
// end
endmodule
