/* Roommates database - Dan Gilleland, 2024
-- This sample will be very useful for showing the reason/need
-- for JOIN when combining results from multiple tables.
   **************************************** */
SELECT DB_NAME() AS 'Active Database'
GO
IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = N'Roommates')
BEGIN
    CREATE DATABASE [Roommates]
END
GO

USE [Roommates]
GO
SELECT DB_NAME() AS 'Active Database'
GO

-- Reset by dropping tables
DROP TABLE IF EXISTS People
DROP TABLE IF EXISTS Rentals
GO

-- Create the tables
CREATE TABLE Rentals
(
    RentalId     int    IDENTITY(1,1)
        CONSTRAINT PK_Rental
            PRIMARY KEY             NOT NULL,
    Unit            varchar(5)          NULL,
    StreetAddress   varchar(50)     NOT NULL,
    City            varchar(50)     NOT NULL,
    MonthlyRent     smallmoney      NOT NULL
)

CREATE TABLE People
(
    PersonID    int     IDENTITY(400, 50)
        CONSTRAINT PK_Person
            PRIMARY KEY             NOT NULL,
    FirstName   varchar(20)         NOT NULL,
    LastName    varchar(20)         NOT NULL,
    RentalId    int
        CONSTRAINT FK_Person_Rental
            FOREIGN KEY REFERENCES Rentals(RentalId)
                                        NULL,
    WantingRoommate datetimeoffset      NULL,
)

GO

-- Generate sample data - Rentals
INSERT INTO Rentals(StreetAddress, City, MonthlyRent)
VALUES ('221-B Baker Street', 'London', 500)
INSERT INTO Rentals(Unit, StreetAddress, City, MonthlyRent)
VALUES ('101', '105 Rockdale Ravine', 'Bedrock', 400),
       ('403', '221 Rockdale Ravine', 'Bedrock', 450)
-- Sherlock Holmes + Watson - 22B, Baker Street
-- Barney + Fred, Wilma + Betty
GO

-- Generate sample data - People
INSERT INTO People(FirstName, LastName, RentalId)
VALUES ('Sherlock', 'Holmes', 1),
       ('John', 'Watson', 1),
       ('Barney', 'Rubble', 2),
       ('Fred', 'Flintstone', 2),
       ('Wilma', 'Slaghoople', 3),
       ('Betty', 'McBricker', 3)
GO

SELECT * FROM Rentals
SELECT * FROM People

-- A demo of why we should use JOINs in our FROM clauses...
-- BAD WAY
SELECT  FirstName + ' ' + LastName AS 'Person',
        ISNULL(Unit + ', ', '') + StreetAddress AS 'Address',
        City
FROM    Rentals, People

-- WRONG CONNECTION
SELECT  FirstName + ' ' + LastName AS 'Person',
        ISNULL(Unit + ', ', '') + StreetAddress AS 'Address',
        City
FROM    Rentals
    INNER JOIN People
        ON People.PersonID = Rentals.MonthlyRent

-- ---------------
-- RIGHT WAY
SELECT  FirstName + ' ' + LastName AS 'Person',
        ISNULL(Unit + ', ', '') + StreetAddress AS 'Address',
        City
FROM    Rentals
    INNER JOIN People
        ON People.RentalId = Rentals.RentalId

