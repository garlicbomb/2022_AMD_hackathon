module item2(    // item
    input wire [15:0] i_x, // x axis 
    input wire [15:0] i_y, // y axis 
    input wire i_v_sync,    // vertical sync 
    output wire [7:0] o_red,    // 8bit red 
    output wire [7:0] o_green,  // 8bit green
    output wire [7:0] o_blue,   // 8bit blue
    ///////////////////////////////////////////////////////////////////
    output wire o_sprite_hit,    // sprite 가 hit 되었을 경우를 판단하기 위한 1bit 할당 , hit시 1 , 아니면 0 
    output wire [15:0] sprite_x_pos, // 외부 모듈과 연결하기 위해 x location 선언 
    output wire [15:0] sprite_y_pos,  // 외부 모듈과 연결하기 위해 y location 선언 
    
    input wire item_begin             // item begin signal 
    );
    
    reg [15:0] sprite_x;   // sprite image x axis
    reg [15:0] sprite_y;   // sprite image y axis

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    assign sprite_x_pos = sprite_x; // 외부 모듈과 연결하기 위해 x location 선언 및 본 모듈의 sprite _ x 와 연결 
    assign sprite_y_pos = sprite_y; // 외부 모듈과 연결하기 위해 y location 선언 및 본 모듈의 sprite_ y와 연결 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    wire sprite_hit_x, sprite_hit_y;    // spirte x, spirte y 가 active region끝에 도달했을 때를 알리기 위한 hit 1bit wire 
    wire [3:0] sprite_render_x;         // spirte render x축, 5bit , 0~15
    wire [3:0] sprite_render_y;         // spirte render y축, 5bit , 0~15 

    localparam [0:3][2:0][7:0] palette_colors =  { // Color table , 4(color) * 3 (R,G,B) * 8bit(0~255) // 4행 3열 data, 각 pixel 은 8bit 
       // R      G       B // 
        8'h00, 8'h00, 8'h00, // black       4'd0
        8'hBD, 8'hBD, 8'hBD,  // GRAY    4'd1
        8'h3F, 8'h00, 8'h99,    // purple  4'd2
        8'hFF, 8'hF4, 8'h00     // yellow   4'd3
    };
   
    localparam [0:8][0:12][3:0] sprite_data = {     // pixel data 16 X 16 ( data 상으로 15 행 16 열 ( 16 X 15 ) 각각의 color table 0~3 으로 총 네개 (black, red, white, blue)

    // 적1--------------------------------------------------------------------<- 적1
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

    // 충돌하면 notcollision = 0 이되어 sprite_hit_x, y 를 0으로 만들어 출력되지 않도록 함 
    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 52) && (item_begin == 1) && (item_true == 1);   // sprite_hit_x = 1 when spirte_x <= i_x < sprite_x + 64
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 36) && (item_begin == 1) && (item_true == 1);   // sprite_hit_y = 1 when spirte_y <= i_y < sprite_y + 64

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
        sprite_x <= 16'd650; // 1280 가로의 중간인 640 에서 적들 5개 이미지의 1/2 값인 190을 뺌
        //-> 적들이 가운데에 위치할 수 있도록 
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
