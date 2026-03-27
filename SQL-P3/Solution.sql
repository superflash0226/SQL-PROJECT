-- Project Netflix
-- Creating the table

CREATE TABLE netflix(

		show_id	VARCHAR(10),
		m_type	VARCHAR(20),
		title	VARCHAR(105),
		director	VARCHAR(210),
		m_cast	VARCHAR(800),
		country	VARCHAR(124),
		date_added	VARCHAR(50),
		release_year INT,
		rating	VARCHAR(20),
		duration	VARCHAR(20),
		listed_in	VARCHAR(90),
		description VARCHAR(260)

);

SELECT * FROM netflix;

SELECT * FROM netflix
WHERE   show_id	IS NULL
		OR
		m_type	IS NULL
		OR
		title	IS NULL
		OR
		director IS NULL
		OR
		m_cast	IS NULL
		OR
		country	IS NULL
		OR
		date_added	IS NULL
		OR
		release_year IS NULL
		OR
		rating	IS NULL
		OR
		duration IS NULL
		OR
		listed_in IS NULL
		OR
		description IS NULL;

SELECT DISTINCT(m_type) FROM netflix;

SELECT DISTINCT(country) FROM netflix;

-- Business Problems

-- Count numbers of movies VS TV shows
SELECT COUNT(m_type) AS Total_Movies from netflix
WHERE m_type = 'Movie';

SELECT COUNT(m_type) AS Total_TV_Shows from netflix
WHERE m_type = 'TV Show';

SELECT m_type, COUNT(*) AS Total FROM netflix
GROUP BY m_type;

-- Find the most common rating for movies and TV Shows
SELECT 
	m_type,
	rating
FROM

(SELECT m_type, rating, COUNT(*), RANK() OVER(PARTITION BY m_type ORDER BY COUNT(*) DESC) from netflix
GROUP BY 1, 2
ORDER BY 1, 3 DESC) AS rating_tank
WHERE rank = '1';

-- List all the movies released in a specific year (e.g, 2020)
SELECT * FROM netflix
WHERE release_year = '2020'
AND m_type = 'Movie';

-- Find the top 5 countries with the most content on netflix
SELECT * FROM netflix

SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS new_country, COUNT(show_id),
	   RANK() OVER(PARTITION BY UNNEST(STRING_TO_ARRAY(country,',')) ORDER BY COUNT(show_id) DESC)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC

-- Identify the longest movie or TV show duration

SELECT * FROM netflix

SELECT * FROM netflix
WHERE m_type ='Movie'
AND duration = (SELECT MAX(duration) FROM netflix)

-- Find the content added in last 5 years
SELECT * FROM netflix;

SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT * FROM netflix

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

--List all TV shows with more than 5 season
SELECT * FROM netflix

SELECT * FROM netflix
WHERE duration >= '5 Season'
AND m_type = 'TV Show'

-- Count the number of content 	items in each genre
SELECT * FROM netflix;

SELECT UNNEST (STRING_TO_ARRAY(listed_in, ',')),
	   COUNT(show_id) FROM netflix
GROUP BY 1

-- Find each year and the average number of content release by INDIA n netflix
-- return top 5 year with highest avg content realse

SELECT * FROM netflix

SELECT release_year, country FROM netflix
WHERE country ILIKE '%INDIA%'
ORDER BY 1 ASC

-- List all the movies that are documentaries
SELECT * FROM netflix

SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%'

-- Find all content without a director
SELECT * FROM netflix

SELECT * FROM netflix
WHERE director IS NULL

-- Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix

SELECT * FROM netflix
WHERE 
	m_cast ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT * FROM netflix     

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT * FROM netflix

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;