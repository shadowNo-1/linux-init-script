#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'


# ASCII签名
ascii_art=$(cat << 'EOF' 

     _____ __              __              _   __       ___
    / ___// /_  ____ _____/ /___ _      __/ | / /___   <  /
    \__ \/ __ \/ __ `/ __  / __ \ | /| / /  |/ / __ \  / / 
   ___/ / / / / /_/ / /_/ / /_/ / |/ |/ / /|  / /_/ / / /  
  /____/_/ /_/\__,_/\__,_/\____/|__/|__/_/ |_/\____(_)_/   
                                                           

        🔗  GitHub: https://github.com/shadowNo-1/
        ⚙️  Script: Linux Quick Init (by ShadowNo.1)
EOF
)

#版本号
echo "$ascii_art"
printf "              ${GREEN}Version: v0.1-alpha${NC}\n"

echo ""
echo "🚀 正在初始化 Debian 系统..."
echo "🧠 正在检测系统版本..."

# 获取系统信息
source /etc/os-release
DISTRO=$ID
VERSION=$VERSION_ID
echo "📦 当前系统：$PRETTY_NAME"

# 常用软件包列表
COMMON_PACKAGES="sudo curl wget ufw iptables iproute2 net-tools vim nano htop unzip zip bzip2 lsof gnupg ca-certificates build-essential"

# 不同系统的初始化逻辑
case "$DISTRO" in
  debian)
    echo "✅ Debian 系统，执行初始化..."
    apt update && apt install -y $COMMON_PACKAGES
    ;;

  ubuntu)
    echo "✅ Ubuntu 系统，执行初始化..."
    apt update && apt install -y $COMMON_PACKAGES software-properties-common
    ;;

  kali)
    echo "✅ Kali 系统，添加安全工具..."
    apt update && apt install -y $COMMON_PACKAGES metasploit-framework
    ;;

  deepin)
    echo "✅ Deepin 系统，添加中文字体..."
    apt update && apt install -y $COMMON_PACKAGES fonts-wqy-microhei fonts-wqy-zenhei
    ;;

  raspbian | raspberrypi)
    echo "✅ 树莓派系统，轻量安装..."
    apt update && apt install -y $COMMON_PACKAGES raspi-config
    ;;

  *)
    echo "⚠️ 未识别系统：$DISTRO，尝试默认初始化..."
    apt update && apt install -y $COMMON_PACKAGES
    ;;
esac
#PS: I don't like CentOS!!!


# 交互式时区设置
if command -v timedatectl &> /dev/null; then
  echo ""
  echo "🌏 常用时区（格式：区域/城市 | 国家）："
  echo "  1) Asia/Shanghai      | 中国"
  echo "  2) Asia/Tokyo         | 日本"
  echo "  3) Asia/Singapore     | 新加坡"
  echo "  4) Europe/London      | 英国"
  echo "  5) Europe/Paris       | 法国"
  echo "  6) America/New_York   | 美国东部"
  echo "  7) America/Los_Angeles| 美国西部"
  echo "  8) UTC                | 世界标准时间"
  echo ""
  echo "请输入你想设置的时区：可填编号 (如 1) 或完整格式 (如 Asia/Shanghai)"
  read -rp "你的选择: " TZ_INPUT

  # 映射编号为具体时区名
  case "$TZ_INPUT" in
    1) USER_TIMEZONE="Asia/Shanghai" ;;
    2) USER_TIMEZONE="Asia/Tokyo" ;;
    3) USER_TIMEZONE="Asia/Singapore" ;;
    4) USER_TIMEZONE="Europe/London" ;;
    5) USER_TIMEZONE="Europe/Paris" ;;
    6) USER_TIMEZONE="America/New_York" ;;
    7) USER_TIMEZONE="America/Los_Angeles" ;;
    8) USER_TIMEZONE="UTC" ;;
    *) USER_TIMEZONE="$TZ_INPUT" ;; # 支持直接输入完整格式
  esac

  # 设置时区
  if [ -n "$USER_TIMEZONE" ]; then
    echo "🕒 正在设置时区为：$USER_TIMEZONE"
    timedatectl set-timezone "$USER_TIMEZONE" && echo "✅ 已成功设置为 $USER_TIMEZONE"
  else
    echo "⚠️ 未设置任何时区，保持默认"
  fi
fi

# 设置默认编辑器
if command -v update-alternatives &>/dev/null && command -v vim &>/dev/null; then
  update-alternatives --set editor /usr/bin/vim.basic
fi

# 检查 sudo 权限
if id "$USER" | grep -q "sudo"; then
  echo "✅ 当前用户已拥有 sudo 权限"
else
  echo "🔐 当前用户不在 sudo 组，建议手动运行："
  echo "usermod -aG sudo $USER"
fi

echo ""
echo "🎉 初始化完成！欢迎使用 $PRETTY_NAME"
