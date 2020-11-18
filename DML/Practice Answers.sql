/* Answers to Practice DML Questions
 *************************************************/

/* ===============================
   |  A - Insert.sql             |
   ------------------------------- */
-- 2.c. We have an open position in the staff.
SELECT  PositionDescription
FROM    Position
WHERE   PositionID NOT IN (SELECT PositionID FROM Staff)
--      Add Sheldon Murray as the new Assistant Dean.
-- TODO: Student Answer Here....

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

/* ===============================
   |  B - Update.sql             |
   ------------------------------- */
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
UPDATE Registration
SET    WithdrawYN = 'Y'
WHERE  StudentID = 200688700

-- 7. Bonus Time! Update the marks of all the students in the DMIT152 course by
--    increasing their marks by 5%. Check the database before and after doing
--    the update to verify if the changes were correct.
-- SELECT StudentID, Mark FROM Registration WHERE CourseId = 'DMIT152'
UPDATE Registration
SET    Mark = Mark * 1.05
WHERE  CourseId = 'DMIT152'
-- SELECT StudentID, Mark FROM Registration WHERE CourseId = 'DMIT152'

--9.  Using the StudentGrades view, update the  mark for studentID 199899200 in course dmit152 to be 90.
-- TODO: Student Answer Here...
UPDATE StudentGrades
SET    Mark = 90
WHERE  StudentID = 199899200
  AND  CourseId = 'DMIT152'

--10. Using the StudentGrades view, see if you can delete the same record from the previous question.
--    If it doesn't work, then copy the error message here.
-- TODO: Student Answer Here...
DELETE StudentGrades
WHERE  StudentID = 199899200
  AND  CourseId = 'DMIT152'
-- Msg 4405, Level 16, State 1, Line 1
-- View or function 'StudentGrades' is not updatable because the modification affects multiple base tables.

/* ===============================
   |  C - Delete.sql             |
   ------------------------------- */
-- 4. The school is resetting all inactive clubs. Remove those clubs without members (use a subquery).
-- TODO: Student Answer Here...
DELETE FROM Club
WHERE  ClubID NOT IN (SELECT ClubId FROM Activity)
