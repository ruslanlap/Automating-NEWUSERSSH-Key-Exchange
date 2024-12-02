#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# ANSI color codes and logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging function
log() {
    local level=$1
    shift
    local color=""
    case "$level" in 
        "INFO") color="$GREEN" ;;
        "WARN") color="$YELLOW" ;;
        "ERROR") color="$RED" ;;
    esac
    echo -e "${color}[$(date +'%Y-%m-%d %H:%M:%S')] [$level] $*${NC}"
}

# Spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while ps -p "$pid" > /dev/null; do
        for i in $(seq 0 9); do
            printf "\r[%c] " "${spinstr:$i:1}"
            sleep $delay
        done
    done
    printf "\r   \r"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log "ERROR" "This script must be run as root"
    exit 1
fi

# Check required commands
for cmd in useradd chpasswd openssl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        log "ERROR" "Required command not found: $cmd"
        exit 1
    fi
done

# Welcome banner
cat << "EOF"
╔═══════════════════════════════════════╗
║        User Setup & Configuration     ║
║     Advanced System Administration    ║
╚═══════════════════════════════════════╝
EOF

log "INFO" "Starting user setup..."

# User input with validation
while true; do
    read -p "$(echo -e "${BLUE}👤 Enter login (3-32 chars, lowercase): ${NC}")" login
    if [[ "$login" =~ ^[a-z][a-z0-9-]{2,31}$ ]]; then
        break
    fi
    log "WARN" "Invalid username format"
done

# Simple password input
read -sp "$(echo -e "${BLUE}🔒 Enter password: ${NC}")" password
echo
read -sp "$(echo -e "${BLUE}🔒 Confirm password: ${NC}")" password2
echo

if [[ "$password" != "$password2" ]]; then
    log "ERROR" "Passwords don't match"
    exit 1
fi

# SSH key handling
while true; do
    read -ep "$(echo -e "${BLUE}🔑 Enter path of SSH public key: ${NC}")" ssh_pub_path
    if [[ -f "$ssh_pub_path" ]] && grep -q "ssh-.*" "$ssh_pub_path"; then
        break
    fi
    log "WARN" "Invalid SSH public key file"
done

log "INFO" "Creating user and configuring system..."

homedir="/home/$login"
ssh_dir="$homedir/.ssh"

# Perform setup in background with spinner
{
    # Check if user exists
    if id -u "$login" >/dev/null 2>&1; then
        log "ERROR" "User $login already exists"
        exit 1
    fi

    # Create user with enhanced security
    useradd -m -d "$homedir" \
            -s /bin/bash \
            "$login"

    # Setup SSH
    mkdir -p "$ssh_dir"
    cp "$ssh_pub_path" "$ssh_dir/authorized_keys"
    chmod 700 "$ssh_dir"
    chmod 600 "$ssh_dir/authorized_keys"
    
    # Copy skel with custom configs
    cp -rT /etc/skel "$homedir"
    
    # Set ownership
    chown -R "$login:$login" "$homedir"
    
    # Set password
    echo "$login:$password" | chpasswd

    # Add to necessary groups
    usermod -aG sudo,users "$login"
    
    # Create custom welcome message
    cat > "$homedir/.welcome" << EOF
Welcome $login!
Your account was created on $(date)
For support, contact your system administrator
EOF
} & spinner $!

# Final verification
if id -u "$login" >/dev/null 2>&1; then
    log "INFO" "✅ User setup completed successfully!"
    log "INFO" "📝 Account Details:"
    log "INFO" "Username: $login"
    log "INFO" "Home Directory: $homedir"
    log "INFO" "Groups: $(groups "$login")"
else
    log "ERROR" "User creation failed"
    exit 1
fi
