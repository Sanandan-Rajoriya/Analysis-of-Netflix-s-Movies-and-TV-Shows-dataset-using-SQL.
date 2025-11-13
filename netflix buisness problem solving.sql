
-- Netflix Project 

	Create table netflix (
	show_id varchar(7),
	type varchar(10),
	title varchar(150),
	director varchar(210),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year int,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
)

select * from netflix ;

select count(*) as total_content from netflix ;

select distinct type from netflix ;

select * from netflix ;

-- count the number of movies vs TV shows ----------------------------

select type, count(*) from netflix group by type ;

-- find the most common rating for movies and tv shows -----------------------

select type,rating
from
(select 
type,
rating,
count(*),rank() over(partition by type order by count(*) desc)
as ranking
from netflix
group by type,rating) as common_ranking
where ranking=1 ;






-- list all movies released in a specific year (eg 2021) ------------------------

select title,type,release_year from netflix where type = 'Movie' and release_year = '2021' ;

-- find the top 5 countries with the most content on netflix -------------------

select unnest(string_to_array(country,',')) as new_country,count(*) as top_count from netflix group by new_country
order by top_count desc limit 5 ;
	

-- identify the longest movie  -----------------

select * from netflix where type = 'Movie' and duration = (select max(duration) from netflix);

-- find the content added in the last 5 years ----------------------

select * from netflix where to_date(date_added,'month dd ,yyyy') >= current_date - interval '5 years' ;

-- find all the movies/tv shows by director 'rajiv chilaka' --------------------

select * from netflix where director ilike '%Rajiv Chilaka%' ;

-- list all tv shows with more than 5 season ---------------------

select * from netflix where split_part(duration,' ',1)::numeric > 5 and type ilike '%tv show%' ;

-- count the number of content item in each genre ---------------

select unnest(string_to_array(listed_in,',')) as new_genre,count(*) from netflix group by new_genre ;

-- find each year and the average number of content release by india on netflix return top 5 year with
-- highest average content release 

	select extract(year from to_date(date_added,'month dd,yyyy')) as date ,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric*100,2) as content_per_year
	from netflix where country = 'India' group by date ;

-- list all the movies and Tv Shows that are documentaries --------------------

select * from netflix where listed_in ilike ('%documentaries%');

-- find all the content without a director 

select * from netflix where director is null ;

-- find in how many movies salman khan appeared in the last 10 year

SELECT * FROM netflix
WHERE casts ILIKE '%salman khan%' 
  AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years' ;

-- find the top 10 actors who have appeared in the highest number of movies produced in india

select unnest(string_to_array(casts,',')) as actors ,
count(*) as total_content from netflix 
where country ilike ('%india%') group by actors order by 2 desc limit 10 ;

-- categorize the content based on the presence of the keywords 'kill' and 'violence' in the description 
-- field. label content containing these keywords as 'bad' and all other content as 'good'. count how many
-- items fall into each category 

with Content_Type as(
select *,
		case when description ilike '%kill%' or description ilike '%violence%' then 'Bad Content'
		else 'Good Content' 
		end as category from netflix
)
select category , count(*) as total_content from Content_Type group by category ;

