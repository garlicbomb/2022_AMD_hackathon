`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 19:08:49
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    inout wire [14:0]DDR_addr,
    inout wire [2:0]DDR_ba,
    inout wire DDR_cas_n,
    inout wire DDR_ck_n,
    inout wire DDR_ck_p,
    inout wire DDR_cke,
    inout wire DDR_cs_n,
    inout wire [3:0]DDR_dm,
    inout wire [31:0]DDR_dq,
    inout wire [3:0]DDR_dqs_n,
    inout wire [3:0]DDR_dqs_p,
    inout wire DDR_odt,
    inout wire DDR_ras_n,
    inout wire DDR_reset_n,
    inout wire DDR_we_n,
    inout wire FIXED_IO_ddr_vrn,
    inout wire FIXED_IO_ddr_vrp,
    inout wire [53:0]FIXED_IO_mio,
    inout wire FIXED_IO_ps_clk,
    inout wire FIXED_IO_ps_porb,
    inout wire FIXED_IO_ps_srstb,
    input wire RST_BTN,
    output wire bclk,
    input wire btn1,
    input wire btn2,
    input wire btn3,
    output wire clk_lock,
    output wire de,
    inout wire hdmi_tx_cec,
    output wire hdmi_tx_clk_n,
    output wire hdmi_tx_clk_p,
    input wire hdmi_tx_hpd,
    output wire [2:0]hdmi_tx_n,
    output wire [2:0]hdmi_tx_p,
    inout wire hdmi_tx_rscl,
    inout wire hdmi_tx_rsda,
    output wire led,
    output wire lrclk,
    output wire mclk,
    input wire miso,
    output wire mosi,
    output wire sclk,
    output wire sdata,
    output wire ss,
    input wire [1:0]sw
    );
    
    wire HCLK;
    wire [31:0]M_AHB_0_haddr;
    wire [2:0]M_AHB_0_hburst;
    wire M_AHB_0_hmastlock;
    wire [3:0]M_AHB_0_hprot;
    wire [31:0]M_AHB_0_hrdata;
    wire M_AHB_0_hready;
    wire M_AHB_0_hresp;
    wire [2:0]M_AHB_0_hsize;
    wire [1:0]M_AHB_0_htrans;
    wire [31:0]M_AHB_0_hwdata;
    wire M_AHB_0_hwrite;

     /////////////////////// sound effect /////////////////////
    wire [4:0] total_score;    // enemy_destory effect & stage change effect
    wire [2:0] life;           // player hit effect 
    wire enemy_shoot_e1, enemy_shoot_e2,enemy_shoot_e3, enemy_shoot_e4, enemy_shoot_e5,enemy_shoot_stage4_e1, enemy_shoot_stage4_e2,enemy_shoot_stage4_e3;
    wire item_1_get, item_2_get;
    
    
    design_1_wrapper zynq_module
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .HCLK(HCLK),
        .M_AHB_0_haddr(M_AHB_0_haddr),
        .M_AHB_0_hburst(M_AHB_0_hburst),
        .M_AHB_0_hmastlock(M_AHB_0_hmastlock),
        .M_AHB_0_hprot(M_AHB_0_hprot),
        .M_AHB_0_hrdata(M_AHB_0_hrdata),
        .M_AHB_0_hready(M_AHB_0_hready),
        .M_AHB_0_hresp(M_AHB_0_hresp),
        .M_AHB_0_hsize(M_AHB_0_hsize),
        .M_AHB_0_htrans(M_AHB_0_htrans),
        .M_AHB_0_hwdata(M_AHB_0_hwdata),
        .M_AHB_0_hwrite(M_AHB_0_hwrite),
        .RST_BTN(RST_BTN),
        .bclk(bclk),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .clk_lock(clk_lock),
        .de(de),
        .hdmi_tx_cec(hdmi_tx_cec),
        .hdmi_tx_clk_n(hdmi_tx_clk_n),
        .hdmi_tx_clk_p(hdmi_tx_clk_p),
        .hdmi_tx_hpd(hdmi_tx_hpd),
        .hdmi_tx_n(hdmi_tx_n),
        .hdmi_tx_p(hdmi_tx_p),
        .hdmi_tx_rscl(hdmi_tx_rscl),
        .hdmi_tx_rsda(hdmi_tx_rsda),
        .led(led),
        .lrclk(lrclk),
        .mclk(mclk),
        .miso(miso),
        .mosi(mosi),
        .sclk(sclk),
        .sdata(sdata),
        .ss(ss),
        .sw(sw),
        .total_score(total_score),
        .life(life),
        .enemy_shoot_e1(enemy_shoot_e1),
        .enemy_shoot_e2(enemy_shoot_e2),
        .enemy_shoot_e3(enemy_shoot_e3),
        .enemy_shoot_e4(enemy_shoot_e4),
        .enemy_shoot_e5(enemy_shoot_e5),
        .enemy_shoot_stage4_e1(enemy_shoot_stage4_e1),
        .enemy_shoot_stage4_e2(enemy_shoot_stage4_e2),
        .enemy_shoot_stage4_e3(enemy_shoot_stage4_e3),
        .item_1_get(item_1_get),
        .item_2_get(item_2_get));
        
        sound_effect sound_effect (
        .HCLK(HCLK),
        .M_AHB_0_haddr(M_AHB_0_haddr),
        .M_AHB_0_hburst(M_AHB_0_hburst),
        .M_AHB_0_hmastlock(M_AHB_0_hmastlock),
        .M_AHB_0_hprot(M_AHB_0_hprot),
        .M_AHB_0_hrdata(M_AHB_0_hrdata),
        .M_AHB_0_hready(M_AHB_0_hready),
        .M_AHB_0_hresp(M_AHB_0_hresp),
        .M_AHB_0_hsize(M_AHB_0_hsize),
        .M_AHB_0_htrans(M_AHB_0_htrans),
        .M_AHB_0_hwdata(M_AHB_0_hwdata),
        .M_AHB_0_hwrite(M_AHB_0_hwrite),
        .btn2(btn2),
        .total_score(total_score),
        .life(life),
        .enemy_shoot_e1(enemy_shoot_e1),
        .enemy_shoot_e2(enemy_shoot_e2),
        .enemy_shoot_e3(enemy_shoot_e3),
        .enemy_shoot_e4(enemy_shoot_e4),
        .enemy_shoot_e5(enemy_shoot_e5),
        .enemy_shoot_stage4_e1(enemy_shoot_stage4_e1),
        .enemy_shoot_stage4_e2(enemy_shoot_stage4_e2),
        .enemy_shoot_stage4_e3(enemy_shoot_stage4_e3),
        .item_1_get(item_1_get),
        .item_2_get(item_2_get)
        );
        
     
endmodule
