/* Answers to Practice Stored Procedures Questions
 *************************************************/
USE [A0X-School]
GO
SELECT DB_NAME() AS 'Active Database'
GO

/* ===============================
   |  A - Stored Procedures.sql  |
   ------------------------------- */

--6. Create a stored procedure called "Provinces" to list all the students provinces.

--7. OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.

--8. Create a stored procedure called StudentPaymentTypes that lists all the student names and their payment types. Ensure all the student names are listed, including those who have not yet made a payment.

--9. Modify the procedure from question 8 to return only the student names that have made payments.

GO

/* ===============================
   |  B - Stored Procedures.sql  |
   ------------------------------- */

-- 5. Create a stored procedure that will remove a student from a club. Call it RemoveFromClub.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS RemoveFromClub
GO
CREATE PROCEDURE RemoveFromClub
    @StudentId      int
AS
    IF @StudentId IS NULL
        RAISERROR('StudentId is required', 16, 1)
    ELSE
        DELETE FROM Student
        WHERE  StudentID = @StudentId
RETURN
GO

-- Query-based Stored Procedures
-- 6. Create a stored procedure that will display all the staff and their position in the school.
--    Show the full name of the staff member and the description of their position.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS ListStaff
GO
CREATE PROCEDURE ListStaff
AS
    SELECT  FirstName + '  ' + LastName AS 'StaffMember', PositionDescription
    FROM    Staff AS S
        INNER JOIN Position AS P ON S.PositionID = p.PositionID
RETURN
GO

-- 7. Display all the final course marks for a given student. Include the name and number of the course
--    along with the student's mark.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS GetStudentMarks
GO
CREATE PROCEDURE GetStudentMarks
    @StudentId      int
AS
    IF @StudentId IS NULL
        RAISERROR('StudentId is required', 16, 1)
    ELSE
        SELECT  C.CourseId, C.CourseName, Mark
        FROM    Registration AS R
            INNER JOIN Course AS C ON R.CourseId = C.CourseId
        WHERE   Mark IS NOT NULL
RETURN
GO

-- 8. Display the students that are enrolled in a given course on a given semester.
--    Display the course name and the student's full name and mark.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS SprocName
GO
CREATE PROCEDURE SprocName
    @CourseNumber   char(7),
    @Semester       char(5)
AS
    IF @CourseNumber IS NULL OR @Semester IS NULL
        RAISERROR('Course Number and Semester are required', 16, 1)
    ELSE
        SELECT  CourseName,
                FirstName + ' ' + LastName AS 'Student',
                Mark
        FROM    Student AS S
            INNER JOIN Registration AS R
                ON R.StudentID = S.StudentID
            INNER JOIN Course AS C
                ON R.CourseId = C.CourseId
        WHERE   R.CourseId = @CourseNumber
          AND   Semester = @Semester
RETURN
GO

-- 9. The school is running out of money! Find out who still owes money for the courses they are enrolled in.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS ListOutstandingBalances
GO
CREATE PROCEDURE ListOutstandingBalances
AS
    SELECT  FirstName + ' ' + LastName AS 'Student', BalanceOwing
    FROM    Student
    WHERE   BalanceOwing > 0
RETURN
GO

/* ===============================
   |  C - Stored Procedures.sql  |
   ------------------------------- */
-- Take the following queries and turn them into stored procedures.

-- 1.   Selects the studentID's, CourseID and mark where the Mark is between 70 and 80
--      Place this in a stored procedure that has two parameters,
--      one for the upper value and one for the lower value.
--      Call the stored procedure ListStudentMarksByRange
GO
DROP PROCEDURE IF EXISTS ListStudentMarksByRange
GO
CREATE PROCEDURE ListStudentMarksByRange
    @lower  decimal,
    @upper  decimal
AS
    SELECT  StudentID, CourseId, Mark
    FROM    Registration
    WHERE   Mark BETWEEN @lower AND @upper -- BETWEEN is inclusive
RETURN
GO

-- Testing
--  Good inputs
EXEC ListStudentMarksByRange 70, 80
--  Bad inputs
EXEC ListStudentMarksByRange 80, 70
EXEC ListStudentMarksByRange 70, NULL
EXEC ListStudentMarksByRange NULL, 80
EXEC ListStudentMarksByRange NULL, NULL
EXEC ListStudentMarksByRange -5, 80
EXEC ListStudentMarksByRange 70, 101 -- Specifically checking the upper limit

--  Alter the stored procedure to handle validation of inputs
GO
ALTER PROCEDURE ListStudentMarksByRange
    @Lower  decimal,
    @Upper  decimal
AS
    IF @Lower IS NULL OR @Upper IS NULL
        RAISERROR('Lower and Upper values are required and cannot be null', 16, 1)
    ELSE IF @Lower > @Upper
        RAISERROR('The lower limit cannot be larger than the upper limit', 16, 1)
    ELSE IF @Lower < 0
        RAISERROR('The lower limit cannot be less than zero', 16, 1)
    ELSE IF @Upper > 100
        RAISERROR('The upper limit cannot be greater than 100', 16, 1)
    ELSE
        SELECT  StudentID, CourseId, Mark
        FROM    Registration
        WHERE   Mark BETWEEN @Lower AND @Upper -- BETWEEN is inclusive
RETURN
GO

/* ----------------------------------------------------- */

-- 2.   Selects the Staff full names and the Course ID's they teach.
--      Place this in a stored procedure called ListCourseInstructors.
DROP PROCEDURE IF EXISTS ListCourseInstructors
GO
CREATE PROCEDURE ListCourseInstructors
AS
    SELECT  DISTINCT -- The DISTINCT keyword will remove duplate rows from the results
            FirstName + ' ' + LastName AS 'Staff Full Name',
            CourseId
    FROM    Staff S
        INNER JOIN Registration R
            ON S.StaffID = R.StaffID
    ORDER BY 'Staff Full Name', CourseId
RETURN
GO



/* ----------------------------------------------------- */

-- 3.   Selects the students first and last names who have last names starting with S.
--      Place this in a stored procedure called FindStudentByLastName.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable;
--      Your solution should concatenate the @PartialName with the wildcard.
DROP PROCEDURE IF EXISTS FindStudentByLastName
GO
CREATE PROCEDURE FindStudentByLastName
    @PartialName    varchar(35)
AS
    SELECT  FirstName, LastName
    FROM    Student
    WHERE   LastName LIKE @PartialName + '%'
RETURN
GO


/* ----------------------------------------------------- */

-- 4.   Selects the CourseID's and Coursenames where the CourseName contains the word 'programming'.
--      Place this in a stored procedure called FindCourse.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable.
DROP PROCEDURE IF EXISTS FindCourse
GO
CREATE PROCEDURE FindCourse
    @PartialName    varchar(40)
AS
    SELECT  CourseId, CourseName
    FROM    Course
    WHERE   CourseName LIKE '%programming%'
RETURN
GO


/* ----------------------------------------------------- */

-- 5.   Selects the Payment Type Description(s) that have the highest number of Payments made.
--      Place this in a stored procedure called MostFrequentPaymentTypes.
DROP PROCEDURE IF EXISTS MostFrequentPaymentTypes
GO
CREATE PROCEDURE MostFrequentPaymentTypes
AS
    SELECT PaymentTypeDescription
    FROM   Payment 
        INNER JOIN PaymentType 
            ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
    GROUP BY PaymentTypeDescription 
    HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                    FROM Payment 
                                                    GROUP BY PaymentTypeID)
RETURN
GO

/* ----------------------------------------------------- */

-- 6.   Selects the current staff members that are in a particular job position.
--      Place this in a stored procedure called StaffByPosition
DROP PROCEDURE IF EXISTS StaffByPosition
GO
CREATE PROCEDURE StaffByPosition
    @Description    varchar(50)
AS
    SELECT  FirstName + ' ' + LastName AS 'StaffFullName'
    FROM    Position P
        INNER JOIN Staff S ON S.PositionID = P.PositionID
    WHERE   DateReleased IS NULL
    AND   PositionDescription = @Description
RETURN
GO

/* ----------------------------------------------------- */

-- 7.   Selects the staff members that have taught a particular course (e.g.: 'DMIT101').
--      This select should also accommodate inputs with wildcards. (Change = to LIKE)
--      Place this in a stored procedure called StaffByCourseExperience
DROP PROCEDURE IF EXISTS SprocName
GO
CREATE PROCEDURE SprocName
    @CourseId   varchar(7)
AS
    SELECT  DISTINCT FirstName + ' ' + LastName AS 'StaffFullName',
            CourseId
    FROM    Registration R
        INNER JOIN Staff S ON S.StaffID = R.StaffID
    WHERE   DateReleased IS NULL
    AND   CourseId LIKE '%' + @CourseId + '%'
RETURN
GO

/* ===============================
   |  D - Stored Procedures.sql  |
   ------------------------------- */

-- 4) Create a stored procedure called OverActiveMembers that takes a single number: ClubCount. This procedure should return the names of all members that are active in as many or more clubs than the supplied club count.
--    (p.s. - You might want to make sure to add more members to more clubs, seeing as tests for the last question might remove a lot of club members....)
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS OverActiveMembers
GO
CREATE PROCEDURE OverActiveMembers
    @ClubCount  int
AS
    IF @ClubCount IS NULL OR @ClubCount < 0
        RAISERROR('ClubCount cannot be negative', 16, 1)
    ELSE
        SELECT  FirstName, LastName
        FROM    Student
        WHERE   StudentID IN
                (SELECT StudentID FROM ACTIVITY
                 GROUP BY StudentID HAVING COUNT(StudentID) >= @ClubCount)
RETURN
GO
-- Testing
SELECT StudentID, COUNT(ClubID) FROM Activity GROUP BY StudentID
EXEC OverActiveMembers 2
EXEC OverActiveMembers 3
EXEC OverActiveMembers 1
EXEC OverActiveMembers 0
EXEC OverActiveMembers NULL
GO

-- 5) Create a stored procedure called ListStudentsWithoutClubs that lists the full names of all students who are not active in a club.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS ListStudentsWithoutClubs
GO
CREATE PROCEDURE ListStudentsWithoutClubs
AS
    SELECT  FirstName + ' ' + LastName AS 'FullName'
    FROM    Student
    WHERE   StudentID NOT IN (SELECT DISTINCT StudentID FROM Activity)
RETURN
GO
EXEC ListStudentsWithoutClubs
GO

-- 6) Create a stored procedure called LookupStudent that accepts a partial student last name and returns a list of all students whose last name includes the partial last name. Return the student first and last name as well as their ID.
-- TODO: Student Answer Here
DROP PROCEDURE IF EXISTS LookupStudent
GO
CREATE PROCEDURE LookupStudent
    @PartialLastName    varchar(35)
AS
    IF @PartialLastName IS NULL OR LEN(@PartialLastName) = 0
        RAISERROR('Partial last name is required an must be at least a single character', 16, 1)
    ELSE
        SELECT  FirstName, LastName, StudentID
        FROM    Student
        WHERE   LastName LIKE '%' + @PartialLastName + '%'
RETURN
GO
EXEC LookupStudent 'oo'
EXEC LookupStudent ''
EXEC LookupStudent NULL
GO

/* ===============================
   |  E - Stored Procedures.sql  |
   ------------------------------- */

-- 2. Create a stored procedure called DissolveClub that will accept a club id as its parameter. Ensure that the club exists before attempting to dissolve the club. You are to dissolve the club by first removing all the members of the club and then removing the club itself.
--    - Delete of rows in the Activity table
--    - Delete of rows in the Club table
DROP PROCEDURE IF EXISTS DissolveClub
GO
CREATE PROCEDURE DissolveClub
    -- Parameters here
    @ClubId     varchar(10)
AS
    -- Validatation:
    -- A) Make sure the ClubId is not null
    IF @ClubId IS NULL
    BEGIN
        RAISERROR('ClubId is required', 16, 1)
    END
    ELSE
    BEGIN
        -- B) Make sure the Club exists
        IF NOT EXISTS(SELECT ClubId FROM Club WHERE ClubId = @ClubId)
        BEGIN
            RAISERROR('That club does not exist', 16, 1)
        END
        ELSE
        BEGIN
            -- Transaction:
            BEGIN TRANSACTION -- Starts the transaction - everything is temporary
            -- 1) Remove members of the club (from Activity)
            DELETE FROM Activity WHERE ClubId = @ClubId
            -- Remember to do a check of your global variables to see if there was a problem
            IF @@ERROR <> 0 -- then there's a problem with the delete, no need to check @@ROWCOUNT
            BEGIN
                ROLLBACK TRANSACTION -- Ending/undoing any temporary DML statements
                RAISERROR('Unable to remove members from the club', 16, 1)
            END
            ELSE
            BEGIN
                -- 2) Remove the club
                DELETE FROM Club WHERE ClubId = @ClubId
                IF @@ERROR <> 0 OR @@ROWCOUNT = 0 -- there's a problem
                BEGIN
                    ROLLBACK TRANSACTION
                    RAISERROR('Unable to delete the club', 16, 1)
                END
                ELSE
                BEGIN
                    COMMIT TRANSACTION -- Finalize all the temporary DML statement
                END
            END
        END
    END
RETURN
GO

-- Test my stored procedure
-- SELECT * FROM Club
-- SELECT * FROM Activity
EXEC DissolveClub 'CSS'
EXEC DissolveClub 'NASA1'
EXEC DissolveClub 'WHA?'
GO

-- 9. Create a stored procedure called ArchivePayments. This stored procedure must transfer all payment records to the StudentPaymentArchive table. After archiving, delete the payment records.
DROP TABLE IF EXISTS StudentPaymentArchive
GO
CREATE TABLE StudentPaymentArchive
(
    ArchiveId       int
        CONSTRAINT PK_StudentPaymentArchive
        PRIMARY KEY
        IDENTITY(1,1)
                                NOT NULL,
    StudentID       int         NOT NULL,
    FirstName       varchar(25) NOT NULL,
    LastName        varchar(35) NOT NULL,
    PaymentMethod   varchar(40) NOT NULL,
    Amount          money       NOT NULL,
    PaymentDate     datetime    NOT NULL
)
GO

DROP PROCEDURE IF EXISTS ArchivePayments
GO

CREATE PROCEDURE ArchivePayments
AS
    BEGIN TRANSACTION
    INSERT INTO StudentPaymentArchive(StudentID, FirstName, LastName, PaymentMethod, Amount, PaymentDate)
    SELECT S.StudentID, FirstName, LastName, PaymentTypeDescription, Amount, PaymentDate
    FROM   Student AS S
        INNER JOIN Payment AS P ON S.StudentID = P.StudentID
        INNER JOIN PayemtnType AS PT ON P.PaymentTypeID = PT.PaymentTypeID
    IF @@ERROR <> 0 OR @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Unable to create archive records', 16, 1)
        ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
        DELETE  Payment
        IF @@ERROR <> 0 OR @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Unable to remove all payment records', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        BEGIN
            COMMIT TRANSACTION
        END
    END
RETURN
GO

-- 10. In response to recommendations in our business practices, we are required to create an audit record of all changes to the Payment table. As such, all updates and deletes from the payment table will have to be performed through stored procedures rather than direct table access. For these stored procedures, you will need to use the following PaymentHistory table.
DROP TABLE IF EXISTS PaymentHistory
GO
CREATE TABLE PaymentHistory
(
    AuditID         int
        CONSTRAINT PK_PaymentHistory
        PRIMARY KEY
        IDENTITY(10000,1)
                                NOT NULL,
    PaymentID       int         NOT NULL,
    PaymentDate     datetime    NOT NULL,
    PriorAmount     money       NOT NULL,
    PaymentTypeID   tinyint     NOT NULL,
    StudentID       int         NOT NULL,
    DMLAction       char(6)     NOT NULL
        CONSTRAINT CK_PaymentHistory_DMLAction
            CHECK  (DMLAction IN ('UPDATE', 'DELETE'))
)
GO

-- 10.a. Create a stored procedure called UpdatePayment that has a parameter to match each column in the Payment table. This stored procedure must first record the specified payment's data in the PaymentHistory before applying the update to the Payment table itself.
DROP PROCEDURE IF EXISTS UpdatePayment
GO

CREATE PROCEDURE UpdatePayment
    @PaymentID      int,
    @PaymentDate    datetime,
    @Amount         money,
    @PaymentTypeID  int,
    @StudentID      int
AS
    IF @PaymentID IS NULL OR @PaymentDate IS NULL OR @Amount IS NULL OR @PaymentTypeID IS NULL OR @StudentID IS NULL
    BEGIN
        RAISERROR('All parameters are required', 16, 1)
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION
        INSERT INTO PaymentHistory(PaymentID, PaymentDate, PriorAmount, PaymentTypeID, StudentID, DMLAction)
        SELECT PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID, 'UPDATE'
        FROM   Payment
        WHERE  PaymentID = @PaymentID
        IF @@ERROR <> 0 OR @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Unable to create audit record - aborting payment update', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        BEGIN
            UPDATE  Payment
            SET     PaymentDate = @PaymentDate,
                    Amount = @Amount,
                    PaymentTypeID = @PaymentTypeID,
                    StudentID = @StudentID
            WHERE   PaymentID = @PaymentID
            IF @@ERROR <> 0 OR @@ROWCOUNT = 0
            BEGIN
                RAISERROR('Unable to update payment record', 16, 1)
                ROLLBACK TRANSACTION
            END
            ELSE
            BEGIN
                COMMIT TRANSACTION
            END
        END
    END
RETURN
GO

-- 10.b. Create a stored procedure called DeletePayment that has a parameter identifying the payment ID and the student ID. This stored procedure must first record the specified payment's data in the PaymentHistory before removing the payment from the Payment table.
DROP PROCEDURE IF EXISTS DeletePayment
GO

CREATE PROCEDURE DeletePayment
    @PaymentID      int,
    @StudentID      int
AS
    IF @PaymentID IS NULL OR @StudentID IS NULL
    BEGIN
        RAISERROR('All parameters are required', 16, 1)
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION
        INSERT INTO PaymentHistory(PaymentID, PaymentDate, PriorAmount, PaymentTypeID, StudentID, DMLAction)
        SELECT PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID, 'DELETE'
        FROM   Payment
        WHERE  PaymentID = @PaymentID
        IF @@ERROR <> 0 OR @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Unable to create audit record - aborting payment deletion', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        BEGIN
            DELETE  Payment
            WHERE   PaymentID = @PaymentID
            IF @@ERROR <> 0 OR @@ROWCOUNT = 0
            BEGIN
                RAISERROR('Unable to remove payment record', 16, 1)
                ROLLBACK TRANSACTION
            END
            ELSE
            BEGIN
                COMMIT TRANSACTION
            END
        END
    END
RETURN
GO

