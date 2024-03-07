#!/bin/bash
mkdir -p ~/printer_data/gcodes/plr
filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" /home/sovol/printer_data/config/saved_variables.cfg)
filepath=$(printf "$filepath")
echo "filepath=$filepath"
last_file=$(sed -n "s/.*last_file *= *'\([^']*\)'.*/\1/p" /home/sovol/printer_data/config/saved_variables.cfg)
last_file=$(printf "$last_file")
echo "$last_file"
plr=$last_file

height=$(jq -r '.Z' /home/sovol/sovol_plr_height)
commandline=$(jq -r '.commandline' /home/sovol/sovol_plr_height)
extrude_type=$(jq -r '.extrude_type' /home/sovol/sovol_plr_height)
e_extrude_abs=$(jq -r '.e_extrude_abs' /home/sovol/sovol_plr_height)

echo "height=$height"	#打印出Z轴高度
echo "plr=$plr" 		#打印续打文件路径

PLR_PATH=~/printer_data/gcodes/plr
file_content=$(cat "${filepath}" | sed '/; thumbnail begin/,/; thumbnail end/d')
comment_content=$(grep '^;' "${filepath}" | sed '/; thumbnail end/q')
echo "$file_content" | sed  's/\r$//' | awk -F"Z" 'BEGIN{OFS="Z"} {if ($2 ~ /^[0-9]+$/) $2=$2".0"} 1' > /home/sovol/plrtmpA.$$

echo "$comment_content" > ${PLR_PATH}/"${plr}"
grep ';TIME:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';Layer height:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINX:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINY:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINZ:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXX:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXY:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXZ:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';Generated with Sovol Slicer' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
echo "SET_KINEMATIC_POSITION Z=$height" >> ${PLR_PATH}/"${plr}"

# BG_EX=`tac /home/sovol/plrtmpA.$$ | sed -e '/$commandline\$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
# echo 'G92 E0.0' >> ${PLR_PATH}/"${plr}"
# echo "$BG_EX" 
# if [ "${BG_EX}" = "" ]; then
#     BG_EX=`tac /home/sovol/plrtmpA.$$ | sed -e '/$commandline\$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
# fi

#echo 'G91' >> ${PLR_PATH}/"${plr}"
#echo 'G1 Z9.9999' >> ${PLR_PATH}/"${plr}"
#echo 'G90' >> ${PLR_PATH}/"${plr}"

#升温防止扯模型
#echo 'M109 S200' >> ${PLR_PATH}/"${plr}"
#echo 'M190 S60' >> ${PLR_PATH}/"${plr}"

# 提前将热床、挤出机升温到制定打印温度，防止后续进行等待
cat /home/sovol/plrtmpA.$$ | sed '/ Z'${height}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M140 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M104 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M190 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M109 S/p' | head -1 >> ${PLR_PATH}/"${plr}"


#抬升z轴，XY回零
echo 'G91' >> ${PLR_PATH}/"${plr}"
echo 'G1 Z5' >> ${PLR_PATH}/"${plr}"
echo 'G90' >> ${PLR_PATH}/"${plr}"
echo 'G28 X Y' >> ${PLR_PATH}/"${plr}"
adjusted_height=$(echo "$height + 5" | bc)
echo "SET_KINEMATIC_POSITION Z=$adjusted_height" >> ${PLR_PATH}/"${plr}"  #chris

#获取温度
cat /home/sovol/plrtmpA.$$ | sed '/ Z'${height}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M140 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M104 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M190 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M109 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
echo 'plr_temperature_wait' >> ${PLR_PATH}/"${plr}"
#开启风扇
echo 'M106 S255' >> ${PLR_PATH}/"${plr}"

#移动到续打点
f_value=10000
x_value=$(echo "$commandline" | grep -oP '(?<=X)[0-9.]+')
y_value=$(echo "$commandline" | grep -oP '(?<=Y)[0-9.]+')
z_value=$(echo "$commandline" | grep -oP '(?<=Z)[0-9.]+')
gcode_z="G0 Z$z_value"
gcode_xy="G0 F$f_value X$x_value Y$y_value"
gcode_absolute_extrude="$extrude_type"
gcode_e="G92 E$e_extrude_abs"
echo $gcode_z >> ${PLR_PATH}/"${plr}"
echo $gcode_xy >> ${PLR_PATH}/"${plr}"
echo $gcode_absolute_extrude >> ${PLR_PATH}/"${plr}"
echo $gcode_e >> ${PLR_PATH}/"${plr}"

#复制后续gcode
sed -n "/$commandline/,\$p" /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"

#删除中间文件
rm /home/sovol/plrtmpA.$$
