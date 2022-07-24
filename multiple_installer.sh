#!/bin/bash

############################################################
# bash script to reconstruct the current environment
# Created by YujiSue 2022.
############################################################
# Paswword input for 'sudo' command.
printf "password: "
read -s PASSWORD

############################################################
# Install flag setting
inst_git=true     # SET false IF you DO NOT require git.
inst_clang=true   # SET false IF you DO NOT require clang.
inst_cmake=true   # SET false IF you DO NOT require cmake.
inst_perl=true    # SET false IF you DO NOT require Perl.
inst_fort=true    # SET false IF you DO NOT require GNU Fortran.
inst_cuda=true    # SET false IF you DO NOT require CUDA and CuDNN.
inst_py=true      # SET false IF you DO NOT require Python3.7 and some modules.
inst_java=true    # SET false IF you DO NOT require JAVA.
inst_dock=true    # SET false IF you DO NOT require Docker.
inst_sql=true     # SET false IF you DO NOT require MySQL and SQLite3.
inst_npm=true     # SET false IF you DO NOT require Node and npm.
inst_r=true       # SET false IF you DO NOT require R.
inst_gviz=true    # SET false IF you DO NOT require Graphviz.
inst_cv=true      # SET false IF you DO NOT require OpenCV.
inst_ffmpeg=true  # SET false IF you DO NOT require FFmpeg.
inst_curl=true    # SET false IF you DO NOT require cURL.
inst_cifs=true    # SET false IF you DO NOT require cifs.
inst_clam=true    # SET false IF you DO NOT require ClamAV.
inst_dox=true     # SET false IF you DO NOT require doxygen.
inst_mozc=true    # For Japanses only. SET false IF you DO NOT need to input in Japanese. 
inst_ssh=true     # SET false IF you DO NOT require SSH and UFW. *After the installation, SSH server will be launched automatically.
#Version
GPU_DRIVER_VER=470
CMAKE_VER=3.22.5
OPENCV_VER=4.5.5
CUDA_VER=11.5
CuDNN_VER=8.3.1.22

############################################################
#Directory set
WORK_SPACE=$(echo $HOME)
TEMPORARY=$WORK_SPACE/Downloads

############################################################
# Install basic program and libraries (Forced)
# *libjasper-dev is not installed by this script.
# *If you get a timeout error when fetching packages, add the option '-o Acquire::http::Timeout="300"' to the end of each apt command.
echo 'Preparation'
echo "$PASSWORD" | sudo -S add-apt-repository "deb http://security.ubuntu.com/ubuntu bionic-security main"
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get -y upgrade
echo "$PASSWORD" | sudo -S apt-get install -y build-essential ca-certificates gnupg lsb-release uuid-dev xz-utils zip unzip zlib1g zlib1g-dev \
libbz2-dev libboost-dev libdb-dev libreadline-dev libffi-dev libgdbm-dev \
libjpeg-dev liblzma-dev libpng-dev libtiff5-dev libwebp-dev \
libopenexr-dev libgdal-dev \
libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \
libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev \
libncurses5-dev libncursesw5-dev libtbb-dev libeigen3-dev libssl-dev \
libvtk6-dev qt5-default tk-dev 

###########################################################
# GPU Driver install (Forced)
echo 'GPU Driver install'
echo "$PASSWORD" | sudo -S add-apt-repository ppa:graphics-drivers/ppa
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y nvidia-driver-$GPU_DRIVER_VER
echo 'Completed.'

###########################################################
# git install
if "${inst_git}"; then
echo 'git check ... '
if which git >/dev/null; then
echo 'Installed.'
else
echo 'git install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y git
echo 'Completed.'
echo 'git > '$(git --version)
fi
fi

###########################################################
# Clang install
if "${inst_clang}"; then
echo 'Clang check...'
if which clang >/dev/null; then
echo 'installed.'
else
echo 'Clang install'
echo "$PASSWORD" | sudo -S bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
echo "$PASSWORD" | sudo -S update-alternatives --install /usr/bin/clang clang $(which /usr/bin/clang-* | head -1) 1
echo 'Completed.'
echo 'clang > '$(clang --version | head -1)
fi
fi

###########################################################
# CMake install
if "${inst_cmake}"; then
echo 'CMake install'
cd $TEMPORARY
echo 'Download source'
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/cmake-$CMAKE_VER.tar.gz
tar zxvf cmake-$CMAKE_VER.tar.gz
cd cmake-$CMAKE_VER/
echo 'Make start'
./bootstrap
make -j8
echo "$PASSWORD" | sudo -S make install
rm -r cmake*
cd $WORK_SPACE
echo 'Completed.'
echo 'cmake > '$(cmake --version | head -1)
fi

###########################################################
# Perl
if "${inst_perl}"; then
echo 'Perl check...'
if which perl >/dev/null; then
echo 'installed.'
else
echo 'Perl install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y perl
echo 'Completed.'
echo 'Perl > '$(perl --version | head -2 | tail -1)
fi
fi

###########################################################
# GNU Fortran
if "${inst_fort}"; then
echo 'GNU Fortran check...'
if which gfortran >/dev/null; then
echo 'installed.'
else
echo 'GNU Fortran install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y gfortran
echo 'Completed.'
echo 'gfortran > '$(gfortran --version | head -1)
fi
fi

###########################################################
# Python3+pip install
if "${inst_py}"; then
echo 'Python3 install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y python-dev python-tk pylint python-numpy python3.7 python3.7-dev python3-pip python3-tk python3-testresources python3-numpy flake8
echo "$PASSWORD" | sudo -S update-alternatives --install /usr/bin/python python $(which python3.7) 1
echo "$PASSWORD" | sudo -S python -m pip install --upgrade pip
echo 'Completed.'
echo 'python > '$(python -V)
echo 'pip > '$(pip -V)

# Install python packages
pip install numpy
pip install pandas
pip install matplotlib
pip install scikit-learn
pip install hmmlearn
pip install umap-learn
pip install tensorflow==2.7.0
pip install torch
pip install openpyxl
pip install python-docx
pip install python-pptx
pip install reportlab
pip install graphviz
pip install selenium
pip install beautifulsoup4
#pip install opencv-python # If you use only Python and CPU calculation, delete the head "#" and set "&inst_cv=false"(@line.26) 
fi

############################################################
# JAVA install
if "${inst_java}"; then
echo 'JDK check...'
if which java >/dev/null; then
echo 'installed.'
else
echo 'JAVA install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y ant default-jre default-jdk
echo 'Completed.'
echo 'java > '$(java -version)
fi
fi

###########################################################
# CUDA install
# *CUDA package (.deb) should be downloaded and copied to $TEMPORARY in advance.
# ex. (in case that you will install CUDA v11.5)
# $ wget https://developer.download.nvidia.com/compute/cuda/11.5.1/local_installers/cuda-repo-ubuntu1804-11-5-local_11.5.1-495.29.05-1_amd64.deb
# mv ./cuda-repo-ubuntu1804-*.deb $TEMPORARY

if "${inst_cuda}"; then
echo 'CUDA check...'
if which nvcc >/dev/null; then
echo 'installed.'
else
echo 'CUDA install'
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
echo "$PASSWORD" | sudo -S mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
cd $TEMPORARY
CUDA_PKG=$(ls cuda-repo-ubuntu1804-${CUDA_VER//./-}*.deb)
echo "$PASSWORD" | sudo -S dpkg -i $CUDA_PKG
cd /var/cuda-repo-ubuntu1804-${CUDA_VER//./-}-local
CUDA_PUB=$(ls ./*.pub)
echo "$PASSWORD" | sudo -S apt-key add $CUDA_PUB
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get -y install cuda-toolkit-${CUDA_VER//./-}
echo "$PASSWORD" | sudo -S update-alternatives --install /usr/bin/nvcc nvcc /usr/local/cuda/bin/nvcc 1
echo 'Completed.'
echo 'CUDA > '$(nvcc -V | tail -1)

# CuDNN install
# *cudnn source code (tarball) should be downloaded and copied to $TEMPORARY in advance.
# *To download cudnn source, NVIDIA account is required.
echo 'CuDNN install'
cd $TEMPORARY
tar -xvf cudnn-linux-x86_64-${CuDNN_VER}_cuda$CUDA_VER-archive.tar.xz
echo "$PASSWORD" | sudo -S cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include
echo "$PASSWORD" | sudo -S cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 
echo "$PASSWORD" | sudo -S chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
cd $WORK_SPACE
echo 'Completed.'
fi
fi

###########################################################
# Docker install
if "${inst_dock}"; then
echo 'Docker check...'
if which docker >/dev/null; then
echo 'installed.'
else
echo 'Docker install'
curl -fsSL -o gpgkey https://download.docker.com/linux/ubuntu/gpg
echo "$PASSWORD" | sudo -S gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg gpgkey
rm gpgkey
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > docklist
echo "$PASSWORD" | sudo -S mv docklist /etc/apt/sources.list.d/docker.list
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io
echo 'Completed.'
echo 'Docker > '$(docker --version)

# NVIDIA Docker install
echo 'NVIDIA Docker install'
distribution=$(. /etc/os-release;echo "$ID$VERSION_ID")
curl -s -L -o gpgkey https://nvidia.github.io/nvidia-docker/gpgkey
echo "$PASSWORD" | sudo -S apt-key add gpgkey
rm gpgkey
echo "$PASSWORD" | sudo -S curl -s -L -o /etc/apt/sources.list.d/nvidia-docker.list "https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list"
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -qq -y nvidia-docker2
echo "$PASSWORD" | sudo -S systemctl restart docker
echo 'Completed.'
fi
fi

###########################################################
# SQL Database install
if "${inst_sql}"; then
# MySQL install
echo 'MySQL check...'
if which mysql >/dev/null; then
echo 'installed.'
else
echo 'MySQL install'
echo "$PASSWORD" | sudo -S apt-get install -y mysql-server mysql-client
echo 'Completed.'
echo 'MySQL > '$(mysql --version)
fi
# SQLite3 install
echo 'SQLite3 check...'
if which sqlite3 >/dev/null; then
echo 'installed.'
else
echo 'SQLite3 install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y sqlite3 libsqlite3-dev
echo 'Completed.'
echo 'sqlite3 > '$(sqlite3 --version)
fi
fi

###########################################################
# Node+npm install
if "${inst_npm}"; then
echo 'Node check...'
if which npm >/dev/null; then
echo 'installed.'
else
echo 'Node+npm install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y nodejs npm
echo "$PASSWORD" | sudo -S npm install n -g
echo "$PASSWORD" | sudo -S n stable
echo "$PASSWORD" | sudo -S apt-get purge -y nodejs npm
echo 'Completed.'
echo 'Node.js > '$(node -v)
echo 'npm > '$(npm -v)
fi
fi

###########################################################
# R install
if "${inst_r}"; then
echo 'R check...'
if which R >/dev/null; then
echo 'installed.'
else
echo 'R install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
echo "$PASSWORD" | sudo -S wget -qO /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
echo "$PASSWORD" | sudo -S add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
echo "$PASSWORD" | sudo -S apt-get install -y --no-install-recommends r-base
echo 'Completed.'
echo 'R > '$(R --version | head -1)
fi
fi

###########################################################
# Graphviz install
if "${inst_gviz}"; then
echo 'Graphviz check...'
if which dot >/dev/null; then
echo 'installed.'
else
echo 'Graphviz install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y graphviz
echo 'Completed.'
echo 'Graphviz > '$(dot -V)
fi
fi

###########################################################
# OpenCV install
if "${inst_cv}"; then
echo 'OpenCV + contrib. install'
wget https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
unzip $OPENCV_VER.zip && rm $OPENCV_VER.zip
mv opencv-$OPENCV_VER OpenCV
wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip
unzip $OPENCV_VER.zip && rm $OPENCV_VER.zip
mv opencv_contrib-$OPENCV_VER opencv_contrib
cp -r opencv_contrib OpenCV
rm -r opencv_contrib
cd OpenCV
mkdir -p build
cd build
cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON \
      -DWITH_XINE=ON -DENABLE_PRECOMPILED_HEADERS=OFF \
      -DWITH_PYTHON=ON -DBUILD_opencv_python3=ON -DPYTHON_DEFAULT_EXECUTABLE=python3 \
      -DWITH_CUDA=ON -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON \
      -DWITH_CUDNN=ON -DWITH_NVCUVID=OFF -DOPENCV_DNN_CUDA=ON -DOPENCV_DNN_CUDA=OFF \
      -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ..
make -j8
echo "$PASSWORD" | sudo -S make install
echo "$PASSWORD" | sudo -S ldconfig
echo 'Completed.'
echo 'OpenCV > '$(pip list | grep opencv*)
fi

###########################################################
# FFmpeg install
if "${inst_ffmpeg}"; then
echo 'FFmpeg check...'
if which ffmpeg >/dev/null; then
echo 'installed.'
else
echo 'FFmpeg install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get -y install ffmpeg
echo 'Completed.'
echo 'ffmpeg > '$(ffmpeg -version | head -1)
fi
fi

###########################################################
# cURL install
if "${inst_curl}"; then
echo 'cURL check...'
if which curl >/dev/null; then
echo 'installed.'
else
echo 'cURL install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y curl
echo 'Completed.'
echo 'curl > '$(curl --version | head -1)
fi
fi

###########################################################
# cifs install
if "${inst_cifs}"; then
if which mount.cifs >/dev/null; then
echo 'installed.'
else
echo 'cifs install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y cifs-utils
echo 'Completed.'
echo 'cifs > '$(mount.cifs -V)
fi
fi

###########################################################
# doxygen install
if "${inst_dox}"; then
echo 'doxygen check...'
if which doxygen >/dev/null; then
echo 'installed.'
else
echo 'doxygen install'
echo "$PASSWORD" | sudo -S apt update
echo "$PASSWORD" | sudo -S apt install -y doxygen
echo 'Completed.'
echo 'doxygen > '$(doxygen --version)
fi
fi

###########################################################
# clam install
if "${inst_clam}"; then
echo 'clamAV check...'
if which clamd >/dev/null; then
echo 'installed.'
else
echo 'clamAV install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y clamav clamav-daemon
echo 'Completed.'
echo 'clamAV > '$(clamd -V)
fi
fi

###########################################################
# mozc install for Japanese input
if "${inst_mozc}"; then
echo 'mozc install'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y ibus-mozc
ibus-daemon -drx
echo 'Completed.'
fi

###########################################################
# SSH server install and start
# Firewall construction
if "${inst_ssh}"; then
echo 'SSH server install and start'
echo "$PASSWORD" | sudo -S apt-get update
echo "$PASSWORD" | sudo -S apt-get install -y ufw openssh-server
echo "$PASSWORD" | sudo -S systemctl enable ssh
echo "$PASSWORD" | sudo -S systemctl start ssh
echo 'Firewall start'
echo "$PASSWORD" | sudo -S systemctl start ufw
echo "$PASSWORD" | sudo -S ufw logging on
echo "$PASSWORD" | sudo -S ufw allow ssh
echo "$PASSWORD" | sudo -S ufw enable
echo 'Completed.'
fi

###########################################################
# Cleanup
echo "$PASSWORD" | sudo -S apt-get autoremove -y
echo 'Finished.'