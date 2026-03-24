#!/bin/bash
#
# AutoCCTVPenTest Toolkit - Comprehensive CCTV Security Assessment
# Educational Purpose Only - Use Responsibly
# Author: ATHEX - Cyber Security Researcher
# Version: 2.0
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
TARGET=""
TARGET_FILE=""
OUTPUT_DIR="$(pwd)/cctv_pentest_$(date +%Y%m%d_%H%M%S)"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
THREADS=10
TIMEOUT=10
CCTV_PORTS="80,81,82,83,84,85,86,87,88,89,443,554,8554,8080,8081,8082,8083,8088,8090,8443"
RTSP_PORTS="554,8554,5554,10554"

# =============================================================================
# MISSING FUNCTION DEFINITIONS - ADDED
# =============================================================================

# Check default credentials
check_default_credentials() {
    local host=$1
    local port=$2
    
    # Default credential pairs
    local creds=(
        "admin:admin"
        "admin:1234"
        "admin:12345"
        "admin:123456"
        "admin:password"
        "admin:"
        "root:root"
        "admin:admin123"
    )
    
    for cred in "${creds[@]}"; do
        local user=$(echo "$cred" | cut -d: -f1)
        local pass=$(echo "$cred" | cut -d: -f2)
        local auth=$(echo -n "$cred" | base64)
        
        if curl -s --connect-timeout 5 -H "Authorization: Basic $auth" "http://$host:$port/" 2>/dev/null | grep -qi -E "(dashboard|admin|console|video)"; then
            echo -e "${GREEN}[+] Default credentials found: $user:$pass on $host:$port${NC}"
            echo "$host:$port:$user:$pass" >> "$OUTPUT_DIR/credentials/found_credentials.txt"
            return 0
        fi
    done
    
    return 1
}

# Check directory listings
check_directory_listings() {
    local host=$1
    local port=$2
    
    local paths=(
        "/"
        "/admin"
        "/cgi-bin"
        "/config"
        "/backup"
        "/logs"
    )
    
    for path in "${paths[@]}"; do
        if curl -s --connect-timeout 5 "http://$host:$port$path/" 2>/dev/null | grep -qi "index of"; then
            echo -e "${RED}[!] Directory listing exposed: http://$host:$port$path/${NC}"
            echo "Directory listing: http://$host:$port$path/" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
        fi
    done
}

# Check RTSP access
check_rtsp_access() {
    local host=$1
    
    for rtsp_port in 554 8554 5554; do
        if nc -z -w 2 "$host" "$rtsp_port" 2>/dev/null; then
            echo -e "${YELLOW}[*] RTSP service detected on $host:$rtsp_port${NC}"
            
            # Try common RTSP paths
            local rtsp_paths=(
                "/live"
                "/stream"
                "/video"
                "/axis-media/media.amp"
                "/h264"
                "/mjpeg"
            )
            
            for path in "${rtsp_paths[@]}"; do
                local rtsp_url="rtsp://$host:$rtsp_port$path"
                if timeout 5 ffprobe -loglevel error "$rtsp_url" 2>/dev/null; then
                    echo -e "${GREEN}[+] Accessible RTSP stream: $rtsp_url${NC}"
                    echo "$rtsp_url" >> "$OUTPUT_DIR/streams/accessible_streams.txt"
                fi
            done
        fi
    done
}

# Create RTSP scanner tool
create_rtsp_scanner() {
    cat > "$OUTPUT_DIR/rtsp_scanner.py" << 'EOF'
#!/usr/bin/env python3
import socket
import concurrent.futures
import sys

def check_rtsp(host, port=554):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(3)
        result = sock.connect_ex((host, port))
        sock.close()
        return result == 0
    except:
        return False

def scan_rtsp(hosts):
    with concurrent.futures.ThreadPoolExecutor(max_workers=50) as executor:
        future_to_host = {executor.submit(check_rtsp, host): host for host in hosts}
        for future in concurrent.futures.as_completed(future_to_host):
            host = future_to_host[future]
            try:
                if future.result():
                    print(f"RTSP found on {host}:554")
            except Exception as exc:
                print(f'{host} generated an exception: {exc}')

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 rtsp_scanner.py <target_file>")
        sys.exit(1)
    
    with open(sys.argv[1], 'r') as f:
        hosts = [line.strip() for line in f]
    
    scan_rtsp(hosts)
EOF
    chmod +x "$OUTPUT_DIR/rtsp_scanner.py" 2>/dev/null || true
}

# Banner
print_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║              AutoCCTVPenTest Toolkit v2.0                        ║
║           Automated CCTV Security Assessment                     ║
║                Educational Purpose Only                          ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${YELLOW}[INFO] Output directory: $OUTPUT_DIR${NC}"
    echo ""
}

# Check dependencies - FIXED to handle missing tools gracefully
check_dependencies() {
    echo -e "${YELLOW}[INFO] Checking dependencies...${NC}"
    
    local missing_tools=()
    local tools=("nmap" "curl" "ffmpeg" "python3" "openssl")
    
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            missing_tools+=("$tool")
            echo -e "${RED}[ERROR] $tool is not installed${NC}"
        fi
    done
    
    # Optional tools - warn but don't fail
    local optional_tools=("hydra" "nikto" "whatweb" "dirb" "gobuster")
    for tool in "${optional_tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${YELLOW}[WARN] $tool not installed (some features may be limited)${NC}"
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${YELLOW}[INFO] Install missing tools with: apt install ${missing_tools[*]}${NC}"
        echo -e "${YELLOW}[INFO] Continuing with limited functionality...${NC}"
    fi
    
    # Check Python modules (non-fatal)
    local python_modules=("requests")
    for module in "${python_modules[@]}"; do
        if ! python3 -c "import $module" &> /dev/null; then
            echo -e "${YELLOW}[INFO] Installing Python module: $module${NC}"
            pip3 install $module &> /dev/null || true
        fi
    done
    
    echo -e "${GREEN}[SUCCESS] Dependency check complete${NC}"
    return 0
}

# Setup environment
setup_environment() {
    mkdir -p "$OUTPUT_DIR"/{recon,exploits,credentials,streams,reports}
    echo -e "${GREEN}[SUCCESS] Created output directory: $OUTPUT_DIR${NC}"
    
    # Create wordlists
    create_cctv_wordlists
}

# Create CCTV-specific wordlists
create_cctv_wordlists() {
    echo -e "${YELLOW}[INFO] Creating CCTV-specific wordlists...${NC}"
    
    cat > "$OUTPUT_DIR/cctv_users.txt" << 'EOF'
admin
administrator
root
user
guest
supervisor
operator
service
default
support
tech
cctv
security
demo
test
EOF

    cat > "$OUTPUT_DIR/cctv_passwords.txt" << 'EOF'
admin
1234
12345
123456
password
pass
12345678
888888
111111
admin123
EOF

    cat > "$OUTPUT_DIR/cctv_paths.txt" << 'EOF'
/
/admin
/console
/login
/view
/video
/stream
/cgi-bin
/live
/axis-cgi/mjpg/video.cgi
/cgi-bin/snapshot.cgi
/image.jpg
EOF

    cat > "$OUTPUT_DIR/rtsp_urls.txt" << 'EOF'
/stream1
/stream2
/main
/live
/video
/av0
/av1
/ch0
/ch1
/cam0
/cam1
/h264
/mjpeg
/axis-media/media.amp
EOF

    echo -e "${GREEN}[SUCCESS] Wordlists created${NC}"
}

# Target input
get_target() {
    echo -e "${CYAN}[TARGET SELECTION]${NC}"
    
    if [ -z "$TARGET_FILE" ]; then
        read -p "Enter target IP/range (e.g., 192.168.1.1 or 192.168.1.0/24): " TARGET
        if [ -z "$TARGET" ]; then
            echo -e "${RED}[ERROR] Target is required${NC}"
            exit 1
        fi
    else
        TARGET=$(cat "$TARGET_FILE")
        echo -e "${YELLOW}[INFO] Using targets from file: $TARGET_FILE${NC}"
    fi
}

# Network Discovery
network_discovery() {
    echo -e "${CYAN}[NETWORK DISCOVERY]${NC}"
    echo -e "${YELLOW}[INFO] Scanning for CCTV systems on $TARGET...${NC}"
    
    # Quick port scan for common CCTV ports
    nmap -sS -p $CCTV_PORTS --open -T4 --min-parallelism 100 --min-rate 64 "$TARGET" -oG "$OUTPUT_DIR/recon/port_scan.txt" &> /dev/null
    
    # Extract live hosts
    grep -E "Ports:" "$OUTPUT_DIR/recon/port_scan.txt" | awk '{print $2}' > "$OUTPUT_DIR/recon/live_hosts.txt"
    
    local host_count=$(wc -l < "$OUTPUT_DIR/recon/live_hosts.txt" 2>/dev/null || echo 0)
    echo -e "${GREEN}[SUCCESS] Found $host_count potential CCTV systems${NC}"
    
    if [ $host_count -gt 0 ]; then
        echo -e "${YELLOW}[INFO] Live hosts:${NC}"
        cat "$OUTPUT_DIR/recon/live_hosts.txt"
    fi
}

# Service Fingerprinting
service_fingerprinting() {
    echo -e "${CYAN}[SERVICE FINGERPRINTING]${NC}"
    
    if [ ! -s "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No live hosts found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Fingerprinting CCTV services...${NC}"
    
    while IFS= read -r host; do
        echo -e "${BLUE}[SCANNING] $host${NC}"
        nmap -sV -sC -p $CCTV_PORTS --script=http-title,http-headers,rtsp-methods "$host" -oN "$OUTPUT_DIR/recon/service_scan_$host.txt" &> /dev/null &
    done < "$OUTPUT_DIR/recon/live_hosts.txt"
    
    wait
    parse_service_scan
}

# Parse service scan results
parse_service_scan() {
    echo -e "${YELLOW}[INFO] Parsing scan results...${NC}"
    
    echo -e "${GREEN}══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                   DETECTED CCTV SYSTEMS                         ${NC}"
    echo -e "${GREEN}══════════════════════════════════════════════════════════════════${NC}"
    
    for scan_file in "$OUTPUT_DIR/recon/service_scan_"*.txt; do
        if [ -f "$scan_file" ]; then
            local host=$(basename "$scan_file" | sed 's/service_scan_//' | sed 's/\.txt//')
            local http_title=$(grep -i "http-title" "$scan_file" 2>/dev/null | head -1 | cut -d: -f2- | sed 's/^ *//')
            local services=$(grep -E "^[0-9]+/(tcp|udp)" "$scan_file" 2>/dev/null | awk '{print $1 "/" $2 " " $3 " " $4}' | tr '\n' ', ' | head -c 100)
            
            echo -e "${BLUE}Host: $host${NC}"
            echo -e "Services: $services"
            echo -e "HTTP Title: $http_title"
            echo "────────────────────────────────────────────────────────────────────"
        fi
    done
}

# Web Interface Discovery
web_interface_discovery() {
    echo -e "${CYAN}[WEB INTERFACE DISCOVERY]${NC}"
    
    if [ ! -s "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No live hosts found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Discovering web interfaces...${NC}"
    
    while IFS= read -r host; do
        echo -e "${BLUE}[CHECKING] $host${NC}"
        
        for port in 80 81 443 8080 8443; do
            if timeout 3 curl -s -I "http://$host:$port/" &> /dev/null; then
                echo -e "${GREEN}[FOUND] HTTP service on $host:$port${NC}"
                echo "$host:$port" >> "$OUTPUT_DIR/recon/web_hosts.txt"
            fi
        done
    done < "$OUTPUT_DIR/recon/live_hosts.txt"
}

# Main execution function
main() {
    print_banner
    check_dependencies
    setup_environment
    get_target
    
    echo -e "${CYAN}[STARTING CCTV PENETRATION TEST]${NC}"
    
    # Phase 1: Discovery
    network_discovery
    service_fingerprinting
    web_interface_discovery
    
    # Phase 2: Vulnerability Assessment
    echo -e "${CYAN}[VULNERABILITY ASSESSMENT]${NC}"
    if [ -f "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        while IFS= read -r web_host; do
            host=$(echo "$web_host" | cut -d: -f1)
            port=$(echo "$web_host" | cut -d: -f2)
            check_default_credentials "$host" "$port"
            check_directory_listings "$host" "$port"
            check_rtsp_access "$host"
        done < "$OUTPUT_DIR/recon/web_hosts.txt"
    fi
    
    # Generate Report
    generate_report
    
    echo -e "${GREEN}[COMPLETE] CCTV penetration test finished${NC}"
    echo -e "${YELLOW}[INFO] Results saved to: $OUTPUT_DIR${NC}"
}

# Generate Report
generate_report() {
    echo -e "${CYAN}[GENERATING REPORT]${NC}"
    
    local report_file="$OUTPUT_DIR/reports/cctv_pentest_report_$(date +%Y%m%d_%H%M%S).html"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>CCTV Penetration Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 5px; }
        .section { margin: 20px 0; padding: 15px; border-left: 4px solid #3498db; background: #f8f9fa; }
        .vulnerability { color: #e74c3c; font-weight: bold; }
        .success { color: #27ae60; }
        .credential { background: #fff3cd; padding: 10px; margin: 5px 0; border-radius: 3px; }
        .stream { background: #d1ecf1; padding: 10px; margin: 5px 0; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>CCTV Penetration Test Report</h1>
        <p>Generated: $(date)</p>
        <p>Target: $TARGET</p>
    </div>
    <div class="section">
        <h2>Executive Summary</h2>
        <p>Assessment of CCTV systems for security vulnerabilities.</p>
    </div>
    <div class="section">
        <h2>Discovered Systems</h2>
EOF

    if [ -f "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        while IFS= read -r host; do
            echo "<p>• $host</p>" >> "$report_file"
        done < "$OUTPUT_DIR/recon/live_hosts.txt"
    fi

    cat >> "$report_file" << EOF
    </div>
    <div class="section">
        <h2>Found Credentials</h2>
EOF

    if [ -f "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        while IFS= read -r cred; do
            echo "<div class='credential'>$cred</div>" >> "$report_file"
        done < "$OUTPUT_DIR/credentials/found_credentials.txt"
    fi

    cat >> "$report_file" << EOF
    </div>
    <div class="section">
        <h2>Recommendations</h2>
        <ul>
            <li>Change default credentials immediately</li>
            <li>Update firmware to latest versions</li>
            <li>Disable unnecessary services</li>
            <li>Implement network segmentation</li>
        </ul>
    </div>
</body>
</html>
EOF

    echo -e "${GREEN}[SUCCESS] Report generated: $report_file${NC}"
}

# Parse command line arguments
while getopts "t:f:o:h" opt; do
    case $opt in
        t) TARGET="$OPTARG" ;;
        f) TARGET_FILE="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        h) echo "Usage: $0 [-t target] [-f file] [-o output]"; exit 0 ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done

# Create RTSP scanner tool
create_rtsp_scanner

# Start main function
if [ $# -eq 0 ]; then
    main
else
    if [ -z "$TARGET" ] && [ -z "$TARGET_FILE" ]; then
        echo -e "${RED}[ERROR] Target is required${NC}"
        exit 1
    fi
    main
fi
