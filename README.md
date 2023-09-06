# Live-Host-Finder
This is a simple tool to find live hosts that are up on a given network range. It uses `ping` to scan then network.
## Installation
```bash
git clone https://github.com/AadithyanRaju/Live-Host-Finder.git
```
## How To Use
First open a terminal and go to the path, where the script is located. Then,
```bash
bash LiveHost.sh <ip range> <threads>
```
Example, Running with 10 threads.
```bash
bash LiveHost.sh 192.168.1.1-192.168.1.255 10
```
