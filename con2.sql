--1 Pedidos realizados en una fecha a elección y abonados en efectivo:

SELECT * 
FROM Pedidos 
WHERE pago = 'EFE' 
  AND DATE(FechaHoraPedido) = '2018-10-15';

--2Listado de pizzas con base normal:
SELECT * 
FROM Pizzas 
WHERE base = 'NOR';


--3 Datos completos de cada empleado:
SELECT * 
FROM Personal;


--4 Listado de los pedidos entregados:
SELECT * 
FROM Pedidos 
WHERE estado = 'ENT';


--5 Pedidos que se encuentran en cocina (pendientes) y son abonados con tarjeta de crédito:
SELECT * 
FROM Pedidos 
WHERE estado = 'PEN' 
  AND pago IN ('VIS', 'MAS', 'AME');


-- 6 Pizzas vendidas con base borde con queso y con base fina:

SELECT * 
FROM Clientes 
WHERE localidad IN ('REO', 'PSM', 'MAL');

-- 7 Datos de clientes que viven en Reocin, Puente San Miguel y Maliaño:
SELECT * 
FROM Clientes 
WHERE localidad IN ('REO', 'PSM', 'MAL');


-- 8 Listado de pizzas para un pedido (por ejemplo, pedido con ID 5):
SELECT * 
FROM Pizzas 
WHERE pedido = 5;
  

-- 9 Sumar precios de ingredientes para la pizza “Aceitunas”:
SELECT SUM(importe) AS total_importe_aceitunas
FROM IngredienteDePizza 
WHERE ingrediente = 'ACE';


-- 10 Contar las pizzas de un pedido (por ejemplo, pedido con ID 5):
SELECT COUNT(*) AS cantidad_pizzas 
FROM Pizzas 
WHERE pedido = 5;
