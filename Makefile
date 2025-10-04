include $(TOPDIR)/rules.mk

PKG_NAME:=nvtop
PKG_VERSION:=3.2.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING
PKG_MAINTAINER:=icynano <iceynano@gmail.com>
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/nvtop
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=GPU process monitoring tool
  URL:=https://github.com/Syllo/nvtop
  DEPENDS:=+libncursesw +libudev-zero +libdrm
endef

define Package/nvtop/description
  Nvtop stands for Neat Videocard TOP, a (h)top like task monitor for GPUs.
  It can handle multiple GPUs and print information about them in a htop-familiar way.
  Supports NVIDIA, AMD, and Intel GPUs.
endef

CMAKE_OPTIONS += \
	-DCMAKE_BUILD_TYPE=Release \
	-DNVIDIA_SUPPORT=OFF \
	-DAMDGPU_SUPPORT=OFF \
	-DINTEL_SUPPORT=OFF \
	-DMSM_SUPPORT=ON \
	-DPANFROST_SUPPORT=ON \
	-DPANTHOR_SUPPORT=ON \
	-DV3D_SUPPORT=ON \
	-DTPU_SUPPORT=OFF \
	-DROCKCHIP_SUPPORT=ON \
	-DAPPLE_SUPPORT=OFF \
	-DASCEND_SUPPORT=OFF \
	-DBUILD_TESTING=OFF

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	# Copy all files except openwrt-sdk directory to avoid recursive copy
	cd $(CURDIR) && find . -maxdepth 1 ! -name '.' ! -name 'openwrt-sdk' -exec cp -fpR {} $(PKG_BUILD_DIR)/ \;
endef

define Package/nvtop/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/nvtop $(1)/usr/bin/
endef

$(eval $(call BuildPackage,nvtop))
