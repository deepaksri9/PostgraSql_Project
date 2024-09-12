select * from netflix

select distinct type from netflix

select 
	count(*) from netflix

-- Count the number of and TV Shows
select type, count(*) as total_Content from netflix
group by type
order by type

-- find the most common rating for movies and TV Shows
select type, rating from 
(
	select 
		type, rating, 
		count(*), 
		Rank() over(PARTITION BY type order by count(*) desc) as ranking
		from netflix
		group by 1,2
		--order by 1,3 desc
) as t1
where ranking =1

-- List all the movies which relase in specific year
select * 	
	from netflix 
	where type='Movie' and release_year=2002


-- Find the top 5 countires with the most content on netflix
select TRIM(UNNEST(STRING_TO_ARRAY(country,',')))  as Country, count(*) as total_content from netflix
group by 1
order by 2 desc
LIMIT 5

-- identify the longest movie
select title, max(CAST(SUBSTRING(duration,1,POSITION(' ' IN duration)-1)as INT)) as maximun_lenght
from netflix
where type = 'Movie' and duration is not null
group by 1
order by 2 desc

-- find content added in last 5 years
select * from netflix
where TO_DATE(date_added, 'Month DD,yyyy')  >= CURRENT_DATE - INTERVAL '5 years'

-- List all the TV Shows with more than 5 seasons
select * from netflix
where type='TV Show' and SPLIT_PART(duration,' ',1)::numeric  > 5

-- Count the number of content item in each genre
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(LISTED_IN, ','))) AS GENRE,
	COUNT(*) AS TOTAL_CONTENT
FROM
	NETFLIX
GROUP BY
	1 ORDER BY
	1

-- find each year and the average number of content release by india on netflix. return top 5 year with highest 
-- avg content release
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(COUNTRY, ','))) AS COUNTRY,
	COUNT(*) AS TOTAL_COUNT
FROM
	NETFLIX
WHERE
	COUNTRY IS NOT NULL
GROUP BY
	1
ORDER BY
	1

SELECT
	COUNTRY,
	RELEASE_YEAR,
	COUNT(*) AS TOTAL_COUNT
FROM
	NETFLIX
WHERE
	COUNTRY ILIKE '%India%'
GROUP BY
	1,
	2
ORDER BY
	3 DESC
LIMIT
	5

SELECT
	EXTRACT(
		YEAR
		FROM
			TO_DATE(DATE_ADDED, 'Month DD, YYYY')
	) AS YEAR,
	COUNT(*) AS YEAR_CONTENT,
	ROUND(
		(
			COUNT(*)::NUMERIC / (
				SELECT
					COUNT(*)
				FROM
					NETFLIX
				WHERE
					COUNTRY ILIKE '%India%'
			)::NUMERIC * 100
		),
		2
	) AS AVERAGE_CONTENT FROM
	NETFLIX
WHERE
	COUNTRY ILIKE '%India%'
GROUP BY
	1
LIMIT
	5


--Find how many movie actor salman khan appeared in last 10 years
SELECT
	*
FROM
	NETFLIX
WHERE
	RELEASE_YEAR >= EXTRACT(
		YEAR
		FROM
			CURRENT_DATE
	) -10
	AND CASTS ILIKE '%salman khan%'

-- find the top 10 actors who have appered in the highest number of movies product in india
SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(CASTS, ','))) AS ACTOR,
	COUNT(*)
FROM
	NETFLIX
WHERE
	COUNTRY ILIKE '%india%'
GROUP BY
	1
ORDER BY 2 DESC
LIMIT 10

-- Categories the content based on the presence of the keywords 'Kill' and 'voilence' in the description field
-- Label Containt containing these keywords as 'Bad' and all other comments as 'Good'.
-- count how many items falls into these category

--using CTE(Common table Expression)
WITH new_table
as
(
	select *,Case when description ilike '%kill%' or description ilike 'voilence' then 'Bad Content'
	else 'Good Content' end as Catogory from netflix
)

select Catogory , count(*) from new_table
group by 1
order by 1


select description from netflix

