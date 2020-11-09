  # Create PFM attributes
set_property PFM_NAME {em.avnet.com:ultra96v1:ultra96v1_mipi:1.0} [get_files [current_bd_design].bd]

set_property PFM.CLOCK {clk_out2 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_0" status "fixed"} clk_out3 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_1" status "fixed"}} [get_bd_cells /clk_wiz_0]

set_property PFM.AXI_PORT {M_AXI_HPM0_FPD {memport "M_AXI_GP"} S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "zynq_ultra_ps_e_0 HP0_DDR_LOW"}  S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"}  S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"}} [get_bd_cells /zynq_ultra_ps_e_0]

save_bd_design

set_property platform.default_output_type "sd_card" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.datacenter "false" [current_project]

set_property platform.post_sys_link_tcl_hook ./dynamic_postlink.tcl [current_project]

write_hw_platform -force -include_bit ./ultra96v1_mipi.xsa

validate_hw_platform ./ultra96v1_mipi.xsa
