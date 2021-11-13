#
DISKNAME = a.dsk

PYTHON = python.exe
JAVA = java.exe -jar
ACME = acme.exe -f plain -o
AC = $(JAVA) $(A2SDK)\bin\ac.jar 
LZ4 = lz4.exe
ZPACK = zpacker.exe
DIRECTWRITE = $(PYTHON) $(A2SDK)\bin\dw.py
INSERTBIN = $(PYTHON27) $(A2SDK)\bin\InsertBIN.py
TRANSAIR = $(PYTHON) $(A2SDK)\bin\transair3.py
GENDSK = $(PYTHON27) $(A2SDK)\bin\genDSK.py
COPYFILES = $(PYTHON27) $(A2SDK)\bin\InsertZIC.py
APPLEWIN = $(APPLEWINPATH)\Applewin.exe -d1

EMULATOR = $(APPLEWIN)

all: $(DISKNAME)

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

main.b.lz4 lbl_main.txt: main.a
	$(ACME) main.b main.a
	$(LZ4) -2 main.b

decomp.b: decomp.a lbl_main.txt main.b.lz4
	$(ACME) decomp.b decomp.a

fload.b: fload.a
	$(ACME) fload.b fload.a

boot.b: boot.a
	$(ACME) boot.b boot.a

data: MUSIC.bin HIRES.bin specialtxt.bin

clean:
	del *.b
	del lbl_*.txt
    