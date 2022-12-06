#!/bin/sh
echo "Knowl pre-commit hook Loading"

BIN_PATH="$HOME"
WORKING_DIR="$BIN_PATH/knowl_temp"
export PATH=$PATH:$WORKING_DIR
KNOWL_CLI_NAME="knowl-cli"
CLI_DOWNLOAD_URL='https://drive.google.com/uc?export=download&id=1fPxmV_rWISTaT9_zS5QN8XiOY078YARp'
VERSION_FILE_URL='https://drive.google.com/uc?export=download&id=1KyDB6NZC2JOOiuEmCdfkpM-aWlWkWXQJ'
VERSION_FILE_NAME="version.txt"


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

download_from_link() {
    echo "download begins ..."
    download_url="$1"
    filename="$2"
    directory_name="$WORKING_DIR/$3"
    echo $download_url
    echo $directory_name
    echo $directory_name/$filename
    create_working_dir $directory_name
    $BIN_WGET --no-check-certificate $download_url -O $directory_name/$filename
    chmod +x $directory_name/$filename 
    echo "download ends ..."

}
download_cli(){
    check_knowl_cli_version
}


check_knowl_cli_version() {
    #download version.text
    echo "check_knowl_cli_version"
    download_from_link $VERSION_FILE_URL $VERSION_FILE_NAME
    version_number=$(head -n 1 $WORKING_DIR/$VERSION_FILE_NAME)
    #get folder names in the working directory
    is_latest_cli_exist=false
    for dir in $WORKING_DIR/*/
        do
            if [ `basename ${dir}` = $version_number ]; 
                then
                    if [ ! -x "$WORKING_DIR/$version_number/$KNOWL_CLI_NAME" ]
                        then
                            download_from_link $CLI_DOWNLOAD_URL $KNOWL_CLI_NAME $version_number
                         else
                            echo "Latest version of the cli is already installed"
                        fi
                    is_latest_cli_exist=true
                    break
                else
                    echo "Downloading latest version of the cli"
                fi
        done
                echo $is_latest_cli_exist
                if [ ! $is_latest_cli_exist ]
                    then
                        download_from_link $CLI_DOWNLOAD_URL $KNOWL_CLI_NAME $version_number
                    fi

}

cleanup() {
    echo "Cleaning up..."
#    rm -f $WORKING_DIR/knowl_cli
}

verify_wget
verify_tmp
check_knowl_cli_version
cleanup
#read -n1 -p "Do you want to CONTINUE pushing? [Y/n]" doit < /dev/tty
knowl-cli knowl-cli-precommit
