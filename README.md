# 概要

Minecraft Java Edition の日本語リソースパックを元に、ひらがなのリソースパックを作るツールです。<br>
プレースホルダー文字(%s等)を含むものは未対応としています。<br>

Minecraft Java Edition の対応バージョン
- 1.12
- 1.13
- 1.14
- 1.15
- 1.16

# 使用準備

リソースパックを作りたいバージョンのMinecraft Java Editionを実行しておきます。<br>
Dockerが利用できる環境を準備しておきます。<br>

下記Docker環境で動作確認しています。

- Windows 10 Pro バージョン 2004
   - Docker Desktop for Windows 2.2.0.5(43884)

- Ubuntu 18.04(Windows Subsystem for Linux)
   - Docker version 18.09.7, build 2d0083d 

# 使用方法

**Windowsでの実行:**

```bash
# windowsのユーザー名は [username] としています。
# 使用するときは環境に合わせて置き換えてください。
docker run -v /c/Users/noguo/AppData/Roaming/.minecraft/assets:/assets:ro -v /c/Users/noguo/AppData/Roaming/.minecraft/resourcepacks:/resourcepacks:rw -e "MINECRAFT_VERSION=1.12" docker.pkg.github.com/n-noguchi/mc-hiragana-resourcepack-builder/mc-hiragana-resourcepack-builder:1.0.0
```

**Ubuntu 18.04 (Windows Subsystem for Linux)での実行:**

```bash
# windowsのユーザー名は [username] としています。
# 使用するときは環境に合わせて置き換えてください。
docker run -v /mnt/c/Users/[username]/AppData/Roaming/.minecraft/assets:/assets:ro \
-v /mnt/c/Users/[username]/AppData/Roaming/.minecraft/resourcepacks:/resourcepacks:rw \
-e "MINECRAFT_VERSION=1.12" docker.pkg.github.com/n-noguchi/mc-hiragana-resourcepack-builder/mc-hiragana-resourcepack-builder:1.0.0

```

## パラメーター

**環境変数 MINECRAFT_VERSION**

Minecraftのバージョンを指定します。<br>
以下を指定可能です。<br>
パッチバージョンは指定できません。（Minecraftバージョンのドットで区切られた3つ目の数字です）<br>

指定可能なバージョン

- 1.12
- 1.13
- 1.14
- 1.15
- 1.16

**ボリューム /assets**

Minecraftのassetsフォルダをマウントします。<br>
Minecraft付属の日本語言語ファイル参照のために必要です。<br>
Windowsの場合は以下のパスです。<br>

`/mnt/c/Users/[username]/AppData/Roaming/.minecraft/assets`

**ボリューム /resourcepacks**

リソースパックの出力先をマウントします。<br>
実行後、このディレクトリにリソースパックファイルが出力されます。<br>
出力先にリソースパックが既に存在する場合は上書きします。<br>
Minecraftのリソースパック格納先フォルダをマウントすると楽です。<br>

`/mnt/c/Users/[username]/AppData/Roaming/.minecraft/resourcepacks`

## 作成されるリソースパック

**ファイル名**

出力されるファイルは以下の名前です。<br>

`hiragana_[Minecraftバージョン].zip`

**リソースパック名**

Minecraft内でリソースパック画面上表示される名称は以下です。

`Hiragana (Minecraft [Minecraftバージョン])`

**言語名**

Minecraft内での言語設定画面に表示される名称は以下です。

`にほんご（ひらがな）`
