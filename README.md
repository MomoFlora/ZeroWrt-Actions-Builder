<p align="center">
  <a href="https://github.com/MomoFlora/ZeroWrt-Actions-Builder">
    <img src="doc/zerowrt.png" alt="ZeroWrt Logo" width="100%">
  </a>
</p>

<h3 align="center">基于 ImmortalWrt 的 MT798x 定制固件构建系统</h3>

<p align="center">
  <a href="https://github.com/MomoFlora/ZeroWrt-Actions-Builder/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/MomoFlora/ZeroWrt-Actions-Builder?color=blue" alt="License">
  </a>
  <img src="https://img.shields.io/badge/platform-MT798x_Filogic-orange" alt="Platform">
  <img src="https://img.shields.io/badge/kernel-6.6_LTS-green" alt="Kernel">
  <img src="https://img.shields.io/badge/base-OpenWrt_24.10-blueviolet" alt="OpenWrt">
  <a href="https://github.com/MomoFlora/ZeroWrt-Actions-Builder/actions">
    <img src="https://img.shields.io/badge/build-automated-brightgreen" alt="Build Status">
  </a>
</p>

---

## 📖 项目简介

**ZeroWrt-Actions-Builder** 是一个基于 GitHub Actions 的自动化固件编译系统。本项目专为 **MediaTek MT798x (Filogic 820/830)** 系列芯片设备打造，源码基于优秀的 **ImmortalWrt** 主线。

通过本项目，您无需本地搭建复杂的 Linux 编译环境，只需点击几下，即可在线定制并编译出集成了最新特性、高稳定性且完全属于您自己的路由器固件。

---

## 📱 支持设备列表 (Supported Devices)

本构建系统目前已完美适配以下 MT798x 设备。在触发编译时，请使用对应的 **Profile ID**：

| 品牌 / 运营商 (Brand) | 设备型号 (Device Model) | 配置文件标识 (Profile ID) |
| :--- | :--- | :--- |
| **GL.iNet** | GL-MT3000 (BeryX) | `glinet_gl-mt3000` |
| | GL-MT6000 (Flint 2) | `glinet_gl-mt6000` |
| **锐捷 (Ruijie)** | 星耀 EW-6000GX Pro | `ruijie_ew-6000gx-pro` |
| | RG-X60 New | `ruijie_rg-x60-new` |
| | RG-X60 Pro | `ruijie_rg-x60-pro` |
| **超级网关** | SuperGateway S20L | `supergateway_s20l` |
| | SuperGateway S20M | `supergateway_s20m` |
| | SuperGateway S20P | `supergateway_s20p` |
| **Cudy** | TR3000 v1 | `cudy_tr3000-v1` |
| | TR3000 v1 (256MB) | `cudy_tr3000-v1-256mb` |
| **中国移动 (CMCC)** | A10 | `cmcc_a10` |
| | A10 (256M) | `cmcc_a10-256m` |
| **京东云 (JDCloud)** | 无线宝 RE-CP-03 | `jdcloud_re-cp-03` |
| **360** | T7 | `qihoo_360t7` |
| **磊科 (Netcore)** | N60 Pro | `netcore_n60-pro` |
| **诺基亚 (Nokia)** | EA0326GMP | `nokia_ea0326gmp` |
| **飞利浦 (Philips)** | HY3000 | `philips_hy3000` |
| **其他适配** | 亚洲商旅 ASR3000 | `abt_asr3000` |
| | Cetron CT3003 | `cetron_ct3003` |
| | SL 3000 (eMMC) | `sl_3000-emmc` |
| | SN R1 | `sn_r1` |

---

## 🛠️ 如何使用与自定义编译 (Usage & Customization)

### 第一步：Fork 本项目
点击页面右上角的 **Fork** 按钮，将本项目复制到您自己的 GitHub 账号下。

### 第二步：自定义固件基础设置
本项目支持高度个性化定制。您可以修改仓库中的自定义脚本（例如 `scripts/custom.sh` 类似文件），在其中加入以下常用的修改命令：

> 💡 **自定义示例（可直接写入您的个性化脚本中）：**

```bash
# 1. 修改默认 LAN IP 地址 (例如改为 192.168.10.1)
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认 root 管理密码 (例如改为 password)
# 提示：OpenWrt 密码使用 MD5/SHA512 加密，此处以将密码设为 "password" 为例
sed -i 's/root::0:0:99999:7:::/root:$1$wEeODAsg$6G6rN7Z174Y.JpEb7G58V.:18730:0:99999:7:::/g' package/base-files/files/etc/shadow

# 3. 修改默认 Wi-Fi 名称 (SSID)
sed -i 's/OpenWrt/ZeroWrt-WiFi/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 4. 设置默认 Wi-Fi 密码 (例如改为 12345678)
# 注意：默认 OpenWrt 可能是没有无线密码的，此处通常需要在对应无线配置中追加 encryption 和 key
```

### 第三步：运行 GitHub Actions 触发编译

1. 进入您 Fork 后的仓库，点击顶部的 **Actions** 标签页。
2. 在左侧侧边栏中选择您的构建工作流（例如 `Build ZeroWrt`）。
3. 点击右侧的 **Run workflow** 下拉菜单。
4. 在弹出的输入框中，输入或选择您想要编译的设备 **Profile ID**（例如 `glinet_gl-mt6000`）。
5. 点击 **Run workflow** 按钮，GitHub Actions 将全自动开始编译。

---

## 📥 固件下载

编译完成后，打包好的固件会自动上传至该次 Action 运行结果的 **Artifacts（产物）** 中。您可以点击对应的构建记录，拉到页面最下方进行下载。

---

## 🤝 致谢与声明

* 本项目基于 [ImmortalWrt](https://github.com/Yuzhii0718/immortalwrt-mt798x-6.6-padavanonly) 源码开源项目。
* 感谢所有为 MT798x 平台提交适配与优化的开发者。

> ⚠️ **免责声明：**
> 刷机有风险，因操作不当导致的设备损坏、变砖等一切后果，本项目及作者概不负责。请在充分了解风险后再进行操作。
