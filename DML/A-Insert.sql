-- Insert Examples
USE [A0X-School]
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
WHERE  PositionDescription = 'Instructor' -- There should only be 1 row

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
INSERT INTO Student(FirstName, LastName, Gender, Birthdate, StreetAddress, City, Province, PostalCode)
VALUES ('Nevaeh', 'Bell', 'F', '07/03/1997', '9516 W Dallas St', 'Red Deer', 'AB', 'T3G9R7'),
       -- https://randomuser.me/api/portraits/women/64.jpg
       ('Vivan', 'Morgan', 'F', '08/03/1996', '2343 Mockingbird Ln', 'Edmonton', 'AB', 'T4W2S1'),
       -- https://randomuser.me/api/portraits/women/25.jpg
       ('Ryan', 'Warren', 'M', '05/04/2001', '6609 Rolling Green Rd', 'Edmonton', 'AB', 'T4K1O1')
       -- https://randomuser.me/api/portraits/men/81.jpg


-- 5. Enroll each of the students you've added into the DMIT777 course.
--    Use 'Dan Gilleland' as the instructor. At this point, their marks should be NULL.
-- HINT - Given the wording of this question, be sure to use some kind of subquery in your answer.
-- TODO: Student Answer Here....
INSERT INTO Registration(CourseId, Semester,StudentID, StaffID)
SELECT 'DMIT777', '2020S', StudentID, (SELECT StaffID
                                       FROM Staff
                                       WHERE FirstName = 'Dan' AND LastName = 'Gilleland')
FROM   Student
WHERE (FirstName = 'Nevaeh' AND LastName = 'Bell' AND Birthdate = '07/03/1997')
   OR (FirstName = 'Vivan' AND LastName = 'Morgan' AND Birthdate = '08/03/1996')
   OR (FirstName = 'Ryan' AND LastName = 'Warren' AND Birthdate = '05/04/2001')

