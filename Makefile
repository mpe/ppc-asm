help:
	@echo "Build & run ppc asm easily."
	@echo
	@echo "Targets are:"
	@echo "  run:   run the program"
	@echo "  debug: debug the program in gdb"
	@echo "  dump:  dump the program with objdump"
	@echo "  clean: clean up"

ARCH = $(shell uname -m)

ifneq ("$(ARCH)", "ppc64le")
	CROSS_COMPILE ?= powerpc64le-linux-gnu-
	QEMU ?= qemu-ppc64le
endif

CC := $(CROSS_COMPILE)gcc
AS := $(CROSS_COMPILE)as
OBJDUMP := $(CROSS_COMPILE)objdump

ASFLAGS += -g -Wall -nostdlib -static

run: harness
	$(QEMU) ./harness

GDB_ARGS := -iex "set auto-load safe-path $(PWD)"

debug: harness
ifeq ("$(ARCH)", "ppc64le")
	gdb $(GDB_ARGS) --ex "b user_code" --ex run harness
else
	$(QEMU) -g 6464 ./harness &
	gdb $(GDB_ARGS) --ex "target remote :6464" --ex "b user_code" --ex "cont" harness
endif

harness.S: helpers.S
	@touch harness.S

harness: harness.S user.S

dump: harness
	$(OBJDUMP) -d harness

clean:
	rm -f harness dump.txt

.PHONY: clean dump run help debug
