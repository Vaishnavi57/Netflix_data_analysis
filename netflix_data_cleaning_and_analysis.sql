SELECT * FROM dbo.netflix_raw WHERE concat(title,type) IN (SELECT concat(title,type) FROM dbo.netflix_raw GROUP BY title,type HAVING COUNT(*)>1) ORDER BY title;



with cte as(select *,ROW_NUMBER() OVER(partition by title,type ORDER BY show_id) AS rn FROM dbo.netflix_raw)
SELECT show_id,type,
cast(date_added as date) as date_added,
release_year,rating,
CASE WHEN duration is null THEN rating ELSE duration end as duration,
description INTO netflix FROM cte 

select * from netflix

select show_id,trim(value) as director 
into netflix_directors
from dbo.netflix_raw
cross apply string_split(director,',')

select show_id,trim(value) as genre
into netflix_genre
from dbo.netflix_raw
cross apply string_split(listed_in,',')
select * from netflix_genre order by show_id


select * from netflix_country WHERE show_id='s1001';

insert into netflix_country
SELECT show_id,m.country FROM netflix_raw nr 
inner join (
select director, country from netflix_country nc 
inner join netflix_directors nd on nc.show_id=nd.show_id
GROUP BY director,country
)m on nr.director=m.director
where nr.country is null


select * from netflix_raw where duration is null

--QUERIES:

--HOW MANY MOVIES AND TV SHOWS ARE DIRECTED BY EACH DIRECTOR (CONSIDER ONLY DIRECTORS WHO HAVE DIRECTED BOTH MOVIES AND TV SHOWS)
with cte as (select n.show_id, n.type,nd.director FROM netflix n inner join netflix_directors nd on n.show_id=nd.show_id ),
cte2 as (select distinct director,type from cte  ),
cte3 as (select director,count(type) as types from cte2 group by director having count(type)>1)
select c.director,count(n.type) as movies_total,n.type FROM cte n JOIN cte3 c ON c.director=n.director AND n.type='MOVIE' GROUP BY c.director,n.type
UNION ALL
select c.director,count(n.type) as movies_total,n.type FROM cte n JOIN cte3 c ON c.director=n.director AND n.type='TV SHOW' GROUP BY c.director,n.type ORDER BY c.director,n.type

--WHICH COUNTRY HAS HIGHEST NUMBER OF COMEDIES
WITH cte as (select c.show_id,c.country,g.genre from netflix_genre g INNER JOIN netflix_country c ON g.show_id=c.show_id where genre='comedies' )
SELECT TOP 1 country, COUNT(country) as comedies FROM cte inner join netflix n on cte.show_id=n.show_id and n.type='movie'  
GROUP BY country 
ORDER BY comedies DESC

--WHICH DIRECTOR HAS THE MAXIMUM NUMBER OF MOVIES RELEASED IN EACH YEAR(IF MULTIPLE DIRECTORS 1ST ONE IN ASCENDING ORDER OF DIRECTOR'S NAME)
with cte as (select n.show_id,year(n.date_added) as year_date,d.director 
from netflix n inner join netflix_directors d 
on n.show_id=d.show_id and n.type='movie' 
),
cte2 as (select count(show_id) as movies_year,year_date,director from cte group by director,year_date),
cte3 as (select *, row_number() over(partition by year_date order by movies_year desc,director) as rn from cte2 ) 
select director,year_date,movies_year from cte3 where rn=1

--LIST AVERAGE DURATION OF MOVIES IN EACH GENRE WITH CTES
with cte as (select g.show_id,g.genre,replace(n.duration,' MIN','') as duration_int from netflix_genre g inner join netflix n on g.show_id=n.show_id where n.type='movie'),
cte2 as (select genre,show_id,cast(duration_int as int)as duration from cte )
select genre,AVG(duration) AS average_duration FROM cte2 GROUP BY genre order by average_duration

--LIST AVERAGE DURATION OF MOVIES IN EACH GENRE
select g.genre,AVG(cast(replace(n.duration,' MIN','') as int)) as average_duration from netflix_genre g inner join netflix n on g.show_id=n.show_id where n.type='movie' 
GROUP By genre order by average_duration


--LIST OF DIRECTORS WHO HAVE CREATED BOTH HORROR AND COMEDY MOVIES
with cte as (select g.show_id,d.director,g.genre from netflix_genre g inner join netflix_directors d on g.show_id=d.show_id 
where g.genre='Horror Movies' OR g.genre='Comedies' )
select director from cte group by director having count(distinct genre)>1




