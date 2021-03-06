#encoding:UTF-8

#author: unkeltao
#version: 1.0

require "date"
require "fileutils"

$bound = "==========\n"
$m_fenge = "------------------\n\n"
$date = DateTime.now.to_time
$name = "kindle note"
$param = {"-h" => 0, "-m" => 1, "-mo" => 2}
$filename = "My Clippings.txt"
$type = 0 

#Octopress格式头
def put_head
	str = "---
layout: post
title: '#{$name}'
date: #{$date}
comments: true 
categories: [kindle note]
keywords: kindle
description: 'kindle note' 
---\n\n"
	str
end

#查看帮助
def put_help
	puts "
格式
ruby kindle-format.rb [-param] [path/filename] 
参数
-h  查看帮助
-m  生成markdown的文档
-mo 支持Octopress 的 MarkDown格式  
"
end

#都去文件，分割笔记块（Windows下存在编码问题）
def get_block(file)
	file.tr!("\r","")
	block = file.split($bound)

	# p block.size
end

#获取快类型 0：书签 1：标注 2：剪贴 3：笔记
def get_type(block)
	block.tr!("\r","")
	reg1 = /[\d]-[\d]/
	reg2 = /剪贴|Clip/
	line = block.split("\n")
	if line.size != 4
		0
	elsif reg1 =~ line[1]
		1
	elsif reg2 =~ line[1]
		2
	else
		3	
	end
end

#得到标注类信息
def get_light(block)
	block.tr!("\r","")
	line = block.split("\n")
	info = {}
	info["title"] = line[0]
	info["location"] = line[1].scan(/[\d]+-?[\d]+/)[0]
	info["text"] = line[3]
	time = line[1][line[1].rindex(/\d\d\d\d+/)..line[1].size].split
	info["time"] = time[0].gsub(/[\u4e00-\u9fa5]/,"-").gsub(/-$/,"")+" "+time[2]
	# info["time"] = line[1].scan(/[\d\d\d\d]+[\u4e00-\u9fa5][\d]+[\u4e00-\u9fa5][\d]+[\u4e00-\u9fa5][\s][\u4e00-\u9fa5]+[\s][\d]+:[\d]+:[\d]+/)[0]
	info
end

#得到笔记信息
def get_note(block1,block2)
	info = get_light(block2)
	block1.tr!("\r","")
	info["note"] = block1.split("\n")[3]
	info 
end

#格式化信息
def get_format(info,type)
	format_str = ""
	case type
	when "-m","-markdown"
		if info["note"] == nil
			format_str +=">#{info["text"]} \n\n-At Kindle page:#{info["location"]} \t time: #{info["time"]} \n\n#{$m_fenge}"			
		else
			format_str +=">Note:**#{info["note"]}**\n>>#{info["text"]} \n\n-At Kindle page:#{info["location"]} \t time: #{info["time"]} \n\n#{$m_fenge}"
		end
	end
	format_str
end

#输出str 到 path目录下的name文件中
def output(str,name,path)
	begin
		if !File.exist?(path)
			 Dir.mkdir(path)
		end

		file = File.new(path+"/"+name,"w")
		file.puts str
		file.close
	rescue Exception => e
		p e
		puts "转换失败 -_-"
		exit
	end
end

#输出str
def write_str(str,type)
	case type
	when "-m"
		output(str,"#{$date} #{$name}.md".tr!(":",""),"kindle-markdown")
	end
end

#Main
def main
	$p = ARGV[0]
	if ARGV.size == 2
		$filename = ARGV[1]
	end

	if ARGV.size > 2 || $param[$p] == nil 
		puts "错误的参数输入(Wrong param)\n\t请输入 -h 进行帮助(-h for help)"
		exit
	elsif !File.exist?($filename) || !File.file?($filename)
 		"文件#{$filename}不存在\n (the file #{$filename} is not exist)"
	end

	if $p == "-h"
		put_help
		exit
	end

	begin
		# p 100
		file = open($filename,:encoding=>"UTF-8")
		# p 100
		$block = get_block(file.read)
		file.close
	rescue Exception => e
		p e
		p 1
		exit
	end

	i = 0
	output_str = ""
	if $param[$p] == 2
		output_str += put_head
		$p = "-m"
		$octo = true
	end
	while i < $block.size
		tp = get_type($block[i])
		case tp
		when 1,2 then
			info = get_light($block[i])
			output_str +=get_format(info,$p)
			output_str += "<!-- more -->\n" if i == 0 && $octo
		when 3 then
			info = get_note($block[i],$block[i+1])
			output_str +=get_format(info,$p)
			output_str += "<!-- more -->\n" if i == 0 && $octo
			i += 1
		end
		i+=1
	end

	write_str(output_str,$p)

	puts "转换成功 ^_^ 请去当前文件夹查看"
	exit
end

main 
