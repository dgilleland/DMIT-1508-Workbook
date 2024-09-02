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
GO

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

-- 11. Change the Registration_ClassSizeLimit trigger so students will be added to a wait list if the course is already full; make sure the student is not added to Registration, and include a message that the student has been added to a waitlist. You should design a WaitList table to accommodate the changes needed for adding a student to the course once space is freed up for the course. Students should be added on a first-come-first-served basis (i.e. - include a timestamp in your WaitList table)
-- Step 1) Make the WaitList table
DROP TABLE IF EXISTS WaitList
GO
CREATE TABLE WaitList
(
    LogID           int  IDENTITY (1,1) NOT NULL CONSTRAINT PK_BalanceOwingLog PRIMARY KEY,
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
        ROLLBACK TRANSACTION
    END
RETURN
GO

-- 12. (Advanced) Create a trigger called Registration_AutomaticEnrollment that will add students from the wait list of a course whenever another student withdraws from that course. Pull your students from the WaitList table on a first-come-first-served basis.
