#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

[ ! -d "$WALLPAPER_DIR" ] && notify-send "Wallpaper Switcher" "Directory not found" && exit 1

mapfile -t WALLPAPERS < <(
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -printf "%f\n" | sort
)

[ ${#WALLPAPERS[@]} -eq 0 ] && notify-send "Wallpaper Switcher" "No wallpapers found" && exit 1

SELECTED=$(printf "%s\n" "${WALLPAPERS[@]}" | rofi -dmenu -i -p "Wallpaper")
[ -z "$SELECTED" ] && exit 0

SELECTED_PATH="$WALLPAPER_DIR/$SELECTED"
URI="file://$SELECTED_PATH"

# Apply wallpaper (GNOME / Pop!_OS)
gsettings set org.gnome.desktop.background picture-uri "$URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$URI"

notify-send "Wallpaper Changed" "$SELECTED" -i "$SELECTED_PATH"

