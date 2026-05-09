-- ============================================================
--  SISTEMA INTEGRADO DE INFORMACIÓN SOCIAL (SIIS) - UTGS

-- ============================================================
-- BLOQUE 1: CONFIGURACIÓN
-- ============================================================
CREATE DATABASE IF NOT EXISTS siis_utgs
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE siis_utgs;

SET NAMES utf8mb4;
SET time_zone = '-04:00'; -- Hora Paraguay (GMT-4)

-- ============================================================
-- BLOQUE 2: TABLA PRINCIPAL
-- ============================================================
DROP TABLE IF EXISTS historial_cambios;
DROP TABLE IF EXISTS reportes_mensuales;
DROP TABLE IF EXISTS programas_siis;

CREATE TABLE programas_siis (
    id                        INT            NOT NULL AUTO_INCREMENT,
    institucion               VARCHAR(200)   NOT NULL COMMENT 'Nombre de la institución responsable',
    programa                  VARCHAR(400)   NOT NULL COMMENT 'Nombre del programa o servicio social',
    estado_programa           ENUM('Vigente','Cerrado') NOT NULL DEFAULT 'Vigente',
    periodo_actualizacion     ENUM('Mensual','Bimensual','Trimestral','Semestral','Anual') NOT NULL DEFAULT 'Anual',
    ultima_fecha_actualizacion DATE           NULL,
    estado_actualizacion      ENUM('Actualizado','Desactualizado') NULL
                              COMMENT 'NULL = programa Cerrado',
    fecha_registro            DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    usuario_registro          VARCHAR(100)   NULL DEFAULT 'sistema',
    observaciones             TEXT           NULL,
    PRIMARY KEY (id),
    INDEX idx_institucion         (institucion),
    INDEX idx_estado_programa     (estado_programa),
    INDEX idx_estado_actualizacion(estado_actualizacion),
    INDEX idx_periodo             (periodo_actualizacion),
    INDEX idx_fecha_act           (ultima_fecha_actualizacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabla principal SIIS — 125 programas sociales del Estado paraguayo';

-- ============================================================
-- BLOQUE 3: AUDITORÍA
-- ============================================================
CREATE TABLE historial_cambios (
    id_historial   INT          NOT NULL AUTO_INCREMENT,
    id_programa    INT          NOT NULL,
    campo_mod      VARCHAR(100) NOT NULL,
    valor_anterior TEXT         NULL,
    valor_nuevo    TEXT         NULL,
    fecha_cambio   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_cambio VARCHAR(100) NULL DEFAULT 'sistema',
    PRIMARY KEY (id_historial),
    INDEX idx_id_programa (id_programa),
    CONSTRAINT fk_hist_prog FOREIGN KEY (id_programa)
        REFERENCES programas_siis(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Auditoría de cambios en registros de programas';

-- ============================================================
-- BLOQUE 4: REPORTES MENSUALES
-- ============================================================
CREATE TABLE reportes_mensuales (
    id_reporte              INT          NOT NULL AUTO_INCREMENT,
    anio                    YEAR         NOT NULL,
    mes                     TINYINT      NOT NULL,
    total_programas         INT          NOT NULL DEFAULT 0,
    total_vigentes          INT          NOT NULL DEFAULT 0,
    total_cerrados          INT          NOT NULL DEFAULT 0,
    total_actualizados      INT          NOT NULL DEFAULT 0,
    total_desactualizados   INT          NOT NULL DEFAULT 0,
    porcentaje_cumplimiento DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    fecha_generacion        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    generado_por            VARCHAR(100) NULL DEFAULT 'sistema',
    PRIMARY KEY (id_reporte),
    UNIQUE KEY uq_anio_mes (anio, mes)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='Resúmenes mensuales de seguimiento SIIS';

-- ============================================================
-- BLOQUE 5: DATOS — 125 PROGRAMAS (VERSIÓN CORREGIDA v2.0)
-- ============================================================
INSERT INTO programas_siis (institucion, programa, estado_programa, periodo_actualizacion, ultima_fecha_actualizacion, estado_actualizacion) VALUES
-- MTESS (11)
('Ministerio de Trabajo, Empleo y Seguridad Social','Centro de entrenamiento del emprendedor','Vigente','Anual','2025-07-08','Actualizado'),
('Ministerio de Trabajo, Empleo y Seguridad Social','Centro de desarrollo del emprendedor-Sinafocal Emprende','Vigente','Anual','2025-03-07','Actualizado'),
('Ministerio de Trabajo, Empleo y Seguridad Social','Jovenes Buscadores del Primer empleo','Cerrado','Anual','2019-01-31',NULL),
('Ministerio de Trabajo, Empleo y Seguridad Social','Micro y pequeños empresarios','Cerrado','Anual','2019-01-31',NULL),
('Ministerio de Trabajo, Empleo y Seguridad Social','Pequeños productores rurales','Cerrado','Anual','2019-01-31',NULL),
('Ministerio de Trabajo, Empleo y Seguridad Social','Curso de Capacitación Laboral','Vigente','Anual','2025-07-08','Actualizado'),
('Ministerio de Trabajo, Empleo y Seguridad Social','Registro de Institutos de Formación y Capacitación Laboral','Vigente','Anual','2024-07-16','Actualizado'),
('Ministerio de Trabajo, Empleo y Seguridad Social','Acciones Formativas','Vigente','Anual','2025-12-11','Actualizado'),
('Ministerio de Trabajo, Empleo y Seguridad Social','Servicio Nacional de Promoción Profesional SNPP','Cerrado','Anual','2018-05-03',NULL),
('Ministerio de Trabajo, Empleo y Seguridad Social','Programa de Capacitación para el Productor Rural','Cerrado','Anual','2023-05-16',NULL),
('Ministerio de Trabajo, Empleo y Seguridad Social','Centro de Innovación de Metodologias Avanzadas y Formación de Instructores','Vigente','Anual','2025-07-08','Actualizado'),
-- MAG (10)
('Ministerio de Agricultura y Ganadería','Extensión Agraria','Vigente','Anual','2024-06-10','Desactualizado'),
('Ministerio de Agricultura y Ganadería','Programa de Agricultura y Economía Indígena','Cerrado','Anual','2015-07-28',NULL),
('Ministerio de Agricultura y Ganadería','Programa de Desarrollo Rural Sostenible','Cerrado','Anual','2018-07-31',NULL),
('Ministerio de Agricultura y Ganadería','Programa de Modernización de la Gestión Pública de Apoyos Agropecuarios','Cerrado','Anual','2016-04-04',NULL),
('Ministerio de Agricultura y Ganadería','Programa de Producción de Alimentos','Cerrado','Anual','2015-11-23',NULL),
('Ministerio de Agricultura y Ganadería','Programa Nacional de Fomento Pecuario','Cerrado','Anual','2016-05-31',NULL),
('Ministerio de Agricultura y Ganadería','Programa Nacional de Fortalecimiento de la Agricultura Familiar','Cerrado','Anual','2015-07-28',NULL),
('Ministerio de Agricultura y Ganadería','Proyecto de Fortalecimiento de la Agricultura Familiar Sostenibles','Cerrado','Anual','2015-07-28',NULL),
('Ministerio de Agricultura y Ganadería','Equipamiento para la Producción Agrícola en el Paraguay','Cerrado','Anual','2024-06-03',NULL),
('Ministerio de Agricultura y Ganadería','Proyecto de Inclusión de la Agricultura Familiar en Cadenas de Valor (Proyecto Paraguay Inclusivo)','Cerrado','Anual','2018-01-11',NULL),
-- DIBEN (2)
('Dirección de Beneficencia y Ayuda Social','Asistencia Económica para gastos médicos','Vigente','Mensual','2025-12-10','Actualizado'),
('Dirección de Beneficencia y Ayuda Social','Provisión de Insumos hospitalarios de Alta Complejidad','Vigente','Mensual','2025-12-10','Actualizado'),
-- CONACYT (6)
('Consejo Nacional de Ciencia y Tecnología','Incentivos para la formación de investigadores en posgrados nacionales PROCIENCIA I','Cerrado','Anual','2018-01-26',NULL),
('Consejo Nacional de Ciencia y Tecnología','Incentivos para la formación de investigadores en posgrados nacionales PROCIENCIA II','Vigente','Anual','2025-08-22','Actualizado'),
('Consejo Nacional de Ciencia y Tecnología','Programa Nacional de Incentivo a los Investigadores 2018','Cerrado','Anual','2018-03-13',NULL),
('Consejo Nacional de Ciencia y Tecnología','Programa Nacional de Incentivo a los Investigadores 2022','Cerrado','Anual','2023-05-26',NULL),
('Consejo Nacional de Ciencia y Tecnología','Programa Nacional de Incentivo a los Investigadores 2023','Cerrado','Anual','2024-10-15',NULL),
('Consejo Nacional de Ciencia y Tecnología','Sistema Nacional de Investigadores (SISNI) 2024','Vigente','Anual','2025-08-22','Actualizado'),
-- FONDEC (2)
('Fondo Nacional de la Cultura y las Artes','Trasferencias Becas','Vigente','Trimestral','2026-01-05','Actualizado'),
('Fondo Nacional de la Cultura y las Artes','Trasferencias Personas Físicas','Vigente','Trimestral','2026-01-05','Actualizado'),
-- SNE (1)
('Secretaria Nacional de Emergencia','Asistencia en Situacion de Emergencia y/o Desastres','Vigente','Mensual','2025-11-27','Actualizado'),
-- CAH (24)
('Crédito Agrícola de Habilitación','Asistencia Financiera','Cerrado','Mensual','2015-10-13',NULL),
('Crédito Agrícola de Habilitación','Banca Comunal','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Bonos Equipamiento para la Producción Agrícola','Cerrado','Mensual','2018-12-14',NULL),
('Crédito Agrícola de Habilitación','Bonos Equipamiento para la Producción Agrícola (EPA 70/30)','Cerrado','Mensual','2020-06-02',NULL),
('Crédito Agrícola de Habilitación','CAH MERCADEO','Vigente','Mensual','2020-10-06','Desactualizado'),
('Crédito Agrícola de Habilitación','Crédito a través de Descuento de Documento','Vigente','Mensual','2020-10-06','Desactualizado'),
('Crédito Agrícola de Habilitación','Dirección de Apoyo a la Agricultura Familiar','Cerrado','Mensual','2020-10-06',NULL),
('Crédito Agrícola de Habilitación','Inversión Productiva','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Juventud Emprendedora','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Mujer Emprendedora','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Petro CAH','Vigente','Mensual','2020-10-06','Desactualizado'),
('Crédito Agrícola de Habilitación','ProAgro CAH','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Programa de Producción de Alimento','Cerrado','Mensual','2020-10-06',NULL),
('Crédito Agrícola de Habilitación','ProMandioca','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Subsidio','Cerrado','Mensual','2015-07-29',NULL),
('Crédito Agrícola de Habilitación','Equipamiento para la Producción Agricola Recuperación de Inversión','Cerrado','Mensual','2020-10-07',NULL),
('Crédito Agrícola de Habilitación','Turismo Rural','Vigente','Mensual','2020-10-06','Desactualizado'),
('Crédito Agrícola de Habilitación','Ñepyrura','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Alquimia','Cerrado','Mensual','2020-06-02',NULL),
('Crédito Agrícola de Habilitación','Po Joasa','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Mbaretera','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Triagro BioCAH','Cerrado','Mensual','2020-10-06',NULL),
('Crédito Agrícola de Habilitación','Para micro y pequeñas empresas','Vigente','Mensual','2024-10-29','Desactualizado'),
('Crédito Agrícola de Habilitación','Producción acuicola','Vigente','Mensual','2024-10-29','Desactualizado'),
-- INDERT (1)
('Instituto Nacional de Desarrollo Rural y de la Tierra','Titulación de Tierras','Vigente','Semestral','2024-01-04','Actualizado'),
-- INFONA (5)
('Instituto Forestal Nacional','Asistencia Técnica realizada','Cerrado','Mensual','2022-08-22',NULL),
('Instituto Forestal Nacional','Asistencia Técnica a productores y productoras','Cerrado','Mensual','2023-10-01',NULL),
('Instituto Forestal Nacional','Capacitación a productores rurales y actores del sector forestal','Cerrado','Mensual','2019-10-01',NULL),
('Instituto Forestal Nacional','Asistencia Técnica a productores rurales y otros del sector','Vigente','Mensual','2025-12-12','Actualizado'),
('Instituto Forestal Nacional','Formación de Técnico Superior Forestal','Vigente','Anual','2025-05-20','Actualizado'),
-- MEC (4)
('Ministerio de Educación y Ciencias','Administración del Sistema Educativo Cultural','Cerrado','Anual','2017-10-02',NULL),
('Ministerio de Educación y Ciencias','Administración del Sistema Educativo Cultural Becas Media','Vigente','Anual','2025-12-11','Actualizado'),
('Ministerio de Educación y Ciencias','Administración del Sistema Educativo Cultural Tercer Ciclo','Vigente','Anual','2024-07-04','Actualizado'),
('Ministerio de Educación y Ciencias','Administración del Sistema Educativo Cultural Becas Superior','Vigente','Anual','2025-09-24','Actualizado'),
-- MIC (3)
('Ministerio de Industria y Comercio','FOCEM','Cerrado','Trimestral','2015-07-25',NULL),
('Ministerio de Industria y Comercio','Programa Competitividad Microempresarial','Cerrado','Trimestral','2017-12-10',NULL),
('Ministerio de Industria y Comercio','Incubadora de Empresas','Cerrado','Trimestral','2015-07-25',NULL),
-- MSPBS (3)
('Ministerio de Salud Pública y Bienestar Social','APS','Vigente','Trimestral','2017-08-11','Desactualizado'),
('Ministerio de Salud Pública y Bienestar Social','Salud Bucodental','Vigente','Trimestral','2017-09-08','Desactualizado'),
('Ministerio de Salud Pública y Bienestar Social','Sub Sistema de Informacion de Estadisticas Vitales (partos)','Vigente','Trimestral','2024-07-14','Desactualizado'),
-- SENADIS (1)
('Secretaria Nacional por los Derechos Humanos de las Personas con Discapacidad','Protección y Rehabilitación a Personas con Discapacidad','Vigente','Mensual','2025-12-12','Actualizado'),
-- SND (7)
('Secretaria Nacional de Deportes','Becas','Cerrado','Anual','2023-12-27',NULL),
('Secretaria Nacional de Deportes','Proyecto escuela iniciación deportiva','Cerrado','Anual','2024-03-04',NULL),
('Secretaria Nacional de Deportes','Juegos Escolares Estudiantiles Nacionales','Vigente','Anual','2026-05-01','Actualizado'),
('Secretaria Nacional de Deportes','colonia de verano','Vigente','Anual','2025-09-12','Actualizado'),
('Secretaria Nacional de Deportes','Programa de Apoyo a Atletas de Alto Rendimiento','Vigente','Anual','2026-01-05','Actualizado'),
('Secretaria Nacional de Deportes','Torneo Interinstitucional','Vigente','Anual','2026-01-05','Actualizado'),
('Secretaria Nacional de Deportes','Escuela Deportiva SND','Vigente','Anual','2026-01-05','Actualizado'),
-- ANDE (1)
('Administración Nacional de Electricidad','Tarifa Social de la Ande','Vigente','Semestral','2024-11-18','Desactualizado'),
-- INDI (4)
('Instituto Paraguayo del Indígena','Asistencia Integral a Indígenas','Cerrado','Anual','2019-10-10',NULL),
('Instituto Paraguayo del Indígena','Asistencia Económica a Indigenas (Ayuda Social y Subsidio Estudiantil)','Vigente','Mensual','2025-11-03','Actualizado'),
('Instituto Paraguayo del Indígena','Asistencia Técnica Jurídica a Comunidades Indigenas (Medios de Vida)','Cerrado','Mensual','2023-12-12',NULL),
('Instituto Paraguayo del Indígena','Asistencia Técnica y económica para el desarrollo productivo','Vigente','Anual','2025-06-18','Actualizado'),
-- MINISTERIO DE LA MUJER (1)
('Ministerio de la Mujer','Mujeres Emprendedoras de la Agricultura Familiar (ALA/UE)','Cerrado','Anual','2017-12-19',NULL),
-- HACIENDA (6)
('Ministerio de Hacienda','Gastos de Sepelios','Vigente','Mensual','2020-07-22','Actualizado'),
('Ministerio de Hacienda','Haberes Atrasados','Vigente','Mensual','2017-04-25','Actualizado'),
('Ministerio de Hacienda','Herederos de Policías y Militares','Vigente','Mensual','2025-06-24','Actualizado'),
('Ministerio de Hacienda','Herederos de Veteranos','Vigente','Mensual','2025-06-30','Actualizado'),
('Ministerio de Hacienda','Pension Graciable','Vigente','Mensual','2025-06-24','Actualizado'),
('Ministerio de Hacienda','Pensión a Veteranos de la Guerra del Chaco','Vigente','Mensual','2025-06-24','Actualizado'),
-- MDS (7)
('Ministerio de Desarrollo Social','Focem Mercosur Habitat - Fortalecimiento de Capital Humano y Social en Condiciones de Pobreza','Cerrado','Bimensual','2017-02-28',NULL),
('Ministerio de Desarrollo Social','Proyecto FOCEM YPORA - Acceso al agua potable y saneamiento básico','Cerrado','Bimensual','2016-11-05',NULL),
('Ministerio de Desarrollo Social','Programa de Asistencia a Pescadores del Territorio Nacional','Vigente','Anual','2025-04-29','Actualizado'),
('Ministerio de Desarrollo Social','PROGRAMA TENONDERÃ','Vigente','Semestral','2025-10-10','Actualizado'),
('Ministerio de Desarrollo Social','TEKOHA - Programa de Desarrollo y Apoyo Social a Territorios Sociales','Vigente','Semestral','2025-12-16','Actualizado'),
('Ministerio de Desarrollo Social','TEKOPORÃ - Programa de Transferencia Monetaria con Corresponsabilidad','Vigente','Mensual','2024-10-09','Actualizado'),
('Ministerio de Desarrollo Social','Pension Alimentaria Adulto Mayor','Vigente','Mensual','2025-12-16','Actualizado'),
-- SEDERREC (4)
('Secretaría de Desarrollo para Repatriados y Refugiados Connacionales','Subsidio de repatriación de connacionales','Vigente','Trimestral','2025-08-18','Actualizado'),
('Secretaría de Desarrollo para Repatriados y Refugiados Connacionales','Subsidio de repatriación de restos mortales de connacionales','Vigente','Trimestral','2025-07-09','Actualizado'),
('Secretaría de Desarrollo para Repatriados y Refugiados Connacionales','Subsidio de Repatriación de Asistencia Económica','Vigente','Trimestral','2025-10-08','Actualizado'),
('Secretaría de Desarrollo para Repatriados y Refugiados Connacionales','Aporte financiero complementario','Vigente','Trimestral','2025-10-09','Actualizado'),
-- SENATUR (2)
('Secretaría Nacional de Turismo','Turismo Joven','Vigente','Semestral','2025-12-08','Actualizado'),
('Secretaría Nacional de Turismo','Programa Posadas Turisticas de Paraguay','Vigente','Semestral','2024-06-24','Desactualizado'),
-- MUVH (14) — incluye el programa anteriormente faltante
('Ministerio de Urbanismo, Vivienda y Hábitat','Coordinadora Ejecutiva para la Reforma Agraria','Cerrado','Anual','2015-07-26',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Construcción de 4500 soluciones habitacionales en el Paraguay CHE TAPYI','Cerrado','Anual','2023-05-12',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Construcción de 600 SH en el B° San Blas Mariano Roque Alonso','Cerrado','Anual','2024-04-23',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Construcción de 1000 Soluciones Habitacionales para Pueblos Indígenas','Vigente','Anual','2025-08-04','Actualizado'),
('Ministerio de Urbanismo, Vivienda y Hábitat','Mi vivienda','Vigente','Anual','2024-05-02','Actualizado'),
('Ministerio de Urbanismo, Vivienda y Hábitat','Fondo Nacional de la Vivienda Social (FONAVIS)','Vigente','Anual','2025-04-25','Actualizado'),
('Ministerio de Urbanismo, Vivienda y Hábitat','Fondo para la Convergencia Estructural del Mercosur (FOCEM)','Cerrado','Anual','2015-07-26',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Programa de Regularización de Asentamientos','Cerrado','Anual','2015-07-26',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Programa Foncoop (Fondo de viviendas para las cooperativas)','Cerrado','Anual','2015-07-26',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Pueblos Originarios','Vigente','Anual','2025-04-25','Actualizado'),
('Ministerio de Urbanismo, Vivienda y Hábitat','Sembrando Oportunidades','Cerrado','Anual','2022-03-31',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Entidades Binacionales','Cerrado','Anual','2022-03-31',NULL),
('Ministerio de Urbanismo, Vivienda y Hábitat','Vy''a Rendá','Vigente','Anual','2025-08-04','Actualizado'),
('Ministerio de Urbanismo, Vivienda y Hábitat','Mejoramiento y Ampliación de Viviendas del Área Metropolitana de Asunción AMA','Vigente','Anual','2024-10-28','Desactualizado'),
-- MNA (2) — DICUIDA corregido
('Ministerio de la Niñez y la Adolescencia','Abrazo','Vigente','Mensual','2026-04-30','Actualizado'),
('Ministerio de la Niñez y la Adolescencia','Programa Nacional de Cuidados Alterntativos DICUIDA','Vigente','Mensual','2025-10-07','Desactualizado'),
-- SEC. JUVENTUD (1)
('Secretaria de la Juventud','Apoyo economico a la educación superior','Vigente','Anual','2024-05-07','Desactualizado'),
-- MINISTERIO DE JUSTICIA Y TRABAJO (2) — nombre corregido
('Ministerio de Justicia y Trabajo','Ambaapo Paraguay','Cerrado','Anual',NULL,NULL),
('Ministerio de Justicia y Trabajo','Sistema Nacional de Formación y Capacitación Laboral','Cerrado','Anual',NULL,NULL),
-- SENASA (1)
('Servicio Nacional de Saneamiento Ambiental','Vacunación Antiaftosa','Cerrado','Anual',NULL,NULL);

-- ============================================================
-- BLOQUE 6: VERIFICACIÓN POST-CARGA
-- ============================================================
SELECT 'VERIFICACIÓN DE CARGA' AS resultado;
SELECT COUNT(*) AS total_registros, 125 AS esperado,
       IF(COUNT(*)=125,'✓ CORRECTO','✗ ERROR') AS estado
FROM programas_siis;

SELECT estado_programa, COUNT(*) AS cantidad
FROM programas_siis GROUP BY estado_programa;

SELECT estado_actualizacion, COUNT(*) AS cantidad
FROM programas_siis GROUP BY estado_actualizacion;

SELECT COUNT(DISTINCT institucion) AS total_instituciones, 26 AS esperado
FROM programas_siis;

-- ============================================================
-- BLOQUE 7: VISTAS ANALÍTICAS
-- ============================================================
CREATE OR REPLACE VIEW v_resumen_por_institucion AS
SELECT
    institucion,
    COUNT(*) AS total_programas,
    SUM(estado_programa='Vigente') AS vigentes,
    SUM(estado_programa='Cerrado') AS cerrados,
    SUM(estado_actualizacion='Actualizado') AS actualizados,
    SUM(estado_actualizacion='Desactualizado') AS desactualizados,
    ROUND(SUM(estado_actualizacion='Actualizado') /
          NULLIF(SUM(estado_programa='Vigente'),0)*100, 2) AS pct_cumplimiento
FROM programas_siis
GROUP BY institucion
ORDER BY vigentes DESC;

CREATE OR REPLACE VIEW v_programas_vigentes AS
SELECT id, institucion, programa, periodo_actualizacion,
       ultima_fecha_actualizacion, estado_actualizacion,
       DATEDIFF(CURDATE(), ultima_fecha_actualizacion) AS dias_sin_actualizar
FROM programas_siis
WHERE estado_programa = 'Vigente'
ORDER BY institucion, estado_actualizacion;

CREATE OR REPLACE VIEW v_alertas_desactualizacion AS
SELECT id, institucion, programa, periodo_actualizacion,
       ultima_fecha_actualizacion,
       DATEDIFF(CURDATE(), ultima_fecha_actualizacion) AS dias_atraso,
       CASE
         WHEN periodo_actualizacion='Mensual'    AND DATEDIFF(CURDATE(),ultima_fecha_actualizacion)>30  THEN 'CRÍTICO'
         WHEN periodo_actualizacion='Bimensual'  AND DATEDIFF(CURDATE(),ultima_fecha_actualizacion)>60  THEN 'CRÍTICO'
         WHEN periodo_actualizacion='Trimestral' AND DATEDIFF(CURDATE(),ultima_fecha_actualizacion)>90  THEN 'CRÍTICO'
         WHEN periodo_actualizacion='Semestral'  AND DATEDIFF(CURDATE(),ultima_fecha_actualizacion)>180 THEN 'CRÍTICO'
         WHEN periodo_actualizacion='Anual'      AND DATEDIFF(CURDATE(),ultima_fecha_actualizacion)>365 THEN 'CRÍTICO'
         ELSE 'ATENCIÓN'
       END AS nivel_alerta
FROM programas_siis
WHERE estado_programa='Vigente' AND estado_actualizacion='Desactualizado'
ORDER BY dias_atraso DESC;

-- ============================================================
-- BLOQUE 8: STORED PROCEDURES
-- ============================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_generar_reporte_mensual $$
CREATE PROCEDURE sp_generar_reporte_mensual(IN p_anio YEAR, IN p_mes TINYINT)
BEGIN
    DECLARE v_total INT DEFAULT 0;
    DECLARE v_vig   INT DEFAULT 0;
    DECLARE v_cerr  INT DEFAULT 0;
    DECLARE v_act   INT DEFAULT 0;
    DECLARE v_des   INT DEFAULT 0;
    DECLARE v_pct   DECIMAL(5,2) DEFAULT 0.00;

    SELECT COUNT(*), SUM(estado_programa='Vigente'), SUM(estado_programa='Cerrado'),
           SUM(estado_actualizacion='Actualizado'), SUM(estado_actualizacion='Desactualizado')
    INTO v_total, v_vig, v_cerr, v_act, v_des FROM programas_siis;

    IF v_vig > 0 THEN SET v_pct = ROUND(v_act/v_vig*100, 2); END IF;

    INSERT INTO reportes_mensuales
        (anio,mes,total_programas,total_vigentes,total_cerrados,total_actualizados,total_desactualizados,porcentaje_cumplimiento)
    VALUES (p_anio,p_mes,v_total,v_vig,v_cerr,v_act,v_des,v_pct)
    ON DUPLICATE KEY UPDATE
        total_programas=v_total, total_vigentes=v_vig, total_cerrados=v_cerr,
        total_actualizados=v_act, total_desactualizados=v_des,
        porcentaje_cumplimiento=v_pct, fecha_generacion=NOW();

    SELECT p_anio AS anio, p_mes AS mes, v_total AS total, v_vig AS vigentes,
           v_cerr AS cerrados, v_act AS actualizados, v_des AS desactualizados, v_pct AS pct;
END $$

DROP PROCEDURE IF EXISTS sp_actualizar_estado $$
CREATE PROCEDURE sp_actualizar_estado(
    IN p_id INT, IN p_estado ENUM('Actualizado','Desactualizado'),
    IN p_fecha DATE, IN p_usuario VARCHAR(100), IN p_obs TEXT)
BEGIN
    DECLARE v_anterior VARCHAR(50);
    SELECT estado_actualizacion INTO v_anterior FROM programas_siis WHERE id=p_id;

    UPDATE programas_siis SET
        estado_actualizacion=p_estado, ultima_fecha_actualizacion=p_fecha,
        usuario_registro=p_usuario, observaciones=p_obs
    WHERE id=p_id AND estado_programa='Vigente';

    IF ROW_COUNT()>0 THEN
        INSERT INTO historial_cambios (id_programa,campo_mod,valor_anterior,valor_nuevo,usuario_cambio)
        VALUES (p_id,'estado_actualizacion',v_anterior,p_estado,p_usuario),
               (p_id,'ultima_fecha_actualizacion',NULL,p_fecha,p_usuario);
        SELECT 'OK' AS resultado, p_id AS id_actualizado;
    ELSE
        SELECT 'ERROR: Programa no encontrado o está Cerrado' AS resultado;
    END IF;
END $$

DELIMITER ;

-- ============================================================
-- BLOQUE 9: EVENTO AUTOMÁTICO MENSUAL
-- ============================================================
-- Habilitar scheduler: SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS evt_reporte_mensual;
CREATE EVENT evt_reporte_mensual
ON SCHEDULE EVERY 1 MONTH
    STARTS CONCAT(DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH),'%Y-%m'),'-01 00:05:00')
DO CALL sp_generar_reporte_mensual(YEAR(CURDATE()), MONTH(CURDATE()));

-- Generar reporte del mes actual
CALL sp_generar_reporte_mensual(YEAR(CURDATE()), MONTH(CURDATE()));

-- ============================================================
-- FIN DEL SCRIPT — SIIS v2.0
-- ============================================================
