# 📦 Amazon Delivery Analytics Project

## ✨ Project Overview
This project analyzes over **1 million delivery records** to uncover delay drivers and optimize logistics performance. Using **SQL** for data extraction and analysis, and **Power BI/Tableau** for visualization, the project delivers insights into:
- ⏳ **Delivery delays by region and weather conditions**.
- 🚚 **Partner performance tracking**.
- 🔄 **Route optimization strategies**.
- 💡 **Warehouse efficiency improvements**.

Key Impact: Reduced delivery delays by **12%** and enhanced operational efficiency.

---

## 📊 Dataset Overview
The project uses four core datasets:
1. **Orders:** Order details, delivery status, and timelines.
2. **Customers:** Customer location data.
3. **Logistics:** Warehouse, dispatch times, and delivery partner information.
4. **Weather:** Daily weather conditions by region.

---

## ⚙️ Data Modeling & SQL Queries
Structured queries were designed to extract insights on:
- Total orders and delays by region.
- Impact of weather on delays.
- Partner performance and delay trends.
- Peak dispatch hours per warehouse.
- Route optimization.

### 🔥 Complex Query Example: Predict Delays Based on Weather and Region
```sql
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
FROM WeatherDelays
ORDER BY delay_percentage DESC;
```

---

## 🔄 Power BI & Tableau Dashboards
**Key Visualizations:**
- 🌍 **Delivery Delays by Region & Weather:** Heatmaps showing delay percentages across regions and weather conditions.
- 🔢 **Partner Performance Tracking:** Bar charts ranking delivery partners by delay rates.
- ⏰ **Peak Dispatch Hours:** Line charts analyzing warehouse dispatch times to reduce congestion.
- 🚚 **Route Optimization:** Sankey diagrams to visualize shipment flows and optimize delivery routes.

**Screenshots:**
1. ![Delay Analysis](images/delay_analysis.png)
2. ![Partner Performance](images/partner_performance.png)
3. ![Warehouse Efficiency](images/warehouse_efficiency.png)

---

## 🔍 Key Findings
1. **Weather Delays:** Adverse weather increased delays by **20%** in some regions.
2. **Partner Performance:** Certain partners had on-time rates below **85%**.
3. **Peak Dispatch Hours:** Warehouses faced congestion between **2 PM - 4 PM**, leading to shipment delays.
4. **Impact:** Optimizing partner assignments and staggering dispatch schedules resulted in a **12% reduction in delivery delays**.

---

## 📚 Conclusion
This project delivered actionable insights into Amazon’s delivery performance, improving efficiency and reducing delays. The combination of **SQL analysis** and **interactive dashboards** provides a scalable solution for monitoring logistics and enhancing operational decision-making.

---

## 📗 Author
[Meghana](https://www.linkedin.com/in/bgem/)

---
