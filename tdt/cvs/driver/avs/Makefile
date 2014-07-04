ifeq ($(KERNELRELEASE),)
DRIVER_TOPDIR:=$(shell pwd)/..
include $(DRIVER_TOPDIR)/kernel.make
else
obj-m       += avs.o
avs-objs	+= tools.o avs_core.o stv6418.o vip2_avs.o vip1_avs.o


CCFLAGSY	+= -DDEBUG
ifneq (,$(findstring 2.6.3,$(KERNELVERSION)))
ccflags-y += $(CCFLAGSY)
else
CFLAGS += $(CCFLAGSY)
endif
endif

