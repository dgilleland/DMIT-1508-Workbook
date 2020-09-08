-- Update Examples
USE [A01-School]
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

-- 4. Someone in the registrar's office has noticed a bunch of data-entry errors.
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

-- 6. Choose a student from the previous question and withdraw them from all
--    of their courses.
-- TODO: Student Answer Here....

-- 7. Bonus Time! Update the marks of all the students in the DMIT152 course by
--    increasing their marks by 5%. Check the database before and after doing
--    the update to verify if the changes were correct.

/* Updating Tables via Views: -----------------------------
 * It is possible to use a VIEW as an "intermediary" for inserting/updating/deleting
 * from tables. Depending on the view, however, there may be limitations on what
 * operations you can perform.
 */
/* The following statements expect the presence of a view called StudentGrades.*/
GO
IF OBJECT_ID('StudentGrades', 'V') IS NOT NULL
    DROP VIEW StudentGrades
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

-- ======= Practice ========
--9.  Using the StudentGrades view, update the  mark for studentID 199899200 in course dmit152 to be 90.
-- TODO: Student Answer Here...

--10. Using the StudentGrades view, see if you can delete the same record from the previous question.
--    If it doesn't work, then copy the error message here.
-- TODO: Student Answer Here...
