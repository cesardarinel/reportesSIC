# Lista de dependencias faltantes — reportesSIC

Validación del 10/08/2026. El repositorio contiene **17 fuentes**:

| Librería | Miembros presentes |
|---|---|
| QCLSRC | PROCI0CL |
| QRPGLESRC | PROCI00 a PROCI15 (16 programas) |

A continuación se listan los **objetos que faltan cargar / compilar** para que el
flujo funcione de punta a punta.

---

## 1. Miembros /copy que faltan en el repositorio

| Copia | Referenciado en | Estado |
|---|---|---|
| `PROCI_H` | `QRPGLESRC` — `proci00.sqlrpgle:18` `//copy QRPGLESRC,PROCI_H` | **FALTA** (contiene los prototipos de PROCI01, 04, 05, 07, 08, 10, 14 y 15 que usa PROCI00) |
| `PROCIS01` | `cartacsrc/qrpglesrc` — `proci12.sqlrpgle:334` `c/copy cartacsrc/qrpglesrc,procis01` | **FALTA** |
| `PROCIS02` | `cartacsrc/qrpglesrc` — `proci12.sqlrpgle:335` `c/copy cartacsrc/qrpglesrc,procis02` | **FALTA** |
| `PROCIS03` | `proci01:513`, `proci02:429`, `proci06:408`, `proci12:336` (todas comentadas `c*`) | Opcional (está comentado, no bloquea compilación) |

---

## 2. Display file (DSPF) que falta

| Miembro DSPF | Referenciado en | Estado |
|---|---|---|
| `PROCI00FM` | `proci00.sqlrpgle:16` `Dcl-F proci00fm WORKSTN` | **FALTA** — display file con los formatos de registro `PANTA01`, `PANTA02` y `ERROR` que usa PROCI00 |

---

## 3. Programas CALLed que faltan (no están en el repo)

| Programa | Llamado desde | Estado |
|---|---|---|
| `PROCI40` | `proci01.sqlrpgle:287` | **FALTA** |
| `PROCI41` | `proci01.sqlrpgle:353` | **FALTA** |
| `CA4MONCU` | `proci01:598`, `proci02:529` | **FALTA** |
| `CAMONPAG` | `proci01:609`, `proci02:540`, `proci05:337`, `proci06:469`, `proci12:397` | **FALTA** |
| `INFOR81` | `proci01:639`, `proci02:567`, `proci05:362`, `proci06:497`, `proci12:426` | **FALTA** |
| `CAPR0101` | `proci01:775`, `proci02:652`, `proci05:458`, `proci06:603`, `proci12:555` | **FALTA** |
| `CAPR0102` | `proci01:757`, `proci02:635`, `proci05:441`, `proci06:586`, `proci12:538` | **FALTA** |

> PROCI00, PROCI01–15 y PROCI0CL ya están en el repo. Los CALL internos
> (PROCI02, PROCI03, PROCI06, PROCI09, PROCI12, PROCI13) están cubiertos.

---

## 4. Archivos físicos / tablas que deben existir en CARTACDAT

### 4.1 Archivos declarados con F-spec / Dcl-F

| Archivo | Usado en | Uso |
|---|---|---|
| `CASALDIA` | proci01, proci02, proci06, proci12 | entrada |
| `CACREDHIST` | proci01, proci02, proci06, proci12 | entrada |
| `CACREDIT` | proci01, proci02, proci05, proci06, proci08, proci10, proci11, proci12 | entrada |
| `CAHISP34` | proci01, proci02, proci06, proci12 | entrada |
| `CLMCTE01` | proci01, proci02, proci05, proci06, proci08, proci12 | entrada |
| `CAFYMPAG` | proci01, proci02, proci06, proci12 | entrada |
| `CLPEIN` | proci01, proci02, proci05, proci06, proci08, proci12 | entrada |
| `CLPEJU` | proci01, proci02, proci05, proci06, proci12 | entrada |
| `CAPRODUC` | proci01, proci02, proci05, proci06, proci12 | entrada |
| `CACANTIP` | proci01, proci02, proci06, proci12 | entrada |
| `CCSFEMTA1` | proci01, proci02, proci05, proci06, proci12 | entrada |
| `CACODEUD` | proci01, proci02, proci06, proci12 | entrada |
| `CAFYMP02` | proci02, proci06, proci12 | entrada |
| `CACRED05` | proci06 | entrada |
| `CACRED17` | proci05 | entrada |
| `CACODE04` | proci05 | entrada |
| `CAADJUDI` | proci05 | entrada |
| `CLDICL` | proci05, proci06 | entrada |
| `CACLACAR01` | proci02, proci06 | entrada |
| `CLDICL12` | proci08 | entrada |
| `CLMCTE` | proci08 | entrada |
| `CLPROF` | proci08 | entrada |
| `CLOCUP` | proci08 | entrada |
| `CATIPPRO` | proci10 | entrada |
| `CAHISPTM` | proci10 | entrada |
| `CASTACRE` | proci13 | entrada |
| `CATABCI` | proci11 | entrada |
| `TABCICLA01` | proci06, proci07, proci08, proci12 | entrada |
| `TABCICLA2` | proci09 | entrada |
| `TABCICLA02` | proci03 | entrada |
| `TABCICLA03` | proci04 | entrada |
| `TABCICLA04` | proci02, proci11 | entrada/salida |
| `TABCICLA` | proci01, proci02, proci04, proci05, proci06, proci12 | entrada/salida |
| `TABDATAC` | proci08, proci10 | entrada/salida (formato REGDATA) |

### 4.2 Tablas SQL

| Tabla | Usada en | Uso |
|---|---|---|
| `TABCICLA3` | proci00 | INSERT (log de usuarios) |
| `TABCICLAT` (cartacdat) | proci15 | INSERT — **tabla nueva con estructura TransUnion** |
| `TABCICLA` (cartacdat) | proci14, proci15 | SELECT/UPDATE |
| `TABDATAC` (cartacdat) | proci14 | UPDATE |
| `CAADJUDI` (cartacdat) | proci14 | SELECT |
| `CACREDHIST` (cartacdat) | proci14 | SELECT |
| `CACREDIT` (cartacdat) | proci14, proci15 | SELECT |
| `CACOMPAG` (cartacdat) | proci15 | SELECT |
| `CAFREA01` (cartacdat) | proci15 | SELECT |
| `CAHISPTM` (cartacdat) | proci15 | SELECT |
| `CAPAGOS` (cartacdat) | proci15 | SELECT |

### 4.3 Tablas en V5CLIDAT (usadas por PROCI15)

`CLTEL03`, `CLCOR`, `CLDI03`, `CLSECTOR`, `CLGEO1`, `CLGEO2`

---

## 5. Archivos que limpia el CL (deben existir)

`PROCI0CL` hace `CLRPFM` a: `TABCICLA`, `TABCICLA02`, `TABDATAC`, `TABCICLAT`

---

## 6. Librerías / objetos externos que se referencian

| Referencia | Origen | Estado |
|---|---|---|
| `@TA_LIB` | `proci0cl.cl:44` `ADDLIBLE @TA_LIB` | Librería debe existir en el sistema |
| `C:\MIGRACI\TRANS_DATC.DTF` | `proci0cl.cl:55` STRPCCMD | Archivo PC para generar salida TransUnion |
| `C:\MIGRACI\TRANS_CICLA.DTF` | `proci0cl.cl:59` STRPCCMD | Archivo PC para generar salida CICLA |
| Librerías `CARTACSRC`, `CARTACPGM`, `CARTACDAT`, `V5CLIDAT` | todos los fuentes | Deben existir en la máquina |

---

## 7. Orden sugerido de carga / compilación

1. Crear/restaurar **copys**: `PROCI_H`, `PROCIS01`, `PROCIS02` (y opcional `PROCIS03`).
2. Crear **DSPF** `PROCI00FM` (formatos `PANTA01`, `PANTA02`, `ERROR`).
3. Verificar/crear **tablas físicas** de la sección 4 (incluidas `TABCICLAT` y `TABCICLA3`).
4. Compilar CL `PROCI0CL`.
5. Compilar RPGLE en orden: **PROCI13, PROCI03, PROCI09, PROCI02, PROCI06, PROCI12, PROCI04, PROCI07, PROCI08, PROCI10, PROCI11, PROCI05, PROCI14, PROCI15, PROCI01, PROCI00**.
6. Cargar/restaurar los **7 programas faltantes** de la sección 3 (`PROCI40`, `PROCI41`, `CA4MONCU`, `CAMONPAG`, `INFOR81`, `CAPR0101`, `CAPR0102`).
