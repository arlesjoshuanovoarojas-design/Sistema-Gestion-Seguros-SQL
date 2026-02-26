CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    dni VARCHAR(15) NOT NULL,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    telefono VARCHAR(15),
    correo VARCHAR(100),
    direccion VARCHAR(150)
);

CREATE TABLE poliza (
    id_poliza SERIAL PRIMARY KEY,
    numero_poliza VARCHAR(20),
    fecha_fin DATE,
    estado VARCHAR(20),
    prima DECIMAL(10,2),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE cobertura (
    id_cobertura SERIAL PRIMARY KEY,
    descripcion VARCHAR(150),
    monto_maximo DECIMAL(10,2),
    id_poliza INT,
    FOREIGN KEY (id_poliza) REFERENCES poliza(id_poliza)
);

CREATE TABLE siniestro (
    id_siniestro SERIAL PRIMARY KEY,
    fecha_reporte DATE,
    descripcion VARCHAR(150),
    monto_reclamado DECIMAL(10,2),
    estado VARCHAR(20),
    id_poliza INT,
    FOREIGN KEY (id_poliza) REFERENCES poliza(id_poliza)
);

CREATE TABLE pago (
    id_pago SERIAL PRIMARY KEY,
    fecha_pago DATE,
    monto_pagado DECIMAL(10,2),
    metodo_pago VARCHAR(50),
    estado_pago VARCHAR(20),
    id_siniestro INT,
    FOREIGN KEY (id_siniestro) REFERENCES siniestro(id_siniestro)
);

INSERT INTO cliente (dni, nombres, apellidos, telefono, correo, direccion)
VALUES
('12345678','Carlos','Ramirez Soto','987654321','carlos@email.com','Av. Lima 123'),
('87654321','Maria','Gonzales Perez','912345678','maria@email.com','Jr. Arequipa 456');

INSERT INTO poliza (numero_poliza, fecha_fin, estado, prima, id_cliente)
VALUES
('POL-001','2026-12-31','Activa',1200.00,1),
('POL-002','2026-06-30','Activa',950.00,2);

INSERT INTO cobertura (descripcion, monto_maximo, id_poliza)
VALUES
('Cobertura contra incendios',50000.00,1),
('Cobertura contra robos',30000.00,1),
('Cobertura vehicular total',80000.00,2);

INSERT INTO siniestro (fecha_reporte, descripcion, monto_reclamado, estado, id_poliza)
VALUES
('2026-02-10','Incendio parcial en vivienda',20000.00,'En evaluacion',1),
('2026-03-05','Choque vehicular leve',15000.00,'Aprobado',2);

INSERT INTO pago (fecha_pago, monto_pagado, metodo_pago, estado_pago, id_siniestro)
VALUES
('2026-02-20',18000.00,'Transferencia','Completado',1),
('2026-03-10',15000.00,'Deposito bancario','Completado',2);

SELECT * FROM cliente;
SELECT * FROM poliza;
SELECT * FROM cobertura;
SELECT * FROM siniestro;
SELECT * FROM pago;

SELECT c.nombres, c.apellidos, p.numero_poliza, p.prima
FROM cliente c
JOIN poliza p ON c.id_cliente = p.id_cliente;

SELECT p.numero_poliza, co.descripcion, co.monto_maximo
FROM poliza p
JOIN cobertura co ON p.id_poliza = co.id_poliza;

SELECT c.nombres, s.descripcion, s.monto_reclamado, s.estado
FROM siniestro s
JOIN poliza p ON s.id_poliza = p.id_poliza
JOIN cliente c ON p.id_cliente = c.id_cliente;

SELECT c.nombres, SUM(s.monto_reclamado) AS total_reclamado
FROM cliente c
JOIN poliza p ON c.id_cliente = p.id_cliente
JOIN siniestro s ON p.id_poliza = s.id_poliza
GROUP BY c.nombres;