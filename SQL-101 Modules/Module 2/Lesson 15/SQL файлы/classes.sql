CREATE TABLE IF NOT EXISTS school."classes" (
    "id" INT,
    "description" TEXT,
    "weeks" INT,
    "enrollment_cap" INT,
     PRIMARY KEY("id")
);
INSERT INTO school."classes" VALUES
    (1,'Intro to Javascript',10,30),
    (2,'Intro to Python',12,35),
    (3,'Intermediate SQL',8,32),
    (4,'D3-js for Beginners',6,35),
    (5,'Probability and Statistics',10,31);
