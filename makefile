#
DISKNAME = A.dsk
DISKNAME800K = A.po

A2SDK=C:/retrodev

PYTHON = python3.exe
PYTHON27 = python.exe
JAVA = java.exe -jar
ACME = acme.exe -f plain -o
AC = $(JAVA) $(A2SDK)/bin/ac.jar 
LZ4 = lz4.exe
ZPACK = zpacker.exe
DIRECTWRITE = $(PYTHON) $(A2SDK)/bin/dw.py
DIRECTWRITE800K = $(PYTHON) $(A2SDK)/bin/dw800k.py
INSERTBIN = $(PYTHON27) $(A2SDK)/bin/InsertBIN.py
TRANSAIR = $(PYTHON) $(A2SDK)/bin/transair3.py
GENDSK = $(PYTHON27) $(A2SDK)/bin/genDSK.py
GENPO = $(PYTHON) $(A2SDK)/bin/genPO800k.py
COPYFILES = $(PYTHON27) $(A2SDK)/bin/InsertZIC.py
APPLEWIN = $(APPLEWINPATH)/Applewin.exe -d1

EMULATOR = $(APPLEWIN)

all: $(DISKNAME) unidisk

$(DISKNAME): main.b.lz4 decomp.b data boot.b fload.b
# boot T0 S0
	$(DIRECTWRITE) $(DISKNAME) boot.b 0 0 + p
# fload T0 S2
	$(DIRECTWRITE) $(DISKNAME) fload.b 0 2 + p
# main_.b (?) T1 S0 > $6000
	$(DIRECTWRITE) $(DISKNAME) decomp.b 1 0 + D

# 	EMULATOR
	copy lbl_main.txt $(APPLEWINPATH)\A2_USER1.SYM
	$(EMULATOR) $(DISKNAME)
#	$(TRANSAIR) $(DISKNAME)

unidisk: $(DISKNAME800K)

$(DISKNAME800K): decomp.b data boot_unidisk.b
	$(GENPO) $(DISKNAME800K)
# block 0
	$(DIRECTWRITE800K) $(DISKNAME800K) boot_unidisk.b 0
# block 1
	$(DIRECTWRITE800K) $(DISKNAME800K) decomp.b 1

main.b.lz4 lbl_main.txt: main.a
	$(ACME) main.b main.ama
	$(LZ4) -2 main.b

decomp.b: decomp.a lbl_main.txt main.b.lz4
	$(ACME) decomp.b decomp.a

fload.b: fload.a
	$(ACME) fload.b fload.a

boot.b: boot.a
	$(ACME) boot.b boot.a

boot_unidisk.b: boot_unidisk.a
	$(ACME) boot_unidisk.b boot_unidisk.a

data: MUSIC.bin HIRES.bin specialtxt.bin

clean:
	rm *.b
	rm lbl_*.txt
    