-- Trabajo Práctico - MySQL Veterinaria "Patitas Felices"
-- Objetivo
-- Este trabajo práctico tiene como objetivo principal que los estudiantes demuestren sus conocimientos en el diseño, creación y manipulación de bases de datos relacionales utilizando MySQL. A través de la implementación de un sistema de gestión para una veterinaria, se evaluará la capacidad de:
-- ● Diseñar un esquema de base de datos relacional apropiado
-- ● Crear tablas con relaciones de integridad referencial (claves foráneas)
-- ● Realizar operaciones CRUD (Create, Read, Update, Delete)
-- ● Aplicar consultas complejas utilizando JOINs
-- ● Gestionar la integridad de los datos mediante transacciones y eliminaciones en cascada
-- Entrega
-- ● La entrega se realizará mediante un repositorio público en GitHub.
-- ● El repositorio debe incluir:
-- ○ Scripts SQL con todas las consultas realizadas (archivo .sql o múltiples archivos organizados).
-- ● El nombre del repositorio debe ser: tp-mysql-[nombre-apellido].
-- Requisitos técnicos obligatorios
-- ● MySQL
-- ● Editor de texto o IDE para escribir scripts SQL
-- ● Conocimientos previos en:
-- ○ SQL básico (CREATE, INSERT, UPDATE, DELETE, SELECT)
-- ○ Claves primarias y foráneas
-- ○ Relaciones entre tablas
-- ○ Consultas con JOIN
-- Descripción del proyecto
-- La veterinaria "Patitas Felices" necesita un sistema de gestión para administrar sus datos. El sistema debe permitir:
-- ● Gestionar dueños de mascotas
-- ● Registrar mascotas y su relación con sus dueños
-- ● Administrar veterinarios y sus especialidades
-- ● Registrar el historial clínico, vinculando mascotas, veterinarios y fechas
-- El sistema debe garantizar la integridad de los datos mediante relaciones adecuadas y permitir consultas combinadas entre varias tablas.
-- Ejercicios
-- Ejercicio 1 – Crear Base de Datos
-- Crear una base de datos llamada veterinaria_patitas_felices.
CREATE DATABASE veterinaria_patitas_felices;

USE veterinaria_patitas_felices;

-- Ejercicio 2 – Crear tabla duenos
-- Crear la tabla duenos con las siguientes columnas:
-- Columna -- Tipo -- Restricciones
-- id      -- INT  -- PRIMARY KEY, AUTO_INCREMENT
-- nombre  -- VARCHAR(50)-- NOT NULL
-- apellido-- VARCHAR(50)-- NOT NULL
-- telefono-- VARCHAR(20)-- NOT NULL
-- direccion-- VARCHAR(100)
CREATE TABLE duenos (
    id_dueno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(100)
);

-- Ejercicio 3 – Crear tabla mascotas
-- Crear la tabla mascotas con las siguientes columnas:
-- Columna-- Tipo-- Restricciones
-- id-- INT-- PRIMARY KEY, AUTO_INCREMENT
-- nombre-- VARCHAR(50)-- NOT NULL
-- especie-- VARCHAR(30)-- NOT NULL
-- fecha_nacimiento-- DATE
-- id_dueno-- INT-- FOREIGN KEY → duenos.id
CREATE TABLE mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    fecha_nacimiento DATE,
    id_dueno INT NOT NULL,
    INDEX idx_mascotas_id_dueno (id_dueno),
    FOREIGN KEY (id_dueno) REFERENCES duenos(id_dueno) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Ejercicio 4 – Crear tabla veterinarios
-- Crear la tabla veterinarios con las siguientes columnas:
-- Columna-- Tipo-- Restricciones
-- id-- INT-- PRIMARY KEY, AUTO_INCREMENT
-- nombre-- VARCHAR(50)-- NOT NULL
-- apellido-- VARCHAR(50)-- NOT NULL
-- matricula-- VARCHAR(20)-- NOT NULL, UNIQUE
-- especialidad-- VARCHAR(50)-- NOT NULL
CREATE TABLE veterinarios (
    id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    especialidad VARCHAR(50) NOT NULL
);

-- Ejercicio 5 – Crear tabla historial_clinico
-- Crear la tabla historial_clinico con las siguientes columnas:
-- Columna-- Tipo-- Restricciones
-- id-- INT-- PRIMARY KEY, AUTO_INCREMENT
-- id_mascota-- INT-- FOREIGN KEY → mascotas.id
-- id_veterinario-- INT-- FOREIGN KEY → veterinarios.id
-- fecha_registro-- DATETIME-- NOT NULL, DEFAULT CURRENT_TIMESTAMP
-- descripcion-- VARCHAR(250)-- NOT NULL
CREATE TABLE historiales_clinicos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(250) NOT NULL,
    id_mascota INT NOT NULL,
    INDEX idx_historiales_id_mascota (id_mascota),
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE ON UPDATE CASCADE,
    id_veterinario INT NOT NULL,
    INDEX idx_historiales_id_veterinario (id_veterinario),
    FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id_veterinario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Ejercicio 6 – Insertar registros
-- Insertar:
-- ● 3 dueños con información completa
INSERT INTO
    duenos (nombre, apellido, telefono, direccion)
VALUES
    ('Juan', 'Pérez', '123456789', 'Calle Falsa 123'),
    (
        'Ana',
        'Gómez',
        '987654321',
        'Avenida Siempre Viva 742'
    ),
    (
        'Luis',
        'Martínez',
        '456789123',
        'Boulevard de los Sueños 456'
    );

-- ● 3 mascotas, cada una asociada a un dueño
INSERT INTO
    mascotas (nombre, especie, fecha_nacimiento, id_dueno)
VALUES
    ('Firulais', 'Perro', '2018-05-01', 1),
    ('Miau', 'Gato', '2020-08-15', 2),
    ('Pajarito', 'Ave', '2019-11-30', 3);

-- ● 2 veterinarios con especialidades distintas
INSERT INTO
    veterinarios (nombre, apellido, matricula, especialidad)
VALUES
    ('Dr. Carlos', 'López', 'VET001', 'Cirugía'),
    (
        'Dra. María',
        'Fernández',
        'VET002',
        'Dermatología'
    );

-- ● 3 registros de historial clínico
INSERT INTO
    historiales_clinicos (
        fecha_registro,
        descripcion,
        id_mascota,
        id_veterinario
    )
VALUES
    (NOW(), 'Consulta por alergias', 1, 1),
    (NOW(), 'Revisión anual', 2, 2),
    (NOW(), 'Vacunación', 3, 1);

-- Ejercicio 7 – Actualizar registros
-- Realizar las siguientes actualizaciones:
-- 1. Cambiar la dirección de un dueño (por ID o nombre).
UPDATE
    duenos
SET
    direccion = 'Nueva Calle 123'
WHERE
    id_dueno = 3;

-- 2. Actualizar la especialidad de un veterinario (por ID o matrícula).
UPDATE
    veterinarios
SET
    especialidad = 'Medicina Interna'
WHERE
    id_veterinario = 2;

-- 3. Editar la descripción de un historial clínico (por ID).
UPDATE
    historiales_clinicos
SET
    descripcion = 'Desparasitacion'
WHERE
    id_historial = 1;

-- Ejercicio 8 – Eliminar registros
-- 1. Eliminar una mascota (por ID o nombre).
DELETE FROM
    mascotas
WHERE
    id_mascota = 3;

-- 2. Verificar que se eliminen automáticamente los registros del historial clínico asociados (ON DELETE CASCADE).
SELECT
    *
FROM
    historiales_clinicos
WHERE
    id_mascota = 3;

-- Ejercicio 9 – JOIN simple
-- Consulta que muestre:
-- ● Nombre de la mascota
-- ● Especie
-- ● Nombre completo del dueño (nombre + apellido)
SELECT
    m.nombre AS Mascota,
    m.especie,
    CONCAT(d.nombre, ' ', d.apellido)
FROM
    mascotas AS m
    INNER JOIN duenos AS d ON m.id_dueno = d.id_dueno;

-- Ejercicio 10
-- JOIN múltiple con historial
-- Consulta que muestre todas las entradas del historial clínico con:
-- ● Nombre y especie de la mascota
-- ● Nombre completo del dueño
-- ● Nombre completo del veterinario
-- ● Fecha de registro
-- ● Descripción
-- Ordenados por fecha de registro descendente (DESC).
SELECT
    m.nombre,
    m.especie,
    CONCAT(d.nombre, ' ', d.apellido) AS Dueño,
    CONCAT(v.nombre, ' ', v.apellido) AS Veterinario,
    h.fecha_registro,
    h.descripcion
FROM
    historiales_clinicos AS h
    INNER JOIN mascotas AS m ON m.id_mascota = h.id_mascota
    INNER JOIN veterinarios AS v ON v.id_veterinario = h.id_veterinario
    INNER JOIN duenos AS d ON d.id_dueno = m.id_dueno
ORDER BY
    h.fecha_registro DESC;