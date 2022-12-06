#!/bin/sh
echo "Knowl pre-commit hook Loading"

BIN_PATH="$HOME"
WORKING_DIR="$BIN_PATH/knowl_temp"
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
    directory_name="$2"
    file_path="$3"
    
    create_working_dir $directory_name
    $BIN_WGET --no-check-certificate $download_url -O $file_path
    chmod +x $file_path
    echo "download ends ..."

}
download_cli(){
    check_knowl_cli_version
}


check_knowl_cli_version() {
    #download version.text
    echo "checking for latest cli version"
    download_from_link $VERSION_FILE_URL $WORKING_DIR $WORKING_DIR/$VERSION_FILE_NAME
    version_number=$(head -n 1 $WORKING_DIR/$VERSION_FILE_NAME)
    #get folder names in the working directory
    download_cli=1
    for dir in $WORKING_DIR/*/
        do
            if [ "`basename ${dir}`" = "$version_number" ]
                then
                    if [ ! -x "$WORKING_DIR/$version_number/$KNOWL_CLI_NAME" ]
                        then
                            download_from_link $CLI_DOWNLOAD_URL $WORKING_DIR/$version_number $WORKING_DIR/$version_number/$KNOWL_CLI_NAME 
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
            download_from_link $CLI_DOWNLOAD_URL $WORKING_DIR/$version_number $WORKING_DIR/$version_number/$KNOWL_CLI_NAME
    fi

    export PATH=$PATH:$WORKING_DIR/$version_number

}

cleanup() {
    echo "Cleaning up..."
#    rm -f $WORKING_DIR/knowl_cli
}

verify_wget
verify_tmp
check_knowl_cli_version
knowl-cli knowl-cli-precommit
cleanup

