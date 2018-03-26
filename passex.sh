#!/bin/bash

FORCE_PASSEX=false
PASSEX_EXPORT=""

function passex_usage () {
cat << EOF
./passex.sh
-f	force - will remove existing files / directories
-p	password directory to export
EOF
}

function passex () {
	function exportpass () {
		GPGF="${1/$HOME\/.password-store\//}"
		NAME="${GPGF/.gpg/}"
		mkdir -p $(dirname $NAME)
		echo Export $NAME
		pass $NAME > $NAME.txt
	}
	while getopts ":fp:" opt; do
		case $opt in
			f)
				FORCE_PASSEX=true
				;;
			p)
				PASSEX_EXPORT=$OPTARG
				;;
		esac
	done
	if [ -z "$PASSEX_EXPORT" ]; then
		echo "Export Required"
		return 1
	fi
	if [ -d "$PASSEX_EXPORT" ] && [ "$FORCE_PASSEX" == false ]; then
		echo $PASSEX_EXPORT directory already exists
		return 1
	elif [ -d "$PASSEX_EXPORT" ] && [ "$FORCE_PASSEX" == true ]; then
		rm -rf $PASSEX_EXPORT
	fi
	if [ -f "$PASSEX_EXPORT.tar.gz" ] && [ "$FORCE_PASSEX" == false ]; then
		echo $PASSEX_EXPORT.tar.gz file already exists
		return 1
	elif [ -f "$PASSEX_EXPORT.tar.gz" ] && [ "$FORCE_PASSEX" == true ]; then
		rm -f $PASSEX_EXPORT.tar.gz
	fi
	mkdir -p $PASSEX_EXPORT
	for file in $(find ~/.password-store/$PASSEX_EXPORT); do
		if [ -f "$file" ]; then
			exportpass $file
		fi
	done
	tar -zcvf $PASSEX_EXPORT.tar.gz $PASSEX_EXPORT
	rm -rf $PASSEX_EXPORT
	echo `pwd`/$PASSEX_EXPORT.tar.gz
	FORCE_PASSEX=false
	PASSEX_EXPORT=""
}

while getopts ":fp:" opt; do
	case $opt in
		f)
			FORCE_PASSEX=true
			;;
		p)
			PASSEX_EXPORT=$OPTARG
			;;
		*)
			passex_usage
			exit 0
			;;
	esac
done


if [ ! -z "$PASSEX_EXPORT" ]; then
	passex
fi
