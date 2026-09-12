<div align = "center" >
    <h1>VMware简体中文本地化 (vmi18n)</h1>
</div>

# 关于

`博通`在新版`VMware`中移除了对中文的支持, 此项目通过添加中文本地化的方式重新使其支持简体中文

旧有翻译基于`17.6.4 build-24832109`版本的官方简体中文翻译

新翻译通过对比差异之后翻译自官方日文本地化(汉化由deepseek完成)

dll文件修改于官方日文本地化,翻译使用旧版官方中文(兼容性有待确认)

截至目前翻译基于`26.0.1.25688693`

# 已知问题

`关于VMware Workstation`,`VMware Workstation`与`Pro`之间有个`111`(产品信息那里也有)

# 使用

在[这里](https://github.com/cueavyqwp/vmi18n/releases/latest)下载最新版

安装时会重启`VMware Workstation`,确保没在运行虚拟机

解压后使用管理员权限运行(用于在`C:\Program Files`目录下写入/删除文件)

`右键VMware Workstation快捷方式`>`打开文件的所在位置`>`复制`>`右键粘贴到脚本`

然后回车等待即可

# 原理

`[安装目录]\VMware\VMware Workstation\messages` 下的文件夹用于存放不同语言的本地化文件

其中的`vmware.vmsg`以即为简单的`键`对`值`形式存储

至于`vmappsdk-XXX.dll`与`vmui-XXX.dll`可通过`ResourceHacker`来实现汉化

在`%APPDATA%\VMware`下的`preferences.ini`添加`pref.locale = "zh_CN"`能使其使用简体中文的本地化文件

# 结构说明

- `base`: `17.6.4 build-24832109`版本的官方简体中文翻译文件
- `current`: 新版本的日文官方本地化文件
- `replace`: 用于合并的`vmware.vmsg`与安装脚本等
- `dist`: 执行`differ.py`后生成的汉化补丁文件

# 自行修改

替换`new\vmware.vmsg`为`[安装目录]\VMware\VMware Workstation\messages\ja`下的`vmware.vmsg`

使用`Python`>=`3.10`运行`differ.py`

复制缺失的本地化项,然后追加至`replace\vmware.vmsg`(怎么翻译看你)

再次运行`differ.py`

你需要的文件会在`dist`文件夹下

修改dll文件你需要使用`ResourceHacker`

复制`[安装目录]\VMware\VMware Workstation\messages\ja`下的dll文件,并将`-ja`改为`-zh_CN`

修改`版本信息`,`清单`,`快捷键`,`对话框`,`菜单`,`字串表`,具体参考`base`下的旧版官方的简体中文格式

编译版本信息时`BLOCK`哪里可能会报错,把后边字符里的`0x`去除再编译即可

# 卸载

先关闭`VMware Workstation`

移除`[安装目录]\VMware\VMware Workstation\messages`下的`zh_CN`文件夹

转到`%APPDATA%\VMware`下的`preferences.ini`移除`pref.locale = "zh_CN"`

# 鸣谢

- [dbohdan/initool](https://github.com/dbohdan/initool): 用于读写ini,项目内直接包含了其二进制文件,以及开源协议(MIT)
- [wzsx150/ResourceHacker_CN](https://github.com/wzsx150/ResourceHacker_CN): `ResourceHacker`的汉化,同时也感谢原作者
- [gandli/vmware-downloads](https://github.com/gandli/vmware-downloads): 提供`VMware Workstation`的下载链接
- [VMware Workstation/Fusion Pro Collection](https://archive.org/details/vmwareworkstationarchive): 收录了`VMware Workstation`的许多版本
- [Kuroba-Sayuki/VMware-Workstation-Chinese-Localization](https://github.com/Kuroba-Sayuki/VMware-Workstation-Chinese-Localization): 汉化思路参考
- [deepseek](https://chat.deepseek.com): 新增文本的翻译
