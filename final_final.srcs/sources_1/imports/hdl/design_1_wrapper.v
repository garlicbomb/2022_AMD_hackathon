//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
//Date        : Sat Jul  2 22:38:39 2022
//Host        : tueszero running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    HCLK,
    M_AHB_0_haddr,
    M_AHB_0_hburst,
    M_AHB_0_hmastlock,
    M_AHB_0_hprot,
    M_AHB_0_hrdata,
    M_AHB_0_hready,
    M_AHB_0_hresp,
    M_AHB_0_hsize,
    M_AHB_0_htrans,
    M_AHB_0_hwdata,
    M_AHB_0_hwrite,
    RST_BTN,
    bclk,
    btn1,
    btn2,
    btn3,
    clk_lock,
    de,
    enemy_shoot_e1,
    enemy_shoot_e2,
    enemy_shoot_e3,
    enemy_shoot_e4,
    enemy_shoot_e5,
    enemy_shoot_stage4_e1,
    enemy_shoot_stage4_e2,
    enemy_shoot_stage4_e3,
    hdmi_tx_cec,
    hdmi_tx_clk_n,
    hdmi_tx_clk_p,
    hdmi_tx_hpd,
    hdmi_tx_n,
    hdmi_tx_p,
    hdmi_tx_rscl,
    hdmi_tx_rsda,
    item_1_get,
    item_2_get,
    led,
    life,
    lrclk,
    mclk,
    miso,
    mosi,
    sclk,
    sdata,
    ss,
    sw,
    total_score);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output HCLK;
  output [31:0]M_AHB_0_haddr;
  output [2:0]M_AHB_0_hburst;
  output M_AHB_0_hmastlock;
  output [3:0]M_AHB_0_hprot;
  input [31:0]M_AHB_0_hrdata;
  input M_AHB_0_hready;
  input M_AHB_0_hresp;
  output [2:0]M_AHB_0_hsize;
  output [1:0]M_AHB_0_htrans;
  output [31:0]M_AHB_0_hwdata;
  output M_AHB_0_hwrite;
  input RST_BTN;
  output bclk;
  input btn1;
  input btn2;
  input btn3;
  output clk_lock;
  output de;
  output enemy_shoot_e1;
  output enemy_shoot_e2;
  output enemy_shoot_e3;
  output enemy_shoot_e4;
  output enemy_shoot_e5;
  output enemy_shoot_stage4_e1;
  output enemy_shoot_stage4_e2;
  output enemy_shoot_stage4_e3;
  inout hdmi_tx_cec;
  output hdmi_tx_clk_n;
  output hdmi_tx_clk_p;
  input hdmi_tx_hpd;
  output [2:0]hdmi_tx_n;
  output [2:0]hdmi_tx_p;
  inout hdmi_tx_rscl;
  inout hdmi_tx_rsda;
  output item_1_get;
  output item_2_get;
  output led;
  output [2:0]life;
  output lrclk;
  output mclk;
  input miso;
  output mosi;
  output sclk;
  output sdata;
  output ss;
  input [1:0]sw;
  output [4:0]total_score;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
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
  wire RST_BTN;
  wire bclk;
  wire btn1;
  wire btn2;
  wire btn3;
  wire clk_lock;
  wire de;
  wire enemy_shoot_e1;
  wire enemy_shoot_e2;
  wire enemy_shoot_e3;
  wire enemy_shoot_e4;
  wire enemy_shoot_e5;
  wire enemy_shoot_stage4_e1;
  wire enemy_shoot_stage4_e2;
  wire enemy_shoot_stage4_e3;
  wire hdmi_tx_cec;
  wire hdmi_tx_clk_n;
  wire hdmi_tx_clk_p;
  wire hdmi_tx_hpd;
  wire [2:0]hdmi_tx_n;
  wire [2:0]hdmi_tx_p;
  wire hdmi_tx_rscl;
  wire hdmi_tx_rsda;
  wire item_1_get;
  wire item_2_get;
  wire led;
  wire [2:0]life;
  wire lrclk;
  wire mclk;
  wire miso;
  wire mosi;
  wire sclk;
  wire sdata;
  wire ss;
  wire [1:0]sw;
  wire [4:0]total_score;

  design_1 design_1_i
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
        .enemy_shoot_e1(enemy_shoot_e1),
        .enemy_shoot_e2(enemy_shoot_e2),
        .enemy_shoot_e3(enemy_shoot_e3),
        .enemy_shoot_e4(enemy_shoot_e4),
        .enemy_shoot_e5(enemy_shoot_e5),
        .enemy_shoot_stage4_e1(enemy_shoot_stage4_e1),
        .enemy_shoot_stage4_e2(enemy_shoot_stage4_e2),
        .enemy_shoot_stage4_e3(enemy_shoot_stage4_e3),
        .hdmi_tx_cec(hdmi_tx_cec),
        .hdmi_tx_clk_n(hdmi_tx_clk_n),
        .hdmi_tx_clk_p(hdmi_tx_clk_p),
        .hdmi_tx_hpd(hdmi_tx_hpd),
        .hdmi_tx_n(hdmi_tx_n),
        .hdmi_tx_p(hdmi_tx_p),
        .hdmi_tx_rscl(hdmi_tx_rscl),
        .hdmi_tx_rsda(hdmi_tx_rsda),
        .item_1_get(item_1_get),
        .item_2_get(item_2_get),
        .led(led),
        .life(life),
        .lrclk(lrclk),
        .mclk(mclk),
        .miso(miso),
        .mosi(mosi),
        .sclk(sclk),
        .sdata(sdata),
        .ss(ss),
        .sw(sw),
        .total_score(total_score));
endmodule
