#!/bin/bash
progress ()
{
        HASH=($(md5sum "$I_FILE_PATH"))
        exiftool -rights="$HASH" -overwrite_original_in_place "$1"
        cwebp -q "$3" -metadata all "$1" -o "$2"
}

showhelper ()
{
        echo -e "\n  ----------------------------------\n  Error: $1 \n  ---------------------------------- \n  How to use this?'\n  nginxwebp.sh [absolutely path of root directory] [relative path of directory for input] [relative path of directory for output] [compression ratio]\n  Example: nginxwebp.sh /var/www/html uploads webp 70"
}

webpbuilder  ()
{
        I_FILE_PATH=$1
	echo "File: $I_FILE_PATH"
        O_DIR_PATH=$2
	RATIO=$3
	ROOT_DIR=$4
	ROOT_DIR_LENGTH=${#ROOT_DIR}
        I_FILE_NAME=$(basename -- "$I_FILE_PATH")
        RELATIVE_FILE_DIR=($(dirname "$I_FILE_PATH" | cut -c $ROOT_DIR_LENGTH-))
	RELATIVE_FILE_DIR="${O_DIR_PATH}${RELATIVE_FILE_DIR}/"
	I_FILE_NAME=$(basename -- "$I_FILE_PATH")
	O_FILE_PATH="${RELATIVE_FILE_DIR}${I_FILE_NAME}.webp"
	if [ ! -d $RELATIVE_FILE_DIR ]; then
                mkdir -p $RELATIVE_FILE_DIR
        fi
        if [ -f "$O_FILE_PATH" ]; then
                I_FILE_HASH=($(exiftool -rights "$I_FILE_PATH" | cut -d: -f2))
                O_FILE_HASH=($(exiftool -rights "$O_FILE_PATH" | cut -d: -f2))
                if [ -n $O_FILE_HASH ]; then
                        if [ $I_FILE_HASH == $O_FILE_HASH ]; then
                                echo "  Action: SKIP"
                        else
                                echo "  Action: REBUILD"
                                progress "$I_FILE_PATH" "$O_FILE_PATH" "$RATIO"
                        fi
                else
                        progress "$I_FILE_PATH" "$O_FILE_PATH" "$RATIO"
                fi
       else
                echo "  Action: BUILD"
                progress "$I_FILE_PATH" "$O_FILE_PATH" "$RATIO"
       fi
}

export -f progress
export -f webpbuilder

ROOT_DIR=$1
I_DIR=$2
O_DIR=$3
RATIO=$4

if [ -n $ROOT_DIR ]; then
	re='\/$'
        if ! [[ "$ROOT_DIR" =~ $re ]]; then
        	ROOT_DIR="${ROOT_DIR}/"
        fi
	if [ -d $ROOT_DIR ]; then
		if [ -n $I_DIR ]; then
			I_DIR="${ROOT_DIR}${I_DIR}"
        		if [ -d $I_DIR ]; then
                		if [ -n $O_DIR ]; then
					O_DIR="${ROOT_DIR}${O_DIR}"
                        		if [ ! -d $O_DIR ]; then
                                		mkdir $O_DIR
                                		if [ $? -ne 0 ]; then
                                        		showhelper "Output directory can not be created! Please, check permissions!"
                                		fi
                        		fi
                        		if [ -d $O_DIR ]; then
                                		re='\/$'
                                		if [[ "$I_DIR" =~ $re ]]; then
                                        		I_DIR="${I_DIR::-1}"
                                		fi
                                		if [[ "$O_DIR" =~ $re ]]; then
                                        		O_DIR=${O_DIR::-1}
                                		fi
                                		re='^[0-9]+$'
                                		if [[ $RATIO =~ $re ]] && [ $RATIO -ge 1 ] && [ $RATIO -le 100 ]; then
                                        		echo -e "\n  Configuration is ready!\n  ----------------------------------\n  Directory for processing: $I_DIR \n  Directory for output files: $O_DIR \n  Compression ratio: $RATIO%\n  ----------------------------------\n  Starting compression... \n";
                                        		find $I_DIR -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png \) -exec bash -c 'webpbuilder "$@"' bash {} $O_DIR $RATIO $ROOT_DIR \;

                                        		echo -e "\n  ----------------------------------\n  Compression process is finished! \n  ----------------------------------"
                                		else
                                        		showhelper "Ratio must be a number from 1 to 100!"
                                		fi
                        		fi
                		else
                       			showhelper "Output Directory Path parameter not supplied!"
                		fi
        		else
                		showhelper "Directory path '$i_DIR' is not correct!"
        		fi
		else
        		showhelper "Input Diretory Path parameter not supplied!"
		fi
	else
		showhelper "Root Directory is not isset!"
	fi
else
	showhelper "Root Diretory Path parameter not supplied!"
fi
