// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sat Jul  2 23:44:30 2022
// Host        : tueszero running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_HDMI_TOP_0_0_stub.v
// Design      : design_1_HDMI_TOP_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "HDMI_TOP,Vivado 2020.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(CLK, RST_BTN, btn1, btn2, btn3, sw, hdmi_tx_cec, 
  hdmi_tx_hpd, hdmi_tx_rscl, hdmi_tx_rsda, hdmi_tx_clk_n, hdmi_tx_clk_p, hdmi_tx_n, hdmi_tx_p, 
  clk_lock, de, led, total_score, enemy_shoot_e1, enemy_shoot_e2, enemy_shoot_e3, enemy_shoot_e4, 
  enemy_shoot_e5, enemy_shoot_stage4_e1, enemy_shoot_stage4_e2, enemy_shoot_stage4_e3, 
  life, item_1_get, item_2_get)
/* synthesis syn_black_box black_box_pad_pin="CLK,RST_BTN,btn1,btn2,btn3,sw[1:0],hdmi_tx_cec,hdmi_tx_hpd,hdmi_tx_rscl,hdmi_tx_rsda,hdmi_tx_clk_n,hdmi_tx_clk_p,hdmi_tx_n[2:0],hdmi_tx_p[2:0],clk_lock,de,led,total_score[4:0],enemy_shoot_e1,enemy_shoot_e2,enemy_shoot_e3,enemy_shoot_e4,enemy_shoot_e5,enemy_shoot_stage4_e1,enemy_shoot_stage4_e2,enemy_shoot_stage4_e3,life[2:0],item_1_get,item_2_get" */;
  input CLK;
  input RST_BTN;
  input btn1;
  input btn2;
  input btn3;
  input [1:0]sw;
  inout hdmi_tx_cec;
  input hdmi_tx_hpd;
  inout hdmi_tx_rscl;
  inout hdmi_tx_rsda;
  output hdmi_tx_clk_n;
  output hdmi_tx_clk_p;
  output [2:0]hdmi_tx_n;
  output [2:0]hdmi_tx_p;
  output clk_lock;
  output de;
  output led;
  output [4:0]total_score;
  output enemy_shoot_e1;
  output enemy_shoot_e2;
  output enemy_shoot_e3;
  output enemy_shoot_e4;
  output enemy_shoot_e5;
  output enemy_shoot_stage4_e1;
  output enemy_shoot_stage4_e2;
  output enemy_shoot_stage4_e3;
  output [2:0]life;
  output item_1_get;
  output item_2_get;
endmodule
