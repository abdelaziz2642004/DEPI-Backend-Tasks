-- no manager in the beginning only , we will change it later as if we made it not nullable
-- we wouldn't have been able to insert any sample data :( ( cycle )  :D


USE Company

INSERT INTO Department (DNUM, Dname, ManagerSSN, HiringDate)
VALUES
(10, 'IT',      NULL, NULL),
(20, 'HR',      NULL, NULL),
(30, 'Finance', NULL, NULL);

INSERT INTO Employee (SSN, Fname, Lname, Birthdate, Gender, DNUM, SupervisorSSN)
VALUES
('111111111', 'Ahmed',  'Ali',     '1985-02-10', 'M', 10, NULL),
('222222222', 'Sara',   'Hassan',  '1988-07-22', 'F', 20, '111111111'),
('333333333', 'Omar',   'Youssef', '1990-11-05', 'M', 30, '111111111'),
('444444444', 'Mona',   'Kamal',   '1995-04-18', 'F', 10, '111111111'),
('555555555', 'Khaled', 'Said',    '1992-09-30', 'M', 10, '333333333');


UPDATE Department
SET ManagerSSN = '111111111', HiringDate = '2020-01-15'
WHERE DNUM = 10;

UPDATE Department
SET ManagerSSN = '222222222', HiringDate = '2019-03-10'
WHERE DNUM = 20;

UPDATE Department
SET ManagerSSN = '333333333', HiringDate = '2021-06-01'
WHERE DNUM = 30;

INSERT INTO Dlocation (DNUM, Location)
VALUES
(10, 'Cairo'),
(10, 'Giza'),
(20, 'Alexandria'),
(30, 'Cairo');


INSERT INTO Project (Pnumber, Name, LocationCity, DNUM)
VALUES
(1001, 'Payroll System',  'Cairo', 10),
(1002, 'Recruitment App', 'Giza',  20),
(1003, 'Budget Analysis', 'Cairo', 30);

INSERT INTO Employee_Project (Essn, Pnumber, WorkingHours)
VALUES
('111111111', 1001, 15),
('444444444', 1001, 20),
('222222222', 1002, 25),
('333333333', 1003, 30),
('555555555', 1001, 10),
('555555555', 1003, 12);

INSERT INTO Dependent (DependentName, Essn, Birthdate, Gender)
VALUES
('Youssef', '111111111', '2012-05-12', 'm'),
('Laila',   '222222222', '2015-08-20', 'f'),
('Adam',    '555555555', '2018-03-01', 'm');

SELECT * FROM Project

---------
UPDATE Employee
SET DNUM = 30
WHERE SSN = '444444444';

DELETE FROM Dependent
WHERE DependentName = 'Adam'
  AND Essn = '555555555';

  SELECT
    E.SSN,
    E.Fname,
    E.Lname,
    D.Dname
FROM Employee E
JOIN Department D
    ON E.DNUM = D.DNUM
WHERE D.Dname = 'IT';

-- multiple joins
SELECT
    E.Fname,
    E.Lname,
    P.Name AS ProjectName,
    EP.WorkingHours
FROM Employee E
JOIN Employee_Project EP
    ON E.SSN = EP.Essn
JOIN Project P
    ON EP.Pnumber = P.Pnumber
ORDER BY E.Fname;
