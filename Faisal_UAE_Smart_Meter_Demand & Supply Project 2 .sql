-- ================================================
-- UAE Smart Meter Demand & Supply Analysis 2023
-- Analyst: Faisal Mujeeb Abdullah
-- Tool: SQLite
-- ================================================

-- Query 1: Total Consumption by Consumer Type
SELECT Consumer_Type,
       SUM(Consumption_kWh) AS Total_Consumption
FROM smart_meter_data
GROUP BY Consumer_Type
ORDER BY Total_Consumption DESC;

-- Query 2: Average Monthly Bill by Region
SELECT Region,
       AVG(Bill_Amount) AS Avg_Monthly_Bill
FROM smart_meter_data
GROUP BY Region
ORDER BY Avg_Monthly_Bill DESC;

-- Query 3: Top 3 Highest Consuming Meters
SELECT Meter_ID, Region, Consumer_Type,
       SUM(Consumption_kWh) AS Total_Consumption
FROM smart_meter_data
GROUP BY Meter_ID, Region, Consumer_Type
ORDER BY Total_Consumption DESC
LIMIT 3;

-- Query 4: Peak vs Off-Peak Ratio by Consumer Type
SELECT Consumer_Type,
       SUM(Peak_Hour_Usage) AS Total_Peak,
       SUM(OffPeak_Hour_Usage) AS Total_OffPeak,
       ROUND(SUM(Peak_Hour_Usage)/SUM(Consumption_kWh)*100,2) AS Peak_Percentage
FROM smart_meter_data
GROUP BY Consumer_Type
ORDER BY ROUND(SUM(Peak_Hour_Usage)/SUM(Consumption_kWh)*100,2) DESC;

-- Query 5: Meters Above Average Consumption
SELECT Meter_ID, Region, Consumer_Type,
       AVG(Consumption_kWh) AS Avg_Consumption
FROM smart_meter_data
GROUP BY Meter_ID, Region, Consumer_Type
HAVING AVG(Consumption_kWh) > (SELECT AVG(Consumption_kWh) FROM smart_meter_data)
ORDER BY Avg_Consumption DESC;

-- Query 6: Monthly Industrial Consumption Trend
SELECT Month, Meter_ID, Consumer_Type, Consumption_kWh
FROM smart_meter_data
WHERE Consumer_Type = 'Industrial'
ORDER BY Month;

-- Query 7: Total Revenue by Region
SELECT Region,
       SUM(Bill_Amount) AS Total_Revenue,
       COUNT(DISTINCT Meter_ID) AS Total_Meters,
       ROUND(AVG(Bill_Amount),2) AS Avg_Bill
FROM smart_meter_data
GROUP BY Region
ORDER BY Total_Revenue DESC;

-- Query 8: Month Over Month Consumption Change
SELECT Month, Meter_ID, Consumer_Type, Consumption_kWh,
       LAG(Consumption_kWh) OVER (PARTITION BY Meter_ID ORDER BY Month) AS Previous_Month,
       ROUND(Consumption_kWh - LAG(Consumption_kWh) OVER (PARTITION BY Meter_ID ORDER BY Month),2) AS Monthly_Change
FROM smart_meter_data
ORDER BY Meter_ID, Month;