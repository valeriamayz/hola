--1) Realizar los siguientes procedimientos, funciones o vistas y guardar en un script de sql.

--1. Calcular la suma total de todos los pedidos realizados por el cliente.

    SELECT SUM(p.importe) AS "Suma total", c.codigo, c.telefono
    FROM Pedidos p 
    JOIN Clientes c 
    ON p.cliente = c.codigo
    GROUP BY c.codigo;

--2. Calcular la suma total de todos los pedidos realizados por el cliente, identificados por su forma de pago.

    USE pizzeria;
    SELECT c.codigo AS cliente_id, c.nombre, p.pago, mp.descripcion AS medio_pago, SUM(p.importe) AS total_pedidos
    FROM Clientes c
    JOIN Pedidos p ON c.codigo = p.cliente
    JOIN MediosPago mp ON p.pago = mp.codigo
    GROUP BY c.codigo, c.nombre, p.pago, mp.descripcion;
   

--3. Se necesita un proceso automatizado que permita agregar tuplas en la tabla Ingredientes de Pizzas.
DELIMITER $$

DROP PROCEDURE IF EXISTS InsertarIngredientePizza; $$
CREATE PROCEDURE InsertarIngredientePizza (
    IN p_pizza INT,
    IN p_ingrediente CHAR(3),
    IN p_importe DECIMAL (5,2)
)
BEGIN
    --INSERTAR INGREDIENTES DE PIZZA
    INSERT INTO IngredienteDePizza (pizza, ingrediente, importe)
    VALUES (p_pizza, p_ingrediente, p_importe);
END; $$

DELIMITER ;

--Prueba
CALL  InsertarIngredientePizza (9, "CHA", 1.0);


--4. Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT 'Ingrediente' AS tipo, descripcion, importe
FROM Ingredientes
WHERE importe = (SELECT MAX(importe) FROM Ingredientes)
UNION
SELECT 'Base' AS tipo, descripcion, importe
FROM Bases
WHERE importe = (SELECT MAX(importe) FROM Bases);


--5. Mostrar aquellos clientes que hayan realizado una compra en un mes a elección del usuario.
SET @mes = 9; -- septiembre
SELECT DISTINCT c.*
FROM Clientes c
JOIN Pedidos p ON c.codigo = p.cliente
WHERE MONTH(p.FechaHoraPedido) = @mes;


--6. Eliminar todos aquellos empleados que no pertenecen más a la pizzería (pista: Fecha de Baja)

UPDATE  Personal SET fechaBaja = '2025-06-07' WHERE codigo = 2;

DELETE FROM Personal WHERE fechaBaja IS NOT NULL;

--7. Visualizar todos aquellos pedidos pendientes de entrega, solicite ingrese una determinada fecha tope.

SET @fechaTope = '2018-10-31';
SELECT * FROM Pedidos WHERE estado = 'PEN' AND FechaHoraPedido <= @fechaTope;


--8. Actualizar un 15% los valores de los todos los ingredientes

UPDATE Ingredientes SET importe = importe *1.15;



--1) Realizar los siguientes procedimientos, funciones o vistas y guardar en un script de sql
--1. Calcular la suma total de los pagos realizados por el cliente.
SELECT c.nombre, SUM(p.importe) AS total_pagos FROM Clientes c 
JOIN Pedidos p ON c.codigo = p.cliente
WHERE c.codigo = 1
GROUP BY c.nombre;



--2. Calcular los pagos pendientes de todos los clientes
SELECT c.nombre, SUM(p.importe) AS total_pendiente FROM Clientes c
JOIN Pedidos p ON c.codigo = p.cliente
WHERE p.estado = 'PEN'
GROUP BY c.nombre;


--3. Calcular el precio de venta del producto más caro y más barato con sus respectivos nombres que lo identifiquen.

SELECT p.codigo AS codigo_pizza, (p.importeBase + SUM(idp.importe)) AS precio_total
FROM Pizzas p
LEFT JOIN IngredienteDePizza idp ON p.codigo = idp.pizza
GROUP BY p.codigo
HAVING precio_total = (
SELECT MAX(subtotal)
FROM (
SELECT p.codigo, (p.importeBase + SUM(idp.importe)) AS subtotal
FROM Pizzas p
LEFT JOIN IngredienteDePizza idp ON p.codigo = idp.pizza
GROUP BY p.codigo
) AS maximos
)

UNION ALL

SELECT p.codigo AS codigo_pizza, (p.importeBase + SUM(idp.importe)) AS precio_total
FROM Pizzas p
LEFT JOIN IngredienteDePizza idp ON p.codigo = idp.pizza
GROUP BY p.codigo
HAVING precio_total = (
SELECT MIN(subtotal)
FROM (
SELECT p.codigo, (p.importeBase + SUM(idp.importe)) AS subtotal
FROM Pizzas p
LEFT JOIN IngredienteDePizza idp ON p.codigo = idp.pizza
GROUP BY p.codigo
) AS minimos
);

--4. Actualizar un 20% los valores de los todos las bases de pizzas.


UPDATE Bases SET importe = importe *1.20;


--5. Se necesita un proceso automatizado que permita agregar registros o tuplas en la tabla Pizzas
DELIMITER $$
CREATE PROCEDURE AgregarPizza(IN p_codigo INT, IN p_pedido INT, IN p_base VARCHAR(3), IN p_importeBase DECIMAL(5,2) 
)
BEGIN 
--insertar pizza
INSERT INTO Pizzas (codigo, pedido, base, importeBase)
VALUES (p_codigo, p_pedido,p_base, p_importeBase);
END; $$
DELIMITER ;

--llamar
CALL AgregarPizza (11,2, 'QUE',4);


--6. Mostrar el empleado con mayores ventas del mes. Se deberá calcular una comisión según la forma de pago: Efectivo 5 % , tarjeta de crédito 10 %.

CREATE TABLE Comisiones (
    descripcion char(20),
    porcentaje decimal(5,2),
    PRIMARY KEY (descripcion)
);

INSERT INTO Comisiones VALUES 
('Efectivo', 0.05),
('Tarjeta de crédito', 0.10);

SELECT p.nombre,
       p.apellido1,
       SUM(pe.importe * c.porcentaje) AS comision_total
FROM Pedidos pe
JOIN Personal p ON pe.personal = p.codigo
JOIN MediosPago mp ON pe.pago = mp.codigo
JOIN Comisiones c ON mp.descripcion = c.descripcion
WHERE MONTH(pe.FechaHoraPedido) = MONTH(CURDATE())
  AND YEAR(pe.FechaHoraPedido) = YEAR(CURDATE())
GROUP BY p.codigo, p.nombre, p.apellido1
ORDER BY comision_total DESC
LIMIT 1;

--7. Devuelve el nombre del cliente con mayor límite de crédito.
ALTER TABLE Clientes ADD limite_credito DECIMAL(10,2);

UPDATE Clientes
SET limite_credito = 50000
WHERE codigo = 1;

SELECT nombre, apellido1, apellido2, limite_credito
FROM Clientes
ORDER BY limite_credito DESC
LIMIT 1;


--8. Eliminar todos aquellos pedidos pendientes y cancelados, solicite ingrese una determinada fecha tope.
-- Eliminar las pizzas asociadas a los pedidos pendientes o cancelados
DELETE FROM Pizzas
WHERE pedido IN (
    SELECT codigo
    FROM Pedidos
    WHERE estado IN ('PEN', 'CAN')
      AND FechaHoraPedido <= '2024-05-08 08:00:00'
);

-- Eliminar los pedidos
DELETE FROM Pedidos
WHERE estado IN ('PEN', 'CAN')
  AND FechaHoraPedido <= '2024-05-08 08:00:00';


SET @fechaTope = '2024-05-08 08:00:00';

DELETE FROM Pedidos
WHERE estado IN ('PEN', 'CAN')
  AND FechaHoraPedido <= @fechaTope;
