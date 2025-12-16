use [Session-3task1]
CREATE TABLE Department (
    DNUM INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL UNIQUE,
    ManagerSSN CHAR(9) NULL,
    CreatedDate DATE NOT NULL DEFAULT GETDATE()
);
CREATE TABLE Employee (
    SSN CHAR(9) PRIMARY KEY,
    Fname VARCHAR(30) NOT NULL,
    Lname VARCHAR(30) NOT NULL,
    Gender CHAR(1) NOT NULL,
    Birthdate DATE NOT NULL,
    DNUM INT NOT NULL,

    CONSTRAINT CK_Employee_Gender
        CHECK (Gender IN ('M','F','m','f'))
);
CREATE TABLE Project (
    Pnumber INT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    DNUM INT NOT NULL
);
CREATE TABLE Dependent (
    DependentID INT IDENTITY PRIMARY KEY,
    DependentName VARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL,
    Birthdate DATE NOT NULL,
    Essn CHAR(9) NOT NULL,

    CONSTRAINT CK_Dependent_Gender
        CHECK (Gender IN ('M','F'))
);

CREATE TABLE Employee_Project (
    Essn CHAR(9) NOT NULL,
    Pnumber INT NOT NULL,
    WorkingHours DECIMAL(5,2) NOT NULL DEFAULT 0,

    PRIMARY KEY (Essn, Pnumber)
);
--------
-- I NEED HELP IN THIS PART
-- Employee -> Department
--I want when department changes , any employee wit the old department will change to the new one
-- also when a manager changes his ssn , in the employee table , it should also change in the department table automatically
-- this is not okay and will cause an error :(  ( cycle yasta ) 
--ALTER TABLE Employee
--ADD CONSTRAINT FK_Employee_Dept
--FOREIGN KEY (DNUM)
--REFERENCES Department(DNUM)
--ON DELETE NO ACTION   -- Cannot delete department if employees exist
--ON UPDATE CASCADE;    -- If DNUM changes, update automatically

-- Department ManagerSSN -> Employee (one-to-one)
--ALTER TABLE Department
--ADD CONSTRAINT FK_Department_Manager
--FOREIGN KEY (ManagerSSN)
--REFERENCES Employee(SSN)
--ON DELETE SET NULL    -- If manager deleted, set ManagerSSN to NULL
--ON UPDATE CASCADE;    -- Update if employee SSN changes

-- Department changes - Project changes
ALTER TABLE Project
ADD CONSTRAINT FK_Project_Dept
FOREIGN KEY (DNUM)
REFERENCES Department(DNUM)
ON DELETE NO ACTION   -- Cannot delete department if projects exist
ON UPDATE CASCADE;

-- Dependent -> Employee
ALTER TABLE Dependent
ADD CONSTRAINT FK_Dependent_Employee
FOREIGN KEY (Essn)
REFERENCES Employee(SSN)
ON DELETE CASCADE     -- Deleting employee deletes their dependents
ON UPDATE CASCADE;

-- Employee_Project -> Employee
ALTER TABLE Employee_Project
ADD CONSTRAINT FK_EmpProj_Employee
FOREIGN KEY (Essn)
REFERENCES Employee(SSN)
ON DELETE CASCADE     -- If employee deleted, remove project assignments
ON UPDATE CASCADE;


-- Department changes (D-id) - Project changes ( the foreign key ) ( done )
-- Employee changes ( Essn ) -> Employee_Project changes its foreign key ( Essn ) ( done )
-- project changes ( Projuct id ) -> employee_project  ( project ID ) changes ( why error )
-- multiple paths that end with changing ( employee_project ) WRONG

-- THIS WILL CAUSE AN ERROR
--ALTER TABLE Employee_Project
--ADD CONSTRAINT FK_EmpProj_Project
--FOREIGN KEY (Pnumber)
--REFERENCES Project(Pnumber)
--ON DELETE CASCADE     -- If project deleted, remove employee assignments
--ON UPDATE CASCADE

--------------

ALTER TABLE Employee
ADD SOMETHING VARCHAR(100);

ALTER TABLE Employee
ALTER COLUMN Email VARCHAR(150);


ALTER TABLE Project
DROP CONSTRAINT FK_Project_Dept;

------
-- data --
INSERT INTO Department (DNUM, Dname)
VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance');
INSERT INTO Employee (SSN, Fname, Lname, Gender, Birthdate, DNUM)
VALUES
('111111111', 'Ahmed', 'Ali', 'M', '1985-02-10', 10),
('222222222', 'Sara', 'Hassan', 'F', '1988-07-22', 20),
('333333333', 'Omar', 'Youssef', 'M', '1990-11-05', 30),
('444444444', 'Mona', 'Kamal', 'F', '1995-04-18', 10),
('555555555', 'Khaled', 'Said', 'M', '1992-09-30', 10);

UPDATE Department SET ManagerSSN = '111111111' WHERE DNUM = 10;
UPDATE Department SET ManagerSSN = '222222222' WHERE DNUM = 20;
UPDATE Department SET ManagerSSN = '333333333' WHERE DNUM = 30;
INSERT INTO Project (Pnumber, Pname, DNUM)
VALUES
(1001, 'Payroll System', 10),
(1002, 'Recruitment App', 20),
(1003, 'Budget Analysis', 30);


INSERT INTO Employee_Project (Essn, Pnumber, WorkingHours)
VALUES
('111111111', 1001, 15),
('444444444', 1001, 20),
('222222222', 1002, 25),
('333333333', 1003, 30),
('555555555', 1001, 10);

INSERT INTO Dependent (DependentName, Gender, Birthdate, Essn)
VALUES
('Youssef', 'M', '2012-05-12', '111111111'),
('Laila', 'F', '2015-08-20', '222222222'),
('Adam', 'M', '2018-03-01', '555555555');
