USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT
	COUNT(*) FROM director_mapping;
    /* Number of rows=3867*/
SELECT
    COUNT(*) FROM genre;
	/* Number of rows=14662*/
SELECT
    COUNT(*) FROM movie;
	/* Number of rows=7997*/
SELECT
    COUNT(*) FROM names;
	/* Number of rows=25735*/
SELECT
    COUNT(*) FROM ratings;
	/* Number of rows=7997*/
SELECT
    COUNT(*) FROM role_mapping;
	/* Number of rows=15615*/


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Version 1 through subtraction with count(*)
SELECT 
    COUNT(*) - COUNT(title) AS Null_title,
    COUNT(*) - COUNT(year) AS Null_year,
    COUNT(*) - COUNT(date_published) AS Null_date_published,
    COUNT(*) - COUNT(duration) AS Null_duration,
    COUNT(*) - COUNT(country) AS Null_country,
    COUNT(*) - COUNT(worlwide_gross_income) AS Null_gross_income,
    COUNT(*) - COUNT(languages) AS Null_language,
    COUNT(*) - COUNT(production_company) AS Null_production
FROM
    movie;

-- Version 2 with case statements
SELECT 
    CASE WHEN SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) > 0 THEN 'title' ELSE NULL END AS Null_title,
    CASE WHEN SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) > 0 THEN 'year' ELSE NULL END AS Null_year,
    CASE WHEN SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) > 0 THEN 'date_published' ELSE NULL END AS Null_date_published,
    CASE WHEN SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) > 0 THEN 'duration' ELSE NULL END AS Null_duration,
    CASE WHEN SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) > 0 THEN 'worlwide_gross_income' ELSE NULL END AS Null_gross_income,
    CASE WHEN SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) > 0 THEN 'country' ELSE NULL END AS Null_country,
    CASE WHEN SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) > 0 THEN 'languages' ELSE NULL END AS Null_language,
    CASE WHEN SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) > 0 THEN 'production_company' ELSE NULL END AS Null_production
FROM 
    movie;

/* # Null_title, Null_year, Null_date_published, Null_duration, Null_gross_income, Null_country, Null_language, Null_production
'0', '0', '0', '0', '3724', '20', '194', '528'
Null_title, Null_year, Null_date_published, and Null_duration columns have null values*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

 /* Movies released each year*/
SELECT 
    year AS Year, COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY year
ORDER BY year;

/* Movies released each year
2019	2001
2018	2944
2017	3052
*/

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;
/* month_num, number_of_movies
'1', '804'
'2', '640'
'3', '824'
'4', '680'
'5', '625'
'6', '580'
'7', '493'
'8', '678'
'9', '809'
'10', '801'
'11', '625'
'12', '438'
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    COUNT(*) AS number_of_movies
FROM
    movie
WHERE
    (country LIKE '%India%'
        OR country LIKE '%USA%')
        AND year = 2019;

/* # No_of_movies
'1059' */

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.

Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;
/* genre
'Drama'
'Fantasy'
'Thriller'
'Comedy'
'Horror'
'Family'
'Romance'
'Adventure'
'Action'
'Sci-Fi'
'Crime'
'Mystery'
'Others'*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    g.genre, COUNT(m.title) AS genre_wise_movie_count
FROM
    movie as m
        INNER JOIN
    genre as g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(m.title) DESC; 

/* "Drama" has the highest number of movies. Here is the complete list:
genre,	 genre_wise_movie_count
'Drama', '4285'
'Comedy', '2412'
'Thriller', '1484'
'Action', '1289'
'Horror', '1208'
'Romance', '906'
'Crime', '813'
'Adventure', '591'
'Mystery', '555'
'Sci-Fi', '375'
'Fantasy', '342'
'Family', '302'
'Others', '100'*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT 
    COUNT(movie_id) AS Total_Mov_One_Genre
FROM
    (SELECT 
        movie_id
    FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1) AS Movie_with_only1_genre;

/*# Total_Mov_One_Genre
'3289'*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY genre;

/*# genre, avg_duration
'Drama', '106.77'
'Fantasy', '105.14'
'Thriller', '101.58'
'Comedy', '102.62'
'Horror', '92.72'
'Family', '100.97'
'Romance', '109.53'
'Adventure', '101.87'
'Action', '112.88'
'Sci-Fi', '97.94'
'Crime', '107.05'
'Mystery', '101.80'
'Others', '100.16'*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select * from (
select g.genre, count(m.title) as movie_count,
rank() over(order by count(m.title) desc) as genre_rank
from movie as m inner join genre as g 
on m.id = g.movie_id 
group by g.genre)
Genre_most_movies
where genre = 'Thriller';

/* Thriller genre rank is #3. Here is the table output:
# genre, movie_count, genre_rank
'Thriller', '1484', '3'*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

/*# min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
'1.0', '10.0', '100', '725138', '1', '10'*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 

Though the mean and median are equal, there seem to be outliers in the total votes as there is a 446X jump from 75th percentile value (1625) to the max value(725138).
There is a 6X jump from 95th percentile to 99th percentile.

Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies 
-- (if there are more than one movies at the 10th place, consider them all.)

-- Version 1: with CTE
with avg_movie_ratings as (select m.title, r.avg_rating,
dense_rank() over(order by r.avg_rating desc) as movie_rank 
from movie as m inner join ratings as r 
on m.id = r.movie_id)
select title, avg_rating, movie_rank from avg_movie_ratings where movie_rank<=10;

-- Version 2: with subquery
select title, avg_rating, movie_rank from (select m.title, r.avg_rating,
dense_rank() over(order by r.avg_rating desc) as movie_rank 
from movie as m inner join ratings as r 
on m.id = r.movie_id) as avg_movie_ratings where movie_rank<=10;

/*# title, avg_rating, movie_rank
'Kirket', '10.0', '1'
'Love in Kilnerry', '10.0', '1'
'Gini Helida Kathe', '9.8', '2'
'Runam', '9.7', '3'
'Fan', '9.6', '4'
'Android Kunjappan Version 5.25', '9.6', '4'
'Yeh Suhaagraat Impossible', '9.5', '5'
'Safe', '9.5', '5'
'The Brighton Miracle', '9.5', '5'
'Shibu', '9.4', '6'
'Our Little Haven', '9.4', '6'
'Zana', '9.4', '6'
'Family of Thakurganj', '9.4', '6'
'Ananthu V/S Nusrath', '9.4', '6'*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!

So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/*# median_rating, movie_count
'1', '94'
'2', '119'
'3', '283'
'4', '479'
'5', '985'
'6', '1975'
'7', '2257'
'8', '1030'
'9', '429'
'10', '346'*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production_house
     AS (SELECT m.production_company,
                Count(m.id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(m.id) DESC) AS prod_company_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND m.production_company IS NOT NULL
         GROUP  BY m.production_company
         ORDER  BY prod_company_rank)
SELECT production_company,
       movie_count,
       prod_company_rank
FROM   top_production_house
WHERE  prod_company_rank = 1; 

/* # # production_company, movie_count, prod_company_rank
'Dream Warrior Pictures', '3', '1'
'National Theatre Live', '3', '1' */

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/*Version 1*/
SELECT 
    g.genre, COUNT(m.id) AS movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    MONTH(m.date_published) = 3
        AND YEAR(m.date_published) = 2017
        AND m.country REGEXP 'USA'
        AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;  

/*Version 2*/

select genre, sum(movie_count) as movie_count from (
select g.genre, count(m.id) as movie_count, m.country, r.total_votes 
from genre as g inner join movie as m 
on g.movie_id = m.id
inner join ratings as r 
on m.id = r.movie_id 
where month(m.date_published)=3 and year(m.date_published)=2017 and m.country regexp 'USA' 
group by g.genre, m.country, r.total_votes 
order by movie_count desc) as 
Genre_and_country_wise_ranking
where total_votes>1000
group by genre
order by sum(movie_count) desc;

/* # genre, movie_count
'Drama', '24'
'Comedy', '9'
'Action', '8'
'Thriller', '8'
'Sci-Fi', '7'
'Crime', '6'
'Horror', '6'
'Mystery', '4'
'Romance', '4'
'Fantasy', '3'
'Adventure', '3'
'Family', '1'*/

-- Lets try to analyse with a unique problem statement.

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    title REGEXP '^The' AND r.avg_rating > 8
ORDER BY avg_rating DESC;

/* # title, avg_rating, genre
'The Brighton Miracle', '9.5', 'Drama'
'The Colour of Darkness', '9.1', 'Drama'
'The Blue Elephant 2', '8.8', 'Drama'
'The Blue Elephant 2', '8.8', 'Horror'
'The Blue Elephant 2', '8.8', 'Mystery'
'The Irishman', '8.7', 'Crime'
'The Irishman', '8.7', 'Drama'
'The Mystery of Godliness: The Sequel', '8.5', 'Drama'
'The Gambinos', '8.4', 'Crime'
'The Gambinos', '8.4', 'Drama'
'Theeran Adhigaaram Ondru', '8.3', 'Action'
'Theeran Adhigaaram Ondru', '8.3', 'Crime'
'Theeran Adhigaaram Ondru', '8.3', 'Thriller'
'The King and I', '8.2', 'Drama'
'The King and I', '8.2', 'Romance' */

-- Same movie can have multiple genres.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(m.id) AS Movies_from_April_2018_2019
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8;

-- 361

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- When considering Total votes per movies as per language
with movie_votes as(
select m.languages, sum(r.total_votes) as votes_tally, 
sum(case when languages regexp 'German' then r.total_votes else 0 end) german_votes,
sum(case when languages regexp 'Italian' then r.total_votes else 0 end) italian_votes
from movie as m inner join ratings as r
on m.id=r.movie_id where languages regexp 'German' or languages regexp 'Italian'
group by m.languages)
select sum(german_votes) as total_german_votes,
sum(italian_votes) as total_italian_votes from movie_votes;

/* # total_german_votes, total_italian_votes
'4421525', '2559540'*/

-- When considering Average votes per movies as per language
with movie_votes as(
select m.languages, sum(r.total_votes) as votes_tally, 
avg(case when languages regexp 'German' then r.total_votes else 0 end) german_votes,
avg(case when languages regexp 'Italian' then r.total_votes else 0 end) italian_votes
from movie as m inner join ratings as r
on m.id=r.movie_id where languages regexp 'German' or languages regexp 'Italian'
group by m.languages)
select sum(german_votes) as total_german_votes,
sum(italian_votes) as total_italian_votes 
from movie_votes;

/* # total_german_votes, total_italian_votes
'3268921.3923', '2338864.8087'*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Using case statements
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) known_for_movies_nulls
FROM
    names;

/* # name_nulls, height_nulls, date_of_birth_nulls, known_for_movies_nulls
'0', '17335', '13431', '15226' */


/* There are no Null value in the column 'name'.

The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genres AS (
           SELECT     g.genre,
                      COUNT(mv.id)                            AS genre_movie_count,
                      RANK() OVER (ORDER BY COUNT(mv.id) DESC) AS genre_rank
           FROM       movie AS mv
           INNER JOIN genre AS g
           ON         g.movie_id = mv.id
           INNER JOIN ratings AS rt
           ON         rt.movie_id = mv.id
           WHERE      rt.avg_rating > 8
           GROUP BY   g.genre
           LIMIT      3
)
SELECT     dnames.name         AS director_name,
           COUNT(dm.movie_id)   AS directed_movie_count
FROM       director_mapping AS dm
INNER JOIN genre AS gen
USING      (movie_id)
INNER JOIN names AS dnames
ON         dnames.id = dm.name_id
INNER JOIN top_genres
USING      (genre)
INNER JOIN ratings AS r
USING      (movie_id)
WHERE      r.avg_rating > 8
GROUP BY   dnames.name
ORDER BY   directed_movie_count DESC
LIMIT      3;

/* # director_name, directed_movie_count
'James Mangold', '4'
'Joe Russo', '3'
'Anthony Russo', '3' */

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name, COUNT(r.movie_id) AS movie_count
FROM
    names AS n
        INNER JOIN
    role_mapping AS role ON n.id = role.name_id
        INNER JOIN
    ratings AS r ON role.movie_id = r.movie_id
WHERE
    r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

/* # name, movie_count
'Mammootty', '8'
'Mohanlal', '5' */


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 

RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           Sum(r.total_votes)                            AS vote_count,
           Rank() OVER(ORDER BY Sum(r.total_votes) DESC) AS prod_comp_rank
FROM       movie                                         AS m
INNER JOIN ratings                                       AS r
ON         m.id = r.movie_id
GROUP BY   m.production_company
ORDER BY   vote_count DESC limit 3;

/* # production_company, vote_count, prod_comp_rank
'Marvel Studios', '2656967', '1'
'Twentieth Century Fox', '2411163', '2'
'Warner Bros.', '2396057', '3' */


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actor_name, 
sum(r.total_votes) as total_votes, 
count(m.id) as movie_count, 
round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actor_avg_rating, -- weighted average method to calculate avg_rating
rank() over(order by round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) desc) as actor_rank -- actor ranking by avg rating 
from names as n 
inner join role_mapping as role
on n.id = role.name_id
inner join movie as m
on role.movie_id = m.id
inner join ratings as r
on  m.id = r.movie_id
where m.country regexp 'India' 
	and role.category = 'actor'
group by n.name
	having count(m.id)>=5
order by actor_rank limit 3;

/* # actor_name, total_votes, movie_count, actor_avg_rating, actor_rank
'Vijay Sethupathi', '23114', '5', '8.42', '1'
'Fahadh Faasil', '13557', '5', '7.99', '2'
'Yogi Babu', '8500', '11', '7.83', '3' */


-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actress_name, 
sum(r.total_votes) as total_votes, 
count(m.id) as movie_count, 
round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actress_avg_rating, -- weighted average method to calculate avg_rating
rank() over(order by round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) desc) as actress_rank -- -- actor ranking by avg rating 
from names as n inner join role_mapping as role
on n.id = role.name_id
inner join movie as m
on role.movie_id = m.id
inner join ratings as r
on  m.id = r.movie_id
where m.country regexp 'India' 
	and role.category = 'actress' 
    and m.languages regexp 'Hindi'
group by n.name
	having count(m.id)>=3
order by actress_avg_rating desc limit 5;

/*# actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
'Taapsee Pannu', '18061', '3', '7.74', '1'
'Kriti Sanon', '21967', '3', '7.05', '2'
'Divya Dutta', '8579', '3', '6.88', '3'
'Shraddha Kapoor', '26779', '3', '6.63', '4'
'Kriti Kharbanda', '2549', '3', '4.80', '5' */


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        WHEN r.avg_rating < 5 THEN 'Flop'
    END AS movie_category
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    g.genre = 'Thriller'
        AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;

/* # movie_name, movie_category
'Joker', 'Superhit'
'Andhadhun', 'Superhit'
'Ah-ga-ssi', 'Superhit'
'Contratiempo', 'Superhit'
'Mission: Impossible - Fallout', 'Hit'
'Forushande', 'Hit' */

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
       Round(Avg(m.duration), 2)                      AS avg_duration,
       SUM(Round(Avg(m.duration), 2))
         over(
           ORDER BY g.genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(m.duration), 2))
         over(
           ORDER BY g.genre ROWS unbounded preceding) AS moving_avg_duration
FROM   genre AS g
       inner join movie AS m
               ON g.movie_id = m.id
GROUP  BY g.genre; 

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
SELECT 
    g.genre, COUNT(m.id) AS movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3;

WITH Top_3_genres as  -- Calculating top genres as CTE
(SELECT g.genre, count(m.id) AS movie_count
FROM genre as g INNER JOIN movie AS m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY movie_count DESC LIMIT 3),
No_INR AS            -- Removing currency signs and converting worlwide_gross_income values to decimal from string
(SELECT id,
CASE
WHEN worlwide_gross_income REGEXP 'INR' THEN cast(replace(worlwide_gross_income, 'INR','') as decimal)
WHEN worlwide_gross_income REGEXP '$' THEN cast(replace(worlwide_gross_income, '$','') as decimal) 
end AS worldwide_gross_income FROM movie)
SELECT * from (
SELECT g.genre, m.YEAR, m.title as movie_name, n.worldwide_gross_income, 
ROW_NUMBER() OVER(partition by m.year ORDER BY year, worldwide_gross_income DESC) AS movie_rank -- partitioning by year 
FROM movie AS m inner join genre as g 
on m.id = g.movie_id 
inner join No_INR as n
on m.id=n.id
WHERE genre in (SELECT genre FROM top_3_genres))
final WHERE movie_rank<=5; 

/* # genre, year, movie_name, worldwide_gross_income, movie_rank
'Thriller', '2017', 'The Fate of the Furious', '1236005118', '1'
'Comedy', '2017', 'Despicable Me 3', '1034799409', '2'
'Comedy', '2017', 'Jumanji: Welcome to the Jungle', '962102237', '3'
'Drama', '2017', 'Zhan lang II', '870325439', '4'
'Thriller', '2017', 'Zhan lang II', '870325439', '5' */

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     m.production_company,
           Count(m.id)                                  AS movie_count,
           Row_number() OVER(ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM       movie                                        AS m
INNER JOIN ratings                                      AS r
ON         m.id=r.movie_id
WHERE      r.median_rating>=8
AND        m.languages regexp ','
AND        m.production_company IS NOT NULL
GROUP BY   m.production_company
ORDER BY   movie_count DESC limit 2;

/* # production_company, movie_count, prod_comp_rank
'Star Cinema', '7', '1'
'Twentieth Century Fox', '4', '2' */


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) 
-- in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:


WITH superhit_movies AS
(
           SELECT     m.id,
                      Count(m.id) AS movie_count
           FROM       ratings r
           INNER JOIN movie m
           ON         r.movie_id = m.id
           INNER JOIN genre AS g
           ON         m.id = g.movie_id
           WHERE      r.avg_rating > 8
           AND        genre='Drama'
           GROUP BY   m.id)
SELECT     n.NAME                                                                                                                                            AS actress_name,
           Sum(r.total_votes)                                                                                                                                AS total_votes,
           Count(m.id)                                                                                                                                       AS movie_count,
           Round((Sum(r.avg_rating*r.total_votes))/Sum(r.total_votes),2)                                                                                     AS actress_avg_rating,
           Row_number() OVER(ORDER BY Count(m.id) DESC, Round((Sum(r.avg_rating*r.total_votes))/Sum(r.total_votes),2) DESC, Sum(r.total_votes) DESC, n.NAME) AS actress_rank
FROM       ratings r
INNER JOIN movie m
ON         r.movie_id = m.id
INNER JOIN genre AS g
ON         m.id = g.movie_id
INNER JOIN role_mapping AS rm
ON         m.id = rm.movie_id
INNER JOIN names AS n
ON         rm.name_id = n.id
INNER JOIN superhit_movies AS sm
ON         sm.id = m.id
WHERE      r.avg_rating > 8
AND        g.genre = 'Drama'
AND        rm.category = 'actress'
AND        sm.movie_count IN
           (
                  SELECT sm.movie_count
                  FROM   superhit_movies)
GROUP BY   n.NAME limit 3; 
	
/* # actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
'Amanda Lawrence', '656', '2', '8.94', '1'
'Denise Gough', '656', '2', '8.94', '2'
'Susan Brown', '656', '2', '8.94', '3' */

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

    
WITH movie_diffs AS (
    SELECT
        dm.name_id AS director_id,
        m.date_published,
        lead(m.date_published,1) OVER (PARTITION BY dm.name_id ORDER BY m.date_published) AS next_release_date
    FROM
        director_mapping AS dm
    INNER JOIN
        movie AS m ON m.id = dm.movie_id
)
SELECT
    n.id AS director_id,
    n.name AS director_name,
    COUNT(m.id) AS number_of_movies,
    Round(AVG(DATEDIFF(md.next_release_date,m.date_published)), 2) AS avg_inter_movie_days,
    AVG(r.avg_rating) AS avg_rating,
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM
    names AS n
INNER JOIN
    director_mapping AS dm ON dm.name_id = n.id
INNER JOIN
    movie AS m ON m.id = dm.movie_id
INNER JOIN
    ratings AS r ON r.movie_id = m.id
INNER JOIN
    movie_diffs AS md ON md.director_id = n.id AND md.date_published = m.date_published
GROUP BY
    director_id, director_name
ORDER BY
    number_of_movies DESC
LIMIT 9;

/*# director_id, director_name, number_of_movies, avg_inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration
'nm1777967', 'A.L. Vijay', '5', '176.7500', '5.42000', '1754', '3.7', '6.9', '613'
'nm2096009', 'Andrew Jones', '5', '190.7500', '3.02000', '1989', '2.7', '3.2', '432'
'nm0831321', 'Chris Stokes', '4', '198.3333', '4.32500', '3664', '4.0', '4.6', '352'
'nm2691863', 'Justin Price', '4', '315.0000', '4.50000', '5343', '3.0', '5.8', '346'
'nm0425364', 'Jesse V. Johnson', '4', '299.0000', '5.45000', '14778', '4.2', '6.5', '383'
'nm0001752', 'Steven Soderbergh', '4', '254.3333', '6.47500', '171684', '6.2', '7.0', '401'
'nm0814469', 'Sion Sono', '4', '331.0000', '6.02500', '2972', '5.4', '6.4', '502'
'nm6356309', 'Özgür Bakar', '4', '112.0000', '3.75000', '1092', '3.1', '4.9', '374'
'nm0515005', 'Sam Liu', '4', '260.3333', '6.22500', '28557', '5.8', '6.7', '312'*/








