SELECT
  user_name,
  COUNT(DISTINCT active_day) AS active_days_in_july
FROM (
  SELECT
    user_name,
    DATE_ADD(start_date, INTERVAL seq DAY) AS active_day
  FROM (
    SELECT
      a.user_name,
      a.start_date,
      a.end_date,
      b.seq
    FROM risk_table a
    JOIN (
      SELECT 0 AS seq UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
      SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) b ON DATEDIFF(a.end_date, a.start_date) >= b.seq
  ) t
  WHERE MONTH(DATE_ADD(start_date, INTERVAL seq DAY)) = 7
) d
GROUP BY user_name;


WITH RECURSIVE date_range AS (
    SELECT 
        name,
        DATE(STR_TO_DATE(risk_start_date, '%Y%m%d')) AS start_date,
        DATE(STR_TO_DATE(risk_end_date, '%Y%m%d')) AS end_date
    FROM insurance_table
    WHERE 
        name = 'namel' 
        AND STR_TO_DATE(risk_start_date, '%Y%m%d') >= '2025-07-01' 
        AND STR_TO_DATE(risk_start_date, '%Y%m%d') <= '2025-07-31'
),
all_dates AS (
    SELECT 
        name,
        start_date + INTERVAL (n) DAY AS date_value
    FROM date_range
    CROSS JOIN (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
        SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL
        SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL
        SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL
        SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
        SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
    ) AS numbers
    WHERE 
        start_date + INTERVAL (n) DAY <= end_date
        AND start_date + INTERVAL (n) DAY >= '2025-07-01'
        AND start_date + INTERVAL (n) DAY <= '2025-07-31'
)
SELECT 
    name AS 用户名,
    COUNT(DISTINCT date_value) AS 不重复生效日期天数
FROM all_dates
GROUP BY name;