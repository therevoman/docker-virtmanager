exec openbox-session &
#x11vnc -xkb -noxrecord -noxfixes -noxdamage -nopw -wait 5 -permitfiletransfer -tightfilexfer -create -forever -rfbport 6000 
#virt-manager
/root/noVNC/utils/launch.sh --vnc localhost:6000 --listen 8080
