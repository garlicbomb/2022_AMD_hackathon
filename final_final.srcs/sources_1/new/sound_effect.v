

module sound_effect(
    ///////////// FOR AHB ////////////////////////
    input wire HCLK,
    input wire [31:0]M_AHB_0_haddr,
    input wire[2:0]M_AHB_0_hburst,
    input wire M_AHB_0_hmastlock,
    input wire [3:0]M_AHB_0_hprot,
    output reg [31:0]M_AHB_0_hrdata,
    output wire M_AHB_0_hready,
    output wire M_AHB_0_hresp,
    input wire [2:0]M_AHB_0_hsize,
    input wire [1:0]M_AHB_0_htrans,
    input wire [31:0]M_AHB_0_hwdata,
    input wire M_AHB_0_hwrite,
    
    // sound effect // 
    input wire btn2, // player shoot projectile effect 
    input wire [4:0] total_score,    // enemy_destory effect & stage change effect
    input wire [2:0] life,           // player hit effect 
    input wire enemy_shoot_e1, enemy_shoot_e2,enemy_shoot_e3, enemy_shoot_e4, enemy_shoot_e5,enemy_shoot_stage4_e1, enemy_shoot_stage4_e2,enemy_shoot_stage4_e3,
    input wire item_1_get, item_2_get
    );
    ///////////////////////// enemy shoot effect ///////////////////////////////////////
    reg e1_shoot_effect, e2_shoot_effect, e3_shoot_effect, e4_shoot_effect, e5_shoot_effect;
    
    //////////////////////////////////// life hit effect///////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////////
    
    assign M_AHB_0_hready = 1'b1;
    assign M_AHB_0_hresp = 1'b0;
    /// Memory register ///
    reg [31:0] mem_A;   /// addr 0              // mem_A 
    reg [31:0] mem_B;   /// addr 1
    reg [31:0] mem_C;   /// addr 2
    reg [31:0] mem_D;   /// addr 3
    reg [31:0] mem_E;   /// addr 4
    reg [31:0] mem_F;   /// addr 5
    reg [31:0] mem_G;   /// addr 6
    reg [31:0] mem_H;   /// addr 7
    ///////////////////////
     ///////////// AHB ////////////////////////
    ///////////// FOR AHB ////////////////////
    
    
    reg [1:0] w_ctrl;     // write type 2bit
    
    reg [1:0] r_ctrl;     // read type 2bit
    
    reg [4:0] w_addr;     // 16 ������ address write -> 3bit ���� (0~7) mem_A~mem_H
    
    reg [4:0] r_addr;    // 16 ������ address read ���� -> 4bit ���� (0~8) mem_i�� �߰��� ���Ե�
    
    ///////// WRITE //////////
    always@(posedge HCLK)
    begin 
        if(M_AHB_0_hwrite == 1'b1)      // hwrite = 1 -> write mode
        begin
        case(M_AHB_0_htrans)
            2'b00 : // IDLE
            begin
                w_ctrl <= 2'b00;
            end
            2'b01 : // BUSY
            begin
                w_ctrl <= 2'b01;
            end
            2'b10 : // NONSEQ
            begin
                w_ctrl <= 2'b10;
                w_addr <= M_AHB_0_haddr[4:2];   // word(4byte) alinged, 3bit
            end
            2'b11 : // SEQ
            begin
                w_ctrl <= 2'b11;
            end
        endcase
        end
   end
    
    always@(posedge HCLK) // write data phase
    begin
    case(w_ctrl)
        2'b00: // IDLE
        begin        
        end
        2'b01: // BUSY
        begin
        end
        2'b10: // NONSEQ
        begin
        case(w_addr)
            5'h0 : mem_A <= M_AHB_0_hwdata; // base address : 0X43C00000�� mem_A�� mapping
            5'h1 : mem_B <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X04�� data�� mem_B�� mapping
            5'h2 : mem_C <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X08�� data�� mem_C�� mapping
            5'h3 : mem_D <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X0C�� data�� mem_D�� mapping
            5'h4 : mem_E <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X10�� data�� mem_E�� mapping
            5'h5 : mem_F <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X14�� data�� mem_F�� mapping
            5'h6 : mem_G <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X18�� data�� mem_G�� mapping
            5'h7 : mem_H <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X1C�� data�� mem_H�� mapping
        endcase
        end
        2'b11: // SEQ
        begin
        case(w_addr)
            5'h0 : mem_A <= M_AHB_0_hwdata; // base address : 0X43C00000�� mem_A�� mapping
            5'h1 : mem_B <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X04�� data�� mem_B�� mapping
            5'h2 : mem_C <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X08�� data�� mem_C�� mapping
            5'h3 : mem_D <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X0C�� data�� mem_D�� mapping
            5'h4 : mem_E <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X10�� data�� mem_E�� mapping
            5'h5 : mem_F <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X14�� data�� mem_F�� mapping
            5'h6 : mem_G <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X18�� data�� mem_G�� mapping
            5'h7 : mem_H <= M_AHB_0_hwdata; // base address : 0X43C00000 + 0X1C�� data�� mem_H�� mapping
        endcase
        end
    endcase
    end
    
    ///////// READ //////////
    always@(posedge HCLK)
    begin 
        if(M_AHB_0_hwrite == 1'b0)      // hwrite = 0 -> read mode
        begin
        case(M_AHB_0_htrans)
            2'b00 : // IDLE
            begin
                r_ctrl <= 2'b00;        // read control 
            end
            2'b01 : // BUSY
            begin
                r_ctrl <= 2'b01;
            end
            2'b10 : // NONSEQ
            begin
                r_ctrl <= 2'b10;
                r_addr <= M_AHB_0_haddr[5:2];   // word(4byte) alinged, 4bit declared, to read
            end
            2'b11 : // SEQ
            begin
                r_ctrl <= 2'b11;
            end
        endcase
        end
   end
    
    always@(*) // read data phase
    begin
        case(r_ctrl)
            2'b00: // IDLE
            begin        
            end
            2'b01: // BUSY
            begin
            end
            2'b10: // NONSEQ
            begin
            case(r_addr)                        // �ռ� case�� ������ �Ҵ��Ͽ��� addr�� �ٽ� case���� ���ؼ� �� ���ǿ� ���� ���� 
                5'h0 : M_AHB_0_hrdata <= btn2; // base address �� mem_A data�� read�� mapping
                5'h1 : M_AHB_0_hrdata <= total_score; // base address + 0X04�� mem_B data�� read�� mapping
                5'h2 : M_AHB_0_hrdata <= life; // base address + 0X08�� mem_C data�� read�� mapping
                5'h3 : M_AHB_0_hrdata <= enemy_shoot_e1;// base address + 0X0C�� mem_D data�� read�� mapping
                5'h4 : M_AHB_0_hrdata <= enemy_shoot_e2;  // base address + 0X10�� mem_E data�� read�� mapping
                5'h5 : M_AHB_0_hrdata <= enemy_shoot_e3;// base address + 0X14�� mem_F data�� read�� mapping
                5'h6 : M_AHB_0_hrdata <= enemy_shoot_e4; // base address + 0X18�� mem_G data�� read�� mapping
                5'h7 : M_AHB_0_hrdata <= enemy_shoot_e5; // base address + 0X1C�� mem_H data�� read�� mapping
                5'h8 : M_AHB_0_hrdata <= enemy_shoot_stage4_e1; // base address + 0X1C�� mem_H data�� read�� mapping
                5'h9 : M_AHB_0_hrdata <= enemy_shoot_stage4_e2; // base address + 0X20�� mem_H data�� read�� mapping
                5'h10 :M_AHB_0_hrdata <= enemy_shoot_stage4_e3; // base address  + 0X24�� mem_H data�� read�� mapping
                5'h11 :M_AHB_0_hrdata <= item_1_get; // base address  + 0X28�� mem_H data�� read�� mapping
                5'h11 :M_AHB_0_hrdata <= item_2_get; // base address + 0X2C�� mem_H data�� read�� mapping
                
            endcase
        end
        2'b11: // SEQ
        begin
            case(r_addr)
                5'h0 : M_AHB_0_hrdata <= btn2; // base address �� mem_A data�� read�� mapping
                5'h1 : M_AHB_0_hrdata <= total_score; // base address + 0X04�� mem_B data�� read�� mapping
                5'h2 : M_AHB_0_hrdata <= life; // base address + 0X08�� mem_C data�� read�� mapping
                5'h3 : M_AHB_0_hrdata <= enemy_shoot_e1;// base address + 0X0C�� mem_D data�� read�� mapping
                5'h4 : M_AHB_0_hrdata <= enemy_shoot_e2;  // base address + 0X10�� mem_E data�� read�� mapping
                5'h5 : M_AHB_0_hrdata <= enemy_shoot_e3;// base address + 0X14�� mem_F data�� read�� mapping
                5'h6 : M_AHB_0_hrdata <= enemy_shoot_e4; // base address + 0X18�� mem_G data�� read�� mapping
                5'h7 : M_AHB_0_hrdata <= enemy_shoot_e5; // base address + 0X1C�� mem_H data�� read�� mapping
                5'h8 : M_AHB_0_hrdata <= enemy_shoot_stage4_e1; // base address + 0X1C�� mem_H data�� read�� mapping
                5'h9 : M_AHB_0_hrdata <= enemy_shoot_stage4_e2; // base address + 0X20�� mem_H data�� read�� mapping
                5'h10 :M_AHB_0_hrdata <= enemy_shoot_stage4_e3; // base address  + 0X24�� mem_H data�� read�� mapping
                5'h11 :M_AHB_0_hrdata <= item_1_get; // base address  + 0X28�� mem_H data�� read�� mapping
                5'h11 :M_AHB_0_hrdata <= item_2_get; // base address + 0X2C�� mem_H data�� read�� mapping
                
            endcase
        end
    endcase
end    

endmodule
