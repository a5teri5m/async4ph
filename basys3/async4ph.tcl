
proc create { 
    args
} {

    # 引数チェック ------------------------------------------
   
    puts "INFO: Create project"

    # プロジェクト名 
    if {[set prj [get_args prj ${args}]] == ""} {
        error "ERROR: \"-prj <project name>\" is not found. \[proc(create)\]"
    }
    puts "INFO: prj = ${prj}"
    # プロジェクトディレクトリ 
    if {[set prjdir [get_args prjdir ${args}]] == ""} {
        error "ERROR: \"-prjdir <project directory>\" is not found. \[proc(create)\]"
    }
    puts "INFO: prjdir = ${prjdir}"
    # パーツ名 
    if {[set part [get_args part ${args}]] == ""} {
        error "ERROR: \"-part <target part>\" is not found. \[proc(create)\]"
    }
    puts "INFO: part = ${part}"
    # ボードパーツ名 
    if {[set board [get_args board ${args}]] == ""} {
        unset board
    } else {
        puts "INFO: board = ${board}"
    }
    # トップモジュール名
    if {[set top [get_args top ${args}]] == ""} {
        error "ERROR: \"-top <top module>\" is not found. \[proc(create)\]"
    }
    puts "INFO: top = ${top}"
    # ソースファイル（Design Sources）ディレクトリ
    set srcdirs [list]
    while {1} {
        if {[set dir [get_args srcdir ${args}]] == ""} {
            break
        } else {
            set srcdirs [concat ${srcdirs} ${dir}]    
        }
    }
    if {[string match "" ${srcdirs}]} {
        error "ERROR: \"-srcdir <design sources directory>\" is not found. \[proc(create)\]"
    }
    puts "INFO: srcdirs = ${srcdirs}"
    # IP_REPO_PATHS
    set ipdirs [list]
    while {1} {
        if {[set dir [get_args ipdir ${args}]] == ""} {
            break
        } else {
            set ipdirs [concat ${ipdirs} ${dir}]    
        }
    }
    if {[string match "" ${ipdirs}]} {
        unset ipdirs
    } else {
        puts "INFO: ipdirs = ${ipdirs}"
    }
    # プロジェクト設定
    if {[set prjcfg [get_args prjcfg ${args}]] == ""} {
        unset prjcfg
    } else {
        puts "INFO: prjcfg = ${prjcfg}"
    }
    # Synthsis設定
    if {[set synthcfg [get_args synthcfg ${args}]] == ""} {
        unset synthcfg
    } else {
        puts "INFO: synthcfg = ${synthcfg}"
    }
    # Impl設定
    if {[set implcfg [get_args implcfg ${args}]] == ""} {
        unset implcfg
    } else {
        puts "INFO: implcfg = ${implcfg}"
    }
    # Pre-Project設定
    if {[set precfg [get_args precfg ${args}]] == ""} {
        unset precfg
    } else {
        puts "INFO: precfg = ${precfg}"
    }
    # Post-Project設定
    if {[set postcfg [get_args postcfg ${args}]] == ""} {
        unset postcfg
    } else {
        puts "INFO: postcfg = ${postcfg}"
    }

    
    
    # メイン処理 -----------------------------------------------------------------

    
    # Pre-Project設定の読込
    if {[info exists precfg]} {
        if {[file exists ${precfg}]} {
            puts "INFO: Load pre-project config file \"${precfg}\""    
            source ${precfg}    
        } else {
            error "ERROR: Pre-project config file \"${precfg}\" is not found. \[proc(create)\]"
        }
    }

    
    # プロジェクトの作成
    create_project ${prj} ${prjdir} -part ${part}
    set prjdir [get_property directory [current_project]]
    set prjobj [get_projects ${prj}]
    # ボードパーツの設定 
    if {[info exists board]} {
        set_property "board_part" ${board} ${prjobj}
        puts "INFO: set_property board_part ${board}"
    }
    # 設定ファイルがあれば読み込む
    if {[info exists prjcfg]} {
        if {[file exists ${prjcfg}]} {
            puts "INFO: Load project config file \"${prjcfg}\""    
            source ${prjcfg}    
        } else {
            error "ERROR: Project config file \"${prjcfg}\" is not found. \[proc(create)\]"
        }
    }


    # fileset sources_1 の作成
    if {[string equal [get_filesets -quiet sources_1] ""]} {
        create_fileset -srcset sources_1
    }
    # sources_1 の設定
    set srcsobj [get_filesets sources_1]
    set_property "design_mode" "RTL" ${srcsobj}
    set_property "edif_extra_search_paths" "" ${srcsobj}
    set_property "generic" "" ${srcsobj}
    set_property "include_dirs" "" ${srcsobj}
    set_property "lib_map_file" "" ${srcsobj}
    set_property "loop_count" "1000" ${srcsobj}
    set_property "name" "sources_1" ${srcsobj}
    set_property "top" ${top} ${srcsobj}
    set_property "verilog_define" "" ${srcsobj}
    set_property "verilog_uppercase" "0" ${srcsobj}

    # fileset constrs_1 の作成
    if {[string equal [get_filesets -quiet constrs_1] ""]} {
        create_fileset -constrset constrs_1
    }

    # fileset sim_1 の作成
    if {[string equal [get_filesets -quiet sim_1] ""]} {
      create_fileset -simset sim_1
    }

    # run synth_1 の作成
    if {[string equal [get_runs -quiet synth_1] ""]} {
        create_run -name synth_1 -part ${part} \
            -flow {Vivado Synthesis 2014} -strategy "Vivado Synthesis Defaults" \
            -constrset constrs_1
    }
    # デフォルトの設定
    set synthobj [get_runs synth_1]
    set_property "constrset" "constrs_1" ${synthobj}
    set_property "description" "Vivado Synthesis Defaults" ${synthobj}
    set_property "flow" "Vivado Synthesis 2014" ${synthobj}
    set_property "name" "synth_1" ${synthobj}
    set_property "needs_refresh" "0" ${synthobj}
    set_property "srcset" "sources_1" ${synthobj}
    set_property "strategy" "Vivado Synthesis Defaults" ${synthobj}
    set_property "incremental_checkpoint" "" ${synthobj}
    set_property "steps.synth_design.tcl.pre" "" ${synthobj}
    set_property "steps.synth_design.tcl.post" "" ${synthobj}
    set_property "steps.synth_design.args.flatten_hierarchy" "rebuilt" ${synthobj}
    set_property "steps.synth_design.args.gated_clock_conversion" "off" ${synthobj}
    set_property "steps.synth_design.args.bufg" "12" ${synthobj}
    set_property "steps.synth_design.args.fanout_limit" "10000" ${synthobj}
    set_property "steps.synth_design.args.directive" "Default" ${synthobj}
    set_property "steps.synth_design.args.fsm_extraction" "auto" ${synthobj}
    set_property "steps.synth_design.args.keep_equivalent_registers" "0" ${synthobj}
    set_property "steps.synth_design.args.resource_sharing" "auto" ${synthobj}
    set_property "steps.synth_design.args.control_set_opt_threshold" "4" ${synthobj}
    set_property "steps.synth_design.args.no_lc" "0" ${synthobj}
    set_property "steps.synth_design.args.shreg_min_size" "3" ${synthobj}
    set_property "steps.synth_design.args.max_bram" "-1" ${synthobj}
    set_property "steps.synth_design.args.max_dsp" "-1" ${synthobj}
    set_property -name {steps.synth_design.args.more options} -value {} -objects ${synthobj}
    # 設定ファイルがあれば読み込む
    if {[info exists synthcfg]} {
        if {[file exists ${synthcfg}]} {
            puts "INFO: Load synthesis config file \"${synthcfg}\""    
            source ${synthcfg}    
        } else {
            error "ERROR: Synthesis config file \"${synthcfg}\" is not found. \[proc(create)\]"
        }
    }
    current_run -synthesis ${synthobj}


    # run impl_1 の作成
    if {[string equal [get_runs -quiet impl_1] ""]} {
        create_run -name impl_1 -part ${part} \
            -flow {Vivado Implementation 2014} -strategy "Vivado Implementation Defaults" \
            -constrset constrs_1 -parent_run synth_1
    }
    # デフォルト設定
    set implobj [get_runs impl_1]
    set_property "constrset" "constrs_1" ${implobj}
    set_property "description" "Vivado Implementation Defaults" ${implobj}
    set_property "flow" "Vivado Implementation 2014" ${implobj}
    set_property "name" "impl_1" ${implobj}
    set_property "needs_refresh" "0" ${implobj}
    set_property "srcset" "sources_1" ${implobj}
    set_property "strategy" "Vivado Implementation Defaults" ${implobj}
    set_property "incremental_checkpoint" "" ${implobj}
    set_property "steps.opt_design.is_enabled" "1" ${implobj}
    set_property "steps.opt_design.tcl.pre" "" ${implobj}
    set_property "steps.opt_design.tcl.post" "" ${implobj}
    set_property "steps.opt_design.args.verbose" "0" ${implobj}
    set_property "steps.opt_design.args.directive" "Default" ${implobj}
    set_property -name {steps.opt_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.power_opt_design.is_enabled" "0" ${implobj}
    set_property "steps.power_opt_design.tcl.pre" "" ${implobj}
    set_property "steps.power_opt_design.tcl.post" "" ${implobj}
    set_property -name {steps.power_opt_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.place_design.tcl.pre" "" ${implobj}
    set_property "steps.place_design.tcl.post" "" ${implobj}
    set_property "steps.place_design.args.directive" "Default" ${implobj}
    set_property -name {steps.place_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.post_place_power_opt_design.is_enabled" "0" ${implobj}
    set_property "steps.post_place_power_opt_design.tcl.pre" "" ${implobj}
    set_property "steps.post_place_power_opt_design.tcl.post" "" ${implobj}
    set_property -name {steps.post_place_power_opt_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.phys_opt_design.is_enabled" "0" ${implobj}
    set_property "steps.phys_opt_design.tcl.pre" "" ${implobj}
    set_property "steps.phys_opt_design.tcl.post" "" ${implobj}
    set_property "steps.phys_opt_design.args.directive" "Default" ${implobj}
    set_property -name {steps.phys_opt_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.route_design.tcl.pre" "" ${implobj}
    set_property "steps.route_design.tcl.post" "" ${implobj}
    set_property "steps.route_design.args.directive" "Default" ${implobj}
    set_property -name {steps.route_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.post_route_phys_opt_design.is_enabled" "0" ${implobj}
    set_property "steps.post_route_phys_opt_design.tcl.pre" "" ${implobj}
    set_property "steps.post_route_phys_opt_design.tcl.post" "" ${implobj}
    set_property "steps.post_route_phys_opt_design.args.directive" "Default" ${implobj}
    set_property -name {steps.post_route_phys_opt_design.args.more options} -value {} -objects ${implobj}
    set_property "steps.write_bitstream.tcl.pre" "" ${implobj}
    set_property "steps.write_bitstream.tcl.post" "" ${implobj}
    set_property "steps.write_bitstream.args.raw_bitfile" "0" ${implobj}
    set_property "steps.write_bitstream.args.mask_file" "0" ${implobj}
    set_property "steps.write_bitstream.args.no_binary_bitfile" "0" ${implobj}
    set_property "steps.write_bitstream.args.bin_file" "0" ${implobj}
    set_property "steps.write_bitstream.args.logic_location_file" "0" ${implobj}
    set_property -name {steps.write_bitstream.args.more options} -value {} -objects ${implobj}
    # 設定ファイルがあれば読み込む
    if {[info exists implcfg]} {
        if {[file exists ${implcfg}]} {
            puts "INFO: Load implementation config file \"${implcfg}\""    
            source ${implcfg}    
        } else {
            error "ERROR: Implementation config file \"${implcfg}\" is not found. \[proc(create)\]"
        }
    }
    current_run -implementation ${implobj}

    # ユーザのIPレポジトリの追加
    if {[info exists ipdirs]} {
        set_property "ip_repo_paths" "[file normalize ${ipdirs}]" [get_filesets sources_1]
    }


    # ソースファイルの追加 
    # ソースファイル（Design Sources）の取得
    set srcs [globRecursiveDirs ${srcdirs} \
        [list *.v *.vlog *.sv *.vh *.vhd *.vhdl *.ngc *.mif *.hex *.prj *.xdc *.xci *.bd.tcl]]
    puts "INFO: srcs = ${srcs}"
    puts "INFO: Import Design Sources ..."
    foreach file ${srcs} {
        switch -glob ${file} {
            *.v {
                # Verilog HDL
                puts "INFO: Import ${file} (Verilog)" 
                set file [file normalize ${file}]
                add_files -norecurse -fileset sources_1 ${file}
                set fileobj [get_files -of_objects [get_filesets sources_1] [list "*${file}"]]
                set_property "file_type" "Verilog" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "used_in" "synthesis implementation simulation" ${fileobj}
                set_property "used_in_implementation" "1" ${fileobj}
                set_property "used_in_simulation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}
            }    
            *.vh {
                # Verilog Header
                puts "INFO: Import ${file} (Verilog Header)" 
                set file [file normalize ${file}]
                add_files -norecurse -fileset sources_1 ${file}
                set fileobj [get_files -of_objects [get_filesets sources_1] [list "*${file}"]]
                set_property "file_type" "Verilog Header" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "used_in" "synthesis simulation" ${fileobj}
                set_property "used_in_simulation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}
            }             
            *.sv {
                # SystemVerilog
                puts "INFO: Import ${file} (SystemVerilog)" 
                set file [file normalize ${file}]
                add_files -norecurse -fileset sources_1 ${file}
                set fileobj [get_files -of_objects [get_filesets sources_1] [list "*${file}"]]
                set_property "file_type" "SystemVerilog" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "used_in" "synthesis implementation simulation" ${fileobj}
                set_property "used_in_implementation" "1" ${fileobj}
                set_property "used_in_simulation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}
            }
            *.hex {
                # Hex Files
                puts "INFO: Import ${file} (HEX File)" 
                set file [file normalize ${file}]
                add_files -norecurse -fileset sources_1 ${file}
                set fileobj [get_files -of_objects [get_filesets sources_1 ] [list "*${file}"]]
                set_property "file_type" "Memory Initialization Files" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "used_in" "synthesis simulation" ${fileobj}
                set_property "used_in_simulation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}    
            }
            *.xdc {
                # XDC
                puts "INFO: Import ${file} (XDC)" 
                set file [file normalize ${file}]
                add_files -norecurse -fileset constrs_1 ${file}
                set fileobj [get_files -of_objects [get_filesets constrs_1] [list "*${file}"]]
                set_property "file_type" "XDC" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "processing_order" "NORMAL" ${fileobj}
                set_property "scoped_to_cells" "" ${fileobj}
                set_property "scoped_to_ref" "" ${fileobj}
                set_property "used_in" "synthesis implementation" ${fileobj}
                set_property "used_in_implementation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}
            }
            *.xci {
                # XCI
                puts "INFO: Import ${file} (XCI)" 
                set xci [regsub {^(.+?)\..*$} "[file tail ${file}]" {\1}]
                set file [file normalize ${file}]
                add_files -norecurse -copy_to "${prjdir}/${prj}.srcs/sources_1/ip" -fileset sources_1 ${file}
                set file "${xci}/${xci}.xci"
                set fileobj [get_files -of_objects [get_filesets sources_1] [list "*${file}"]]
                set_property "generate_synth_checkpoint" "1" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "used_in" "synthesis implementation simulation" ${fileobj}
                set_property "used_in_implementation" "1" ${fileobj}
                set_property "used_in_simulation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}
            }
            *.bd.tcl {
                # Block Design
                # ブロックデザイン名の取得 (***.bd.tclの***部分)
                set bd [regsub {^(.+?)\..*$} "[file tail ${file}]" {\1}]
                # Block Designの読込み
                source ${file}
                set bd_design [get_bd_designs ${bd}]
                current_bd_design ${bd_design}
                # ラッパーの作成
                make_wrapper -files [get_files "${prjdir}/${prj}.srcs/sources_1/bd/${bd}/${bd}.bd"] -top
                # ラッパーの追加
                puts "INFO: Import ${prjdir}/${prj}.srcs/sources_1/bd/${bd}/hdl/${bd}_wrapper.v (Verilog)"
                add_files -norecurse "${prjdir}/${prj}.srcs/sources_1/bd/${bd}/hdl/${bd}_wrapper.v"
                set file "${prjdir}/${prj}.srcs/sources_1/bd/$bd/hdl/${bd}_wrapper.v"
                set file [file normalize ${file}]
                set fileobj [get_files -of_objects [get_filesets sources_1] [list "*${file}"]]
                set_property "file_type" "Verilog" ${fileobj}
                set_property "is_enabled" "1" ${fileobj}
                set_property "is_global_include" "0" ${fileobj}
                set_property "library" "xil_defaultlib" ${fileobj}
                set_property "path_mode" "RelativeFirst" ${fileobj}
                set_property "used_in" "synthesis implementation simulation" ${fileobj}
                set_property "used_in_implementation" "1" ${fileobj}
                set_property "used_in_simulation" "1" ${fileobj}
                set_property "used_in_synthesis" "1" ${fileobj}
                # デザインを閉じる
                close_bd_design ${bd_design}
            }
            default {
                error "ERROR: ${file} is not imported" 
            }
        }
    }
    # Post-Project設定の読込
    if {[info exists postcfg]} {
        if {[file exists ${postcfg}]} {
            puts "INFO: Load post-project config file \"${postcfg}\""    
            source ${postcfg}    
        } else {
            error "ERROR: Post-project config file \"${postcfg}\" is not found. \[proc(create)\]"
        }
    }


    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1

    puts "INFO: Project Created: ${prj}"

    close_project
    puts "INFO: close project"
}


# ディレクトリリストから再帰的にファイルを取得する
proc globRecursiveDirs {dirs masks} {
    set result [list]
    foreach dir ${dirs} {
        set result [concat ${result} [globRecursive ${dir} ${masks}]]
    }
    return ${result}
}

# 再帰的にファイルを取得
proc globRecursive {dir masks} {
    set result [list]
    foreach cur [lsort [glob -nocomplain -dir ${dir} *]] {
        if {[file type ${cur}] == "directory"} {
            eval lappend result [globRecursive ${cur} ${masks}]
        } else {
            foreach mask ${masks} {
                if {[string match ${mask} ${cur}]} {
                    lappend result ${cur}
                    break
                }
            }
        }
    } 
    return ${result} 
}

# 引数の取得
proc get_args { name args } {
    upvar args largs
    set arg ""
    set idx [lsearch ${largs} "-${name}"] 
    if {${idx} != -1} {
        set arg [lindex ${largs} [expr {${idx}+1}]]    
        set largs [lreplace ${largs} ${idx} [expr {${idx}+1}]]
    }
    return ${arg}
}


create -prj async4ph \
       -prjdir project \
       -part xc7a35tcpg236-1 \
       -srcdir srcs \
       -top top



