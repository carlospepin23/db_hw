-- Supermarket Database Queries
-- Database: supermarket_chain (PostgreSQL)

-- ============================================
-- Query 1: Find all products running low on stock (below threshold)
-- ============================================
SELECT 
    p.product_id,
    p.product_name,
    p.sku,
    p.category,
    p.reorder_threshold,
    w.warehouse_name,
    ws.section_name,
    si.quantity_available,
    (p.reorder_threshold - si.quantity_available) AS units_below_threshold
FROM 
    product as p
    JOIN section_inventory as si ON p.product_id = si.product_id
    JOIN warehouse_section as ws ON si.section_id = ws.section_id
    JOIN warehouse as w ON ws.warehouse_id = w.warehouse_id
WHERE 
    si.quantity_available < p.reorder_threshold
ORDER BY units_below_threshold DESC;


-- ============================================
-- Query 2: Find all warehouses that received restocked products in the last month
-- ============================================
SELECT DISTINCT
    w.warehouse_id,
    w.warehouse_name,
    w.address,
    COUNT(DISTINCT it.product_id) AS products_restocked,
    SUM(it.quantity) AS total_quantity_received
FROM 
    warehouse as w
    JOIN inventory_transaction as it ON w.warehouse_id = it.warehouse_id
WHERE 
    it.transaction_type = 'INBOUND'
    AND it.transaction_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY 
    w.warehouse_id, w.warehouse_name, w.address
ORDER BY 
    total_quantity_received DESC;


-- ============================================
-- Query 3: Find all orders shipped to a specific country
-- ============================================
SELECT 
    o.order_id,
    o.tracking_number,
    o.order_date,
    o.shipped_date,
    o.order_status,
    c.first_name,
    c.last_name,
    c.shipping_address,
    ci.city_name,
    co.country_name
FROM 
    "order" as o
    JOIN customer as c ON o.customer_id = c.customer_id
    JOIN city as ci ON c.shipping_city_id = ci.city_id
    JOIN country as co ON c.shipping_country_id = co.country_id
WHERE 
    co.country_name = 'United States'
ORDER BY 
    o.order_date DESC;


-- ============================================
-- Query 4: Find the total value of inventory stored in each warehouse
-- ============================================
SELECT 
    w.warehouse_id,
    w.warehouse_name,
    w.address,
    COUNT(DISTINCT p.product_id) AS unique_products,
    SUM(si.quantity_available) AS total_units,
    SUM(si.quantity_available * p.base_price) AS total_inventory_value
FROM 
    warehouse as w
    JOIN warehouse_section as ws ON w.warehouse_id = ws.warehouse_id
    JOIN section_inventory as si ON ws.section_id = si.section_id
    JOIN product as p ON si.product_id = p.product_id
GROUP BY 
    w.warehouse_id, w.warehouse_name, w.address
ORDER BY 
    total_inventory_value DESC;


-- ============================================
-- Query 5: Find all employees assigned to a specific warehouse
-- ============================================
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.email,
    e.phone,
    e.position,
    e.hire_date,
    w.warehouse_name,
    w.address
FROM 
    employee as e
    JOIN warehouse as w ON e.warehouse_id = w.warehouse_id
WHERE -- Can be changed to warehouse_name
    w.warehouse_id = 1 -- w.warehouse_name = 'NYC Main Warehouse'
ORDER BY 
    e.position, e.last_name;


-- ============================================
-- Query 6: Check if products requiring special storage conditions are in warehouse sections that fulfill requirements
-- ============================================
-- Products in INCORRECT storage (violations)
SELECT 
    p.product_id,
    p.product_name,
    p.requires_refrigeration,
    p.requires_climate_control,
    p.required_temp_min,
    p.required_temp_max,
    ws.section_name,
    ws.has_refrigeration,
    ws.has_climate_control,
    ws.temperature_min,
    ws.temperature_max,
    w.warehouse_name,
    'VIOLATION' AS status
FROM 
    product as p
    JOIN section_inventory as si ON p.product_id = si.product_id
    JOIN warehouse_section as ws ON si.section_id = ws.section_id
    JOIN warehouse as w ON ws.warehouse_id = w.warehouse_id
WHERE 
    (p.requires_refrigeration = TRUE AND ws.has_refrigeration = FALSE)
    OR (p.requires_climate_control = TRUE AND ws.has_climate_control = FALSE)
    OR (p.required_temp_min < ws.temperature_min)
    OR (p.required_temp_max > ws.temperature_max);


-- ============================================
-- Query 7: Find all orders that have not been shipped yet
-- ============================================
SELECT 
    o.order_id,
    o.tracking_number,
    o.order_date,
    o.order_status,
    o.total_amount,
    c.first_name,
    c.last_name,
    c.email,
    c.shipping_address
FROM 
    "order" as o
    JOIN customer as c ON o.customer_id = c.customer_id
WHERE 
    o.shipped_date IS NULL
    OR o.order_status IN ('PENDING', 'PROCESSING')
ORDER BY 
    o.order_date ASC;


-- ============================================
-- Query 8: Find what warehouses are supplying an order
-- ============================================
SELECT 
    o.order_id,
    o.tracking_number,
    o.order_status,
    w.warehouse_id,
    w.warehouse_name,
    w.address,
    ow.fulfillment_status,
    ow.assigned_date,
    ci.city_name,
    co.country_name
FROM 
    "order" as o
    JOIN order_warehouse as ow ON o.order_id = ow.order_id
    JOIN warehouse as w ON ow.warehouse_id = w.warehouse_id
    JOIN city as ci ON w.city_id = ci.city_id
    JOIN country as co ON w.country_id = co.country_id
WHERE 
    o.order_id = 4
ORDER BY 
    ow.assigned_date;
