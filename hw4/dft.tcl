read_verilog FAS_syn.v
read_file FAS_syn.v -format verilog
current_design FAS
link
check_design
source FAS_syn.sdc
report_constraint -all_violators
report_area > FAS_syn.area_rpt
report_timing > FAS_syn.timing_rpt
report_power > FAS_syn.power_rpt


#set_scan_configuration -create_dedicated_scan_out_ports true
set test_default_scan_style multiplexed_flip_flop
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 40
set test_default_period 100
create_test_protocol -infer_asynch -infer_clock
report_constraint -all_violators > FAS_syn.scan_rpt
dft_drc

set_scan_configuration -chain_count 26
preview_dft


insert_dft
report_constraint -all_violators
dft_drc
report_scan_path -view existing -chain all > FAS_dft.scan_path
report_scan_path -view existing -cell all > FAS_dft.scan_cell
report_area > FAS_dft.area_rpt
report_timing > FAS_dft.timing_rpt
report_power > FAS_dft.power_rpt

write_test_protocol -output FAS_dft.spf
write -hierarchy -format verilog -output FAS_dft.v
write -hierarchy -format ddc -output FAS_dft.ddc
write_sdf -version 2.1 FAS_dft.sdf