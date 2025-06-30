sed -E -i.bak 's@!\[([^]]*)\]\((https?://[^)]+/([^/)\?#]+\.(png|jpg|jpeg|gif|svg)))\)@![\1](/img/cloud-desktop/\3)@gi' "vGPU云桌面QA.md"
# 替换所有md文件图片路径	
#find . -name "*.md" -exec sed -E -i.bak 's@!\[([^]]*)\]\((https?://[^)]+/([^/)\?#]+\.(png|jpg|jpeg|gif|svg)))\)@![\1](/img/cloud-desktop/\3)@gi' {} +

