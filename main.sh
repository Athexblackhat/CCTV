#!/bin/bash

F="scripts"  # Scripts folder
[ ! -d "$F" ] && mkdir -p "$F"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[38;5;208m'
MAGENTA='\033[38;5;165m'
LIME='\033[38;5;118m'
PINK='\033[38;5;200m'
NC='\033[0m'

# Function to display banner properly
display_banner() {
    clear
    # Get terminal width
    local term_width
    term_width=$(tput cols 2>/dev/null || echo 80)
    
    # Calculate padding for centering
    local padding=$(( (term_width - 78) / 2 ))
    [ $padding -lt 0 ] && padding=0
    
    # Create padding string
    local pad_str=""
    for ((i=0; i<padding; i++)); do
        pad_str="${pad_str} "
    done
    
    # Check if terminal is wide enough for the full banner
    if [ "$term_width" -lt 60 ]; then
        # Ultra-small terminal - minimal banner
        echo -e "${pad_str}${RED}╔════════════════════════════════════════════════╗${NC}"
        echo -e "${pad_str}${GREEN}║      SECURITY & PENETRATION TOOLKIT          ║${NC}"
        echo -e "${pad_str}${BLUE}║               CCTV EDITION                    ║${NC}"
        echo -e "${pad_str}${RED}╚════════════════════════════════════════════════╝${NC}"
    elif [ "$term_width" -lt 78 ]; then
        # Medium terminal - compact banner
        echo -e "${pad_str}${CYAN}███████╗              ███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗${NC}"
        echo -e "${pad_str}${GREEN}██╔════╝              ██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝${NC}"
        echo -e "${pad_str}${BLUE}█████╗      █████╗    ███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ ${NC}"
        echo -e "${pad_str}${PURPLE}██╔══╝      ╚════╝    ╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝  ${NC}"
        echo -e "${pad_str}${RED}██║                   ███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║   ${NC}"
        echo -e "${pad_str}${YELLOW}╚═╝                   ╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝   ${NC}"
        echo -e "${pad_str}${ORANGE}            CCTV HACKING & JAMMING TOOLKIT v3.0           ${NC}"
    else
        # Large terminal - full banner with your ASCII art
        echo -e "${pad_str}${RED}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${pad_str}${CYAN}║  ███████╗              ███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗  ║${NC}"
        echo -e "${pad_str}${GREEN}║  ██╔════╝              ██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝  ║${NC}"
        echo -e "${pad_str}${BLUE}║  █████╗      █████╗    ███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝   ║${NC}"
        echo -e "${pad_str}${PURPLE}║  ██╔══╝      ╚════╝    ╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝    ║${NC}"
        echo -e "${pad_str}${RED}║  ██║                   ███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║    ║${NC}"
        echo -e "${pad_str}${YELLOW}║  ╚═╝                   ╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝    ║${NC}"
        echo -e "${pad_str}${MAGENTA}╠══════════════════════════════════════════════════════════════════════════╣${NC}"
        echo -e "${pad_str}${ORANGE}║  🚀 ADVANCED SECURITY PENETRATION TOOLKIT • CCTV EDITION v3.0 🚀         ║${NC}"
        echo -e "${pad_str}${LIME}║               CREATED BY: ATHEX BL4CK H4T & MARUF ZERO TRACE                     ║${NC}"
        echo -e "${pad_str}${RED}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${pad_str}${YELLOW}════════════════════════════════════════════════════════════════════════════${NC}"
        echo -e "${pad_str}${GREEN}⚠️   FOR EDUCATIONAL & AUTHORIZED SECURITY TESTING ONLY   ⚠️${NC}"
        echo -e "${pad_str}${YELLOW}════════════════════════════════════════════════════════════════════════════${NC}"
    fi
    echo ""
}

# Function to check if script exists and is executable
check_and_run() {
    local script="$1"
    local executor="${2:-bash}"
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}Error: File not found: $script${NC}"
        echo -e "${YELLOW}Please make sure the script exists in the '$F' folder${NC}"
        read -rp "$(echo -e "${GREEN}"'Press Enter to continue...'"${NC}")"
        return 1
    fi
    
    if [ ! -x "$script" ] && [ "$executor" = "bash" ]; then
        chmod +x "$script" 2>/dev/null
    fi
    
    echo -e "${CYAN}Running $script...${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════${NC}"
    
    if [ "$executor" = "bash" ]; then
        bash "$script"
    elif [ "$executor" = "python3" ]; then
        python3 "$script"
    fi
    
    local exit_code=$?
    echo -e "${YELLOW}════════════════════════════════════════════════${NC}"
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Script completed successfully${NC}"
    else
        echo -e "${RED}✗ Script exited with code: $exit_code${NC}"
    fi
    
    return $exit_code
}

# Function to create sample scripts if they don't exist
create_sample_scripts() {
    # Create old-version.sh if it doesn't exist
    if [ ! -f "$F/old-version.sh" ]; then
        cat > "$F/old-version.sh" << 'EOF'
#!/bin/bash
echo -e "\033[38;5;208m╔══════════════════════════════════════════════════╗\033[0m"
echo -e "\033[38;5;118m║         LEGACY CCTV PENETRATION TOOL            ║\033[0m"
echo -e "\033[38;5;208m╚══════════════════════════════════════════════════╝\033[0m"
echo ""
echo "This is the old version script"
echo "Place your old CCTV hacking script here"
echo "Current directory: $(pwd)"
echo "Press Enter to return to main menu..."
read
EOF
        chmod +x "$F/old-version.sh"
    fi
    
    # Create updated.sh if it doesn't exist
    if [ ! -f "$F/updated.sh" ]; then
        cat > "$F/updated.sh" << 'EOF'
#!/bin/bash
echo -e "\033[38;5;51m╔══════════════════════════════════════════════════╗\033[0m"
echo -e "\033[38;5;51m║         ADVANCED CCTV PENETRATION TOOL          ║\033[0m"
echo -e "\033[38;5;51m╚══════════════════════════════════════════════════╝\033[0m"
echo ""
echo "This is the updated version script"
echo "Place your updated CCTV hacking script here"
echo "Current time: $(date)"
echo "Press Enter to return to main menu..."
read
EOF
        chmod +x "$F/updated.sh"
    fi
    
    # Create run.py if it doesn't exist
    if [ ! -f "$F/run.py" ]; then
        cat > "$F/run.py" << 'EOF'
#!/usr/bin/env python3
import sys
print("\033[38;5;200m╔══════════════════════════════════════════════════╗\033[0m")
print("\033[38;5;200m║         PYTHON CCTV PENETRATION TOOL            ║\033[0m")
print("\033[38;5;200m╚══════════════════════════════════════════════════╝\033[0m")
print()
print("Python Version - CCTV Camera Toolkit")
print("=" * 40)
print("This is the Python version of the CCTV hacking tool")
print("Place your Python CCTV hacking script here")
print(f"Python version: {sys.version}")
input("Press Enter to return to main menu...")
EOF
    fi
    
    # Create CCTV-jammer.py if it doesn't exist
    if [ ! -f "$F/CCTV-jammer.py" ]; then
        cat > "$F/CCTV-jammer.py" << 'EOF'
#!/usr/bin/env python3
print("\033[38;5;196m╔══════════════════════════════════════════════════╗\033[0m")
print("\033[38;5;196m║           CCTV JAMMER TOOL v2.0                 ║\033[0m")
print("\033[38;5;196m╚══════════════════════════════════════════════════╝\033[0m")
print()
print("CCTV JAMMER Tool")
print("=" * 40)
print("This is the CCTV jamming tool")
print("Place your CCTV jamming Python script here")
print("\033[38;5;208m⚠️  WARNING: FOR AUTHORIZED SECURITY TESTING ONLY! ⚠️\033[0m")
input("Press Enter to return to main menu...")
EOF
    fi
}

# Create sample scripts if folder is empty or scripts don't exist
create_sample_scripts

# Main loop
while true; do
    display_banner
    echo -e "${BLUE}📁 Scripts Folder:${NC} ${GREEN}$(pwd)/$F${NC}"
    echo -e "${YELLOW}📋 Available Scripts:${NC}"
    
    # List available scripts
    shopt -s nullglob
    scripts=("$F"/*.sh "$F"/*.py)
    shopt -u nullglob
    
    if [ ${#scripts[@]} -eq 0 ]; then
        echo -e "${RED}⚠️  No scripts found in $F folder!${NC}"
        echo -e "${YELLOW}✨ Created sample scripts for you.${NC}"
    else
        echo -e "${CYAN}🔍 Found ${#scripts[@]} script(s)${NC}"
    fi
    echo
    
    echo -e "${CYAN}[1]${NC} ${ORANGE}▶ LEGACY VERSION${NC} ${GREEN}($F/old-version.sh)${NC}"
    echo -e "${CYAN}[2]${NC} ${GREEN}▶ ADVANCED VERSION${NC} ${GREEN}($F/updated.sh)${NC}"
    echo -e "${CYAN}[3]${NC} ${BLUE}▶ PYTHON VERSION${NC} ${GREEN}($F/run.py)${NC}"
    echo -e "${CYAN}[4]${NC} ${RED}▶ JAMMER TOOL${NC} ${GREEN}($F/CCTV-jammer.py)${NC}"
    echo -e "${RED}[0]${NC} 🚪 Exit Program"
    echo
    
    read -rp "$(echo -e "${YELLOW}"'🎯 Choice: '"${NC}")" c
    
    case $c in
        1) check_and_run "$F/old-version.sh" "bash" ;;
        2) check_and_run "$F/updated.sh" "bash" ;;
        3) check_and_run "$F/run.py" "python3" ;;
        4) check_and_run "$F/CCTV-jammer.py" "python3" ;;
        0) 
            echo -e "${RED}🚪 Exiting...${NC}"
            echo -e "${GREEN}🙏 Thank you for using Security Toolkit!${NC}"
            echo -e "${YELLOW}✨ Stay secure and ethical! ✨${NC}"
            exit 0 
            ;;
        *) 
            echo -e "${RED}❌ Invalid choice! Please enter 0-4${NC}"
            sleep 1 
            ;;
    esac
    
    echo
    echo -e "${GREEN}📌 Press Enter to return to main menu...${NC}"
    read -r
done