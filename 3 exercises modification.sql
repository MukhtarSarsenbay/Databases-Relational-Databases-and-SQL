--SQL Movie-Rating Modification Exercises
--Add the reviewer Roger Ebert to your database, with an rID of 209.

Insert Into Reviewer ( rID, name )
Values (209, "Roger Ebert");

--For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)
Update Movie
set year=year+25
where mid in
(Select Mid
 from Rating 
 Group by mid 
 Having AVG(stars)>=4
);

--Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
DELETE FROM RATING
WHERE mid in
(Select distinct mid
 from Movie
 Where year <1970 or year>2000) and stars<4;