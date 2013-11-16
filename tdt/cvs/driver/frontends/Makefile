TREE_ROOT?=$(DRIVER_TOPDIR)/
CONFIG_STGFB_PATH?=$(DRIVER_TOPDIR)/stgfb/stmfb
CCFLAGSY += -I$(TREE_ROOT)/linux/include/linux/stm/
CCFLAGSY += -I$(TREE_ROOT)/linux/drivers/media/video/stm/
CCFLAGSY += -I$(KERNEL_LOCATION)/drivers/media/dvb/dvb-core
CCFLAGSY += -I$(CONFIG_STGFB_PATH)/include
CCFLAGSY += -DDEBUG_DVB
CCFLAGSY += -I$(TREE_ROOT)/include


ifneq (,$(findstring 2.6.3,$(KERNELVERSION)))
ccflags-y += $(CCFLAGSY)
else
CFLAGS += $(CCFLAGSY)
endif

ifeq (,$(findstring 2.6.3,$(KERNELVERSION)))
# < 2.6.30
ifdef HL101
fe-core-objs +=        hl101/stb0899_algo.o
fe-core-objs +=        hl101/stb0899_drv.o
fe-core-objs +=        hl101/stb6100.o
fe-core-objs +=        hl101/stv090x.o
fe-core-objs +=        hl101/stv6110x.o
fe-core-objs +=        hl101/ix7306.o
fe-core-objs +=        hl101/core.o
obj-m += fe-core.o
endif

else

# >= 2.6.30
ifdef HL101
###### Vip1v1 und Opticum
fe-core-objs +=        hl101/stb0899_algo.o
fe-core-objs +=        hl101/stb0899_drv.o
fe-core-objs +=        hl101/stb6100.o
fe-core-objs +=        hl101/stv090x.o
fe-core-objs +=        hl101/stv6110x.o
fe-core-objs +=        hl101/ix7306.o
fe-core-objs +=        hl101/core.o
obj-m += fe-core.o
###### VIP2 - MAKE
fe-core-vip2-objs += vip2/stv090x.o
fe-core-vip2-objs += vip2/ix7306.o
fe-core-vip2-objs += vip2/zl10353.o
fe-core-vip2-objs += base/sharp6465.o
fe-core-vip2-objs += base/tda10023.o
fe-core-vip2-objs += base/lg031.o
fe-core-vip2-objs += vip2/core.o
obj-m += fe-core-vip2.o
##### VIP1v2 MAKE
fe-core-vip1v2-objs += vip1_v2/stb0899_algo.o
fe-core-vip1v2-objs += vip1_v2/stb0899_drv.o
fe-core-vip1v2-objs += vip1_v2/stb6100.o
fe-core-vip1v2-objs += vip1_v2/stv090x.o
fe-core-vip1v2-objs += vip1_v2/stv6110x.o
fe-core-vip1v2-objs += vip1_v2/ix7306.o
fe-core-vip1v2-objs += vip1_v2/zl10353.o
fe-core-vip1v2-objs += vip1_v2/cx24116.o
fe-core-vip1v2-objs += base/sharp6465.o
fe-core-vip1v2-objs += base/tda10023.o
fe-core-vip1v2-objs += base/lg031.o
fe-core-vip1v2-objs += vip1_v2/core.o
obj-m += fe-core-vip1v2.o 
endif
