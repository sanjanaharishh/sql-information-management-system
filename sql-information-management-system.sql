CREATE DATABASE LittleSteps;
USE LittleSteps;


-- 1. STUDENT TABLE 
CREATE TABLE Student (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male','Female','Other') NULL,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    Postcode VARCHAR(10),
    StartDate DATE NOT NULL,
    Status ENUM('Active','Inactive') DEFAULT 'Active',
    
    ParentID INT NULL
);


-- 2. PARENT TABLE
CREATE TABLE Parent (
    ParentID INT AUTO_INCREMENT PRIMARY KEY,
    MotherName VARCHAR(50),
    MotherPhone VARCHAR(20),
    MotherEmail VARCHAR(100),
    FatherName VARCHAR(50),
    FatherPhone VARCHAR(20),
    FatherEmail VARCHAR(100),
    EmergencyContactName VARCHAR(50),
    EmergencyContactPhone VARCHAR(20),
    PreferredContact ENUM('Mother','Father','Both') DEFAULT 'Both'
);

-- 3. STAFF TABLE
CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Designation ENUM('Teacher','Housekeeping','Driver','Owner') NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE NOT NULL
);


-- 4. CLASS TABLE 
CREATE TABLE Class (
    ClassID INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(50) NOT NULL,   -- e.g. 'Play School A'
    AgeGroup VARCHAR(50),             -- e.g. '2–3 Years'
    Capacity INT DEFAULT 20,
    StaffID INT NOT NULL,

    CONSTRAINT fk_class_staff
        FOREIGN KEY (StaffID)
        REFERENCES Staff(StaffID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 5. ENROLMENT TABLE 
CREATE TABLE Enrolment (
    EnrolmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    EnrolStartDate DATE NOT NULL,
    EnrolEndDate DATE NULL,

    CONSTRAINT fk_enrol_student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_enrol_class
        FOREIGN KEY (ClassID)
        REFERENCES Class(ClassID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 6. ATTENDANCE TABLE 
CREATE TABLE Attendance (
    AttendanceID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    Status ENUM('Present','Absent','Late') NOT NULL,
    Notes VARCHAR(255),

    CONSTRAINT fk_attendance_student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_attendance_class
        FOREIGN KEY (ClassID)
        REFERENCES Class(ClassID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- 7. LOGISTICS TABLE 
CREATE TABLE Logistics (
    LogisticsID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,

    ModeOfTransportToSchool ENUM('Parent','SchoolTransport') NOT NULL,
    ModeOfTransportFromSchool ENUM('Parent','SchoolTransport') NOT NULL,

    PickupDropoffContactName VARCHAR(100) NOT NULL,
    PickupDropoffContactPhone VARCHAR(20) NOT NULL,

    PickupLocation VARCHAR(100),
    Notes VARCHAR(255),

    CONSTRAINT fk_logistics_student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- 8. PAYMENT TABLE (linked to Student)
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,
    AcademicYear VARCHAR(9) NOT NULL,   -- e.g. '2025-2026'

    Quarter ENUM('Q1','Q2','Q3','Full') NOT NULL,
    -- Q1/Q2/Q3 for term records, 'Full' for full-year summaries

    TuitionAmountDue DECIMAL(10,2) DEFAULT 0.00,
    TuitionAmountPaid DECIMAL(10,2) DEFAULT 0.00,

    TransportAmountDue DECIMAL(10,2) DEFAULT 0.00,
    TransportAmountPaid DECIMAL(10,2) DEFAULT 0.00,

    PaymentDate DATE NULL,
    PaymentMethod ENUM('Cash','Card','Bank Transfer') NULL,

    TuitionStatus ENUM('Not Applicable','Unpaid','Partially Paid','Paid')
        DEFAULT 'Not Applicable',
    TransportStatus ENUM('Not Applicable','Unpaid','Partially Paid','Paid')
        DEFAULT 'Not Applicable',

    CONSTRAINT fk_payment_student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- 9. NOW ADD THE MISSING FOREIGN KEY: STUDENT → PARENT
ALTER TABLE Student
ADD CONSTRAINT fk_student_parent
    FOREIGN KEY (ParentID)
    REFERENCES Parent(ParentID)
    ON UPDATE CASCADE
    ON DELETE SET NULL;

SHOW TABLES;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO Parent
(ParentID, MotherName, MotherPhone, MotherEmail,
 FatherName, FatherPhone, FatherEmail,
 EmergencyContactName, EmergencyContactPhone, PreferredContact)
VALUES
(1,'Sarah Brown','07111111001','sarah.brown@gmail.com','James Brown','07222222001','james.brown@gmail.com','Sarah Brown','07111111001','Mother'),
(2,'Emily Green','07111111002','emily.green@gmail.com','David Green','07222222002','david.green@gmail.com','Emily Green','07111111002','Mother'),
(3,'Aisha Khan','07111111003','aisha.khan@gmail.com','Omar Khan','07222222003','omar.khan@gmail.com','Aisha Khan','07111111003','Mother'),
(4,'Laura Smith','07111111004','laura.smith@hotmail.com','Mark Smith','07222222004','mark.smith@hotmail.com','Laura Smith','07111111004','Mother'),
(5,'Priya Patel','07111111005','priya.patel@gmail.com','Ravi Patel','07222222005','ravi.patel@gmail.com','Priya Patel','07111111005','Mother'),
(6,'Rachel Miller','07111111006','rachel.miller@gmail.com','Thomas Miller','07222222006','thomas.miller@gmail.com','Rachel Miller','07111111006','Mother'),
(7,'Olivia Turner','07111111007','olivia.turner@hotmail.com','Luke Turner','07222222007','luke.turner@hotmail.com','Olivia Turner','07111111007','Mother'),
(8,'Chloe Wilson','07111111008','chloe.wilson@yahoo.com','Ethan Wilson','07222222008','ethan.wilson@gmail.com','Chloe Wilson','07111111008','Mother'),
(9,'Megan Johnson','07111111009','megan.johnson@gmail.com','Paul Johnson','07222222009','paul.johnson@hotmail.com','Megan Johnson','07111111009','Mother'),
(10,'Amina Rahman','07111111010','amina.rahman@gmail.com','Khalid Rahman','07222222010','khalid.rahman@gmail.com','Amina Rahman','07111111010','Mother'),
(11,'Natalie Clark','07111111011','natalie.clark@gmail.com','Jason Clark','07222222011','jason.clark@gmail.com','Natalie Clark','07111111011','Mother'),
(12,'Holly Adams','07111111012','holly.adams@hotmail.com','Ethan Adams','07222222012','ethan.adams@hotmail.com','Holly Adams','07111111012','Mother'),
(13,'Sanjana Desai','07111111013','sanjana.desai@gmail.com','Rohan Desai','07222222013','rohan.desai@gmail.com','Sanjana Desai','07111111013','Mother'),
(14,'Lucy Edwards','07111111014','lucy.edwards@yahoo.com','Aaron Edwards','07222222014','aaron.edwards@hotmail.com','Lucy Edwards','07111111014','Mother'),
(15,'Kerry Hughes','07111111015','kerry.hughes@gmail.com','Ben Hughes','07222222015','ben.hughes@hotmail.com','Kerry Hughes','07111111015','Mother'),
(16,'Priya Sharma','07111111016','priya.sharma@gmail.com','Vikram Sharma','07222222016','vikram.sharma@gmail.com','Priya Sharma','07111111016','Mother'),
(17,'Emma Davies','07111111017','emma.davies@hotmail.com','Tom Davies','07222222017','tom.davies@hotmail.com','Emma Davies','07111111017','Mother'),
(18,'Hannah Reed','07111111018','hannah.reed.parent@gmail.com','Chris Reed','07222222018','chris.reed@gmail.com','Hannah Reed','07111111018','Mother'),
(19,'Sara Ahmed','07111111019','sara.ahmed@yahoo.com','Imran Ahmed','07222222019','imran.ahmed@gmail.com','Sara Ahmed','07111111019','Mother'),
(20,'Zoe Walker','07111111020','zoe.walker@gmail.com','Matt Walker','07222222020','matt.walker@hotmail.com','Zoe Walker','07111111020','Mother'),
(21,'Laura King','07111111021','laura.king@hotmail.com','Daniel King','07222222021','daniel.king@gmail.com','Laura King','07111111021','Mother'),
(22,'Farah Ali','07111111022','farah.ali@gmail.com','Yusuf Ali','07222222022','yusuf.ali@gmail.com','Farah Ali','07111111022','Mother'),
(23,'Julie Scott','07111111023','julie.scott@yahoo.com','Mark Scott','07222222023','mark.scott@gmail.com','Julie Scott','07111111023','Mother'),
(24,'Kim Lee','07111111024','kim.lee@gmail.com','David Lee','07222222024','david.lee@hotmail.com','Kim Lee','07111111024','Mother'),
(25,'Nadia Khan','07111111025','nadia.khan@gmail.com','Omar Khan','07222222025','omar.khan.parent@gmail.com','Nadia Khan','07111111025','Mother'),
(26,'Rebecca Hall','07111111026','rebecca.hall@hotmail.com','Peter Hall','07222222026','peter.hall@gmail.com','Rebecca Hall','07111111026','Mother'),
(27,'Monica Patel','07111111027','monica.patel@gmail.com','Raj Patel','07222222027','raj.patel@hotmail.com','Monica Patel','07111111027','Mother'),
(28,'Elena Rossi','07111111028','elena.rossi@gmail.com','Marco Rossi','07222222028','marco.rossi@gmail.com','Elena Rossi','07111111028','Mother'),
(29,'Amira Yusuf','07111111029','amira.yusuf@gmail.com','Jamal Yusuf','07222222029','jamal.yusuf@hotmail.com','Amira Yusuf','07111111029','Mother'),
(30,'Ella Fraser','07111111030','ella.fraser@gmail.com','Scott Fraser','07222222030','scott.fraser@hotmail.com','Ella Fraser','07111111030','Mother'),
(31,'Naomi Clarke','07111111031','naomi.clarke@gmail.com','Gavin Clarke','07222222031','gavin.clarke@gmail.com','Naomi Clarke','07111111031','Mother'),
(32,'Isobel Grant','07111111032','isobel.grant@yahoo.com','Stuart Grant','07222222032','stuart.grant@gmail.com','Isobel Grant','07111111032','Mother'),
(33,'Leah Morton','07111111033','leah.morton@gmail.com','Sam Morton','07222222033','sam.morton@hotmail.com','Leah Morton','07111111033','Mother'),
(34,'Grace White','07111111034','grace.white@gmail.com','Adam White','07222222034','adam.white@gmail.com','Grace White','07111111034','Mother'),
(35,'Ana Lopez','07111111035','ana.lopez@gmail.com','Carlos Lopez','07222222035','carlos.lopez@gmail.com','Ana Lopez','07111111035','Mother'),
(36,'Patricia Young','07111111036','patricia.young@gmail.com','Ian Young','07222222036','ian.young@gmail.com','Patricia Young','07111111036','Mother'),
(37,'Marta Novak','07111111037','marta.novak@gmail.com','Lukas Novak','07222222037','lukas.novak@gmail.com','Marta Novak','07111111037','Mother'),
(38,'Helen Hayes','07111111038','helen.hayes@gmail.com','Brian Hayes','07222222038','brian.hayes@gmail.com','Helen Hayes','07111111038','Mother'),
(39,'Ayesha Iqbal','07111111039','ayesha.iqbal@gmail.com','Rashid Iqbal','07222222039','rashid.iqbal@gmail.com','Ayesha Iqbal','07111111039','Mother'),
(40,'Linda Baker','07111111040','linda.baker@gmail.com','George Baker','07222222040','george.baker@gmail.com','Linda Baker','07111111040','Mother'),
(41,'Karen Shaw','07111111041','karen.shaw@gmail.com','Peter Shaw','07222222041','peter.shaw@gmail.com','Karen Shaw','07111111041','Mother'),
(42,'Diana Moore','07111111042','diana.moore@gmail.com','Kevin Moore','07222222042','kevin.moore@gmail.com','Diana Moore','07111111042','Mother'),
(43,'Alice Wong','07111111043','alice.wong@gmail.com','David Wong','07222222043','david.wong@gmail.com','Alice Wong','07111111043','Mother'),
(44,'Nadia Begum','07111111044','nadia.begum@gmail.com','Imran Begum','07222222044','imran.begum@gmail.com','Nadia Begum','07111111044','Mother'),
(45,'Meera Patel','07111111045','meera.patel@gmail.com','Sanjay Patel','07222222045','sanjay.patel@gmail.com','Meera Patel','07111111045','Mother'),
(46,'Preeti Singh','07111111046','preeti.singh@gmail.com','Arjun Singh','07222222046','arjun.singh@gmail.com','Preeti Singh','07111111046','Mother'),
(47,'Laura Allen','07111111047','laura.allen@gmail.com','Tom Allen','07222222047','tom.allen@gmail.com','Laura Allen','07111111047','Mother'),
(48,'Sabah Hussain','07111111048','sabah.hussain@gmail.com','Ali Hussain','07222222048','ali.hussain@gmail.com','Sabah Hussain','07111111048','Mother'),
(49,'Rachel Kelly','07111111049','rachel.kelly@gmail.com','Sean Kelly','07222222049','sean.kelly@gmail.com','Rachel Kelly','07111111049','Mother'),
(50,'Holly Ward','07111111050','holly.ward@gmail.com','Chris Ward','07222222050','chris.ward@gmail.com','Holly Ward','07111111050','Mother'),
(51,'Emma Gibson','07111111051','emma.gibson@gmail.com','Rob Gibson','07222222051','rob.gibson@gmail.com','Emma Gibson','07111111051','Mother'),
(52,'Hannah Murray','07111111052','hannah.murray@gmail.com','Joe Murray','07222222052','joe.murray@gmail.com','Hannah Murray','07111111052','Mother'),
(53,'Sarah Douglas','07111111053','sarah.douglas@gmail.com','Neil Douglas','07222222053','neil.douglas@gmail.com','Sarah Douglas','07111111053','Mother'),
(54,'Lauren Hunter','07111111054','lauren.hunter@gmail.com','Gary Hunter','07222222054','gary.hunter@gmail.com','Lauren Hunter','07111111054','Mother'),
(55,'Leah Blair','07111111055','leah.blair@gmail.com','Sam Blair','07222222055','sam.blair@gmail.com','Leah Blair','07111111055','Mother'),
(56,'Katie Reid','07111111056','katie.reid@gmail.com','Alan Reid','07222222056','alan.reid@gmail.com','Katie Reid','07111111056','Mother'),
(57,'Molly Black','07111111057','molly.black@gmail.com','Ian Black','07222222057','ian.black@gmail.com','Molly Black','07111111057','Mother'),
(58,'Jenna Gray','07111111058','jenna.gray@gmail.com','Owen Gray','07222222058','owen.gray@gmail.com','Jenna Gray','07111111058','Mother'),
(59,'Paula Young','07111111059','paula.young@gmail.com','Steve Young','07222222059','steve.young@gmail.com','Paula Young','07111111059','Mother'),
(60,'Nora Doyle','07111111060','nora.doyle@gmail.com','Liam Doyle','07222222060','liam.doyle@gmail.com','Nora Doyle','07111111060','Mother'),
(61,'Cheryl Burns','07111111061','cheryl.burns@gmail.com','Adam Burns','07222222061','adam.burns@gmail.com','Cheryl Burns','07111111061','Mother'),
(62,'Fiona Price','07111111062','fiona.price@gmail.com','Ryan Price','07222222062','ryan.price@gmail.com','Fiona Price','07111111062','Mother'),
(63,'Joanne Kerr','07111111063','joanne.kerr@gmail.com','Mark Kerr','07222222063','mark.kerr@gmail.com','Joanne Kerr','07111111063','Mother'),
(64,'Donna Sharp','07111111064','donna.sharp@gmail.com','Colin Sharp','07222222064','colin.sharp@gmail.com','Donna Sharp','07111111064','Mother'),
(65,'Nicola Holt','07111111065','nicola.holt@gmail.com','Glen Holt','07222222065','glen.holt@gmail.com','Nicola Holt','07111111065','Mother'),
(66,'Vicky Lowe','07111111066','vicky.lowe@gmail.com','Sean Lowe','07222222066','sean.lowe@gmail.com','Vicky Lowe','07111111066','Mother'),
(67,'Sophie Quinn','07111111067','sophie.quinn@gmail.com','Aaron Quinn','07222222067','aaron.quinn@gmail.com','Sophie Quinn','07111111067','Mother'),
(68,'Claire Boyd','07111111068','claire.boyd@gmail.com','Dean Boyd','07222222068','dean.boyd@gmail.com','Claire Boyd','07111111068','Mother'),
(69,'Erin Walsh','07111111069','erin.walsh@gmail.com','Kevin Walsh','07222222069','kevin.walsh@gmail.com','Erin Walsh','07111111069','Mother'),
(70,'Bethany Kerr','07111111070','bethany.kerr@gmail.com','Scott Kerr','07222222070','scott.kerr@gmail.com','Bethany Kerr','07111111070','Mother'),
(71,'Tara Green','07111111071','tara.green@gmail.com','Paul Green','07222222071','paul.green@gmail.com','Tara Green','07111111071','Mother'),
(72,'Rachel Long','07111111072','rachel.long@gmail.com','Chris Long','07222222072','chris.long@gmail.com','Rachel Long','07111111072','Mother'),
(73,'Naomi Bell','07111111073','naomi.bell@gmail.com','Gary Bell','07222222073','gary.bell@gmail.com','Naomi Bell','07111111073','Mother'),
(74,'Amber Fox','07111111074','amber.fox@gmail.com','Dan Fox','07222222074','dan.fox@gmail.com','Amber Fox','07111111074','Mother'),
(75,'Holly Rose','07111111075','holly.rose@gmail.com','Matt Rose','07222222075','matt.rose@gmail.com','Holly Rose','07111111075','Mother'),
(76,'Katie Wood','07111111076','katie.wood@gmail.com','Adam Wood','07222222076','adam.wood@gmail.com','Katie Wood','07111111076','Mother'),
(77,'Saira Khan','07111111077','saira.khan@gmail.com','Bilal Khan','07222222077','bilal.khan@gmail.com','Saira Khan','07111111077','Mother'),
(78,'Amy Hill','07111111078','amy.hill@gmail.com','Tom Hill','07222222078','tom.hill@gmail.com','Amy Hill','07111111078','Mother'),
(79,'Leah Green','07111111079','leah.green@gmail.com','Jack Green','07222222079','jack.green@gmail.com','Leah Green','07111111079','Mother'),
(80,'Paige West','07111111080','paige.west@gmail.com','Ryan West','07222222080','ryan.west@gmail.com','Paige West','07111111080','Mother');

INSERT INTO Student
(StudentID, FirstName, LastName, DateOfBirth, Gender,
 AddressLine1, AddressLine2, City, Postcode,
 StartDate, Status, ParentID)
VALUES
-- SIBLINGS / TWINS (40 students, Parents 1–20)

(501,'Oliver','Brown','2020-05-01','Male','2 Oak Street','Flat 1A','Glasgow','G1 1AA','2023-09-01','Active',1),
(502,'Amelia','Brown','2020-05-01','Female','2 Oak Street','Flat 1A','Glasgow','G1 1AA','2023-09-01','Active',1), -- twins

(503,'Noah','Green','2019-08-10','Male','3 Maple Road','Flat 2B','Glasgow','G1 2AB','2022-09-01','Active',2),
(504,'Isla','Green','2021-01-15','Female','3 Maple Road','Flat 2B','Glasgow','G1 2AB','2024-09-01','Active',2),

(505,'Leo','Khan','2020-03-12','Male','4 Willow Close','Flat 3C','Glasgow','G2 3AC','2023-09-01','Active',3),
(506,'Mia','Khan','2020-03-12','Female','4 Willow Close','Flat 3C','Glasgow','G2 3AC','2023-09-01','Active',3), -- twins

(507,'Ethan','Smith','2019-11-20','Male','5 Birch Avenue','Flat 4D','Glasgow','G3 4AD','2022-09-01','Active',4),
(508,'Ava','Smith','2021-06-05','Female','5 Birch Avenue','Flat 4D','Glasgow','G3 4AD','2024-09-01','Active',4),

(509,'Sophia','Patel','2019-09-30','Female','6 Cedar Lane','Flat 1B','Glasgow','G4 5AE','2022-09-01','Active',5),
(510,'Liam','Patel','2020-12-18','Male','6 Cedar Lane','Flat 1B','Glasgow','G4 5AE','2023-09-01','Active',5),

(511,'Emily','Miller','2020-04-09','Female','7 Rowan Street','Flat 2C','Glasgow','G2 6AB','2023-09-01','Active',6),
(512,'Lucas','Miller','2020-04-09','Male','7 Rowan Street','Flat 2C','Glasgow','G2 6AB','2023-09-01','Active',6), -- twins

(513,'Grace','Turner','2019-02-14','Female','8 Ash Grove','Flat 3A','Glasgow','G3 2CD','2022-09-01','Active',7),
(514,'Jacob','Turner','2021-03-27','Male','8 Ash Grove','Flat 3A','Glasgow','G3 2CD','2024-09-01','Active',7),

(515,'Chloe','Wilson','2020-07-01','Female','9 Linden Road','Flat 1C','Glasgow','G4 3EF','2023-09-01','Active',8),
(516,'Harvey','Wilson','2019-10-11','Male','9 Linden Road','Flat 1C','Glasgow','G4 3EF','2022-09-01','Active',8),

(517,'Ruby','Johnson','2019-05-23','Female','10 Elm Crescent','Flat 2D','Glasgow','G5 1GH','2022-09-01','Active',9),
(518,'Oscar','Johnson','2020-02-02','Male','10 Elm Crescent','Flat 2D','Glasgow','G5 1GH','2023-09-01','Active',9),

(519,'Lily','Rahman','2020-05-05','Female','11 Willowbank Terrace','Flat 3B','Glasgow','G3 6XY','2023-09-01','Active',10),
(520,'George','Rahman','2020-05-05','Male','11 Willowbank Terrace','Flat 3B','Glasgow','G3 6XY','2023-09-01','Active',10), -- twins

(521,'Holly','Clark','2019-09-09','Female','12 Kelvin Street','Flat 4A','Glasgow','G3 8AB','2022-09-01','Active',11),
(522,'Archie','Clark','2021-01-20','Male','12 Kelvin Street','Flat 4A','Glasgow','G3 8AB','2024-09-01','Active',11),

(523,'Ella','Adams','2019-01-30','Female','13 Clyde Road','Flat 1D','Glasgow','G2 5CD','2022-09-01','Active',12),
(524,'Logan','Adams','2020-08-19','Male','13 Clyde Road','Flat 1D','Glasgow','G2 5CD','2023-09-01','Active',12),

(525,'Daniel','Desai','2019-06-17','Male','14 Regent Park','Flat 2A','Glasgow','G41 2AB','2022-09-01','Active',13),
(526,'Maya','Desai','2019-06-17','Female','14 Regent Park','Flat 2A','Glasgow','G41 2AB','2022-09-01','Active',13), -- twins

(527,'Zain','Edwards','2020-03-03','Male','15 Queen Street','Flat 3D','Glasgow','G1 3EF','2023-09-01','Active',14),
(528,'Huda','Edwards','2021-04-14','Female','15 Queen Street','Flat 3D','Glasgow','G1 3EF','2024-09-01','Active',14),

(529,'Samir','Hughes','2019-11-08','Male','16 River Lane','Flat 4B','Glasgow','G2 4GH','2022-09-01','Active',15),
(530,'Yasmin','Hughes','2020-09-22','Female','16 River Lane','Flat 4B','Glasgow','G2 4GH','2023-09-01','Active',15),

(531,'Poppy','Sharma','2020-05-01','Female','17 Sauchiehall Street','Flat 1B','Glasgow','G2 3JJ','2023-09-01','Active',16),
(532,'Reuben','Sharma','2020-05-01','Male','17 Sauchiehall Street','Flat 1B','Glasgow','G2 3JJ','2023-09-01','Active',16), -- twins

(533,'Krish','Davies','2019-10-02','Male','18 Forth Street','Flat 2C','Glasgow','G4 9KL','2022-09-01','Active',17),
(534,'Neha','Davies','2021-02-11','Female','18 Forth Street','Flat 2C','Glasgow','G4 9KL','2024-09-01','Active',17),

(535,'Luca','Reed','2019-03-15','Male','19 Hillhead Place','Flat 3B','Glasgow','G12 8AA','2022-09-01','Active',18),
(536,'Giulia','Reed','2020-07-29','Female','19 Hillhead Place','Flat 3B','Glasgow','G12 8AA','2023-09-01','Active',18),

(537,'Summer','Ahmed','2020-01-07','Female','20 Pollokshaws Road','Flat 4C','Glasgow','G41 1BB','2023-09-01','Active',19),
(538,'Caleb','Ahmed','2021-09-09','Male','20 Pollokshaws Road','Flat 4C','Glasgow','G41 1BB','2024-09-01','Active',19),

(539,'Ivy','Walker','2019-04-21','Female','21 Yorkhill Street','Flat 1D','Glasgow','G3 8XY','2022-09-01','Active',20),
(540,'Toby','Walker','2019-04-21','Male','21 Yorkhill Street','Flat 1D','Glasgow','G3 8XY','2022-09-01','Active',20),
(541,'Oscar','King','2020-06-06','Male','22 Woodlands Road','Flat 1A','Glasgow','G3 6AB','2023-09-01','Active',21),
(542,'Lily','Ali','2021-03-03','Female','23 Cathedral Street','Flat 2B','Glasgow','G1 2XY','2024-09-01','Active',22),
(543,'Henry','Scott','2019-09-18','Male','24 Bath Street','Flat 3C','Glasgow','G2 1EE','2022-09-01','Active',23),
(544,'Grace','Lee','2020-02-12','Female','25 Hope Street','Flat 4D','Glasgow','G2 2AA','2023-09-01','Active',24),
(545,'Yusuf','Khan','2021-11-21','Male','26 Baltic Street','Flat 1B','Glasgow','G40 2ZZ','2024-09-01','Active',25),
(546,'Poppy','Hall','2020-08-03','Female','27 Bothwell Street','Flat 2C','Glasgow','G2 6BD','2023-09-01','Active',26),
(547,'Reuben','Patel','2021-04-14','Male','28 India Street','Flat 3A','Glasgow','G2 4PF','2024-09-01','Active',27),
(548,'Krish','Rossi','2020-01-18','Male','29 Great Western Road','Flat 4B','Glasgow','G4 9AA','2023-09-01','Active',28),
(549,'Harley','Yusuf','2022-02-27','Other','30 High Street','Flat 1C','Glasgow','G1 1XY','2025-09-01','Active',29),
(550,'Bilal','Fraser','2019-06-06','Male','31 Crown Street','Flat 2D','Glasgow','G5 9EX','2022-09-01','Active',30),

(551,'Hana','Clarke','2022-10-22','Female','32 Argyle Street','Flat 3B','Glasgow','G2 8QQ','2025-09-01','Active',31),
(552,'Ariana','Grant','2021-05-11','Female','33 Byres Road','Flat 4C','Glasgow','G11 5RD','2024-09-01','Active',32),
(553,'Jonas','Morton','2020-03-01','Male','34 Gordon Street','Flat 1A','Glasgow','G1 3PL','2023-09-01','Active',33),
(554,'Mason','White','2021-07-19','Male','35 Waterloo Street','Flat 2B','Glasgow','G2 6AY','2024-09-01','Active',34),
(555,'Oscar','Lopez','2019-12-05','Male','36 Renfrew Street','Flat 3C','Glasgow','G2 3BW','2022-09-01','Active',35),
(556,'Lily','Young','2020-09-09','Female','37 Kelvin Way','Flat 4D','Glasgow','G3 7AB','2023-09-01','Active',36),
(557,'Harley','Novak','2021-01-04','Other','38 Clyde Place','Flat 1A','Glasgow','G5 0AB','2024-09-01','Active',37),
(558,'George','Hayes','2019-02-15','Male','39 Broomhill Road','Flat 2B','Glasgow','G11 7CD','2022-09-01','Active',38),
(559,'Mila','Iqbal','2020-06-20','Female','40 Merchant Street','Flat 3C','Glasgow','G1 1CD','2023-09-01','Active',39),
(560,'Adam','Baker','2021-03-09','Male','41 West End Lane','Flat 4D','Glasgow','G12 9BC','2024-09-01','Active',40),

(561,'Ava','Shaw','2020-05-23','Female','42 Oak Street','Flat 1A','Glasgow','G1 1AA','2023-09-01','Active',41),
(562,'Hugo','Moore','2019-10-28','Male','43 Maple Road','Flat 2B','Glasgow','G1 2AB','2022-09-01','Active',42),
(563,'Sienna','Wong','2021-09-01','Female','44 Willow Close','Flat 3C','Glasgow','G2 3AC','2024-09-01','Active',43),
(564,'Leo','Begum','2020-01-30','Male','45 Birch Avenue','Flat 4D','Glasgow','G3 4AD','2023-09-01','Active',44),
(565,'Esme','Patel','2019-07-07','Female','46 Cedar Lane','Flat 1B','Glasgow','G4 5AE','2022-09-01','Active',45),
(566,'Finn','Singh','2021-02-16','Male','47 Rowan Street','Flat 2C','Glasgow','G2 6AB','2024-09-01','Active',46),
(567,'Archer','Allen','2020-11-11','Male','48 Ash Grove','Flat 3A','Glasgow','G3 2CD','2023-09-01','Active',47),
(568,'Nora','Hussain','2019-08-26','Female','49 Linden Road','Flat 4B','Glasgow','G4 3EF','2022-09-01','Active',48),
(569,'Rowan','Kelly','2021-06-30','Other','50 Elm Crescent','Flat 1C','Glasgow','G5 1GH','2024-09-01','Active',49),
(570,'Skye','Ward','2020-04-04','Female','51 Willowbank Terrace','Flat 2D','Glasgow','G3 6XY','2023-09-01','Active',50),

(571,'Theo','Gibson','2022-01-19','Male','52 Kelvin Street','Flat 3B','Glasgow','G3 8AB','2025-09-01','Active',51),
(572,'Zainab','Murray','2021-10-12','Female','53 Clyde Road','Flat 4C','Glasgow','G2 5CD','2024-09-01','Active',52),
(573,'Amira','Douglas','2020-09-03','Female','54 Regent Park','Flat 1A','Glasgow','G41 2AB','2023-09-01','Active',53),
(574,'Idris','Hunter','2019-03-13','Male','55 Queen Street','Flat 2B','Glasgow','G1 3EF','2022-09-01','Active',54),
(575,'Lena','Blair','2021-05-25','Female','56 River Lane','Flat 3C','Glasgow','G2 4GH','2024-09-01','Active',55),
(576,'Omar','Reid','2020-02-09','Male','57 Sauchiehall Street','Flat 4D','Glasgow','G2 3JJ','2023-09-01','Active',56),
(577,'Priya','Black','2019-06-18','Female','58 Forth Street','Flat 1A','Glasgow','G4 9KL','2022-09-01','Active',57),
(578,'Rafi','Gray','2021-07-27','Male','59 Hillhead Place','Flat 2B','Glasgow','G12 8AA','2024-09-01','Active',58),
(579,'Daisy','Young','2020-10-21','Female','60 Pollokshaws Road','Flat 3C','Glasgow','G41 1BB','2023-09-01','Active',59),
(580,'Freya','Doyle','2019-01-16','Female','61 Yorkhill Street','Flat 4D','Glasgow','G3 8XY','2022-09-01','Active',60),

(581,'Noah','Burns','2020-03-05','Male','62 Oak Street','Flat 1A','Glasgow','G1 1AA','2023-09-01','Active',61),
(582,'Isla','Price','2021-11-29','Female','63 Maple Road','Flat 2B','Glasgow','G1 2AB','2025-09-01','Active',62),
(583,'Leo','Kerr','2019-09-09','Male','64 Willow Close','Flat 3C','Glasgow','G2 3AC','2022-09-01','Active',63),
(584,'Mia','Sharp','2020-06-24','Female','65 Birch Avenue','Flat 4D','Glasgow','G3 4AD','2023-09-01','Active',64),
(585,'Ethan','Holt','2021-02-02','Male','66 Cedar Lane','Flat 1B','Glasgow','G4 5AE','2024-09-01','Active',65),
(586,'Ava','Lowe','2019-08-14','Female','67 Rowan Street','Flat 2C','Glasgow','G2 6AB','2022-09-01','Active',66),
(587,'Sophia','Quinn','2020-12-01','Female','68 Ash Grove','Flat 3A','Glasgow','G3 2CD','2023-09-01','Active',67),
(588,'Liam','Boyd','2021-09-22','Male','69 Linden Road','Flat 4B','Glasgow','G4 3EF','2024-09-01','Active',68),
(589,'Emily','Walsh','2020-01-28','Female','70 Elm Crescent','Flat 1C','Glasgow','G5 1GH','2023-09-01','Active',69),
(590,'Lucas','Kerr','2019-05-04','Male','71 Willowbank Terrace','Flat 2D','Glasgow','G3 6XY','2022-09-01','Active',70),

(591,'Grace','Green','2021-03-19','Female','72 Kelvin Street','Flat 3B','Glasgow','G3 8AB','2024-09-01','Active',71),
(592,'Jacob','Long','2020-07-30','Male','73 Clyde Road','Flat 4C','Glasgow','G2 5CD','2023-09-01','Active',72),
(593,'Chloe','Bell','2019-02-25','Female','74 Regent Park','Flat 1A','Glasgow','G41 2AB','2022-09-01','Active',73),
(594,'Harvey','Fox','2021-01-08','Male','75 Queen Street','Flat 2B','Glasgow','G1 3EF','2024-09-01','Active',74),
(595,'Ruby','Rose','2020-09-17','Female','76 River Lane','Flat 3C','Glasgow','G2 4GH','2023-09-01','Active',75),
(596,'Oscar','Wood','2019-06-03','Male','77 Sauchiehall Street','Flat 4D','Glasgow','G2 3JJ','2022-09-01','Active',76),
(597,'Lily','Khan','2021-05-29','Female','78 Forth Street','Flat 1A','Glasgow','G4 9KL','2024-09-01','Active',77),
(598,'Henry','Hill','2020-11-11','Male','79 Hillhead Place','Flat 2B','Glasgow','G12 8AA','2023-09-01','Active',78),
(599,'Ava','Green','2019-03-07','Female','80 Pollokshaws Road','Flat 3C','Glasgow','G41 1BB','2022-09-01','Active',79),
(600,'Noor','West','2021-07-01','Female','81 Yorkhill Street','Flat 4D','Glasgow','G3 8XY','2024-09-01','Active',80);

SELECT * FROM Student;

INSERT INTO Staff
(StaffID, FirstName, LastName, Designation, Email, HireDate)
VALUES
(201,'Emma','Clark','Teacher','emma.clark@littlesteps.com','2022-08-15'),
(202,'Daniel','Hughes','Teacher','daniel.hughes@littlesteps.com','2023-01-10'),
(203,'Sofia','Martin','Teacher','sofia.martin@littlesteps.com','2021-09-01'),
(204,'Hannah','Reed','Teacher','hannah.reed@littlesteps.com','2020-04-12'),
(205,'James','Stewart','Teacher','james.stewart@littlesteps.com','2023-03-25'),
(206,'Alicia','Brown','Teacher','alicia.brown@littlesteps.com','2024-06-01'),
(207,'Michael','Fraser','Teacher','michael.fraser@littlesteps.com','2019-11-18'),
(208,'Zara','Ahmed','Teacher','zara.ahmed@littlesteps.com','2021-02-05'),
(209,'Linda','Wallace','Housekeeping','linda.wallace@littlesteps.com','2018-05-10'),
(210,'Peter','Grant','Housekeeping','peter.grant@littlesteps.com','2020-07-22'),
(211,'Raj','Singh','Driver','raj.singh@littlesteps.com','2024-03-01');

SELECT * FROM Staff;

INSERT INTO Class
(ClassID, ClassName, AgeGroup, Capacity, StaffID)
VALUES
(1,'Play School A','2–3 Years',20,201),
(2,'Play School B','2–3 Years',20,202),
(3,'Nursery A','3–4 Years',20,203),
(4,'Nursery B','3–4 Years',20,204),
(5,'Jr KG A','4–5 Years',20,205),
(6,'Jr KG B','4–5 Years',20,206),
(7,'Sr KG A','5–6 Years',25,207),
(8,'Sr KG B','5–6 Years',25,208);

SELECT * FROM Class;

INSERT INTO Enrolment (StudentID, ClassID, EnrolStartDate, EnrolEndDate)
SELECT
    s.StudentID,
    CASE
        -- Age < 3 (includes below 2 and exactly 2) → Play School (Class 1 or 2)
        WHEN TIMESTAMPDIFF(YEAR, s.DateOfBirth, '2025-09-01') < 3 THEN
            CASE WHEN MOD(s.StudentID, 2) = 1 THEN 1 ELSE 2 END
        
        -- Age 3 → Nursery (Class 3 or 4)
        WHEN TIMESTAMPDIFF(YEAR, s.DateOfBirth, '2025-09-01') = 3 THEN
            CASE WHEN MOD(s.StudentID, 2) = 1 THEN 3 ELSE 4 END
        
        -- Age 4 → Jr KG (Class 5 or 6)
        WHEN TIMESTAMPDIFF(YEAR, s.DateOfBirth, '2025-09-01') = 4 THEN
            CASE WHEN MOD(s.StudentID, 2) = 1 THEN 5 ELSE 6 END
        
        -- Age 5 or 6 → Sr KG (Class 7 or 8)
        WHEN TIMESTAMPDIFF(YEAR, s.DateOfBirth, '2025-09-01') IN (5,6) THEN
            CASE WHEN MOD(s.StudentID, 2) = 1 THEN 7 ELSE 8 END
        
        -- Age > 6 → also Sr KG (safety fallback)
        ELSE
            CASE WHEN MOD(s.StudentID, 2) = 1 THEN 7 ELSE 8 END
    END AS ClassID,
    '2025-09-01' AS EnrolStartDate,
    NULL AS EnrolEndDate
FROM Student s;


SELECT 
    e.StudentID,
    s.DateOfBirth,
    TIMESTAMPDIFF(YEAR, s.DateOfBirth, '2025-09-01') AS Age,
    e.ClassID
FROM Enrolment e
JOIN Student s ON e.StudentID = s.StudentID
ORDER BY e.StudentID
LIMIT 20;

INSERT INTO Logistics
(StudentID,
 ModeOfTransportToSchool,
 ModeOfTransportFromSchool,
 PickupDropoffContactName,
 PickupDropoffContactPhone,
 PickupLocation,
 Notes)
VALUES
(501,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(502,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(503,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(504,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(505,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Parent drops in morning, bus home'),
(506,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(507,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(508,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(509,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Bus to school, parent pick-up'),
(510,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(511,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(512,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(513,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(514,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(515,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(516,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(517,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(518,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(519,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(520,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(521,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Parent drops in morning, bus home'),
(522,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(523,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(524,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(525,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(526,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(527,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(528,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(529,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(530,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(531,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Bus to school, parent pick-up'),
(532,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(533,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(534,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(535,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(536,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(537,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(538,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(539,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(540,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(541,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Bus to school, parent pick-up'),
(542,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(543,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(544,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(545,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(546,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(547,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(548,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(549,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(550,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(551,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(552,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(553,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(554,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(555,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Parent drops in morning, bus home'),
(556,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(557,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(558,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(559,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(560,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(561,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(562,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(563,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(564,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(565,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(566,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(567,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(568,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(569,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Parent drops in morning, bus home'),
(570,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(571,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Bus to school, parent pick-up'),
(572,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(573,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(574,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(575,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(576,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(577,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(578,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(579,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(580,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(581,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(582,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(583,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Parent drops in morning, bus home'),
(584,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(585,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(586,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(587,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(588,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(589,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Parent drops in morning, bus home'),
(590,'Parent','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(591,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(592,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(593,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Bus to school, parent pick-up'),
(594,'SchoolTransport','Parent','Raj Singh','07123456780','Home address','Sibling – same mixed pattern'),

(595,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(596,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine'),

(597,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','School minibus both ways'),
(598,'SchoolTransport','SchoolTransport','Raj Singh','07123456780','Home address','Sibling – same bus route'),

(599,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Parent drop-off and pick-up'),
(600,'Parent','Parent','Parent/Guardian','07111111111',NULL,'Sibling – same parent routine');

SELECT COUNT(*) FROM Logistics;

SELECT * FROM Logistics;

SELECT 
  ModeOfTransportToSchool,
  ModeOfTransportFromSchool,
  COUNT(*) AS NumStudents
FROM Logistics
GROUP BY ModeOfTransportToSchool, ModeOfTransportFromSchool;       

INSERT INTO Payment
(PaymentID, StudentID, AcademicYear, Quarter,
 TuitionAmountDue, TuitionAmountPaid,
 TransportAmountDue, TransportAmountPaid,
 PaymentDate, PaymentMethod,
 TuitionStatus, TransportStatus)
VALUES
(1001, 501, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Card', 'Paid', 'Not Applicable'),
(1002, 502, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1003, 503, '2025-2026', 'Full', 2700.00, 2700.00, 300.00, 300.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Paid'),
(1004, 504, '2025-2026', 'Full', 2700.00, 2700.00, 300.00, 150.00, '2025-08-20', 'Card', 'Paid', 'Partially Paid'),
(1005, 505, '2025-2026', 'Full', 2700.00, 2700.00, 150.00, 75.00, '2025-08-20', 'Cash', 'Paid', 'Partially Paid'),
(1006, 506, '2025-2026', 'Full', 2700.00, 2700.00, 150.00, 0.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Unpaid'),
(1007, 507, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Card', 'Paid', 'Not Applicable'),
(1008, 508, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1009, 509, '2025-2026', 'Full', 2700.00, 2700.00, 150.00, 150.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Paid'),
(1010, 510, '2025-2026', 'Full', 2700.00, 2700.00, 150.00, 75.00, '2025-08-20', 'Card', 'Paid', 'Partially Paid'),
(1011, 511, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1012, 512, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Not Applicable'),
(1013, 513, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Card', 'Paid', 'Not Applicable'),
(1014, 514, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1015, 515, '2025-2026', 'Full', 2700.00, 2700.00, 300.00, 300.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Paid'),
(1016, 516, '2025-2026', 'Full', 2700.00, 2700.00, 300.00, 150.00, '2025-08-20', 'Card', 'Paid', 'Partially Paid'),
(1017, 517, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1018, 518, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Not Applicable'),
(1019, 519, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Card', 'Paid', 'Not Applicable'),
(1020, 520, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1021, 521, '2025-2026', 'Full', 2700.00, 2700.00, 150.00, 150.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Paid'),
(1022, 522, '2025-2026', 'Full', 2700.00, 2700.00, 150.00, 75.00, '2025-08-20', 'Card', 'Paid', 'Partially Paid'),
(1023, 523, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1024, 524, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Not Applicable'),
(1025, 525, '2025-2026', 'Full', 2700.00, 2700.00, 300.00, 300.00, '2025-08-20', 'Card', 'Paid', 'Paid'),
(1026, 526, '2025-2026', 'Full', 2700.00, 2700.00, 300.00, 150.00, '2025-08-20', 'Cash', 'Paid', 'Partially Paid'),
(1027, 527, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Not Applicable'),
(1028, 528, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Card', 'Paid', 'Not Applicable'),
(1029, 529, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Cash', 'Paid', 'Not Applicable'),
(1030, 530, '2025-2026', 'Full', 2700.00, 2700.00, 0.00, 0.00, '2025-08-20', 'Bank Transfer', 'Paid', 'Not Applicable'),
(1031, 531, '2025-2026', 'Full', 2700.00, 1350.00, 150.00, 150.00, '2025-10-15', 'Card', 'Partially Paid', 'Paid'),
(1032, 532, '2025-2026', 'Full', 2700.00, 1350.00, 150.00, 75.00, '2025-10-15', 'Cash', 'Partially Paid', 'Partially Paid'),
(1033, 533, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Not Applicable'),
(1034, 534, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1035, 535, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Cash', 'Partially Paid', 'Not Applicable'),
(1036, 536, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Not Applicable'),
(1037, 537, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1038, 538, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Cash', 'Partially Paid', 'Not Applicable'),
(1039, 539, '2025-2026', 'Full', 2700.00, 1350.00, 300.00, 300.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Paid'),
(1040, 540, '2025-2026', 'Full', 2700.00, 1350.00, 300.00, 150.00, '2025-10-15', 'Card', 'Partially Paid', 'Partially Paid'),
(1041, 541, '2025-2026', 'Full', 2700.00, 1350.00, 150.00, 75.00, '2025-10-15', 'Cash', 'Partially Paid', 'Partially Paid'),
(1042, 542, '2025-2026', 'Full', 2700.00, 1350.00, 150.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Unpaid'),
(1043, 543, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1044, 544, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Cash', 'Partially Paid', 'Not Applicable'),
(1045, 545, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Not Applicable'),
(1046, 546, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1047, 547, '2025-2026', 'Full', 2700.00, 1350.00, 300.00, 300.00, '2025-10-15', 'Cash', 'Partially Paid', 'Paid'),
(1048, 548, '2025-2026', 'Full', 2700.00, 1350.00, 300.00, 150.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Partially Paid'),
(1049, 549, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1050, 550, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Cash', 'Partially Paid', 'Not Applicable'),
(1051, 551, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Not Applicable'),
(1052, 552, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1053, 553, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Cash', 'Partially Paid', 'Not Applicable'),
(1054, 554, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Not Applicable'),
(1055, 555, '2025-2026', 'Full', 2700.00, 1350.00, 150.00, 150.00, '2025-10-15', 'Card', 'Partially Paid', 'Paid'),
(1056, 556, '2025-2026', 'Full', 2700.00, 1350.00, 150.00, 75.00, '2025-10-15', 'Cash', 'Partially Paid', 'Partially Paid'),
(1057, 557, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Not Applicable'),
(1058, 558, '2025-2026', 'Full', 2700.00, 1350.00, 0.00, 0.00, '2025-10-15', 'Card', 'Partially Paid', 'Not Applicable'),
(1059, 559, '2025-2026', 'Full', 2700.00, 1350.00, 300.00, 300.00, '2025-10-15', 'Cash', 'Partially Paid', 'Paid'),
(1060, 560, '2025-2026', 'Full', 2700.00, 1350.00, 300.00, 150.00, '2025-10-15', 'Bank Transfer', 'Partially Paid', 'Partially Paid'),
(1061, 561, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1062, 562, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1063, 563, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 300.00, NULL, 'Bank Transfer', 'Unpaid', 'Paid'),
(1064, 564, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 150.00, NULL, 'Card', 'Unpaid', 'Partially Paid'),
(1065, 565, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1066, 566, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Not Applicable'),
(1067, 567, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1068, 568, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1069, 569, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 150.00, NULL, 'Bank Transfer', 'Unpaid', 'Paid'),
(1070, 570, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 75.00, NULL, 'Card', 'Unpaid', 'Partially Paid'),
(1071, 571, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 0.00, NULL, 'Cash', 'Unpaid', 'Unpaid'),
(1072, 572, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 150.00, NULL, 'Bank Transfer', 'Unpaid', 'Paid'),
(1073, 573, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1074, 574, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1075, 575, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 300.00, NULL, 'Bank Transfer', 'Unpaid', 'Paid'),
(1076, 576, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 150.00, NULL, 'Card', 'Unpaid', 'Partially Paid'),
(1077, 577, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1078, 578, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Not Applicable'),
(1079, 579, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 300.00, NULL, 'Card', 'Unpaid', 'Paid'),
(1080, 580, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 150.00, NULL, 'Cash', 'Unpaid', 'Partially Paid'),
(1081, 581, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Not Applicable'),
(1082, 582, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1083, 583, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 150.00, NULL, 'Cash', 'Unpaid', 'Paid'),
(1084, 584, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 75.00, NULL, 'Bank Transfer', 'Unpaid', 'Partially Paid'),
(1085, 585, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1086, 586, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1087, 587, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Not Applicable'),
(1088, 588, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1089, 589, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 150.00, NULL, 'Cash', 'Unpaid', 'Paid'),
(1090, 590, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 75.00, NULL, 'Bank Transfer', 'Unpaid', 'Partially Paid'),
(1091, 591, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable'),
(1092, 592, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1093, 593, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Unpaid'),
(1094, 594, '2025-2026', 'Full', 2700.00, 0.00, 150.00, 150.00, NULL, 'Card', 'Unpaid', 'Paid'),
(1095, 595, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Cash', 'Unpaid', 'Not Applicable'),
(1096, 596, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Not Applicable'),
(1097, 597, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 300.00, NULL, 'Card', 'Unpaid', 'Paid'),
(1098, 598, '2025-2026', 'Full', 2700.00, 0.00, 300.00, 150.00, NULL, 'Cash', 'Unpaid', 'Partially Paid'),
(1099, 599, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Bank Transfer', 'Unpaid', 'Not Applicable'),
(1100, 600, '2025-2026', 'Full', 2700.00, 0.00, 0.00, 0.00, NULL, 'Card', 'Unpaid', 'Not Applicable');

SELECT p.StudentID, l.ModeOfTransportToSchool, l.ModeOfTransportFromSchool,
       p.TransportAmountDue, p.TransportAmountPaid, p.TransportStatus
FROM Payment p
JOIN Logistics l ON p.StudentID = l.StudentID
WHERE p.TransportAmountDue > 0;

SELECT * FROM Payment LIMIT 20;


-- Q1: List each student with their parent contact, class and teacher
SELECT 
    s.StudentID,
    s.FirstName AS StudentFirstName,
    s.LastName  AS StudentLastName,
    c.ClassName,
    CONCAT(st.FirstName, ' ', st.LastName) AS TeacherName,
    p.MotherName AS PrimaryContactName,
    p.MotherPhone AS PrimaryContactPhone
FROM Enrolment e
JOIN Student s ON e.StudentID = s.StudentID
JOIN Class c   ON e.ClassID = c.ClassID
JOIN Staff st  ON c.StaffID = st.StaffID
JOIN Parent p  ON s.ParentID = p.ParentID
ORDER BY c.ClassName, s.LastName, s.FirstName
LIMIT 10;

-- Q2: Show class sizes and flag classes that are close to or over capacity
SELECT 
    c.ClassID,
    c.ClassName,
    c.Capacity,
    COUNT(e.StudentID) AS CurrentStudents,
    (COUNT(e.StudentID) - c.Capacity) AS OverBy
FROM Class c
JOIN Enrolment e ON c.ClassID = e.ClassID
GROUP BY c.ClassID, c.ClassName, c.Capacity
HAVING COUNT(e.StudentID) >= 15;   -- only show reasonably full classes


-- Q3: Find parents who have more than one child enrolled (siblings/twins)
SELECT 
    p.ParentID,
    p.MotherName,
    p.FatherName,
    child_counts.NumChildren
FROM Parent p
JOIN (
    SELECT ParentID, COUNT(*) AS NumChildren
    FROM Student
    GROUP BY ParentID
    HAVING COUNT(*) > 1
) AS child_counts
ON p.ParentID = child_counts.ParentID
ORDER BY child_counts.NumChildren DESC, p.ParentID;

-- Q4: Students who have fully paid their tuition fees
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    p.TuitionAmountDue,
    p.TuitionAmountPaid,
    p.TuitionStatus
FROM Student s
JOIN Payment p ON s.StudentID = p.StudentID
WHERE EXISTS (
    SELECT 1
    FROM Payment p2
    WHERE p2.StudentID = s.StudentID
      AND p2.TuitionStatus = 'Paid'
)
ORDER BY s.StudentID
LIMIT 10;

-- Q5: For each student, show class size and their age order within that class
SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.DateOfBirth,
    c.ClassName,
    COUNT(*) OVER (PARTITION BY e.ClassID) AS ClassSize,
    ROW_NUMBER() OVER (
        PARTITION BY e.ClassID
        ORDER BY s.DateOfBirth
    ) AS AgeRankInClass  -- 1 = oldest in that class
FROM Enrolment e
JOIN Student s ON e.StudentID = s.StudentID
JOIN Class c   ON e.ClassID = c.ClassID
ORDER BY c.ClassName, AgeRankInClass
LIMIT 10;

-- Q6: Flag each student as Low / Medium / High fee-risk
SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    p.TuitionStatus,
    p.TransportStatus,
    CASE
        WHEN p.TuitionStatus = 'Paid'
         AND (p.TransportStatus = 'Paid' OR p.TransportStatus = 'Not Applicable')
            THEN 'Low Risk'
        WHEN p.TuitionStatus = 'Partially Paid'
          OR p.TransportStatus = 'Partially Paid'
            THEN 'Medium Risk'
        WHEN p.TuitionStatus = 'Unpaid'
          OR p.TransportStatus = 'Unpaid'
            THEN 'High Risk'
        ELSE 'Unknown'
    END AS FeeRiskCategory
FROM Student s
JOIN Payment p ON s.StudentID = p.StudentID
ORDER BY FeeRiskCategory, s.StudentID
LIMIT 5;

-- Q7: Total transport revenue by transport pattern (both ways / one-way / none)
SELECT
    CASE
        WHEN l.ModeOfTransportToSchool = 'SchoolTransport'
         AND l.ModeOfTransportFromSchool = 'SchoolTransport'
            THEN 'Both ways (bus)'
        WHEN l.ModeOfTransportToSchool = 'SchoolTransport'
         AND l.ModeOfTransportFromSchool = 'Parent'
            THEN 'Bus to school only'
        WHEN l.ModeOfTransportToSchool = 'Parent'
         AND l.ModeOfTransportFromSchool = 'SchoolTransport'
            THEN 'Bus home only'
        ELSE 'No school transport'
    END AS TransportPattern,
    COUNT(DISTINCT l.StudentID) AS NumStudents,
    SUM(p.TransportAmountDue) AS TotalTransportDue,
    SUM(p.TransportAmountPaid) AS TotalTransportPaid
FROM Logistics l
JOIN Payment p ON l.StudentID = p.StudentID
GROUP BY TransportPattern
ORDER BY TotalTransportPaid DESC;

-- Q8: Show outstanding amount per student and grand total outstanding
SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    (p.TuitionAmountDue   - p.TuitionAmountPaid) +
    (p.TransportAmountDue - p.TransportAmountPaid) AS OutstandingAmount,
    SUM(
        (p.TuitionAmountDue   - p.TuitionAmountPaid) +
        (p.TransportAmountDue - p.TransportAmountPaid)
    ) OVER () AS GrandTotalOutstanding
FROM Student s
JOIN Payment p ON s.StudentID = p.StudentID
WHERE (p.TuitionAmountDue   - p.TuitionAmountPaid) +
      (p.TransportAmountDue - p.TransportAmountPaid) > 0
ORDER BY OutstandingAmount DESC, s.StudentID;


