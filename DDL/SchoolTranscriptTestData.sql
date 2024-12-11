/*  TEST DATA
    Having test data that we can insert into our database tables
    will help us to ensure that our CREATE TABLE and ALTER TABLE statements
    are running correctly.
*/

-- Database scripts execute within a certain context - a specific database.
SELECT DB_NAME() AS 'Initial Database'  -- should be [master] when first executed
GO
-- We can change the context through the USE statement,ensuring that we're inside the correct database
USE [SchoolTranscript]  -- Switch to the desired database
GO  -- The GO keyword tells the database server to GO ahead and make these changes
SELECT DB_NAME() AS 'Active Database'   -- shows that we are in the correct database
GO


/*=== Start of Test Data ===*/

-- Add a single student (DML statement)
INSERT INTO Students(GivenName, Surname, DateOfBirth, Enrolled)
VALUES  ('Sara', 'Bellum', 'Aug 1, 2005', 1)

-- Add multiple students (with default constraints)
INSERT INTO Students(GivenName, Surname, DateOfBirth)
VALUES  ('Oliver', 'Nerr', 'April 1, 2001'), -- O. Nerr
        ('Stewart', 'Dent', 'July 23, 2003'), -- Stew Dent
        ('Yu', 'Sur', 'Feb 29, 2000'),
        ('Anne', 'Other', 'Nov 3, 2004'),
        ('Dee', 'Vellop-Ur', 'Dec 4, 1999')

/*
-- Add these students after altering the table constraints
INSERT INTO Students(GivenName, MiddleNames, Surname, DateOfBirth)
VALUES  ('Reginald', 'Ian', 'Stirr', 'Aug 1, 2005') -- Reg I. Stirr
*/

-- Explore the results (Query statement)
SELECT * FROM Students


/*
-- Samples of "bad" data (violates CHECK constraints)
INSERT INTO Students(GivenName, Surname, DateOfBirth, Enrolled)
VALUES  ('B', '4', 'Aug 20, 2025', 1) -- Bad GivenName and Surname

INSERT INTO Students(GivenName, Surname, DateOfBirth)
VALUES  ('Oh', 'No', 'Feb 5, 2045') -- This is a bad date

*/


/* Lots of Courses */

INSERT INTO Courses ([Number], [Name], Credits, [Hours], Active, Cost)
VALUES  ('PROG-1001', 'Introduction to Programming', 3.0, 60, 1, 500.00),
        ('PROG-1002', 'Data Structures', 4.5, 75, 1, 750.00),
        ('PROG-1003', 'Database Systems', 3.0, 60, 1, 500.00),
        ('PROG-1004', 'Web Development', 4.5, 75, 1, 750.00),
        ('PROG-1005', 'Software Engineering', 6.0, 90, 1, 1000.00),
        ('PROG-1506', 'Operating Systems', 3.0, 60, 1, 500.00),
        ('PROG-1507', 'Computer Networks', 4.5, 75, 1, 750.00),
        ('PROG-1508', 'Algorithms', 6.0, 90, 1, 1000.00),
        ('PROG-1509', 'Mobile App Development', 3.0, 60, 1, 500.00),
        ('PROG-1510', 'Cyber Security', 4.5, 75, 1, 750.00),
        ('PROG-2011', 'Cloud Computing', 6.0, 90, 1, 1000.00),
        ('PROG-2012', 'Artificial Intelligence', 3.0, 60, 1, 500.00),
        ('PROG-2013', 'Machine Learning', 4.5, 75, 1, 750.00),
        ('PROG-2014', 'Big Data Analytics', 6.0, 90, 1, 1000.00),
        ('PROG-2015', 'Human-Computer Interaction', 3.0, 60, 1, 500.00),
        ('PROG-2516', 'Software Testing', 4.5, 75, 1, 750.00),
        ('PROG-2517', 'DevOps', 6.0, 90, 1, 1000.00),
        ('PROG-2518', 'Game Development', 3.0, 60, 1, 500.00),
        ('PROG-2519', 'Blockchain Technology', 4.5, 75, 1, 750.00),
        ('PROG-2520', 'Ethical Hacking', 6.0, 90, 1, 1000.00)


/* More Students! */
INSERT INTO Students (GivenName, Surname, DateOfBirth)
VALUES  ('Alice', 'Smith', '2001-01-15'),
        ('Bob', 'Johnson', '2001-05-22'),
        ('Charlie', 'Williams', '2002-03-10'),
        ('David', 'Brown', '2002-07-18'),
        ('Edward', 'Jones', '2003-02-25'),
        ('Frank', 'Garcia', '2003-11-30'),
        ('George', 'Martinez', '2004-04-12'),
        ('Henry', 'Rodriguez', '2004-08-05'),
        ('Isaac', 'Lee', '2005-06-14'),
        ('Jack', 'Walker', '2005-09-23'),
        ('Kevin', 'Hall', '2006-01-09'),
        ('Larry', 'Allen', '2006-05-17'),
        ('Michael', 'Young', '2006-10-21'),
        ('Nathan', 'Hernandez', '2007-03-03'),
        ('Oliver', 'King', '2007-07-29'),
        ('Peter', 'Wright', '2007-12-11'),
        ('Quincy', 'Lopez', '2008-02-19'),
        ('Robert', 'Hill', '2008-06-06'),
        ('Samuel', 'Scott', '2008-09-15'),
        ('Thomas', 'Green', '2008-12-30'),
        ('Ulysses', 'Adams', '2001-04-04'),
        ('Victor', 'Baker', '2001-08-20'),
        ('William', 'Gonzalez', '2002-11-02'),
        ('Xavier', 'Nelson', '2003-01-27'),
        ('Yuri', 'Carter', '2003-05-13'),
        ('Zachary', 'Mitchell', '2004-09-08'),
        ('Aaron', 'Perez', '2005-12-19'),
        ('Brian', 'Roberts', '2006-03-07'),
        ('Chris', 'Turner', '2006-07-25'),
        ('Daniel', 'Phillips', '2007-11-14')

GO
/* Modifying the Courses data to fit a pattern for the semester*/
UPDATE  Courses
SET     Semester = 1
WHERE   [Number] LIKE '_____10%'

UPDATE  Courses
SET     Semester = 2
WHERE   [Number] LIKE '_____15%'

UPDATE  Courses
SET     Semester = 3
WHERE   [Number] LIKE '_____20%'

UPDATE  Courses
SET     Semester = 4
WHERE   [Number] LIKE '_____25%'

/*
SELECT * FROM Students
SELECT * FROM Courses
*/