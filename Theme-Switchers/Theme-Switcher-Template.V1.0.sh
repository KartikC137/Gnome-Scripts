#!/bin/bash

# basic 2 Gnome User themes Dark mode/Light mode switcher

#requirements:
# User themes gnome extension
# gsettings
# dconf 

# How it works:
# 1. If Switching from First theme's light mode -> Switched to First theme's dark mode, 
# 2. If Switching to Second theme from First theme (and vice versa) -> Check First themes' color and switch to same color in Second theme

# ex if on First Dark theme -> Switch to First Light theme, if on Second Dark theme -> Switch to Second Dark theme

# Usage:
# Create two scripts with same format for both themes

# Define theme names and paths WARNING: SET NAMES PROPERLY
LIGHT_THEME='' #Name of First Light theme
DARK_THEME='' #Name of First Dark theme
DARK_THEME_2='' #Name of Second Dark theme to swtich to
GTK4_CONFIG_LINK="$HOME/.config/" #Default path for user gtk theme config for apps that use libadwaita, symlink is required
LIGHT_THEME_PATH='' # Path to Light theme's gtk files. Usually "$HOME/.themes/$LIGHT_THEME/gtk-4.0"  
DARK_THEME_PATH='' # Usually "$HOME/.themes/$DARK_THEME/gtk-4.0"

# Check the current system color scheme
COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)
echo "System mode is: $COLOR_SCHEME"

# Check the current theme
CURRENT_THEME=$(dconf read /org/gnome/shell/extensions/user-theme/name | tr -d "'")
echo "Shell theme is: $CURRENT_THEME"

if [[ "$CURRENT_THEME" == "$DARK_THEME_2" ]] || [[ "$COLOR_SCHEME" == "'default'" ]]; then
  # --- SET DARK THEME ---
  echo "Setting theme to $DARK_THEME ..."
  gsettings set org.gnome.desktop.interface gtk-theme "$DARK_THEME"
  # CAREFUL, SETTING DIRECT DCONF VALUE
  dconf write /org/gnome/shell/extensions/user-theme/name "'$DARK_THEME'"
  
  # Update GTK4 symlink
  echo "Linked GTK4 config to $DARK_THEME files..."
  rm -rf "$GTK4_CONFIG_LINK/gtk-4.0"
  mkdir -p "$GTK4_CONFIG_LINK/gtk-4.0"
  ln -sf "${DARK_THEME_PATH}/assets" "$GTK4_CONFIG_LINK/gtk-4.0/assets"
  ln -sf "${DARK_THEME_PATH}/gtk.css" "$GTK4_CONFIG_LINK/gtk-4.0/gtk.css"
  ln -sf "${DARK_THEME_PATH}/gtk-dark.css" "$GTK4_CONFIG_LINK/gtk-4.0/gtk-dark.css"
 
  # set system dark mode
  echo "Turning on Gnome Dark Mode."
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark

else
  # --- SET LIGHT THEME ---
  echo "Setting themes to $LIGHT_THEME..."
  gsettings set org.gnome.desktop.interface gtk-theme "$LIGHT_THEME"
  dconf write /org/gnome/shell/extensions/user-theme/name "'$LIGHT_THEME'"

  # Update GTK4 symlink
  echo "Linked GTK4 config to $LIGHT_THEME files..."
  rm -rf "$GTK4_CONFIG_LINK/gtk-4.0"
  mkdir -p "$GTK4_CONFIG_LINK/gtk-4.0"
  ln -sf "${LIGHT_THEME_PATH}/assets" "$GTK4_CONFIG_LINK/gtk-4.0/assets"
  ln -sf "${LIGHT_THEME_PATH}/gtk.css" "$GTK4_CONFIG_LINK/gtk-4.0/gtk.css"
  ln -sf "${LIGHT_THEME_PATH}/gtk-dark.css" "$GTK4_CONFIG_LINK/gtk-4.0/gtk-dark.css"

  # set system light mode
  echo "Turning on Gnome Light Mode."
  gsettings set org.gnome.desktop.interface color-scheme default
fi
echo "Done."
