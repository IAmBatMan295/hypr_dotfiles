#!/usr/bin/env bash

CONSERVATION_PATH="/sys/devices/pci0000:00/0000:00:14.3/PNP0C09:00/VPC2004:00/conservation_mode"

current=$(cat "$CONSERVATION_PATH" 2>/dev/null | tr -d '[:space:]')

echo ""
if [[ "$current" == "1" ]]; then
  echo "  Current Mode: 🔋 Conservation Mode (60% cap)"
elif [[ "$current" == "0" ]]; then
  echo "  Current Mode: ⚡ Normal Mode (100% charge)"
else
  echo "  Current Mode: ❓ Unknown (read: '$current')"
fi

echo ""
echo "  1) 🔋 Conservation Mode (60% cap)"
echo "  2) ⚡ Normal Mode (100% charge)"
echo ""
read -rp "  Pick [1/2]: " choice

case "$choice" in
  1)
    echo 1 | sudo tee "$CONSERVATION_PATH" > /dev/null
    echo ""
    echo "  ✅ Switched to Conservation Mode"
    ;;
  2)
    echo 0 | sudo tee "$CONSERVATION_PATH" > /dev/null
    echo ""
    echo "  ✅ Switched to Normal Mode"
    ;;
  *)
    echo ""
    echo "  ❌ Invalid choice"
    ;;
esac

sleep 1
