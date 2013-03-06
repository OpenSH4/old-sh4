ifeq ($(KERNELRELEASE),)
DRIVER_TOPDIR:=$(shell pwd)/..
include $(DRIVER_TOPDIR)/kernel.make
else
    aotom_vip1-objs += aotom_trace.o
    aotom_vip1-objs += aotom_i2csoft.o
    aotom_vip1-objs += aotom_vfd.o
    aotom_vip1-objs += aotom_main.o

    obj-m += aotom_vip1.o
    
ifneq (,$(findstring 2.6.3,$(KERNELVERSION)))
ccflags-y += $(CCFLAGSY)
else
CFLAGS += $(CCFLAGSY)
endif
endif

