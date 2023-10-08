define Package/base-files/install-target
	if [ -d "$(PLATFORM_SUBDIR)/teltonika/boot/$(call device_shortname)" ]; then \
		$(CP) -r $(PLATFORM_SUBDIR)/teltonika/boot/$(call device_shortname)/* $(1)/; \
	fi;
endef
