#!/bin/sh

# 使用说明：
# 1.该文件放在源项目根目录下，并进入.git/hooks目录
# 2.重命名文件commit-msg.sample为commit-msg
# 3.注释其他代码，添加代码(. ./hooks-commit.sh)即可

#################### 配置变量 #####################

# 源项目根目录
sourceDir="./"

# 目标项目根目录
targetDir="../test2"

# 排除文件或目录，多个使用竖线"|"分隔
excludes='dist/*'

##################################################

echo "\033[33m* 改动文件拷贝开始 *\033[0m"

# 获取变化文件列表
git diff --cached --name-status | grep -Ev "$excludes" |
while read st file
do

    # 拷贝复制文件
    if [ "$st" = 'A' ] || [ "$st" = 'M' ]; then 
        cp --path "$sourceDir/$file" "$targetDir"
        echo "\033[32m$st $file\033[0m"

    # 删除文件
    elif [ "$st" = 'D' ]; then 
        rm -f "$targetDir/$file"
        echo "\033[32m$st $file\033[0m"

    # 重命名文件
    elif [ "$st" = 'R100' ]; then 
        source=`echo $file | awk -F'[[:space:]][[:space:]]' '{print $1}'`
        target=`echo $file | awk -F'[[:space:]][[:space:]]' '{print $2}'`
        echo $source
        echo $target
        # mv -f "$targetDir/$source" "$targetDir/$target"
        echo "\033[32mR $file\033[0m"
    fi

done

echo "\033[33m* 改动文件拷贝结束 *\033[0m"
