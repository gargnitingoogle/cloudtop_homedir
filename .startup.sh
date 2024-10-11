#!/bin/bash

set -x
set -e

#install/enable google-drive
sudo glinux-add-repo drive-fs-all stable && sudo apt update -y && sudo apt install -y drive-fs && /opt/google/drive-file-stream/drive_fs 2>/dev/null && systemctl --user enable --now google-drive-fs && ls ~/DriveFileStream/

