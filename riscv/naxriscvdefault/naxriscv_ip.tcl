#set name NaxTapascoRiscvSmall
set version 1.0
create_project -in_memory

set rootdir [lindex $::argv 0]
set module [lindex $::argv 1]
set name $module

add_files $rootdir/$module.v
add_files $rootdir/Ram_1w_1rs_Generic.v

update_compile_order -fileset sources_1
set_property top $module [current_fileset]
update_compile_order -fileset sources_1

ipx::package_project -root_dir $rootdir -import_files -force -force_update_compile_order
set core [ipx::current_core]
set_property vendor user.org $core
set_property library user $core
set_property name $name $core
set_property display_name ${name} $core
set_property description ${name} $core
set_property version $version $core
set_property core_revision 1 $core

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::save_core $core
ipx::check_integrity $core

ipx::unload_core component_1

set_property  ip_repo_paths $rootdir [current_project]
update_ip_catalog
