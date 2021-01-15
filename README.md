# tplink_rom_extend
This script could be used when changing the SPI ROM from 4MB to e.g 8, 16 MB etc

Usage:

./openwrt_SPI_extender.sh {flash size in MB} {original dumped file}


example:

./openwrt_SPI_extender.sh 8 dump.bin


result:

new file with name: dump_8M_extended.bin
