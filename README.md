# Linux Quick Init
[![Author](https://img.shields.io/badge/author-shadowNo--1-informational?style=flat&logo=github&logoColor=181717&color=green)](https://github.com/shadowNo-1)
[![](https://img.shields.io/badge/license-GNU--v3.0-informational?style=flat&logo=gnu&logoColor=white&color=A42E2B)](https://www.gnu.org/licenses/gpl-3.0.html)
![](https://img.shields.io/badge/Version-v0.1--alpha-&logoColor=e95420&color=e95420)

一键初始化多发行版 Linux 系统的环境配置脚本，支持 Debian、Ubuntu、Kali、Deepin、Raspbian 等主流发行版。（完善中...）

简称LQI

## 功能

- 自动检测并识别 Linux 发行版  
- 安装常用基础工具（sudo、curl、wget、vim、htop 等）  
- 交互式时区设置，支持常用时区快速选择或自定义输入  
- 设置默认编辑器为 vim  
- 检查并提示 sudo 权限配置

## 支持的系统

- 绝大多数基于 Linux 的发行版，包括但不限于：  
  - Debian 系列  
  - Ubuntu 系列  
  - Kali Linux  
  - Deepin  
  - Raspbian / Raspberry Pi OS  
  - 其他主流和定制 Linux 发行版

## 使用方法

在目标 Linux 服务器或主机上，执行：

```bash
curl -fsSL https://raw.githubusercontent.com/shadowNo-1/linux-init-script/main/linux-init-script.sh | bash
```

##‼️别用！还没写完‼️
