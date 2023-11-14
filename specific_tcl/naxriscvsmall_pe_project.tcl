  # Create instance: NaxRiscv_0, and set properties
  set NaxRiscv_0 [ create_bd_cell -type ip -vlnv [dict get $cpu_vlnv $project_name] NaxRiscv_0 ]
  set cpu_clk [get_bd_pins NaxRiscv_0/clk]
  #set_property -dict [ list \
  # CONFIG.SUPPORTS_NARROW_BURST {1} \
  # CONFIG.NUM_READ_OUTSTANDING {2} \
  # CONFIG.NUM_WRITE_OUTSTANDING {2} \
  # CONFIG.MAX_BURST_LENGTH {256} \
 #] [get_bd_intf_pins /NaxRiscv_0/ram_dbus]

 # set_property -dict [ list \
 #  CONFIG.SUPPORTS_NARROW_BURST {1} \
 #  CONFIG.NUM_READ_OUTSTANDING {2} \
 #  CONFIG.NUM_WRITE_OUTSTANDING {2} \
 #  CONFIG.MAX_BURST_LENGTH {256} \
 #] [get_bd_intf_pins /NaxRiscv_0/ram_ibus]

  # Create interface connections
  #connect_bd_intf_net -intf_net NaxRiscv_0_ram_dbus [get_bd_intf_pins NaxRiscv_0/ram_dbus] [get_bd_intf_pins axi_mem_intercon_1/S00_AXI]
  #connect_bd_intf_net -intf_net NaxRiscv_0_peripheral_dbus [get_bd_intf_pins NaxRiscv_0/peripheral_dbus] [get_bd_intf_pins RVController_0/saxi]
  set axi_io_port [get_bd_intf_pins NaxRiscv_0/peripheral_dbus]
  set axi_mem_port [get_bd_intf_pins NaxRiscv_0/ram_dbus]
  set iaxi [get_bd_intf_pins NaxRiscv_0/ram_ibus]

  # Create port connections
  connect_bd_net -net RVController_0_rv_reset [get_bd_pins RVController_0/rv_reset] [get_bd_pins NaxRiscv_0/reset]
  connect_bd_intf_net [get_bd_intf_pins NaxRiscv_0/ram_dbus] [get_bd_intf_pins axi_mem_intercon_1/S00_AXI]
  save_bd_design

proc create_specific_addr_segs {} {
  variable lmem
  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x11000000 [get_bd_addr_spaces NaxRiscv_0/peripheral_dbus] [get_bd_addr_segs RVController_0/saxi/reg0] SEG_RVController_0_reg0
  create_bd_addr_seg -range $lmem -offset $lmem [get_bd_addr_spaces NaxRiscv_0/ram_dbus] [get_bd_addr_segs rv_dmem_ctrl/S_AXI/Mem0] SEG_rv_dmem_ctrl_Mem0
  create_bd_addr_seg -range $lmem -offset 0x00000000 [get_bd_addr_spaces NaxRiscv_0/ram_ibus] [get_bd_addr_segs rv_imem_ctrl/S_AXI/Mem0] SEG_rv_imem_ctrl_Mem0
}

proc get_external_mem_addr_space {} {
  return [get_bd_addr_spaces NaxRiscv_0/ram_dbus]
}
