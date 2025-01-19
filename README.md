# Netflix Movies and T.V Shows Data analysis using SQL

![icons8-netflix-desktop-app-94](https://github.com/user-attachments/assets/1d9b8f1f-09c9-44ec-83b6-8e96c8a8bc5e)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
    Analyze the distribution of content types (movies vs TV shows).
    Identify the most common ratings for movies and TV shows.
    List and analyze content based on release years, countries, and durations.
    Explore and categorize content based on specific criteria and keywords.
    
## Dataset
The data for this project is sourced from the Kaggle dataset:

## Dataset Link: [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

## Business Problems and Solutions
1. Count the Number of Movies vs TV Shows
[SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20%0A%20%20%20%20type%2C%0A%20%20%20%20COUNT(*)%0AFROM%20netflix%0AGROUP%20BY%201%3B)
Objective: Determine the distribution of content types on Netflix.

2. Find the Most Common Rating for Movies and TV Shows
[WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=WITH%20RatingCounts%20AS,%3D%201%3B)
Objective: Identify the most frequently occurring rating for each type of content.

3. List All Movies Released in a Specific Year (e.g., 2020)
[SELECT * 
FROM netflix
WHERE release_year = 2020;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%20%0AFROM%20netflix%0AWHERE%20release_year%20%3D%202020%3B)

4. Find the Top 5 Countries with the Most Content on Netflix
[SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%20%0AFROM%0A(%0A%20%20%20%20SELECT%20%0A%20%20%20%20%20%20%20%20UNNEST(STRING_TO_ARRAY(country%2C%20%27%2C%27))%20AS%20country%2C%0A%20%20%20%20%20%20%20%20COUNT(*)%20AS%20total_content%0A%20%20%20%20FROM%20netflix%0A%20%20%20%20GROUP%20BY%201%0A)%20AS%20t1%0AWHERE%20country%20IS%20NOT%20NULL%0AORDER%20BY%20total_content%20DESC%0ALIMIT%205%3B)
Objective: Identify the top 5 countries with the highest number of content items.

5. Identify the Longest Movie
[SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
Objective: Find the movie with the longest duration.
](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20%0A%20%20%20%20*%0AFROM%20netflix%0AWHERE%20type%20%3D%20%27Movie%27%0AORDER%20BY%20SPLIT_PART(duration%2C%20%27%20%27%2C%201)%3A%3AINT%20DESC%3B)

6. Find Content Added in the Last 5 Years
[SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%0AFROM%20netflix%0AWHERE%20TO_DATE(date_added%2C%20%27Month%20DD%2C%20YYYY%27)%20%3E%3D%20CURRENT_DATE%20%2D%20INTERVAL%20%275%20years%27%3B)
Objective: Retrieve content added to Netflix in the last 5 years.

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
[SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%0AFROM%20(%0A%20%20%20%20SELECT%20%0A%20%20%20%20%20%20%20%20*%2C%0A%20%20%20%20%20%20%20%20UNNEST(STRING_TO_ARRAY(director%2C%20%27%2C%27))%20AS%20director_name%0A%20%20%20%20FROM%20netflix%0A)%20AS%20t%0AWHERE%20director_name%20%3D%20%27Rajiv%20Chilaka%27%3B)
Objective: List all content directed by 'Rajiv Chilaka'.

8. List All TV Shows with More Than 5 Seasons
[SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%0AFROM%20netflix%0AWHERE%20type%20%3D%20%27TV%20Show%27%0A%20%20AND%20SPLIT_PART(duration%2C%20%27%20%27%2C%201)%3A%3AINT%20%3E%205%3B)
Objective: Identify TV shows with more than 5 seasons.

9. Count the Number of Content Items in Each Genre
[SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20%0A%20%20%20%20UNNEST(STRING_TO_ARRAY(listed_in%2C%20%27%2C%27))%20AS%20genre%2C%0A%20%20%20%20COUNT(*)%20AS%20total_content%0AFROM%20netflix%0AGROUP%20BY%201%3B)
Objective: Count the number of content items in each genre.

10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!

[SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20%0A%20%20%20%20country%2C%0A%20%20%20%20release_year,LIMIT%205%3B)
Objective: Calculate and rank years by the average number of content releases by India.

11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
Objective: Retrieve all movies classified as documentaries.

12. Find All Content Without a Director
[SELECT * 
FROM netflix
WHERE director IS NULL;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%20%0AFROM%20netflix%0AWHERE%20director%20IS%20NULL%3B)
Objective: List content that does not have a director.

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
[FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20*%20%0AFROM%20netflix%0AWHERE%20casts%20LIKE%20%27%25Salman%20Khan%25%27%0A%20%20AND%20release_year%20%3E%20EXTRACT(YEAR%20FROM%20CURRENT_DATE)%20%2D%2010%3B)
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
[SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file#1-count-the-number-of-movies-vs-tv-shows:~:text=SELECT%20%0A%20%20%20%20UNNEST(STRING_TO_ARRAY(casts%2C%20%27%2C%27))%20AS%20actor%2C%0A%20%20%20%20COUNT(*)%0AFROM%20netflix%0AWHERE%20country%20%3D%20%27India%27%0AGROUP%20BY%20actor%0AORDER%20BY%20COUNT(*)%20DESC%0ALIMIT%2010%3B)
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
[SELECT 
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
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
