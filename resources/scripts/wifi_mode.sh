sudo tee /etc/usb_modeswitch.d/0bda:1a2b > /dev/null <<'EOF'
TargetVendor=0x0bda
TargetProductList="c820,c821,c822,c82b"
StandardEject=1
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger
