#/!bin/bash

# Prompt for root password
pass=$(kdialog --password "Enter your password...")

# If password is entered, try to run the command as root
ERROR_TEXT="The password entered is incorrect... Please try again!"
[ -n "$pass" ] && $(echo "$pass" | sudo -S -E $1 || kdialog --error "$ERROR_TEXT")
