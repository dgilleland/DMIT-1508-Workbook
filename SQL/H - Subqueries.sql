--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
--**If the questions could also be solved without a subquery, solve it without one as well**
USE [A0X-School]
GO

-- A Subquery is a query within a query. The inner-most query is called the subquery.
-- A subquery can appear in almost all clauses of the SELECT statement. For our purposes here,
-- they tend to appear in the WHERE clause or the HAVING clause.

--1. Select the Payment dates and payment amount for all payments that were Cash
SELECT PaymentDate, Amount
FROM   Payment
WHERE  PaymentTypeID = -- Using the = means that the RH side must be a single value
     -- Assuming that every PaymentTypeDescription will be UNIQUE,
     -- the following subquery will return a single column and a single row
    (SELECT PaymentTypeID
     FROM   PaymentType
     WHERE  PaymentTypeDescription = 'cash')
-- Here is the Inner Join version of the above
SELECT PaymentDate, Amount
FROM   Payment AS P
    INNER JOIN PaymentType AS PT
            ON PT.PaymentTypeID = P.PaymentTypeID
WHERE  PaymentTypeDescription = 'cash'


--2. Select The Student ID's of all the students that are in the 'Association of Computing Machinery' club
-- TODO: Student Answer Here
/*
SELECT * FROM Club
SELECT * FROM Activity
*/
-- Thinking of the subquery first, I can find out
-- what club ID matches for the given club name


--3. Select All the staff full names for staff that have taught a course.
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
WHERE  StaffID IN -- I used IN because the subquery returns many rows
    (SELECT DISTINCT StaffID FROM Registration)

-- The above can also be done as an INNER JOIN...
SELECT DISTINCT FirstName + ' ' + LastName AS 'Staff'
FROM Staff
    INNER JOIN Registration
        ON Staff.StaffID = Registration.StaffID 

--4. Select All the staff full names that taught DMIT172.
-- TODO: Student Answer Here

--4.b. Who has taught DMIT152?
-- TODO: Student Answer Here


--5. Select All the staff full names of staff that have never taught a course
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
WHERE  StaffID NOT IN -- I used IN because the subquery returns many rows
    (SELECT DISTINCT StaffID FROM Registration)

-- To do the above questions with a JOIN requires that we use an OUTER JOIN...
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
    LEFT OUTER JOIN Registration
        ON Staff.StaffID = Registration.StaffID
WHERE Registration.StaffID IS NULL

--6. Select the Payment TypeID(s) that have the highest number of Payments made.
-- Explore the counts of payment types, before we try the subquery
SELECT  PaymentTypeID, COUNT(PaymentTypeID) AS 'How many times'
FROM    Payment
GROUP BY PaymentTypeID

-- To get the payment type IDs whose count is greater than or equal to all the others
-- (i.e.: whose count is the highest)
SELECT  PaymentTypeID
FROM    Payment
GROUP BY PaymentTypeID
HAVING COUNT(PaymentTypeID)  >= ALL (SELECT COUNT(PaymentTypeID)
                                     FROM Payment 
                                     GROUP BY PaymentTypeID)

--7. Select the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentTypeDescription 
HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--   Examining the solution:
--   - First, take a look at the results of the subquery by itself - this gives us
--     the counts and we can visually see what the highest value is
                                               (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--   - Second, take a look at the outer query, but leave out the filtering of aggregates.
--     Also, display the count that is used in the HAVING clause. This should give you
--     an idea of what the right answers should be.
SELECT PaymentTypeDescription
       , COUNT(PaymentType.PaymentTypeID)
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentTypeDescription 

--8. What is the total avg mark for the students from Edm?
SELECT AVG(Mark) AS 'Average'
FROM   Registration 
WHERE  StudentID IN (SELECT StudentID FROM Student WHERE City = 'Edm')

-- The above results, done as a JOIN instead of a subquery
SELECT AVG(Mark) AS 'Average'
FROM   Registration 
    INNER JOIN Student
        ON Registration.StudentID = Student.StudentID
WHERE City = 'Edm'

-- 9. What is the avg mark for each of the students from Edm? Display their StudentID and avg(mark)
-- TODO: Student Answer Here...


-- 10. Which course(s) allow the largest classes? Show the course id, name, and max class size.
-- TODO: Student Answer Here...


-- 11. Which course(s) are the most affordable? Show the course name and cost.
-- TODO: Student Answer Here...


-- 12. Which staff have taught the largest classes? (Be sure to group registrations by course and semester.)
-- TODO: Student Answer Here...


-- 13. Which students are most active in the clubs?
-- TODO: Student Answer Here...


-- 14. Which student(s) have the highest average mark?
-- Hint - This can only be done by a subquery.
-- Extra Hint - This one is a bit tricky, because you need to make sure your subquery does not
--              have any NULL rows...
-- TODO: Student Answer Here...

