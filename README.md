kindle-note-format
============

使用kindle-format导出笔记，标注和剪贴文章。

## 源文件
源文件是在使用kindle阅读书籍的时候产生的一个记录用户的标注，笔记，剪贴和标签信息的文档，但是源文件在共享的时候格式往往需要修改，于是提供一个脚本，将其格式化。 
脚本参考于[李超同学](http://minejo.github.io/blog/2014/02/18/shi-yong-kindlebi-ji-lai-zuo-fortuneming-yan/)的python脚本（没有学过python -_-），重构了ruby脚本，也算是我的的第一个脚本.  
源文件共有四种格式:
### 书签 ###
格式为：

    Book Title\r\n
    - 我的书签 位置N | 已添加至 sometime\r\n
    \r\n
    \r\n

### 标注 ###
格式为：

    Book Title\r\n
    - 我的标注 位置N-N | 已添加至 sometime\r\n
    \r\n
    标注内容\r\n

### 笔记 ###
笔记比较特殊，笔记是与标注连在一起的。表示该笔记是在该标注上完成的。

    Book Title\r\n
    - 我的笔记 位置N | 已添加至 sometime\r\n
    \r\n
    笔记内容\r\n
    ==========\r\n
    Book Title\r\n
    - 我的标注 位置N-N | 已添加至 sometime\r\n
    \r\n
    标注内容\r\n

### 剪贴文章 ###

    Book Title\r\n
    - 剪贴文章 位置N | 已添加至 sometime\r\n
    \r\n
    剪贴文章内容\r\n

每一个摘录都用`==========\r\n`分割开。

##脚本使用

###环境###
安装ruby

###运行###
>ruby kindle-format [-param] [path-to-sourcefile]

其中 

*   -param 有 “-h”,"-m"   
    -h 表示查看帮助   
    -m 表示输出为markdown格式   
*   path-to-sourcefile 为可选参数，默认为当前路径下的My Clippings.txt   

###输出###
-m 会在当前目录下生成“kindle-markdown”目录，并在该目录下创建一个以运行时间为标题的markdown文件. 

##待完成
###支持Octopress的文档###
###支持其他格式的文档###

##参考
* [lxyu-Kindle Clippings](https://github.com/lxyu/kindle-clippings)
* [自己定制mint-fortune 打造个性linuxmint终端窗口](http://blog.51osos.com/linux/mint-fortune-linuxmint-terminal/)




