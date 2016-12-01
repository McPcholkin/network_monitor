#!/bin/bash

# -----------------------------------------
#
# Reboot ADSL Modem if connetcito to 5 of 5 hosts
# not respond to ping
#
# ----------------------------------------

# Hosts list
host0=yandex.ua
host1=google.com.ua
host2=ns.volia.com
host3=amazon.com
host4=ukrtelecom.ua

number_of_hosts=5   # nunber of used hosts

number_of_packets=2 # how mach pactets to send
check_interval=2    # how freq to check connection
boot_time=1         # time to wait after modem reboot

unreachable_hosts=0 # initialize variable


# main function
pinger () { # ping hosts from array
   ARRAY=($@) # include all arguments that send to function in array
#   echo $@    # debug
   i=0        # initialize counter

   while [ "$#" -gt $i ]   # compare counter with number of arguments
    do 
#      echo "argument number $i = ${ARRAY[$i]}" # debug

      ping -c $number_of_packets -q ${ARRAY[$i]} 2>1 1>/dev/null # ping host number "i" in array
        if
          [ "$?" = 0 ] # if exit code of ping are zero
            then       # all OK 
                echo "${ARRAY[$i]} is reachable" # debug 
            else       # host unreachable (exit code is 2)
                echo "${ARRAY[$i]} is NOT reachable" # debug
                let unreachable_hosts=$unreachable_hosts+1 # increase counter of unreachable hosts
        fi

      let i=$i+1 # increase counter of arguments
    done            
}

# main cycle 
while true 
  do
    pinger $host0 $host1 $host2 $host3 $host4  # select host to ping
    echo "Number of unreachable hosts: $unreachable_hosts of $number_of_hosts" # debug

      if # Check unreaceble host counter
        [ "$unreachable_hosts" -eq "$number_of_hosts" ] # if ALL hosts unreachable reboot modem
          then # reboot modem
            echo "Network connettion is lost, we all die" # debug
            echo "Reboot modem and wait 5 min"            # debug
            sleep $boot_time  # wait until modem reboot
          else # all ok
            echo "All OK Internet is work" # debug
    fi

    let unreachable_hosts=0 # reset unreacable host counter

    sleep $check_interval   # interval to chack network status


  done


