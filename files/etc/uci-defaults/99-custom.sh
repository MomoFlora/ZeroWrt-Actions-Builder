#!/bin/sh

# 网络诊断
if [ $(uci -q get luci.diag.ping) = "immortalwrt.org" ]; then
    uci set luci.diag.dns='www.qq.com'
    uci set luci.diag.ping='www.qq.com'
    uci set luci.diag.route='www.qq.com'
    uci commit luci
fi

