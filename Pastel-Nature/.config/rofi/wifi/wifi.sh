#!/bin/sh
INTERFACE="wlan0"

# Directory for temporary files related to iwd_rofi_menu
TPATH="$HOME/.cache/iwd_rofi_menu_files"

# Temporary files for storing network information
RAW_NETWORK_FILE="$TPATH/iwd_rofi_menu_ssid_raw.txt"        # Stores raw output of 'iwctl get-networks'
NETWORK_FILE="$TPATH/iwd_rofi_menu_ssid_structured.txt"		# Stores formatted output (SSID, Security, etc)
RAW_METADATA_FILE="$TPATH/iwd_rofi_menu_metadata_raw.txt"           # Stores raw output of 'iwctl show'
METADATA_FILE="$TPATH/iwd_rofi_menu_metadata_structured.txt"        # Stores formatted metadata output
TEMP_PASSWORD_FILE="$TPATH/iwd_rofi_menu_temp_ssid_password.txt"    # Stores temporary password for networks

# Rofi theme/settings files
THEME_FILE="~/.config/rofi/wifi/style.rasi"
PASS_WIN_THEME="~/.config/rofi/wifi/password.rasi"
ROFI_DEFAULT_MODE="rofi -dmenu -mouse -i -theme $THEME_FILE"

# Function to clean up temporary files and directories
clean_up() { [[ -e "$TPATH" ]] && rm -r "$TPATH"; }

# Menu options for the Wi-Fi management interface
MENU_OPTIONS=( "Refresh" "Enable Wi-Fi" "Disable Wi-Fi" "Network Info" \
               "Scan Networks" "Connect" "Disconnect"
)

# Arrays to store Wi-Fi information
wifi=()   # Stores formatted network info [Signal Strength, SSID, etc]
ssid=()   # Stores SSIDs of available networks
mkdir -p "$TPATH"  # Ensure the directory for temporary files exists

# Function to power on/off the Wi-Fi interface
power() { iwctl device "$INTERFACE" set-property Powered $1 ; main; }

# Close other notifiation after a new function call
notify() { dunstctl close-all ; notify-send "$1" "$2";}

# Function to disconnect from the currently connected network
function disconnect() {
    iwctl station "$INTERFACE" disconnect
    notify "Network Disconnected!!" "You are now disconnected to ${ssid[$1]}..."
}

# Function to check the current status of the Wi-Fi interface
function check() {
    local status=$(iwctl station "$INTERFACE" show | grep 'State' | awk '{print $2}')
    if [[ -n "$status" ]]; then
        interface="ON" ; [[ "$status" == "disconnected" ]] && wifi="OFF" || wifi="ON"
    else
        interface="OFF"
    fi
    local status_results=( $interface $wifi )
    echo "${status_results[@]}"
}

# Function to fetch available networks and format the data for later use
# It handles edge cases where SSID contains consecutive spaces.
function helper_get_networks() {
    # Scan for networks using iwctl
    iwctl station "$INTERFACE" scan
    iwctl station "$INTERFACE" get-networks > "$RAW_NETWORK_FILE"
    {
        # Add header for formatted file
        echo "SSID,SECURITY,SIGNAL"
        # Read the raw network file, remove non-printable characters, and process each line
        local i=1 ; sed $'s/[^[:print:]\t]//g' "$RAW_NETWORK_FILE" | while read -r line; do
            # Skip the first 4 lines (header info)
            if (( i < 5 )); then
                ((i++))
                continue

            # Process the 5th line differently based on Wi-Fi status
            elif (( i == 5 )); then
                # Adjust for different line format if connected/disconnected
                wifi_status=($(check)) ; [[ ${wifi_status[1]} == "ON" ]] && line="${line:18}" || line="${line:9}"
                # Replace consecutive spaces with commas for CSV format
                echo "$line" | sed 's/  \+/,/g'
                ((i++))
                continue
            fi
            # Skip empty lines and replace consecutive spaces with commas
            [[ -z "$line" ]] && continue ; echo "$line" | sed 's/  \+/,/g'
        done
    } > "$NETWORK_FILE"

    # Format signal strength and replace it with a visual representation of stars
    sed -e 's/\*\*\*\*\[1;90m\[0m/[####] /g' -e 's/\*\*\*\[1;90m\*\[0m/[###-] /g' \
        -e 's/\*\*\[1;90m\*\*\[0m/[##--] /g' -e 's/\*\[1;90m\*\*\*\[0m/[#---] /g' \
        -e 's/\[1;90m\*\*\*\*\[0m/[----] /g' -e 's/\*\*\*\*/[####] /g' \
        "$NETWORK_FILE" > "${NETWORK_FILE}.tmp" && mv "${NETWORK_FILE}.tmp" "$NETWORK_FILE"
}

# Function to retrieve and store the formatted list of available networks
# It reads from the formatted network file and stores SSIDs, Security, and Signal Strength
function get_networks() {
    ssid=() ; local security=() ; local signal=()
    helper_get_networks ; local local_file="$NETWORK_FILE"

    # Read the CSV formatted file and store each column into separate arrays
    while IFS=',' read -r col1 col2 col3; do
        ssid+=("$col1") ; security+=("$col2") ; signal+=("$col3")
    done < <(tail -n +2 "$local_file")

    # Combine the data into the 'wifi' array
    for ((i = 0; i < ${#ssid[@]}; i++)); do
        wifi+=("${signal[$i]} ${ssid[$i]} (${security[$i]})")
    done
}

# Function to connect to a selected Wi-Fi network
# It handles both known and unknown networks, including entering a passphrase for secure networks
function connect_to_network() {
    local selected_ssid="${ssid[$1]}" ; notify "Connecting..." "Attempting to access $selected_ssid!!"
    local known=$(iwctl known-networks list | grep -w "$selected_ssid")
    if [[ -n "$known" ]]; then
        # Attempt to connect to a known network
        local connection_output=$(timeout 10 iwctl station "$INTERFACE" connect "$selected_ssid" 2>&1)

        if [[ -z "$connection_output" ]]; then
            notify "Connection Was Successful!!" "You are now connected to $selected_ssid!!" ; return
        else
            notify "Connection Was Unsuccessful!!" "$selected_ssid may not be available for a while, please try again!!" ; return
        fi
    else
        # Prompt for a password if the network is not known
        (rofi -dmenu -password -p "  " -theme $PASS_WIN_THEME) > "$TEMP_PASSWORD_FILE"

        # Attempt to connect to an unknown network with the provided passphrase
        local connection_output=$(iwctl station "$INTERFACE" connect "$selected_ssid" --passphrase=$(<"$TEMP_PASSWORD_FILE") 2>&1)
        if [[ -n "$connection_output" ]]; then
            notify "Connection Was Unsuccessful!!" "The password entered may be wrong or empty, please try again!!"
        else
            notify "Connection Was Successful!!" "You are now connected to $selected_ssid!!"
        fi
    fi
}

# Function to display detailed Wi-Fi metadata (e.g., signal strength, etc.)
function helper_wifi_status() {
    iwctl station "$INTERFACE" show > "$RAW_METADATA_FILE"
    {
        # Add options to return or refresh the menu
        echo "󱚷  Return" ; echo "󱛄  Refresh" ; local i=1 # Read the raw metadata file and process each line
        sed $'s/[^[:print:]\t]//g' "$RAW_METADATA_FILE" | while read -r line; do
            (( i <= 5 )) && ((i++)) && continue
            # Skip empty lines and replace consecutive spaces with commas
            [[ -z "$line" ]] && continue ; echo "$line" | sed 's/  \+/,/g'
        done
    } > "$METADATA_FILE"

    # Extract the second column into a list of values
    while IFS=, read -r key value; do
        local list+=("$value")
    done < "$METADATA_FILE"
    echo "${list[@]}"
}

# Function to display Wi-Fi metadata in a user-friendly format and copy selected value to clipboard
function wifi_status() {
    # Fetch Wi-Fi metadata values
    local values=($(helper_wifi_status))

    # Adjust the display of metadata dynamically based on the length of keys
    local data=$(awk -F',' '
    BEGIN { max_key_length = 10; }
    {
        # Calculate the maximum length of the first column for formatting
        if (length($1) > max_key_length) max_key_length = length($1);
        keys[NR] = $1;
        values[NR] = $2;
    }
    END {
        # Format and print each row with aligned columns
        for (i = 1; i <= NR; i++) {
            printf "%-*s  %s\n", max_key_length, keys[i], values[i];
        }
    }' "$METADATA_FILE")
    # Use rofi to allow the user to select a metadata field
    local selected_index=$(echo -e "$data" | $ROFI_DEFAULT_MODE -format i)

    # Handle the selected index
    (( selected_index == 0 )) && return  # Return if 'Return' option is selected
    (( selected_index == 1 )) && wifi_status ; return  # Refresh if 'Refresh' option is selected

    # Copy the selected field to clipboard
    echo "${values["$selected_index"]}" | xclip -selection clipboard
}

# Function to scan for available Wi-Fi networks and allow the user to connect to one
function scan() {
    # Continue scanning if 'Rescan' option is selected
    local selected_wifi_index=1
    while (( selected_wifi_index == 1 )); do
        notify "Scanning..." "For nearby networks!!"
        wifi=("󱚷  Return") ; wifi+=("󱛇  Rescan") ; get_networks
        selected_wifi_index=$( printf "%s\n" "${wifi[@]}" | $ROFI_DEFAULT_MODE -format i)
    done

    # Connect to the selected network if an SSID is selected
    if [[ -n "$selected_wifi_index" ]] && (( selected_wifi_index > 1 )); then
        connect_to_network "$((selected_wifi_index - 2))"
    fi
}

# Function to display the Rofi menu and handle user choices
function rofi_cmd() {
    local options="${MENU_OPTIONS[0]}" ; local status=($(check))
    if [[ "${status[0]}" == "OFF" ]]; then
        options+="\n${MENU_OPTIONS[1]}"
    else
        options+="\n${MENU_OPTIONS[2]}"

        if [[ "${status[1]}" == "OFF" ]]; then
            options+="\n${MENU_OPTIONS[5]}"
        else
            options+="\n${MENU_OPTIONS[3]}"
            options+="\n${MENU_OPTIONS[4]}"
            options+="\n${MENU_OPTIONS[6]}"
        fi
    fi
    local choice=$(echo -e "$options" | $ROFI_DEFAULT_MODE) ; echo "$choice"
}

# Function to run the selected command from the Rofi menu
function run_cmd() {
    case "$1" in
        "${MENU_OPTIONS[0]}")  # Refresh menu
            main ;;
        "${MENU_OPTIONS[1]}")  # Turn on Wi-Fi
            power on ;;
        "${MENU_OPTIONS[2]}")  # Turn off Wi-Fi
            power off ;;
        "${MENU_OPTIONS[3]}")  # Show Wi-Fi status
            wifi_status ; main ;;
        "${MENU_OPTIONS[4]}" | "${MENU_OPTIONS[5]}")  # List networks | Scan networks
            scan ; main ;;
        "${MENU_OPTIONS[6]}")  # Disconnect
            disconnect ; main ;;
        *)
            return ;;
    esac
}

# Main function to start the script and display the menu
main() { local chosen_option=$(rofi_cmd) ; run_cmd "$chosen_option" ; clean_up; } ; main
