#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/luci/applications/luci-app-adguardhome
rm -rf feeds/luci/themes/luci-theme-argon

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/new
  cd .. && rm -rf $repodir
}

# Go 1.26
git clone --depth=1 -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 添加额外插件
git clone --depth=1 https://github.com/MomoFlora/adguardhome package/new/luci-app-adguardhome
git_sparse_clone main https://github.com/sbwml/openwrt_pkgs bash-completion otahelper luci-app-socat luci-app-ota

# 科学上网插件
git clone --depth=1 https://github.com/nikkinikki-org/OpenWrt-nikki package/new/OpenWrt-nikki && rm -rf package/new/OpenWrt-nikki/mihomo-alpha

# Themes
git clone --depth=1 -b openwrt-25.12 https://github.com/MomoFlora/luci-theme-argon package/new/luci-theme-argon
git clone --depth=1 -b openwrt-25.12 https://github.com/MomoFlora/luci-theme-design package/new/luci-theme-design
