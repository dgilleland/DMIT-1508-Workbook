--Stored Procedures (Sprocs)
--  A Stored Procedure is a controlled execution of some SQL script.

USE [A0X-School]
GO
SELECT DB_NAME() AS 'Active Database'
GO

/* *******************************************
  Each Stored Procedure has to be the first statement in a batch,
    so place a GO statement in-between each question to execute 
    the previous batch (question) and start another.

GO
DROP PROCEDURE IF EXISTS SprocName
GO
CREATE PROCEDURE SprocName
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
*/

/****************
 * Introduction */


GO
DROP PROCEDURE IF EXISTS GetName
GO
CREATE PROCEDURE GetName
    -- Parameters here
AS
    -- Body of procedure here
    SELECT  'Dan', 'Gilleland'
    -- How would you change the line above to put column names on the result set?
RETURN
GO

-- Execute (run/call) the stored procedure as follows:
EXEC GetName

/* Variables and Flow Control */

-- Declare a variable
DECLARE @Cost money
-- Set a value for the variable using a value from the database
-- Note that the whole SELECT statement is in parenthesis
SET @Cost = (SELECT CourseCost FROM Course WHERE CourseId = 'DMIT101')
PRINT @Cost

-- Understanding BEGIN/END blocks
--  A BEGIN/END block basically acts like a pair of curly braces in C#.
--  It represents a single block of code, that is, a single set of instructions.
--  These are helpful especially with the IF/ELSE flow-control statements.
--  Consider the following example.
GO
DROP PROCEDURE IF EXISTS GuessRows
GO
-- 
CREATE PROCEDURE GuessRows
    -- This is the parameter list. These variables don't use the DECLARE keyword
    @clubRows   int 
AS
    DECLARE @actual int
    SELECT @actual = COUNT(ClubId) FROM Club
    IF @actual <> @clubRows
    BEGIN
        RAISERROR('Wrong guess. Club has a different number of rows', 16, 1)
        IF @clubRows > @actual
            RAISERROR('Too high a guess', 16, 1)
        ELSE
            RAISERROR('Too low a guess', 16, 1)
    END
    ELSE
    BEGIN
        RAISERROR('Good guess!', 16, 1) -- Always use:    ,16, 1)
        --          message, error number, severity/state
    END
RETURN
GO
EXEC GuessRows 5 -- Call the GuessRows procedure that's in the database.


/*******************
 * Sample Problems */

--1. Create a stored procedure called "HonorCourses" to select all the course names that have averages > 80%.
GO
DROP PROCEDURE IF EXISTS HonorCourses
GO
CREATE PROCEDURE HonorCourses
    -- Parameters here
AS
    -- Body of procedure here
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO
-- To actually execute (run) the stored procedure, you call EXEC
EXEC HonorCourses


--2. Create a stored procedure called "HonorCoursesOneTerm" to select all the course names that have average > 80% in semester 2004J.
GO
DROP PROCEDURE IF EXISTS HonorCoursesOneTerm
GO
CREATE PROCEDURE HonorCoursesOneTerm
AS
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    WHERE  R.Semester = '2004J'
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO
EXEC HonorCoursesOneTerm
GO

--3. Oops, made a mistake! For question 2, it should have been for semester 2004S. Write the code to change the procedure accordingly. 
ALTER PROCEDURE HonorCoursesOneTerm
AS
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    WHERE  R.Semester = '2004S'
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO

--3.B. Your instructor is back, and recommends that the previous stored procedure use a parameter for the semester, making it more "re-usable"
ALTER PROCEDURE HonorCoursesOneTerm
    @Semester   char(5) -- @ preceeds the name of the parameter
AS
    SELECT C.CourseName
    FROM   Course C
        INNER JOIN Registration R ON C.CourseId = R.CourseId
    WHERE  R.Semester = @Semester
    GROUP BY C.CourseName
    HAVING AVG(R.Mark) > 80
RETURN
GO
-- Now the stored procedure can be called with any semester I want
EXEC HonorCoursesOneTerm '2004S'
EXEC HonorCoursesOneTerm '2004J'

--4.  Create a stored procedure called CourseCalendar that lists the course ID, name, and cost of all available courses.
GO
DROP PROCEDURE IF EXISTS CourseCalendar
GO
CREATE PROCEDURE CourseCalendar
    -- Parameters here
AS
    -- Body of procedure here
    SELECT  CourseId, CourseName, CourseCost
    FROM    Course
RETURN
GO

-- Call the stored procedure...
EXEC CourseCalendar

--4.B. Create a stored procedure called "NotInCourse" that lists the full names of the students that are not in a particular course. The stored procedure should expect the course number as a parameter. e.g.: DMIT221.
GO
DROP PROCEDURE IF EXISTS NotInCourse
GO
CREATE PROCEDURE NotInCourse
    -- Parameters here
    @CourseNumber   char(7)
AS
    -- Body of procedure here
    SELECT  DISTINCT FirstName + ' ' + LastName AS 'Student Name'        
    FROM    Student S
        INNER JOIN Registration R ON S.StudentID = R.StudentID
    WHERE   R.CourseId <> @CourseNumber -- <> is the "not equal to" operator
RETURN
GO
-- Try it out.....
EXEC NotInCourse 'DMIT221'


--5. Create a stored procedure called "LowNumbers" to select the course name of the course(s) that have had the lowest number of students in it.
GO
DROP PROCEDURE IF EXISTS LowNumbers
GO
CREATE PROCEDURE LowNumbers
    -- Parameters here
AS
    -- Body of procedure here
    SELECT  C.CourseName
--           ,COUNT(R.StudentID) AS 'Enrollement Count'
    FROM    Course C
        LEFT OUTER JOIN Registration R ON C.CourseId = R.CourseId
    GROUP BY C.CourseName
    HAVING COUNT(R.StudentID) <= ALL (SELECT COUNT(StudentID)
                                      FROM   Course C
                                          LEFT OUTER JOIN Registration R
                                              ON C.CourseId = R.CourseId
                                      GROUP BY C.CourseId)
    -- Notice that the subquery uses a left outer join. This is so that it includes courses
    -- that do not yet have registrations (in which case, it will be a zero enrollment).
    -- An acceptable alternate would be this....
    --HAVING COUNT(R.StudentID) <= ALL (SELECT COUNT(StudentID)
    --                                  FROM   Registration
    --                                  GROUP BY CourseId)
RETURN
GO
-- Run the above with the database as-is, and you will see five courses coming back.
EXEC LowNumbers
INSERT INTO Course(CourseId, CourseName, CourseHours, CourseCost, MaxStudents)
VALUES ('DMIT987', 'Advanced Logic', 90, 420.00, 12)
GO

--6. Create a stored procedure called "Provinces" to list all the students provinces.
-- TODO: Student Answer Here

--7. OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.
-- TODO: Student Answer Here

--8. Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment types. Ensure all the student names are listed, including those who have not yet made a payment.
-- TODO: Student Answer Here

--9. Modify the procedure from question 8 to return only the student names that have made payments.
-- TODO: Student Answer Here

