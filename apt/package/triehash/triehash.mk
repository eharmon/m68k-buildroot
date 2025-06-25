TRIEHASH_VERSION = 0.3-3
TRIEHASH_SOURCE = $(TRIEHASH_VERSION).tar.gz
TRIEHASH_SITE = https://github.com/julian-klode/triehash/archive/refs/tags/debian
define HOST_TRIEHASH_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/triehash.pl $(HOST_DIR)/bin/triehash
endef

$(eval $(host-generic-package))
