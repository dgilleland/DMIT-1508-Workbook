-- Insert Examples
USE [A01-School]
GO -- Execute the code up to this point as a single batch

/*  Notes:
    The syntax for the INSERT statement is

    INSERT INTO TableName(Comma, Separated, ListOf, ColumnNames)
    VALUES ('A', 'Value', 'Per', 'Column')

    The line above will insert a single row of data. Typically, this
    syntax is used for hard-coded values.
    To insert multiple rows of hard-coded values, follow this pattern:

    INSERT INTO TableName(Comma, Separated, ListOf, ColumnNames)
    VALUES ('A', 'Value', 'Per', 'Column'),
           ('Another', 'Row', 'Of', 'Values')
    
    When inserting values, you can use subqueries for individual values
    provided that the subquery returns a single value:
    
    INSERT INTO TableName(Comma, Separated, ListOf, ColumnNames)
    VALUES ('A', (SELECT SingleValue FROM SomeTable), 'Per', 'Column')

    Another syntax for the INSERT statement is to use a SELECT clause in place
    of the VALUES clause. This is used for zero-to-many possible rows to insert.

    INSERT INTO TableName(Comma, Separated, ListOf, ColumnNames)
    SELECT First, Second, Third, LastColumn
    FROM   SomeTable
*/

-- Insert Examples
-- 1. Let's add a new course called "Expert SQL". It will be a 90 hour course with a cost of $450.00
INSERT INTO Course(CourseId, CourseName, CourseHours, CourseCost)
VALUES ('DMIT777', 'Expert SQL', 90, 450.00)
-- SELECT * FROM Course

-- 2. Let's add a new staff member, someone who's really good at SQL
-- SELECT * FROM STAFF
INSERT INTO Staff(FirstName, LastName, DateHired, PositionID)
SELECT 'Dan', 'Gilleland', GETDATE(), PositionID
       --, PositionDescription
FROM   Position
WHERE  PositionDescription = 'Instructor'
-- 2b. Let's get another instructor
INSERT INTO Staff(FirstName, LastName, DateHired, PositionID)
VALUES ('Shane', 'Bell', GETDATE(), 
        (SELECT PositionID
        FROM   Position
        WHERE  PositionDescription = 'Instructor'))
-- 2.c. We have an open position in the staff.
SELECT  PositionDescription
FROM    Position
WHERE   PositionID NOT IN (SELECT PositionID FROM Staff)
--      Add Sheldon Murray as the new Assistant Dean.
-- TODO: Student Answer Here....

-- 3. There are three additional clubs being started at the school:
--      - START - Small Tech And Research Teams
--      - CALM - Coping And Lifestyle Management
--      - RACE - Rapid Acronym Creation Experts
--    SELECT * FROM Club
INSERT INTO Club(ClubId, ClubName)
VALUES ('START', 'Small Tech And Research Teams'),
       ('CALM', 'Coping And Lifestyle Management'),
       ('RACE', 'Rapid Acronym Creation Experts')

-- ======= Practice ========
-- 4. In your web browser, use https://randomuser.me/ to get information on three
--    people to add as new students. Write a separate insert statement for each new student.
-- TODO: Student Answer Here....
-- sp_help Student
-- TIP: When inserting into a datetime column, you can use a string and SQL Server
--      will convert it for you. E.g.: 'Jan 5, 2020'

-- 5. Enroll each of the students you've added into the DMIT777 course.
--    Use 'Dan Gilleland' as the instructor. At this point, their marks should be NULL.
-- HINT - Given the wording of this question, be sure to use some kind of subquery in your answer.
-- TODO: Student Answer Here....
