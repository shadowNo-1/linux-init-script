#!/bin/bash
set -e

# 输出颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 日志文件
LOGFILE="/var/log/linux-init.log"
exec > >(tee -a "$LOGFILE") 2>&1

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

# 版本号
echo "$ascii_art"
printf "              ${GREEN}Version: v0.1-alpha${NC}\n\n"

echo "🚀 正在初始化 Linux 系统..."
echo "🧠 正在检测系统版本..."

# 设置非交互模式安装
export DEBIAN_FRONTEND=noninteractive

# 获取系统信息
if [ -f /etc/os-release ]; then
  source /etc/os-release
  DISTRO=$ID
  VERSION=$VERSION_ID
  echo "📦 当前系统：$PRETTY_NAME"
else
  echo -e "${RED}❌ 无法识别系统信息，/etc/os-release 不存在${NC}"
  exit 1
fi

# 通用软件包
COMMON_PACKAGES="sudo curl wget ufw iptables iproute2 net-tools vim nano htop unzip zip bzip2 lsof gnupg ca-certificates build-essential"

# 各系统初始化逻辑
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
    echo -e "${YELLOW}⚠️ 未识别系统：$DISTRO，尝试默认初始化...${NC}"
    apt update && apt install -y $COMMON_PACKAGES
    ;;
esac

# 设置时区
if command -v timedatectl &>/dev/null; then
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
  read -rp "请输入你想设置的时区（编号或完整时区名）: " TZ_INPUT

  case "$TZ_INPUT" in
    1) USER_TIMEZONE="Asia/Shanghai" ;;
    2) USER_TIMEZONE="Asia/Tokyo" ;;
    3) USER_TIMEZONE="Asia/Singapore" ;;
    4) USER_TIMEZONE="Europe/London" ;;
    5) USER_TIMEZONE="Europe/Paris" ;;
    6) USER_TIMEZONE="America/New_York" ;;
    7) USER_TIMEZONE="America/Los_Angeles" ;;
    8) USER_TIMEZONE="UTC" ;;
    *) USER_TIMEZONE="$TZ_INPUT" ;;
  esac

  if [ -n "$USER_TIMEZONE" ]; then
    echo "🕒 设置时区为：$USER_TIMEZONE"
    timedatectl set-timezone "$USER_TIMEZONE" && echo "✅ 成功设置为 $USER_TIMEZONE" || echo -e "${RED}❌ 设置失败，请手动检查${NC}"
  fi
fi

# 设置默认编辑器为 vim
if command -v update-alternatives &>/dev/null && command -v vim &>/dev/null; then
  echo "📝 设置默认编辑器为 vim"
  update-alternatives --set editor /usr/bin/vim.basic
fi

# 检查 sudo 权限
CURRENT_USER=$(logname 2>/dev/null || echo $SUDO_USER || echo $USER)
if id "$CURRENT_USER" | grep -q "sudo"; then
  echo "✅ 当前用户 [$CURRENT_USER] 已拥有 sudo 权限"
else
  echo -e "${YELLOW}🔐 当前用户 [$CURRENT_USER] 不在 sudo 组，建议执行：${NC}"
  echo "usermod -aG sudo $CURRENT_USER"
fi

echo ""
echo -e "${GREEN}🎉 初始化完成！欢迎使用 $PRETTY_NAME${NC}"
