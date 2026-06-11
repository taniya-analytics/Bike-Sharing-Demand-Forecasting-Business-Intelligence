CREATE DATABASE bike_sharing_analysis;
USE bike_sharing_db;


ALTER TABLE cleaned_capital_bike_share
ADD COLUMN revenue DECIMAL(10,2);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN operating_cost DECIMAL(10,2);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN profit DECIMAL(10,2);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN demand_level VARCHAR(20);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN rider_type VARCHAR(30);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN loyalty_ratio DECIMAL(5,2);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN weather_label VARCHAR(30);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN day_category VARCHAR(20);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN month_name VARCHAR(20);

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN quarter_name VARCHAR(10);

-- UPDATE REVENUE
SET SQL_SAFE_UPDATES = 0;
UPDATE cleaned_capital_bike_share
SET revenue =
(casual_users * 100) +
(registered_users * 60);
-- UPDATE OPERATING COST
UPDATE cleaned_capital_bike_share
SET operating_cost = 20000;
-- UPDATE PROFIT
UPDATE cleaned_capital_bike_share
SET profit = revenue - operating_cost;
-- UPDATE DEMAND LEVEL
UPDATE cleaned_capital_bike_share
SET demand_level =
CASE
    WHEN total_users < 1000 THEN 'Low Demand'
    WHEN total_users BETWEEN 1000 AND 5000 THEN 'Medium Demand'
    ELSE 'High Demand'
END;
-- UPDATE RIDER TYPE
UPDATE cleaned_capital_bike_share
SET rider_type =
CASE
    WHEN is_weekday = 'YES'
    THEN 'Commuter Riders'
    ELSE 'Leisure Riders'
END;


-- UPDATE LOYALTY RATIO

UPDATE cleaned_capital_bike_share
SET loyalty_ratio =
ROUND((registered_users / total_users) * 100, 2);

-- UPDATE WEATHER LABEL

UPDATE cleaned_capital_bike_share
SET weather_label =
CASE
    WHEN weather_situation = 1 THEN 'Clear Weather'
    WHEN weather_situation = 2 THEN 'Cloudy Weather'
    WHEN weather_situation = 3 THEN 'Rainy Weather'
    ELSE 'Extreme Weather'
END;

-- UPDATE DAY CATEGORY

UPDATE cleaned_capital_bike_share
SET day_category =
CASE
    WHEN is_weekday = 'YES'
    THEN 'Weekday'
    ELSE 'Weekend'
END;

-- UPDATE MONTH NAME

DESCRIBE cleaned_capital_bike_share;

UPDATE cleaned_capital_bike_share
SET month_name = MONTHNAME(ï»¿date);

-- UPDATE QUARTER NAME

UPDATE cleaned_capital_bike_share
SET quarter_name =
CASE
    WHEN MONTH(ï»¿date) BETWEEN 1 AND 3 THEN 'Q1'
    WHEN MONTH(ï»¿date) BETWEEN 4 AND 6 THEN 'Q2'
    WHEN MONTH(ï»¿date) BETWEEN 7 AND 9 THEN 'Q3'
    ELSE 'Q4'
END;


-- FINAL CHECK

SELECT *
FROM cleaned_capital_bike_share
LIMIT 20;



USE bike_sharing_db;

-- KPI ANALYSIS FOR BIKE SHARING PROJECT

-- 1. TOTAL REVENUE
SELECT
ROUND(SUM(revenue),2) AS total_revenue
FROM cleaned_capital_bike_share;

-- 2. TOTAL PROFIT
SELECT
ROUND(SUM(profit),2) AS total_profit
FROM cleaned_capital_bike_share;

-- 3. AVERAGE DAILY USERS
SELECT
ROUND(AVG(total_users),2) AS avg_daily_users
FROM cleaned_capital_bike_share;

-- 4. TOTAL CASUAL VS REGISTERED USERS
SELECT
SUM(casual_users) AS total_casual_users,
SUM(registered_users) AS total_registered_users
FROM cleaned_capital_bike_share;

-- 5. BEST PERFORMING SEASON
DESCRIBE cleaned_capital_bike_share;

ALTER TABLE cleaned_capital_bike_share
ADD COLUMN season_name VARCHAR(20);

UPDATE cleaned_capital_bike_share
SET season_name =
CASE
    WHEN month_name IN ('December','January','February')
    THEN 'Winter'
    
    WHEN month_name IN ('March','April','May')
    THEN 'Spring'
    
    WHEN month_name IN ('June','July','August')
    THEN 'Summer'
    
    ELSE 'Fall'
END;

SELECT
season_name,
SUM(revenue) AS total_revenue
FROM cleaned_capital_bike_share
GROUP BY season_name
ORDER BY total_revenue DESC;

-- 6. MOST PROFITABLE QUARTER
SELECT
quarter_name,
SUM(profit) AS total_profit
FROM cleaned_capital_bike_share
GROUP BY quarter_name
ORDER BY total_profit DESC;

-- 7. MONTHLY REVENUE TREND
SELECT
month_name,
SUM(revenue) AS monthly_revenue
FROM cleaned_capital_bike_share
GROUP BY month_name
ORDER BY monthly_revenue DESC;


-- 8. WEATHER IMPACT ANALYSIS
SELECT
weather_label,
ROUND(AVG(total_users),2) AS avg_users
FROM cleaned_capital_bike_share
GROUP BY weather_label
ORDER BY avg_users DESC;

-- 9. WEEKDAY VS WEEKEND ANALYSIS
SELECT
day_category,
ROUND(AVG(total_users),2) AS avg_users,
ROUND(SUM(revenue),2) AS total_revenue
FROM cleaned_capital_bike_share
GROUP BY day_category;

-- 10. DEMAND LEVEL ANALYSIS
SELECT
demand_level,
COUNT(*) AS total_days,
ROUND(AVG(total_users),2) AS avg_users
FROM cleaned_capital_bike_share
GROUP BY demand_level;


-- 11. CUSTOMER LOYALTY ANALYSIS
SELECT
ROUND(AVG(loyalty_ratio),2) AS avg_loyalty_ratio
FROM cleaned_capital_bike_share;

-- 12. TOP 10 HIGHEST REVENUE DAYS
SELECT
ï»¿date,
day_name,
revenue
FROM cleaned_capital_bike_share
ORDER BY revenue DESC
LIMIT 10;

-- 13. TOP 10 MOST PROFITABLE DAYS
SELECT
ï»¿date,
day_name,
profit
FROM cleaned_capital_bike_share
ORDER BY profit DESC
LIMIT 10;


USE bike_sharing_db;

-- ADVANCED SQL ANALYSIS

-- 1. DAILY REVENUE RANKING
SELECT
ï»¿date,
revenue,

RANK() OVER(
ORDER BY revenue DESC
) AS revenue_rank

FROM cleaned_capital_bike_share;

-- 2. DAILY PROFIT RANKING

SELECT
ï»¿date,
profit,

DENSE_RANK() OVER(
ORDER BY profit DESC
) AS profit_rank

FROM cleaned_capital_bike_share;


-- 3. ROW NUMBER ANALYSIS
SELECT
ROW_NUMBER() OVER(
ORDER BY total_users DESC
) AS row_num,

ï»¿date,
total_users

FROM cleaned_capital_bike_share;

-- 4. PREVIOUS DAY USERS (LAG)
SELECT
ï»¿date,
total_users,

LAG(total_users)
OVER(ORDER BY ï»¿date) AS previous_day_users

FROM cleaned_capital_bike_share;


-- 5. NEXT DAY USERS (LEAD)
SELECT
ï»¿date,
total_users,

LEAD(total_users)
OVER(ORDER BY ï»¿date) AS next_day_users

FROM cleaned_capital_bike_share;

-- 6. DAILY USER GROWTH %
SELECT
ï»¿date,
total_users,

LAG(total_users)
OVER(ORDER BY ï»¿date) AS previous_day_users,

ROUND(
(
(total_users -
LAG(total_users)
OVER(ORDER BY ï»¿date))
/
LAG(total_users)
OVER(ORDER BY ï»¿date)
) * 100,
2
) AS growth_percentage

FROM cleaned_capital_bike_share;


-- 7. 7-DAY ROLLING AVERAGE USERS
SELECT
ï»¿date,
total_users,

ROUND(
AVG(total_users)
OVER(
ORDER BY ï»¿date
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
),
2
) AS rolling_avg_7_days

FROM cleaned_capital_bike_share;

-- 8. CUMULATIVE REVENUE
SELECT
ï»¿date,
revenue,

SUM(revenue)
OVER(
ORDER BY ï»¿date
) AS cumulative_revenue

FROM cleaned_capital_bike_share;

-- 9. CUMULATIVE PROFIT
SELECT
ï»¿date,
profit,

SUM(profit)
OVER(
ORDER BY ï»¿date
) AS cumulative_profit

FROM cleaned_capital_bike_share;

-- 10. MONTHLY REVENUE RANKING
SELECT
month_name,

SUM(revenue) AS total_revenue,

RANK() OVER(
ORDER BY SUM(revenue) DESC
) AS revenue_rank

FROM cleaned_capital_bike_share
GROUP BY month_name;

-- 11. WEATHER IMPACT RANKING
SELECT
weather_label,

AVG(total_users) AS avg_users,

RANK() OVER(
ORDER BY AVG(total_users) DESC
) AS weather_rank

FROM cleaned_capital_bike_share
GROUP BY weather_label;

-- 12. CTE MONTHLY SUMMARY

WITH monthly_summary AS (

SELECT
month_name,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,
AVG(total_users) AS avg_users

FROM cleaned_capital_bike_share
GROUP BY month_name

)

SELECT *
FROM monthly_summary
ORDER BY total_revenue DESC;

-- 13. HIGH DEMAND DAYS
WITH high_demand_days AS (

SELECT
ï»¿date,
day_name,
total_users,
demand_level

FROM cleaned_capital_bike_share
WHERE demand_level = 'High Demand'

)

SELECT *
FROM high_demand_days
ORDER BY total_users DESC;

-- 14. TOP 5 MOST PROFITABLE DAYS
SELECT *
FROM (

SELECT
ï»¿date,
profit,

ROW_NUMBER() OVER(
ORDER BY profit DESC
) AS row_num

FROM cleaned_capital_bike_share

) ranked_profit

WHERE row_num <= 5;

-- 15. QUARTERLY PROFIT TREND
SELECT
quarter_name,

SUM(profit) AS total_profit,

LAG(SUM(profit))
OVER(ORDER BY quarter_name) AS previous_quarter_profit

FROM cleaned_capital_bike_share
GROUP BY quarter_name;

-- 16. RIDER TYPE PERFORMANCE
SELECT
rider_type,

SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,
AVG(total_users) AS avg_users

FROM cleaned_capital_bike_share
GROUP BY rider_type;


-- 17. MOST CONSISTENT DEMAND DAYS
SELECT
day_name,

ROUND(AVG(total_users),2) AS avg_users,
ROUND(STDDEV(total_users),2) AS demand_variation

FROM cleaned_capital_bike_share
GROUP BY day_name
ORDER BY demand_variation ASC;


-- 18. WEATHER VS PROFITABILITY
SELECT
weather_label,

SUM(profit) AS total_profit,
AVG(profit) AS avg_profit

FROM cleaned_capital_bike_share
GROUP BY weather_label
ORDER BY total_profit DESC;


-- 19. MONTHLY USER GROWTH TREND
SELECT
month_name,

SUM(total_users) AS total_users,

LAG(SUM(total_users))
OVER(ORDER BY SUM(total_users)) AS previous_month_users

FROM cleaned_capital_bike_share
GROUP BY month_name;


-- 20. FINAL DATA CHECK
SELECT *
FROM cleaned_capital_bike_share
LIMIT 20;

-- 14. AVERAGE USERS BY DAY NAME
SELECT
day_name,
ROUND(AVG(total_users),2) AS avg_users
FROM cleaned_capital_bike_share
GROUP BY day_name
ORDER BY avg_users DESC;


-- 15. WEATHER VS REVENUE
SELECT
weather_label,
ROUND(SUM(revenue),2) AS total_revenue
FROM cleaned_capital_bike_share
GROUP BY weather_label
ORDER BY total_revenue DESC;

-- 16. SEASONAL USER TREND
SELECT
season_name,
ROUND(AVG(total_users),2) AS avg_users
FROM cleaned_capital_bike_share
GROUP BY season_name
ORDER BY avg_users DESC;

-- 17. QUARTERLY PROFIT TREND
SELECT
quarter_name,
ROUND(SUM(profit),2) AS total_profit
FROM cleaned_capital_bike_share
GROUP BY quarter_name
ORDER BY total_profit DESC;

-- 18. RIDER TYPE ANALYSIS
SELECT
rider_type,
ROUND(AVG(total_users),2) AS avg_users,
ROUND(SUM(revenue),2) AS total_revenue
FROM cleaned_capital_bike_share
GROUP BY rider_type;


-- 19. HIGHEST DEMAND MONTH
SELECT
month_name,
SUM(total_users) AS total_users
FROM cleaned_capital_bike_share
GROUP BY month_name
ORDER BY total_users DESC
LIMIT 1;


-- 20. LOWEST DEMAND MONTH
SELECT
month_name,
SUM(total_users) AS total_users
FROM cleaned_capital_bike_share
GROUP BY month_name
ORDER BY total_users ASC
LIMIT 1;



USE bike_sharing_db;
-- SQL VIEWS FOR DASHBOARD & ANALYSIS


-- 1. MONTHLY SUMMARY VIEW
CREATE VIEW monthly_summary_view AS

SELECT
month_name,

SUM(total_users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,

ROUND(AVG(total_users),2) AS avg_daily_users,
ROUND(AVG(loyalty_ratio),2) AS avg_loyalty_ratio

FROM cleaned_capital_bike_share
GROUP BY month_name;

-- 2. WEATHER ANALYSIS VIEW
CREATE VIEW weather_analysis_view AS

SELECT
weather_label,

SUM(total_users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,

ROUND(AVG(total_users),2) AS avg_users,
ROUND(AVG(profit),2) AS avg_profit

FROM cleaned_capital_bike_share
GROUP BY weather_label;


-- 3. RIDER TYPE PERFORMANCE VIEW

CREATE VIEW rider_type_view AS

SELECT
rider_type,

SUM(total_users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,

ROUND(AVG(total_users),2) AS avg_users

FROM cleaned_capital_bike_share
GROUP BY rider_type;



-- 4. DEMAND LEVEL VIEW
CREATE VIEW demand_level_view AS

SELECT
demand_level,

COUNT(*) AS total_days,

SUM(total_users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit

FROM cleaned_capital_bike_share
GROUP BY demand_level;


-- 5. WEEKDAY VS WEEKEND VIEW

CREATE VIEW weekday_weekend_view AS

SELECT
day_category,

SUM(total_users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,

ROUND(AVG(total_users),2) AS avg_users

FROM cleaned_capital_bike_share
GROUP BY day_category;


-- 6. QUARTERLY PERFORMANCE VIEW
CREATE VIEW quarterly_performance_view AS

SELECT
quarter_name,

SUM(total_users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(profit) AS total_profit,

ROUND(AVG(total_users),2) AS avg_users

FROM cleaned_capital_bike_share
GROUP BY quarter_name;


-- 7. TOP PROFIT DAYS VIEW

CREATE VIEW top_profit_days_view AS

SELECT
ï»¿date,
day_name,
revenue,
profit,
total_users

FROM cleaned_capital_bike_share
ORDER BY profit DESC
LIMIT 20;


-- 8. CUSTOMER LOYALTY VIEW
CREATE VIEW customer_loyalty_view AS

SELECT
month_name,

ROUND(AVG(loyalty_ratio),2) AS avg_loyalty_ratio,
SUM(registered_users) AS total_registered_users,
SUM(casual_users) AS total_casual_users

FROM cleaned_capital_bike_share
GROUP BY month_name;


-- 9. DAILY TREND VIEW
CREATE VIEW daily_trend_view AS

SELECT
ï»¿date ,
day_name,
month_name,

total_users,
revenue,
profit,

weather_label,
demand_level

FROM cleaned_capital_bike_share;


-- 10. HIGH DEMAND ANALYSIS VIEW

CREATE VIEW high_demand_view AS

SELECT
ï»¿date,
day_name,
month_name,

total_users,
revenue,
profit

FROM cleaned_capital_bike_share
WHERE demand_level = 'High Demand';


-- CHECK ALL VIEWS


SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';



