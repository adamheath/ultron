#!/bin/bash

source $(dirname $0)/simple_curses.sh

main(){
    window "Top 10 IPs" "white" "25%"
    netstat -ntulpa | awk '/:80/ {print $5}' | awk -F\: '{print $1}' |sort -n | uniq -c |sort -n | tail -10 > /tmp/ips.ultron
    while read ips ; do
        append_tabbed "$ips~" 1 "~"
        done < /tmp/ips.ultron
        rm -f /tmp/ips.ultron
    endwin

    window "Memory usage" "white" "25%"
    append_tabbed `cat /proc/meminfo | awk '/MemTotal/ {print "Total:" $2/1024}'` 2
    append_tabbed `cat /proc/meminfo | awk '/MemFree/ {print "Used:" $2/1024}'` 2
    endwin

    window "Processes taking memory and CPU" "white" "25%"
    for i in `seq 2 10`; do
        append_tabbed "`ps ax -o pid,rss,pcpu,ucmd --sort=-cpu,-rss | sed -n "$i,$i p" | awk '{printf "%s: %s:  %s%%" , $4, $2/1024, $3 }'`" 3
    done
    endwin

    col_right 
    move_up

    window "Mail Queue Count" "white" "25%"
    append "`exim -bpc`"
    endwin

    window "Top Mailing Accounts" "white" "25%"
    exim -bp | awk {'print $4'} | cut -d @ -f 2 | awk -F ">" '{print $1}'  |sort | uniq -c | sort -n | tail -n 10 > /tmp/accounts.ultron
    while read accounts ; do
    	append_tabbed "$accounts~" 1 "~"
    	done < /tmp/accounts.ultron
    	rm -f /tmp/accounts.ultron
    endwin

    col_right 
    move_up

    window "Load Averages" "white" "50%"
    append "`uptime`"
    endwin

    window "Potential Spam Directories" "white" "50%"
    tail -n 1000 /var/log/exim_mainlog | grep cwd=/home | awk '{print $4}' |sort | uniq -c | sort -n > /tmp/spam.ultron
    while read spam ; do
        append_tabbed "$spam~" 1 "~"
        done < /tmp/spam.ultron
        rm -f /tmp/spam.ultron
    endwin

    window "PHP scripts using CPU" "white" "50%"
    ps ax -o pid,pcpu,cmd --sort=-cpu,-rss | grep [p]hp > /tmp/php.ultron
    while read php ; do
        append_tabbed "$php~" 1 "~"
        done < /tmp/php.ultron
        rm -f /tmp/php.ultron
    endwin


}
main_loop
