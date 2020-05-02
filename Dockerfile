FROM centos:centos7.7.1908

RUN yum install epel-release -y

RUN rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm && \
  yum install mecab mecab-devel mecab-ipadic git make curl xz patch find which file openssl jq -y zip unzip --nogpg

# mecab-ipadic-neologd のセットアップ
RUN mkdir -p /mecab && \
    cd /mecab && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git

RUN cd /mecab/mecab-ipadic-neologd && \
  ./bin/install-mecab-ipadic-neologd -y -n && \
  echo `mecab-config --dicdir`"/mecab-ipadic-neologd"

# pythonのセットアップ
RUN yum install python3 -y && pip3 install jaconv mecab-python3

# マウント用フォルダ作成
RUN mkdir -p /assets
RUN mkdir -p /resourcepacks

# ファイルコピー
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

COPY ja2hiragana_1.12.py /ja2hiragana_1.12.py
COPY ja2hiragana_ge1.13.py /ja2hiragana_ge1.13.py

COPY pack_1.12.mcmeta /pack_1.12.mcmeta
COPY pack_1.13.mcmeta /pack_1.13.mcmeta
COPY pack_1.14.mcmeta /pack_1.14.mcmeta
COPY pack_1.15.mcmeta /pack_1.15.mcmeta
COPY pack_1.16.mcmeta /pack_1.16.mcmeta

ENTRYPOINT /entrypoint.sh
