#!/bin/bash

# FTP server details
FTP_SERVER_IP="1.1.1.1"
FTP_USERNAME="aa"
FTP_PASSWORD="123@ab"
FTP_PORT="23456"

LOCAL_DIR_ROOT="/path/to/local/directory/"

# List of directories to sync
directories=(
"/home/me/data1"
"/home/me/data2"
"/home/me/data3"
# Add more directories as needed
)

while true
do
    for dir in "${directories[@]}"
    do
        # Extract the directory name
        dir_name=$(basename $dir)
        out_local_dir="${LOCAL_DIR_ROOT}/${dir_name}"
        mkdir -p $out_local_dir
        
        lftp -u $FTP_USERNAME,$FTP_PASSWORD -p $FTP_PORT sftp://$FTP_SERVER_IP << EOF
        mirror --reverse --delete --verbose $dir $out_local_dir
        quit
EOF
    done
    sleep 10
done
