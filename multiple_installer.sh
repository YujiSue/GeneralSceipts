#!/bin/sh

###########################################################
# *libjasper-dev is not installed by this script. JPEG-2000 format is not available.
# *If you get a timeout error when fetching packages, add the option '-o Acquire::http::Timeout="300"' to the end of each apt command.
echo 'Preparation'
sudo add-apt-repository "deb http://security.ubuntu.com/ubuntu bionic-security main"
sudo apt update
sudo apt -y upgrade
sudo apt install -y build-essential ca-certificates gnupg lsb-release uuid-dev xz-utils wget zip unzip zlib1g zlib1g-dev \
libbz2-dev libboost-dev libdb-dev libreadline-dev libffi-dev libgdbm-dev \
libjpeg-dev liblzma-dev libpng-dev libtiff5-dev libwebp-dev \
libopenexr-dev libgdal-dev \
libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev \
libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev \
libncurses5-dev libncursesw5-dev libtbb-dev libeigen3-dev libssl-dev \
libvtk6-dev qt5-default tk-dev

###########################################################
#Version check

CMAKE_VER=3.22.1
CUDA_VER=11.5
CuDNN_VER=8.3.1.22
OPENCV_VER=4.5.5
PYTHON_VER=3.7.x
#Directory set
WORK_SPACE=$(echo $HOME)
TEMPORARY=$WORK_SPACE/Downloads

###########################################################
#mozc install for Japanese input
echo 'mozc install'
sudo apt update
sudo apt install -y ibus-mozc
ibus-daemon -d -x
echo 'Completed.'

###########################################################
#git install
echo 'git install'
sudo apt update
sudo apt install -y git
echo 'Completed.'

###########################################################
#Clang install
echo 'Clang install'
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
sudo update-alternatives --install /usr/bin/clang clang $(which /usr/bin/clang-* | head -1) 1
echo 'Completed.'

###########################################################
#CMake install
echo 'CMake install'
cd $TEMPORARY
echo 'Download source'
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/cmake-$CMAKE_VER.tar.gz
tar zxvf cmake-$CMAKE_VER.tar.gz
cd cmake-$CMAKE_VER/
echo 'Make start'
./bootstrap
make -j8
sudo make install
rm -r cmake*
cd $WORK_SPACE
echo 'Completed.'

###########################################################
#doxygen install
echo 'doxygen install'
sudo apt update
sudo apt install -y doxygen
echo 'Completed.'

###########################################################
#Python3+pip install
# *pyinstall.sh should be copied to home directory in advance.
echo 'Python3 install'
sudo apt update
sudo apt install -y python-dev python-tk pylint python-numpy python3.7 python3.7-dev python3-pip python3-tk python3-testresources python3-numpy flake8
sudo update-alternatives --install /usr/bin/python python $(which python3.7) 1
sudo python -m pip install --upgrade pip
echo 'Completed.'

###########################################################
#CUDA install
echo 'CUDA install'
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.5.1/local_installers/cuda-repo-ubuntu1804-11-5-local_11.5.1-495.29.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-5-local_11.5.1-495.29.05-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu1804-11-5-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
sudo update-alternatives --install /usr/bin/nvcc nvcc /usr/local/cuda/bin/nvcc 1
echo 'Completed.'

###########################################################
#CuDNN install
# *cudnn source code (tarball) should be downloaded and copied to $TEMPORARY in advance.
# *To download cudnn source, NVIDIA account is required.
echo 'CuDNN install'
cd $TEMPORARY
tar -xvf cudnn-linux-x86_64-${CuDNN_VER}_cuda$CUDA_VER-archive.tar.xz
sudo cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include
sudo cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*
cd $WORK_SPACE
echo 'Completed.'

###########################################################
#SQLite3 install
echo 'SQLite3 install'
sudo apt update
sudo apt install sqlite3 libsqlite3-dev
echo 'Completed.'

###########################################################
#FFmpeg install
echo 'FFmpeg install'
sudo apt update
sudo apt install ffmpeg
echo 'Completed.'

###########################################################
#cURL install
echo 'cURL install'
sudo apt update
sudo apt install -y curl
echo 'Completed.'

###########################################################
#SSH server install and Firewall construction
echo 'SSH server install'
sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl start ufw
sudo ufw logging on
sudo ufw allow ssh
sudo ufw enable
echo 'Completed.'

###########################################################
#cifs install
echo 'cifs install'
sudo apt update
sudo apt install -y cifs-utils
echo 'Completed.'

###########################################################
#clam install
echo 'clamAV install'
sudo apt update
sudo apt install -y clamav clamav-daemon
echo 'Completed.'

###########################################################
#Node+npm install
echo 'Node+npm install'
sudo apt update
sudo apt install -y nodejs npm
sudo npm install n -g
sudo n stable
sudo apt purge -y nodejs npm
echo 'Completed.'

###########################################################
#Docker install
echo 'Docker install'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
echo 'Completed.'

###########################################################
#R install
echo 'R install'
sudo apt update
sudo apt install -y --no-install-recommends software-properties-common dirmngr
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install -y --no-install-recommends r-base
echo 'Completed.'

###########################################################
#JAVA install
echo 'JAVA install'
sudo apt update
sudo apt install -y ant default-jre default-jdk
echo 'Completed.'

###########################################################
#OpenCV install
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
sudo make install
sudo ldconfig
echo 'Completed.'

###########################################################
# Install python packages
pip install numpy
pip install pandas
pip install matplotlib
pip install opencv-python
pip install scikit-learn
pip install hmmlearn
pip install umap-learn
pip install tensorflow==2.7.0
pip install torch
pip install openpyxl
pip install python-docx
pip install python-pptx
pip install reportlab
pip install HTSeq
pip install selenium
pip install beautifulsoup4

sudo apt autoremove -y

###########################################################
#Check version
echo 'Full install completed.'
echo 'clang > '$(clang --version | head -1)
echo 'CUDA > '$(nvcc -V | tail -1)
echo 'python > '$(python -V)
echo 'pip > '$(pip -V)
echo 'java > '$(java -version)
echo 'cmake > '$(cmake --version | head -1)
echo 'doxygen > '$(doxygen --version)
echo 'mozc > '$(ibus-daemon -V)
echo 'git > '$(git --version)
echo 'cifs > '$(mount.cifs -V)
echo 'clamAV > '$(clamd -V)
echo 'Node.js > '$(node -v)
echo 'npm > '$(npm -v)
echo 'Docker > '$(docker --version)
echo 'OpenCV > '$(pip list | grep opencv*)
echo 'sqlite3 > '$(sqlite3 --version)
echo 'ffmpeg > '$(ffmpeg -version | head -1)
echo 'curl > '$(curl --version | head -1)
echo 'R > '$(R --version | head -1)
