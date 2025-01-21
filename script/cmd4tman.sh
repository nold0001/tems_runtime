#!/bin/sh

func_echoUsage()
{
#	echo "Usage : " $0 "cpu_usage | mem_usage | disk_usage | net_usage | load | ps"
	func_echoUsage_uptime
	func_echoUsage_cpu
	func_echoUsage_mem
	func_echoUsage_disk
	func_echoUsage_net
	func_echoLoad
	func_echoPs
}
func_echoUsage_cpu()
{
	echo "Usage : " $0 "cpu_usage"
}
func_echoUsage_mem()
{
	echo "Usage : " $0 "mem_usage"
}
func_echoUsage_disk()
{
	echo "Usage : " $0 "disk_usage dir-name"
}
func_echoUsage_net()
{
	echo "Usage : " $0 "net_usage interface-name [interval-sec]"
}
func_echoLoad()
{
	echo "Usage : " $0 "load"
}
func_echoPs()
{
	echo "Usage : " $0 "ps"
}

func_uptime()
{
	if [ $# -ne 1 ];then
		func_echoUsage_mem
		exit
	fi
	resultUptime=$(uptime)

	echo $resultUptime
}

func_cpu_usage()
{
	if [ $# -ne 1 -a $# -ne 2 ];then
		func_echoUsage_cpu
		exit
	fi

	if [ $# -eq 1 ];then
		sleepDurationSeconds=0.1
	else
		sleepDurationSeconds=$2
	fi

	previousDate=$(date +%s%N | cut -b1-13)
	previousStats=$(cat /proc/stat)

	sleep $sleepDurationSeconds

	currentDate=$(date +%s%N | cut -b1-13)
	currentStats=$(cat /proc/stat)    

	cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')

	for cpu in $cpus
	do
		currentLine=$(echo "$currentStats" | grep "$cpu ")
		user=$(echo "$currentLine" | awk -F " " '{print $2}')
		nice=$(echo "$currentLine" | awk -F " " '{print $3}')
		system=$(echo "$currentLine" | awk -F " " '{print $4}')
		idle=$(echo "$currentLine" | awk -F " " '{print $5}')
		iowait=$(echo "$currentLine" | awk -F " " '{print $6}')
		irq=$(echo "$currentLine" | awk -F " " '{print $7}')
		softirq=$(echo "$currentLine" | awk -F " " '{print $8}')
		steal=$(echo "$currentLine" | awk -F " " '{print $9}')
		guest=$(echo "$currentLine" | awk -F " " '{print $10}')
		guest_nice=$(echo "$currentLine" | awk -F " " '{print $11}')

		previousLine=$(echo "$previousStats" | grep "$cpu ")
		prevuser=$(echo "$previousLine" | awk -F " " '{print $2}')
		prevnice=$(echo "$previousLine" | awk -F " " '{print $3}')
		prevsystem=$(echo "$previousLine" | awk -F " " '{print $4}')
		previdle=$(echo "$previousLine" | awk -F " " '{print $5}')
		previowait=$(echo "$previousLine" | awk -F " " '{print $6}')
		previrq=$(echo "$previousLine" | awk -F " " '{print $7}')
		prevsoftirq=$(echo "$previousLine" | awk -F " " '{print $8}')
		prevsteal=$(echo "$previousLine" | awk -F " " '{print $9}')
		prevguest=$(echo "$previousLine" | awk -F " " '{print $10}')
		prevguest_nice=$(echo "$previousLine" | awk -F " " '{print $11}')    

		PrevIdle=$((previdle + previowait))
		Idle=$((idle + iowait))

		PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
		NonIdle=$((user + nice + system + irq + softirq + steal))

		PrevTotal=$((PrevIdle + PrevNonIdle))
		Total=$((Idle + NonIdle))

		totald=$((Total - PrevTotal))
		idled=$((Idle - PrevIdle))

		CPU_Percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}")

		if [[ "$cpu" == "cpu" ]]; then
			echo #echo "total "$CPU_Percentage
		else
			echo $cpu" "$CPU_Percentage
		fi
	done
}

func_mem_usage()
{
	if [ $# -ne 1 ];then
		func_echoUsage_mem
		exit
	fi
	freeOutput=$(free)

	memUsage=$(echo "$freeOutput" | grep -i "Mem:")
	memName=$(echo "$memUsage" | awk -F ":" '{print $1}')

	memUsage_total=$(echo "$memUsage" | awk -F " " '{print $2}')
	memUsage_use=$(echo "$memUsage" | awk -F " " '{print $3}')
	memUsage_percentage=$(awk "BEGIN {print (100 * $memUsage_use / $memUsage_total)}")
	echo $memName $memUsage_percentage

	swapUsage=$(echo "$freeOutput" | grep ":" | grep -v "Mem:")
	swapName=$(echo "$swapUsage" | awk -F ":" '{print $1}')

	swapUsage_total=$(echo "$swapUsage" | awk -F " " '{print $2}')
	swapUsage_use=$(echo "$swapUsage" | awk -F " " '{print $3}')
	swapUsage_percentage=$(awk "BEGIN {print (100 * $swapUsage_use / $swapUsage_total)}")
	echo $swapName $swapUsage_percentage
}

func_disk_usage()
{
	if [ $# -ne 2 ];then
		func_echoUsage_disk
		exit
	fi
	dfOutput=$(df $2 | grep -v "Filesystem")

	diskUsage_name=$(echo $dfOutput | awk -F " " '{print $1}')
	diskUsage_available=$(echo $dfOutput | awk -F " " '{print $4}')
	diskUsage_total=$(echo $dfOutput | awk -F " " '{print $2}')
	diskUsage_percentage=$(awk "BEGIN {print (100 * $diskUsage_available / $diskUsage_total)}")
	echo $diskUsage_name $diskUsage_percentage
}

func_net_usage()
{
	if [ $# -ne 2 -a $# -ne 3 ];then
		func_echoUsage_net
		exit
	fi

	if [ $# -eq 2 ];then
		sleepDurationSeconds=1
	else
		sleepDurationSeconds=$3
	fi

	netUsage_name=$2

	prevLine=$(grep $netUsage_name /proc/net/dev)
	sleep $sleepDurationSeconds
	nextLine=$(grep $netUsage_name /proc/net/dev)

	prevRx=$(echo $prevLine | awk '{print $2}')
	prevTx=$(echo $prevLine | awk '{print $10}')

	nextRx=$(echo $nextLine | awk '{print $2}')
	nextTx=$(echo $nextLine | awk '{print $10}')

	netRx=$(awk "BEGIN {print ($nextRx - $prevRx)}")
	netTx=$(awk "BEGIN {print ($nextTx - $prevTx)}")

	echo $netUsage_name $netRx $netTx
}

func_load()
{
	if [ $# -ne 1 ];then
		func_echoLoad
		exit
	fi
	loadOutput=$(cat /proc/loadavg)
	loadMin1=$(echo $loadOutput | awk -F " " '{print $1}')
	loadMin5=$(echo $loadOutput | awk -F " " '{print $2}')
	loadMin15=$(echo $loadOutput | awk -F " " '{print $3}')

	echo $loadMin1 $loadMin5 $loadMin15
}

func_ps()
{
	if [ $# -ne 1 ];then
		func_echoPs
		exit
	fi
	#cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')
	#psOutput=`ps --no-headers laxo stime,uname,pid,ppid,nlwp,%cpu,%mem,rsz,bsdtime,cmd`
	#psOutput=$(tems - ps | awk -F " " '{print $1}' '{print $2}' '{print $3}' '{print $4}' '{print $5}' '{print $6}' '{print $7}' '{print $8}' '{print $9}' '{print $10}')
	#psOutput=$(ps --no-headers laxo stime,uname,pid,ppid,nlwp,%cpu,%mem,rsz,bsdtime,cmd | awk -F '{print $1}' -F '{print $2}' -F '{print $3}' -F '{print $4}' -F '{print $5}' -F '{print $6}' -F '{print $7}' -F '{print $8}' -F '{print $9}' -F '{print $10}')
	tmpfile=$(mktemp /tmp/cmd4tman.XXXXXX)
	cmd="$(ps --no-headers axo stime,uname,pid,ppid,nlwp,%cpu,%mem,rsz,bsdtime,cmd > $tmpfile)"
	$cmd
	/bin/cat $tmpfile
	/bin/rm $tmpfile > /dev/null
}

func_cpu_current()
{
	currentStats=$(cat /proc/stat)    

	cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')

	for cpu in $cpus
	do
		currentLine=$(echo "$currentStats" | grep "$cpu ")
		user=$(echo "$currentLine" | awk -F " " '{print $2}')
		nice=$(echo "$currentLine" | awk -F " " '{print $3}')
		system=$(echo "$currentLine" | awk -F " " '{print $4}')
		idle=$(echo "$currentLine" | awk -F " " '{print $5}')
		iowait=$(echo "$currentLine" | awk -F " " '{print $6}')
		irq=$(echo "$currentLine" | awk -F " " '{print $7}')
		softirq=$(echo "$currentLine" | awk -F " " '{print $8}')
		steal=$(echo "$currentLine" | awk -F " " '{print $9}')

		Idle=$((idle + iowait))
		NonIdle=$((user + nice + system + irq + softirq + steal))
		Total=$((Idle + NonIdle))

		if [[ "$cpu" != "cpu" ]]; then
			#CPU_Percentage=$(awk "BEGIN {print ($NonIdle)/$Total*100}")
			echo $cpu" "$Total $NonIdle
		fi
	done
}

func_net_current()
{
	netUsage_name=$2

	nextLine=$(grep $netUsage_name /proc/net/dev)

	nextRx=$(echo $nextLine | awk '{print $2}')
	nextTx=$(echo $nextLine | awk '{print $10}')

	echo $netUsage_name $nextRx $nextTx
}

case $1 in
	cpu_usage)
		func_cpu_usage $*
		;;
	uptime)
		func_uptime $*
		;;
	mem_usage)
		func_mem_usage $*
		;;
	disk_usage)
		func_disk_usage $*
		;;
	net_usage)
		func_net_usage $*
		;;
	load)
		func_load $*
		;;
	ps)
		func_ps $*
		;;


	cpu_current)
		func_cpu_current $*
		;;
	net_current)
		func_net_current $*
		;;


	*)
		func_echoUsage
		;;
esac


