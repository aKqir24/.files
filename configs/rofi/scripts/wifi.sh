#!/bin/bash

#############################
# Configuration
#############################

TPATH="$HOME/.cache/connman_rofi_menu_files"
mkdir -p "$TPATH"

RAW_NETWORK_FILE="$TPATH/connman_rofi_menu_ssid_raw.txt"
TEMP_PASSWORD_FILE="$TPATH/connman_rofi_menu_temp_ssid_password.txt"

PASS_WIN_THEME="$HOME/.config/rofi/styles/wifi_password.rasi"
ROFI_DEFAULT_MODE="rofi -dmenu -mouse -i -theme $THEME_FILE"

REFRESH_OPT="󱛄  Refresh"
ENABLE_OPT="󰤨  Enable Wi-Fi"
DISABLE_OPT="󰤮  Disable Wi-Fi"
wifi=()
ssid=()
service_paths=()

#############################
# Utilities
#############################

clean_up() { [ -e "$TPATH" ] && rm -r "$TPATH"; }
notify() { dunstctl close-all; notify-send "$1" "$2"; }

check_status() {
    local wifi_powered=$(connmanctl technologies | awk '/Type = wifi/{flag=1} flag && /Powered/{print $3; exit}')
    local state=$(connmanctl state | awk '{print $3}')
    
    if [[ "$wifi_powered" == "True" ]]; then
        local iface="ON"
        if [[ "$state" == "online" || "$state" == "ready" ]]; then
            local wifi_status="ON"
        else
            local wifi_status="OFF"
        fi
    else
        local iface="OFF"
        local wifi_status=""
    fi
    echo "$iface $wifi_status"
}

check_state() {
    local state=$(connmanctl state | awk '{print $3}')
    if [[ "$state" == "online" || "$state" == "ready" ]]; then
        echo "connected"
    else
        echo "disconnected"
    fi
}

connect_with_password() {
    local service="$1"
    local password=""
    if command -v zenity &> /dev/null; then
        password=$(zenity --password --title="Wi-Fi Password" 2>/dev/null)
    elif command -v kdialog &> /dev/null; then
        password=$(kdialog --password "Enter Wi-Fi Password" 2>/dev/null)
    else
        rofi -dmenu -password -p "Password:" -theme "$PASS_WIN_THEME" > "$TEMP_PASSWORD_FILE"
        password="$(<"$TEMP_PASSWORD_FILE")"
    fi

    if [[ -n "$password" ]]; then
        connmanctl config "$service" --set-property Passphrase "$password"
        connection_output=$(timeout 5 connmanctl connect "$service" 2>&1)
    fi
}

notify_connection() {
    if [[ $(check_state) == "connected" ]]; then
        notify "Connection Successful" "Connected successfully."
    else
        notify "Connection Failed" "Something went wrong."
    fi
}

#############################
# Network Functions
#############################

get_networks() {
    ssid=() wifi=() service_paths=()
    connmanctl services > "$RAW_NETWORK_FILE"

    while read -r line; do
        if [[ "$line" =~ wifi_ ]]; then
            local s_path=$(echo "$line" | awk '{print $NF}')
            
            local security="OPEN"
            if [[ "$s_path" == *_psk* ]]; then
                security="WPA/WPA2"
            elif [[ "$s_path" == *_ieee8021x* ]]; then
                security="Enterprise"
            fi

            local net_name=$(connmanctl services "$s_path" | awk -F'=' '/^[ \t]*Name[ \t]*=/{print $2; exit}' | xargs)
            [[ -z "$net_name" ]] && net_name="$s_path"

            local s_details=$(connmanctl services "$s_path")
            local state=$(echo "$s_details" | awk '/State/{print $3}')
            local favorite=$(echo "$s_details" | awk '/Favorite/{print $3}')
            local strength=$(echo "$s_details" | awk '/Strength/{print $3}')
            [[ -z "$strength" ]] && strength="0"

            local icon="󰤟"
            if [[ "$state" == "online" || "$state" == "ready" || "$line" == \** ]]; then
                icon="󰤨"
            elif [[ "$favorite" == "True" ]]; then
                icon="󰤥"
            fi

            ssid+=("$net_name")
            service_paths+=("$s_path")
            wifi+=("$icon  $net_name ($security - ${strength}%)")
        fi
    done < "$RAW_NETWORK_FILE"

    if [[ ${#wifi[@]} -eq 0 ]]; then
        notify "No available networks" "There are no available networks"
    fi
}

show_network_details() {
    local service="$1"
    local ssid_name="$2"
    local raw_details=$(connmanctl services "$service")
    
    local name=$(echo "$raw_details" | awk -F'=' '/^[ \t]*Name[ \t]*=/{print $2; exit}' | xargs)
    local state=$(echo "$raw_details" | awk -F'=' '/^[ \t]*State[ \t]*=/{print $2; exit}' | xargs)
    local strength=$(echo "$raw_details" | awk -F'=' '/^[ \t]*Strength[ \t]*=/{print $2; exit}' | xargs)
    local security=$(echo "$raw_details" | awk -F'=' '/^[ \t]*Security[ \t]*=/{print $2; exit}' | xargs)
    local autoconnect=$(echo "$raw_details" | awk -F'=' '/^[ \t]*AutoConnect[ \t]*=/{print $2; exit}' | xargs)
    
    local ipv4_line=$(echo "$raw_details" | grep 'IPv4 =')
    local ip_method=$(echo "$ipv4_line" | grep -o 'Method=[^,[:space:]]*' | cut -d= -f2)
    local ip_addr=$(echo "$ipv4_line" | grep -o 'Address=[^,[:space:]]*' | cut -d= -f2)
    local ip_mask=$(echo "$ipv4_line" | grep -o 'Netmask=[^,[:space:]]*' | cut -d= -f2)
    local ip_gw=$(echo "$ipv4_line" | grep -o 'Gateway=[^,[:space:]]*' | cut -d= -f2)

    local ns_line=$(echo "$raw_details" | grep 'Nameservers =')
    local dns_raw=$(echo "$ns_line" | cut -d= -f2- | tr -d '[]{}' | xargs)

    [[ -z "$name" ]] && name="$ssid_name"
    [[ -z "$state" ]] && state="Unknown"
    [[ -z "$strength" ]] && strength="N/A"
    [[ -z "$security" ]] && security="Open"

    local details_list=(
        "󱚷  Return"
        "󰌘  Name: $name"
        "󱎫  Status: ${state^}"
        "󰤨  Signal Strength: ${strength}%"
        "󰦝  Security: $security"
        "󰩟  IPv4 Configuration"
        "     └─ Address: ${ip_addr:-None}"
        "     └─ Gateway: ${ip_gw:-None}"
        "     └─ Netmask: ${ip_mask:-None}"
        "     └─ Method: ${ip_method:-None}"
        "󰓅  DNS Servers"
    )

    if [[ -n "$dns_raw" ]]; then
        IFS=',' read -ra dns_array <<< "$dns_raw"
        for dns in "${dns_array[@]}"; do
            dns=$(echo "$dns" | xargs)
            [[ -n "$dns" ]] && details_list+=("     └─ $dns")
        done
    else
        details_list+=("     └─ None")
    fi

    details_list+=("󰒓  Auto-Connect: ${autoconnect:-No}")

    while true; do
        local selected=$(printf "%s\n" "${details_list[@]}" | $ROFI_DEFAULT_MODE -p "Details")
        [[ -z "$selected" || "$selected" == *"Return"* ]] && break
    done
}

connect_to_network() {
    local index="$1"
    local selected_ssid="${ssid[$index]}"
    local service="${service_paths[$index]}"
    
    local raw_details=$(connmanctl services "$service")
    local service_state=$(echo "$raw_details" | awk '/State/{print $3}')
    local autoconnect=$(echo "$raw_details" | awk -F'=' '/^[ \t]*AutoConnect[ \t]*=/{print $2; exit}' | xargs)

    local autoconnect_opt="󰌾  Enable auto-connect"
    if [[ "$autoconnect" == "True" || "$autoconnect" == "true" ]]; then
        autoconnect_opt="󰌿  Disable auto-connect"
    fi

    local actions=""
    if [[ "$service_state" == "online" || "$service_state" == "ready" ]]; then
        actions="󰤭  Disconnect\n󰆴  Forget\n$autoconnect_opt\n󰋽  Show Details"
    else
        actions="󰤨  Connect\n󰆴  Forget\n$autoconnect_opt\n󰋽  Show Details"
    fi

    local action=$(echo -e "$actions" | $ROFI_DEFAULT_MODE -p "$selected_ssid")

    if [[ "$action" =~ "Disconnect" ]]; then
        connmanctl disconnect "$service" && notify "Network Disconnected!!" "Disconnected from $selected_ssid"
    elif [[ "$action" =~ "Forget" ]]; then
        connmanctl remove "$service" && notify "Forgotten!!" "$selected_ssid forgotten"
    elif [[ "$action" =~ "Enable auto-connect" ]]; then
        connmanctl config "$service" --set-property AutoConnect True && notify "Auto-connection enabled"
    elif [[ "$action" =~ "Disable auto-connect" ]]; then
        connmanctl config "$service" --set-property AutoConnect False && notify "Auto-connection disabled"
    elif [[ "$action" =~ "Show Details" ]]; then
        show_network_details "$service" "$selected_ssid"
    elif [[ "$action" =~ "Connect" ]]; then
        notify "Connecting..." "Attempting $selected_ssid"

        if [[ "$service" == *_none* ]]; then
            connection_output=$(connmanctl connect "$service" 2>&1)
            notify_connection
        else
            connect_with_password "$service"
            notify_connection
        fi
    fi
}

#############################
# Menu Functions
#############################

power() {
    local state="$1"
    if [[ "$state" == "on" ]]; then
        connmanctl enable wifi
    else
        connmanctl disable wifi
    fi
    main
}

rofi_menu() {
    local status=($(check_status))
    local options=""

    if [[ "${status[0]}" == "OFF" ]]; then
        options="$ENABLE_OPT\n$REFRESH_OPT"
    else
        options="$DISABLE_OPT\n$REFRESH_OPT"
        if [[ ${#wifi[@]} -gt 0 ]]; then
            for net in "${wifi[@]}"; do
                options+="\n$net"
            done
        fi
    fi

    echo -e "$options" | $ROFI_DEFAULT_MODE
}

main() {
    wifi=()
    ssid=()
    service_paths=()

    local status=($(check_status))
    if [[ "${status[0]}" != "OFF" ]]; then
        get_networks
    fi

    local selected
    selected=$(rofi_menu)
    [[ -z "$selected" ]] && { clean_up; return; }

    if [[ "$selected" =~ "Enable Wi-Fi" ]]; then
        connmanctl enable wifi
        notify "Turning On..." "Wi-Fi is now enabled!!"
        sleep 1
        main
    elif [[ "$selected" =~ "Disable Wi-Fi" ]]; then
        connmanctl disable wifi
        notify "Turning Off..." "Wi-Fi is now disabled!!"
        main
    elif [[ "$selected" =~ "Refresh" ]]; then
        notify "Scanning..." "Nearby networks"
        connmanctl scan wifi > /dev/null 2>&1
        sleep 0.5
        main
    else
        for i in "${!wifi[@]}"; do
            if [[ "${wifi[$i]}" == "$selected" ]]; then
                connect_to_network "$i"
                break
            fi
        done
        main
    fi
}

#############################
# Start
#############################

main
