dtbo-$(CONFIG_EXYNOS7904_A40_EUR_OPEN) += \
	exynos/dtbo/exynos7904-a40_eur_open_00.dtbo \
	exynos/dtbo/exynos7904-a40_eur_open_01.dtbo
dtb-$(CONFIG_EXYNOS7904_M20LTE_SWA_OPEN) += exynos/exynos7904-m20lte_swa_open_04.dtb
dtb-$(CONFIG_EXYNOS7904_M30LTE_SWA_OPEN) += \
	exynos/exynos7904-m30lte_swa_open_00.dtb \
	exynos/exynos7904-m30lte_swa_open_01.dtb \
	exynos/exynos7904-m30lte_swa_open_03.dtb \
	exynos/exynos7904-m30lte_swa_open_04.dtb

dts-dirs += altera
dts-dirs += amd
dts-dirs += apm
dts-dirs += arm
dts-dirs += broadcom
dts-dirs += cavium
dts-dirs += exynos
dts-dirs += freescale
dts-dirs += hisilicon
dts-dirs += marvell
dts-dirs += mediatek
dts-dirs += qcom
dts-dirs += rockchip
dts-dirs += sprd
dts-dirs += xilinx

subdir-y	:= $(dts-dirs)

dtstree		:= $(srctree)/$(src)

dtb-$(CONFIG_OF_ALL_DTBS) := $(patsubst $(dtstree)/%.dts,%.dtb, $(foreach d,$(dts-dirs), $(wildcard $(dtstree)/$(d)/*.dts)))

always		:= $(dtb-y) $(dtbo-y)

targets += dtbs

DTB_NAMES := $(subst $\",,$(CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE_NAMES))
ifneq ($(DTB_NAMES),)
DTB_LIST := $(addsuffix .dtb,$(DTB_NAMES))
else
DTB_LIST := $(dtb-y) $(dtbo-y)
endif
targets += $(DTB_LIST)

dtbs: $(addprefix $(obj)/, $(DTB_LIST))

clean-files := dts/*.dtb *.dtb*
