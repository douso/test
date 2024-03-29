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
git diff --cached --name-status | grep -Ev "$excludes" | awk 'gsub("\t","\001",$0)' |
while read line
do

    st=`echo $line | awk -F "\001" '{print $1}'`
    file1=`echo $line | awk -F "\001" '{print $2}'`
    file2=`echo $line | awk -F "\001" '{print $3}'`

    # 拷贝复制文件
    if [ "$st" = 'A' ] || [ "$st" = 'M' ]; then 
        cp --path "$sourceDir/$file1" "$targetDir"
        echo "\033[32m$st\t$file1\033[0m"

    # 删除文件
    elif [ "$st" = 'D' ]; then 
        rm -f "$targetDir/$file1"
        echo "\033[32m$st\t$file1\033[0m"

    # 重命名文件
    elif [ "$st" = 'R100' ]; then 
        mv -f "$targetDir/$file1" "$targetDir/$file2"
        echo "\033[32mR\t$file1\t$file2\033[0m"
    fi

done

echo "\033[33m* 改动文件拷贝结束 *\033[0m"
