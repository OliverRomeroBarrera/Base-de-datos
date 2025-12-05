PRAGMA foreign_keys = ON;

-- *****************
-- TABLAS   
-- *****************

CREATE TABLE IF NOT EXISTS cliente (
    cliente_id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    telefono TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    direccion TEXT,
    fecha_registro TEXT NOT NULL DEFAULT (date('now')),
    CHECK (length(telefono) >= 10),
    CHECK (email LIKE '%@%')
);

CREATE TABLE IF NOT EXISTS empleado (
    empleado_id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    rol TEXT NOT NULL CHECK (rol IN ('Gerente', 'Repartidor', 'Cocinero', 'Cajero')),
    telefono TEXT NOT NULL UNIQUE,
    usuario TEXT NOT NULL UNIQUE,
    fecha_registro TEXT NOT NULL DEFAULT (date('now'))
);

CREATE TABLE IF NOT EXISTS producto (
    producto_id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    tipo TEXT NOT NULL CHECK (tipo IN ('Taco', 'Bebida', 'Postre', 'Complemento')),
    precio_unitario REAL NOT NULL CHECK (precio_unitario > 0),
    unidad_medida REAL NOT NULL DEFAULT 1,
    activo INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS pedido (
    pedido_id TEXT PRIMARY KEY,
    cliente_id TEXT NOT NULL,
    fecha_pedido TEXT NOT NULL DEFAULT (datetime('now')),
    tipo_pago TEXT CHECK (tipo_pago IN ('Efectivo', 'Tarjeta', 'Transferencia')),
    estado TEXT NOT NULL DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'En Proceso', 'Completado', 'Entregado', 'Cancelado')),
    total REAL NOT NULL CHECK (total >= 0),
    empleado_id TEXT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id) ON DELETE RESTRICT,
    FOREIGN KEY (empleado_id) REFERENCES empleado(empleado_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS detalle_pedido (
    detalle_id TEXT PRIMARY KEY,
    pedido_id TEXT NOT NULL,
    producto_id TEXT NOT NULL,
    cantidad REAL NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL CHECK (precio_unitario > 0),
    sub_total REAL NOT NULL CHECK (sub_total >= 0),
    FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS pago (
    pago_id TEXT PRIMARY KEY,
    pedido_id TEXT NOT NULL,
    fecha_pago TEXT NOT NULL DEFAULT (datetime('now')),
    monto REAL NOT NULL CHECK (monto > 0),
    metodo TEXT NOT NULL CHECK (metodo IN ('Efectivo', 'Tarjeta', 'Transferencia')),
    referencia TEXT UNIQUE,
    FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS inventario (
    inventario_id TEXT PRIMARY KEY,
    producto_id TEXT NOT NULL UNIQUE,
    stock_actual REAL NOT NULL CHECK (stock_actual >= 0),
    stock_minimo REAL NOT NULL CHECK (stock_minimo >= 0),
    ultima_actualizacion TEXT NOT NULL DEFAULT (datetime('now')),
    ubicacion TEXT,
    FOREIGN KEY (producto_id) REFERENCES producto(producto_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS evento (
    evento_id TEXT PRIMARY KEY,
    pedido_id TEXT NOT NULL UNIQUE,
    fecha_evento TEXT NOT NULL,
    lugar TEXT NOT NULL,
    numero_personas REAL NOT NULL CHECK (numero_personas > 0),
    estado TEXT NOT NULL DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Confirmado', 'Cancelado', 'Completado')),
    notas TEXT,
    FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id) ON DELETE CASCADE
);

-- **************************
-- ÍNDICES PARA OPTIMIZACIÓN
-- **************************

CREATE INDEX IF NOT EXISTS idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX IF NOT EXISTS idx_pedido_empleado ON pedido(empleado_id);
CREATE INDEX IF NOT EXISTS idx_pedido_fecha ON pedido(fecha_pedido);
CREATE INDEX IF NOT EXISTS idx_pedido_estado ON pedido(estado);

CREATE INDEX IF NOT EXISTS idx_detalle_pedido ON detalle_pedido(pedido_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto ON detalle_pedido(producto_id);

CREATE INDEX IF NOT EXISTS idx_pago_pedido ON pago(pedido_id);
CREATE INDEX IF NOT EXISTS idx_pago_fecha ON pago(fecha_pago);

CREATE INDEX IF NOT EXISTS idx_inventario_producto ON inventario(producto_id);

CREATE INDEX IF NOT EXISTS idx_evento_pedido ON evento(pedido_id);
CREATE INDEX IF NOT EXISTS idx_evento_fecha ON evento(fecha_evento);

-- 1. CLIENTES
INSERT INTO cliente VALUES
('C100', 'Juanito', 'Alcachofa', '8115551010', 'juanito.alcachofa@gmail.com', 'Colonia Roma 45', '2025-05-01'),
('C101', 'Alma', 'Marla', '8115552020', 'alma.marla@hotmail.com', 'Av. Las Torres 99', '2025-05-15'),
('C102', 'Bruce', 'Banner', '8115553030', 'bruce.banner@yahoo.com', 'Calle Hidalgo 12 Centro', '2025-05-20');

-- 2. EMPLEADOS 
INSERT INTO empleado VALUES
('E100', 'Gilberto', 'Muñoz', 'Gerente', '8187770001', 'giluñoz', '2025-04-01'),
('E101', 'Miguel', 'Ángel', 'Repartidor', '8187770002', 'mangel', '2025-04-10');

-- 3. PRODUCTOS 
INSERT INTO producto VALUES
('P001', 'Taco de maiz', 'Taco al vapor de maiz', 'Taco', 7.00, 1, 1),
('P002', 'Taco de harina', 'Taco al vapor de harina con queso', 'Taco', 12.00, 1, 1),
('P003', 'Refresco 600ml', 'Refresco embotellado', 'Bebida', 18.00, 1, 1),
('P004', 'Agua de horchata', 'Vaso de 500ml', 'Bebida', 15.00, 1, 1);

-- 4. INVENTARIO 
INSERT INTO inventario VALUES
('INV01', 'P001', 300, 50, '2025-06-01', 'Cocina Central'),
('INV02', 'P002', 250, 40, '2025-06-01', 'Cocina Central'),
('INV03', 'P003', 100, 20, '2025-06-01', 'Refrigerador 1'),
('INV04', 'P004', 80, 15, '2025-06-01', 'Barra de bebidas');

-- 5. PEDIDOS 
-- Pedido 1: Grande para evento (Efectivo)
-- Pedido 2: Comida normal (Transferencia)
-- Pedido 3: Solo bebidas y pocos tacos (Tarjeta)
INSERT INTO pedido VALUES
('PED100', 'C100', '2025-06-05', 'Efectivo', 'Entregado', 600.00, 'E100'),
('PED101', 'C101', '2025-06-06', 'Transferencia', 'Completado', 66.00, 'E101'),
('PED102', 'C102', '2025-06-07', 'Tarjeta', 'En Proceso', 54.00, 'E100');

-- 6. DETALLE PEDIDO
-- Detalles del PED100 (Total 475) -> 25 de Maiz + 25 de Harina
INSERT INTO detalle_pedido VALUES
('DET01', 'PED100', 'P001', 25, 7.00, 175.00),
('DET02', 'PED100', 'P002', 25, 12.00, 300.00),

-- Detalles del PED101 (Total 46) -> 4 de Maiz + 1 Refresco
('DET03', 'PED101', 'P001', 4, 7.00, 28.00),
('DET04', 'PED101', 'P003', 1, 18.00, 18.00),

-- Detalles del PED102 (Total 54) -> 2 Harina + 2 Horchata
('DET05', 'PED102', 'P002', 2, 12.00, 24.00),
('DET06', 'PED102', 'P004', 2, 15.00, 30.00);

-- 7. PAGOS 
INSERT INTO pago VALUES
('PAG01', 'PED100', '2025-06-05', 475.00, 'Efectivo', 'TICKET-001'),
('PAG02', 'PED101', '2025-06-06', 46.00, 'Transferencia', 'SPEI-56789'),
('PAG03', 'PED102', '2025-06-07', 54.00, 'Tarjeta', 'AUTH-9988');

-- 8. EVENTOS
INSERT INTO evento VALUES
('EVT01', 'PED100', '2025-06-10', 'Pemex Topolobampo', 50, 'Confirmado', 'Llevar salsas extra y servilletas'),
('EVT02', 'PED102', '2025-06-12', 'Toro Loco', 5, 'Pendiente', 'Reunion de amigos');