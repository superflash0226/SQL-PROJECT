# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/superflash0226/Netflix-SQL-Project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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

```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT COUNT(m_type) AS Total_Movies from netflix
WHERE m_type = 'Movie';

SELECT COUNT(m_type) AS Total_TV_Shows from netflix
WHERE m_type = 'TV Show';

SELECT m_type, COUNT(*) AS Total FROM netflix
GROUP BY m_type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT 
	m_type,
	rating
FROM

(SELECT m_type, rating, COUNT(*), RANK() OVER(PARTITION BY m_type ORDER BY COUNT(*) DESC) from netflix
GROUP BY 1, 2
ORDER BY 1, 3 DESC) AS rating_tank
WHERE rank = '1';
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * FROM netflix
WHERE release_year = '2020'
AND m_type = 'Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT * FROM netflix

SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS new_country, COUNT(show_id),
	   RANK() OVER(PARTITION BY UNNEST(STRING_TO_ARRAY(country,',')) ORDER BY COUNT(show_id) DESC)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * FROM netflix

SELECT * FROM netflix
WHERE m_type ='Movie'
AND duration = (SELECT MAX(duration) FROM netflix)
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * FROM netflix;

SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * FROM netflix

SELECT * FROM netflix
WHERE duration >= '5 Season'
AND m_type = 'TV Show'
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT * FROM netflix;

SELECT UNNEST (STRING_TO_ARRAY(listed_in, ',')),
	   COUNT(show_id) FROM netflix
GROUP BY 1
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT * FROM netflix

SELECT release_year, country FROM netflix
WHERE country ILIKE '%INDIA%'
ORDER BY 1 ASC
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * FROM netflix

SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * FROM netflix

SELECT * FROM netflix
WHERE director IS NULL
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * FROM netflix

SELECT * FROM netflix
WHERE 
	m_cast ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT * FROM netflix     

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

