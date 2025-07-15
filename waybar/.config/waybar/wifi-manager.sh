#!/bin/bash

# WiFi Manager Script for Waybar using wofi

MENU_CMD="wofi --dmenu --prompt"
notify() {
    if command -v notify-send &> /dev/null; then
        notify-send "WiFi Manager" "$1"
    fi
}

scan_networks() {
    nmcli device wifi rescan 2>/dev/null
    sleep 2
    nmcli -f SSID,SIGNAL,SECURITY device wifi list | \
    awk 'NR>1 && $1!="" {
        ssid = $1
        signal = $2
        security = $3
        if (security == "--") security = "Open"
        printf "%-30s %s%% [%s]\n", ssid, signal, security
    }' | sort -k2 -nr
}

get_current_connection() {
    nmcli -t -f NAME connection show --active | grep -v lo | head -1
}

connect_to_network() {
    local ssid="$1"

    if nmcli connection show | grep -q "^$ssid "; then
        if nmcli connection up "$ssid" 2>/dev/null; then
            notify "Connected to $ssid"
        else
            notify "Failed to connect to $ssid"
        fi
    else
        local security=$(nmcli -f SSID,SECURITY device wifi list | grep "^$ssid " | awk '{print $2}')

        if [[ "$security" == "--" ]]; then
            if nmcli device wifi connect "$ssid" 2>/dev/null; then
                notify "Connected to $ssid (Open network)"
            else
                notify "Failed to connect to $ssid"
            fi
        else
            local password
            password=$(echo "" | $MENU_CMD "Password for $ssid:")

            if [[ -n "$password" ]]; then
                if nmcli device wifi connect "$ssid" password "$password" 2>/dev/null; then
                    notify "Connected to $ssid"
                else
                    notify "Failed to connect to $ssid (Wrong password?)"
                fi
            fi
        fi
    fi
}

disconnect_current() {
    local current=$(get_current_connection)
    if [[ -n "$current" ]]; then
        if nmcli connection down "$current" 2>/dev/null; then
            notify "Disconnected from $current"
        else
            notify "Failed to disconnect"
        fi
    else
        notify "No active connection to disconnect"
    fi
}

forget_network() {
    local connections=$(nmcli -t -f NAME connection show | grep -v lo)

    if [[ -z "$connections" ]]; then
        notify "No saved connections to forget"
        return
    fi

    local selected
    selected=$(echo "$connections" | $MENU_CMD "Forget network:")

    if [[ -n "$selected" ]]; then
        if nmcli connection delete "$selected" 2>/dev/null; then
            notify "Forgot network: $selected"
        else
            notify "Failed to forget network: $selected"
        fi
    fi
}

main_menu() {
    local current=$(get_current_connection)
    local wifi_status="Disconnected"

    if [[ -n "$current" ]]; then
        wifi_status="Connected: $current"
    fi

    local options="🔍 Scan & Connect
📡 Refresh Networks
🔌 Disconnect
🗑️  Forget Network
📊 Show Status
❌ Cancel"

    local choice
    choice=$(echo "$options" | $MENU_CMD "WiFi Manager [$wifi_status]:")

    case "$choice" in
        "🔍 Scan & Connect")
            show_networks_menu
            ;;
        "📡 Refresh Networks")
            notify "Refreshing networks..."
            nmcli device wifi rescan
            show_networks_menu
            ;;
        "🔌 Disconnect")
            disconnect_current
            ;;
        "🗑️  Forget Network")
            forget_network
            ;;
        "📊 Show Status")
            show_status
            ;;
        *)
            exit 0
            ;;
    esac
}

show_networks_menu() {
    notify "Scanning for networks..."
    local networks=$(scan_networks)

    if [[ -z "$networks" ]]; then
        notify "No networks found"
        return
    fi

    networks="⬅️  Back to Main Menu
$networks"

    local selected
    selected=$(echo "$networks" | $MENU_CMD "Select network:")

    if [[ "$selected" == "⬅️  Back to Main Menu" ]]; then
        main_menu
    elif [[ -n "$selected" ]]; then
        local ssid=$(echo "$selected" | awk '{print $1}')
        connect_to_network "$ssid"
    fi
}

show_status() {
    local status="WiFi Status:\n\n"
    status+="Current Connection:\n$(get_current_connection || echo 'None')\n\n"
    status+="WiFi Device Status:\n$(nmcli device status | grep wifi)\n\n"
    status+="Active Connections:\n$(nmcli connection show --active | head -5)"

    echo -e "$status" | $MENU_CMD "Network Status (Press Enter to close):"
}

# Ensure NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
    notify "NetworkManager is not running"
    exit 1
fi

main_menu
