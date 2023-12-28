--Find the names of all students who are friends with someone named Gabriel.

SELECT DISTINCT H1.name
FROM Highschooler H1
JOIN Friend F ON H1.ID = F.ID1
JOIN Highschooler H2 ON F.ID2 = H2.ID
WHERE H2.name = 'Gabriel'


--For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
JOIN Likes L ON H1.ID = L.ID1
JOIN Highschooler H2 ON L.ID2 = H2.ID
WHERE H1.grade - H2.grade >= 2;

--For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

SELECT distinct H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
JOIN Likes L ON H1.ID = L.ID1
JOIN Highschooler H2 ON L.ID2 = H2.ID
JOIN Likes L2 ON H1.ID = L2.ID2 AND H2.ID = L2.ID1
Where H1.name<H2.name
Order by H1.name

--Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT distinct Highschooler.name, Highschooler.grade
From Highschooler
Where Highschooler.id not in (Select distinct id1 from Likes union Select distinct id2 from Likes)
Order by Highschooler.grade, Highschooler.name;

--For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
SELECT A.name, A.grade, B.name, B.grade
FROM Highschooler A
JOIN Likes L ON A.ID = L.ID1
JOIN Highschooler B ON L.ID2 = B.ID
WHERE B.ID NOT IN (SELECT ID1 FROM Likes)

--Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT H1.name, H1.grade
FROM Highschooler H1
WHERE H1.ID NOT IN (
    SELECT DISTINCT F.ID1
    FROM Friend F
    JOIN Highschooler H2 ON F.ID2 = H2.ID AND H1.grade != H2.grade
    WHERE F.ID1 IS NOT NULL
    
    UNION
    
    SELECT DISTINCT F.ID2
    FROM Friend F
    JOIN Highschooler H2 ON F.ID1 = H2.ID AND H1.grade != H2.grade
    WHERE F.ID2 IS NOT NULL
)
ORDER BY H1.grade, H1.name;

--For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
SELECT DISTINCT A.name, A.grade, B.name, B.grade, C.name, C.grade
FROM Highschooler A, Highschooler B, Highschooler C, Likes L, Friend F1, Friend F2
WHERE (A.ID = L.ID1 AND B.ID = L.ID2) AND B.ID NOT IN (
  SELECT ID2
  FROM Friend
  WHERE ID1 = A.ID
) AND (A.ID = F1.ID1 AND C.ID = F1.ID2) AND (B.ID = F2.ID1 AND C.ID = F2.ID2);

--Find the difference between the number of students in the school and the number of different first names.

SELECT COUNT(*) - Count(distinct name)
From Highschooler

--Find the name and grade of all students who are liked by more than one other student.
Select H1.name, H1.grade
From Highschooler H1
JOIN Likes L ON H1.id=L.id2
Group BY id2
Having Count(DISTINCT L.id1)>1;

