#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: bash $0 <ip_range> <num_threads>"
    echo "Example: bash $0 192.168.1.1-192.168.1.254 10"
    exit 1
fi

ip_range="$1"
num_threads="$2"

# Function to perform a ping scan for a range of IP addresses
ping_scan() {
    local start_ip="$1"
    local end_ip="$2"
    for ((i = $(echo "$start_ip" | cut -d '.' -f 4); i <= $(echo "$end_ip" | cut -d '.' -f 4); i++)); do
        current_ip=$(echo "$start_ip" | cut -d '.' -f 1-3).$i
        if ping -c 1 -W 1 "$current_ip" >/dev/null; then
            echo "Host $current_ip is alive"
            echo "$current_ip" >> output.txt
        else
            echo "Host $current_ip is not alive"
        fi
    done
}

# Extract the start and end IP addresses from the range
start_ip=$(echo "$ip_range" | cut -d '-' -f 1)
end_ip=$(echo "$ip_range" | cut -d '-' -f 2)

# Calculate the number of IPs to scan per thread
ip_range_size=$(( ($(echo "$end_ip" | cut -d '.' -f 4) - $(echo "$start_ip" | cut -d '.' -f 4) + 1) / num_threads ))

# Launch multiple threads for scanning
for ((i = 0; i < num_threads; i++)); do
    start_range=$((i * ip_range_size + $(echo "$start_ip" | cut -d '.' -f 4)))
    end_range=$(((i + 1) * ip_range_size + $(echo "$start_ip" | cut -d '.' -f 4) - 1))
    start_ip_thread=$(echo "$start_ip" | cut -d '.' -f 1-3)
    end_ip_thread=$(echo "$start_ip" | cut -d '.' -f 1-3)

    ping_scan "$start_ip_thread.$start_range" "$end_ip_thread.$end_range" &
done

# Wait for all background threads to finish
wait
