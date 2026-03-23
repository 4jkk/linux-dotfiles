#!/bin/bash

WALLPAPERS=("/home/akk/Pictures/Wallpapers/a_black_and_white_swirly_pattern.jpg"
"/home/akk/Pictures/Wallpapers/a_blue_and_orange_background.jpg"
"/home/akk/Pictures/Wallpapers/a_blue_sky_over_a_mountain_range.png"
"/home/akk/Pictures/Wallpapers/a_cartoon_of_a_woman_on_a_balcony.png"
"/home/akk/Pictures/Wallpapers/a_group_of_pink_flowers.png"
"/home/akk/Pictures/Wallpapers/a_house_in_the_snow.png"
"/home/akk/Pictures/Wallpapers/a_person_on_a_beach.jpg"
"/home/akk/Pictures/Wallpapers/sunset-scenery-minimalist.jpg"
"/home/akk/Pictures/Wallpapers/vulcan.jpg"
"/home/akk/Pictures/Wallpapers/your-name-mitsuha-miyamuzu-close-up-wallpaper-2880x1800_8.jpg")

INDEX_FILE="/tmp/current_wallpaper_index"

if [ -f "$INDEX_FILE" ]; then
    NEXT_INDEX=$(($(cat "$INDEX_FILE") + 1))
else
    NEXT_INDEX=0
fi

if [ $NEXT_INDEX -ge ${#WALLPAPERS[@]} ]; then
    NEXT_INDEX=0
fi

echo "$NEXT_INDEX" > "$INDEX_FILE"
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"
hyprctl hyprpaper wallpaper "eDP-1,$NEXT_WALLPAPER"
