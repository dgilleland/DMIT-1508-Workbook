-- Update Examples
USE [A0X-School]
GO -- Execute the code up to this point as a single batch

/*  Notes:
    The syntax for the UPDATE statement is

    UPDATE TableName
    -- the SET portion is a comma-separated list of assignment statements
    SET    ColumnName = Expression,
           Column2 = Expression
    WHERE  ConditionalExpression

*/
-- Update Examples
-- 1. The school thinks it can get a bit more money out of students
--    because of the popularity of a few of its courses. As such,
--    they are increasing the course cost of 'Expert SQL' and 'Quality Assurance'
--    by 10%.
-- SELECT * FROM Course
UPDATE Course
SET    CourseCost = CourseCost * 1.10
WHERE  CourseName IN ('Expert SQL', 'Quality Assurance')
-- Should see 2 rows affected

-- 2. Along with the goals of the school to make more money, they are allowing
--    all courses to have a total of 10 students as the maximum.
UPDATE Course
SET    MaxStudents = 10
-- Notice that because we don't have a WHERE clause, ALL the rows will be affected

-- 3. One of the students has moved and has supplied their new address.
--    Change the address of student 199912010 to 4407-78 Ave, Edmonton, T4Y3P0
-- SELECT * FROM Student WHERE StudentID = 199912010
UPDATE Student
SET    StreetAddress = '4407-78 Ave',
       City = 'Edmonton',
       PostalCode = 'T4Y3P0'
WHERE  StudentID = 199912010

/* ================== */
/* == Interlude... == */
-- Updating Multiple Columns in One Statement
-- Consider the following new table with data
GO
DROP TABLE IF EXISTS Rectangle
GO
CREATE TABLE Rectangle
(
    Id        int
        CONSTRAINT PK_Rectangle_Id PRIMARY KEY
        IDENTITY(1, 1)    NOT NULL,
    Width     int         NOT NULL,
    [Length]  int         NOT NULL,
    Area      int         NOT NULL
)
GO
INSERT INTO Rectangle(Width, [Length], Area)
VALUES (5, 10, 50)
GO

-- Now, say we want to increase the width and length by 5
-- for the rectangle with an Id of 1.
-- The area would have to be updated as well.
-- Run the following and then describe if the result is correct or not. What values do you expect to appear in each column?
UPDATE  Rectangle                     -- Expression Value is
SET     Width    = Width + 5,         -- ??
        [Length] = [Length] + 5,      -- ??
        Area     = Width * [Length]   -- ??
WHERE   Id = 1
-- Check the results:
SELECT Width, [Length], Area
FROM   rectangle
-- What went wrong??
-- The problem with the UPDATE was that the value of the
-- expression is calculated on the right-hand of the equals
-- BEFORE anything is assigned in the columns.
-- That is because the entire row is updated in a SINGLE step,
-- not one column at a time.

-- Let's reset the values in the table.
UPDATE  Rectangle
SET     Width    = 5,
        [Length] = 10,
        Area     = 5 * 10
WHERE   Id = 1

SELECT Width, [Length], Area
FROM   rectangle

-- Now, let's try it again.
-- Increase the width and length by 5 and calculate the area.
UPDATE  Rectangle                                 -- Expression Value is
SET     Width    = Width + 5,                     -- ??
        [Length] = [Length] + 5,                  -- ??
        Area     = (Width + 5) * ([Length] + 5)   -- ??
WHERE   Id = 1

SELECT Width, [Length], Area
FROM   rectangle

-- Let's clean up our database by removing this ad-hoc table
GO
IF EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Rectangle')
    DROP TABLE Rectangle
GO

/* ================== */

-- 4. Someone in the registrar's office has noticed a bunch of data-entry errors.
-- SELECT City FROM Student
--    All the student cities named 'Edm' should be changed to 'Edmonton'
UPDATE Student
SET    City = 'Edmonton'
WHERE  City = 'Edm'

-- ======= Practice ========
-- 5. For each student that does not have a mark in the Registration table,
--    create an update statement that gives each student a mark.
-- TIP - Try using the RAND() function for a random number. E.g.:
--       SELECT floor(rand()*101) AS 'Mark'
--       and then check the database to see if those students were assigned
--       unique values or the same value.
-- TODO: Student Answer Here....
-- SELECT StudentID, Mark FROM Registration WHERE Mark IS NULL
UPDATE Registration
SET    Mark = (SELECT floor(rand()*101) AS 'Mark')
WHERE  Mark IS NULL
-- SELECT StudentID, Mark FROM Registration

-- 6. Choose a student from the previous question and withdraw them from all
--    of their courses.
-- TODO: Student Answer Here....

-- 7. Bonus Time! Update the marks of all the students in the DMIT152 course by
--    increasing their marks by 5%. Check the database before and after doing
--    the update to verify if the changes were correct.
-- SELECT StudentID, Mark FROM Registration WHERE CourseId = 'DMIT152'
UPDATE Registration
SET    Mark = Mark * 1.05
WHERE  CourseId = 'DMIT152'
-- SELECT StudentID, Mark FROM Registration WHERE CourseId = 'DMIT152'

/* Updating Tables via Views: -----------------------------
 * It is possible to use a VIEW as an "intermediary" for inserting/updating/deleting
 * from tables. Depending on the view, however, there may be limitations on what
 * operations you can perform.
 */
/* The following statements expect the presence of a view called StudentGrades.*/
GO
DROP VIEW IF EXISTS StudentGrades
GO
CREATE VIEW StudentGrades
AS
    SELECT  S.StudentID,
            FirstName + ' ' + LastName AS 'StudentFullName',
            C.CourseId,
            CourseName,
            Mark
    FROM    Student S
        INNER JOIN Registration R ON S.StudentID = R.StudentID
        INNER JOIN Course C ON C.CourseId = R.CourseId
GO
-- SELECT * FROM StudentGrades -- Use to examine the results in the view

--8.  Using the StudentGrades view, change the coursename for the capstone course to be 'basket weaving 101'.
UPDATE  StudentGrades
SET     CourseName = 'basket weaving 101'
WHERE   CourseName = 'Capstone Project'

/* 
    Sometimes, we need to update columns in a certain table
    based on information in another related table.
    There are a few ways to do this, but one of the
    easier ways is through the use of subqueries.
    The following is an example of how to do this.
--  NOTE: First of all, this next problem is presuming
    that there is a column called "Rebate".
    To add that column, execute the following ALTER TABLE statement.
ALTER TABLE Student
    ADD  Rebate  money  NULL
 */
--9. If a student has achieved high honours (80% or higher) on all courses, give them a $200 rebate.
UPDATE Student
    SET Rebate = 200
WHERE  StudentID IN
    (
        SELECT StudentID
        FROM   Registration
        GROUP BY StudentID
        HAVING  AVG(Mark) >= 80
    )

-- ======= Practice ========
--10.  Using the StudentGrades view, update the  mark for studentID 199899200 in course dmit152 to be 90.
-- TODO: Student Answer Here...

--11. Using the StudentGrades view, see if you can delete the same record from the previous question.
--    If it doesn't work, then copy the error message here.
-- TODO: Student Answer Here...

