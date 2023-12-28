--SQL Movie-Rating Modification Exercises
--It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
Delete from Highschooler
Where Highschooler.grade=12;

--If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes
WHERE (ID1, ID2) IN (
    SELECT L1.ID1, L1.ID2
    FROM Likes L1
    JOIN Friend F ON L1.ID1 = F.ID1 AND L1.ID2 = F.ID2
    LEFT JOIN Likes L2 ON L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1
    WHERE L2.ID1 IS NULL
);

--For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)
INSERT INTO Friend (ID1, ID2)
SELECT DISTINCT F1.ID1, F2.ID2
FROM Friend F1
JOIN Friend F2 ON F1.ID2 = F2.ID1
WHERE F1.ID1 <> F2.ID2
  AND (F1.ID1, F2.ID2) NOT IN (SELECT ID1, ID2 FROM Friend);
