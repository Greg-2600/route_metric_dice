#!/bin/bash
 
get_interfaces() {
	ifconfig|
	grep en|
	awk '{print $1}'|
	grep ':'|
	tr -d ':'|
	sort -R
}


chill() {

	duration="$1"
	sleep "$duration"
}


change_int_metric() {

	interface="$1"
	weight="$2"
	sudo ifmetric "$interface" "$weight"

}


main() {
	weight='0'
	interfaces="$(get_interfaces)"
	last_interface='';

	for interface in $interfaces; do
		change_int_metric "$interface" "$weight"
		echo "changed metric to prefer interface $interface over $last_interface"
		last_interface="$interface"
		chill '5'; 
	done
}


while true; do 
	main
done
