#!/bin/bash

# Control to show or hide the IP (disabled by default)
SHOW_IP=false

# Control to show or hide the date and time (disabled by default)
SHOW_TIME=false

# Default interface to get the IP address (tun0 by default)
INTERFACE="tun0"

# Variable to store a manually set IP, if needed
MANUAL_IP=""

# Track whether public IP is being used
CHECK_PUBLIC_IP=false

# Variable to store the last time the public IP was checked
LAST_PUBLIC_IP_CHECK=0
PUBLIC_IP_CHECK_INTERVAL=900  # 15 minutes (900 seconds)

local user_name="%{$fg[white]%}%n"
local dir_prefix="%{$fg[red]%}["
local dir_string="%{$fg[white]%}%~"
local dir_postfix="%{$fg[red]%}] "
local cmd_symbol_success="%{$fg[white]%}❯ "  # Default prompt symbol in white
local cmd_symbol_fail="%{$fg[red]%}❯ "      # Prompt symbol in red for errors
local cmd_symbol_root="%{$fg[red]#%} "      # Symbol for root always red
local new_line=""  # Always use a single line prompt by default
local check_interval=10  # Check the interface every 10 seconds

# Function to get the IP address from the specified interface or the main one
get_ip_address() {
    if [ -n "$MANUAL_IP" ]; then
        echo "$MANUAL_IP"
    else
        local ip=$(ip -o -4 addr list "$INTERFACE" 2>/dev/null | awk '{print $4}' | cut -d/ -f1)
        if [ -z "$ip" ]; then
            ip=$(ip -o -4 addr list | grep -v '127.0.0.1' | awk '{print $4}' | cut -d/ -f1 | head -n 1)
        fi
        echo $ip
    fi
}

# Global variable that stores the IP in the prompt (always in magenta)
IP_PROMPT=""

# Function to update the IP in the prompt if it changes
update_ip_in_prompt() {
    if [ "$SHOW_IP" = true ]; then
        local new_ip=$(get_ip_address)
        # Keep IP always in magenta
        IP_PROMPT="%{$fg[magenta]%}$new_ip%{$reset_color%}"
    else
        IP_PROMPT=""
    fi
}

# Initial update of IP_PROMPT
update_ip_in_prompt

# Function to update the public IP if it's been 15 minutes
update_public_ip_if_needed() {
    if [ "$SHOW_IP" = true ] && [ "$CHECK_PUBLIC_IP" = true ]; then
        local current_time=$(date +%s)
        local time_elapsed=$((current_time - LAST_PUBLIC_IP_CHECK))

        if [ $time_elapsed -ge $PUBLIC_IP_CHECK_INTERVAL ]; then
            # Update the public IP
            MANUAL_IP=$(curl -s https://ifconfig.me)
            LAST_PUBLIC_IP_CHECK=$current_time
            update_ip_in_prompt
        fi
    fi
}

# Check the specified interface every certain interval of time
autoload -Uz add-zsh-hook
add-zsh-hook precmd () {
    if [[ $SECONDS -gt $check_interval ]]; then
        SECONDS=0
        update_ip_in_prompt
        update_public_ip_if_needed  # Check and update public IP if needed
    fi
}

# Function to get the date and time in the desired format
get_datetime() {
    if [ "$SHOW_TIME" = true ]; then
        echo "%{$fg[cyan]%}$(date +'%d/%m/%y %H:%M')%{$reset_color%}"
    else
        echo ""
    fi
}

# If the user is root, use the red root symbol
if [ "$USER" = "root" ]; then
    cmd_symbol="$cmd_symbol_root"
else
    # Check the exit status of the previous command and set the appropriate symbol
    cmd_symbol="%(?.$cmd_symbol_success.$cmd_symbol_fail)"
fi

# Unified function to set either a specific IP, obtain the IP from an interface, or get the public IP
setip() {
    if [[ -n "$1" ]]; then
        if [[ "$1" == "public" ]]; then
            # Get the public IP using an external service
            MANUAL_IP=$(curl -s https://ifconfig.me)
            INTERFACE=""  # Clear any interface selection
            CHECK_PUBLIC_IP=true  # Enable public IP check
            LAST_PUBLIC_IP_CHECK=$(date +%s)  # Initialize the time of the last public IP check
        elif [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            MANUAL_IP="$1"  # If it matches an IP format, set it as the manual IP
            INTERFACE=""  # Clear any interface selection
            CHECK_PUBLIC_IP=false  # Disable public IP check
        else
            INTERFACE="$1"  # Otherwise, assume it's an interface name
            MANUAL_IP=""  # Clear any manually set IP
            CHECK_PUBLIC_IP=false  # Disable public IP check
        fi
        update_ip_in_prompt
    else
        echo "Usage: setip <ip_address|interface_name|public>"
    fi
}

# Git prompt settings (if needed)
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}(%{$reset_color%}%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Command to disable the IP in the prompt
disableip() {
    SHOW_IP=false
    CHECK_PUBLIC_IP=false    # Stop checking the public IP
    MANUAL_IP=""             # Clear any manually set IP
    INTERFACE="tun0"         # Reset to default interface if desired
    update_ip_in_prompt
}

# Command to enable the IP in the prompt
enableip() {
    SHOW_IP=true
    update_ip_in_prompt
}

# Command to disable the date and time in the prompt
disabledate() {
    SHOW_TIME=false
}

# Command to enable the date and time in the prompt
enabledate() {
    SHOW_TIME=true
}

# Function to construct the prompt
construct_prompt() {
    local prompt=""
    local datetime="$(get_datetime)"
    local ip="$IP_PROMPT"
    local hyphen=""
    local separator=""

    if [ -n "$datetime" ] && [ -n "$ip" ]; then
        hyphen="%{$fg[white]%} - %{$reset_color%}"
    fi

    # Include a space if datetime, hyphen, or ip is non-empty
    if [ -n "${datetime}${hyphen}${ip}" ]; then
        separator=" "
    fi

    prompt="${datetime}${hyphen}${ip}${separator}${dir_prefix}${dir_string}${dir_postfix}${cmd_symbol}%{$reset_color%}"

    echo "$prompt"
}

# Final prompt string
PROMPT='$(construct_prompt)'

# Set up initial values
update_ip_in_prompt
