#!/bin/bash

ROFI_DIR="${ROFI_DIR:-$HOME/.files/configs/rofi}"

shutdown_opt="󰐥"
reboot_opt="󰜉"
sleep_opt="󰒲"
logout_opt="󰍃"

run_with_privilege() {
    local cmd="$1"
    if $cmd 2>/dev/null; then
        return 0
    fi
    local pass
    pass=$(zenity --password --title="Authentication Required" --text="Enter password for root privileges:" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$pass" ]; then
        echo "$pass" | su -c "$cmd" 2>/dev/null
    fi
}

show_main_menu() {
    current_profile=$(powerprofilesctl get 2>/dev/null || echo "balanced")
    profile_icon="󰾆"
    case "$current_profile" in
        performance) profile_icon="󱐋" ;;
        balanced) profile_icon="󰾆" ;;
        power-saver) profile_icon="󰌪" ;;
    esac

    options="$shutdown_opt\n$reboot_opt\n$sleep_opt\n$logout_opt\n$profile_icon"

    chosen=$(echo -e "$options" | rofi -dmenu -i -theme "$THEME_FILE" -p "")

    case "$chosen" in
        "$shutdown_opt")
            run_with_privilege "loginctl poweroff"
            ;;
        "$reboot_opt")
            run_with_privilege "loginctl reboot"
            ;;
        "$sleep_opt")
            run_with_privilege "loginctl suspend"
            ;;
        "$logout_opt")
            # Try multiple robust logout methods
            if [ -n "$XDG_SESSION_ID" ]; then
                loginctl terminate-session "$XDG_SESSION_ID" 2>/dev/null
            fi
            
            session_id=$(loginctl list-sessions --no-legend 2>/dev/null | grep "$USER" | awk '{print $1}' | head -n1)
            if [ -n "$session_id" ]; then
                loginctl terminate-session "$session_id" 2>/dev/null
            fi
            
            loginctl terminate-user "$USER" 2>/dev/null
            
            case "$DESKTOP_SESSION" in
                openbox) openbox --exit ;;
                bspwm) bspc quit ;;
                i3) i3-msg exit ;;
                sway) swaymsg exit ;;
                hyprland) hyprctl dispatch exit ;;
            esac
            
            pkill -u "$USER"
            ;;
        "$profile_icon"|"󱐋"|"󰾆"|"󰌪"|"󰓅")
            show_profile_menu
            ;;
    esac
}

show_profile_menu() {
    current_profile=$(powerprofilesctl get 2>/dev/null || echo "balanced")
    profile_icon="󰾆"
    case "$current_profile" in
        performance) profile_icon="󱐋" ;;
        balanced) profile_icon="󰾆" ;;
        power-saver) profile_icon="󰌪" ;;
    esac
    profiles=("performance" "balanced" "power-saver")
    profile_menu=""
    for p in "${profiles[@]}"; do
        p_icon="󰾆"
        [[ "$p" == "performance" ]] && p_icon="󱐋"
        [[ "$p" == "power-saver" ]] && p_icon="󰌪"
        
        local label="${p^}"
        [[ "$p" == "power-saver" ]] && label="Minimal"

        if [[ "$p" == "$current_profile" ]]; then
            profile_menu+="$p_icon  $label  \n"
        else
            profile_menu+="$p_icon  $label\n"
        fi
    done
    profile_menu+="󰁍 Back"
    
    chosen_profile=$(echo -e "$profile_menu" | rofi -dmenu -i -theme "$ROFI_DIR/styles/powerprofile.rasi" -p "Profile")
    if [[ -n "$chosen_profile" ]]; then
        if [[ "$chosen_profile" =~ "Back" ]]; then
            show_main_menu
        elif [[ "$chosen_profile" =~ "Performance" ]]; then
            powerprofilesctl set performance
        elif [[ "$chosen_profile" =~ "Balanced" ]]; then
            powerprofilesctl set balanced
        elif [[ "$chosen_profile" =~ "Power-saver" || "$chosen_profile" =~ "Power Saver" || "$chosen_profile" =~ "Minimal" ]]; then
            powerprofilesctl set power-saver
        fi
    fi
}

show_main_menu
