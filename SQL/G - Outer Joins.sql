--Outer Joins Exercise
USE [A01-School]
GO

--1. Select All position descriptions and the staff ID's that are in those positions
SELECT  PositionDescription, StaffID
FROM    Position AS P -- Start with the Position table, because I want ALL position descriptions...
    LEFT OUTER JOIN Staff AS S ON P.PositionID = S.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
--HINT: Count can use either count(*) which means the entire "row", or "all the columns".
--      Which gives the correct result in this question?
SELECT  PositionDescription,
        COUNT(StaffID) AS 'Number of Staff'
FROM    Position AS P
    LEFT OUTER JOIN Staff AS S ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription
-- but -- The following version gives the WRONG results, so just DON'T USE *  !
SELECT PositionDescription, 
       Count(*) -- this is counting the WHOLE row (not just the Staff info)
FROM   Position AS P
    LEFT OUTER JOIN Staff AS S
        ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        AVG(Mark) AS 'Average'
FROM    Student AS S
    LEFT OUTER JOIN Registration AS R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--4. Select the highest and lowest mark for each student. 
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        MAX(Mark) AS 'Highest',
		MIN(Mark) 'Lowest'
FROM    Student AS S
    LEFT OUTER JOIN Registration AS R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--5. How many students are in each club? Display club name and count.
-- TODO: Student Answer Here...
SELECT  ClubName,
        COUNT(Studentid) AS 'StudentCount'
FROM    Club
    LEFT OUTER JOIN Activity
        ON Club.ClubId = Activity.ClubId
GROUP BY ClubName

--6. How many times has each course been offered? Display the course ID and course name along with the number of times it has been offered.
-- TODO: Student Answer Here...
SELECT  C.CourseId, C.CourseName, COUNT(R.CourseId) AS 'Offerings'
FROM    Course AS C
    LEFT OUTER JOIN Registration AS R
        ON C.CourseId = R.CourseId
GROUP BY C.CourseId, C.CourseName

--7. How many courses have each of the staff taught? Display the full name and the count.
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName,
        COUNT(R.CourseId) AS 'CourseCount'
FROM    Staff AS S
    LEFT OUTER JOIN Registration AS R ON S.StaffID = R.StaffID
GROUP BY FirstName, LastName

--   Another way of interpreting the question is to think of the number of "kinds" of courses the staff has taught
SELECT  FirstName + ' ' + LastName,
       COUNT(DISTINCT CourseId) AS 'CourseCount'
FROM    Staff AS S
   LEFT OUTER JOIN Registration AS R ON S.StaffID = R.StaffID
GROUP BY FirstName, LastName

--8. How many second-year courses have the staff taught? Include all the staff and their job position.
--   A second-year course is one where the number portion of the course id starts with a '2'.
-- TODO: Student Answer Here...
SELECT  PositionDescription,
        FirstName + ' ' + LastName AS 'StaffName',
        COUNT(CourseId) AS 'CourseCount'
FROM    Position AS P
    -- Use an INNER join to only include positions with staff members
    --INNER JOIN Staff AS S ON P.PositionID = S.PositionID
    LEFT OUTER JOIN Staff AS S ON P.PositionID = S.PositionID
    LEFT OUTER JOIN Registration AS R ON S.StaffID = R.StaffID
WHERE   CourseId LIKE '____2%' -- An underscore means a single character
   OR   CourseId IS NULL -- Now I will get staff that haven't taught a course
GROUP BY PositionDescription, FirstName, LastName

--   Another way of interpreting the question is to think of the number of "kinds" of courses the staff has taught
SELECT  PositionDescription,
        FirstName + ' ' + LastName AS 'StaffName',
        COUNT(DISTINCT CourseId) AS 'CourseCount'
FROM    Position AS P
    -- Use an INNER join to only include positions with staff members
    --INNER JOIN Staff AS S ON P.PositionID = S.PositionID
    LEFT OUTER JOIN Staff AS S ON P.PositionID = S.PositionID
    LEFT OUTER JOIN Registration AS R ON S.StaffID = R.StaffID
WHERE   CourseId LIKE '____2%' -- An underscore means a single character
   OR   CourseId IS NULL -- Now I will get staff that haven't taught a course
GROUP BY PositionDescription, FirstName, LastName

--9. What is the average payment amount made by each student? Include all the students,
--   and display the students' full names.
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'Student',
        AVG(Amount) AS 'AveragePayment'
FROM    Student AS S 
    LEFT OUTER JOIN Payment AS P
        ON S.StudentID = P.StudentID
GROUP BY FirstName, LastName

--10. Display the names of all students who have not made a payment.
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'StudentName'
FROM    Student AS S
    LEFT OUTER JOIN Payment AS P
        ON S.StudentID = P.StudentID
WHERE   P.StudentID IS NULL -- Where the Payment does not exist

