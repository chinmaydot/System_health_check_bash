#!/bin/bash

# Enable debuggin if debugging is set to true
DEBUG=true

if [ "$DEBUG" = true ]; then
	set -x
fi

EMAIL="uparechinmay24@gmail.com"
REPORT_FILE="/mnt/c/Users/Chinmay/Documents/system_health_report.txt"

check_disk_usage() {
	echo "=== Disk Usage ===" >> $REPORT_FILE
	df -h >> $REPORT_FILE
	cat $REPORT_FILE
}

monitor_services() {
	echo "=== Monitor Services ===" >> $REPORT_FILE
	systemctl list-units -- type=service --state=running >> $REPORT_FILE
	cat $REPORT_FILE
}

check_memory_usage() {
	echo "=== Memory Usage ===" >> $REPORT_FILE
	free -h >> $REPORT_FILE
	cat $REPORT_FILE
}

check_cpu_usage() {
	echo "=== CPU Usage ===" >> $REPORT_FILE
	top -b -n 1 | head -10 >> $REPORT_FILE
	cat $REPORT_FILE
}
send_email_report() {
	echo "Sending report via Email"
	{
		echo "Subject: System Health Report"
		echo "System Health Report:"
		cat $REPORT_FILE
	} | sendmail -v -i -Am $EMAIL
}

while true; do
	echo "========================================="
	echo "System Health Check Menu"
	echo "1. Check Disk Usage"
	echo "2. Monitor Running services"
	echo "3. check Memory Usage"
	echo "4. Check CPU Usage"
	echo "5. Send Report via Email"
	echo "6. Exit"
	read -p "Select from an option (1-6):" choice

	case $choice in 
		1) 
			check_disk_usage
			;;
		2)
			monitor_sevices
			;;
		3)
			check_memory_usage
			;;
		4)
			check_cpu_usage
			;;
		5)
			send_email_report
			;;
		6)
			echo "Exiting... goodbye!"
		        exit 0
			;;
		*)
			echo "Please enter valid option"
			;;
	esac
done	



