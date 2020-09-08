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

-- 5. Enroll each of the students you've added into the DMIT777 course.
--    Use 'Dan Gilleland' as the instructor. At this point, their marks should be NULL.
-- HINT - Given the wording of this question, be sure to use some kind of subquery in your answer.
-- TODO: Student Answer Here....

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

-- 6. Choose a student from the previous question and withdraw them from all
--    of their courses.
-- TODO: Student Answer Here....

-- 7. Bonus Time! Update the marks of all the students in the DMIT152 course by
--    increasing their marks by 5%. Check the database before and after doing
--    the update to verify if the changes were correct.

--9.  Using the StudentGrades view, update the  mark for studentID 199899200 in course dmit152 to be 90.
-- TODO: Student Answer Here...

--10. Using the StudentGrades view, see if you can delete the same record from the previous question.
--    If it doesn't work, then copy the error message here.
-- TODO: Student Answer Here...


/* ===============================
   |  C - Delete.sql             |
   ------------------------------- */
-- 4. The school is resetting all inactive clubs. Remove those clubs without members (use a subquery).
-- TODO: Student Answer Here...
