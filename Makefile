# Copyright (C) 2025  OneNAS-space <https://github.com/OneNAS-space/luci-app-advanced/>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=luci-app-advanced
PKG_VERSION:=2.2.0
PKG_RELEASE:=20251203
PKG_BUILD_DEPENDS:=luci-base/host

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	DEPENDS:=
	TITLE:=LuCI Support for advanced with fileassistant
	PKGARCH:=all
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/advanced $(1)/etc/config/
	
	$(INSTALL_DIR) $(1)/www
	cp -pR ./htdocs/* $(1)/www/
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/* $(1)/etc/uci-defaults/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh_Hans/advanced.po $(1)/usr/lib/lua/luci/i18n/advanced.zh-cn.lmo
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
