#!/bin/bash

filepath="/home/swapnesh/Logs/Net Usage/"
filename=$(date -R | awk '{print "du" $2 $3 $4 ".txt"}')

while true
do
	ipstat=$(ifconfig eno1 | grep 'inet addr')

	if [ ! -z "$ipstat" ]; then

		filename=$(date -R | awk '{print "du" $2 $3 $4 ".txt"}')

		if [ -e "$filepath${filename}" ]; then
			dat_inter=$(tail -n2 "$filepath${filename}" | head -n1)
			dat_intra=$(tail -n1 "$filepath${filename}")
		else
			dat_inter=0
			dat_intra=0
			zenity --warning --title="WARNING : netmon.sh" --text="New log file created" &
		fi

		nethogs -c 1 -d 3 -t -v 3 > "$filepath"nethogs_output.txt
		
		sed 1,5d "$filepath"nethogs_output.txt > "$filepath"nethogs_output_e.txt
		acq_inter=$(grep -v linuxdcpp "$filepath"nethogs_output_e.txt | awk '{dat_sum+=$3} END {print dat_sum}')
		acq_intra=$(grep linuxdcpp "$filepath"nethogs_output_e.txt | awk '{dat_sum+=$3} END {print dat_sum}')

		if [ ! -z "$acq_inter" ]; then
			dat_inter=$(printf "$dat_inter $acq_inter" | awk '{print $1 + $2}')
		fi

		if [ ! -z "$acq_intra" ]; then
			dat_intra=$(printf "$dat_intra $acq_intra" | awk '{print $1 + $2}')
		fi
	
		date -R > "$filepath${filename}"
		printf "\n" >> "$filepath${filename}"
		printf "$dat_inter\n" >> "$filepath${filename}"
		printf "$dat_intra" >> "$filepath${filename}"

	fi
done


: '
##Does not work for scientific notation

#
for dat in ${inter[*]}
	do
		dat_sum=`$(($dat_sum + $dat))`
	done
#

#
IFS='+'
sum=$(echo "scale=2;${inter[*]}" | bc -l)
echo $sum
#
'


