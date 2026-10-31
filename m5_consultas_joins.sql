-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: integrar ventas, clientes, productos y categorías en una sola vista.

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo:
-- La vista reúne toda la información comercial necesaria
-- para analizar ventas por cliente y categoría.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca compraron.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- Hallazgo:
-- 1 cliente registrado aún no realizó compras.
-- CRM puede contactarlo mediante campañas de activación.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar productos del catálogo sin ventas registradas.

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
WHERE v.id_producto IS NULL;

-- Hallazgo:
-- 1 producto del catálogo no registra ventas.
-- El área de producto puede evaluar acciones comerciales para incrementar su rotación.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar ventas de Computación frente al resto de categorías.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Computacion' AS canal
    FROM ventas v
    INNER JOIN productos p
        ON v.id_producto = p.id_producto
    INNER JOIN categorias c
        ON p.id_categoria = c.id_categoria
    WHERE c.nombre_categoria = 'Computación'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Otras Categorias' AS canal
    FROM ventas v
    INNER JOIN productos p
        ON v.id_producto = p.id_producto
    INNER JOIN categorias c
        ON p.id_categoria = c.id_categoria
    WHERE c.nombre_categoria <> 'Computación'

) AS consolidado
GROUP BY canal;

-- Hallazgo:
-- La categoría Computación generó $4.950 en ventas,
-- mientras que el resto de las categorías alcanzó $1.494.
-- Computación representa la principal fuente de ingresos de TechStore.
