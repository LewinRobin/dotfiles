#!/bin/bash

# --- CONFIG ---
INTERFACE="wlp0s20f3" 
STATE_FILE="/tmp/net_stats_state"
DISK_STATE_FILE="/tmp/disk_util_state"

# The Figure Space (U+2007) - width of a digit
FIG_SPACE=$(printf '\u2007')

# 1. CPU Usage
cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}')

# 2. Memory & Swap
read mem_used mem_total <<< $(free -b | awk '/Mem:/ {printf "%.1f %.1f", $3/1024^3, $2/1024^3}')
read swp_used swp_total <<< $(free -b | awk '/Swap:/ {printf "%.1f %.1f", $3/1024^3, $2/1024^3}')

# 3. Disk Space Usage (Capacity)
disk_used=$(df -h / | awk 'NR==2 {print $3}')
disk_total=$(df -h / | awk 'NR==2 {print $2}')

# 4. Network Speed Logic
line=$(grep "$INTERFACE" /proc/net/dev)
rx1=$(echo $line | awk -F: '{print $2}' | awk '{print $1}')
tx1=$(echo $line | awk -F: '{print $2}' | awk '{print $9}')

if [ -f "$STATE_FILE" ]; then
    read rx0 tx0 last_time < "$STATE_FILE"
    now=$(date +%s)
    dt=$((now - last_time))
    if [ $dt -gt 0 ]; then
        rx_bps=$(( (rx1 - rx0) / dt ))
        tx_bps=$(( (tx1 - tx0) / dt ))
    else
        rx_bps=0; tx_bps=0
    fi
else
    rx_bps=0; tx_bps=0
fi
echo "$rx1 $tx1 $(date +%s)" > "$STATE_FILE"

# 5. Total Disk Utilization % (Aggregate of all physical disks)
# Filters for sda, sdb, nvme0n1, etc., while ignoring partitions (sda1) and loops
current_io_total=$(awk '$3 ~ /^(([hs]|v)d[a-z]|nvme[0-9]n[0-9])$/ {sum += $13} END {print sum}' /proc/diskstats)

if [ -f "$DISK_STATE_FILE" ]; then
    read last_io last_io_time < "$DISK_STATE_FILE"
    now_io=$(date +%s%3N) 
    dt_io=$((now_io - last_io_time))
    
    if [ $dt_io -gt 0 ]; then
        # Total utilization across all drives
        util=$(( (current_io_total - last_io) * 100 / dt_io ))
        (( util > 100 )) && util=100
        (( util < 0 )) && util=0
    else
        util=0
    fi
else
    util=0
fi
echo "$current_io_total $(date +%s%3N)" > "$DISK_STATE_FILE"

# --- PADDING FUNCTIONS ---

pad_to_three() {
    local str=$1
    local len=${#str}
    local needed=$((3 - len))
    while [ $needed -gt 0 ]; do
        str="${FIG_SPACE}${str}"
        needed=$((needed - 1))
    done
    echo "$str"
}

pad_to_four() {
    local str=$1
    local len=${#str}
    local needed=$((4 - len))
    while [ $needed -gt 0 ]; do
        str="${FIG_SPACE}${str}"
        needed=$((needed - 1))
    done
    echo "$str"
}

format_speed() {
    local bytes=$1
    local out=""
    if [ "$bytes" -lt 1024 ]; then
        out=$(pad_to_four "${bytes}")"B"
    elif [ "$bytes" -lt 1048576 ]; then
        out=$(pad_to_four "$((bytes / 1024))")"K"
    elif [ "$bytes" -lt 1073741824 ]; then
        local val=$(awk "BEGIN {printf \"%.1f\", $bytes/1048576}")
        out=$(pad_to_four "$val")"M"
    else
        local val=$(awk "BEGIN {printf \"%.1f\", $bytes/1073741824}")
        out=$(pad_to_four "$val")"G"
    fi
    echo "$out"
}

rx_fmt=$(format_speed $rx_bps)
tx_fmt=$(format_speed $tx_bps)
util_fmt=$(pad_to_three $util)

# Output
echo "  ${cpu}% |   ${mem_used}/${mem_total}GB | 󰓡  ${swp_used}/${swp_total}GB | 󰋊 ${disk_used}/${disk_total} | 󱓞 ${util_fmt}% | 󱘖 ↓$rx_fmt ↑$tx_fmt "
