#
# Copyright (C) 2019 Lucian Cristian <lucian.cristian@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=frr8
PKG_VERSION:=8.4.2
PKG_RELEASE:=21
PKG_SOURCE_DATE:=2023-02-17


PKG_SOURCE_VERSION:=8.4.2
PKG_SOURCE_VERSION:=410d78b7a4f2c8b4d4c3736c6d6cdb710287ca80
PKG_SOURCE:=frr-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_FILE=$(PKG_SOURCE)
PKG_SOURCE_URL:=https://codeload.github.com/FRRouting/frr/tar.gz/$(PKG_SOURCE_VERSION)?
PKG_LICENSE_FILES:=COPYING COPYING-LGPLv2.1

PKG_HASH:=1334b050ea3d4144efeb7bdfe9c6976ebc91744810c5d8a7381a53fac2877ea9
PKG_MAINTAINER:=Lucian Cristian <lucian.cristian@gmail.com>

PKG_LICENSE:=GPL-2.0-only LGPL-2.1-only
PKG_CPE_ID:=cpe:/a:frrouting:frrouting

PKG_DAEMON_AVAILABLE:= \
	babeld \
	bfdd \
	bgpd \
	eigrpd \
	fabricd \
	isisd \
	ldpd \
	nhrp \
	ospfd \
	ospf6d \
	pathd \
	pbrd \
	pimd \
	ripd \
	ripngd \
	staticd \
	vrrpd

PKG_CONFIG_DEPENDS:= \
	CONFIG_IPV6 \
	CONFIG_FRR8_OPENSSL \
	CONFIG_FRR8_INTERNAL \
	CONFIG_FRR8_SNMP \
	CONFIG_FRR8_NO_SNMP \
	CONFIG_PACKAGE_frr8-libfrr \
	CONFIG_PACKAGE_frr8-vtysh \
	CONFIG_PACKAGE_frr8-watchfrr \
	CONFIG_PACKAGE_frr8-zebra \
	$(patsubst %,CONFIG_PACKAGE_frr8-%,$(PKG_DAEMON_AVAILABLE)) \

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=lto
PKG_INSTALL:=1

PKG_BUILD_DEPENDS:=frr/host

include $(INCLUDE_DIR)/package.mk

define Package/frr8-libfrr/config
  source "$(SOURCE)/Config.in"
endef

define Package/frr8/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  URL:=https://www.frrouting.org/
  DEPENDS:=frr8
endef

define Package/frr8
  $(call Package/frr8/Default)
  DEPENDS:=+librt
  TITLE:=The FRRouting (FRR) Software Routing Suite
  MENU:=1
endef

define Package/frr8/description
  FRRouting is free software that implements and manages various IPv4 and IPv6
  routing protocols.

  Currently FRRouting supports BGP4, BGP4+, OSPFv2, OSPFv3, RIPv1, RIPv2, RIPng,
  IS-IS, PIM-SM/MSDP, LDP, VRRP and Babel as well as very early support for EIGRP and
  NHRP.
endef

define Package/frr8-libfrr
  $(call Package/frr8/Default)
  TITLE:=zebra library
  DEPENDS+=+librt +libatomic +libcap +libjson-c +libyang8 +FRR8_OPENSSL:libopenssl +FRR8_SNMP:libnetsnmp
  CONFLICTS:=quagga-libzebra
endef

define Package/frr8-vtysh
  $(call Package/frr8/Default)
  DEPENDS+=+frr8-libfrr +libreadline +libncurses +more
  TITLE:=integrated shell for frr routing software
  CONFLICTS:=quagga-vtysh
  ifneq (,$(filter m,$(CONFIG_PACKAGE_frr8-vtysh))$(DUMP))
    PKG_TLT_NAME:=FRR VTYSH
    PKG_ROUTER:=$(TLT_PLATFORM_NAME)
  endif
endef

define Package/frr8-watchfrr
  $(call Package/frr8/Default)
  TITLE:=frr watchdog
  DEPENDS+=+frr8-libfrr
  DEFAULT:=n if PACKAGE_frr8
endef

define Package/frr8-zebra
  $(call Package/frr8/Default)
  TITLE:=Zebra daemon
  DEPENDS+=+frr8-libfrr
  DEFAULT:=y if PACKAGE_frr8
  CONFLICTS:=quagga-zebra
  FATTRS:=/usr/sbin/zebra::::cap_net_admin,cap_net_raw,cap_sys_admin+p
  USERID:=zebra:frr
endef

define Package/frr8-pythontools
  $(call Package/frr8/Default)
  TITLE:=Python reload tool
  DEPENDS+=+frr8-libfrr +python3-base +python3-light +python3-logging
endef

##Migrate from quagga
##should test file exists and link in frr folder
#define Package/frr/postinst
##!/bin/sh
#if [ -f /etc/quagga/ospfd.conf ]; then
#    ls to /etc/frr
#    sed enable ospfd daemon
#fi
#exit 0
#endef

# define Package/frr-zebra/conffiles
# /etc/frr/zebra.conf
# endef

# define Package/frr-babeld/conffiles
# /etc/frr/babeld.conf
# endef

define Package/frr8-bgpd/conffiles
/etc/config/bgp
endef

define Package/frr8-eigrpd/conffiles
/etc/config/eigrp
endef

# define Package/frr-isisd/conffiles
# /etc/frr/isisd.conf
# endef

define Package/frr8-ldpd/conffiles
/etc/config/mpls
endef

define Package/frr8-nhrp/conffiles
/etc/config/nhrp
endef

define Package/frr8-ospfd/conffiles
/etc/config/ospf
endef

# define Package/frr-ospf6d/conffiles
# /etc/frr/ospf6d.conf
# endef

# define Package/frr-pbrd/conffiles
# /etc/frr/pbrd.conf
# endef

# define Package/frr-pimd/conffiles
# /etc/frr/pimd.conf
# endef

define Package/frr8-ripd/conffiles
/etc/config/rip
endef

define Package/frr8-bfdd/conffiles
/etc/config/bfd
endef

# define Package/frr-staticd/conffiles
# /etc/config/static
# endef

# define Package/frr-ripngd/conffiles
# /etc/frr/ripngd.conf
# endef

# define Package/frr-libfrr/conffiles
# /etc/frr/vtysh.conf
# endef

define BuildDaemon
    define Package/frr8-$(1)
	$$(call Package/frr8/Default)
	TITLE:= $(1) routing engine
	DEPENDS+=+frr8-zebra $(2)

	ifeq ($(1),bgpd)
		DEPENDS+=+kmod-tcpmd5sig
		FATTRS:=/usr/sbin/bgpd::::cap_net_bind_service,cap_net_admin,cap_net_raw,cap_sys_admin+p
		USERID:=bgp:frr
	endif
	ifeq ($(1),ripd)
		FATTRS:=/usr/sbin/ripd::::cap_net_bind_service,cap_net_raw,cap_sys_admin+p
		USERID:=rip:frr
	endif
	ifeq ($(1),ospfd)
		FATTRS:=/usr/sbin/ospfd::::cap_net_bind_service,cap_net_raw,cap_sys_admin+p
		USERID:=ospf:frr
	endif
	ifeq ($(1),eigrpd)
		FATTRS:=/usr/sbin/eigrpd::::cap_net_bind_service,cap_net_admin,cap_net_raw+p
		USERID:=eigrp:frr
	endif
	ifeq ($(1),nhrp)
		FATTRS:=/usr/sbin/nhrpd::::cap_dac_override,cap_net_admin,cap_net_raw+p
		USERID:=nhrp:frr
	endif
	ifeq ($(1),ldpd)
		FATTRS:=/usr/sbin/ldpd::::cap_net_bind_service,cap_net_admin+p
		USERID:=ldp:frr
	endif
#	if [ "$(1)" == "bfdd" ]; then \
#	export HAVE_BFDD == 1 ; fi
    endef

    define Package/frr8-$(1)/install
		$(INSTALL_DIR) $$(1)/usr/sbin
		$(INSTALL_DIR) $$(1)/etc/config
		$(INSTALL_DIR) $$(1)/etc/permtab.d
		if [ "$(1)" == "nhrp" ]; then \
			$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/nhrpd $$(1)/usr/sbin/; \
			$(INSTALL_DIR) $$(1)/usr/lib; \
			$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfrrcares.so* $$(1)/usr/lib/; \
		else \
			$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/$(1) $$(1)/usr/sbin/; \
		fi
		config_name="$(1)"; \
		config_name="$$$$$$$${config_name::-1}"; \
		config_name="$$$$$$$${config_name/nhr/nhrp}"; \
		config_name="$$$$$$$${config_name/ldp/mpls}"; \
		$(INSTALL_CONF_USR) ./files/configs/"$$$$$$$${config_name}".conf $$(1)/etc/config/"$$$$$$$${config_name}"; \
		echo -e "/etc/config/$$$$$$$${config_name}	$$$$$$$${config_name}:frr	660	-\n" > $$(1)/etc/permtab.d/"$$$$$$$${config_name}"
    endef

    $$(eval $$(call BuildPackage,frr8-$(1)))
endef

TARGET_LDFLAGS += -Wl,--gc-sections,--as-needed -latomic

CONFIGURE_ARGS+= \
	--with-clippy=$(STAGING_DIR_HOSTPKG)/bin/clippy \
	--prefix=/usr \
	--enable-shared \
	--disable-static \
	--enable-ldpd \
	--disable-ospfclient \
	--disable-doc \
	--disable-backtrace \
	--disable-watchfrr \
	--disable-bgp-vnc \
	--disable-bgp-bmp \
	--sysconfdir=/etc/frr \
	--localstatedir=/var/run/frr \
	--with-vici-socket=/var/run/ipsec/charon.vici \
	$(if $(CONFIG_FRR8_OPENSSL),--with-crypto=openssl,) \
	$(if $(CONFIG_FRR8_SNMP),--enable-snmp,) \
	$(foreach m,$(PKG_DAEMON_AVAILABLE), \
	$(call autoconf_bool,CONFIG_PACKAGE_frr8-$(m),$(m)) ) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr8-vtysh,vtysh) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr8-libfrr,zebra)

define Package/frr8/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/frr $(1)/etc/permtab.d $(1)/etc/init.d
	$(INSTALL_BIN) ./files/frr.init $(1)/etc/init.d/frr
	$(INSTALL_DIR) $(1)/etc/uci-defaults/7.5 $(1)/etc/uci-defaults/7.7 $(1)/etc/uci-defaults/7.22
	$(INSTALL_DATA) ./files/defaults/97_frr_indexing $(1)/etc/uci-defaults/7.5/97_frr_indexing
	$(INSTALL_DATA) ./files/defaults/98_modify-frr.sh $(1)/etc/uci-defaults/7.5/98_modify-frr.sh
	$(INSTALL_DATA) ./files/defaults/99_migrate-frr.sh $(1)/etc/uci-defaults/7.5/99_migrate-frr.sh
	$(INSTALL_DATA) ./files/defaults/7.7/99-migrate-main_instance.sh $(1)/etc/uci-defaults/7.7/99-migrate-main_instance.sh
	$(INSTALL_DATA) ./files/defaults/7.22/99-migrate-bgp-name-option.sh $(1)/etc/uci-defaults/7.22/99-migrate-bgp-name-option.sh
	$(INSTALL_DATA) ./files/defaults/7.22/99-migrate-rip-name-option.sh $(1)/etc/uci-defaults/7.22/99-migrate-rip-name-option.sh

	$(INSTALL_DIR) $(1)/etc/uci-defaults/7.18
	$(INSTALL_DATA) ./files/defaults/99_fix_frr_broken_uci_default $(1)/etc/uci-defaults/7.18/99-recover-broken-config
	$(INSTALL_DATA) ./files/defaults/7.7/99-migrate-main_instance.sh $(1)/etc/uci-defaults/7.18/99-migrate-main_instance.sh
endef

define Package/frr8-watchfrr/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/frrcommon.sh $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/watchfrr.sh $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/watchfrr $(1)/usr/sbin/
endef

define Package/frr8-zebra/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/zebra $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr $(1)/etc/permtab.d
	$(INSTALL_DATA) ./files/zebra.conf $(1)/etc/frr/
	$(INSTALL_DATA) ./files/frr.permtab $(1)/etc/permtab.d/frr
endef

define Package/frr8-libfrr/install
	$(INSTALL_DIR) $(1)/usr/lib $(1)/etc/frr
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfrr.so* $(1)/usr/lib/
	$(if $(CONFIG_FRR8_SNMP),$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfrrsnmp.so* $(1)/usr/lib/,)
endef

define Package/frr8-pythontools/install
	$(INSTALL_DIR) $(1)/usr/lib/frr $(1)/usr/sbin $(1)/etc/frr
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/*.py $(1)/usr/lib/frr/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/frr-reload $(1)/usr/sbin/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/tools/etc/frr/support_bundle_commands.conf $(1)/etc/frr/
endef

define Package/frr8-vtysh/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/frr
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/vtysh $(1)/usr/bin/
	$(INSTALL_CONF) ./files/vtysh.conf $(1)/etc/frr/
endef

define generate_post_template
define Package/frr8-$(1)/postinst
	/etc/init.d/frr reload > /dev/null 2>&1
	exit 0
endef
define Package/frr8-$(1)/postrm
	/etc/init.d/frr reload > /dev/null 2>&1
	exit 0
endef
endef

$(foreach pkg,$(PKG_DAEMON_AVAILABLE),$(eval $(call generate_post_template,$(pkg))))
$(eval $(call BuildPackage,frr8))
$(eval $(call BuildPackage,frr8-libfrr))
$(eval $(call BuildPackage,frr8-pythontools))
$(eval $(call BuildPackage,frr8-watchfrr))
$(eval $(call BuildPackage,frr8-zebra))
$(eval $(call BuildPackage,frr8-vtysh))
$(eval $(call BuildDaemon,babeld,))
$(eval $(call BuildDaemon,bfdd,))
$(eval $(call BuildDaemon,bgpd,))
$(eval $(call BuildDaemon,eigrpd,))
$(eval $(call BuildDaemon,fabricd,))
$(eval $(call BuildDaemon,isisd,))
$(eval $(call BuildDaemon,ldpd,))
$(eval $(call BuildDaemon,nhrp,+libcares +iptables-mod-hashlimit +iptables-mod-nflog))
$(eval $(call BuildDaemon,ospfd,))
$(eval $(call BuildDaemon,ospf6d,@IPV6))
$(eval $(call BuildDaemon,pathd,))
$(eval $(call BuildDaemon,pbrd,))
$(eval $(call BuildDaemon,pimd,))
$(eval $(call BuildDaemon,ripd,))
$(eval $(call BuildDaemon,ripngd,@IPV6))
$(eval $(call BuildDaemon,staticd,))
$(eval $(call BuildDaemon,vrrpd,))
