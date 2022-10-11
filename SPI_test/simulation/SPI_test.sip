set_global_assignment -entity "SPI_test" -library "lib_SPI_test" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "SPI_test" -library "lib_SPI_test" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "SPI_test" -library "lib_SPI_test" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_SPI_test" -name SPD_FILE [file join $::quartus(sip_path) "../SPI_test.spd"]
set_global_assignment -library "lib_SPI_test" -name MISC_FILE [file join $::quartus(sip_path) "../../SPI_test.qsys"]

set_global_assignment -library "lib_SPI_test" -name MISC_FILE [file join $::quartus(sip_path) "SPI_test.v"]
set_global_assignment -library "lib_SPI_test" -name MISC_FILE [file join $::quartus(sip_path) "submodules/spiphyslave.v"]
