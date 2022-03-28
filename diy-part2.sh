#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

#sed -i 's,http://www.cryptopp.com/,https://src.fedoraproject.org/lookaside/pkgs/rpms/cryptopp/cryptopp564.zip/4ee7e5cdd4a45a14756c169eaf2a77fc,g' package/lean/libcryptopp/Makefile

cat <<EOF >> package/kernel/mac80211/patches/rt2x00/651-rt2x00-driver-compile-with-kernel-5.15.patch
From 8d9252c789b01c97d4dbac85765e1e13e2411470 Mon Sep 17 00:00:00 2001
From: W_Y_CPP <383152993@qq.com>
Date: Sun, 27 Feb 2022 20:49:30 -0500
Subject: [PATCH] fix ralink driver compile with kernel 5.15
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index f0f9d2e13..676a7df03 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -997,10 +997,13 @@ void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr
 	if (pdata && pdata->mac_address)
 		ether_addr_copy(eeprom_mac_addr, pdata->mac_address);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 15, 0) 
+	of_get_mac_address(rt2x00dev->dev->of_node,eeprom_mac_addr);
+#else
 	mac_addr = of_get_mac_address(rt2x00dev->dev->of_node);
 	if (!IS_ERR(mac_addr))
 		ether_addr_copy(eeprom_mac_addr, mac_addr);
-
+#endif
 	if (!is_valid_ether_addr(eeprom_mac_addr)) {
 		eth_random_addr(eeprom_mac_addr);
 		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", eeprom_mac_addr);
-- 
2.17.1
EOF
