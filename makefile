# makefile.common - Reglas comunes para el proyecto Reportes RC
# Incluir este archivo desde los makefiles locales

# Asegurar que 'all' sea el target por defecto
all:

# Configuración básica
BIN_LIB ?= CORTIZ
COMMON_LIBL ?= IBMIUNIT V5CFBDAT4 IQS36F QGPL @GENDAT V7LBTRDAT V7LBTRPGM @UTLLIB QS36F CARTACDAT CARTACPGM @NOMDAT @NOMLIB BYTEJU V5CLIPGM V5CLIDAT SEGMENDAT SEGMENPGM V5COVENDAT @RESDAT MONITOR V5DPDAT01 V5DPPGM01 VIS
LIBLIST ?= $(BIN_LIB) $(COMMON_LIBL)
DBGVIEW ?= *SOURCE
CCSID ?= 37
SHELL = /QOpenSys/usr/bin/qsh
ERR ?= *NONE

# Rules

# SQLRPGLE
%.pgm.sqlrpgle: qrpglesrc/%.pgm.sqlrpgle
	@echo "Enviando y Compilando SQLRPGLE: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QRPGLESRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@system "CHGPFM FILE($(BIN_LIB)/QRPGLESRC) MBR($*) SRCTYPE(SQLRPGLE)"
	@liblist -a $(LIBLIST) > /dev/null 2>&1 || true; \
	system "CRTSQLRPGI OBJ($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QRPGLESRC) COMMIT(*NONE) DBGVIEW($(DBGVIEW)) OPTION($(ERR)) REPLACE(*YES)"
	@echo "$* Finalizado."

# DSPF
%.dspf: qddxsrc/%.dspf
	@echo "Enviando y Compilando DSPF: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QDDXSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@system "CHGPFM FILE($(BIN_LIB)/QDDXSRC) MBR($*) SRCTYPE(DSPF)"
	@liblist -a $(LIBLIST) > /dev/null 2>&1 || true; \
	system "CRTDSPF FILE($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QDDXSRC) SRCMBR($*) REPLACE(*YES)"
	@echo "$* Finalizado."

# Tables (SQL)
%.table: qddssrc/%.table
	@echo "Enviando y Creando Tabla: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QDDSSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@sed 's/CARTACDAT/$(BIN_LIB)/g' '$<' > /tmp/$*.sql
	@liblist -c $(BIN_LIB) > /dev/null 2>&1 || true; \
	system "RUNSQLSTM SRCSTMF('/tmp/$*.sql') COMMIT(*NONE)" && \
	rm -f /tmp/$*.sql && \
	echo "Tabla $* Finalizada."

# CLLE
%.clle: qclsrc/%.clle
	@echo "Enviando y Compilando CLLE: $*..."
	@system "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCLSRC.file/$*.mbr') MBROPT(*REPLACE) STMFCCSID(*STMF) ENDLINFMT(*ALL) TABEXPN(*YES)"
	@system "CHGPFM FILE($(BIN_LIB)/QCLSRC) MBR($*) SRCTYPE(CLLE)"
	@liblist -a $(LIBLIST) > /dev/null 2>&1 || true; \
	system "CRTBNDCL PGM($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QCLSRC) DBGVIEW($(DBGVIEW)) OPTION($(ERR)) REPLACE(*YES)"
	@echo "$* Finalizado."

# Limpieza segura
clear-common:
	rm -f *.evfevent
	rm -f *.log
	rm -f *.mbr

.PHONY: all clear-common
