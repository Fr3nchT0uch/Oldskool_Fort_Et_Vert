#
DISKNAME = test.dsk

PYTHON = python.exe
JAVA = java.exe -jar
ACME = acme.exe -f plain -o
AC = $(JAVA) $(A2SDK)\bin\ac.jar 
LZ4 = lz4.exe
ZPACK = zpacker.exe
DIRECTWRITE = $(PYTHON27) $(A2SDK)\bin\dw.py
INSERTBIN = $(PYTHON27) $(A2SDK)\bin\InsertBIN.py
TRANSAIR = $(PYTHON27) $(A2SDK)\bin\transair.py
GENDSK = $(PYTHON27) $(A2SDK)\bin\genDSK.py
COPYFILES = $(PYTHON27) $(A2SDK)\bin\InsertZIC.py
APPLEWIN = $(APPLEWINPATH)\Applewin.exe -d1

EMULATOR = $(APPLEWIN)

all: $(DISKNAME)

$(DISKNAME): main.b.lz4 decomp.b data
#	REMOVE OLD FILE (mandatory)
	$(AC) -d $(DISKNAME) "OLDSKOOL"
# 	COPY TO DSK
	$(AC) -p $(DISKNAME) "OLDSKOOL" B 0x1000 <decomp.b

# 	EMULATOR
	copy lbl_main.txt $(APPLEWINPATH)\A2_USER1.SYM
	$(EMULATOR) $(DISKNAME)

main.b.lz4 lbl_main.txt: main.a
	$(ACME) main.b main.a
	$(LZ4) -2 main.b

decomp.b: decomp.a lbl_main.txt main.b.lz4
	$(ACME) decomp.b decomp.a

data: MUSIC.bin HIRES.bin specialtxt.bin

clean:
	del *.b
	del lbl_*.txt
    