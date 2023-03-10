##########################################################
### FMC Interface: Common Signals
##########################################################

# INTAN Chip, Digital Control Signals
set_property PACKAGE_PIN R19 [get_ports {Elec_Test_0[3]}]
set_property PACKAGE_PIN E15 [get_ports {Elec_Test_0[2]}]
set_property PACKAGE_PIN F19 [get_ports {Elec_Test_0[1]}]
set_property PACKAGE_PIN T17 [get_ports {Elec_Test_0[0]}]

set_property PACKAGE_PIN E21 [get_ports {Elec_Test_en_0[3]}]
set_property PACKAGE_PIN M20 [get_ports {Elec_Test_en_0[2]}]
set_property PACKAGE_PIN B16 [get_ports {Elec_Test_en_0[1]}]
set_property PACKAGE_PIN E20 [get_ports {Elec_Test_en_0[0]}]

set_property PACKAGE_PIN D21 [get_ports {Conn_All_0[3]}]
set_property PACKAGE_PIN N22 [get_ports {Conn_All_0[2]}]
set_property PACKAGE_PIN B17 [get_ports {Conn_All_0[1]}]
set_property PACKAGE_PIN A18 [get_ports {Conn_All_0[0]}]

set_property PACKAGE_PIN N19 [get_ports {Settle_0[3]}]
set_property PACKAGE_PIN P22 [get_ports {Settle_0[2]}]
set_property PACKAGE_PIN B21 [get_ports {Settle_0[1]}]
set_property PACKAGE_PIN A19 [get_ports {Settle_0[0]}]

set_property PACKAGE_PIN N20 [get_ports {Sel0_Reset_0[3]}]
set_property PACKAGE_PIN J21 [get_ports {Sel0_Reset_0[2]}]
set_property PACKAGE_PIN B22 [get_ports {Sel0_Reset_0[1]}]
set_property PACKAGE_PIN A16 [get_ports {Sel0_Reset_0[0]}]

set_property PACKAGE_PIN J18 [get_ports {Sel1_Step_0[3]}]
set_property PACKAGE_PIN J22 [get_ports {Sel1_Step_0[2]}]
set_property PACKAGE_PIN P17 [get_ports {Sel1_Step_0[1]}]
set_property PACKAGE_PIN A17 [get_ports {Sel1_Step_0[0]}]

set_property PACKAGE_PIN K18 [get_ports {Sel2_Sync_0[3]}]
set_property PACKAGE_PIN P20 [get_ports {Sel2_Sync_0[2]}]
set_property PACKAGE_PIN P18 [get_ports {Sel2_Sync_0[1]}]
set_property PACKAGE_PIN C15 [get_ports {Sel2_Sync_0[0]}]

set_property PACKAGE_PIN R20 [get_ports {Sel3_0[3]}]
set_property PACKAGE_PIN P21 [get_ports {Sel3_0[2]}]
set_property PACKAGE_PIN M21 [get_ports {Sel3_0[1]}]
set_property PACKAGE_PIN B15 [get_ports {Sel3_0[0]}]

set_property PACKAGE_PIN R21 [get_ports {Sel4_0[3]}]
set_property PACKAGE_PIN J20 [get_ports {Sel4_0[2]}]
set_property PACKAGE_PIN M22 [get_ports {Sel4_0[1]}]
set_property PACKAGE_PIN A21 [get_ports {Sel4_0[0]}]

set_property PACKAGE_PIN L17 [get_ports {Mode_0[3]}]
set_property PACKAGE_PIN K21 [get_ports {Mode_0[2]}]
set_property PACKAGE_PIN T16 [get_ports {Mode_0[1]}]
set_property PACKAGE_PIN A22 [get_ports {Mode_0[0]}]

# ADC_AD7982 Interface
set_property PACKAGE_PIN K20 [get_ports {ADC_SDO_0[3]}]
set_property PACKAGE_PIN F18 [get_ports {ADC_SDO_0[2]}]
set_property PACKAGE_PIN C22 [get_ports {ADC_SDO_0[1]}]
set_property PACKAGE_PIN G15 [get_ports {ADC_SDO_0[0]}]

set_property PACKAGE_PIN D20 [get_ports {ADC_CNV_0[3]}]
set_property PACKAGE_PIN E18 [get_ports {ADC_CNV_0[2]}]
set_property PACKAGE_PIN C17 [get_ports {ADC_CNV_0[1]}]
set_property PACKAGE_PIN G16 [get_ports {ADC_CNV_0[0]}]

set_property PACKAGE_PIN C20 [get_ports {ADC_SCLK_0[3]}]
set_property PACKAGE_PIN M19 [get_ports {ADC_SCLK_0[2]}]
set_property PACKAGE_PIN C18 [get_ports {ADC_SCLK_0[1]}]
set_property PACKAGE_PIN E19 [get_ports {ADC_SCLK_0[0]}]

#HiCEE BOARD LEDs (A AND B)
set_property PACKAGE_PIN B20 [get_ports {LED_HiCCE_AB_0[0]}]
set_property PACKAGE_PIN B19 [get_ports {LED_HiCCE_AB_0[1]}]

#------------------------------------------------------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Elec_Test_en_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Conn_All_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Settle_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Settle_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Settle_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Settle_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel0_Reset_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel1_Step_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel1_Step_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel1_Step_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel1_Step_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel2_Sync_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel3_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Sel4_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Mode_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SDO_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SDO_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SDO_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SDO_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {ADC_CNV_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_CNV_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_CNV_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_CNV_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SCLK_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SCLK_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SCLK_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ADC_SCLK_0[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LED_HiCCE_AB_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_HiCCE_AB_0[0]}]

##------------------------------------------------------------------------------------------------



set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[5]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[7]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[9]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[13]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[19]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[20]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[31]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[17]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[4]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[8]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[18]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[28]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[29]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[30]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[6]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[15]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[16]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[22]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[23]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[25]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[26]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[10]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[11]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[12]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[14]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[21]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[24]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutAB[27]}]
set_property MARK_DEBUG true [get_nets design_1_i/CombIntan_0_DoutAB_valid]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[4]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[9]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[17]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[19]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[24]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[28]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[30]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[31]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[8]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[12]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[13]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[21]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[22]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[25]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[29]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[6]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[14]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[15]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[16]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[20]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[23]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[27]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[5]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[7]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[10]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[11]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[18]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_DoutCD[26]}]
set_property MARK_DEBUG true [get_nets design_1_i/CombIntan_0_DoutCD_valid]
set_property MARK_DEBUG true [get_nets design_1_i/comblock_0_fifo_full_o]
set_property MARK_DEBUG true [get_nets design_1_i/comblock_1_fifo_full_o]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCEv2_v2022_0_Data_valid[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCEv2_v2022_0_Data_valid[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCEv2_v2022_0_Data_valid[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCEv2_v2022_0_Data_valid[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_Data_Rd_En[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_Data_Rd_En[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_Data_Rd_En[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/CombIntan_0_Data_Rd_En[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[5]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[10]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[12]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[15]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[6]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[8]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[13]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[14]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[7]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[9]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[11]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_A[4]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[12]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[14]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[8]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[11]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[6]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[9]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[10]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[13]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[15]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[4]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[5]}]
set_property MARK_DEBUG true [get_nets {design_1_i/HiCCE_2018_0_Data_intan_C[7]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_CNV_0[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_CNV_0[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_CNV_0[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_CNV_0[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SCLK_0[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SCLK_0[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SCLK_0[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SCLK_0[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SDO_0[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SDO_0[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SDO_0[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/ADC_SDO_0[3]}]
set_property MARK_DEBUG true [get_nets {design_1_i/Sel1_Step_0[0]}]
set_property MARK_DEBUG true [get_nets {design_1_i/Sel1_Step_0[1]}]
set_property MARK_DEBUG true [get_nets {design_1_i/Sel1_Step_0[2]}]
set_property MARK_DEBUG true [get_nets {design_1_i/Sel1_Step_0[3]}]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/CombIntan_0_Data_Rd_En[0]} {design_1_i/CombIntan_0_Data_Rd_En[1]} {design_1_i/CombIntan_0_Data_Rd_En[2]} {design_1_i/CombIntan_0_Data_Rd_En[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/Sel1_Step_0[0]} {design_1_i/Sel1_Step_0[1]} {design_1_i/Sel1_Step_0[2]} {design_1_i/Sel1_Step_0[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/ADC_CNV_0[0]} {design_1_i/ADC_CNV_0[1]} {design_1_i/ADC_CNV_0[2]} {design_1_i/ADC_CNV_0[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/CombIntan_0_DoutAB[0]} {design_1_i/CombIntan_0_DoutAB[1]} {design_1_i/CombIntan_0_DoutAB[2]} {design_1_i/CombIntan_0_DoutAB[3]} {design_1_i/CombIntan_0_DoutAB[4]} {design_1_i/CombIntan_0_DoutAB[5]} {design_1_i/CombIntan_0_DoutAB[6]} {design_1_i/CombIntan_0_DoutAB[7]} {design_1_i/CombIntan_0_DoutAB[8]} {design_1_i/CombIntan_0_DoutAB[9]} {design_1_i/CombIntan_0_DoutAB[10]} {design_1_i/CombIntan_0_DoutAB[11]} {design_1_i/CombIntan_0_DoutAB[12]} {design_1_i/CombIntan_0_DoutAB[13]} {design_1_i/CombIntan_0_DoutAB[14]} {design_1_i/CombIntan_0_DoutAB[15]} {design_1_i/CombIntan_0_DoutAB[16]} {design_1_i/CombIntan_0_DoutAB[17]} {design_1_i/CombIntan_0_DoutAB[18]} {design_1_i/CombIntan_0_DoutAB[19]} {design_1_i/CombIntan_0_DoutAB[20]} {design_1_i/CombIntan_0_DoutAB[21]} {design_1_i/CombIntan_0_DoutAB[22]} {design_1_i/CombIntan_0_DoutAB[23]} {design_1_i/CombIntan_0_DoutAB[24]} {design_1_i/CombIntan_0_DoutAB[25]} {design_1_i/CombIntan_0_DoutAB[26]} {design_1_i/CombIntan_0_DoutAB[27]} {design_1_i/CombIntan_0_DoutAB[28]} {design_1_i/CombIntan_0_DoutAB[29]} {design_1_i/CombIntan_0_DoutAB[30]} {design_1_i/CombIntan_0_DoutAB[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/HiCCE_2018_0_Data_intan_A[0]} {design_1_i/HiCCE_2018_0_Data_intan_A[1]} {design_1_i/HiCCE_2018_0_Data_intan_A[2]} {design_1_i/HiCCE_2018_0_Data_intan_A[3]} {design_1_i/HiCCE_2018_0_Data_intan_A[4]} {design_1_i/HiCCE_2018_0_Data_intan_A[5]} {design_1_i/HiCCE_2018_0_Data_intan_A[6]} {design_1_i/HiCCE_2018_0_Data_intan_A[7]} {design_1_i/HiCCE_2018_0_Data_intan_A[8]} {design_1_i/HiCCE_2018_0_Data_intan_A[9]} {design_1_i/HiCCE_2018_0_Data_intan_A[10]} {design_1_i/HiCCE_2018_0_Data_intan_A[11]} {design_1_i/HiCCE_2018_0_Data_intan_A[12]} {design_1_i/HiCCE_2018_0_Data_intan_A[13]} {design_1_i/HiCCE_2018_0_Data_intan_A[14]} {design_1_i/HiCCE_2018_0_Data_intan_A[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/CombIntan_0_DoutCD[0]} {design_1_i/CombIntan_0_DoutCD[1]} {design_1_i/CombIntan_0_DoutCD[2]} {design_1_i/CombIntan_0_DoutCD[3]} {design_1_i/CombIntan_0_DoutCD[4]} {design_1_i/CombIntan_0_DoutCD[5]} {design_1_i/CombIntan_0_DoutCD[6]} {design_1_i/CombIntan_0_DoutCD[7]} {design_1_i/CombIntan_0_DoutCD[8]} {design_1_i/CombIntan_0_DoutCD[9]} {design_1_i/CombIntan_0_DoutCD[10]} {design_1_i/CombIntan_0_DoutCD[11]} {design_1_i/CombIntan_0_DoutCD[12]} {design_1_i/CombIntan_0_DoutCD[13]} {design_1_i/CombIntan_0_DoutCD[14]} {design_1_i/CombIntan_0_DoutCD[15]} {design_1_i/CombIntan_0_DoutCD[16]} {design_1_i/CombIntan_0_DoutCD[17]} {design_1_i/CombIntan_0_DoutCD[18]} {design_1_i/CombIntan_0_DoutCD[19]} {design_1_i/CombIntan_0_DoutCD[20]} {design_1_i/CombIntan_0_DoutCD[21]} {design_1_i/CombIntan_0_DoutCD[22]} {design_1_i/CombIntan_0_DoutCD[23]} {design_1_i/CombIntan_0_DoutCD[24]} {design_1_i/CombIntan_0_DoutCD[25]} {design_1_i/CombIntan_0_DoutCD[26]} {design_1_i/CombIntan_0_DoutCD[27]} {design_1_i/CombIntan_0_DoutCD[28]} {design_1_i/CombIntan_0_DoutCD[29]} {design_1_i/CombIntan_0_DoutCD[30]} {design_1_i/CombIntan_0_DoutCD[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_1_i/ADC_SCLK_0[0]} {design_1_i/ADC_SCLK_0[1]} {design_1_i/ADC_SCLK_0[2]} {design_1_i/ADC_SCLK_0[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 4 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_1_i/HiCCEv2_v2022_0_Data_valid[0]} {design_1_i/HiCCEv2_v2022_0_Data_valid[1]} {design_1_i/HiCCEv2_v2022_0_Data_valid[2]} {design_1_i/HiCCEv2_v2022_0_Data_valid[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {design_1_i/ADC_SDO_0[0]} {design_1_i/ADC_SDO_0[1]} {design_1_i/ADC_SDO_0[2]} {design_1_i/ADC_SDO_0[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {design_1_i/HiCCE_2018_0_Data_intan_C[0]} {design_1_i/HiCCE_2018_0_Data_intan_C[1]} {design_1_i/HiCCE_2018_0_Data_intan_C[2]} {design_1_i/HiCCE_2018_0_Data_intan_C[3]} {design_1_i/HiCCE_2018_0_Data_intan_C[4]} {design_1_i/HiCCE_2018_0_Data_intan_C[5]} {design_1_i/HiCCE_2018_0_Data_intan_C[6]} {design_1_i/HiCCE_2018_0_Data_intan_C[7]} {design_1_i/HiCCE_2018_0_Data_intan_C[8]} {design_1_i/HiCCE_2018_0_Data_intan_C[9]} {design_1_i/HiCCE_2018_0_Data_intan_C[10]} {design_1_i/HiCCE_2018_0_Data_intan_C[11]} {design_1_i/HiCCE_2018_0_Data_intan_C[12]} {design_1_i/HiCCE_2018_0_Data_intan_C[13]} {design_1_i/HiCCE_2018_0_Data_intan_C[14]} {design_1_i/HiCCE_2018_0_Data_intan_C[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list design_1_i/CombIntan_0_DoutAB_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list design_1_i/CombIntan_0_DoutCD_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list design_1_i/comblock_0_fifo_full_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list design_1_i/comblock_1_fifo_full_o]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK0]
