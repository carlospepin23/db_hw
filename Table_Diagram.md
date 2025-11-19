# Database Table Diagram – Online Supermarket Chain  
---

## 1. COUNTRY
| Attribute        | Data Type     | Constraints                               |
|------------------|---------------|--------------------------------------------|
| **country_id**   | INT           | PRIMARY KEY, AUTO_INCREMENT                |
| country_name     | VARCHAR(100)  | NOT NULL, UNIQUE                           |
| country_code     | CHAR(3)       | NOT NULL, UNIQUE                           |

**Relationships:**  
- COUNTRY (1) — (M) CITY  
- COUNTRY (1) — (M) WAREHOUSE  
- COUNTRY (1) — (M) CUSTOMER (via shipping_country_id)

---

## 2. CITY
| Attribute      | Data Type     | Constraints                                       |
|----------------|---------------|--------------------------------------------------|
| **city_id**    | INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| city_name      | VARCHAR(100)  | NOT NULL                                         |
| country_id     | INT           | FOREIGN KEY → COUNTRY(country_id), NOT NULL      |

**Relationships:**  
- CITY (1) — (M) WAREHOUSE  
- CITY (1) — (M) CUSTOMER  

---

## 3. WAREHOUSE
| Attribute         | Data Type     | Constraints                                    |
|-------------------|---------------|------------------------------------------------|
| **warehouse_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                    |
| warehouse_name    | VARCHAR(150)  | NOT NULL                                       |
| city_id           | INT           | FOREIGN KEY → CITY(city_id), NOT NULL          |
| country_id        | INT           | FOREIGN KEY → COUNTRY(country_id), NOT NULL    |
| address           | VARCHAR(255)  | NOT NULL                                       |
| total_capacity    | DECIMAL(10,2) | NULL                                           |

**Relationships:**  
- WAREHOUSE (1) — (M) WAREHOUSE_SECTION  
- WAREHOUSE (1) — (M) EMPLOYEE  
- WAREHOUSE (1) — (M) INVENTORY_TRANSACTION  
- WAREHOUSE (M) — (M) ORDER (via ORDER_WAREHOUSE)

---

## 4. WAREHOUSE_SECTION
| Attribute       | Data Type     | Constraints                                     |
|-----------------|---------------|--------------------------------------------------|
| **section_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| warehouse_id    | INT           | FOREIGN KEY → WAREHOUSE(warehouse_id), NOT NULL |
| section_name    | VARCHAR(100)  | NOT NULL                                        |
| section_type    | VARCHAR(50)   | NOT NULL                                        |
| has_refrigeration | BOOLEAN     | DEFAULT FALSE                                   |
| has_climate_control | BOOLEAN   | DEFAULT FALSE                                   |
| temperature_min | DECIMAL(5,2)  | NULL                                            |
| temperature_max | DECIMAL(5,2)  | NULL                                            |

**Relationships:**  
- WAREHOUSE_SECTION (1) — (M) SECTION_INVENTORY  

---

## 5. PRODUCT
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
- PRODUCT (1) — (M) SECTION_INVENTORY  
- PRODUCT (1) — (M) INVENTORY_TRANSACTION  
- PRODUCT (1) — (M) ORDER_ITEM  

---

## 6. SECTION_INVENTORY
| Attribute          | Data Type     | Constraints                                       |
|--------------------|---------------|---------------------------------------------------|
| **inventory_id**   | INT           | PRIMARY KEY, AUTO_INCREMENT                       |
| section_id         | INT           | FOREIGN KEY → WAREHOUSE_SECTION(section_id)       |
| product_id         | INT           | FOREIGN KEY → PRODUCT(product_id)                 |
| quantity_available | INT           | NOT NULL, DEFAULT 0                               |
| last_updated       | DATETIME      | NOT NULL                                          |

**Unique:** (section_id, product_id)

**Relationships:**  
- SECTION_INVENTORY (M) → (1) PRODUCT  
- SECTION_INVENTORY (M) → (1) WAREHOUSE_SECTION  

---

## 7. INVENTORY_TRANSACTION
| Attribute           | Data Type     | Constraints                                          |
|---------------------|---------------|------------------------------------------------------|
| **transaction_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                          |
| warehouse_id        | INT           | FOREIGN KEY → WAREHOUSE(warehouse_id), NOT NULL      |
| product_id          | INT           | FOREIGN KEY → PRODUCT(product_id), NOT NULL          |
| transaction_type    | VARCHAR(20)   | NOT NULL                                             |
| quantity            | INT           | NOT NULL                                             |
| transaction_date    | DATETIME      | NOT NULL                                             |
| notes               | TEXT          | NULL                                                 |
| employee_id         | INT           | FOREIGN KEY → EMPLOYEE(employee_id), NULL            |

**Relationships:**  
- INVENTORY_TRANSACTION (M) → (1) PRODUCT  
- INVENTORY_TRANSACTION (M) → (1) WAREHOUSE  
- INVENTORY_TRANSACTION (M) → (1) EMPLOYEE  

---

## 8. EMPLOYEE
| Attribute        | Data Type     | Constraints                                 |
|------------------|---------------|----------------------------------------------|
| **employee_id**  | INT           | PRIMARY KEY, AUTO_INCREMENT                  |
| first_name       | VARCHAR(50)   | NOT NULL                                     |
| last_name        | VARCHAR(50)   | NOT NULL                                     |
| email            | VARCHAR(100)  | UNIQUE, NOT NULL                             |
| phone            | VARCHAR(20)   | NULL                                         |
| warehouse_id     | INT           | FOREIGN KEY → WAREHOUSE(warehouse_id)        |
| position         | VARCHAR(100)  | NOT NULL                                     |
| hire_date        | DATE          | NOT NULL                                     |

**Relationships:**  
- EMPLOYEE (M) → (1) WAREHOUSE  

---

## 9. CUSTOMER
| Attribute            | Data Type     | Constraints                                      |
|----------------------|---------------|--------------------------------------------------|
| **customer_id**      | INT           | PRIMARY KEY, AUTO_INCREMENT                       |
| first_name           | VARCHAR(50)   | NOT NULL                                          |
| last_name            | VARCHAR(50)   | NOT NULL                                          |
| email                | VARCHAR(100)  | UNIQUE, NOT NULL                                   |
| phone                | VARCHAR(20)   | NULL                                              |
| shipping_address     | VARCHAR(255)  | NOT NULL                                          |
| shipping_city_id     | INT           | FOREIGN KEY → CITY(city_id), NOT NULL             |
| shipping_country_id  | INT           | FOREIGN KEY → COUNTRY(country_id), NOT NULL       |
| registration_date    | DATE          | NOT NULL                                          |

**Relationships:**  
- CUSTOMER (1) — (M) ORDER  

---

## 10. ORDER
| Attribute        | Data Type     | Constraints                                 |
|------------------|---------------|----------------------------------------------|
| **order_id**     | INT           | PRIMARY KEY, AUTO_INCREMENT                  |
| customer_id      | INT           | FOREIGN KEY → CUSTOMER(customer_id)          |
| order_date       | DATETIME      | NOT NULL                                     |
| total_amount     | DECIMAL(12,2) | NOT NULL                                     |
| order_status     | VARCHAR(30)   | NOT NULL                                     |
| tracking_number  | VARCHAR(100)  | UNIQUE, NULL                                 |
| shipped_date     | DATETIME      | NULL                                         |
| delivered_date   | DATETIME      | NULL                                         |

**Relationships:**  
- ORDER (1) — (M) ORDER_ITEM  
- ORDER (M) — (M) WAREHOUSE via ORDER_WAREHOUSE  

---

## 11. ORDER_ITEM
| Attribute         | Data Type     | Constraints                                 |
|-------------------|---------------|----------------------------------------------|
| **order_item_id** | INT           | PRIMARY KEY, AUTO_INCREMENT                  |
| order_id          | INT           | FOREIGN KEY → ORDER(order_id)                |
| product_id        | INT           | FOREIGN KEY → PRODUCT(product_id)            |
| quantity          | INT           | NOT NULL                                     |
| unit_price        | DECIMAL(10,2) | NOT NULL                                     |
| subtotal          | DECIMAL(12,2) | NOT NULL                                     |

---

## 12. ORDER_WAREHOUSE
| Attribute             | Data Type     | Constraints                                     |
|-----------------------|---------------|-------------------------------------------------|
| **order_warehouse_id**| INT           | PRIMARY KEY, AUTO_INCREMENT                      |
| order_id              | INT           | FOREIGN KEY → ORDER(order_id), NOT NULL          |
| warehouse_id          | INT           | FOREIGN KEY → WAREHOUSE(warehouse_id), NOT NULL  |
| fulfillment_status    | VARCHAR(30)   | NOT NULL                                         |
| assigned_date         | DATETIME      | NOT NULL                                         |

**Unique:** (order_id, warehouse_id)

---

# Cardinality Summary

1. COUNTRY (1) ↔ (M) CITY  
2. COUNTRY (1) ↔ (M) WAREHOUSE  
3. CITY (1) ↔ (M) WAREHOUSE  
4. CITY (1) ↔ (M) CUSTOMER  
5. WAREHOUSE (1) ↔ (M) WAREHOUSE_SECTION  
6. WAREHOUSE (1) ↔ (M) EMPLOYEE  
7. WAREHOUSE (1) ↔ (M) INVENTORY_TRANSACTION  
8. WAREHOUSE_SECTION (1) ↔ (M) SECTION_INVENTORY  
9. PRODUCT (1) ↔ (M) SECTION_INVENTORY  
10. PRODUCT (1) ↔ (M) INVENTORY_TRANSACTION  
11. PRODUCT (1) ↔ (M) ORDER_ITEM  
12. CUSTOMER (1) ↔ (M) ORDER  
13. ORDER (1) ↔ (M) ORDER_ITEM  
14. ORDER (M) ↔ (M) WAREHOUSE (via ORDER_WAREHOUSE)

---

# Query Support Analysis

**Query 1:** Products running low on stock  
→ `SECTION_INVENTORY.quantity_available` + `PRODUCT.reorder_threshold`

**Query 2:** Warehouses receiving restocks  
→ `INVENTORY_TRANSACTION.transaction_type = 'INBOUND'`

**Query 3:** Orders shipped to specific country  
→ Join ORDER → CUSTOMER → COUNTRY

**Query 4:** Total inventory value per warehouse  
→ Join WAREHOUSE → SECTION → INVENTORY → PRODUCT  
→ `SUM(quantity * base_price)`

**Query 5:** Employees per warehouse  
→ `EMPLOYEE.warehouse_id`

**Query 6:** Check special storage compliance  
→ Compare PRODUCT storage requirements vs. SECTION capabilities

**Query 7:** Orders not shipped  
→ `ORDER.order_status = 'PENDING'` or `shipped_date IS NULL`

**Query 8:** Warehouses supplying an order  
→ `ORDER_WAREHOUSE.warehouse_id`

---

If you want this **exported as a formatted PDF**, I can generate one next.
