#!/bin/bash
#
# Program: Upload shell script
# Purpose: Upload the all the normal files under the publish_dir
# Author : Sucha <suchaaa@gmail.com>
# Version: 1.04
# Usage  : Fill in your PUBLISH_DIR and FTP information blow , then
#	   run it anywhere.
# 
# History: v1.04 - 2006.08.05
#                * If transfer failure or any other mistakes occur,
#                  abort the mission, DO NOT update the record file,
#                  and you should upload the files at later time. 
#                  [ Thanks to zhao wang, arithboy AT gmail DOT com ]
#          v1.03 - 2006.01.19
#		 * Upload all the normal files under the publish dir 
#		   use the find command, no depth limited, and less 
#	 	   tmp file generated.
#	   v1.02 - 2005.05.03
#		 * Upload all the normal files under the publish dir,
#		   no depth limited.
#	   v1.01 - 2005.05.02
#		 * Upload all the normal files under the publish dir
#		   wtih the depth is 2.
#	   v1.00 - 2005.01.07
#		 * Upload a single dir's normal file, and also support
#		   it's sub image dir.

# How does it work
#
# 1. the first time to create a file to record the last motified time,
#    that is the program start time.
# 2. recourse the directory, and use find command get the modified file
#    newer than the record file, if there's one, upload it with ncftpput.
# 3. if upload error was occurred, do not update the record file, and you
#    should run upload-script later time.

# Settins
#
# 1. Local settings
#    publish_dir is your site's publish dir, normal files under this 
#    dir will be checked. And DON'T forget the last "/".  
publish_dir=$HOME/your/publish-dir/

# file of recording the modified time, needless to change
ctf=$publish_dir.ctime.txt

# 2. Serve settings
#    eg 1. If the remote publish dir is the one when you login, just
#	   as this blow.DON'T forget the last "." 
#	   FTP="-u user -p passwd -P port www.ftp.com ." 
#    eg 2. Otherwise, likes me, but please remember  DOSEN'T need the
#	   last "/" 
ftp="-E -u user -p passwd -P port www.ftp.com remote_server_dir"

# 3. Backup
# 
store_dir=$HOME
backup_dir=$HOME/backup_dir
file_name="homesite"
backup()
{
    echo " "
    echo "Backup files from $backup_dir/$file_name"
    echo "To $store_dir/site.tar.gz"
    cd $backup_dir
    tar -czf $store_dir/site.tar.gz $file_name
}

# travel the dir, and upload the modified files
travel()
{
    # get the relatid dir
    del=$(echo "$publish_dir" | wc -c)
    floor=$(echo "$PWD" | cut -c$del-)

    # upload the modified files newer than the $ctf
    echo "from /$floor"
    for files in $(find . -maxdepth 1 -type f -cnewer $ctf -print)
    do
	ncftpput $ftp/$floor "$files"
	if [ $? -gt 0 ]; then	# if upload failure...
	    return $?
	fi
    done

    # scan the folders, and enter it
    for dir in *; do
	if [ -d $dir ]; then
	    cd $dir
	    travel
	    cd ../
	fi
    done
}

# prepare work
#generate_google_sitemap
if [ -e $ctf ]; then
    cd $publish_dir
    travel
    if [ $? -gt 0 ]; then
	echo "upload failure, transfer abort, you MUST upload them in next time!"
    else
	echo "upload created in $(date), records the modified time." > $ctf
	backup
    fi
else
    echo "First run this program, create the file for recoreding the motified time."
    echo "upload created in $(date), records the modified time." > $ctf
fi
