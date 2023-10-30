--Joins Exercise 1
USE [A0X-School]
GO
SELECT DB_NAME() AS 'Active Database'
GO


--1.	Select Student full names and the course ID's they are registered in.
SELECT  FirstName + ' ' + LastName AS 'Full Name',
        CourseId
FROM    Student -- Start the FROM statement by identifying one of the tables you want
    INNER JOIN Registration -- Identify another table you are connecting to
        -- ON is where we specify which columns should be used in the relationship
        ON Student.StudentID = Registration.StudentID

--1.a. Select Student full names, the course ID and the course name that the students are registered in.
SELECT  FirstName + ' ' + LastName AS 'FullName',
        C.CourseId,
        CourseName
FROM    Student AS S
    INNER JOIN Registration AS R
        ON S.StudentID = R.StudentID -- ON helps us identify MATCHING data
    INNER JOIN Course AS C
        ON R.CourseId = C.CourseId

--2.	Select the Staff full names and the Course ID's they teach.
--      Order the results by the staff name then by the course Id
SELECT  DISTINCT -- The DISTINCT keyword will remove duplate rows from the results
        FirstName + ' ' + LastName AS 'Staff Full Name',
        CourseId
FROM    Staff AS S
    INNER JOIN Registration AS R
        ON S.StaffID = R.StaffID
ORDER BY 'Staff Full Name', CourseId

--3.	Select all the Club ID's and the Student full names that are in them
-- TODO: Student Answer Here...


--4.	Select the Student full name, courseID's and marks for studentID 199899200.
SELECT  S.FirstName + ' ' + S.LastName AS 'Student Name',
        R.CourseId,
        R.Mark
FROM    Registration AS R
    INNER JOIN Student AS S
            ON S.StudentID = R.StudentID
WHERE   S.StudentID = 199899200

--5.	Select the Student full name, course names and marks for studentID 199899200.
-- TODO: Student Answer Here...


--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
-- TODO: Student Answer Here...


--7.	What Staff Full Names have taught Networking 1?
-- TODO: Student Answer Here...


--8.	What is the course list for student ID 199912010 in semester 2001S. Select the Students Full Name and the CourseNames
-- TODO: Student Answer Here...


--9. What are the Student Names, courseID's with individual Marks at 80% or higher? Sort the results by course.
-- TODO: Student Answer Here...


--10. Modify the script from the previous question to show the Course Name along with the ID.
-- TODO: Student Answer Here...

