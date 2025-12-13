
CREATE TABLE Department (
    DNUM INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL,
    ManagerSSN CHAR(9) NULL,
    HiringDate DATE NULL
);


CREATE TABLE Employee (
    SSN CHAR(9) PRIMARY KEY,
    Fname VARCHAR(30) NOT NULL,
    Lname VARCHAR(30) NOT NULL,
    Birthdate DATE,
    Gender CHAR(1),
    DNUM INT NOT NULL,
    SupervisorSSN CHAR(9),

    CONSTRAINT WorksInDept
        FOREIGN KEY (DNUM)
        REFERENCES Department(DNUM),

    CONSTRAINT HasSupervisor
        FOREIGN KEY (SupervisorSSN)
        REFERENCES Employee(SSN)
);

ALTER TABLE Department
ADD CONSTRAINT ManagedBy
    FOREIGN KEY (ManagerSSN)
    REFERENCES Employee(SSN);


CREATE TABLE Project (
    Pnumber INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    LocationCity VARCHAR(50),
    DNUM INT NOT NULL,

    CONSTRAINT ProjectDepartment
        FOREIGN KEY (DNUM)
        REFERENCES Department(DNUM)
);



CREATE TABLE Dlocation (
    DNUM INT,
    Location VARCHAR(50),

    PRIMARY KEY (DNUM, Location),

    CONSTRAINT DepartmentLocation
        FOREIGN KEY (DNUM)
        REFERENCES Department(DNUM)
);


CREATE TABLE Dependent (
    DependentName VARCHAR(50),
    Essn CHAR(9),
    Birthdate DATE,
    Gender CHAR(1),

    PRIMARY KEY (DependentName, Essn),

    CONSTRAINT DependentOfEmployee
        FOREIGN KEY (Essn)
        REFERENCES Employee(SSN)
        ON DELETE CASCADE
);



CREATE TABLE Employee_Project (
    Essn CHAR(9),
    Pnumber INT,
    WorkingHours DECIMAL(5,2),

    PRIMARY KEY (Essn, Pnumber),

    CONSTRAINT EmployeeAssignment
        FOREIGN KEY (Essn)
        REFERENCES Employee(SSN),

    CONSTRAINT ProjectAssignment
        FOREIGN KEY (Pnumber)
        REFERENCES Project(Pnumber)
);
