#!/bin/bash

# Kontrollera att skriptet körs som root (sudo)
if [ "$EUID" -ne 0 ]; then 
  echo "Kör som root (sudo ./fix_audio.sh)"
  exit
fi

echo "Fixar ljudproblem för Dell XPS..."

# Skapar konfigurationsfilen med rätt inställningar
# Vi använder 'echo' och skickar texten in i filen med '>'
echo "options snd_hda_intel model=dell-headset-multi position_fix=1" > /etc/modprobe.d/audio-fix.conf

echo "Klart! Starta om datorn för att ändringen ska gälla."
