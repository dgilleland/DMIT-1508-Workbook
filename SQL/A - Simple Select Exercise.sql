--SIMPLE SELECT EXERCISE 1

USE [A01-School]
GO

/* SELECT Statement in SQL

SELECT clause   - (Required) Identify the columns/data we want to retrieve
FROM clause     - Identify the table(s) to look at for the data
WHERE clause    - Filter the results of the search/query
GROUP BY clause - Re-organize the rows into groups for some aggregation
HAVING clause   - Filter the results of our grouping
ORDER BY clause - Sort our final results

 */

-- Simple Select, without any other clauses
SELECT  'Dan', 'Gilleland'

-- Simple Select with expressions
SELECT  'Dan' + ' ' + 'Gilleland', 18 * 52, '5' + '10'
--        textual information      numbers    textual

-- Specify a column name with some hard-code/calculated values
SELECT  'Dan' + ' ' + 'Gilleland' AS 'Instructor',
        22 * 52 AS 'Weeks at the job'

-- Let's use the SELECT statement with database tables

-- 1.   Select all the information from the Club table
-- The SELECT statement produces a table of results which will consist of one or more rows of data.
SELECT  ClubId, ClubName
FROM    Club

-- The * can be used to indicate all of the columns. But DO NOT DO THIS, or your instructor
-- WILL deduct marks EVERY TIME you do this.
SELECT  *
FROM    Club

-- Notice that when selecting from an existing table, when we identify which columns we want to
-- show, then those column names are used as the column title for the results table.
-- The AS keyword  in the SELECT clause is used to assign a title to the column in the results table
SELECT  ClubId AS 'ID', ClubName
FROM    Club

-- These keyboard shortcuts are for SQL Server Management Studio (SSMS)
  -- Pro-Tip: Press [ctrl] + r to toggle the results window
  -- Pro-Tip: If you write the FROM clause before specifying the columns,
  --            you will get Intellisense help on the column names
  -- Pro-Tip: Press [ctrl] + [shift] + r to "refresh" intellisense

-- 2.   Select the FirstNames and LastNames of all the students
SELECT  FirstName, LastName
FROM    Student
-- 2.a. Repeat the above query, but using column aliases
SELECT  FirstName AS 'First Name', LastName AS 'Last Name'
FROM    Student
-- 2.b. Select the student id and full name of all the students
SELECT  StudentID, FirstName + ' ' + LastName AS 'Full Name'
FROM    Student
-- 2.c. Select the first and last names of all the students,
--      and sort the results by the last name
SELECT    FirstName, LastName
FROM      Student
ORDER BY  LastName -- default is to sort in ASCENDING order
-- 2.d
SELECT    FirstName, LastName
FROM      Student
ORDER BY  LastName DESC -- Descending order
-- 2.e. Select the first and last names of all the students,
--      and sort the results by the last name, then by the first name
SELECT    FirstName, LastName
FROM      Student
ORDER BY  LastName, FirstName

--3. Select the CourseId and CourseName of all the courses. Use the column aliases of Course ID and Course Name
SELECT  CourseId AS 'Course ID', CourseName AS 'Course Name'
FROM    Course

--4. Select all the course information for courseID 'DMIT101'
-- I will mark the following as a ZERO
--SELECT  * -- All columns
--FROM    Course
SELECT CourseID, CourseName, CourseHours, MaxStudents, CourseCost
FROM   Course
WHERE  CourseID = 'DMIT101'

-- 4.a Select the course information for 'DMIT142'
SELECT CourseID, CourseName, CourseHours, MaxStudents, CourseCost
FROM   Course
WHERE  CourseID = 'DMIT142'

-- 4.b. Select all the first-year courses (DMIT1xx). Show the ID and the name.
SELECT CourseID, CourseName
FROM   Course
WHERE  CourseID LIKE 'DMIT1%'

--5. Select the Staff names who have job positionID of 3
SELECT FirstName, LastName
       --,PositionID -- Press [ctrl] + k, then [ctrl] + u to un-comment
FROM   Staff
WHERE  PositionID = 3

        -- BTW, what is PositionID of 3 referring to?
SELECT  PositionID, PositionDescription
FROM    Position

--6.    Select the Course Names whose course hours are less than 96
SELECT  C.CourseName
FROM    Course AS C -- I can have an alias to the table name
WHERE   C.CourseHours < 96

-- Type with me the following...
SELECT  ST.LastName, ST.DateHired, ST.DateReleased
FROM    Staff AS ST -- The use of the AS keyword in producing table/column aliases is optional
                    -- but it can be a good idea for readability.
-- You can use the full table name to fully-qualify your column names
SELECT  Staff.LastName, Staff.FirstName, Staff.DateHired
FROM    Staff
WHERE   Staff.DateReleased IS NOT NULL
-- NOTE: You can't mix the use of a table alias with the full name of the table

-- 7.   Select the studentID's, CourseID and mark where the Mark is between 70 and 80
SELECT  StudentID, CourseId, Mark
FROM    Registration
WHERE   Mark BETWEEN 70 AND 80 -- BETWEEN is inclusive
--WHERE   Mark >= 70 AND Mark <= 80

-- 7.a. Select the StudentIDs where the withdrawal status is null
SELECT  StudentID
        --, WithdrawYN
FROM    Registration
WHERE   WithdrawYN IS NULL -- we use IS NULL instead of = NULL, because = NULL won't work.

-- 7.b. Select the student ids of students who have withdrawn from a course
SELECT  StudentID
FROM    Registration
WHERE   WithdrawYN = 'Y'

--8.    Select the studentID's, CourseID and mark where the Mark is
--      between 70 and 80 and the courseID is DMIT223 or DMIT168
SELECT  R.StudentID, R.CourseId, R.Mark
FROM    Registration AS R -- Alias for the Registration table
WHERE   R.Mark BETWEEN 70 AND 80
  AND   (R.CourseId = 'DMIT223' OR R.CourseId = 'DMIT168')
  --    I use parenthesis to force the OR operation to happen first
-- alternate answer to #8
SELECT  R.StudentID, R.CourseId, R.Mark
FROM    Registration AS R -- Alias for the Registration table
WHERE   R.Mark BETWEEN 70 AND 80
  AND   R.CourseId IN ('DMIT223', 'DMIT168') -- The IN keyword allows us to have a list of values
                                             -- that will be checked in a OR manner.

--8.a. Select the studentIDs, CourseID and mark where the Mark is 80 and 85
SELECT  R.StudentID, R.CourseId, R.Mark
FROM    Registration AS R
WHERE   R.Mark = 80 OR R.Mark = 85

-- The next two questions introduce the idea of "wildcards" and pattern matching in the WHERE clause
-- _ is a wildcard for a single character
-- % is a wildcard for zero or more characters
-- [] is a pattern for a single character matching the pattern in the square brackets
--9. Select the students first and last names who have last names starting with S
SELECT  FirstName, LastName
FROM    Student
WHERE   LastName LIKE 'S%'

--10. Select Coursenames whose CourseID have a 1 as the fifth character
SELECT  CourseName
FROM    Course
WHERE   CourseID LIKE '____1%' -- four underscores, 1, %
--                     DMIT158

--11. Select the CourseID's and CourseNames where the CourseName contains the word 'programming'
-- TODO: Student Answer Here


--12. Select all the ClubNames who start with N or C.
-- TODO: Student Answer Here


--13. Select Student Names, Street Address and City where the lastName is only 3 letters long.
-- TODO: Student Answer Here


--14. Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5
-- TODO: Student Answer Here


