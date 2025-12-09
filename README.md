
# Install required dependencies
pip install scapy requests

# Basic scan
python cctv_scanner.py -t 192.168.1.100

# Network scan with exploitation
python cctv_scanner.py -n 192.168.1.0/24 --exploit --crack-passwords

# RTSP scanning
python cctv_scanner.py -t 192.168.1.100 --rtsp-scan

# Generate wordlist
python cctv_scanner.py --generate-wordlist custom_wordlist.txt