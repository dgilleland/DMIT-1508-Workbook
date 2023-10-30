/* Answers to Practice SQL Query Questions
 *************************************************/
USE [A0X-School]
GO
SELECT DB_NAME() AS 'Active Database'
GO

/* ===============================
   |  A - Simple Select          |
   ------------------------------- */
--11. Select the CourseID's and CourseNames where the CourseName contains the word 'programming'
-- TODO: Student Answer Here
SELECT  C.CourseId, C.CourseName
FROM    Course AS C
WHERE   CourseName LIKE '%programming%'


--12. Select all the ClubNames who start with N or C.
-- TODO: Student Answer Here
SELECT  RG.ClubName
FROM    Club AS RG
--WHERE   RG.ClubName LIKE 'N%' OR RG.ClubName LIKE 'C%'
WHERE   RG.ClubName LIKE '[NC]%'


--13. Select Student Names, Street Address and City where the lastName is only 3 letters long.
-- TODO: Student Answer Here
SELECT  S.FirstName + ' ' + S.LastName AS 'StudentName',
        S.StreetAddress,
        S.City
FROM    Student AS S
WHERE   S.LastName LIKE '___'


--14. Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5
-- TODO: Student Answer Here
SELECT  StudentID
FROM    Payment
WHERE   Amount < 500
   OR   PaymentTypeID = 5


/* ===============================
   |  B - Simple Select          |
   ------------------------------- */
--5.	Select the average payment amount for payment type 5
-- TODO: Student Answer Here - Hint: It's in the Payment table....
SELECT  AVG(Amount) AS 'Average Payment'
FROM    Payment AS P
WHERE   P.PaymentTypeID = 5


-- Given that there are some other aggregate methods like MAX(columnName) and MIN(columnName), complete the following two questions:
--6. Select the highest payment amount
-- TODO: Student Answer Here
SELECT  MAX(Amount) AS 'Highest Payment'
FROM    Payment


--7.	 Select the lowest payment amount
-- TODO: Student Answer Here
SELECT  MIN(Amount) AS 'Lowest Payment'
FROM    Payment


--8. Select the total of all the payments that have been made
-- TODO: Student Answer Here
SELECT  SUM(Amount) AS 'Total Payments'
FROM    Payment


--9. How many different payment types does the school accept?
-- Do a bit of exploratory selects
SELECT PaymentTypeDescription
FROM   PaymentType
-- TODO: Student Answer Here
SELECT  COUNT(1) -- or COUNT(PaymentTypeDescription)
FROM    PaymentType


--10. How many students are in club 'CSS'?
-- TODO: Student Answer Here
SELECT  COUNT(Activity.StudentId)
FROM    Activity
WHERE   ClubId = 'CSS'



/* ===============================
   |  C - Simple Select          |
   ------------------------------- */
-- 3. Select the average Mark for each studentID. Display the StudentId and their average mark
-- TODO: Student Answer Here....
SELECT StudentID,
       AVG(Mark) AS 'Avg Mark'
FROM   Registration
GROUP BY StudentID

-- 8. How many students are there in each club? Show the clubID and the count
-- TODO: Student Answer Here....
SELECT  ClubId, COUNT(StudentID) AS 'StudentCount'
FROM    Activity
GROUP BY ClubId

-- Check your answer by manually grouping students by their club membership and counting them
SELECT  ClubId, StudentID
FROM    Activity

-- 9. Which clubs have 3 or more students in them?
-- TODO: Student Answer Here....
-- SELECT * FROM Activity
SELECT  ClubID
FROM    Activity
GROUP BY ClubId
HAVING  COUNT(StudentID) >= 3


--10. Grouping the courses by the number of hours in each course, what is the average cost of those courses? Display the course hours and the average cost.
-- TODO: Student Answer Here
-- select * from course
SELECT  CourseHours, AVG(CourseCost) AS 'AvgCost'
FROM    Course
GROUP BY CourseHours


--11. Which teachers are getting the best results from the courses they teach? Display the staff ID and the average course mark, sorted by the course mark from highest to lowest.
-- TODO: Student Answer Here
SELECT  StaffID, AVG(Mark) AS 'AvgMark'
FROM    Registration
GROUP BY StaffID
ORDER BY AVG(Mark) DESC


--12. How many male and female students do we have?
-- TODO: Student Answer Here
SELECT Gender, COUNT(StudentID) AS 'Count'
FROM   Student
GROUP BY Gender


--13. Show the average balance owing for male and female students.
-- TODO: Student Answer Here
SELECT Gender, AVG(BalanceOwing) AS 'AverageOwed'
FROM   Student
GROUP BY Gender


--14. How many students participate in school clubs? Display the club id and the number of students. (Hint: You should be using the Activity table for this question.)
-- TODO: Student Answer Here
-- See Q.8.

/* ===============================
   |  D - Simple Joins           |
   ------------------------------- */
--5.	Select the Student full name, course names and marks for studentID 199899200.
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'Student',
        CourseName,
        Mark
FROM    Student AS S
    INNER JOIN Registration AS R ON R.StudentID = S.StudentID
    INNER JOIN Course AS C ON C.CourseId = R.CourseId
WHERE   S.StudentID = '199899200'


--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
-- TODO: Student Answer Here...
SELECT  DISTINCT C.CourseId, C.CourseName, R.Semester
FROM    Course AS C
    INNER JOIN Registration AS R ON C.CourseId = R.CourseId


--7.	What Staff Full Names have taught Networking 1?
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'Staff Name'
FROM    Staff AS S
    INNER JOIN Registration AS R ON S.StaffID = R.StaffID
    INNER JOIN Course AS C ON R.CourseId = C.CourseId
WHERE   CourseName = 'Networking 1'

--8.	What is the course list for student ID 199912010 in semester 2001S. Select the Students Full Name and the CourseNames
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'Student',
        CourseName
--        , S.StudentID -- Used for WHERE clause
--        , R.Semester  -- Used for WHERE clause
FROM    Student AS S
    INNER JOIN Registration AS R ON S.StudentID = R.StudentID
    INNER JOIN Course AS C       ON R.CourseId = C.CourseId
WHERE   S.StudentID = 199912010
  AND   R.Semester = '2001S'

--9. What are the Student Names, courseID's with individual Marks at 80% or higher? Sort the results by course.
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'Student',
        CourseId
--        , S.StudentID -- Used for WHERE clause
--        , R.Semester  -- Used for WHERE clause
FROM    Student AS S
    INNER JOIN Registration AS R ON S.StudentID = R.StudentID
WHERE   R.Mark >= 80
ORDER BY CourseId

--10. Modify the script from the previous question to show the Course Name along with the ID.
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName AS 'Student',
        R.CourseId,
        CourseName
--        , S.StudentID -- Used for WHERE clause
--        , R.Semester  -- Used for WHERE clause
FROM    Student AS S
    INNER JOIN Registration AS R ON S.StudentID = R.StudentID
    INNER JOIN Course AS C ON R.CourseId = C.CourseId
WHERE   R.Mark >= 80
ORDER BY R.CourseId


/* ===============================
   |  E - Strings & Dates        |
   ------------------------------- */
  -- Abbreviate the month name to 3 characters.
  -- TODO: Student Answer Here
	SELECT LEFT(DATENAME(MONTH, GETDATE()), 3) AS 'Database Server- Current Month'

   
-- 6. select last three characters of all the course ids
-- TODO: Student Answer Here...


-- 7. Select the characters in the position description from characters 8 to 12
--    (five characters worth) for PositionID 5
-- TODO: Student Answer Here...
-- Exploring...
-- SELECT * FROM Position
SELECT  SUBSTRING(PositionDescription, 8, 5)
FROM    [Position]
WHERE   PositionID = 5

-- 8. Select all the Student First Names as upper case.
-- TODO: Student Answer Here...


-- 9. Select the First Names of students whose first names are 3 characters long.
-- TODO: Student Answer Here...


-- 10. Select the staff names and the name of the month they were hired
--     and order the results by the month number.
-- TODO: Student Answer Here...


/* ===============================
   |  F - Inner Join Aggregates  |
   ------------------------------- */
--3. How many payments where made for each payment type. Display the PaymentTypeDescription and the count.
 -- TODO: Student Answer Here... 
SELECT  PaymentTypeDescription,
        COUNT(P.PaymentTypeID) AS 'Count'
FROM    PaymentType AS PT
    INNER JOIN Payment AS P ON P.PaymentTypeID = PT.PaymentTypeID
GROUP BY PaymentTypeDescription

--5. Select the same data as question 4 but only show the student names and averages that are 80% or higher. (HINT: Remember the HAVING clause?)
 -- TODO: Student Answer Here... 
SELECT  S.FirstName  + ' ' + S.LastName AS 'Student Name',
        AVG(R.Mark)                     AS 'Average'
FROM    Registration AS R
        INNER JOIN Student AS S
            ON S.StudentID = R.StudentID
GROUP BY    S.FirstName  + ' ' + S.LastName
HAVING  AVG(R.Mark) >= 80

--6. What is the highest, lowest and average payment amount for each payment type Description?
 -- TODO: Student Answer Here... 
SELECT  PaymentTypeDescription,
        MAX(P.Amount) AS 'Highest',
        MIN(P.Amount) AS 'Lowest',
        AVG(P.Amount) AS 'Average'
FROM    PaymentType AS PT
    INNER JOIN Payment AS P ON P.PaymentTypeID = PT.PaymentTypeID
GROUP BY PaymentTypeDescription

 
--7. Which clubs have 3 or more students in them? Display the Club Names.
 -- TODO: Student Answer Here... 
SELECT  ClubName
FROM    Club AS C
    INNER JOIN Activity AS A ON A.ClubId = C.ClubId
GROUP BY ClubName
HAVING  COUNT(ClubName) >= 3



/* ===============================
   |  G - Outer Joins            |
   ------------------------------- */
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


/* ===============================
   |  H - Subqueries             |
   ------------------------------- */
   
--2. Select The Student ID's of all the students that are in the 'Association of Computing Machinery' club
-- TODO: Student Answer Here
/*
SELECT * FROM Club
SELECT * FROM Activity
*/
-- Thinking of the subquery first, I can find out
-- what club ID matches for the given club name

SELECT  StudentID
FROM    Activity
WHERE   ClubID =   -- This is the Activity.ClubID
        (SELECT  ClubID  -- This is the Club.ClubID
        FROM Club 
        WHERE ClubName = 'Association of Computing Machinery')

-- 2.b. Let's revisit/modify Question 2: Select the names of all the students in the 'Association of Computing Machinery' club. Use a subquery for your answer; do not use any JOINs. When you make your answer, ensure the outmost query only uses the Student table in its FROM clause.
SELECT firstName + ' ' + LastName AS 'StudentName'
FROM Student
WHERE StudentID IN 
    (SELECT  StudentID
    FROM    Activity
    WHERE   ClubID =   -- This is the Activity.ClubID
            (SELECT  ClubID  -- This is the Club.ClubID
            FROM Club 
            WHERE ClubName = 'Association of Computing Machinery'))
-- As a solution with JOINs, the following gets the same
-- result.
SELECT  FirstName + ' ' + LastName AS 'StudentName'
FROM    Student AS S
    INNER JOIN Activity AS A ON S.StudentID = A.StudentID
    INNER JOIN Club AS C ON C.ClubId = A.ClubId
WHERE   ClubName = 'Association of Computing Machinery'

--4. Select All the staff full names that taught DMIT172.
-- TODO: Student Answer Here
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
WHERE  StaffID IN -- I used IN because the subquery returns many rows
    (SELECT DISTINCT StaffID FROM Registration WHERE CourseId = 'DMIT172')

-- The above can also be done as an INNER JOIN...
SELECT DISTINCT FirstName + ' ' + LastName AS 'Staff'
FROM Staff
    INNER JOIN Registration
        ON Staff.StaffID = Registration.StaffID
WHERE CourseId = 'DMIT172'

--4.b. Who has taught DMIT152?
-- TODO: Student Answer Here
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
WHERE  StaffID IN -- I used IN because the subquery returns many rows
    (SELECT DISTINCT StaffID FROM Registration WHERE CourseId = 'DMIT152')


-- 9. What is the avg mark for each of the students from Edm? Display their StudentID and avg(mark)
-- TODO: Student Answer Here...
SELECT  S.StudentID, AVG(Mark) AS 'Average Mark'
FROM    Student AS S
    INNER JOIN Registration AS R
        ON S.StudentID = R.StudentID
WHERE   City = 'Edm'
GROUP BY S.StudentID

-- 10. Which course(s) allow the largest classes? Show the course id, name, and max class size.
-- TODO: Student Answer Here...
SELECT  CourseId, CourseName, MaxStudents
FROM    Course
WHERE   MaxStudents >= ALL (SELECT MaxStudents FROM Course)

-- 11. Which course(s) are the most affordable? Show the course name and cost.
-- TODO: Student Answer Here...
SELECT  CourseName, CourseCost
FROM    Course
WHERE   CourseCost <= ALL (SELECT CourseCost FROM Course)

-- 12. Which staff have taught the largest classes? (Be sure to group registrations by course and semester.)
-- TODO: Student Answer Here...
SELECT  DISTINCT FirstName + ' ' + LastName AS 'StaffName'
        --, CourseId
        --, COUNT(CourseId)
FROM    Staff AS S
    INNER JOIN Registration AS R
        ON S.StaffID = R.StaffID
GROUP BY FirstName + ' ' + LastName, CourseId
HAVING  COUNT(CourseId) >= ALL (SELECT COUNT(CourseId)
                                FROM   Registration
                                GROUP BY StaffID, CourseId)

-- 13. Which students are most active in the clubs?
-- TODO: Student Answer Here...
SELECT  FirstName + ' ' + LastName  AS 'StudentName'
      --, COUNT(A.ClubId)
FROM    Student AS S
    INNER JOIN Activity AS A
        ON S.StudentID = A.StudentID
GROUP BY FirstName + ' ' + LastName
HAVING  COUNT(ClubId) >= ALL (SELECT COUNT(ClubId) FROM Activity GROUP BY StudentID)

-- 14. Which student(s) have the highest average mark?
-- Hint - This can only be done by a subquery.
-- Extra Hint - This one is a bit tricky, because you need to make sure your subquery does not
--              have any NULL rows...
-- TODO: Student Answer Here...
SELECT StudentID
FROM   Registration
GROUP BY StudentID
HAVING AVG(Mark) >= ALL --  A number can't be 'GREATER THAN or EQUAL TO' a NULL value
        (SELECT AVG(Mark)
         FROM   Registration
         WHERE  Mark IS NOT NULL -- Ah, tricky!
         GROUP BY StudentID)


/* ===============================
   |  I - Views                  |
   ------------------------------- */
--4.  Create a view called StudentGrades that retrieves the student ID's, full names, courseId's, course names, and marks for each student.
-- TODO: Student Answer here

/* *******************
 * Using the Views
 *  If an operation fails write a brief explanation why.
 *  Do not just quote the error message generated by the server!
 */

--5.  Use the student grades view to create a grade report for studentID 199899200 that shows the students ID, full name, course names and marks.
-- TODO: Student Answer here

--6.  Select the same information using the student grades view for studentID 199912010.
-- TODO: Student Answer here

--7.  Retrieve the course id for the student grades view from the database.
-- TODO: Student Answer here



/* ===============================
   |  J - Unions                 |
   ------------------------------- */

