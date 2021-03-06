/*STRATEGY
 * Translating Classes: with single-valued attributes
 *			and simulating object identity
 */
CREATE TABLE Person (
    pid INT PRIMARY KEY,		# person id
    name VARCHAR(100) NOT NULL
);

/*STRATEGY
 * Translating Classes: with single-valued attributes
 *			and simulating object identity
 *	- using `Position` because I think Position 
 *	  is a reserved word (as per Workbench)

 */
CREATE TABLE `Position` (
    posid INT PRIMARY KEY,		# position id
    title VARCHAR(100) NOT NULL
);

/*STRATEGY
 * Translating Classes: with single-valued attributes
 * Translating Hierarchies: using JOINED STRATEGY
 */
CREATE TABLE Employee (
    eid INT PRIMARY KEY,		# employee id
    FOREIGN KEY (eid)
        REFERENCES Person (pid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    address VARCHAR(200) NOT NULL,
    servesAs INT NOT NULL,
    FOREIGN KEY (servesAs)
        REFERENCES `Position` (posid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    email VARCHAR(100) NOT NULL,
    UNIQUE (email)
);

/*STRATEGY
 * Translating Association: MANY-TO-ONE relationship
 *	- on delete behavior should be "no action"
 *	- since the multiplicity on the other end is [0..1]
 *	  we should create a new table to avoid redundant values
 *	  that are not part of the relationship
 */
CREATE TABLE Dependent (
    hasDependent INT PRIMARY KEY,
    FOREIGN KEY (hasDependent)
        REFERENCES Person (pid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    dependsOn INT NOT NULL,
    FOREIGN KEY (dependsOn)
        REFERENCES Employee (eid)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    relatedBy ENUM('Spouse', 'Child', 'Parent', 'Sibling', 'Other') NOT NULL
);

/*STRATEGY
 * Translating Classes: with single-valued attributes
 */
CREATE TABLE Benefit (
    bid INT PRIMARY KEY,		# benefit id
    type VARCHAR(200) NOT NULL
);

/*STRATEGY
 * Translating Classes: with single-valued attributes
 * Translating Composition
 */
CREATE TABLE BenefitPlan (
    bpid INT PRIMARY KEY,		# benefit plan id
    name VARCHAR(100) NOT NULL,
    description VARCHAR(200) NOT NULL,
    partOf INT NOT NULL,
    FOREIGN KEY (partOf)
        REFERENCES Benefit (bid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

/*STRATEGY
 * Translating Associations: MANY-TO-MANY requires separate tables
 * Translating Associations: between association class and an other class with MANY-TO-ONE relationship
 *	- on delete behavior must be "no action"
 */
CREATE TABLE Selection (
    selectedBy INT NOT NULL,
    selects INT NOT NULL,
    PRIMARY KEY (selectedBy , selects),
    FOREIGN KEY (selectedBy)
        REFERENCES Employee (eid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (selects)
        REFERENCES Benefit (bid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    uses INT NOT NULL,
    FOREIGN KEY (uses)
        REFERENCES BenefitPlan (bpid)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

/*STRATEGY
 * Translating Hierarchies: using JOINED STRATEGY
 */
CREATE TABLE Individual (
    ibpid INT PRIMARY KEY,		# individual benefit plan id
    FOREIGN KEY (ibpid)
        REFERENCES BenefitPlan (bpid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

/*STRATEGY
 * Translating Hierarchies: using JOINED STRATEGY
 */
CREATE TABLE Family (
    fbpid INT PRIMARY KEY,		# family benefit plan id
    FOREIGN KEY (fbpid)
        REFERENCES BenefitPlan (bpid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

/*STRATEGY
 * Translating Classes: with multi-valued attributes
 *	- each multi-valud attribute requires a separate table
 */
CREATE TABLE FamilyBenefitPlanInclusions (
    fbpiid INT NOT NULL,		# family benefit plan inclusion id
    FOREIGN KEY (fbpiid)
        REFERENCES Family (fbpid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    includes ENUM('Spouse', 'Child', 'Parent', 'Sibling', 'Other') NOT NULL,
    PRIMARY KEY (fbpiid , includes)
);

/*STRATEGY
 * Translating Classes: with single-valued attributes
 */
CREATE TABLE PayPeriod (
    ppid INT PRIMARY KEY,		# pay period id
    duration VARCHAR(100) NOT NULL
);

/*STRATEGY
 * Translating Associations: MANY-TO-MANY requires separate tables
 */
CREATE TABLE Entitles (
    entitledTo INT NOT NULL,
    entitledBy INT NOT NULL,
    PRIMARY KEY (entitledTo , entitledBy),
    FOREIGN KEY (entitledTo)
        REFERENCES Benefit (bid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (entitledBy)
        REFERENCES `Position` (posid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

/*STRATEGY
 * Translating associations: MANY-TO-MANY requires separate tables
 */
CREATE TABLE Permission (
    allowedFor INT NOT NULL,
    allows INT NOT NULL,
    PRIMARY KEY (allows , allowedFor),
    FOREIGN KEY (allows)
        REFERENCES BenefitPlan (bpid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (allowedFor)
        REFERENCES `Position` (posid)
        ON UPDATE CASCADE ON DELETE CASCADE
);

/*STRATEGY
 * Translating Associations: MANY-TO-MANY requires separate tables
 *	- since the MANY-TO-MANY relationship is between an association class
 *	  and an other class, we need to use primary keys from every table that
 *	  is part of this relationship as a foreign key in this table
 */
CREATE TABLE Cost (
    during INT NOT NULL,
    costsAllowedFor INT NOT NULL,
    costsAllows INT NOT NULL,
    PRIMARY KEY (costsAllows , costsAllowedFor , during),
    FOREIGN KEY (costsAllows, costsAllowedFor)
        REFERENCES Permission (allows, allowedFor)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (during)
        REFERENCES PayPeriod (ppid)
        ON UPDATE CASCADE ON DELETE CASCADE,
    employee NUMERIC(10 , 2 ),
    employer NUMERIC(10 , 2 ) /* for Money datatype I use numeric MySQL datatype
				 that has a precision of 10 digits with 2 decimal places*/
);
