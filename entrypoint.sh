#!/bin/bash

# MinecraftのAssetsフォルダのマウントフォルダ
MINECRAFT_ASSET=/assets

# リソースパックの出力先マウントフォルダ
RESOURCEPACK_OUTPUT_DIR=/resourcepacks

echo "MINECRAFT_VERSION:$MINECRAFT_VERSION"
if [ -z "$MINECRAFT_VERSION" ]; then
    echo "The environment variable MINECRAFT_VERSION is required."
    exit 1;
fi

case "$MINECRAFT_VERSION" in
  "1.12" ) HI_JP_FILE_NAME="hi_jp.lang"
           CONVERT_SCRIPT="/ja2hiragana_1.12.py"
           PACK_FILE="pack_1.12.mcmeta"
           JA_JP_LANG_HASH_KEY="minecraft/lang/ja_jp.lang";;

# 1.13以降はひとまとめ
  * )      HI_JP_FILE_NAME="hi_jp.json"
           CONVERT_SCRIPT="/ja2hiragana_ge1.13.py"
           PACK_FILE="pack_$MINECRAFT_VERSION.mcmeta"
           JA_JP_LANG_HASH_KEY="minecraft/lang/ja_jp.json";;
esac

echo "HI_JP_FILE_NAME:$HI_JP_FILE_NAME"
echo "CONVERT_SCRIPT:$CONVERT_SCRIPT"
echo "PACK_FILE:$PACK_FILE"

# 対象バージョンのインデックスjsonファイルを特定
INDEX_JSON_PATH=`find $MINECRAFT_ASSET/indexes | grep $MINECRAFT_VERSION`
echo "INDEX_JSON_PATH:$INDEX_JSON_PATH"

# ja_jpの言語ファイル情報を取得
JA_JP_LANG_HASH=`jq ".objects.\"${JA_JP_LANG_HASH_KEY}\".hash" $INDEX_JSON_PATH | sed 's/^\"\(.*\)\"$/\1/'`
echo "JA_JP_LANG_HASH:$JA_JP_LANG_HASH"

JA_JP_LANG_DIR=`echo $JA_JP_LANG_HASH | awk '{print substr( $0, 0, 2)}'`
echo "JA_JP_LANG_DIR:$JA_JP_LANG_DIR"

JA_JP_LANG_PATH=$MINECRAFT_ASSET/objects/$JA_JP_LANG_DIR/$JA_JP_LANG_HASH
echo "JA_JP_LANG_PATH:$JA_JP_LANG_PATH"

env

echo "ja_JP.lang:$JA_JP_LANG_PATH"
if [ -z "$JA_JP_LANG_PATH" ]; then
    echo "ja_JP.lang not found."
    exit 1;
fi

# mecab-ipadic-neologd の辞書パスを取得
NEOLOGD_PATH=`mecab-config --dicdir`"/mecab-ipadic-neologd"

echo "neologd:$NEOLOGD_PATH"
if [ -z "$NEOLOGD_PATH" ]; then
    echo "mecab-ipadic-neologd dic not found."
    exit 1;
fi

# 日本語言語ファイルを平仮名言語ファイルに変換
python3 $CONVERT_SCRIPT $NEOLOGD_PATH $JA_JP_LANG_PATH

# リソースファイル作成
rm -rf /tmp/hiragana/assets/minecraft/lang/
mkdir -p /tmp/hiragana/assets/minecraft/lang/
cp hi_jp.lang /tmp/hiragana/assets/minecraft/lang/$HI_JP_FILE_NAME
cp $PACK_FILE /tmp/hiragana/pack.mcmeta
RESOURCE_FILE=hiragana_$MINECRAFT_VERSION.zip
cd /tmp/hiragana
zip -r /tmp/$RESOURCE_FILE *

# 出力
rm -f $RESOURCEPACK_OUTPUT_DIR/$RESOURCE_FILE
cp /tmp/$RESOURCE_FILE $RESOURCEPACK_OUTPUT_DIR/$RESOURCE_FILE
