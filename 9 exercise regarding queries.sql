--Find the titles of all movies directed by Steven Spielberg.
select title
from Movie 
where director ='Steven Spielberg'

--Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
Select distinct year
from Movie, Rating
where Movie.mID==Rating.mID and stars>=4 and stars<=5
order by year asc;

--Find the titles of all movies that have no ratings.

Select distinct title
from Movie, Rating
where Movie.mID not in (select mid from Rating where Movie.mid=Rating.mid)

--Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
Select DISTINCT Reviewer.name
From Reviewer, Rating
where Reviewer.rID= Rating.rID and Rating.ratingdate is null;

--Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select Reviewer.name, Movie.title,Rating.stars, Rating.ratingDate
From Reviewer, Movie,Rating
Where Movie.mID=Rating.mID and Reviewer.rID =Rating.rID
order by Reviewer.name asc,Movie.title Asc,Rating.stars ASC;

--For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
SELECT
  rv.name AS reviewer_name,
  mv.title AS movie_title
FROM
  Rating r1
  JOIN Rating r2 ON r1.rID = r2.rID
  JOIN Movie mv ON r1.mID = mv.mID
  JOIN Reviewer rv ON r1.rID = rv.rID
WHERE
  r1.mID = r2.mID
  AND r1.stars < r2.stars
  AND r1.ratingDate < r2.ratingDate;
  
--For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
SELECT
  m.title AS movie_title,
  MAX(r.stars) AS highest_stars
FROM
  Movie m
  JOIN Rating r ON m.mID = r.mID
WHERE
  r.stars IS NOT NULL
GROUP BY
  m.title
ORDER BY
  movie_title;
  
--For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT
  m.title AS movie_title,
  MAX(r.stars) - MIN(r.stars) AS rating_spread
FROM
  Movie m
  JOIN Rating r ON m.mID = r.mID
GROUP BY
  m.title
ORDER BY
  rating_spread DESC, movie_title;
  
--Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

WITH MovieAvgRating AS (
  SELECT
    m.mID,
    m.title,
    m.year,
    CAST(AVG(r.stars) AS DECIMAL(30, 20)) AS avg_rating
  FROM
    Movie m
    LEFT JOIN Rating r ON m.mID = r.mID
  GROUP BY
    m.mID, m.title, m.year
)
SELECT
  CAST(AVG(CASE WHEN year < 1980 THEN avg_rating END) AS DECIMAL(30, 20)) AS avg_rating_before_1980,
  CAST(AVG(CASE WHEN year >= 1980 THEN avg_rating END) AS DECIMAL(30, 20)) AS avg_rating_after_1980,
  CAST(AVG(CASE WHEN year < 1980 THEN avg_rating END) AS DECIMAL(30, 20)) - CAST(AVG(CASE WHEN year >= 1980 THEN avg_rating END) AS DECIMAL(30, 20)) AS rating_difference
FROM
  MovieAvgRating;