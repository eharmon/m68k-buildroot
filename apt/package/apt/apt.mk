APT_VERSION = 2.7.14
APT_SOURCE = apt-$(APT_VERSION).tar.gz
APT_SITE = https://salsa.debian.org/apt-team/apt/-/archive/$(APT_VERSION)
APT_INSTALL_STAGING = YES
APT_INSTALL_TARGET = YES
APT_CONF_OPTS = -DWITH_DOC=OFF -DWITH_TESTS=OFF -DUSE_NLS=OFF
APT_DEPENDENCIES = host-triehash berkeleydb bzip2 dpkg gnupg gnutls libgcrypt lz4 xxhash xz zlib

$(eval $(cmake-package))
