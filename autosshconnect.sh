#!/bin/bash 
 
set -e 
 


# ANSI color codes and emoji for readability
GREEN=$(tput setaf 2)   # 🟢
YELLOW=$(tput setaf 3)  # 🟡
RESET=$(tput sgr0)      # 🔄

# Function to display loading animation
function loading_animation() {
    local pid=$!
    local delay=0.15
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    while ps -p $pid >/dev/null; do
        local temp=${spin#?}
        printf " [%c] " "$spin"
        local spin=$temp${spin%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done

    printf "    \b\b\b\b"
}

echo -n "${GREEN} 🟢 Starting user setup...${RESET}"
sleep 1
echo -ne "\r${GREEN} ✅ Starting user setup...${RESET}"
sleep 1
echo -ne "\r${GREEN} 🟢 Starting user setup...${RESET}"
sleep 1
echo -e "\r${GREEN} ✅ Starting user setup...${RESET}":




printf "${GREEN}🌟 Starting user setup...${RESET}\n" 
 
read -p "${YELLOW}🔑 Enter login: ${RESET}" login 
read -sp "${YELLOW}🔒 Enter password: ${RESET}" password 
echo 
read -ep "${YELLOW}🔑 Enter path of SSH public key: ${RESET}" ssh_pub_path 
 
# Check if the provided SSH public key file exists 
if [ ! -f "$ssh_pub_path" ]; then 
    printf "${YELLOW}⚠️  SSH public key file does not exist. Please check the path and try again.${RESET}\n" 
    exit 1 
fi 
 
printf "${GREEN}🚀 Creating user directories and setting up SSH...${RESET}\n" 
 
homedir="/home/$login" 
ssh_dir="$homedir/.ssh" 
 
# Check if the user already exists 
if id -u "$login" >/dev/null 2>&1; then 
    printf "${YELLOW}⚠️  User $login already exists. Please choose a different username.${RESET}\n" 
    exit 1 
fi 
 
sudo mkdir -p "$ssh_dir" 
sudo cp "$ssh_pub_path" "$ssh_dir/authorized_keys" 
sudo cp -rT /etc/skel "$homedir" 
sudo useradd -d "$homedir" -s /bin/bash "$login" 
sudo chown -R "$login:$login" "$homedir" 
echo "$login:$password" | sudo chpasswd 
 
printf "${GREEN}✅ User setup completed successfully!${RESET}\n" 
 
# Check if user is successfully added 
if id -u "$login" >/dev/null 2>&1; then 
    printf "${GREEN}🎉 Enjoy your new user account, $login!${RESET}\n" 
else 
    printf "${YELLOW}⚠️  User creation failed. Please check the provided details and try again.${RESET}\n" 
fi
