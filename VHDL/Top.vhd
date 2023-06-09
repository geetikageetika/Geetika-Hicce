--Copyright 1986-2023 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2022.2.2 (lin64) Build 3788238 Tue Feb 21 19:59:23 MST 2023
--Date        : Wed May  3 17:09:00 2023
--Host        : hp6g4-mlab-5 running 64-bit Ubuntu 20.04.6 LTS
--Command     : generate_target HICCEv2_w_header_wrapper.bd
--Design      : HICCEv2_w_header_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity HICCEv2_w_header_wrapper is
  port (
    ADC_CNV_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ADC_SCLK_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ADC_SDO_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    Conn_All_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    Elec_Test_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Elec_Test_en_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    LED_HiCCE_AB_0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    Mode_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel0_Reset_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel1_Step_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel2_Sync_0 : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel3_0 : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel4_0 : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Settle_0 : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end HICCEv2_w_header_wrapper;

architecture STRUCTURE of HICCEv2_w_header_wrapper is
  component HICCEv2_w_header is
  port (
    ADC_CNV_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ADC_SCLK_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    ADC_SDO_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    Conn_All_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Elec_Test_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Elec_Test_en_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    LED_HiCCE_AB_0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    Mode_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel0_Reset_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel1_Step_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel2_Sync_0 : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel3_0 : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Sel4_0 : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    Settle_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC
  );
  end component HICCEv2_w_header;
begin
HICCEv2_w_header_i: component HICCEv2_w_header
     port map (
      ADC_CNV_0(3 downto 0) => ADC_CNV_0(3 downto 0),
      ADC_SCLK_0(3 downto 0) => ADC_SCLK_0(3 downto 0),
      ADC_SDO_0(3 downto 0) => ADC_SDO_0(3 downto 0),
      Conn_All_0(3 downto 0) => Conn_All_0(3 downto 0),
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      Elec_Test_0(3 downto 0) => Elec_Test_0(3 downto 0),
      Elec_Test_en_0(3 downto 0) => Elec_Test_en_0(3 downto 0),
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      LED_HiCCE_AB_0(1 downto 0) => LED_HiCCE_AB_0(1 downto 0),
      Mode_0(3 downto 0) => Mode_0(3 downto 0),
      Sel0_Reset_0(3 downto 0) => Sel0_Reset_0(3 downto 0),
      Sel1_Step_0(3 downto 0) => Sel1_Step_0(3 downto 0),
      Sel2_Sync_0(3 downto 0) => Sel2_Sync_0(3 downto 0),
      Sel3_0(3 downto 0) => Sel3_0(3 downto 0),
      Sel4_0(3 downto 0) => Sel4_0(3 downto 0),
      Settle_0(3 downto 0) => Settle_0(3 downto 0)
    );
end STRUCTURE;
