#!/bin/bash
#
# Program: Upload shell script
# Purpose: Upload the all the normal files under the publish_dir
# Author : Sucha <suchaaa@gmail.com>
# Version: 2.00
# Usage  : Fill in your PUBLISH_DIR and FTP information blow , then
#          run it anywhere.
# 
# History: v2.00 - 2014.01.04
#                * Using ftp script to transfer
#          v1.04 - 2006.08.05
#                * If transfer failure or any other mistakes occur,
#                  abort the mission, DO NOT update the record file,
#                  and you should upload the files at later time. 
#                  [ Thanks to zhao wang, arithboy AT gmail DOT com ]
#          v1.03 - 2006.01.19
#                * Upload all the normal files under the publish dir 
#                  use the find command, no depth limited, and less 
#                  tmp file generated.
#          v1.02 - 2005.05.03
#                * Upload all the normal files under the publish dir,
#                  no depth limited.
#          v1.01 - 2005.05.02
#                * Upload all the normal files under the publish dir
#                  wtih the depth is 2.
#          v1.00 - 2005.01.07
#                * Upload a single dir's normal file, and also support
#                  it's sub image dir.

# Settins
#
# 1. Local settings
#    publish_dir holding your ftp files, normal file under this 
#    dir will be checked, path including last "/".  
publish_dir=$HOME/workport/homesite/publish/

# file of recording the modified time, no need to change
ctf=$publish_dir.ctime.txt

# tmp file prefix
tmpfile="/tmp/upssdef"$RANDOM

# magic line
magic_line="_UNIQUE__NAME___"

# 2. Serve settings
server=98.126.60.122
user=lalawuer
passwd=814a5b63c0fab
rdir=web

# 3. Backup
# 
store_dir=$HOME
backup_dir=$HOME/workport
file_name="homesite"
_backup()
{
    echo "------ backup files ------"
    echo "from $backup_dir/$file_name"
    echo "To $store_dir/site.tar.gz"
    cd $backup_dir
    tar -czf $store_dir/site.tar.gz $file_name
}

_generate_and_run_script()
{
    echo "------ generate ftp script ------"

    echo "#!/bin/bash" > $tmpfile
    echo "ftp -n << $magic_line" >> $tmpfile
    echo "open $server" >> $tmpfile
    echo "user $user $passwd" >> $tmpfile

    for path in $(find . -type f -cnewer $ctf -print)
    do
        file=$(echo $path | cut -c3- )
        echo "put $file $rdir/$file" >> $tmpfile
    done

    echo "bye" >> $tmpfile
    echo "$magic_line" >> $tmpfile
    
    # run script
    echo "------ run script ------"
    bash $tmpfile
    echo "------ delete script ------"
    rm $tmpfile
}

# run
generate_google_sitemap
if [ -e $ctf ]; then
    cd $publish_dir
    _generate_and_run_script
	_backup
    echo "created in $(date), records the modified time." > $ctf
else
    echo "First run this program, create the file for recoreding the motified time."
    echo "created in $(date), records the modified time." > $ctf
fi
