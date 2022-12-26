#!/bin/sh
echo "Knowl pre-commit hook Loading"

BIN_PATH="/Users/knowl"
WORKING_DIR="$BIN_PATH/knowl_temp"
KNOWL_CLI_NAME="knowl-cli"
CLI_DOWNLOAD_URL_MAC='https://releases.knowl.io/cli/mac/knowl-cli'
CLI_DOWNLOAD_URL_LINUX='https://releases.knowl.io/cli/linux/knowl-cli'
VERSION_FILE_URL_MAC='https://releases.knowl.io/cli/mac/version.txt'
VERSION_FILE_URL_LINUX='https://releases.knowl.io/cli/linux/version.txt'
PRE_COMMIT_TYPE=$1 #0 - for blocker, 1 for non-blocker
TEMP_DATA_FILE="$WORKING_DIR/tmp_data.txt"
VERSION_FILE_NAME="version.txt"
EVENT_PRE_COMMIT="pre_commit"



verify_wget() {
    BIN_WGET=$(which wget) || {
        echo "You need to install 'wget' to use this hook."
    }
}

verify_tmp() {
    touch $BIN_PATH || {
        error_out "Could not write to $BIN_PATH"
    }
}

create_working_dir(){
    working_dir=$1
    if [ ! -d "$working_dir" ]
        then
            mkdir -p -- "$working_dir"
    fi
}

get_machine_os() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
    Linux*)     machine_type=linux;;
    Darwin*)    machine_type=mac;;
    CYGWIN*)    machine_type=cygwin;;
    MINGW*)     machine_type=minGw;;
    *)          machine_type="UNKNOWN:${unameOut}"
    esac
}

download_from_link() {
    echo "download begins ..."
    download_url="$1"
    directory_name="$2"
    file_path="$3"
    
    create_working_dir $directory_name
    $BIN_WGET --no-check-certificate $download_url -O $file_path
    chmod +x $file_path
    echo "download ends ..."

}


check_knowl_cli_version() {
    #download version.text
    echo "checking for latest cli version"
    version_file_url=$VERSION_FILE_URL_MAC
    cli_file_url=$CLI_DOWNLOAD_URL_MAC
    if [ "$machine_type" = "" ]
        then
            get_machine_os
    fi
    if [ "$machine_type" = "linux" ]
        then
            version_file_url=$VERSION_FILE_URL_LINUX
            cli_file_url=$CLI_DOWNLOAD_URL_LINUX
    fi
    echo $machine_type
    download_from_link $version_file_url $WORKING_DIR $WORKING_DIR/$VERSION_FILE_NAME
    version_number=$(head -n 1 $WORKING_DIR/$VERSION_FILE_NAME)
    #get folder names in the working directory
    download_cli=1
    for dir in $WORKING_DIR/*/
        do
            if [ "`basename ${dir}`" = "$version_number" ]
                then
                    if [ ! -x "$WORKING_DIR/$version_number/$KNOWL_CLI_NAME" ]
                        then
                            download_from_link $cli_file_url $WORKING_DIR/$version_number $WORKING_DIR/$version_number/$KNOWL_CLI_NAME 
                         else
                            echo "Latest version of the cli is already installed"
                    fi
                    download_cli=0
                    break
                    
            fi
        done
    if [ $download_cli -eq 1 ]
        then
            echo "Downloading latest version of the cli"
            download_from_link $cli_file_url $WORKING_DIR/$version_number $WORKING_DIR/$version_number/$KNOWL_CLI_NAME 
    fi

    export PATH=$PATH:$WORKING_DIR/$version_number

}

cleanup() {
    rm $TEMP_DATA_FILE
    echo "Cleaning up..."
#    rm -f $WORKING_DIR/knowl_cli
}


machine_type=""
verify_wget
verify_tmp
check_knowl_cli_version
knowl-cli cli $EVENT_PRE_COMMIT $TEMP_DATA_FILE
is_sycned=$(head -n 1 $TEMP_DATA_FILE)
cleanup
if [ $PRE_COMMIT_TYPE -eq 0 ] 
    then
        if [ $is_sycned -eq 0 ]
            then 
                echo "error: block precommit"
            exit 1
        fi
fi

