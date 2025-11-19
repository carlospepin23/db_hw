# Database Table Diagram – Online Supermarket Chain  
---

## 1. country
| Attribute        | Data Type     | Constraints                               |
|------------------|---------------|--------------------------------------------|
| **country_id**   | INT           | PRIMARY KEY, AUTO_INCREMENT                |
| country_name     | VARCHAR(100)  | NOT NULL, UNIQUE                           |
| country_code     | CHAR(3)       | NOT NULL, UNIQUE                           |

**Relationships:**  
- country (1) — (M) city  
- country (1) — (M) warehouse  
- country (1) — (M) customer (via shipping_country_id)

---

## 2. city
| Attribute      | Data Type     | Constraints                                       |
|----------------|---------------|--------------------------------------------------|
| **city_id**    | INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| city_name      | VARCHAR(100)  | NOT NULL                                         |
| country_id     | INT           | FOREIGN KEY → country(country_id), NOT NULL      |

**Relationships:**  
- city (1) — (M) warehouse  
- city (1) — (M) customer  

---

## 3. warehouse
| Attribute         | Data Type     | Constraints                                    |
|-------------------|---------------|------------------------------------------------|
| **warehouse_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                    |
| warehouse_name    | VARCHAR(150)  | NOT NULL                                       |
| city_id           | INT           | FOREIGN KEY → city(city_id), NOT NULL          |
| country_id        | INT           | FOREIGN KEY → country(country_id), NOT NULL    |
| address           | VARCHAR(255)  | NOT NULL                                       |
| total_capacity    | DECIMAL(10,2) | NULL                                           |

**Relationships:**  
- warehouse (1) — (M) warehouse_section  
- warehouse (1) — (M) employee  
- warehouse (1) — (M) inventory_transaction  
- warehouse (M) — (M) order (via order_warehouse)

---

## 4. warehouse_section
| Attribute       | Data Type     | Constraints                                     |
|-----------------|---------------|--------------------------------------------------|
| **section_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| warehouse_id    | INT           | FOREIGN KEY → warehouse(warehouse_id), NOT NULL |
| section_name    | VARCHAR(100)  | NOT NULL                                        |
| section_type    | VARCHAR(50)   | NOT NULL                                        |
| has_refrigeration | BOOLEAN     | DEFAULT FALSE                                   |
| has_climate_control | BOOLEAN   | DEFAULT FALSE                                   |
| temperature_min | DECIMAL(5,2)  | NULL                                            |
| temperature_max | DECIMAL(5,2)  | NULL                                            |

**Relationships:**  
- warehouse_section (1) — (M) section_inventory  

---

## 5. product
| Attribute                | Data Type     | Constraints                    |
|--------------------------|---------------|---------------------------------|
| **product_id**           | INT           | PRIMARY KEY, AUTO_INCREMENT     |
| product_name             | VARCHAR(200)  | NOT NULL                        |
| description              | TEXT          | NULL                            |
| category                 | VARCHAR(100)  | NOT NULL                        |
| base_price               | DECIMAL(10,2) | NOT NULL                        |
| sku                      | VARCHAR(50)   | UNIQUE, NOT NULL                |
| requires_refrigeration   | BOOLEAN       | DEFAULT FALSE                   |
| requires_climate_control | BOOLEAN       | DEFAULT FALSE                   |
| required_temp_min        | DECIMAL(5,2)  | NULL                            |
| required_temp_max        | DECIMAL(5,2)  | NULL                            |
| reorder_threshold        | INT           | NOT NULL, DEFAULT 10            |

**Relationships:**  
- product (1) — (M) section_inventory  
- product (1) — (M) inventory_transaction  
- product (1) — (M) order_item  

---

## 6. section_inventory
| Attribute          | Data Type     | Constraints                                       |
|--------------------|---------------|---------------------------------------------------|
| **inventory_id**   | INT           | PRIMARY KEY, AUTO_INCREMENT                       |
| section_id         | INT           | FOREIGN KEY → warehouse_section(section_id), NOT NULL |
| product_id         | INT           | FOREIGN KEY → product(product_id), NOT NULL       |
| quantity_available | INT           | NOT NULL, DEFAULT 0                               |
| last_updated       | TIMESTAMP     | NOT NULL                                          |

**Unique:** (section_id, product_id)

**Relationships:**  
- section_inventory (M) → (1) product  
- section_inventory (M) → (1) warehouse_section  

---

## 7. inventory_transaction
| Attribute           | Data Type     | Constraints                                          |
|---------------------|---------------|------------------------------------------------------|
| **transaction_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                          |
| warehouse_id        | INT           | FOREIGN KEY → warehouse(warehouse_id), NOT NULL      |
| product_id          | INT           | FOREIGN KEY → product(product_id), NOT NULL          |
| transaction_type    | VARCHAR(20)   | NOT NULL                                             |
| quantity            | INT           | NOT NULL                                             |
| transaction_date    | TIMESTAMP     | NOT NULL                                             |
| notes               | TEXT          | NULL                                                 |
| employee_id         | INT           | FOREIGN KEY → employee(employee_id), NULL            |

**Relationships:**  
- inventory_transaction (M) → (1) product  
- inventory_transaction (M) → (1) warehouse  
- inventory_transaction (M) → (1) employee  

---

## 8. employee
| Attribute        | Data Type     | Constraints                                 |
|------------------|---------------|----------------------------------------------|
| **employee_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                  |
| first_name       | VARCHAR(50)   | NOT NULL                                     |
| last_name        | VARCHAR(50)   | NOT NULL                                     |
| email            | VARCHAR(100)  | UNIQUE, NOT NULL                             |
| phone            | VARCHAR(20)   | NULL                                         |
| warehouse_id     | INT           | FOREIGN KEY → warehouse(warehouse_id), NOT NULL |
| position         | VARCHAR(100)  | NOT NULL                                     |
| hire_date        | DATE          | NOT NULL                                     |

**Relationships:**  
- employee (M) → (1) warehouse  

---

## 9. customer
| Attribute            | Data Type     | Constraints                                      |
|----------------------|---------------|--------------------------------------------------|
| **customer_id**      | INT           | PRIMARY KEY, AUTO_INCREMENT                       |
| first_name           | VARCHAR(50)   | NOT NULL                                          |
| last_name            | VARCHAR(50)   | NOT NULL                                          |
| email                | VARCHAR(100)  | UNIQUE, NOT NULL                                   |
| phone                | VARCHAR(20)   | NULL                                              |
| shipping_address     | VARCHAR(255)  | NOT NULL                                          |
| shipping_city_id     | INT           | FOREIGN KEY → city(city_id), NOT NULL             |
| shipping_country_id  | INT           | FOREIGN KEY → country(country_id), NOT NULL       |
| registration_date    | DATE          | NOT NULL                                          |

**Relationships:**  
- customer (1) — (M) order  

---

## 10. order
| Attribute        | Data Type     | Constraints                                 |
|------------------|---------------|----------------------------------------------|
| **order_id**     | INT           | PRIMARY KEY, AUTO_INCREMENT                  |
| customer_id      | INT           | FOREIGN KEY → customer(customer_id), NOT NULL |
| order_date       | TIMESTAMP     | NOT NULL                                     |
| total_amount     | DECIMAL(12,2) | NOT NULL                                     |
| order_status     | VARCHAR(30)   | NOT NULL                                     |
| tracking_number  | VARCHAR(100)  | UNIQUE, NULL                                 |
| shipped_date     | TIMESTAMP     | NULL                                         |
| delivered_date   | TIMESTAMP     | NULL                                         |

**Relationships:**  
- order (1) — (M) order_item  
- order (M) — (M) warehouse via order_warehouse  

---

## 11. order_item
| Attribute         | Data Type     | Constraints                                 |
|-------------------|---------------|----------------------------------------------|
| **order_item_id** | INT           | PRIMARY KEY, AUTO_INCREMENT                  |
| order_id          | INT           | FOREIGN KEY → order(order_id), NOT NULL      |
| product_id        | INT           | FOREIGN KEY → product(product_id), NOT NULL  |
| quantity          | INT           | NOT NULL                                     |
| unit_price        | DECIMAL(10,2) | NOT NULL                                     |
| subtotal          | DECIMAL(12,2) | NOT NULL                                     |

**Relationships:**  
- order_item (M) → (1) order  
- order_item (M) → (1) product

---

## 12. order_warehouse
| Attribute             | Data Type     | Constraints                                     |
|-----------------------|---------------|-------------------------------------------------|
| **order_warehouse_id**| INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| order_id              | INT           | FOREIGN KEY → order(order_id), NOT NULL          |
| warehouse_id          | INT           | FOREIGN KEY → warehouse(warehouse_id), NOT NULL  |
| fulfillment_status    | VARCHAR(30)   | NOT NULL                                         |
| assigned_date         | TIMESTAMP     | NOT NULL                                         |

**Unique:** (order_id, warehouse_id)

**Relationships:**  
- order_warehouse (M) → (1) order  
- order_warehouse (M) → (1) warehouse

---

# Cardinalities

1. country (1) ↔ (M) city  
2. country (1) ↔ (M) warehouse  
3. city (1) ↔ (M) warehouse  
4. city (1) ↔ (M) customer  
5. warehouse (1) ↔ (M) warehouse_section  
6. warehouse (1) ↔ (M) employee  
7. warehouse (1) ↔ (M) inventory_transaction  
8. warehouse_section (1) ↔ (M) section_inventory  
9. product (1) ↔ (M) section_inventory  
10. product (1) ↔ (M) inventory_transaction  
11. product (1) ↔ (M) order_item  
12. customer (1) ↔ (M) order  
13. order (1) ↔ (M) order_item  
14. order (M) ↔ (M) warehouse (via order_warehouse)

---

# Queries

**Query 1:** Products running low on stock  
→ `section_inventory.quantity_available` + `product.reorder_threshold`

**Query 2:** Warehouses receiving restocks  
→ `inventory_transaction.transaction_type = 'INBOUND'`

**Query 3:** Orders shipped to specific country  
→ Join order → customer → country

**Query 4:** Total inventory value per warehouse  
→ Join warehouse → warehouse_section → section_inventory → product  
→ `SUM(quantity * base_price)`

**Query 5:** Employees per warehouse  
→ `employee.warehouse_id`

**Query 6:** Check special storage compliance  
→ Compare product storage requirements vs. warehouse_section capabilities

**Query 7:** Orders not shipped  
→ `order.order_status = 'PENDING'` or `shipped_date IS NULL`

**Query 8:** Warehouses supplying an order  
→ `order_warehouse.warehouse_id`
