import os
import subprocess
from subprocess import PIPE

# ソフトとバージョン一覧
bwa_ver = '0.7.17'
tvc_ver = '5.12.1'
samtool_ver = '1.14'
bcftool_ver = '1.14'
picard_ver = '2.26.9'
GATK_ver = '4.2.4.0'
bowtie_ver = '2.4.4'
star_ver = '2.7.9a'
cuff_ver = '2.2.1'
MACS_ver = '2.2.7.1'
meme_ver = '5.4.1'

# ディレクトリの準備
WORK_SPACE = os.environ.get("HOME")
APPS = WORK_SPACE+'/MyApp'
TEMPORAL = WORK_SPACE+'/Downloads'
REFERENCE_DIR = WORK_SPACE+'/Reference'
PREFERENCE_DIR = WORK_SPACE+'/Preference'
TEST_DIR = WORK_SPACE+'/Test'
TEST_OUT_DIR = WORK_SPACE+'/Test/output'

os.makedirs(APPS,exist_ok=True)
os.makedirs(TEMPORAL,exist_ok=True)
os.makedirs(REFERENCE_DIR,exist_ok=True)
os.makedirs(PREFERENCE_DIR,exist_ok=True)
os.makedirs(TEST_DIR,exist_ok=True)
os.makedirs(TEST_OUT_DIR,exist_ok=True)
os.environ['PATH'] += ':'+APPS 

# 各ソフトのインストール用関数の定義
def checkBWA():
  return os.path.exists(APPS+'/bwa')

def installBWA():
  print('BWAのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://jaist.dl.sourceforge.net/project/bio-bwa/bwa-'+bwa_ver+'.tar.bz2', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/bwa-'+bwa_ver+'.tar.bz2'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('tar xvf ./bwa-'+bwa_ver+'.tar.bz2', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.chdir(TEMPORAL+'/bwa-'+bwa_ver)
  proc = subprocess.run('make -j8', shell=True)
  if proc.returncode == 0:
    proc = subprocess.run('cp bwa '+APPS, shell=True)
  if proc.returncode == 0:
    print('コンパイル完了') 
  else:
    print('コンパイルに失敗しました')
    return
  proc = subprocess.run('rm -r '+TEMPORAL+'/bwa*', shell=True)
  os.chdir(WORK_SPACE)
  print('インストール完了')
  proc = subprocess.run('bwa', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  lines = proc.stderr.splitlines()
  for line in lines:
    if line != '':
      print('> ', line)
    if line.startswith('Version'):
      break

def installArmadillo4TVC(dir):
  os.chdir(dir)
  proc = subprocess.run('wget http://updates.iontorrent.com/updates/software/external/armadillo-4.600.1.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('tar xvzf armadillo-4.600.1.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  os.chdir('armadillo-4.600.1')
  proc = subprocess.run("sed -i 's:^// #define ARMA_USE_LAPACK$:#define ARMA_USE_LAPACK:g' include/armadillo_bits/config.hpp", shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run("sed -i 's:^// #define ARMA_USE_BLAS$:#define ARMA_USE_BLAS:g'     include/armadillo_bits/config.hpp", shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('cmake .', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('make -j8', shell=True, stdout=PIPE, stderr=PIPE, text=True)

def installBamtools4TVC(dir):
  os.chdir(dir)
  proc = subprocess.run('wget updates.iontorrent.com/updates/software/external/bamtools-2.4.0.20150702+git15eadb925f.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('tar xvzf bamtools-2.4.0.20150702+git15eadb925f.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  os.makedirs('bamtools-2.4.0.20150702+git15eadb925f-build')
  os.chdir('bamtools-2.4.0.20150702+git15eadb925f-build')
  proc = subprocess.run('cmake ../bamtools-2.4.0.20150702+git15eadb925f -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('make -j8', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  
def installHTSlib4TVC(dir):
  os.chdir(dir)
  proc = subprocess.run('wget --no-check-certificate https://github.com/samtools/htslib/archive/1.2.1.tar.gz -O htslib-1.2.1.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('tar xvzf htslib-1.2.1.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('ln -s htslib-1.2.1 htslib', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  os.chdir('htslib-1.2.1')
  proc = subprocess.run('make -j8', shell=True, stdout=PIPE, stderr=PIPE, text=True)

def installSamtools4TVC(dir, dest):
  os.chdir(dir)
  proc = subprocess.run('wget --no-check-certificate https://github.com/samtools/samtools/archive/1.2.tar.gz -O samtools-1.2.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('tar xvzf samtools-1.2.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  os.chdir('samtools-1.2')
  proc = subprocess.run('make -j8', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('cp ./samtools '+dest, shell=True, stdout=PIPE, stderr=PIPE, text=True)
  
def checkTVC():
  return os.path.exists(APPS+'/TVC/bin/tvc')

def installTVC():
  print('TorrentSutio VariantCallerのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget updates.iontorrent.com/tvc_standalone/tvc-'+tvc_ver+'.tar.gz', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/tvc-'+tvc_ver+'.tar.gz'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  build = TEMPORAL+'/temp'
  os.makedirs(build,exist_ok=True)
  proc = subprocess.run('cp '+TEMPORAL+'/tvc-'+tvc_ver+'.tar.gz '+build+'/tvc-'+tvc_ver+'.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  install = APPS+'/TVC'
  os.makedirs(install,exist_ok=True)
  os.makedirs(install+'/bin',exist_ok=True)
  print('armadilloインストール') 
  installArmadillo4TVC(build)
  print('Bamtoolsインストール') 
  installBamtools4TVC(build)
  print('HTSlibインストール') 
  installHTSlib4TVC(build)
  print('Samtools(TVC用)インストール') 
  installSamtools4TVC(build, install+'/bin/')
  os.chdir(build)
  proc = subprocess.run('tar xvzf ./tvc-'+tvc_ver+'.tar.gz', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('ソースファイルの解凍完了') 
  os.makedirs(build+'/build',exist_ok=True)
  os.chdir(build+'/build')
  proc = subprocess.run('cmake '+build+'/tvc-'+tvc_ver+' -DCMAKE_INSTALL_PREFIX:PATH='+install+' -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('cmake完了') 
  proc = subprocess.run('make -j8 install', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('コンパイル完了') 
  os.environ['PATH'] += ':'+APPS+'/TVC/bin'
  proc = subprocess.run('cp '+build+'/tvc-'+tvc_ver+'/share/TVC/examples/example1/reference* '+REFERENCE_DIR, shell=True)
  proc = subprocess.run('cp '+build+'/tvc-'+tvc_ver+'/share/TVC/examples/example1/test* '+TEST_DIR, shell=True)
  proc = subprocess.run('cp '+build+'/tvc-'+tvc_ver+'/share/TVC/pluginMedia/configs/* '+PREFERENCE_DIR, shell=True)
  proc = subprocess.run('cp '+build+'/tvc-'+tvc_ver+'/share/TVC/sse/* '+PREFERENCE_DIR, shell=True)
  proc = subprocess.run(APPS+'/TVC/bin/samtools bam2fq'+TEST_DIR+'/test.bam > '+TEST_DIR+'/test.fq', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('rm -r '+build, shell=True)
  proc = subprocess.run('rm '+TEMPORAL+'/tvc*', shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('tvc --version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stdout.splitlines()[0])

def checkSamtools():
  return os.path.exists('/usr/local/bin/samtools')

def installSamtools():
  print('Samtoolsのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://github.com/samtools/samtools/releases/download/'+samtool_ver+'/samtools-'+samtool_ver+'.tar.bz2', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/samtools-'+samtool_ver+'.tar.bz2'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('tar xvf ./samtools-'+samtool_ver+'.tar.bz2', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.chdir(TEMPORAL+'/samtools-'+samtool_ver)
  proc = subprocess.run('./configure', shell=True)
  if proc.returncode == 0:
    proc = subprocess.run('make -j8', shell=True)
  if proc.returncode == 0:
    print('コンパイル完了') 
  else:
    print('コンパイルに失敗しました')
    return
  proc = subprocess.run('sudo make install', shell=True)
  proc = subprocess.run('cp '+TEMPORAL+'/samtools-'+samtool_ver+'/examples/ex1.fa '+REFERENCE_DIR, shell=True)
  proc = subprocess.run('gunzip '+TEMPORAL+'/samtools-'+samtool_ver+'/examples/ex1.sam.gz', stdout=PIPE, stderr=PIPE, shell=True)
  proc = subprocess.run('cp '+TEMPORAL+'/samtools-'+samtool_ver+'/examples/ex1.sam ' +TEST_DIR, stdout=PIPE, stderr=PIPE, shell=True)
  proc = subprocess.run('rm -r '+TEMPORAL+'/samtools*', shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('samtools view -b -T '+REFERENCE_DIR+'/ex1.fa -o '+TEST_DIR+'/ex1.bam '+TEST_DIR+'/ex1.sam', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('samtools fastq '+TEST_DIR+'/ex1.bam > '+TEST_DIR+'/ex1.fq', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  proc = subprocess.run('samtools --version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stdout.splitlines()[0])

def checkBCFtools():
  return os.path.exists('/usr/local/bin/bcftools')

def installBCFtools():
  print('BCFtoolsのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://github.com/samtools/bcftools/releases/download/'+bcftool_ver+'/bcftools-'+bcftool_ver+'.tar.bz2', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/bcftools-'+bcftool_ver+'.tar.bz2'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('tar xvf ./bcftools-'+bcftool_ver+'.tar.bz2', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.chdir(TEMPORAL+'/bcftools-'+bcftool_ver)
  proc = subprocess.run('./configure', shell=True)
  if proc.returncode == 0:
    proc = subprocess.run('make -j8', shell=True)
  if proc.returncode == 0:
    print('コンパイル完了') 
  else:
    print('コンパイルに失敗しました')
    return
  proc = subprocess.run('sudo make install', shell=True)
  proc = subprocess.run('rm -r '+TEMPORAL+'/bcftools*', shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('bcftools --version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stdout.splitlines()[0])

def checkPicard():
  return os.path.exists(APPS+'/picard.jar')

def installPicard():
  print('Picardのインストール開始')
  print('jarファイルのダウンロード開始') 
  proc = subprocess.run('wget https://github.com/broadinstitute/picard/releases/download/'+picard_ver+'/picard.jar -O '+APPS+'/picard.jar', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(APPS+'/picard.jar'):
    print('ダウンロード完了') 
  else:
    print('ダウンロードに失敗しました')
    return
  os.chdir(WORK_SPACE)
  proc = subprocess.run('java -jar '+APPS+'/picard.jar MarkDuplicates --version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stderr)

def checkGATK():
  return os.path.exists(APPS+'/gatk')

def installGATK():
  print('GATKのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://github.com/broadinstitute/gatk/releases/download/'+GATK_ver+'/gatk-'+GATK_ver+'.zip', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/gatk-'+GATK_ver+'.zip'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('unzip -o ./gatk-'+GATK_ver+'.zip', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.makedirs(APPS+'/gatk',exist_ok=True)
  os.environ['PATH'] += ':'+APPS+'/gatk'
  proc = subprocess.run('mv ./gatk-'+GATK_ver+'/* '+APPS+'/gatk', shell=True)
  proc = subprocess.run('rm -r '+TEMPORAL+'/gatk*', shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('gatk --list', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stderr.splitlines()[0])

def checkBowtie():
  return os.path.exists('/usr/local/bin/bowtie2')

def installBowtie():
  print('Bowtie2のインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://jaist.dl.sourceforge.net/project/bowtie-bio/bowtie2/'+bowtie_ver+'/bowtie2-'+bowtie_ver+'-source.zip', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/bowtie2-'+bowtie_ver+'-source.zip'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('unzip -o ./bowtie2-'+bowtie_ver+'-source.zip', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.chdir(TEMPORAL+'/bowtie2-'+bowtie_ver)
  proc = subprocess.run('make -j8', shell=True)
  if proc.returncode == 0:
    proc = subprocess.run('sudo make install', shell=True)
  if proc.returncode == 0:
    print('コンパイル完了') 
  else:
    print('コンパイルに失敗しました')
    return
  os.chdir(TEMPORAL)
  proc = subprocess.run('rm -r ./bowtie2*', shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('bowtie2 --version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stdout.splitlines()[0])

def checkSTAR():
  return os.path.exists(APPS+'/STAR')

def installSTAR():
  print('STARのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://github.com/alexdobin/STAR/archive/'+star_ver+'.tar.gz', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/'+star_ver+'.tar.gz'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('tar xvf ./'+star_ver+'.tar.gz', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.chdir(TEMPORAL+'/STAR-'+star_ver+'/source')
  proc = subprocess.run('make -j8 STAR', shell=True)
  if proc.returncode == 0:
    print('コンパイル完了') 
  else:
    print('コンパイルに失敗しました')
    return
  proc = subprocess.run('cp STAR '+APPS, shell=True)
  proc = subprocess.run('rm -r '+TEMPORAL+'/STAR*', shell=True)
  proc = subprocess.run('rm '+TEMPORAL+'/'+star_ver+'*', shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('STAR', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  lines = proc.stdout.splitlines()
  for line in lines:
    if ("version" in line) :
      print('> ', line)
      break

def checkCuff():
  return os.path.exists(APPS+'/cuff/cufflinks')

def installCuff():
  print('Cufflinksのインストール開始')
  os.chdir(TEMPORAL)
  print('バイナリファイルのダウンロード開始') 
  proc = subprocess.run('wget http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-'+cuff_ver+'.Linux_x86_64.tar.gz', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/cufflinks-'+cuff_ver+'.Linux_x86_64.tar.gz'):
    print('バイナリファイルのダウンロード完了') 
  else:
    print('バイナリファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('tar xvf ./cufflinks-'+cuff_ver+'.Linux_x86_64.tar.gz', shell=True)
  if proc.returncode == 0:
    print('バイナリファイルの解凍完了') 
  else:
    print('バイナリファイルの解凍に失敗しました')
    return
  os.makedirs(APPS+'/cuff',exist_ok=True)
  os.environ['PATH'] += ':'+APPS+'/cuff'
  proc = subprocess.run('mv ./cufflinks-'+cuff_ver+'.Linux_x86_64/* '+APPS+'/cuff', shell=True)
  proc = subprocess.run('rm -r ./cufflinks*', shell=True)
  proc = subprocess.run('cufflinks', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stderr.splitlines()[0])

def checkMACS():
  return os.path.exists('/usr/local/bin/macs2')

def installMACS():
  print('MACS2のインストール開始')
  proc = subprocess.run('pip install macs2', stdout=PIPE, stderr=PIPE, shell=True)
  os.chdir(WORK_SPACE)
  proc = subprocess.run('source ~/.profile', stdout=PIPE, stderr=PIPE, shell=True)
  proc = subprocess.run('macs2 --version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  print('インストール完了')
  print('> ', proc.stdout.splitlines()[0])

def checkMEME():
  return os.path.exists(APPS+'/meme/bin/meme')

def installMEME():
  print('MEME Suiteのインストール開始')
  os.chdir(TEMPORAL)
  print('ソースファイルのダウンロード開始') 
  proc = subprocess.run('wget https://meme-suite.org/meme/meme-software/'+meme_ver+'/meme-'+meme_ver+'.tar.gz', stdout=PIPE, stderr=PIPE, shell=True)
  if proc.returncode == 0 and os.path.exists(TEMPORAL+'/meme-'+meme_ver+'.tar.gz'):
    print('ソースファイルのダウンロード完了') 
  else:
    print('ソースファイルのダウンロードに失敗しました')
    return
  proc = subprocess.run('tar zxf ./meme-'+meme_ver+'.tar.gz', shell=True)
  if proc.returncode == 0:
    print('ソースファイルの解凍完了') 
  else:
    print('ソースファイルの解凍に失敗しました')
    return
  os.chdir('./meme-'+meme_ver)
  proc = subprocess.run('./configure --prefix='+APPS+'/meme --enable-build-libxml2 --enable-build-libxslt', shell=True)
  proc = subprocess.run('make', shell=True)
  proc = subprocess.run('make test', shell=True)
  proc = subprocess.run('sudo make install', shell=True)
  if proc.returncode == 0:
    print('コンパイル完了') 
  else:
    print('コンパイルに失敗しました')
    return
  os.environ['PATH'] += ':'+APPS+'/meme/bin'
  os.chdir(TEMPORAL)
  proc = subprocess.run('rm -r ./meme*', shell=True)
  proc = subprocess.run('meme -version', shell=True, stdout=PIPE, stderr=PIPE, text=True)
  os.chdir(WORK_SPACE)
  print('インストール完了')
  print('> MEME Suite', proc.stdout.splitlines()[0])


# Main
hasBWA = checkBWA()
print('BWAのチェック...', 'Installed.' if hasBWA else 'Not installed.')
if hasBWA == False:
  installBWA()

hasTVC = checkTVC()
print('TVCのチェック...', 'Installed.' if hasTVC else 'Not installed.')
if hasTVC == False:
  installTVC()

hasST = checkSamtools()
print('samtoolsのチェック...', 'Installed.' if hasST else 'Not installed.')
if hasST == False:
  installSamtools()

hasBT = checkBCFtools()
print('BCFtoolsのチェック...', 'Installed.' if hasBT else 'Not installed.')
if hasBT == False:
  installBCFtools()

hasPicard = checkPicard()
print('Picardのチェック...', 'Installed.' if hasPicard else 'Not installed.')
if hasPicard == False:
  installPicard()

hasGATK = checkGATK()
print('GATKのチェック...', 'Installed.' if hasGATK else 'Not installed.')
if hasGATK == False:
  installGATK()

hasBT = checkBowtie()
print('bowtie2のチェック...', 'Installed.' if hasBT else 'Not installed.')
if hasBT == False:
  installBowtie()

hasSTAR = checkSTAR()
print('STARのチェック...', 'Installed.' if hasSTAR else 'Not installed.')
if hasSTAR == False:
  installSTAR()

hasCuff = checkCuff()
print('Cufflinksのチェック...', 'Installed.' if hasCuff else 'Not installed.')
if hasCuff == False:
  installCuff()
  
hasMACS = checkMACS()
print('MACS2のチェック...', 'Installed.' if hasMACS else 'Not installed.')
if hasMACS == False:
  installMACS()
  
hasMEME = checkMEME()
print('MEMEのチェック...', 'Installed.' if hasMEME else 'Not installed.')
if hasMEME == False:
  installMEME()
