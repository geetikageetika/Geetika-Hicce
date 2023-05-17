# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/hicce_w_header_system/_ide/scripts/systemdebugger_hicce_w_header_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/hicce_w_header_system/_ide/scripts/systemdebugger_hicce_w_header_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/HICCEv2_w_header/export/HICCEv2_w_header/hw/HICCEv2_w_header.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
stop
source /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/hicce_w_header/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
rst -processor
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /opt/my_gits/HICCE/hicce-project/hicce_w_header/vitis/hicce_w_header/Debug/hicce_w_header.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
