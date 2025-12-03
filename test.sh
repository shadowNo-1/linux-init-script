#!/bin/bash
set -e

# 输出颜色
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
        ⚙️  Script: Linux Quick Init (Interactive)
EOF
)
echo "$ascii_art"
printf "              ${GREEN}Version: v0.2-alpha${NC}\n\n"

# 检查 root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ 请以 root 或 sudo 运行此脚本${NC}"
    exit 1
fi

# 获取系统信息
if [ -f /etc/os-release ]; then
  source /etc/os-release
  DISTRO=$ID
  VERSION=$VERSION_ID
  echo "📦 当前系统：$PRETTY_NAME"
else
  echo -e "${RED}❌ 无法识别系统信息${NC}"
  exit 1
fi

# 通用软件包
COMMON_PACKAGES="sudo curl wget ufw iptables iproute2 net-tools vim nano htop unzip zip bzip2 lsof gnupg ca-certificates build-essential"

# 功能函数
install_common_packages() {
    echo "🚀 安装通用软件包..."
    case "$DISTRO" in
        debian|ubuntu|kali|deepin|raspbian|raspberrypi)
            apt update && apt install -y $COMMON_PACKAGES
            ;;
        *)
            echo -e "${YELLOW}⚠️ 未识别系统，尝试默认安装${NC}"
            apt update && apt install -y $COMMON_PACKAGES
            ;;
    esac
}

set_timezone() {
    if command -v timedatectl &>/dev/null; then
        echo ""
        echo "🌏 常用时区："
        echo "  1) Asia/Shanghai"
        echo "  2) Asia/Tokyo"
        echo "  3) UTC"
        read -rp "请输入时区编号或完整时区名: " TZ_INPUT
        case "$TZ_INPUT" in
            1) USER_TIMEZONE="Asia/Shanghai" ;;
            2) USER_TIMEZONE="Asia/Tokyo" ;;
            3) USER_TIMEZONE="UTC" ;;
            *) USER_TIMEZONE="$TZ_INPUT" ;;
        esac
        timedatectl set-timezone "$USER_TIMEZONE" && echo "✅ 时区设置为 $USER_TIMEZONE"
    else
        echo -e "${YELLOW}⚠️ timedatectl 不可用，无法设置时区${NC}"
    fi
}

set_default_editor() {
    if command -v update-alternatives &>/dev/null && command -v vim &>/dev/null; then
        echo "📝 设置默认编辑器为 vim"
        update-alternatives --set editor /usr/bin/vim.basic
    fi
}

check_sudo() {
    CURRENT_USER=$(logname 2>/dev/null || echo $SUDO_USER || echo $USER)
    if id "$CURRENT_USER" | grep -q "sudo"; then
        echo "✅ 当前用户 [$CURRENT_USER] 已拥有 sudo 权限"
    else
        echo -e "${YELLOW}🔐 当前用户 [$CURRENT_USER] 不在 sudo 组${NC}"
        echo "建议执行：usermod -aG sudo $CURRENT_USER"
    fi
}

# 主菜单
while true; do
    echo ""
    echo -e "${GREEN}请选择要执行的操作:${NC}"
    echo "1) 安装常用软件包"
    echo "2) 设置时区"
    echo "3) 设置默认编辑器为 vim"
    echo "4) 检查 sudo 权限"
    echo "5) 退出"
    read -rp "输入编号: " CHOICE

    case "$CHOICE" in
        1) install_common_packages ;;
        2) set_timezone ;;
        3) set_default_editor ;;
        4) check_sudo ;;
        5) echo "👋 退出脚本" ; exit 0 ;;
        *) echo -e "${YELLOW}⚠️ 无效选项，请重新选择${NC}" ;;
    esac
done
