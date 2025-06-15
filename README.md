# linux-init-script
一键初始化多发行版 Linux 系统的环境配置脚本，支持 Debian、Ubuntu、Kali、Deepin、Raspbian 等主流发行版。（完善中）

## 功能

- 自动识别系统发行版  
- 安装常用基础工具（sudo、curl、wget、vim、htop 等）  
- 交互式时区设置，支持常用时区快速选择或自定义输入  
- 设置默认编辑器为 vim  
- 检查并提示 sudo 权限配置

## 支持的系统

- Debian  
- Ubuntu  
- Kali Linux  
- Deepin  
- Raspbian / Raspberry Pi OS  
- 其他基于 Debian 的发行版（自动尝试通用设置）

## 使用方法

在目标 Linux 服务器或主机上，执行：

```bash
bash <(curl -sSL ***)
