# SIIS — Guía de Implementación v2.0
**Sistema Integrado de Información Social · UTGS · Proyecto PNUD PARAGUAY + VERDE (00115142)**

---

## Archivos del Sistema (v2.0)

| Archivo | Descripción | Estado |
|---------|-------------|--------|
| `siis_v2_implementacion.sql` | Script SQL canónico único con 125 programas | ✅ Definitivo |
| `dashboard_siis_v2.html` | Dashboard corregido y sincronizado | ✅ Definitivo |
| Archivos anteriores (v1) | Versiones anteriores con inconsistencias | ⚠ Archivar |

---

## Correcciones aplicadas en v2.0

### Datos (Dashboard HTML)
| # | Corrección | Detalle |
|---|-----------|---------|
| 1 | Programa agregado | MUVH — "Mejoramiento y Ampliación de Viviendas del Área Metropolitana de Asunción AMA" (faltaba en v1) |
| 2 | Fecha corregida | Abrazo (MNA): `2025-12-02` → `2026-04-30` |
| 3 | Nombre + estado + fecha | DICUIDA (MNA): nombre abreviado → nombre completo, estado Actualizado → Desactualizado |
| 4 | Typo institución | "Minesterio de Justicia Y trabajo" → "Ministerio de Justicia y Trabajo" |
| 5 | Error de encoding | "Informacin" → "Informacion" (MSPBS) |
| 6 | Nombre unificado | TEKOPORÃ: guión bajo → guión |
| 7 | Nombre unificado | TEKOHA: nombre extendido → nombre canónico SQL |
| 8 | Nombre unificado | FOCEM Mercosur Habitat: nombre extendido → nombre SQL |
| 9 | Nombre unificado | Proyecto FOCEM YPORA: nombre extendido → nombre SQL |

### Totales finales
```
Total programas : 125 ✓
Vigentes        :  73
Cerrados        :  52
Actualizados    :  49
Desactualizados :  24
Instituciones   :  26
```

---

## Pasos de Implementación

### 1. Base de Datos MySQL
```bash
# Conectarse a MySQL
mysql -u root -p

# Ejecutar script (DROP + CREATE + INSERT + PROCEDURES)
source /ruta/siis_v2_implementacion.sql
```

### 2. Verificar carga
```sql
USE siis_utgs;
SELECT COUNT(*) FROM programas_siis;  -- debe dar 125
SELECT * FROM v_resumen_por_institucion;
```

### 3. Dashboard
Abrir `dashboard_siis_v2.html` directamente en el navegador.  
Para producción: servir desde un servidor web (Apache, Nginx) o integrar con backend PHP/Node.

### 4. Activar Evento Mensual Automático
```sql
SET GLOBAL event_scheduler = ON;
-- El evento evt_reporte_mensual se ejecuta el día 1 de cada mes a las 00:05
```

---

## Mantenimiento

### Actualizar estado de un programa
```sql
CALL sp_actualizar_estado(
    <id_programa>,
    'Actualizado',         -- o 'Desactualizado'
    '2026-05-06',          -- fecha de actualización
    'nombre.usuario',
    'Observación opcional'
);
```

### Generar reporte mensual manualmente
```sql
CALL sp_generar_reporte_mensual(2026, 5);
```

### Vistas disponibles
```sql
SELECT * FROM v_resumen_por_institucion;    -- resumen por institución
SELECT * FROM v_programas_vigentes;          -- solo vigentes con días
SELECT * FROM v_alertas_desactualizacion;    -- programas vencidos con nivel alerta
```

---

## Notas Técnicas
- **Charset**: utf8mb4 / utf8mb4_unicode_ci (soporte completo de caracteres especiales: ã, é, ó, ñ, etc.)
- **Engine**: InnoDB (soporte de FK e integridad referencial)
- **Zona horaria**: GMT-4 (Paraguay)
- **Apóstrofes en SQL**: escapar como `''` (comilla simple doble), e.g. `Vy''a Rendá`
