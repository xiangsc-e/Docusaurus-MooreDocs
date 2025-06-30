#!/bin/bash

# 设置输入文件和输出目录
INPUT_MD="/root/my-website/docs/vGPU云桌面/vGPU云桌面QA.md"
OUTPUT_DIR="/root/my-website/static/img/cloud-desktop"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 使用 grep + sed 提取图片 URL
grep -oE '!\[.*?\]\((https?://[^)]*)\)' "$INPUT_MD" | \
  sed -E 's/!\[.*\]\((https?:\/\/[^)]*)\)/\1/' | while read -r url; do
    echo "📥 下载: $url"
    filename=$(basename "$url")
    curl -fSL "$url" \
      -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
      -H "Referer: https://alidocs.dingtalk.com" \
      -o "$OUTPUT_DIR/$filename"
    
    if [ $? -eq 0 ]; then
      echo "✅ 成功: $filename"
    else
      echo "❌ 失败: $url"
    fi
done
