#
# Copyright (C) 2012-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=strongswan5
PKG_VERSION:=5.9.14
PKG_RELEASE:=1

# Legacy strongSwan 5.9.x kept for SMALL_FLASH devices only (see strongswan for 6.x).
# Upstream tarball is named strongswan-*, and it unpacks to strongswan-$(PKG_VERSION),
# so keep the source references and build dir on the upstream name.
PKG_BUILD_DIR:=$(BUILD_DIR)/strongswan-$(PKG_VERSION)

PKG_SOURCE_VERSION:=5.9.14
PKG_SOURCE:=strongswan-$(PKG_SOURCE_VERSION).tar.bz2

PKG_SOURCE_URL:=https://download.strongswan.org/ https://download2.strongswan.org/
PKG_HASH:=728027ddda4cb34c67c4cec97d3ddb8c274edfbabdaeecf7e74693b54fc33678
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Philip Prindeville <philipp@redfish-solutions.com>, Noel Kuntze <noel.kuntze@thermi.consulting>
PKG_CPE_ID:=cpe:/a:strongswan:strongswan

PKG_MOD_AVAILABLE:= \
	addrblock \
	aes \
	af-alg \
	agent \
	attr \
	attr-sql \
	bliss \
	blowfish \
	ccm \
	chapoly \
	cmac \
	constraints \
	connmark \
	coupling \
	ctr \
	curl \
	curve25519 \
	des \
	dhcp \
	dnskey \
	drbg \
	duplicheck \
	eap-dynamic \
	eap-identity \
	eap-md5 \
	eap-mschapv2 \
	eap-radius \
	eap-tls \
	farp \
	fips-prf \
	forecast \
	gcm \
	gcrypt \
	gmp \
	gmpdh \
	ha \
	hmac \
	kdf \
	kernel-libipsec \
	kernel-netlink \
	ldap \
	led \
	load-tester \
	nonce \
	md4 \
	md5 \
	mgf1 \
	mysql \
	newhope \
	ntru \
	openssl \
	pem \
	pgp \
	pkcs1 \
	pkcs7 \
	pkcs8 \
	pkcs11 \
	pkcs12 \
	pubkey \
	random \
	rc2 \
	resolve \
	revocation \
	sha1 \
	sha2 \
	sha3 \
	smp \
	socket-default \
	socket-dynamic \
	sql \
	sqlite \
	sshkey \
	stroke \
	test-vectors \
	unity \
	uci \
	updown \
	vici \
	whitelist \
	x509 \
	xauth-eap \
	xauth-generic \
	xcbc \
	tpm

PKG_CONFIG_DEPENDS:= \
	CONFIG_STRONGSWAN5_ROUTING_TABLE \
	CONFIG_STRONGSWAN5_ROUTING_TABLE_PRIO \
	$(patsubst %,CONFIG_PACKAGE_strongswan5-mod-%,$(PKG_MOD_AVAILABLE)) \

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
# strongswan-mod-mysql needs iconv
include $(INCLUDE_DIR)/nls.mk

define Package/strongswan5/Default
  SUBMENU:=VPN
  SECTION:=net
  CATEGORY:=Network
  TITLE:=StrongSwan
  URL:=http://www.strongswan.org/
  FATTRS:=/usr/lib/ipsec/charon::::cap_net_admin,cap_net_bind_service,cap_net_raw+ep
  USERID:=ipsec:ipsec
endef

define Package/strongswan5/description/Default
 StrongSwan is an OpenSource IPsec implementation for the Linux operating system.
endef

define Package/strongswan5
$(call Package/strongswan5/Default)
  MENU:=1
  DEPENDS:= +libpthread +ip \
	+kmod-crypto-aead \
	+kmod-crypto-authenc \
	+kmod-crypto-cbc \
	+kmod-lib-zlib-inflate \
	+kmod-lib-zlib-deflate \
	+kmod-crypto-des \
	+kmod-crypto-echainiv \
	+kmod-crypto-hmac \
	+kmod-crypto-md5 \
	+kmod-crypto-sha1 \
	+kmod-ipsec +kmod-ipsec4 +IPV6:kmod-ipsec6
endef

define Package/strongswan5/config
  source "$(SOURCE)/Config.in"
endef

define Package/strongswan5/description
$(call Package/strongswan5/description/Default)
 This package contains shared libraries and scripts.
endef

define Package/strongswan5-full
$(call Package/strongswan5/Default)
  TITLE+= (full)
  DEPENDS:= strongswan5 \
	+strongswan5-charon \
	+strongswan5-charon-cmd \
	+strongswan5-ipsec \
	+strongswan5-libnttfft \
	+strongswan5-mod-addrblock \
	+strongswan5-mod-aes \
	+strongswan5-mod-af-alg \
	+strongswan5-mod-agent \
	+strongswan5-mod-attr \
	+strongswan5-mod-attr-sql \
	+strongswan5-mod-bliss \
	+strongswan5-mod-blowfish \
	+strongswan5-mod-ccm \
	+strongswan5-mod-chapoly \
	+strongswan5-mod-cmac \
	+strongswan5-mod-constraints \
	+strongswan5-mod-connmark \
	+strongswan5-mod-coupling \
	+strongswan5-mod-ctr \
	+strongswan5-mod-curl \
	+strongswan5-mod-curve25519 \
	+strongswan5-mod-des \
	+strongswan5-mod-dhcp \
	+strongswan5-mod-dnskey \
	+strongswan5-mod-drbg \
	+strongswan5-mod-duplicheck \
	+strongswan5-mod-eap-dynamic \
	+strongswan5-mod-eap-identity \
	+strongswan5-mod-eap-md5 \
	+strongswan5-mod-eap-mschapv2 \
	+strongswan5-mod-eap-radius \
	+strongswan5-mod-eap-tls \
	+strongswan5-mod-farp \
	+strongswan5-mod-fips-prf \
	+strongswan5-mod-forecast \
	+strongswan5-mod-gcm \
	+strongswan5-mod-gcrypt \
	+strongswan5-mod-gmp \
	+strongswan5-mod-ha \
	+strongswan5-mod-hmac \
	+strongswan5-mod-kdf \
	+strongswan5-mod-kernel-netlink \
	+strongswan5-mod-led \
	+strongswan5-mod-load-tester \
	+strongswan5-mod-nonce \
	+strongswan5-mod-md4 \
	+strongswan5-mod-md5 \
	+strongswan5-mod-mgf1 \
	+strongswan5-mod-newhope \
	+strongswan5-mod-ntru \
	+strongswan5-mod-openssl \
	+strongswan5-mod-pem \
	+strongswan5-mod-pgp \
	+strongswan5-mod-pkcs1 \
	+strongswan5-mod-pkcs7 \
	+strongswan5-mod-pkcs8 \
	+strongswan5-mod-pkcs11 \
	+strongswan5-mod-pkcs12 \
	+strongswan5-mod-pubkey \
	+strongswan5-mod-random \
	+strongswan5-mod-rc2 \
	+strongswan5-mod-resolve \
	+strongswan5-mod-revocation \
	+strongswan5-mod-sha1 \
	+strongswan5-mod-sha2 \
	+strongswan5-mod-sha3 \
	+strongswan5-mod-smp \
	+strongswan5-mod-socket-default \
	+strongswan5-mod-sql \
	+strongswan5-mod-sqlite \
	+strongswan5-mod-sshkey \
	+strongswan5-mod-stroke \
	+strongswan5-mod-test-vectors \
	+strongswan5-mod-uci \
	+strongswan5-mod-unity \
	+strongswan5-mod-updown \
	+strongswan5-mod-vici \
	+strongswan5-mod-whitelist \
	+strongswan5-mod-x509 \
	+strongswan5-mod-xauth-eap \
	+strongswan5-mod-xauth-generic \
	+strongswan5-mod-xcbc \
	+strongswan5-pki \
	+strongswan5-swanctl \
	@DEVEL
endef

define Package/strongswan5-full/description
$(call Package/strongswan5/description/Default)
 This meta-package contains dependencies for all of the strongswan plugins
 except kernel-libipsec,
 socket-dynamic and which are omitted in favor of the kernel-netlink and
 socket-default plugins.
endef


define Package/strongswan5-default
$(call Package/strongswan5/Default)
  TITLE+= (default)
  DEPENDS:= strongswan5 \
	+strongswan5-charon \
	+strongswan5-ipsec \
	+strongswan5-mod-aes \
	+strongswan5-mod-attr \
	+strongswan5-mod-connmark \
	+strongswan5-mod-constraints \
	+strongswan5-mod-des \
	+strongswan5-mod-dnskey \
	+strongswan5-mod-fips-prf \
	+strongswan5-mod-gmp \
	+strongswan5-mod-hmac \
	@(PACKAGE_strongswan5-mod-kdf||PACKAGE_strongswan5-mod-openssl||PACKAGE_strongswan5-mod-wolfssl) \
	+strongswan5-mod-kernel-netlink \
	+strongswan5-mod-md5 \
	+strongswan5-mod-mgf1 \
	+strongswan5-mod-nonce \
	+strongswan5-mod-pem \
	+strongswan5-mod-pgp \
	+strongswan5-mod-pkcs1 \
	+strongswan5-mod-pubkey \
	+strongswan5-mod-random \
	+strongswan5-mod-rc2 \
	+strongswan5-mod-resolve \
	+strongswan5-mod-revocation \
	+strongswan5-mod-sha1 \
	+strongswan5-mod-sha2 \
	+strongswan5-mod-socket-default \
	+strongswan5-mod-sshkey \
	+strongswan5-mod-stroke \
	+strongswan5-mod-updown \
	+strongswan5-mod-x509 \
	+strongswan5-mod-xauth-generic \
	+strongswan5-mod-xcbc \
	+strongswan5-pki
endef

define Package/strongswan5-default/description
$(call Package/strongswan5/description/Default)
 This meta-package contains only dependencies to match upstream defaults.
endef

define Package/strongswan5-isakmp
$(call Package/strongswan5/Default)
  TITLE+= (isakmp)
  DEPENDS:= strongswan5 \
	+strongswan5-charon \
	+strongswan5-ipsec \
	+strongswan5-mod-aes \
	+strongswan5-mod-des \
	+strongswan5-mod-gmpdh \
	+strongswan5-mod-hmac \
	@(PACKAGE_strongswan5-mod-kdf||PACKAGE_strongswan5-mod-openssl||PACKAGE_strongswan5-mod-wolfssl) \
	+strongswan5-mod-kernel-netlink \
	+strongswan5-mod-md5 \
	+strongswan5-mod-nonce \
	+strongswan5-mod-pubkey \
	+strongswan5-mod-random \
	+strongswan5-mod-sha1 \
	+strongswan5-mod-socket-default \
	+strongswan5-mod-stroke \
	+strongswan5-mod-uci \
	+strongswan5-mod-updown
endef

define Package/strongswan5-isakmp/description
$(call Package/strongswan5/description/Default)
 This meta-package contains only dependencies to establish  ISAKMP /
 IKE PSK connections, dropping other capabilities in favor of small size
 Can fit most routers even with 4Mb flash (after removing IPv6 support).
endef


define Package/strongswan5-minimal
$(call Package/strongswan5/Default)
  TITLE+= (minimal)
  DEPENDS:= strongswan5 \
	+strongswan5-charon \
	+strongswan5-swanctl \
	+strongswan5-mod-kernel-netlink \
	+strongswan5-mod-nonce \
	+strongswan5-mod-mgf1 \
	+strongswan5-mod-pubkey \
	+strongswan5-mod-socket-default \
	+strongswan5-mod-updown \
	+strongswan5-mod-x509 \
	+strongswan5-mod-xcbc \
	+strongswan5-mod-connmark \
	+strongswan5-mod-random \
	+strongswan5-mod-xauth-generic \
	+strongswan5-mod-vici \
	+strongswan5-mod-revocation \
	+strongswan5-mod-pkcs1 \
	+strongswan5-mod-pgp \
	+strongswan5-mod-pem \
	+strongswan5-mod-constraints \
	+strongswan5-mod-openssl \
	+strongswan5-mod-eap-identity \
	+strongswan5-mod-eap-mschapv2 \
	+strongswan5-mod-pkcs8
endef

define Package/strongswan5-minimal/description
$(call Package/strongswan5/description/Default)
 This meta-package contains only dependencies for a minimal IKEv2 setup.
endef

define Package/strongswan5-charon
$(call Package/strongswan5/Default)
  TITLE+= IKEv1/IKEv2 keying daemon
  DEPENDS:= strongswan5
endef

define Package/strongswan5-charon/description
$(call Package/strongswan5/description/Default)
 This package contains charon, an IKEv2 keying daemon.
endef

define Package/strongswan5-charon-cmd
$(call Package/strongswan5/Default)
  TITLE+= charon-cmd utility
  DEPENDS:= strongswan5 +strongswan5-charon
endef

define Package/strongswan5-charon-cmd/description
$(call Package/strongswan5/description/Default)
 This package contains the charon-cmd utility.
endef

define Package/strongswan5-ipsec
$(call Package/strongswan5/Default)
  TITLE+= utilities
  DEPENDS:= strongswan5
endef

define Package/strongswan5-ipsec/description
$(call Package/strongswan5/description/Default)
 This package contains the ipsec utility.
endef

define Package/strongswan5-libnttfft
$(call Package/strongswan5/Default)
  TITLE+= nttfft library
  DEPENDS:= strongswan5
endef

define Package/strongswan5-libnttfft/description
$(call Package/strongswan5/description/Default)
 This package contains the Number Theoretic Transforms library.
endef

define Package/strongswan5-pki
$(call Package/strongswan5/Default)
  TITLE+= PKI tool
  DEPENDS:= strongswan5 +strongswan5-libtls
endef

define Package/strongswan5-pki/description
  This package contains the pki tool.
endef

define Package/strongswan5-tss-tss2
$(call Package/strongswan5/Default)
  TITLE+= TSS-TSS2
  DEPENDS:= strongswan5 +tpm2-tss
endef

define Package/strongswan5-tss-tss2/description
  strongswan tss2 lib for tpm support
endef

define Package/strongswan5-swanctl
$(call Package/strongswan5/Default)
  TITLE+= swanctl utility
  DEPENDS:= strongswan5 +strongswan5-mod-vici
endef

define Package/strongswan5-swanctl/description
$(call Package/strongswan5/description/Default)
 This package contains the swanctl utility.
endef

define Package/strongswan5-gencerts
$(call Package/strongswan5/Default)
  TITLE+= X.509 certificate generation utility
  DEPENDS:= strongswan5 +strongswan5-pki bash
endef

define Package/strongswan5-gencerts/description
$(call Package/strongswan5/description/Default)
 This package contains the X.509 certificate generation utility.
endef

define Package/strongswan5-libtls
$(call Package/strongswan5/Default)
  TITLE+= libtls
  DEPENDS:= strongswan5
endef

define Package/strongswan5-libtls/description
$(call Package/strongswan5/description/Default)
 This package contains libtls for strongSwan plugins eap-tls, eap-ttls,
 eap-peap, tnc-tnccs
endef

define Package/strongswan5-check
$(call Package/strongswan5/Default)
  TITLE+:= strongswan-check
  DEPENDS:= strongswan5
endef

define Package/strongswan5-check/description
$(call Package/strongswan5/description/Default)
 This is a tool to test ipsec connection
endef

define Build/Install
	find $(PKG_BUILD_DIR)/src $(PKG_BUILD_DIR)/conf -name '*.conf' -print -exec sed -i -e 's/#.*$$$$//' -e '/^[[:space:]]*$$$$/d' {} +
	$(call Build/Install/Default)
endef

define BuildPlugin
  define Package/strongswan5-mod-$(1)
    $$(call Package/strongswan5/Default)
    TITLE:= StrongSwan $(2) plugin
    DEPENDS:= strongswan5 $(3)
  endef

  define Package/strongswan5-mod-$(1)/install
	$(eval DEST_DIR:=$$$$(1)$(if $(findstring m,$(CONFIG_PACKAGE_strongswan5-mod-$(1))),,/usr/local))
	$(INSTALL_DIR) $$(1)/etc/strongswan.d/charon
	if [ -f $(PKG_INSTALL_DIR)/etc/strongswan.d/charon/$(1).conf ]; then \
		$(INSTALL_DATA) $(PKG_INSTALL_DIR)/etc/strongswan.d/charon/$(1).conf $$(1)/etc/strongswan.d/charon/; fi
	$(INSTALL_DIR) $(DEST_DIR)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-$(1).so \
		$(DEST_DIR)/usr/lib/ipsec/plugins/
	$(call Plugin/$(1)/install,$$(1))
  endef

  $$(eval $$(call BuildPackage,strongswan5-mod-$(1)))
endef

CONFIGURE_ARGS+= \
	--disable-scripts \
	--disable-static \
	--disable-fast \
	--enable-nonce \
	--enable-mgf1 \
	--enable-mediation \
	--with-systemdsystemunitdir=no \
	--with-user=ipsec \
	--with-group=ipsec \
	--with-capabilities=native \
	--with-piddir=/var/run/ipsec \
	$(if $(CONFIG_PACKAGE_strongswan5-charon-cmd),--enable-cmd,--disable-cmd) \
	$(if $(CONFIG_PACKAGE_strongswan5-pki),--enable-pki,--disable-pki) \
	$(if $(CONFIG_PACKAGE_strongswan5-tss-tss2),--enable-tss-tss2,--disable-tss-tss2) \
	--with-random-device=/dev/random \
	--with-urandom-device=/dev/urandom \
	--with-routing-table="$(call qstrip,$(CONFIG_STRONGSWAN5_ROUTING_TABLE))" \
	--with-routing-table-prio="$(call qstrip,$(CONFIG_STRONGSWAN5_ROUTING_TABLE_PRIO))" \
	$(foreach m,$(PKG_MOD_AVAILABLE), \
	  $(if $(CONFIG_PACKAGE_strongswan5-mod-$(m)),--enable-$(m),--disable-$(m)) \
	) \
	ac_cv_search___atomic_load=no

define Package/strongswan5/conffiles
/etc/strongswan.conf
/etc/strongswan.d/
/etc/config/ipsec
endef

define Package/strongswan5/install
	$(INSTALL_DIR) $(1)/etc $(1)/etc/permtab.d
	$(INSTALL_CONF) ./files/etc/strongswan.conf $(1)/etc/
	echo -e "\ninclude /var/run/ipsec/ipsec/strongswan.conf" >> $(1)/etc/strongswan.conf
	$(INSTALL_DIR) $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libstrongswan.so.* $(1)/usr/lib/ipsec/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF_USR) ./files/ipsec.config $(1)/etc/config/ipsec
	$(INSTALL_DATA) files/ipsec.permtab $(1)/etc/permtab.d/ipsec
	$(INSTALL_DIR) $(1)/etc/uci-defaults/7.17 $(1)/etc/uci-defaults/7.21 $(1)/etc/uci-defaults/7.22 $(1)/etc/uci-defaults/7.24
	$(INSTALL_DATA) files/defaults/99_ipsec_add_new_path $(1)/etc/uci-defaults/7.17/99_ipsec_add_new_path
	$(INSTALL_DATA) files/defaults/7.21/99_migrate_passthrough $(1)/etc/uci-defaults/7.21/99_migrate_passthrough
	$(INSTALL_DATA) files/defaults/7.22/99_migrate_ikev1_proposals $(1)/etc/uci-defaults/7.22/99_migrate_ikev1_proposals
	$(INSTALL_DATA) files/defaults/7.22/99_migrate_duplicate_proposals $(1)/etc/uci-defaults/7.22/99_migrate_duplicate_proposals
	$(INSTALL_DATA) files/defaults/7.24/99_migrate_psk_remote_identifier $(1)/etc/uci-defaults/7.24/99_migrate_psk_remote_identifier
endef

define Package/strongswan5-default/install
	true
endef

define Package/strongswan5-full/install
	true
endef

define Package/strongswan5-isakmp/install
	true
endef

define Package/strongswan5-minimal/install
	true
endef

define Package/strongswan5-charon/install
	$(INSTALL_DIR) $(1)/etc/strongswan.d
	$(CP) $(PKG_INSTALL_DIR)/etc/strongswan.d/charon.conf $(1)/etc/strongswan.d
	$(CP) $(PKG_INSTALL_DIR)/etc/strongswan.d/charon-logging.conf $(1)/etc/strongswan.d
	$(INSTALL_DIR) $(1)/usr/lib/ipsec
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/ipsec/charon $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libcharon.so.* $(1)/usr/lib/ipsec/
endef

define Package/strongswan5-charon-cmd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/charon-cmd $(1)/usr/sbin/
endef

define Package/strongswan5-ipsec/conffiles
/etc/ipsec.d/
/etc/ipsec.conf
/etc/ipsec.secrets
/etc/ipsec.user
endef

define Package/strongswan5-ipsec/install
	$(INSTALL_DIR) $(1)/etc/ $(1)/usr/sbin
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/ipsec.conf $(1)/etc/
	echo -e "\ninclude /var/run/ipsec/ipsec/ipsec.conf" >> $(1)/etc/ipsec.conf
	$(INSTALL_CONF) ./files/ipsec.secrets $(1)/etc/
	echo -e "\ninclude /var/run/ipsec/ipsec/ipsec.secrets " >> $(1)/etc/ipsec.secrets
	$(INSTALL_CONF) ./files/ipsec.user $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ipsec.init $(1)/etc/init.d/ipsec
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/ipsec $(1)/usr/sbin/
endef

define Package/strongswan5-ipsec/postinst
#!/bin/sh

[ -z "$${IPKG_INSTROOT}" ] || exit 0

opkg list-changed-conffiles | grep -qx /etc/ipsec.conf || {
	rm -f /etc/ipsec.conf-opkg
}
endef

define Package/strongswan5-libnttfft/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libnttfft.so.* $(1)/usr/lib/ipsec/
endef

define Package/strongswan5-pki/install
	$(INSTALL_DIR) $(1)/etc/strongswan.d
	$(CP) $(PKG_INSTALL_DIR)/etc/strongswan.d/pki.conf $(1)/etc/strongswan.d/
	$(INSTALL_DIR) $(1)/etc/permtab.d
	$(INSTALL_DATA) ./files/cert-enroll.permtab $(1)/etc/permtab.d/cert-enroll
	$(eval DEST_DIR:=$$(1)$(if $(findstring m,$(CONFIG_PACKAGE_strongswan5-pki)),,/usr/local))
	$(INSTALL_DIR) $(DEST_DIR)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/pki $(DEST_DIR)/usr/bin/
	$(INSTALL_DIR) $(DEST_DIR)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/cert-enroll.d
	$(CP) ./files/etc/cert-enroll.d $(1)/etc/
	$(INSTALL_BIN) ./files/usr/sbin/cert-enroll.sh $(DEST_DIR)/usr/sbin
endef

define Package/strongswan5-swanctl/conffiles
/etc/config/ipsec
/etc/swanctl/
endef

define Package/strongswan5-swanctl/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/swanctl/{bliss,conf.d,ecdsa,pkcs{12,8},private,pubkey,rsa}
	$(INSTALL_DIR) $(1)/etc/swanctl/x509{,aa,ac,ca,crl,ocsp}
	$(CP) $(PKG_INSTALL_DIR)/etc/swanctl/swanctl.conf $(1)/etc/swanctl/
	echo "include /var/run/ipsec/swanctl/swanctl.conf" >> $(1)/etc/swanctl/swanctl.conf
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/swanctl $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/swanctl.init $(1)/etc/init.d/swanctl
endef

define Package/strongswan5-gencerts/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/gencerts.sh $(1)/usr/bin/gencerts
endef

define Package/strongswan5-libtls/install
	$(eval DEST_DIR:=$$(1)$(if $(findstring m,$(CONFIG_PACKAGE_strongswan5-libtls)),,/usr/local))
	$(INSTALL_DIR) $(DEST_DIR)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libtls.so.* $(DEST_DIR)/usr/lib/
endef

define Package/strongswan5-check/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/ipsec.test $(1)/usr/sbin/ipsec_check
endef

define Plugin/duplicheck/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/duplicheck $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-duplicheck.so $(1)/usr/lib/ipsec/plugins/
endef

define Plugin/eap-radius/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libradius.so.* $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-eap-radius.so $(1)/usr/lib/ipsec/plugins/
endef

define Plugin/attr-sql/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/pool $(1)/usr/lib/ipsec/
endef

define Plugin/stroke/install
	$(INSTALL_DIR) $(1)/etc/ipsec.d/{aacerts,acerts,cacerts,certs,crls,ocspcerts,private,reqs}

	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/ipsec/{starter,stroke} $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-stroke.so $(1)/usr/lib/ipsec/plugins/
endef

define Plugin/updown/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/_updown $(1)/usr/lib/ipsec/
	$(INSTALL_BIN) ./files/usr/lib/ipsec/_updown_no_fw $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-updown.so $(1)/usr/lib/ipsec/plugins/
	$(INSTALL_DIR) $(1)/etc/hotplug.d/ipsec
	$(INSTALL_BIN) ./files/etc/hotplug.d/ipsec/* $(1)/etc/hotplug.d/ipsec/
	$(INSTALL_DIR) $(1)/usr/share/acl.d
	$(INSTALL_DATA) ./files/ipsec_acl.json $(1)/usr/share/acl.d/ipsec_acl.json
endef

define Plugin/vici/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libvici.so.* $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-vici.so $(1)/usr/lib/ipsec/plugins/
endef

define Plugin/whitelist/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/whitelist $(1)/usr/lib/ipsec/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/plugins/libstrongswan-whitelist.so $(1)/usr/lib/ipsec/plugins/
endef

define Plugin/kernel-libipsec/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libipsec.so.* $(1)/usr/lib/ipsec/
endef

define Package/strongswan5-tss-tss2/install
	$(INSTALL_DIR) $(1)/usr/lib/ipsec/plugins
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/ipsec/libtpmtss.so.* $(1)/usr/lib/ipsec/
endef

$(eval $(call BuildPackage,strongswan5))
$(eval $(call BuildPackage,strongswan5-default))
$(eval $(call BuildPackage,strongswan5-full))
$(eval $(call BuildPackage,strongswan5-minimal))
$(eval $(call BuildPackage,strongswan5-isakmp))
$(eval $(call BuildPackage,strongswan5-charon))
$(eval $(call BuildPackage,strongswan5-charon-cmd))
$(eval $(call BuildPackage,strongswan5-ipsec))
$(eval $(call BuildPackage,strongswan5-libnttfft))
$(eval $(call BuildPackage,strongswan5-pki))
$(eval $(call BuildPackage,strongswan5-swanctl))
$(eval $(call BuildPackage,strongswan5-gencerts))
$(eval $(call BuildPackage,strongswan5-libtls))
$(eval $(call BuildPackage,strongswan5-check))
$(eval $(call BuildPackage,strongswan5-tss-tss2))
$(eval $(call BuildPlugin,addrblock,RFC 3779 address block constraint support,))
$(eval $(call BuildPlugin,aes,AES crypto,))
$(eval $(call BuildPlugin,af-alg,AF_ALG crypto interface to Linux Crypto API,+kmod-crypto-user))
$(eval $(call BuildPlugin,agent,SSH agent signing,))
$(eval $(call BuildPlugin,attr,file based config,))
$(eval $(call BuildPlugin,attr-sql,SQL based config,+strongswan5-charon))
$(eval $(call BuildPlugin,bliss,BLISS crypto,+strongswan5-libnttfft +strongswan5-mod-mgf1 +strongswan5-mod-hmac))
$(eval $(call BuildPlugin,blowfish,Blowfish crypto,))
$(eval $(call BuildPlugin,ccm,CCM AEAD wrapper crypto,))
$(eval $(call BuildPlugin,chapoly,ChaCha20-Poly1305 AEAD crypto,))
$(eval $(call BuildPlugin,cmac,CMAC crypto,))
$(eval $(call BuildPlugin,connmark,netfilter connection marking,+libip4tc))
$(eval $(call BuildPlugin,constraints,advanced X509 constraint checking,))
$(eval $(call BuildPlugin,coupling,IKEv2 plugin to couple peer certificates permanently to authentication,))
$(eval $(call BuildPlugin,ctr,Counter Mode wrapper crypto,))
$(eval $(call BuildPlugin,curl,cURL fetcher plugin,+PACKAGE_strongswan5-mod-curl:libcurl))
$(eval $(call BuildPlugin,curve25519,Curve25519 Diffie-Hellman,))
$(eval $(call BuildPlugin,des,DES crypto,))
$(eval $(call BuildPlugin,dhcp,DHCP based attribute provider,))
$(eval $(call BuildPlugin,dnskey,DNS RR key decoding,))
$(eval $(call BuildPlugin,drbg,Deterministic random bit generator,,))
$(eval $(call BuildPlugin,duplicheck,advanced duplicate checking,))
$(eval $(call BuildPlugin,eap-dynamic,EAP dynamic selector,))
$(eval $(call BuildPlugin,eap-identity,EAP identity helper,))
$(eval $(call BuildPlugin,eap-md5,EAP MD5 (CHAP) EAP auth,))
$(eval $(call BuildPlugin,eap-mschapv2,EAP MS-CHAPv2 EAP auth,+strongswan5-mod-md4))
$(eval $(call BuildPlugin,eap-radius,EAP RADIUS auth,))
$(eval $(call BuildPlugin,eap-tls,EAP TLS auth,+strongswan5-libtls))
$(eval $(call BuildPlugin,farp,fake arp respsonses,))
$(eval $(call BuildPlugin,fips-prf,FIPS PRF crypto,+strongswan5-mod-sha1))
$(eval $(call BuildPlugin,forecast,forward multi/broadcast traffic,+libip4tc +kmod-ipt-conntrack-extra))
$(eval $(call BuildPlugin,gcm,GCM AEAD wrapper crypto,))
$(eval $(call BuildPlugin,gcrypt,libgcrypt,+PACKAGE_strongswan5-mod-gcrypt:libgcrypt))
$(eval $(call BuildPlugin,gmp,libgmp,+PACKAGE_strongswan5-mod-gmp:libgmp))
$(eval $(call BuildPlugin,gmpdh,DH-Groups; no libgmp dep,))
$(eval $(call BuildPlugin,ha,high availability cluster,))
$(eval $(call BuildPlugin,hmac,HMAC crypto,))
$(eval $(call BuildPlugin,kdf,KDF/PRF+,))
$(eval $(call BuildPlugin,kernel-libipsec,libipsec kernel interface,))
$(eval $(call BuildPlugin,kernel-netlink,netlink kernel interface,))
$(eval $(call BuildPlugin,led,LED blink on IKE activity,))
$(eval $(call BuildPlugin,load-tester,load testing,))
$(eval $(call BuildPlugin,nonce,nonce genereation,))
$(eval $(call BuildPlugin,md4,MD4 crypto,))
$(eval $(call BuildPlugin,md5,MD5 crypto,))
$(eval $(call BuildPlugin,mgf1,MGF1 crypto,))
$(eval $(call BuildPlugin,newhope,New Hope crypto,+strongswan5-libnttfft +strongswan5-mod-chapoly +strongswan5-mod-sha3))
$(eval $(call BuildPlugin,ntru,NTRU crypto,+strongswan5-mod-mgf1))
$(eval $(call BuildPlugin,openssl,OpenSSL crypto,+PACKAGE_strongswan5-mod-openssl:libopenssl))
$(eval $(call BuildPlugin,pem,PEM decoding,))
$(eval $(call BuildPlugin,pgp,PGP key decoding,))
$(eval $(call BuildPlugin,pkcs1,PKCS1 key decoding,))
$(eval $(call BuildPlugin,pkcs7,PKCS7 key decoding,))
$(eval $(call BuildPlugin,pkcs8,PKCS8 key decoding,))
$(eval $(call BuildPlugin,pkcs11,PKCS11 key decoding,))
$(eval $(call BuildPlugin,pkcs12,PKCS12 key decoding,))
$(eval $(call BuildPlugin,pubkey,raw public key,))
$(eval $(call BuildPlugin,random,RNG,))
$(eval $(call BuildPlugin,rc2,RC2 crypto,))
$(eval $(call BuildPlugin,resolve,DNS resolver,))
$(eval $(call BuildPlugin,revocation,X509 CRL/OCSP revocation,))
$(eval $(call BuildPlugin,sha1,SHA1 crypto,))
$(eval $(call BuildPlugin,sha2,SHA2 crypto,))
$(eval $(call BuildPlugin,sha3,SHA3 and SHAKE crypto,))
$(eval $(call BuildPlugin,smp,SMP configuration and control interface,+PACKAGE_strongswan5-mod-smp:libxml2))
$(eval $(call BuildPlugin,socket-default,default socket implementation for charon,))
$(eval $(call BuildPlugin,socket-dynamic,dynamic socket implementation for charon,))
$(eval $(call BuildPlugin,sql,SQL database interface,))
$(eval $(call BuildPlugin,sqlite,SQLite database interface,+strongswan5-mod-sql +PACKAGE_strongswan5-mod-sqlite:libsqlite3))
$(eval $(call BuildPlugin,sshkey,SSH key decoding,))
$(eval $(call BuildPlugin,stroke,Stroke,+strongswan5-charon +strongswan5-ipsec))
$(eval $(call BuildPlugin,test-vectors,crypto test vectors,))
$(eval $(call BuildPlugin,uci,UCI config interface,+PACKAGE_strongswan5-mod-uci:libuci))
$(eval $(call BuildPlugin,unity,Cisco Unity extension,))
$(eval $(call BuildPlugin,updown,updown firewall,+iptables +IPV6:ip6tables +iptables-mod-ipsec +kmod-ipt-ipsec +iptables-mod-ipopt))
$(eval $(call BuildPlugin,vici,Versatile IKE Configuration Interface,))
$(eval $(call BuildPlugin,whitelist,peer identity whitelisting,))
$(eval $(call BuildPlugin,x509,x509 certificate,))
$(eval $(call BuildPlugin,xauth-eap,EAP XAuth backend,))
$(eval $(call BuildPlugin,xauth-generic,generic XAuth backend,))
$(eval $(call BuildPlugin,xcbc,xcbc crypto,))
$(eval $(call BuildPlugin,tpm,TPM support,+strongswan5-charon +strongswan5-pki +strongswan5-tss-tss2))
