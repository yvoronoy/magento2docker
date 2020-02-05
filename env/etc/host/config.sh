FS_MOUNT_TYPE='mutagen'
SOURCE_DIRECTORY=$(cd ../src && pwd)

if [ -f etc/host/config.sh.override ]
then
    source etc/host/config.sh.override
fi
echo ${!1}
