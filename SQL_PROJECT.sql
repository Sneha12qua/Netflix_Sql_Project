Create TAble Netflix
(
show_id	Varchar(6),
type	Varchar(10),
title	Varchar(150),
director Varchar(208),	
casts	Varchar(1000),
country Varchar(150),
date_added	Varchar(50),
release_year Int,	
rating Varchar(10),	
duration Varchar(15),	
listed_in	Varchar(150),
description Varchar(250)
);

select * from Netflix;

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

Select
Type,
Count(*) as Total_content
From netflix
Group by Type


--2. Find the most common rating for movies and TV shows

Select
	Type,
	Rating
From
(
Select
	Type,
	Rating,
	Count(*),
	Rank() over(partition by type order by count (*) Desc) as ranking
	From Netflix
	Group by 1,2
) as T1
where
	Ranking = 1

3. List all movies released in a specific year (e.g., 2020)

Select * from Netflix
Where
	Type = 'Movie'
	And
	RElease_year = 2020
	

4. Find the top 5 countries with the most content on Netflix

Select
	Unnest(String_to_array(Country, ','))as new_country,
	Count(show_id)as total_content
From Netflix
Group By 1
Order by 2 Desc
Limit 5


5. Identify the longest movie

Select * from Netflix
Where
	Type = 'Movie'
	And
Duration = (Select Max(Duration) from Netflix)


6. Find content added in the last 5 years
Select
*
From Netflix
	Where
	to_date(Date_added, 'Month DD, YYYY') >= Current_date - interval '5 year'
	
	Select Current_date - interval '5 years'

	
7. Find all the movies/TV shows by director 'Rajiv Chilaka'

Select* from Netflix
Where director like '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons

Select
*
from Netflix
Where 
	Type = 'T.V Show'
	And
	Split_part(duration, '', 1)::numeric > 5

9. Count the number of content items in each genre

Select
	unnest(String_to_array(Listed_in, ',')) as genre,
	Count(show_id)as total_content
From Netflix
Group by 1


10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!

Select
	Extract(Year from To_date(date_added, 'Month DD, YYYY')) as year,
	Count (*) as yearly_content,
	Round(
	Count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100,2) as avg_content_per_year
	From Netflix
	Where Country = 'India'
	Group by 1
	

11. List all movies that are documentaries

Select from Netflix
	where
	listed_in Ilike '%documentaries%'

12. Find all content without a director

Select * from Netflix
where 
	director is Null
	
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

Select * from Netflix
	where 
	Casts Ilike '%Salman Khan%'
	And
	release_year > Extract(year from current_date) - 10
	
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

Select
	--show_id,
	--Casts,
	Unnest(string_to_array(casts, ',')) as actors,
	Count(*) as total_content
From Netflix
Where country Ilike '%India%'
Group by 1
Order by 2 Desc
Limit 10


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

With New_table
As
(
Select
*,
	Case
	When
	Description Ilike '%Kill%'
	Or
	Description Ilike '%Violence%' Then 'Bad_content'
	Else 'Good_Content'
	End category
From Netflix
)
Select
	Category,
	Count(*) as Total_content
	From New_table
	Group by 1


