#
# Copyright (C) 2021 Teltonika
#

include rules.mk

PKG_LIST ?= $(strip $(foreach m,$(shell jq -r 'to_entries[] | select(.value.third_party != true) | .key' "$(TOPDIR)/ipk_packages.json"),$(if $(filter m,$(CONFIG_PACKAGE_$(m))),$(m),)))
THIRD_PARTY_PKG_LIST ?= $(strip $(foreach m,$(shell jq -r 'to_entries[] | select(.value.third_party == true) | .key' "$(TOPDIR)/ipk_packages.json"),$(if $(filter m,$(CONFIG_PACKAGE_$(m))),$(m),)))
THIRD_PARTY_BUILD_KEY ?= $(TOPDIR)/key-build-third-party

ifeq ($(strip $(PKG_LIST) $(THIRD_PARTY_PKG_LIST)),)

define PM/Build/Clean
	true
endef
define PM/Build/Prepare
	true
endef
define PM/Build/Sign_ipk
	true
endef
define PM/Build
	true
endef
define PM/Build/Sign_index
	true
endef

else # $(PKG_LIST)

PM_DIR:=$(OUTPUT_DIR)/packages/$(ARCH_PACKAGES)/pm_packages
PM_THIRD_PARTY_DIR:=$(OUTPUT_DIR)/packages/$(ARCH_PACKAGES)/pm_packages_third_party
PM_ZIPPED_DIR:=$(OUTPUT_DIR)/packages/$(ARCH_PACKAGES)/zipped_packages

SIGN_FILE_LIST?=$(TMP_DIR)/pm/.sign-file-list
SIGN_THIRD_PARTY_LIST?=$(TMP_DIR)/pm/.third-party-sign-file-list

define PM/Build/Clean
	rm -fr "$(PM_DIR)" "$(PM_THIRD_PARTY_DIR)" "$(PM_ZIPPED_DIR)" "$(TMP_DIR)/pm"
endef

define PM/Build/Prepare
	mkdir -p "$(PM_DIR)" && \
	"$(SCRIPT_DIR)/prepare_tlt_pm_packages.sh" $(if $(CONFIG_GPL_BUILD),-i) -u "$(SIGN_FILE_LIST)" -t "$(SIGN_THIRD_PARTY_LIST)" "$(strip $(PKG_LIST) $(THIRD_PARTY_PKG_LIST))" "$(TOPDIR)" "$(ARCH_PACKAGES)" "$(PACKAGE_DIR)"
endef

define PM/Build/Sign_ipk
	"$(SCRIPT_DIR)/sign_packages.sh" "$(SIGN_FILE_LIST)"
	if [ -n "$(strip $(THIRD_PARTY_PKG_LIST))" ] && [ -s "$(SIGN_THIRD_PARTY_LIST)" ]; then \
		"$(SCRIPT_DIR)/sign_packages.sh" "$(SIGN_THIRD_PARTY_LIST)"; \
	fi
endef

define PM/Build
	mkdir -p "$(PM_ZIPPED_DIR)" && \
	"$(SCRIPT_DIR)/prepare_tlt_pm_packages.sh" $(if $(CONFIG_GPL_BUILD),-i) -p "$(strip $(PKG_LIST) $(THIRD_PARTY_PKG_LIST))" "$(TOPDIR)" "$(ARCH_PACKAGES)" "$(PACKAGE_DIR)"; \
	cd "$(PM_DIR)" && \
	{ "$(SCRIPT_DIR)/ipkg-make-index.sh" . >Packages.manifest; } 2>&1; \
	if [ -n "$(strip $(THIRD_PARTY_PKG_LIST))" ]; then \
		mkdir -p "$(PM_THIRD_PARTY_DIR)" "$(TMP_DIR)/pm"; \
		resolve_deps() { \
			awk -v seeds="$$1" ' \
				BEGIN { RS=""; FS="\\n"; split(seeds, s, /[[:space:]]+/); for (i in s) if (s[i] != "") want[s[i]] = 1; } \
				{ \
					pkg=""; deps=""; file=""; \
					for (i = 1; i <= NF; i++) { \
						if ($$i ~ /^Package:[[:space:]]*/) { pkg = $$i; sub(/^Package:[[:space:]]*/, "", pkg); } \
						else if ($$i ~ /^Depends:[[:space:]]*/) { deps = $$i; sub(/^Depends:[[:space:]]*/, "", deps); } \
						else if ($$i ~ /^Filename:[[:space:]]*/) { file = $$i; sub(/^Filename:[[:space:]]*/, "", file); } \
					} \
					if (pkg != "") { depmap[pkg] = deps; filemap[pkg] = file; } \
				} \
				END { \
					for (p in want) if (p in filemap) queue[++qt] = p; \
					while (qh < qt) { \
						p = queue[++qh]; \
						if (seen[p]++) continue; \
						if (filemap[p] != "") print filemap[p]; \
						n = split(depmap[p], d, ","); \
						for (i = 1; i <= n; i++) { \
							dep = d[i]; \
							gsub(/^[[:space:]]+|[[:space:]]+$$/, "", dep); \
							split(dep, parts, /[[:space:]]+/); \
							dep = parts[1]; \
							if (dep != "" && (dep in filemap) && !seen[dep]) queue[++qt] = dep; \
						} \
					} \
				} \
			' "$(PM_DIR)/Packages.manifest" | sort -u; \
		}; \
		resolve_deps "$(strip $(THIRD_PARTY_PKG_LIST))" >"$(TMP_DIR)/pm/.third-party-ipk-files"; \
		[ -s "$(TMP_DIR)/pm/.third-party-ipk-files" ] || { \
			echo "No third-party packages resolved for: $(THIRD_PARTY_PKG_LIST)" >&2; \
			exit 1; \
		}; \
		non_tp_deps="$$(resolve_deps "$(strip $(PKG_LIST))")"; \
		while read -r ipk; do \
			[ -n "$$ipk" ] || continue; \
			cp -f "$(PM_DIR)/$$ipk" "$(PM_THIRD_PARTY_DIR)/" || { \
				echo "Missing third-party package in $(PM_DIR): $$ipk" >&2; \
				exit 1; \
			}; \
			echo "$$non_tp_deps" | grep -qxF "$$ipk" || rm -f "$(PM_DIR)/$$ipk"; \
		done <"$(TMP_DIR)/pm/.third-party-ipk-files"; \
		cd "$(PM_THIRD_PARTY_DIR)" && \
		{ "$(SCRIPT_DIR)/ipkg-make-index.sh" . >Packages.manifest; } 2>&1 && \
		grep -vE '^(Maintainer|LicenseFiles|Source|SourceName|Require)' Packages.manifest >Packages && \
		gzip -9nc Packages >Packages.gz; \
	fi; \
	cd "$(PM_DIR)" && \
	{ "$(SCRIPT_DIR)/ipkg-make-index.sh" . >Packages.manifest; } 2>&1 && \
	grep -vE '^(Maintainer|LicenseFiles|Source|SourceName|Require)' Packages.manifest >Packages && \
	gzip -9nc Packages >Packages.gz
endef

define PM/Build/Sign_index
	"$(STAGING_DIR_HOST)/bin/usign" -S -m "$(PM_DIR)/Packages" -s "$(BUILD_KEY)" -x "$(PM_DIR)/Packages.sig"
	if [ -n "$(strip $(THIRD_PARTY_PKG_LIST))" ]; then \
		"$(STAGING_DIR_HOST)/bin/usign" -S -m "$(PM_THIRD_PARTY_DIR)/Packages" -s "$(BUILD_KEY)" -x "$(PM_THIRD_PARTY_DIR)/Packages.sig"; \
	fi
endef

endif # $(PKG_LIST)
