use final_project;
select *
from global_bleaching_env;


-- Order table by year
SELECT * 
FROM global_bleaching_env
ORDER BY year ASC;

-- Number of bleaching events per year, ordered by descending values
SELECT YEAR(date) AS year, COUNT(*) AS num_bleaching_events
FROM global_bleaching_env
WHERE percent_bleaching > 0
GROUP BY YEAR(date)
ORDER BY num_bleaching_events DESC;

-- Average total area covered by substrate name for each ocean
CREATE VIEW substrate_cover_view AS
SELECT 
    gbe.substrate_name, 
    ocean.ocean,
    ROUND(AVG(gbe.percent_cover), 2) AS total_area_covered
FROM 
    global_bleaching_env gbe
JOIN 
    ocean ON gbe.ocean_id = ocean.ocean_id
GROUP BY 
    gbe.substrate_name, ocean.ocean;
    
SELECT * 
FROM substrate_cover_view
ORDER BY ocean;


-- Bleaching status per substrate name
SELECT 
    gbe.substrate_name,
    bs.bleaching_status,
    COUNT(*) AS count
FROM 
    global_bleaching_env gbe
JOIN 
    bleaching_status bs ON gbe.bleaching_status_id = bs.bleaching_status_id
GROUP BY 
    gbe.substrate_name, bs.bleaching_status;


-- Selecting all info for Australia
SELECT 
    gbe.*,
    c.country
FROM 
    global_bleaching_env gbe
JOIN 
    country c ON gbe.country_id = c.country_id
WHERE 
    c.country = 'Australia';

-- Selecting all for year = 2016
SELECT *
FROM global_bleaching_env
WHERE YEAR(date) = 2016;

-- Top countries with highest percent_bleaching in 2016
SELECT 
    YEAR(gbe.date) AS bleaching_year,
    c.country,
    MAX(gbe.percent_bleaching) AS max_percent_bleaching
FROM 
    global_bleaching_env gbe
JOIN 
    country c ON gbe.country_id = c.country_id
WHERE 
    YEAR(gbe.date) = 2016
GROUP BY 
    YEAR(gbe.date), c.country
ORDER BY 
    max_percent_bleaching DESC;
    
    
-- Let's create a view to use it for each year
CREATE VIEW bleaching_max_percent_view AS
SELECT 
    YEAR(gbe.date) AS bleaching_year,
    c.country,
    MAX(gbe.percent_bleaching) AS max_percent_bleaching
FROM 
    global_bleaching_env gbe
JOIN 
    country c ON gbe.country_id = c.country_id
GROUP BY 
    YEAR(gbe.date), c.country;


SELECT * FROM bleaching_max_percent_view;


-- distance to shore and percent_bleaching
-- turbidy and percent_bleaching
-- 


