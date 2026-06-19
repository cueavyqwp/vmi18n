<div align = "center" >
    <h1>VMware简体中文本地化 (vmi18n)</h1>
</div>

# 关于

`博通`在新版`VMware`中移除了对中文的支持, 此项目通过添加中文本地化的方式重新使其支持简体中文

旧有翻译基于`17.6.4 build-24832109`版本的官方简体中文翻译

新翻译通过对比差异之后翻译自官方日文本地化(汉化由deepseek完成)

# 使用

在[这里](https://github.com/cueavyqwp/vmi18n/releases/latest)下载最新版

安装时会重启`VMware`,确保没在运行虚拟机

解压后使用管理员权限运行(用于在`C:\Program Files`目录下写入文件)

`右键VMware快捷方式`>`打开文件的所在位置`>`复制`>`右键粘贴到脚本`

一路回车即可

# 安全性?

原理就在[下面](#原理),你不想用就不用呗￣へ￣

# 原理

`[安装目录]\VMware\VMware Workstation\messages` 下的文件夹用于存放不同语言的本地化文件

其中的`vmware.vmsg`以即为简单的`键`对`值`形式存储

至于`vmappsdk-XXX.dll`与`vmui-XXX.dll`可通过`ResourceHacker`来实现汉化

在`%APPDATA%\VMware`下的`preferences.ini`添加`pref.locale = "zh_CN"`能使其使用简体中文的本地化文件

# 说明

- `base`: `17.6.4 build-24832109`版本的官方简体中文翻译文件
- `new`: 新版本的日文官方本地化文件
- `replace`: 用于合并的`vmware.vmsg`与安装脚本等
- `out`: 执行`differ.py`后生成的汉化补丁文件

# 自行生成

替换`new\vmware.vmsg`为`[安装目录]\VMware\VMware Workstation\messages\ja`下的`vmware.vmsg`

使用`Python`>=`3.10`运行`differ.py`

复制缺失的本地化项,然后追加至`replace\vmware.vmsg`(怎么翻译看你)

再次运行`differ.py`

你需要的文件会在`out`文件夹下

# 鸣谢

- [dbohdan/initool](https://github.com/dbohdan/initool): 用于读写ini,项目内直接包含了其二进制文件,以及开源协议
- [wzsx150/ResourceHacker_CN](https://github.com/wzsx150/ResourceHacker_CN): `ResourceHacker`的汉化,同时也感谢原作者
- [gandli/vmware-downloads](https://github.com/gandli/vmware-downloads): 提供`VMware`的下载链接
- [Kuroba-Sayuki/VMware-Workstation-Chinese-Localization](https://github.com/Kuroba-Sayuki/VMware-Workstation-Chinese-Localization): 汉化思路参考
- `deepseek`: 新增文本的翻译
