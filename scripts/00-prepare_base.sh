#!/bin/bash -e

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.110.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 修改默认主机名
sed -i 's/ImmortalWrt/ZeroWrt/g' package/base-files/files/bin/config_generate

# 设置默认主题
sed -i 's/+luci-theme-bootstrap/+luci-theme-design/' feeds/luci/collections/luci-light/Makefile
sed -i 's/+luci-theme-bootstrap/+luci-theme-design/' feeds/luci/collections/luci-nginx/Makefile

# MTK 无线 WIFI 设置
sed -i \
  -e 's/ImmortalWrt-2\.4G/ZeroWrt-2.4G/g' \
  -e 's/ImmortalWrt-5G/ZeroWrt-5G/g' \
  -e 's/encryption=none/encryption=psk2/g' \
  -e '/set wireless.default_\${dev}\.encryption=psk2/a\					set wireless.default_${dev}.key=1234567890' \
  package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

# 更改默认 Shell 为 zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 修改默认密码
default_password=$(openssl passwd -5 password)
sed -i "s|^root:[^:]*:|root:${default_password}:|" package/base-files/files/etc/shadow

# TTYD 设置
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# 修改版本号
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By MomoFlora'/g" package/base-files/files/etc/openwrt_release
sed -i "s|^OPENWRT_RELEASE=\".*\"|OPENWRT_RELEASE=\"ZeroWrt 标准版 @R$(date +%Y%m%d) BY MomoFlora\"|" package/base-files/files/usr/lib/os-release
sed -i 's/\(VERSION_DIST:=$(if $(VERSION_DIST),$(VERSION_DIST),\)[^)]*\()\)/\1ZeroWrt\2/' include/version.mk
sed -i 's/\(VERSION_MANUFACTURER:=$(if $(VERSION_MANUFACTURER),$(VERSION_MANUFACTURER),\)[^)]*\()\)/\1ZeroWrt\2/' include/version.mk

# NTP
sed -i 's/time.apple.com/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/time1.google.com/ntp2.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/time.cloudflare.com/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/pool.ntp.org/time2.cloud.tencent.com/g' package/base-files/files/bin/config_generate

# 根文件系统文件
mkdir -p files/etc files/root
curl -so files/etc/banner https://raw.githubusercontent.com/MomoFlora/ZeroWrt-Actions-Builder/refs/heads/master/files/etc/banner
curl -so files/root/.zshrc https://raw.githubusercontent.com/MomoFlora/ZeroWrt-Actions-Builder/refs/heads/master/files/root/.zshrc
pushd files/root
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ./.oh-my-zsh
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-completions ./.oh-my-zsh/custom/plugins/zsh-completions
popd

# 应用补丁文件
pushd feeds/luci
    curl -s https://raw.githubusercontent.com/MomoFlora/ZeroWrt-Actions-Builder/refs/heads/master/patch/firewall/0001-luci-mod-status-firewall-disable-legacy-firewall-rule.patch | patch -p1
    curl -s https://raw.githubusercontent.com/MomoFlora/ZeroWrt-Actions-Builder/refs/heads/master/patch/firewall/0002-luci-app-firewall-remove-flow-offloading-UI-section.patch | patch -p1
    curl -s https://raw.githubusercontent.com/MomoFlora/ZeroWrt-Actions-Builder/refs/heads/master/patch/reboot/0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch | patch -p1
    curl -s https://raw.githubusercontent.com/MomoFlora/ZeroWrt-Actions-Builder/refs/heads/master/patch/overview/0001-luci-mod-status-add-help-feedback-links-with-styled-button.patch | patch -p1
popd
