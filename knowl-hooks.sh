#!/bin/sh
echo "Knowl Pre Commiting Loading"
# check if knowl cli is installed
# if not then download cli binary to a folder
# wget binary_url
# install binary from that folder
BIN_PATH="$HOME"
WORKING_DIR="$BIN_PATH/knowl_temp"
#TARGET_DIR="/usr/local/apache/conf/modsec_rules/"

verify_wget() {
    BIN_WGET=$(which wget) || {
        echo "You need to install 'wget' to use this hook."
    }
    echo $BIN_WGET
}

verify_tmp() {
    touch $BIN_PATH || {
        error_out "Could not write to $BIN_PATH"
    }
}

create_working_dir(){
    if [ ! -d "$WORKING_DIR" ]
then
    echo "File doesn't exist. Creating now"
    mkdir -p -- "$WORKING_DIR"
    echo "File created- /bin/knowl_temp"
else
    echo "WORKING_DIR exists"
fi
}

download_cli() {
    echo "downloading cli.."
    create_working_dir
    $BIN_WGET --no-check-certificate 'https://docs.google.com/uc?export=download&id=1fPxmV_rWISTaT9_zS5QN8XiOY078YARp' -O $WORKING_DIR/knowl-cli
    export PATH=$PATH:$WORKING_DIR
    chmod +x $WORKING_DIR/knowl-cli

}

cleanup() {
    echo "Cleaning up..."
#    rm -f $WORKING_DIR/knowl_cli
}

verify_wget
verify_tmp
download_cli
cleanup
knowl-cli
