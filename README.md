[English](#GeneralScripts)/[日本語](#このリポジトリについて)
# GeneralScripts

# File list
|Name|Brief description|
|---|---|
|multiple_installer.sh|Shell script to install basic apps and libraries required for the data science|
|||

# Description
## multiple_installer.sh  
This is a bash script to install the following softwares.
  
|Name|Version|
|---|---|
|NVIDIA GPU Driver|470|
|git|Depend on **apt-get** package|
|Clang|Refer to https://apt.llvm.org/llvm.sh|
|CMake|3.22.5|
|Perl|Depend on **apt-get** package|
|GNU Fortran|Depend on **apt-get** package|
|CUDA|11.5|
|CuDNN|8.3|
|Python3(+pip)|3.7|
|OpenJDK|Depend on **apt-get** package|
|Docker|https://download.docker.com/linux/ubuntu/dists/bionic/stable/|
|NVIDIA Docker|https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list|
|MySQL+SQLite|Depend on **apt-get** package|
|npm|Depend on **apt-get** package|
|NodeJS|[n (npm)](https://www.npmjs.com/package/n) stable ver.|
|R|Refer to https://cloud.r-project.org/bin/linux/ubuntu|
|Graphviz|Depend on **apt-get** package|
|OpenCV|4.5.5|
|FFmpeg|Depend on **apt-get** package|
|cURL|Depend on **apt-get** package|
|cifs|Depend on **apt-get** package|
|clamAV|Depend on **apt-get** package|
|doxygen|Depend on **apt-get** package|
|mozc|Depend on **apt-get** package|
|OpenSSH(server)+ufw|Depend on **apt-get** package|
|||  

# Usage
## - multiple_installer.sh  

> Requirement:  
> Ubuntu 18.04  
> NVIDIA GPU  
  
### 1. Download the script
Run the command on the terminal app.

```
$ wget https://raw.githubusercontent.com/YujiSue/GeneralScripts/main/multiple_installer.sh
```

### 2. Download CUDA package and CuDNN source code to "Downloads" directory  
  
\- CUDA  
```
$ wget https://developer.download.nvidia.com/compute/cuda/11.5.1/local_installers/cuda-repo-ubuntu1804-11-5-local_11.5.1-495.29.05-1_amd64.deb
```
  
\- CuDNN  
Download "cudnn-linux-x86_64-8.3.1.22_cuda11.5-archive.tar.xz" from [NVIDIA download site](https://developer.nvidia.com/cudnn-download-survey)\*1.
  
\*1 Require NVIDIA Developer's account. Please create your account if do not have. 
  
### 3. Run the script
Run the following command.  
To run the sudo command internally, you will be asked for your password first.  
After that, leave it until the end of the process.

```
$ bash {$path_to_script}/multiple_installer.sh
```
  


---
---

# このリポジトリについて
雑多なスクリプト置き場（予定）

# ファイル一覧
|名称|説明|
|---|---|
|multiple_installer.sh|データサイエンスでよく使う基本アプリを一括インストールするためのスクリプト|
|||

# 詳細
## multiple_installer.sh
以下のソフトをインストールするためのbashスクリプトです。

|名称|バージョン|
|---|---|
|NVIDIA GPU Driver|470|
|git|Depend on **apt-get** package|
|Clang|Refer to https://apt.llvm.org/llvm.sh|
|CMake|3.22.5|
|Perl|Depend on **apt-get** package|
|GNU Fortran|Depend on **apt-get** package|
|CUDA|11.5|
|CuDNN|8.3|
|Python3(+pip)|3.7|
|OpenJDK|Depend on **apt-get** package|
|Docker|https://download.docker.com/linux/ubuntu/dists/bionic/stable/|
|NVIDIA Docker|https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list|
|MySQL+SQLite|Depend on **apt-get** package|
|npm|Depend on **apt-get** package|
|NodeJS|[n (npm)](https://www.npmjs.com/package/n) stable ver.|
|R|Refer to https://cloud.r-project.org/bin/linux/ubuntu|
|Graphviz|Depend on **apt-get** package|
|OpenCV|4.5.5|
|FFmpeg|Depend on **apt-get** package|
|cURL|Depend on **apt-get** package|
|cifs|Depend on **apt-get** package|
|clamAV|Depend on **apt-get** package|
|doxygen|Depend on **apt-get** package|
|mozc|Depend on **apt-get** package|
|OpenSSH(server)+ufw|Depend on **apt-get** package|
|||  

# 使用法
## - multiple_installer.sh  

> 必要要件:  
> Ubuntu 18.04 (English)  
> NVIDIA GPU  
  
### 1. まずはスクリプトのダウンロード
以下のコマンドを実行してください。  
```
$ wget https://raw.githubusercontent.com/YujiSue/GeneralScripts/main/multiple_installer.sh
```

### 2. CUDAパッケージとCuDNNのソースコードを"Downloads"フォルダにダウンロード  
  
\- CUDA  
```
$ wget https://developer.download.nvidia.com/compute/cuda/11.5.1/local_installers/cuda-repo-ubuntu1804-11-5-local_11.5.1-495.29.05-1_amd64.deb
```
  
\- CuDNN  
CuDNNのソースコードは、[NVIDIA download site](https://developer.nvidia.com/cudnn-download-survey)から"cudnn-linux-x86_64-8.3.1.22_cuda11.5-archive.tar.xz"をダウンロードしてください。  
ただし、NVIDIA Developerのアカウントが必要になるので、ない人は作成をお願いします（もちろン無料です）。  
  
### 3. スクリプトの実行
```
$ bash {$path_to_script}/multiple_installer.sh
```

内部でsudoコマンドを走らせるため、最初にパスワードを聞かれるので入力してください。  
そのあとは終了まで放置です。
