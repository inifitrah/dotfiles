#!/bin/bash

# Rofi Theme Switcher Script
# Usage: ./switch-theme.sh [theme-name]

ROFI_CONFIG_DIR="$HOME/.config/rofi"
CURRENT_CONFIG="$ROFI_CONFIG_DIR/config.rasi"

# Available themes
declare -A THEMES
THEMES=(
    ["glassmorphism"]="config.rasi"
    ["minimalist"]="minimalist-dark.rasi"
    ["rounded"]="rounded-dark.rasi"
    ["catppuccin"]="catppuccin-dark.rasi"
    ["sidebar"]="sidebar-dark.rasi"
)

# Function to show available themes
show_themes() {
    echo "Available themes:"
    for theme in "${!THEMES[@]}"; do
        echo "  - $theme"
    done
}

# Function to apply theme
apply_theme() {
    local theme_name="$1"
    local theme_file="${THEMES[$theme_name]}"
    
    if [[ -z "$theme_file" ]]; then
        echo "Error: Theme '$theme_name' not found!"
        show_themes
        exit 1
    fi
    
    local theme_path="$ROFI_CONFIG_DIR/$theme_file"
    
    if [[ ! -f "$theme_path" ]]; then
        echo "Error: Theme file '$theme_file' not found!"
        exit 1
    fi
    
    # Backup current config if it's not already a backup
    if [[ ! -f "$CURRENT_CONFIG.backup" ]]; then
        cp "$CURRENT_CONFIG" "$CURRENT_CONFIG.backup"
        echo "Created backup of original config"
    fi
    
    # Apply new theme
    cp "$theme_path" "$CURRENT_CONFIG"
    echo "Applied theme: $theme_name"
    echo "Theme file: $theme_file"
}

# Function to preview theme
preview_theme() {
    local theme_name="$1"
    local theme_file="${THEMES[$theme_name]}"
    
    if [[ -z "$theme_file" ]]; then
        echo "Error: Theme '$theme_name' not found!"
        show_themes
        exit 1
    fi
    
    local theme_path="$ROFI_CONFIG_DIR/$theme_file"
    
    if [[ ! -f "$theme_path" ]]; then
        echo "Error: Theme file '$theme_file' not found!"
        exit 1
    fi
    
    # Launch rofi with the theme for preview
    rofi -show drun -config "$theme_path"
}

# Function to restore original theme
restore_original() {
    if [[ -f "$CURRENT_CONFIG.backup" ]]; then
        cp "$CURRENT_CONFIG.backup" "$CURRENT_CONFIG"
        echo "Restored original theme"
    else
        echo "No backup found!"
        exit 1
    fi
}

# Main logic
case "$1" in
    "")
        echo "Rofi Theme Switcher"
        echo "Usage: $0 <command> [theme-name]"
        echo ""
        echo "Commands:"
        echo "  apply <theme>     - Apply a theme"
        echo "  preview <theme>   - Preview a theme"
        echo "  list             - List available themes"
        echo "  restore          - Restore original theme"
        echo ""
        show_themes
        ;;
    "list")
        show_themes
        ;;
    "apply")
        if [[ -z "$2" ]]; then
            echo "Please specify a theme name"
            show_themes
            exit 1
        fi
        apply_theme "$2"
        ;;
    "preview")
        if [[ -z "$2" ]]; then
            echo "Please specify a theme name"
            show_themes
            exit 1
        fi
        preview_theme "$2"
        ;;
    "restore")
        restore_original
        ;;
    *)
        # If first argument looks like a theme name, apply it
        if [[ -n "${THEMES[$1]}" ]]; then
            apply_theme "$1"
        else
            echo "Unknown command or theme: $1"
            show_themes
            exit 1
        fi
        ;;
esac
