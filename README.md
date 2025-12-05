# Base de Datos - Proyecto Tacos del Chavo

## Descripción
Este repositorio contiene el script SQL para la base de datos del proyecto "Tacos del Chavo".

## Archivos
- `tacos_del_chavo.sql` - Script SQL con la estructura y datos de la base de datos

## Estructura de la Base de Datos

La base de datos incluye las siguientes tablas:

| Tabla | Descripción |
|-------|-------------|
| `clientes` | Información de los clientes |
| `categorias` | Categorías de productos |
| `productos` | Productos del menú (tacos, bebidas, extras) |
| `pedidos` | Registro de pedidos |
| `detalle_pedido` | Detalle de productos por pedido |

## Cómo usar

1. Abrir MySQL o MariaDB
2. Ejecutar el script:
   ```sql
   SOURCE tacos_del_chavo.sql;
   ```
   O importar desde la línea de comandos:
   ```bash
   mysql -u usuario -p < tacos_del_chavo.sql
   ```

## Autor
Oliver Romero Barrera
