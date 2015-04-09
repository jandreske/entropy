# Build FAT filesystem header for firmware verification.
#
# The author has waived all copyright and related or neighbouring rights
# to this file and placed it in public domain.

SHELL = bash
SIZE = $(word 2,$(shell fgrep '\#size' $(MTOOLSRC)))
NBLK = $(wordlist 2,99,$(shell sed -n 's/^.*[dr]s=/* /p' $(MTOOLSRC)))

export MTOOLSRC = $(basename $@).conf

%.c:	%.img disk.mk
	@echo "/*" > $@
	@echo "    FAT filesystem header." >> $@
	@echo "    This file is automatically generated." >> $@
	@echo >> $@
	mdir a: >> $@
	@echo "*/" >> $@
	@echo "__attribute__ ((aligned (4)))" >> $@
	xxd -i -l $(SIZE) $< >> $@
	@echo "unsigned int $(subst -,_,$*)_nblk = $(NBLK);" >> $@

%.img: %.conf disk.mk
	mformat -C -c4 -d1 -r1 -v "FIRMWARE" a:
	dd if=/dev/zero count=16 bs=1k of=tmp
	mcopy tmp a:boot.bin
	dd if=/dev/zero count=240 bs=1k of=tmp
	mcopy tmp a:firmware.bin
	dd if=/dev/zero count=10 bs=1k of=tmp
	mcopy tmp a:bip39.bin
	dd if=/dev/zero bs=1 conv=notrunc seek=446 count=16 of=$@
	rm tmp
