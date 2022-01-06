English/日本語
# GeneralScripts
## Introduction / はじめに


## About scripts / 各スクリプトについて

1. multiple_installer.sh


|Name / 名称|Version / バージョン|
|---|---|
|[clang](https://github.com/llvm/llvm-project)|13.0.1|
|[cmake](https://cmake.org/)|3.22.1|
|[Docker](https://docs.docker.com/)|20.10.12|
|[CUDA](https://developer.nvidia.com/cuda-toolkit)|11.5|
|[CuDNN](https://developer.nvidia.com/cudnn)|8.3|
|[Chrome](https://www.google.com/intl/ja_jp/chrome/)|Stable latest|
|[sqlite3](https://www.sqlite.org/index.html)|3.22.0|
|[java](https://openjdk.java.net/)|11.0.13|
|[ImageJ](https://imagej.nih.gov/ij/index.html)|1.53k|
|[ffmpeg](https://ffmpeg.org/)|3.4.8|
|[OpenCV](https://opencv.org/)|4.5.5|
|[cURL](https://curl.se/)|7.58.0|
|[clamAV](http://www.clamav.net/)|0.103.2|
|[R](https://www.r-project.org/)|4.1.2|
|[Python3](https://www.python.org/)|3.7.5|
|[pip](https://pypi.org/project/pip/)|21.3.1|
|[Node.js](https://nodejs.org/ja/)|16.13.1|
|[npm](https://www.npmjs.com/)|8.1.2|
|[cifs](http://cifs.com/jp/)|6.8|
|[VSCode](https://azure.microsoft.com/ja-jp/products/visual-studio-code/)|1.63.2|
|[TorrentSuite VaraintCaller](http://updates.iontorrent.com/tvc_standalone/)|5.12|
|[SAMtools](https://github.com/samtools/samtools)|1.14|
|[BWA](https://sourceforge.net/projects/bio-bwa/files/)|0.7.17|
|[Picard](https://broadinstitute.github.io/picard/)|2.26.9|
|[GATK](https://gatk.broadinstitute.org/hc/en-us)|4.2.4.0|
|[Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)|2.4.4|
|[STAR](https://github.com/alexdobin/STAR)|2.7.9a|
|[IGV](https://software.broadinstitute.org/software/igv/)|2.11.9|
|[Cufflinks](https://github.com/cole-trapnell-lab/cufflinks)|2.2.1|
|[MACS](https://github.com/macs3-project/MACS)|2.2.7.1|
|[MEME Suite](https://meme-suite.org/meme/)|5.4.1|

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
### Run script / スクリプトの実行


