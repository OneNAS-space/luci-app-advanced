# Copyright (C) 2025  OneNAS-space <https://github.com/OneNAS-space/luci-app-advanced/>
#
# This is free software, licensed under the MIT License
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=luci-app-advanced
PKG_VERSION:=3.3.0
PKG_RELEASE:=2
PKG_BUILD_DEPENDS:=luci-base/host

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	DEPENDS:=
	TITLE:=LuCI Support for advanced with fileassistant
	PKGARCH:=all
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/advanced
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) ./root/etc/sysinfo $(1)/etc/

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/advanced $(1)/etc/config/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/bypass_guard $(1)/etc/init.d/bypass_guard

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/* $(1)/etc/uci-defaults/

	$(INSTALL_DIR) $(1)/usr/share/bypass_guard/scripts
	$(INSTALL_BIN) ./root/usr/share/bypass_guard/scripts/natmap_bypass.sh $(1)/usr/share/bypass_guard/scripts/natmap_bypass.sh

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh_Hans/advanced.po $(1)/usr/lib/lua/luci/i18n/advanced.zh-cn.lmo
	po2lmo ./po/en/advanced.po $(1)/usr/lib/lua/luci/i18n/advanced.en.lmo

	$(INSTALL_DIR) $(1)/www
	cp -pR ./htdocs/* $(1)/www/
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/rpcd reload
fi
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
