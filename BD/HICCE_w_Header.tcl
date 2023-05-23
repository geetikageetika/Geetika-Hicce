
################################################################
# This is a generated script based on design: HICCEv2_w_header
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source HICCEv2_w_header_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# CombIntan_w_header, HiCCEv2_v2022, counter64

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART avnet.com:zedboard:part0:1.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name HICCEv2_w_header

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
www.ictp.it:user:comblock:2.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
CombIntan_w_header\
HiCCEv2_v2022\
counter64\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set ADC_CNV_0 [ create_bd_port -dir O -from 3 -to 0 ADC_CNV_0 ]
  set ADC_SCLK_0 [ create_bd_port -dir O -from 3 -to 0 ADC_SCLK_0 ]
  set ADC_SDO_0 [ create_bd_port -dir I -from 3 -to 0 ADC_SDO_0 ]
  set Conn_All_0 [ create_bd_port -dir O -from 3 -to 0 Conn_All_0 ]
  set Elec_Test_0 [ create_bd_port -dir O -from 3 -to 0 Elec_Test_0 ]
  set Elec_Test_en_0 [ create_bd_port -dir O -from 3 -to 0 Elec_Test_en_0 ]
  set LED_HiCCE_AB_0 [ create_bd_port -dir O -from 1 -to 0 LED_HiCCE_AB_0 ]
  set Mode_0 [ create_bd_port -dir O -from 3 -to 0 Mode_0 ]
  set Sel0_Reset_0 [ create_bd_port -dir O -from 3 -to 0 -type rst Sel0_Reset_0 ]
  set Sel1_Step_0 [ create_bd_port -dir O -from 3 -to 0 Sel1_Step_0 ]
  set Sel2_Sync_0 [ create_bd_port -dir IO -from 3 -to 0 Sel2_Sync_0 ]
  set Sel3_0 [ create_bd_port -dir IO -from 3 -to 0 Sel3_0 ]
  set Sel4_0 [ create_bd_port -dir IO -from 3 -to 0 Sel4_0 ]
  set Settle_0 [ create_bd_port -dir O -from 3 -to 0 Settle_0 ]

  # Create instance: CombIntan_w_header_0, and set properties
  set block_name CombIntan_w_header
  set block_cell_name CombIntan_w_header_0
  if { [catch {set CombIntan_w_header_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CombIntan_w_header_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property CONFIG.FIFO_SIZE {32768} $CombIntan_w_header_0


  # Create instance: HiCCEv2_v2022_0, and set properties
  set block_name HiCCEv2_v2022
  set block_cell_name HiCCEv2_v2022_0
  if { [catch {set HiCCEv2_v2022_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $HiCCEv2_v2022_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: comblock_0, and set properties
  set comblock_0 [ create_bd_cell -type ip -vlnv www.ictp.it:user:comblock:2.0 comblock_0 ]
  set_property -dict [list \
    CONFIG.DRAM_IO_ENA {false} \
    CONFIG.FIFO_IN_DEPTH {32768} \
    CONFIG.FIFO_IN_DWIDTH {32} \
    CONFIG.REGS_OUT_DEPTH {8} \
  ] $comblock_0


  # Create instance: comblock_1, and set properties
  set comblock_1 [ create_bd_cell -type ip -vlnv www.ictp.it:user:comblock:2.0 comblock_1 ]
  set_property -dict [list \
    CONFIG.DRAM_IO_ENA {false} \
    CONFIG.FIFO_IN_DEPTH {32768} \
    CONFIG.FIFO_IN_DWIDTH {32} \
    CONFIG.REGS_IN_ENA {true} \
    CONFIG.REGS_OUT_DEPTH {8} \
    CONFIG.REGS_OUT_ENA {true} \
  ] $comblock_1


  # Create instance: counter64_0, and set properties
  set block_name counter64
  set block_cell_name counter64_0
  if { [catch {set counter64_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $counter64_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [list \
    CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
    CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
    CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
    CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {250.000000} \
    CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
    CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
    CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
    CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
    CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666667} \
    CONFIG.PCW_CLK0_FREQ {250000000} \
    CONFIG.PCW_CLK1_FREQ {10000000} \
    CONFIG.PCW_CLK2_FREQ {10000000} \
    CONFIG.PCW_CLK3_FREQ {10000000} \
    CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
    CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
    CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
    CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
    CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
    CONFIG.PCW_ENET0_RESET_ENABLE {0} \
    CONFIG.PCW_ENET_RESET_ENABLE {1} \
    CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
    CONFIG.PCW_EN_EMIO_TTC0 {1} \
    CONFIG.PCW_EN_ENET0 {1} \
    CONFIG.PCW_EN_GPIO {1} \
    CONFIG.PCW_EN_QSPI {1} \
    CONFIG.PCW_EN_SDIO0 {1} \
    CONFIG.PCW_EN_TTC0 {1} \
    CONFIG.PCW_EN_UART1 {1} \
    CONFIG.PCW_EN_USB0 {1} \
    CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {250} \
    CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150.000000} \
    CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50.000000} \
    CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
    CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
    CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_I2C_RESET_ENABLE {1} \
    CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_0_PULLUP {disabled} \
    CONFIG.PCW_MIO_0_SLEW {slow} \
    CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_10_PULLUP {disabled} \
    CONFIG.PCW_MIO_10_SLEW {slow} \
    CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_11_PULLUP {disabled} \
    CONFIG.PCW_MIO_11_SLEW {slow} \
    CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_12_PULLUP {disabled} \
    CONFIG.PCW_MIO_12_SLEW {slow} \
    CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_13_PULLUP {disabled} \
    CONFIG.PCW_MIO_13_SLEW {slow} \
    CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_14_PULLUP {disabled} \
    CONFIG.PCW_MIO_14_SLEW {slow} \
    CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_15_PULLUP {disabled} \
    CONFIG.PCW_MIO_15_SLEW {slow} \
    CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_16_PULLUP {disabled} \
    CONFIG.PCW_MIO_16_SLEW {fast} \
    CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_17_PULLUP {disabled} \
    CONFIG.PCW_MIO_17_SLEW {fast} \
    CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_18_PULLUP {disabled} \
    CONFIG.PCW_MIO_18_SLEW {fast} \
    CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_19_PULLUP {disabled} \
    CONFIG.PCW_MIO_19_SLEW {fast} \
    CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_1_PULLUP {disabled} \
    CONFIG.PCW_MIO_1_SLEW {fast} \
    CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_20_PULLUP {disabled} \
    CONFIG.PCW_MIO_20_SLEW {fast} \
    CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_21_PULLUP {disabled} \
    CONFIG.PCW_MIO_21_SLEW {fast} \
    CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_22_PULLUP {disabled} \
    CONFIG.PCW_MIO_22_SLEW {fast} \
    CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_23_PULLUP {disabled} \
    CONFIG.PCW_MIO_23_SLEW {fast} \
    CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_24_PULLUP {disabled} \
    CONFIG.PCW_MIO_24_SLEW {fast} \
    CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_25_PULLUP {disabled} \
    CONFIG.PCW_MIO_25_SLEW {fast} \
    CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_26_PULLUP {disabled} \
    CONFIG.PCW_MIO_26_SLEW {fast} \
    CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_27_PULLUP {disabled} \
    CONFIG.PCW_MIO_27_SLEW {fast} \
    CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_28_PULLUP {disabled} \
    CONFIG.PCW_MIO_28_SLEW {fast} \
    CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_29_PULLUP {disabled} \
    CONFIG.PCW_MIO_29_SLEW {fast} \
    CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_2_SLEW {fast} \
    CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_30_PULLUP {disabled} \
    CONFIG.PCW_MIO_30_SLEW {fast} \
    CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_31_PULLUP {disabled} \
    CONFIG.PCW_MIO_31_SLEW {fast} \
    CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_32_PULLUP {disabled} \
    CONFIG.PCW_MIO_32_SLEW {fast} \
    CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_33_PULLUP {disabled} \
    CONFIG.PCW_MIO_33_SLEW {fast} \
    CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_34_PULLUP {disabled} \
    CONFIG.PCW_MIO_34_SLEW {fast} \
    CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_35_PULLUP {disabled} \
    CONFIG.PCW_MIO_35_SLEW {fast} \
    CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_36_PULLUP {disabled} \
    CONFIG.PCW_MIO_36_SLEW {fast} \
    CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_37_PULLUP {disabled} \
    CONFIG.PCW_MIO_37_SLEW {fast} \
    CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_38_PULLUP {disabled} \
    CONFIG.PCW_MIO_38_SLEW {fast} \
    CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_39_PULLUP {disabled} \
    CONFIG.PCW_MIO_39_SLEW {fast} \
    CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_3_SLEW {fast} \
    CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_40_PULLUP {disabled} \
    CONFIG.PCW_MIO_40_SLEW {fast} \
    CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_41_PULLUP {disabled} \
    CONFIG.PCW_MIO_41_SLEW {fast} \
    CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_42_PULLUP {disabled} \
    CONFIG.PCW_MIO_42_SLEW {fast} \
    CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_43_PULLUP {disabled} \
    CONFIG.PCW_MIO_43_SLEW {fast} \
    CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_44_PULLUP {disabled} \
    CONFIG.PCW_MIO_44_SLEW {fast} \
    CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_45_PULLUP {disabled} \
    CONFIG.PCW_MIO_45_SLEW {fast} \
    CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_46_PULLUP {disabled} \
    CONFIG.PCW_MIO_46_SLEW {slow} \
    CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_47_PULLUP {disabled} \
    CONFIG.PCW_MIO_47_SLEW {slow} \
    CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_48_PULLUP {disabled} \
    CONFIG.PCW_MIO_48_SLEW {slow} \
    CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_49_PULLUP {disabled} \
    CONFIG.PCW_MIO_49_SLEW {slow} \
    CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_4_SLEW {fast} \
    CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_50_PULLUP {disabled} \
    CONFIG.PCW_MIO_50_SLEW {slow} \
    CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_51_PULLUP {disabled} \
    CONFIG.PCW_MIO_51_SLEW {slow} \
    CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_52_PULLUP {disabled} \
    CONFIG.PCW_MIO_52_SLEW {slow} \
    CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
    CONFIG.PCW_MIO_53_PULLUP {disabled} \
    CONFIG.PCW_MIO_53_SLEW {slow} \
    CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_5_SLEW {fast} \
    CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_6_SLEW {fast} \
    CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_7_SLEW {slow} \
    CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_8_SLEW {fast} \
    CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
    CONFIG.PCW_MIO_9_PULLUP {disabled} \
    CONFIG.PCW_MIO_9_SLEW {slow} \
    CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet\
0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet\
0} \
    CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#wp#cd#tx#rx#gpio[50]#gpio[51]#mdc#mdio}\
\
    CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
    CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
    CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
    CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
    CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
    CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
    CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
    CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
    CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
    CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
    CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
    CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
    CONFIG.PCW_SD0_GRP_WP_IO {MIO 46} \
    CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
    CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
    CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
    CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
    CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
    CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
    CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
    CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
    CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
    CONFIG.PCW_UIPARAM_DDR_BL {8} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.41} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.411} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.341} \
    CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.358} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.025} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.028} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.001} \
    CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.001} \
    CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333313} \
    CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
    CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J128M16 HA-15E} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
    CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
    CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
    CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
    CONFIG.PCW_USB0_RESET_ENABLE {0} \
    CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
    CONFIG.PCW_USB_RESET_ENABLE {1} \
    CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
    CONFIG.preset {ZedBoard} \
  ] $processing_system7_0


  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property CONFIG.NUM_MI {2} $ps7_0_axi_periph


  # Create instance: rst_ps7_0_250M, and set properties
  set rst_ps7_0_250M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_250M ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {25} \
    CONFIG.C_PROBE0_TYPE {0} \
    CONFIG.C_PROBE10_TYPE {0} \
    CONFIG.C_PROBE11_TYPE {0} \
    CONFIG.C_PROBE12_TYPE {0} \
    CONFIG.C_PROBE13_TYPE {0} \
    CONFIG.C_PROBE14_TYPE {0} \
    CONFIG.C_PROBE15_TYPE {0} \
    CONFIG.C_PROBE16_TYPE {0} \
    CONFIG.C_PROBE17_TYPE {0} \
    CONFIG.C_PROBE18_TYPE {0} \
    CONFIG.C_PROBE19_TYPE {0} \
    CONFIG.C_PROBE1_TYPE {0} \
    CONFIG.C_PROBE20_TYPE {0} \
    CONFIG.C_PROBE21_TYPE {0} \
    CONFIG.C_PROBE22_TYPE {0} \
    CONFIG.C_PROBE23_TYPE {0} \
    CONFIG.C_PROBE24_TYPE {0} \
    CONFIG.C_PROBE2_TYPE {0} \
    CONFIG.C_PROBE3_TYPE {0} \
    CONFIG.C_PROBE4_TYPE {0} \
    CONFIG.C_PROBE5_TYPE {0} \
    CONFIG.C_PROBE6_TYPE {0} \
    CONFIG.C_PROBE7_TYPE {0} \
    CONFIG.C_PROBE8_TYPE {0} \
    CONFIG.C_PROBE9_TYPE {0} \
  ] $system_ila_0


  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property CONFIG.C_SIZE {1} $util_vector_logic_0


  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_1


  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $util_vector_logic_2


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins comblock_0/AXIL] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins comblock_1/AXIL] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]

  # Create port connections
  connect_bd_net -net ADC_SDO_0_1 [get_bd_ports ADC_SDO_0] [get_bd_pins HiCCEv2_v2022_0/ADC_SDO] [get_bd_pins system_ila_0/probe0]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets ADC_SDO_0_1]
  connect_bd_net -net CLK_SWITCH_INT_A [get_bd_pins HiCCEv2_v2022_0/CLK_SWITCH_INT_A]
  connect_bd_net -net CLK_SWITCH_INT_B [get_bd_pins HiCCEv2_v2022_0/CLK_SWITCH_INT_B]
  connect_bd_net -net CLK_SWITCH_INT_C [get_bd_pins HiCCEv2_v2022_0/CLK_SWITCH_INT_C]
  connect_bd_net -net CLK_SWITCH_INT_D [get_bd_pins HiCCEv2_v2022_0/CLK_SWITCH_INT_D]
  connect_bd_net -net CombIntan_w_header_0_Data_Rd_En [get_bd_pins CombIntan_w_header_0/DataIn_ready] [get_bd_pins HiCCEv2_v2022_0/FIFO_READ_ENB] [get_bd_pins system_ila_0/probe5]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_Data_Rd_En]
  connect_bd_net -net CombIntan_w_header_0_FIFO_CLEAR_AB [get_bd_pins CombIntan_w_header_0/FIFO_CLEAR_AB] [get_bd_pins comblock_0/fifo_clear_i] [get_bd_pins system_ila_0/probe6]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_FIFO_CLEAR_AB]
  connect_bd_net -net CombIntan_w_header_0_FIFO_CLEAR_CD [get_bd_pins CombIntan_w_header_0/FIFO_CLEAR_CD] [get_bd_pins comblock_1/fifo_clear_i] [get_bd_pins system_ila_0/probe7]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_FIFO_CLEAR_CD]
  connect_bd_net -net CombIntan_w_header_0_ab_maxis_tdata [get_bd_pins CombIntan_w_header_0/ab_maxis_tdata] [get_bd_pins comblock_0/fifo_data_i] [get_bd_pins system_ila_0/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_ab_maxis_tdata]
  connect_bd_net -net CombIntan_w_header_0_ab_maxis_tvalid [get_bd_pins CombIntan_w_header_0/ab_maxis_tvalid] [get_bd_pins comblock_0/fifo_we_i] [get_bd_pins system_ila_0/probe2]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_ab_maxis_tvalid]
  connect_bd_net -net CombIntan_w_header_0_cd_maxis_tdata [get_bd_pins CombIntan_w_header_0/cd_maxis_tdata] [get_bd_pins comblock_1/fifo_data_i] [get_bd_pins system_ila_0/probe3]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_cd_maxis_tdata]
  connect_bd_net -net CombIntan_w_header_0_cd_maxis_tvalid [get_bd_pins CombIntan_w_header_0/cd_maxis_tvalid] [get_bd_pins comblock_1/fifo_we_i] [get_bd_pins system_ila_0/probe4]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets CombIntan_w_header_0_cd_maxis_tvalid]
  connect_bd_net -net HiCCEv2_v2022_0_ADC_CNV [get_bd_ports ADC_CNV_0] [get_bd_pins HiCCEv2_v2022_0/ADC_CNV] [get_bd_pins system_ila_0/probe13]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_ADC_CNV]
  connect_bd_net -net HiCCEv2_v2022_0_ADC_SCLK [get_bd_ports ADC_SCLK_0] [get_bd_pins HiCCEv2_v2022_0/ADC_SCLK] [get_bd_pins system_ila_0/probe14]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_ADC_SCLK]
  connect_bd_net -net HiCCEv2_v2022_0_Ack_intan [get_bd_pins CombIntan_w_header_0/DataIn_ack] [get_bd_pins HiCCEv2_v2022_0/Ack_intan] [get_bd_pins comblock_0/reg0_i] [get_bd_pins system_ila_0/probe12]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Ack_intan]
  connect_bd_net -net HiCCEv2_v2022_0_Conn_All [get_bd_ports Conn_All_0] [get_bd_pins HiCCEv2_v2022_0/Conn_All]
  connect_bd_net -net HiCCEv2_v2022_0_Data_intan_A [get_bd_pins CombIntan_w_header_0/DataIn_A] [get_bd_pins HiCCEv2_v2022_0/Data_intan_A] [get_bd_pins system_ila_0/probe15]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Data_intan_A]
  connect_bd_net -net HiCCEv2_v2022_0_Data_intan_B [get_bd_pins CombIntan_w_header_0/DataIn_B] [get_bd_pins HiCCEv2_v2022_0/Data_intan_B] [get_bd_pins system_ila_0/probe16]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Data_intan_B]
  connect_bd_net -net HiCCEv2_v2022_0_Data_intan_C [get_bd_pins CombIntan_w_header_0/DataIn_C] [get_bd_pins HiCCEv2_v2022_0/Data_intan_C] [get_bd_pins system_ila_0/probe17]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Data_intan_C]
  connect_bd_net -net HiCCEv2_v2022_0_Data_intan_D [get_bd_pins CombIntan_w_header_0/DataIn_D] [get_bd_pins HiCCEv2_v2022_0/Data_intan_D] [get_bd_pins system_ila_0/probe18]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Data_intan_D]
  connect_bd_net -net HiCCEv2_v2022_0_Data_valid [get_bd_pins CombIntan_w_header_0/DataIn_valid] [get_bd_pins HiCCEv2_v2022_0/Data_valid] [get_bd_pins counter64_0/clk] [get_bd_pins system_ila_0/probe19]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Data_valid]
  connect_bd_net -net HiCCEv2_v2022_0_Elec_Test [get_bd_ports Elec_Test_0] [get_bd_pins HiCCEv2_v2022_0/Elec_Test]
  connect_bd_net -net HiCCEv2_v2022_0_Elec_Test_en [get_bd_ports Elec_Test_en_0] [get_bd_pins HiCCEv2_v2022_0/Elec_Test_en]
  connect_bd_net -net HiCCEv2_v2022_0_LED_HiCCE_AB [get_bd_ports LED_HiCCE_AB_0] [get_bd_pins HiCCEv2_v2022_0/LED_HiCCE_AB]
  connect_bd_net -net HiCCEv2_v2022_0_Mode [get_bd_ports Mode_0] [get_bd_pins HiCCEv2_v2022_0/Mode] [get_bd_pins system_ila_0/probe20]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Mode]
  connect_bd_net -net HiCCEv2_v2022_0_Sel0_Reset [get_bd_ports Sel0_Reset_0] [get_bd_pins HiCCEv2_v2022_0/Sel0_Reset] [get_bd_pins system_ila_0/probe21]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Sel0_Reset]
  connect_bd_net -net HiCCEv2_v2022_0_Sel1_Step [get_bd_ports Sel1_Step_0] [get_bd_pins HiCCEv2_v2022_0/Sel1_Step] [get_bd_pins system_ila_0/probe22]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets HiCCEv2_v2022_0_Sel1_Step]
  connect_bd_net -net HiCCEv2_v2022_0_Settle [get_bd_ports Settle_0] [get_bd_pins HiCCEv2_v2022_0/Settle]
  connect_bd_net -net Net [get_bd_ports Sel2_Sync_0] [get_bd_pins HiCCEv2_v2022_0/Sel2_Sync]
  connect_bd_net -net Net2 [get_bd_ports Sel3_0] [get_bd_pins HiCCEv2_v2022_0/Sel3]
  connect_bd_net -net Net3 [get_bd_ports Sel4_0] [get_bd_pins HiCCEv2_v2022_0/Sel4]
  connect_bd_net -net comblock_0_fifo_afull_o [get_bd_pins CombIntan_w_header_0/FIFO_AFULL_AB] [get_bd_pins comblock_0/fifo_afull_o] [get_bd_pins system_ila_0/probe8]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets comblock_0_fifo_afull_o]
  connect_bd_net -net comblock_0_fifo_full_o [get_bd_pins comblock_0/fifo_full_o] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net comblock_0_reg0_o [get_bd_pins HiCCEv2_v2022_0/Config_Res_intan_A] [get_bd_pins comblock_0/reg0_o] [get_bd_pins system_ila_0/probe9]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets comblock_0_reg0_o]
  connect_bd_net -net comblock_0_reg1_o [get_bd_pins HiCCEv2_v2022_0/Config_Res_intan_B] [get_bd_pins comblock_0/reg1_o]
  connect_bd_net -net comblock_0_reg2_o [get_bd_pins HiCCEv2_v2022_0/Config_Res_intan_C] [get_bd_pins comblock_0/reg2_o]
  connect_bd_net -net comblock_0_reg3_o [get_bd_pins HiCCEv2_v2022_0/Config_Res_intan_D] [get_bd_pins comblock_0/reg3_o]
  connect_bd_net -net comblock_0_reg4_o [get_bd_pins HiCCEv2_v2022_0/Read_intan] [get_bd_pins comblock_0/reg4_o] [get_bd_pins system_ila_0/probe10]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets comblock_0_reg4_o]
  connect_bd_net -net comblock_0_reg5_o [get_bd_pins comblock_0/reg5_o] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net comblock_0_reg6_o [get_bd_pins CombIntan_w_header_0/nsasmples] [get_bd_pins comblock_0/reg6_o]
  connect_bd_net -net comblock_0_reg7_o [get_bd_pins comblock_0/reg7_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net comblock_1_fifo_afull_o [get_bd_pins CombIntan_w_header_0/FIFO_AFULL_CD] [get_bd_pins comblock_1/fifo_afull_o] [get_bd_pins system_ila_0/probe11]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets comblock_1_fifo_afull_o]
  connect_bd_net -net comblock_1_fifo_full_o [get_bd_pins comblock_1/fifo_full_o] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net counter64_0_q [get_bd_pins CombIntan_w_header_0/timestamp_i] [get_bd_pins counter64_0/q]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins CombIntan_w_header_0/ab_maxis_clk] [get_bd_pins CombIntan_w_header_0/cd_maxis_clk] [get_bd_pins HiCCEv2_v2022_0/FIFO_clk] [get_bd_pins HiCCEv2_v2022_0/Sys_Clock] [get_bd_pins comblock_0/axil_aclk] [get_bd_pins comblock_0/fifo_clk_i] [get_bd_pins comblock_1/axil_aclk] [get_bd_pins comblock_1/fifo_clk_i] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_250M/slowest_sync_clk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_250M/ext_reset_in]
  connect_bd_net -net rst_ps7_0_250M_peripheral_aresetn [get_bd_pins CombIntan_w_header_0/sys_rstn] [get_bd_pins comblock_0/axil_aresetn] [get_bd_pins comblock_1/axil_aresetn] [get_bd_pins counter64_0/rstn] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_250M/peripheral_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins HiCCEv2_v2022_0/Sys_Reset] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins CombIntan_w_header_0/ab_maxis_tready] [get_bd_pins system_ila_0/probe23] [get_bd_pins util_vector_logic_1/Res]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets util_vector_logic_1_Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins CombIntan_w_header_0/cd_maxis_tready] [get_bd_pins system_ila_0/probe24] [get_bd_pins util_vector_logic_2/Res]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets util_vector_logic_2_Res]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins HiCCEv2_v2022_0/ADC_SDO_VIRTUAL_A] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins CombIntan_w_header_0/sys_en] [get_bd_pins xlslice_0/Dout]

  # Create address segments
  assign_bd_address -offset 0x43C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs comblock_0/AXIL/AXIL] -force
  assign_bd_address -offset 0x43C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs comblock_1/AXIL/AXIL] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


