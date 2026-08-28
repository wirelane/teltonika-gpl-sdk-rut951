ifneq ($(CONFIG_VERIFIED_BOOT_SUPPORT),)
#This dir should contain X509 public certificates of signing keys.
#In the case of local signing, it should also contain the private keys.
#public key/cert extension: .crt, .pub
#private keys extension: .key, .priv
VERIFIED_BOOT_KEY_DIR := $(TOPDIR)/vboot_keys

# (sha256:sha384:sha512),(rsa2048:rsa3072:rsa4096)
VERIFIED_BOOT_ALGO := sha384,rsa4096
ifneq ($(CONFIG_VERIFIED_BOOT_LOCAL_SIGN),)

VERIFIED_BOOT_FIT_CONF_KEY_PREFIX := dev_fit_conf

ifneq ($(CONFIG_VERIFIED_BOOT_FIT_CERT_IN_IMAGE),)
VERIFIED_BOOT_FIT_CERT_KEY_PREFIX := dev_fit_cert
endif #CONFIG_VERIFIED_BOOT_FIT_CERT_IN_IMAGE

else #CONFIG_VERIFIED_BOOT_LOCAL_SIGN

ifneq ($(CI),true)
# Locally, use these values, when CI variable is true - use the ones below
VERIFIED_BOOT_SIGNER := $(VERIFIED_BOOT_KEY_DIR)/test/sign_online.sh
VERIFIED_BOOT_FIT_CONF_KEY_PREFIX := fit_conf

ifneq ($(CONFIG_VERIFIED_BOOT_FIT_CERT_IN_IMAGE),)
VERIFIED_BOOT_FIT_CERT_KEY_PREFIX := fit_cert
endif #CONFIG_VERIFIED_BOOT_FIT_CERT_IN_IMAGE

else
VERIFIED_BOOT_SIGNER := /usr/sbin/sign_online # this exists only on CI/CD runners
VERIFIED_BOOT_FIT_CONF_KEY_PREFIX := fit_conf-a

ifneq ($(CONFIG_VERIFIED_BOOT_FIT_CERT_IN_IMAGE),)
VERIFIED_BOOT_FIT_CERT_KEY_PREFIX := "fit_cert-a"
endif #CONFIG_VERIFIED_BOOT_FIT_CERT_IN_IMAGE

endif #CI

endif #CONFIG_VERIFIED_BOOT_LOCAL_SIGN

endif #CONFIG_VERIFIED_BOOT_SUPPORT
