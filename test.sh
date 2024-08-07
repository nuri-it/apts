#!/bin/bash

# Define the list of programs
programs=(
"flatpak"
"apt-transport-https"
"poppler-utils"
"rsync"
"telegram-desktop"
"cpu-x"
"gparted"
"filezilla"
"greed"
"grub-customizer"
"toilet"
"git"
"nfs-common"
"neofetch"
"gdu"
"net-tools"
"ghostscript"
"imagemagik"
"gimp"
"htop"
"conky"
"thunderbird"
"speedtest-cli"
"bat"
"iftop"
"alacarte"
"nala"
"ranger"
"ncdu"
"remmina"
"bpytop"
"wireshark"
"gnome-console"
"clamav"
"ufw"
"arp-scan"
"nmap"
"firefox-esr"
"chromium"
"tldr"
"tlp"
)

# Create an associative array to hold the selection status
declare -A selection

# Initialize all programs as unselected
for program in "${programs[@]}"; do
  selection[$program]=0
done

# Function to display the program list with checkboxes and numbers
display_list() {
  for i in "${!programs[@]}"; do
    if [ ${selection[${programs[$i]}]} -eq 0 ]; then
      printf " %02d. [ ] %s\n" $((i+1)) "${programs[$i]}"
    else
      printf " %02d. [x] %s\n" $((i+1)) "${programs[$i]}"
    fi
  done
}

# Function to toggle the selection based on number input
toggle_selection() {
  idx=$(( $1 - 1 ))
  if [ ${selection[${programs[$idx]}]} -eq 0 ]; then
    selection[${programs[$idx]}]=1
  else
    selection[${programs[$idx]}]=0
  fi
}

# Main loop
while true; do
  clear
  display_list
  echo "Enter the number of the program to toggle selection and press enter."
  echo "Type 'done' when you are finished."
  
  read -r input
  
  if [ "$input" == "done" ]; then
    break
  elif [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 1 ] && [ "$input" -le ${#programs[@]} ]; then
    toggle_selection "$input"
  else
    echo "Invalid input. Please try again."
    sleep 2
  fi
done

# Prepare the list of programs to install
programs_to_install=""
for program in "${programs[@]}"; do
  if [ ${selection[$program]} -eq 1 ]; then
    programs_to_install+="$program "
  fi
done

# Install selected programs at once
if [ -n "$programs_to_install" ]; then
  echo "Installing selected programs..."
  sudo apt-get install -y $programs_to_install
else
  echo "No programs selected for installation."
fi

echo "Installation complete!"
