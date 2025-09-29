#!/bin/bash

UUID="" #UUID of extension (check in metadata.json)
EXTENSION_NAME="" #for notification

# Get the current state of the extension
CURRENT_STATE=$(gnome-extensions info "$UUID" | grep -oP 'State: \K\w+')

if [[ "$CURRENT_STATE" == "ACTIVE" ]]; then
	gnome-extensions disable "$UUID"
	notify-send -a "Gnome Extensions" "$EXTENSION_NAME" "Disabled" -i video-display-symbolic
else 
	gnome-extensions enable "$UUID"
	notify-send -a "Gnome Extensions" "$EXTENSION_NAME" "Enabled" -i video-display-symbolic
fi
