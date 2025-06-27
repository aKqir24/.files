# Verify Paths & Store The Wallpaper Config Variables In A Text File
[ -z $(which kdialog) ] && $(echo "kdialog is not found please install it!!" ; exit)
[ -z $PYWAL16_OUT_DIR ] && $(kdilog --error "The 'PYWAL16_OUT_DIR' env is not defined!!
\n You can define it in your '.bashrc, .xinit, .profile, etc' by export PYWAL16_OUT_DIR=/path/to/folder..." ; exit)
WALLPAPER_PATH_TEMP=$PYWAL16_OUT_DIR/wallpaper.cfg
[ -e "$WALLPAPER_PATH_TEMP" ] || touch $WALLPAPER_PATH_TEMP

# Function To Apply/Read A Random Wallpaper or not With Pywal16
applyWAL() { wal -i $1 -n --cols16 lighten --out-dir $PYWAL16_OUT_DIR > /dev/null; }
readTEMPCONF() { echo "$(grep "^$1=" $WALLPAPER_PATH_TEMP | cut -d '=' -f 2-)" ; }
assignTEMPCONF() {
	wallpaperIMG=$(readTEMPCONF wallpaper)
	wallpaperTYPE=$(readTEMPCONF type)
	wallpaperMODE=$(readTEMPCONF mode)
}

assignTEMPCONF

# Either GUI or Not get/read the image Wallpaper
if [ "$1" = "--gui" ]; then
	WALL_SELECT=$(kdialog --yesnocancel "Your Changing your pywal Wallpaper Colorscheme,\nDo you want to pick it randomly?" && echo "random" || echo "static")	
	WALL_TYPE=$(kdialog --geometry 300x100-0-0 --radiolist "Wallpaper Setup Type" none "Not Set" off clr "Solid Color" off img "Image File" on || exit)
	[ "$WALL_TYPE" = "img" ] && WALL_MODE=$(kdialog --geometry 280x170-0-0 --radiolist "Wallpaper Setup Mode" center "Center" off fill "Fill" on tile "Tile" off full "Full" off cover "Scale" off || exit) || WALL_MODE="none"

else
	WALL_SELECT=$(readTEMPCONF select)
	WALL_TYPE=$wallpaperTYPE
	WALL_MODE=$wallpaperMODE
fi

if [ "$WALL_SELECT" = "random" ]; then
	[ "$1" = "--gui" ] && WALL_CHANGE_FOLDER=$(kdialog --yesno "Do You Want To Change The Random Wallpaper Folder?" && echo "YES")
	if [ "$(file $wallpaperIMG)" != "$wallpaperIMG: directory" ]; then
		kdialog --msgbox "To be able to use random wallpapers\nYou need to specify a directory/folder of your wallpapers"
		WALLPAPER_FOLDER=$( kdialog --getexistingdirectory $HOME || exit )
	elif [ "$WALL_CHANGE_FOLDER" = "YES" ]; then
		WALLPAPER_FOLDER=$( kdialog --getexistingdirectory $HOME || exit )
	else
		WALLPAPER_FOLDER=$wallpaperIMG
	fi
elif [ "$WALL_SELECT" = "static" ]; then
	WALLPAPER=$wallpaperIMG
	[ "$1" = "--gui" ] && WALLPAPER=$(kdialog --getopenfilename $PYWAL16_OUT_DIR || exit) 
else
	kdialog --geometry 400x280-0-0 --msgbox "Please launch the GUI for config:\n$0 --gui!"
	$0 --gui ; exit
fi

# Write the $WALLPAPER_PATH_TEMP
[ -e $WALLPAPER_FOLDER ] && WALLPAPER=$WALLPAPER_FOLDER
cat > $WALLPAPER_PATH_TEMP <<EOF 
wallpaper=$WALLPAPER
type=$WALL_TYPE
mode=$WALL_MODE
select=$WALL_SELECT
EOF

assignTEMPCONF

if [ "$(file $wallpaperIMG)" = "$wallpaperIMG: directory" ]; then 
	wallpaperIMAGE=$(find $wallpaperIMG/* | shuf -n 1)
else 
	wallpaperIMAGE=$wallpaperIMG
fi

# Call the Wallpaper apply pywal16 function
applyWAL $wallpaperIMAGE 
case "$wallpaperTYPE" in
	"clr")
		. "${PYWAL16_OUT_DIR}/colors.sh"
		hsetroot -solid "$color8" || feh --bg-color "$color8" ;;
	"img")
		case "$wallpaperMODE" in
		"full")
			fehWALLmode="max" ;;
		"cover")
			fehWALLmode="scale" ;;
		*)
			fehWALLmode=$wallpaperMODE ;;
		esac
		hsetroot -$wallpaperMODE $wallpaperIMAGE || feh --bg-$wallpaperMODE $wallpaperIMAGE ;;
	"none")
		echo "";;
esac

# Reload Your WM/DE
i3-msg restart # You can change this depending on your setup!!
