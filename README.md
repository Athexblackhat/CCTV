
# Install required dependencies
pip install scapy requests

# Basic scan
python run.py -t 192.168.1.100

# Network scan with exploitation
python run.py -n 192.168.1.0/24 --exploit --crack-passwords

# RTSP scanning
python run.py -t 192.168.1.100 --rtsp-scan

# Generate wordlist
python run.py --generate-wordlist custom_wordlist.txt
