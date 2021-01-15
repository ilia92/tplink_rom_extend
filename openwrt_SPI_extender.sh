#!/bin/bash
set -e

flash_size_in_MB=$1
original_file=$2

#boot_loader_file=`head -c $(( 128 * 1024 )) $original_file > boot.tmp`
head -c $(( 128 * 1024 )) $original_file > boot.tmp
#art_file=`tail -c $(( 64*1024 )) $original_file > art.tmp`
tail -c $(( 64*1024 )) $original_file > art.tmp


original_file_size=$(wc -c $original_file | cut -f 1 -d " ")
boot_loader_size=$(wc -c boot.tmp | cut -f 1 -d " ")
art_file_size=$(wc -c art.tmp | cut -f 1 -d " ")

internal_part_file=$(( $original_file_size - $art_file_size - $boot_loader_size ))

dd if=$original_file bs=1 skip=$boot_loader_size count=$internal_part_file of="part_${original_file}.tmp"

echo "original_file_size: " $original_file_size
echo "boot_loader_size: " $boot_loader_size
echo "internal_part_file: " $internal_part_file
echo "art_file_size: " $art_file_size

padcount=$(($flash_size_in_MB * 1024 * 1024 - $original_file_size))

result_file_name=`echo $original_file | sed 's|.rom||g' | sed 's|.bin||g'`
result_file_name="${result_file_name}_${flash_size_in_MB=}M_extended.bin"

echo " Write boot loader ..."
dd if=boot.tmp bs=512 > $result_file_name

echo "Write firmware ..."
dd if="part_${original_file}.tmp" bs=512 >> $result_file_name

echo "Write padding FF ..."
dd if=/dev/zero ibs=1 count="$padcount" | tr "\000" "\377" >> $result_file_name

echo "Write art partition"
dd if=art.tmp bs=512 >> $result_file_name

# Cleaning
#rm boot.tmp art.tmp "part_${original_file}.tmp"

echo "File is ready: " $result_file_name
