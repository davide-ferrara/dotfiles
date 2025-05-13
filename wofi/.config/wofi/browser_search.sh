#!/bin/bash
query=$(wofi --show=dmenu --prompt="Search: " --height=50)
if [ -n "$query" ]; then
  brave-browser "https://search.brave.com/search?q=$query&source=desktop"
fi
