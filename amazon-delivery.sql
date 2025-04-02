-- Create Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    delivery_date DATE,
    status VARCHAR(20)
);

-- Create Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    region VARCHAR(50),
    city VARCHAR(50),
    zip_code VARCHAR(10)
);

-- Create Logistics Table
CREATE TABLE Logistics (
    order_id INT PRIMARY KEY,
    warehouse_id INT,
    delivery_partner VARCHAR(50),
    dispatch_time TIMESTAMP,
    transit_time INTERVAL
);

-- Create Weather Table
CREATE TABLE Weather (
    order_date DATE,
    region VARCHAR(50),
    weather_condition VARCHAR(50),
    temperature FLOAT
);

-- Total Orders and Delays Per Region
WITH RegionOrders AS (
    SELECT c.region, COUNT(o.order_id) AS total_orders,
           SUM(CASE WHEN o.delivery_date > o.order_date THEN 1 ELSE 0 END) AS delayed_orders
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    GROUP BY c.region
)
SELECT region, total_orders, delayed_orders,
       ROUND((delayed_orders * 100.0) / total_orders, 2) AS delay_percentage
FROM RegionOrders;

-- Predict Delays Based on Weather and Region
WITH WeatherDelays AS (
    SELECT c.region, w.weather_condition, COUNT(o.order_id) AS total_orders,
           SUM(CASE WHEN o.delivery_date > o.order_date THEN 1 ELSE 0 END) AS delayed_orders
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    JOIN Weather w ON o.order_date = w.order_date AND c.region = w.region
    GROUP BY c.region, w.weather_condition
)
SELECT region, weather_condition, total_orders, delayed_orders,
       ROUND((delayed_orders * 100.0) / total_orders, 2) AS delay_percentage
FROM WeatherDelays;

-- Optimize Delivery Routes
WITH AvgTransitTime AS (
    SELECT l.warehouse_id, c.region, AVG(l.transit_time) AS avg_transit_time
    FROM Logistics l
    JOIN Orders o ON l.order_id = o.order_id
    JOIN Customers c ON o.customer_id = c.customer_id
    GROUP BY l.warehouse_id, c.region
)
SELECT warehouse_id, region, avg_transit_time
FROM AvgTransitTime
ORDER BY avg_transit_time;

-- Identify Peak Delivery Times Per Warehouse
WITH PeakTimes AS (
    SELECT l.warehouse_id, EXTRACT(HOUR FROM l.dispatch_time) AS dispatch_hour,
           COUNT(o.order_id) AS total_orders
    FROM Logistics l
    JOIN Orders o ON l.order_id = o.order_id
    GROUP BY l.warehouse_id, dispatch_hour
)
SELECT warehouse_id, dispatch_hour, total_orders
FROM PeakTimes
ORDER BY warehouse_id, total_orders DESC;

-- Calculate Average Delivery Time by Region and Weather
WITH AvgDeliveryTime AS (
    SELECT c.region, w.weather_condition,
           AVG(o.delivery_date - o.order_date) AS avg_delivery_days
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    JOIN Weather w ON o.order_date = w.order_date AND c.region = w.region
    GROUP BY c.region, w.weather_condition
)
SELECT region, weather_condition, avg_delivery_days
FROM AvgDeliveryTime
ORDER BY avg_delivery_days DESC;

-- Find Top 5 Most Delayed Delivery Partners
WITH DelayedPartners AS (
    SELECT l.delivery_partner, COUNT(o.order_id) AS delayed_orders
    FROM Orders o
    JOIN Logistics l ON o.order_id = l.order_id
    WHERE o.status = 'Delayed'
    GROUP BY l.delivery_partner
)
SELECT delivery_partner, delayed_orders
FROM DelayedPartners
ORDER BY delayed_orders DESC
LIMIT 5;
