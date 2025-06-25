DPKG_VERSION = 1.22.20
DPKG_SOURCE = dpkg_$(DPKG_VERSION).tar.xz
DPKG_SITE = http://deb.debian.org/debian/pool/main/d/dpkg
DPKG_INSTALL_TARGET = YES
DPKG_CONF_OPTS += --enable-static --disable-shared
DPKG_DEPENDENCIES = coreutils ncurses tar

$(eval $(autotools-package))
