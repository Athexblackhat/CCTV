#!/bin/bash

# ============================================
# NEO-MATRIX HACKING SIMULATOR & LAUNCHER
# ============================================
# Version: 3.0 | Codename: SYSTEM_INFILTRATOR
# ============================================

# Configuration
MAIN_FILE="main.sh"  # Change this to your main file
ANIMATION_SPEED=0.01
TERMINAL_WIDTH=$(tput cols 2>/dev/null || echo 80)
TERMINAL_HEIGHT=$(tput lines 2>/dev/null || echo 24)
COLORS=("32" "36" "34" "92" "96" "94")  # Green, Cyan, Blue variants
MATRIX_CHARS=("ｱ" "ｲ" "ｳ" "ｴ" "ｵ" "ｶ" "ｷ" "ｸ" "ｹ" "ｺ" "0" "1" "█" "▓" "▒" "░" "╬" "╩" "╦" "╠" "╣" "║" "╗" "╝" "╚" "╔")

# Terminal Control
trap 'tput cnorm; clear; exit' INT TERM
tput civis 2>/dev/null
clear

# ASCII Art Frames for startup
declare -A STARTUP_FRAMES
STARTUP_FRAMES[0]=$(cat << 'EOF'
      ███████╗              ███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗
      ██╔════╝              ██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝
      █████╗      █████╗    ███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ 
      ██╔══╝      ╚════╝    ╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝  
      ██║                   ███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║   
      ╚═╝                   ╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝ 
EOF
)

STARTUP_FRAMES[1]=$(cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   █████╗ ████████╗██╗  ██╗███████╗██╗  ██╗                    ║
    ║  ██╔══██╗╚══██╔══╝██║  ██║██╔════╝╚██╗██╔╝                    ║
    ║  ███████║   ██║   ███████║█████╗   ╚███╔╝                     ║
    ║  ██╔══██║   ██║   ██╔══██║██╔══╝   ██╔██╗                     ║
    ║  ██║  ██║   ██║   ██║  ██║███████╗██╔╝ ██╗                    ║
    ║  ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝                    ║ 
    ║                                                               ║
    ║          [■▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄■]        ║
    ║            INITIALIZING SYSTEM_INFILTRATOR v3.0...            ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
)

# Hacking animation frames
declare -A HACK_FRAMES
HACK_FRAMES[0]=$(cat << 'EOF'
    ████████████████████████████████████████████████████████████████
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █  ACCESSING MAINFRAME... [░░░░░░░░░░░░░░░░░░░░░░░░░░] 23%     █
    █  > DECRYPTING SECURITY LAYERS...                              █
    █  > BYPASSING FIREWALL...                                      █
    █  > ESTABLISHING ENCRYPTED CONNECTION...                       █
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
    ████████████████████████████████████████████████████████████████
EOF
)

HACK_FRAMES[1]=$(cat << 'EOF'
    ████████████████████████████████████████████████████████████████
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █  ACCESSING MAINFRAME... [████████████░░░░░░░░░░░░░░] 47%     █
    █  > SECURITY LAYER 1: DECRYPTED ✓                             █
    █  > FIREWALL BYPASSED ✓                                       █
    █  > CONNECTION ESTABLISHED ✓                                  █
    █  > SCANNING NETWORK TOPOLOGY...                              █
    █  > LOCATING TARGET SYSTEMS...                                █
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
    ████████████████████████████████████████████████████████████████
EOF
)

HACK_FRAMES[2]=$(cat << 'EOF'
    ████████████████████████████████████████████████████████████████
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █  ACCESSING MAINFRAME... [████████████████████████░░] 85%     █
    █  > NETWORK TOPOLOGY MAPPED ✓                                 █
    █  > TARGET SYSTEMS IDENTIFIED ✓                               █
    █  > ADMIN CREDENTIALS CAPTURED ✓                              █
    █  > DATASTREAMS INTERCEPTED ✓                                 █
    █  > INSTALLING ROOTKIT...                                     █
    █  > ESTABLISHING PERSISTENCE...                               █
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█
    ████████████████████████████████████████████████████████████████
EOF
)

HACK_FRAMES[3]=$(cat << 'EOF'
    ████████████████████████████████████████████████████████████████
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █  ACCESS COMPLETE... [██████████████████████████████] 100%    █
    █                                                              █
    █    █████╗ ████████╗██╗  ██╗███████╗██╗  ██╗                  █
    █   ██╔══██╗╚══██╔══╝██║  ██║██╔════╝╚██╗██╔╝                  █
    █   ███████║   ██║   ███████║█████╗   ╚███╔╝                   █
    █   ██╔══██║   ██║   ██╔══██║██╔══╝   ██╔██╗                   █
    █   ██║  ██║   ██║   ██║  ██║███████╗██╔╝ ██╗                  █
    █   ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝                  █
    █                                                              █
    █  SYSTEM COMPROMISED. LAUNCHING PAYLOAD...                    █
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    █▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██
    ████████████████████████████████████████████████████████████████
EOF
)

# Matrix rain characters
matrix_rain() {
    local duration=$1
    local start_time=$(date +%s)
    local end_time=$((start_time + duration))
    
    while [ $(date +%s) -lt $end_time ]; do
        for ((i=1; i<=TERMINAL_WIDTH; i++)); do
            local char="${MATRIX_CHARS[$RANDOM % ${#MATRIX_CHARS[@]}]}"
            local color="\e[38;5;${COLORS[$RANDOM % ${#COLORS[@]}]}m"
            echo -ne "${color}${char}\e[0m"
        done
        echo ""
        sleep 0.05
    done
    clear
}

# Binary stream effect
binary_stream() {
    local duration=$1
    local start_time=$(date +%s)
    local end_time=$((start_time + duration))
    
    while [ $(date +%s) -lt $end_time ]; do
        for ((i=0; i<TERMINAL_WIDTH; i++)); do
            if [ $((RANDOM % 3)) -eq 0 ]; then
                echo -ne "\e[32m$((RANDOM % 2))\e[0m"
            else
                echo -ne " "
            fi
        done
        echo ""
        sleep 0.03
    done
}

# Glitch text effect
glitch_text() {
    local text="$1"
    local iterations=${2:-10}
    
    for ((i=0; i<iterations; i++)); do
        clear
        echo -e "\e[35m"
        echo "$text" | while IFS= read -r line; do
            local glitched=""
            for ((j=0; j<${#line}; j++)); do
                if [ $((RANDOM % 10)) -eq 0 ]; then
                    glitched+="${MATRIX_CHARS[$RANDOM % ${#MATRIX_CHARS[@]}]}"
                else
                    glitched+="${line:$j:1}"
                fi
            done
            echo "$glitched"
        done
        echo -e "\e[0m"
        sleep 0.1
    done
}

# Typing effect with sound simulation
type_effect() {
    local text="$1"
    local color="${2:-32}"
    
    echo -ne "\e[38;5;${color}m"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.03
        # Simulate keypress sound with random beeps
        if [ $((RANDOM % 5)) -eq 0 ]; then
            echo -ne "\a" > /dev/null 2>&1
        fi
    done
    echo -e "\e[0m"
    sleep 0.5
}

# Animated progress bar
progress_bar() {
    local width=50
    local duration=$1
    local step=$((duration * 1000000 / width))
    
    echo -ne "["
    for ((i=0; i<width; i++)); do
        if [ $((i % 4)) -eq 0 ]; then
            echo -ne "\e[32m█\e[0m"
        else
            echo -ne "\e[92m█\e[0m"
        fi
        usleep $step 2>/dev/null || sleep 0.02
    done
    echo -ne "]\n"
}

# Scanlines effect
scanlines() {
    local duration=$1
    local start_time=$(date +%s)
    local end_time=$((start_time + duration))
    
    while [ $(date +%s) -lt $end_time ]; do
        for ((i=0; i<TERMINAL_HEIGHT; i+=2)); do
            tput cup $i 0 2>/dev/null
            echo -ne "\e[30m"
            for ((j=0; j<TERMINAL_WIDTH; j++)); do
                echo -n "▄"
            done
        done
        sleep 0.1
        clear
        sleep 0.05
    done
}

# System takeover sequence
system_takeover() {
    clear
    
    # Phase 1: Initialization
    echo -e "\e[36m"
    for frame in 0 1; do
        clear
        echo -e "${STARTUP_FRAMES[$frame]}"
        sleep 0.8
    done
    
    sleep 1
    clear
    
    # Phase 2: Matrix rain intro
    echo -e "\e[32mINITIATING MATRIX PROTOCOL...\e[0m"
    sleep 1
    matrix_rain 2
    
    # Phase 3: Hacking sequence
    echo -e "\e[31m"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║                    SYSTEM_INFILTRATOR v3.0                    ║
    ║                   [TARGET ACQUISITION MODE]                   ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "\e[0m"
    sleep 1
    
    # Phase 4: Binary stream
    binary_stream 2
    clear
    
    # Phase 5: Animated hacking frames
    for frame in 0 1 2 3; do
        clear
        echo -e "\e[36m"
        echo "${HACK_FRAMES[$frame]}"
        echo -e "\e[0m"
        
        # Add dynamic effects
        if [ $frame -eq 0 ]; then
            echo -e "\e[33m> SCANNING VULNERABILITIES...\e[0m"
            progress_bar 1
        elif [ $frame -eq 1 ]; then
            echo -e "\e[33m> EXPLOITING WEAKNESSES...\e[0m"
            progress_bar 1
        elif [ $frame -eq 2 ]; then
            echo -e "\e[33m> ELEVATING PRIVILEGES...\e[0m"
            progress_bar 1
        fi
        
        sleep 2
    done
    
    # Phase 6: Scanlines glitch
    scanlines 1
    clear
    
    # Phase 7: Final takeover
    glitch_text "SYSTEM COMPROMISED" 15
    
    clear
    echo -e "\e[31m"
    cat << "EOF"
    ██████████████████████████████████████████████████████████████████████████████████████
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  █
    █        ███████╗              ███████╗ ██████╗  ██████╗██╗███████╗████████╗██╗   ██╗█
    █        ██╔════╝              ██╔════╝██╔═══██╗██╔════╝██║██╔════╝╚══██╔══╝╚██╗ ██╔╝█
    █        █████╗      █████╗    ███████╗██║   ██║██║     ██║█████╗     ██║    ╚████╔╝ █
    █        ██╔══╝      ╚════╝    ╚════██║██║   ██║██║     ██║██╔══╝     ██║     ╚██╔╝  █
    █        ██║                   ███████║╚██████╔╝╚██████╗██║███████╗   ██║      ██║   █
    █        ╚═╝                   ╚══════╝ ╚═════╝  ╚═════╝╚═╝╚══════╝   ╚═╝      ╚═╝   █
    █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
    ██████████████████████████████████████████████████████████████████████████████████████
EOF
    echo -e "\e[0m"
    
    # Blinking effect
    for ((i=0; i<5; i++)); do
        echo -ne "\e[31m█ SYSTEM TAKEOVER COMPLETE █\e[0m"
        sleep 0.3
        echo -ne "\r\e[32m█ SYSTEM TAKEOVER COMPLETE █\e[0m"
        sleep 0.3
        echo -ne "\r\e[34m█ SYSTEM TAKEOVER COMPLETE █\e[0m"
        sleep 0.3
    done
    
    echo -e "\n"
    sleep 1
}

# Find and run main file
launch_main_file() {
    echo -e "\e[36m"
    type_effect "SEARCHING FOR FILE: $MAIN_FILE"
    echo -e "\e[0m"
    
    # Search for main file
    local found_files=()
    while IFS= read -r file; do
        [ -f "$file" ] && found_files+=("$file")
    done < <(find . -name "$MAIN_FILE" -type f 2>/dev/null)
    
    if [ ${#found_files[@]} -eq 0 ]; then
        echo -e "\e[31m[ERROR] Payload '$MAIN_FILE' not found!\e[0m"
        echo -e "\e[33mSearching for alternative executables...\e[0m"
        
        # Look for any executable
        found_files=()
        while IFS= read -r file; do
            [ -f "$file" ] && found_files+=("$file")
        done < <(find . -type f -executable ! -name "*.so" ! -name "*.dll" 2>/dev/null | head -5)
        
        if [ ${#found_files[@]} -eq 0 ]; then
            echo -e "\e[31mNo executable files found. Mission aborted.\e[0m"
            return 1
        fi
        
        MAIN_FILE=$(basename "${found_files[0]}")
        echo -e "\e[32mFound alternative: $MAIN_FILE\e[0m"
    fi
    
    # Select file if multiple found
    local target_file
    if [ ${#found_files[@]} -gt 1 ]; then
        echo -e "\e[36mMultiple payloads detected:\e[0m"
        for i in "${!found_files[@]}"; do
            echo -e "  [$((i+1))] ${found_files[$i]}"
        done
        echo -ne "\e[33mSelect payload (1-${#found_files[@]}): \e[0m"
        read -r choice
        target_file="${found_files[$((choice-1))]}"
    else
        target_file="${found_files[0]}"
    fi
    
    # Launch sequence
    echo -e "\n\e[35m"
    cat << "EOF"
         █████╗ ████████╗██╗  ██╗███████╗██╗  ██╗                 
        ██╔══██╗╚══██╔══╝██║  ██║██╔════╝╚██╗██╔╝                  
        ███████║   ██║   ███████║█████╗   ╚███╔╝                  
        ██╔══██║   ██║   ██╔══██║██╔══╝   ██╔██╗                   
        ██║  ██║   ██║   ██║  ██║███████╗██╔╝ ██╗                  
        ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ 
EOF
    echo -e "\e[0m"
    
    for i in {5..1}; do
        echo -ne "\e[31mLAUNCH IN $i...\e[0m\r"
        sleep 1
    done
    
    echo -e "\e[32mEXECUTING PAYLOAD: $target_file\e[0m"
    echo -e "\e[90m"  # Gray color for output
    
    # Make executable if needed
    [ ! -x "$target_file" ] && chmod +x "$target_file" 2>/dev/null
    
    # Run the file
    if [[ "$target_file" == *.sh ]]; then
        bash "$target_file"
    elif [[ "$target_file" == *.py ]]; then
        python3 "$target_file"
    elif [[ "$target_file" == *.js ]]; then
        node "$target_file" 2>/dev/null || echo "Node.js not found or file execution failed"
    else
        "./$target_file"
    fi
    
    local exit_code=$?
    echo -e "\e[0m"
    
    if [ $exit_code -eq 0 ]; then
        echo -e "\e[32m✓ PAYLOAD EXECUTION SUCCESSFUL\e[0m"
    else
        echo -e "\e[31m✗ PAYLOAD EXECUTION FAILED (Exit code: $exit_code)\e[0m"
    fi
    
    return $exit_code
}

# Countdown timer
countdown() {
    echo -e "\e[36m"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║               SYSTEM_INFILTRATOR - INITIALIZING               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "\e[0m"
    
    for i in {3..1}; do
        echo -ne "\e[31mSTARTING IN $i...\e[0m\r"
        sleep 1
    done
    echo -e "\e[32mENGAGING SYSTEMS...\e[0m"
    sleep 1
}

# Main execution
main() {
    # Check terminal size
    if [ "$TERMINAL_WIDTH" -lt 80 ] || [ "$TERMINAL_HEIGHT" -lt 24 ]; then
        echo "Terminal too small! Please resize to at least 80x24"
        tput cnorm 2>/dev/null
        exit 1
    fi
    
    # Initial countdown
    countdown
    
    # Run system takeover animation
    system_takeover
    
    # Launch main file
    launch_main_file
    
    # Exit sequence
    echo -e "\n\e[36m"
    type_effect "MISSION COMPLETE. TERMINATING SYSTEM_INFILTRATOR..."
    echo -e "\e[0m"
    
    # Final matrix effect
    matrix_rain 1
    
    echo -e "\e[32m[+] Operation completed at $(date)\e[0m"
    
    # Restore terminal
    tput cnorm 2>/dev/null
}

# Run with or without arguments
if [ "$1" = "--skip" ]; then
    echo "Skipping animation, launching directly..."
    launch_main_file
elif [ "$1" = "--help" ]; then
    echo "SYSTEM_INFILTRATOR v3.0 - Hacking Simulation & Launcher"
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  --skip     Skip animation and launch directly"
    echo "  --help     Show this help"
    echo "  --test     Test animation only"
    echo ""
    echo "Configuration:"
    echo "  Edit MAIN_FILE variable to change target executable"
    echo "  Adjust ANIMATION_SPEED for faster/slower animation"
elif [ "$1" = "--test" ]; then
    echo "Testing animation sequence..."
    system_takeover
else
    main
fi

# Restore terminal on exit
tput cnorm 2>/dev/null
clear