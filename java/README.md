# Generador de reporte de tarjetas de crédito para TransUnion y DataCredito

Aplicación Desktop que se encarga de obtener las informaciones respectivas de tarjeta de crédito para generar el reporte que se envía a las entidades crediticias competentes.

### Requisitos
- Java 8
- Acceso a AS400
- Carpeta <b>DATA</b> ubicada en el disco C:/DATA

### Datos
La información para la generación de los reportes es obtenida de las tablas:
- ``@TA_LIB.CICLA736DB`` -> información para TransUnion.
- ``@TA_LIB.DATAC736DB`` -> información para DataCredito.

### Uso
1. Ejecutar el <b>jar</b> generado.
2. Introducir la fecha deseada.
3. Persionar botón <b>generar reporte</b>.

### Empaquetado
``mvn clean package``

### Antiguo Repositorio
[Repositorio original (Programador original).](http://acapccv01d:7990/users/acap1831/repos/reporte_datacredito_transunion_tarjeta/browse)

