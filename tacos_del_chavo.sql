-- ============================================
-- Base de Datos: Tacos del Chavo
-- Proyecto para revisión del profesor
-- ============================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS tacos_del_chavo;
USE tacos_del_chavo;

-- ============================================
-- Tabla: Clientes
-- ============================================
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(255),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Tabla: Categorias de productos
-- ============================================
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255)
);

-- ============================================
-- Tabla: Productos (Tacos y otros productos)
-- ============================================
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- ============================================
-- Tabla: Pedidos
-- ============================================
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'en_preparacion', 'listo', 'entregado', 'cancelado') DEFAULT 'pendiente',
    total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- ============================================
-- Tabla: Detalle de pedidos
-- ============================================
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================
-- Datos de ejemplo: Categorías
-- ============================================
INSERT INTO categorias (nombre, descripcion) VALUES
('Tacos', 'Variedad de tacos tradicionales'),
('Bebidas', 'Refrescos y aguas frescas'),
('Extras', 'Complementos y extras');

-- ============================================
-- Datos de ejemplo: Productos
-- ============================================
INSERT INTO productos (nombre, descripcion, precio, id_categoria) VALUES
('Taco de Pastor', 'Taco de carne al pastor con piña', 25.00, 1),
('Taco de Bistec', 'Taco de bistec asado', 28.00, 1),
('Taco de Carnitas', 'Taco de carnitas de cerdo', 26.00, 1),
('Taco de Barbacoa', 'Taco de barbacoa de res', 30.00, 1),
('Agua de Horchata', 'Agua fresca de horchata', 20.00, 2),
('Refresco', 'Refresco de lata', 18.00, 2),
('Guacamole', 'Porción de guacamole', 15.00, 3),
('Salsa Extra', 'Porción extra de salsa', 5.00, 3);

-- ============================================
-- Datos de ejemplo: Clientes
-- ============================================
INSERT INTO clientes (nombre, telefono, email, direccion) VALUES
('Juan Pérez', '555-1234', 'juan@email.com', 'Calle Principal 123'),
('María García', '555-5678', 'maria@email.com', 'Avenida Central 456');

-- ============================================
-- Fin del script
-- ============================================
