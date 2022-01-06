English/日本語
# GeneralScripts
## Introduction / はじめに


## About scripts / 各スクリプトについて


## Test / テスト
### Test environment / テスト環境
```
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.6 LTS"

$ lspci | grep -i nvidia
03:00.0 VGA compatible controller: NVIDIA Corporation GK110GL [Quadro K5200] (rev a1)
03:00.1 Audio device: NVIDIA Corporation GK110 HDMI Audio (rev a1)

$ cat /proc/driver/nvidia/version
NVRM version: NVIDIA UNIX x86_64 Kernel Module  470.86  Tue Oct 26 21:55:45 UTC 2021
GCC version:  gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)
```

