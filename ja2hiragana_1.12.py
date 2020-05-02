import sys
import jaconv
import json
import MeCab

# argv[1] : mecab dictionary directory
# argv[2] : original ja_JP.lang file

# -Oyomi 読みのみの出力
# -d 辞書のパス指定
mecab_yomi = MeCab.Tagger("-Oyomi -d {0}".format(sys.argv[1]))

result = []

with open(sys.argv[2], 'r', encoding='utf-8') as f:
  read_data = f.readlines()
  for line in read_data:
    split = line.split('=')
    key = split[0]
    value = split[1]

    # プレースホルダーを含む文字は平仮名変換はしない
    if('%' in value):
        continue

    katakana_value = mecab_yomi.parse(value).strip()
    hiragana_value = jaconv.kata2hira(katakana_value)
    result.append("{0}={1}\n".format(key, hiragana_value))

# save
with open('./hi_jp.lang', 'a', encoding='utf-8') as f:
    for line in result:
      f.write(line)
