# makefile - Reglas para el proyecto reportesSIC
# Compila los miembros desde qrpglesrc, qclsrc y qddssrc hacia la libreria
# indicada con BUILDLIB (o BIN_LIB). Pensado para usarse con Code for IBM i.

BUILDLIB ?= CARTACPGM
BIN_LIB ?= $(BUILDLIB)
COMMON_LIBL ?= IBMIUNIT V5CFBDAT4 IQS36F QGPL @GENDAT V7LBTRDAT V7LBTRPGM @UTLLIB QS36F CARTACDAT CARTACPGM @NOMDAT @NOMLIB BYTEJU V5CLIPGM V5CLIDAT SEGMENDAT SEGMENPGM V5COVENDAT @RESDAT MONITOR V5DPDAT01 V5DPPGM01 VIS
LIBLIST ?= $(BIN_LIB) $(COMMON_LIBL)
DBGVIEW ?= *SOURCE
SHELL = /QOpenSys/usr/bin/qsh
ERR ?= *NONE

# Target por defecto: compila todo
all: proci00 proci01 proci02 proci03 proci04 proci05 proci06 proci07 \
     proci08 proci09 proci10 proci11 proci12 proci13 proci14 proci15 \
     proci0cl tabciclat tabdatac

# SQLRPGLE -> QRPGLESRC
%: qrpglesrc/%.sqlrpgle
	@echo "Enviando y Compilando SQLRPGLE: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QRPGLESRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@system "CHGPFM FILE($(BIN_LIB)/QRPGLESRC) MBR($*) SRCTYPE(SQLRPGLE)"
	@liblist -a $(LIBLIST) > /dev/null 2>&1 || true; \
	system "CRTSQLRPGI OBJ($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QRPGLESRC) COMMIT(*NONE) DBGVIEW($(DBGVIEW)) OPTION($(ERR)) REPLACE(*YES)"
	@echo "$* Finalizado."

# CL -> QCLSRC
%: qclsrc/%.cl
	@echo "Enviando y Compilando CL: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCLSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@system "CHGPFM FILE($(BIN_LIB)/QCLSRC) MBR($*) SRCTYPE(CLP)"
	@liblist -a $(LIBLIST) > /dev/null 2>&1 || true; \
	system "CRTBNDCL PGM($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QCLSRC) DBGVIEW($(DBGVIEW)) OPTION($(ERR)) REPLACE(*YES)"
	@echo "$* Finalizado."

# PF (DDS) -> QDDSSRC
%: qddssrc/%.pf
	@echo "Enviando y Creando PF: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QDDSSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@system "CHGPFM FILE($(BIN_LIB)/QDDSSRC) MBR($*) SRCTYPE(PF)"
	@liblist -a $(LIBLIST) > /dev/null 2>&1 || true; \
	system "CRTPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QDDSSRC) SRCMBR($*) REPLACE(*YES)"
	@echo "$* Finalizado."

# Limpieza segura
clear:
	rm -f *.evfevent
	rm -f *.log

# Sin pruebas definidas
test:
	@echo "No hay pruebas definidas para este proyecto."

.PHONY: all clear test
