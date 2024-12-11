/* Answers to Practice Triggers Questions
 *************************************************/
USE [A0X-School]
GO
SELECT DB_NAME() AS 'Active Database'
GO

/* ===============================
   |  A - Triggers.sql           |
   ------------------------------- */
-- 3.b. TODO: Write code to test this trigger by creating a stored procedure called RegisterStudent that puts a student in a course and then increases the balance owing by the cost of the course.
SELECT * FROM Student WHERE BalanceOwing > 0
-- sp_help Registration
GO
CREATE OR ALTER PROCEDURE RegisterStudent
    @StudentID      int,
    @CourseId       char(7),
    @Semester       char(5)
AS
    IF @StudentID IS NULL OR @CourseId IS NULL OR @Semester IS NULL
    BEGIN
        RAISERROR('StudentId, CourseId and Semester are required', 16, 1)
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION

        INSERT INTO Registration(StudentID, CourseId, Semester)
        VALUES (@StudentID, @CourseId, @Semester)

        IF @@ERROR <> 0
        BEGIN
            RAISERROR('Unable to register student in course', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        BEGIN
            DECLARE @Cost   money
            SET @Cost = (SELECT CourseCost FROM Course WHERE CourseId = @CourseId)

            UPDATE  Student
            SET     BalanceOwing = BalanceOwing + @Cost
            WHERE   StudentID = @StudentID

            IF @@ERROR <> 0
            BEGIN
                RAISERROR('Unable to charge student for course registration', 16, 1)
                ROLLBACK TRANSACTION
            END
            ELSE
            BEGIN
                COMMIT TRANSACTION
            END
        END
    END
GO

-- Now, let's have a student register in a lot of courses and see if the trigger's rollback gets fired.
-- First I need to find a student that I can add to courses...
SELECT * FROM STUDENT WHERE StudentId NOT IN (SELECT StudentId FROM Registration)
-- From this, I will select 200494476 (Joe Cool), and add them to some courses
SELECT * FROM Course
-- DMIT101, DMIT103, DMIT104, DMIT115, DMIT152, DMIT163, DMIT168, DMIT170, DMIT172, DMIT175, DMIT215
EXEC RegisterStudent 200494476, 'DMIT101', '2024S'
EXEC RegisterStudent 200494476, 'DMIT103', '2024S'
EXEC RegisterStudent 200494476, 'DMIT104', '2024S'
EXEC RegisterStudent 200494476, 'DMIT115', '2024S'
EXEC RegisterStudent 200494476, 'DMIT152', '2024S'
EXEC RegisterStudent 200494476, 'DMIT163', '2024S'
EXEC RegisterStudent 200494476, 'DMIT168', '2024S'
-- check balance...
SELECT [StudentID],[FirstName],[LastName],[BalanceOwing]
FROM Student WHERE StudentID = 200494476
EXEC RegisterStudent 200494476, 'DMIT170', '2024S'
EXEC RegisterStudent 200494476, 'DMIT172', '2024S'
EXEC RegisterStudent 200494476, 'DMIT175', '2024S'
-- THIS ONE should trigger the rejection
EXEC RegisterStudent 200494476, 'DMIT215', '2024S'


-- 5. The school has placed a temporary hold on the creation of any more clubs. (Existing clubs can be renamed or removed, but no additional clubs can be created.) Put a trigger on the Clubs table to prevent any new clubs from being created.
DROP TRIGGER IF EXISTS Club_Insert_Lockdown
GO

CREATE TRIGGER Club_Insert_Lockdown
ON Club
FOR Insert -- Choose only the DML statement(s) that apply
AS
    -- Body of Trigger
    IF @@ROWCOUNT > 0
    BEGIN
        RAISERROR('Temporary lockdown on creating new clubs.', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO
INSERT INTO Club(ClubId, ClubName) VALUES ('HACK', 'Honest Analyst Computer Knowledge')
GO

-- 8. The Registration table has a composite primary key. In order to ensure that parts of this key cannot be changed, write a trigger called Registration_ProtectPrimaryKey that will prevent changes to the primary key columns.
DROP TRIGGER IF EXISTS Registration_ProtectPrimaryKey
GO

CREATE TRIGGER Registration_ProtectPrimaryKey
ON Registration
FOR Update
AS
    IF UPDATE(StudentID) OR UPDATE(CourseID) OR UPDATE(Semester)
    BEGIN
        RAISERROR('Modifications to the composite primary key of Registration are not allowed', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO

-- 9. Create a trigger to ensure that an instructor does not teach more than 3 courses in a given semester.
DROP TRIGGER IF EXISTS Registration_InstructorLoad
GO

CREATE TRIGGER Registration_InstructorLoad
ON Registration
FOR Insert, Update
AS
    IF  @@ROWCOUNT > 0 AND
        EXISTS( Select  S.StaffID
                FROM    Staff AS S
                    INNER JOIN Registration AS R ON S.StaffID = R.StaffID   -- Joining with Registration to get staff teaching load
                WHERE   R.Semester IN (SELECT Semester FROM inserted)       -- Filter for only those semesters that are affected by trigger
                AND     S.StaffID IN (SELECT StaffID FROM inserted)         -- Filter for only those staff that are affected by trigger
                GROUP BY S.StaffID, R.Semester
                HAVING  COUNT(R.StaffID) > 3)
    BEGIN
        RAISERROR('Staff cannot be assigned more than 3 courses in a given semester', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO

-- 10. Create a trigger to ensure that students cannot be added to a course if the course is already full.
DROP TRIGGER IF EXISTS Registration_ClassSizeLimit
GO

CREATE TRIGGER Registration_ClassSizeLimit
ON Registration
FOR Insert
AS
    IF  @@ROWCOUNT > 0 AND
        EXISTS( SELECT  COUNT(R.StudentID)
                FROM    Course AS C
                    INNER JOIN Registration AS R ON R.CourseId = C.CourseId
                    -- Note that the join below is only on the course and semester, because that's how
                    -- we're interested in grouping to solve this particular question.
                    INNER JOIN Inserted AS I ON I.CourseId = R.CourseId AND I.Semester = R.Semester
                WHERE   R.WithdrawYN <> 'Y' -- Don't count those students who have withdrawn                            
                GROUP BY R.CourseId, R.Semester, C.MaxStudents
                HAVING  COUNT(R.StudentID) > C.MaxStudents)
    BEGIN
        RAISERROR('Student registration cancelled - class is full', 16, 1)
        ROLLBACK TRANSACTION
    END
RETURN
GO
-- We can explore what data is available in our database to build up some test data
SELECT * FROM Course
    -- Let's use 'DMIT259'
SELECT * FROM Student
    -- Let's use 200122100, 200011730, and 199912010
SELECT * FROM Staff
    -- Let's use 1 - Donna Bookem
UPDATE Student SET BalanceOwing = 0; -- to clean up any potential problems of registering our students....


INSERT INTO Registration(CourseId, StudentID, Semester, StaffID)
VALUES  ('DMIT259',200122100,'2024S',1)
INSERT INTO Registration(CourseId, StudentID, Semester, StaffID)
VALUES  ('DMIT259',200011730,'2024S',1)
-- The next one should be one too many
INSERT INTO Registration(CourseId, StudentID, Semester, StaffID)
VALUES  ('DMIT259',199912010,'2024S',1)
SELECT * FROM REGISTRATION WHERE CourseId = 'DMIT259' AND Semester = '2024S'
-- Here we can cleanup
DELETE FROM REGISTRATION WHERE CourseId = 'DMIT259' AND Semester = '2024S'
GO
-- 11. Change the Registration_ClassSizeLimit trigger so students will be added to a wait list if the course is already full; make sure the student is not added to Registration, and include a message that the student has been added to a waitlist. You should design a WaitList table to accommodate the changes needed for adding a student to the course once space is freed up for the course. Students should be added on a first-come-first-served basis (i.e. - include a timestamp in your WaitList table)
-- Step 1) Make the WaitList table
DROP TABLE IF EXISTS WaitList
GO
CREATE TABLE WaitList
(
    LogID           int  IDENTITY (1,1) NOT NULL CONSTRAINT PK_WaitListLogID PRIMARY KEY,
    StudentID       int                 NOT NULL,
    CourseID        char(7)             NOT NULL,
    Semester        char(5)             NOT NULL,
    AddedOn         datetime            NOT NULL
)
GO
-- Step 2) Modify the trigger
ALTER TRIGGER Registration_ClassSizeLimit
ON Registration
FOR Insert
AS
    IF  @@ROWCOUNT > 0 AND
        EXISTS( SELECT  COUNT(R.StudentID)
                FROM    Course AS C
                    INNER JOIN Registration AS R ON R.CourseId = C.CourseId
                    -- Note that the join below is only on the course and semester, because that's how
                    -- we're interested in grouping to solve this particular question.
                    INNER JOIN Inserted AS I ON I.CourseId = R.CourseId AND I.Semester = R.Semester
                GROUP BY R.CourseId, R.Semester, C.MaxStudents
                HAVING  COUNT(R.StudentID) > C.MaxStudents)
    BEGIN
        RAISERROR('Student registration cancelled - class is full', 16, 1)
        INSERT INTO WaitList(StudentID, CourseID, Semester, AddedOn)
        SELECT StudentID, CourseID, Semester, GETDATE()
        FROM   inserted
        
        DELETE R FROM Registration AS R
        INNER JOIN inserted AS I 
            ON  I.StudentID = R.StudentID 
            AND I.CourseId = R.CourseId 
            AND I.Semester = R.Semester
    END
RETURN
GO
-- Let's try adding that last student again
INSERT INTO Registration(CourseId, StudentID, Semester, StaffID)
VALUES  ('DMIT259',199912010,'2024S',1)

SELECT * FROM WaitList

-- 12. (Advanced) Create a trigger called Registration_AutomaticEnrollment that will add students from the wait list of a course whenever another student withdraws from that course. Pull your students from the WaitList table on a first-come-first-served basis.
