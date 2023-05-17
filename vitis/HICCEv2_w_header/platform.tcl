# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header/platform.tcl
# 
# OR launch xsct and run below command.
# source /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {HICCEv2_w_header}\
-hw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}\
-out {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis}

platform write
domain create -name {freertos10_xilinx_ps7_cortexa9_0} -display-name {freertos10_xilinx_ps7_cortexa9_0} -os {freertos10_xilinx} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {udma_server}
platform generate -domains 
platform active {HICCEv2_w_header}
domain active {zynq_fsbl}
domain active {freertos10_xilinx_ps7_cortexa9_0}
platform generate -quick
platform generate
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains freertos10_xilinx_ps7_cortexa9_0 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform generate -domains freertos10_xilinx_ps7_cortexa9_0 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains freertos10_xilinx_ps7_cortexa9_0 
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header.xsa}
platform generate -domains 
platform active {HICCEv2_w_header}
platform config -updatehw {/opt/my_gits/HICCE/hicce-project/Bitstream/HICCEv2_w_header.xsa}
platform generate -domains freertos10_xilinx_ps7_cortexa9_0 
