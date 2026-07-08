CONF_PARTS    = sms_utils.conf

if BUILD_DUALSIM
CONF_PARTS += dualsim.conf
endif

if BUILD_ESIM
CONF_PARTS += esim.conf
endif

if BUILD_GPS
CONF_PARTS += gps.conf
endif

if BUILD_WIFI
CONF_PARTS += wifi.conf
endif

sms_utils.config: $(CONF_PARTS)
	@for f in $(CONF_PARTS); do \
	  echo "" >> $@; \
	  cat "$$f" >> $@; \
	done

# Hook into build
all-local: sms_utils.config

# Install it
# confdir = $(sysconfdir)/config
# conf_DATA = sms_utils.config

EXTRA_DIST = dualsim.conf esim.conf gps.conf sms_utils.conf wifi.conf
CLEANFILES = sms_utils.config
