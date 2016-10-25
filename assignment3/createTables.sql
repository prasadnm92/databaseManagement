CREATE TABLE Person (
    id INT PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE Position (
    id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL
);

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    FOREIGN KEY (id)
        REFERENCES Person (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    servesAs INT NOT NULL,
    FOREIGN KEY (servesAs)
        REFERENCES `Position` (id)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    address VARCHAR(500) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE Dependent (
    hasDependent INT PRIMARY KEY,
    FOREIGN KEY (hasDependent)
        REFERENCES Person (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    dependsOn INT NOT NULL,
    FOREIGN KEY (dependsOn)
        REFERENCES Employee (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    relatedBy ENUM('Spouse', 'Child', 'Parent', 'Sibling', 'Other') NOT NULL
);

CREATE TABLE Benefit (
    id INT PRIMARY KEY,
    type VARCHAR(200) NOT NULL
);

CREATE TABLE BenefitPlan (
    id INT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    description VARCHAR(2000) NOT NULL,
    partOf INT NOT NULL,
    FOREIGN KEY (partOf)
        REFERENCES Benefit (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Selection (
    selectedBy INT NOT NULL,
    FOREIGN KEY (selectedBy)
        REFERENCES Employee (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    selects INT NOT NULL,
    FOREIGN KEY (selects)
        REFERENCES Benefit (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (selectedBy , selects),
    usesPlan INT NOT NULL,
    FOREIGN KEY (usesPlan)
        REFERENCES BenefitPlan (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Individual (
    id INT PRIMARY KEY,
    FOREIGN KEY (id)
        REFERENCES BenefitPlan (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Family (
    id INT PRIMARY KEY,
    FOREIGN KEY (id)
        REFERENCES BenefitPlan (id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE FamilyIncludes (
    family INT NOT NULL,
    FOREIGN KEY (family)
        REFERENCES Family (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    includes ENUM('Spouse', 'Child', 'Parent', 'Sibling', 'Other') NOT NULL,
    PRIMARY KEY (family , includes)
);

CREATE TABLE PayPeriod (
    id INT PRIMARY KEY,
    duration VARCHAR(200) NOT NULL
);

CREATE TABLE Entitlement (
    entitledTo INT NOT NULL,
    FOREIGN KEY (entitledTo)
        REFERENCES Benefit (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    entitledBy INT NOT NULL,
    FOREIGN KEY (entitledBy)
        REFERENCES `Position` (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (entitledTo , entitledBy)
);

create table Permission (
  allows int not null,
  foreign key(allows) references BenefitPlan(id) 
    on update cascade on delete cascade,
  allowedFor int not null,
  foreign key(allowedFor) references Position(id) 
    on update cascade on delete cascade,  
  primary key(allows, allowedFor)
);

CREATE TABLE Cost (
    costsAllows INT NOT NULL,
    costsAllowedFor INT NOT NULL,
    FOREIGN KEY (costsAllows , costsAllowedFor)
        REFERENCES Permission (allows , allowedFor)
        ON UPDATE CASCADE ON DELETE CASCADE,
    during INT NOT NULL,
    FOREIGN KEY (during)
        REFERENCES PayPeriod (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (costsAllows , costsAllowedFor , during),
    employee NUMERIC(9 , 2 ),
    employer NUMERIC(9 , 2 )
);