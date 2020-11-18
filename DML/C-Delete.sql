-- Delete Examples
USE [A01-School]
GO -- Execute the code up to this point as a single batch

-- Delete examples
-- 1. A scandal has rocked the CSS club. The president has run off with all the
--    club's money. As such, the club is disbanded. Remove all the members of the
--    CSS club.
-- SELECT * FROM Activity order by ClubID
DELETE FROM Activity
WHERE  ClubID = 'CSS'

-- 2. The probe into the CSS club scandal is complete. Remove the club from the Club table.
DELETE FROM Club
WHERE  ClubID = 'CSS'

-- SELECT * FROM Club AS C LEFT OUTER JOIN Activity AS A ON A.ClubId = C.ClubId

-- 3. The student "Flying Nun" has withdrawn from the school. Remove this student from all clubs they are participating in.
DELETE FROM Activity
WHERE  StudentID IN (SELECT StudentID
                     FROM Student
                     WHERE FirstName = 'Flying'
                       AND LastName = 'Nun')

-- 4. The school is resetting all inactive clubs. Remove those clubs without members (use a subquery).
-- TODO: Student Answer Here...
DELETE FROM Club
WHERE  ClubID NOT IN (SELECT ClubId FROM Activity)

