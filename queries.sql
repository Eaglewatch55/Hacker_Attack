-- STAGE 1
CREATE TABLE "person"(
  "person_id" VARCHAR(9) PRIMARY KEY,
  "full_name" TEXT,
  "address" TEXT,
  "building_number" TEXT,
  "phone_number" TEXT
);

.mode csv
.import --skip 1 person.csv person
.mode column

SELECT 
    person_id, 
    full_name
FROM
    person
ORDER BY
    person_id
LIMIT
    5;

-- STAGE 2

CREATE TABLE "teacher"(
    "person_id" VARCHAR(9) PRIMARY KEY,
    "class_code" TEXT
);

.mode csv
.import --skip 1 teacher.csv teacher
.mode column

SELECT 
    person_id,
    full_name
FROM 
    person
WHERE person_id IN (
    SELECT 
        person_id
    FROM 
        person
    EXCEPT
    SELECT
        person_id
    FROM
        teacher
)
ORDER BY
    full_name
LIMIT
    5;


SELECT 
    COUNT(person_id) 
FROM
    person
WHERE person_id IN (
    SELECT 
        person_id
    FROM 
        person
    EXCEPT
    SELECT
        person_id
    FROM
        teacher
);

-- STAGE 3

CREATE TABLE student (
    "person_id" VARCHAR(9) PRIMARY KEY,
    "grade_code" TEXT
);

INSERT INTO student (person_id)
    SELECT 
        person_id
    FROM 
        person
    WHERE person_id IN (
        SELECT 
            person_id
        FROM 
            person
        EXCEPT
        SELECT
            person_id
        FROM
            teacher);

SELECT * 
FROM student
ORDER BY person_id
LIMIT 5;

-- STAGE 4

CREATE TABLE score1 (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

CREATE TABLE score2 (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

CREATE TABLE score3 (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

.mode csv
.import --skip 1 score1.csv score1
.import --skip 1 score2.csv score2
.import --skip 1 score3.csv score3
.mode column

SELECT * FROM score1
UNION ALL
SELECT * FROM score2
UNION ALL
SELECT * FROM score3;

-- STAGE 5

CREATE TABLE score (
    "person_id" VARCHAR(9),
    "score" INTEGER
);

INSERT INTO score (person_id, score)
    SELECT * FROM score1
    UNION ALL
    SELECT * FROM score2
    UNION ALL
    SELECT * FROM score3;

DROP TABLE score1;
DROP TABLE score2;
DROP TABLE score3;

SELECT * FROM score
ORDER BY person_id
LIMIT 5;

SELECT person_id, count(score)
FROM score
GROUP BY person_id
HAVING count(score) = 3
ORDER BY person_id
LIMIT 5;

-- STAGE 6

UPDATE student
SET grade_code = 'GD-10'
WHERE student.person_id IN
    (SELECT person_id
    FROM score
    GROUP BY person_id
    HAVING count(score) = 1);

UPDATE student
SET grade_code = 'GD-11'
WHERE student.person_id IN
    (SELECT person_id
    FROM score
    GROUP BY person_id
    HAVING count(score) = 2);

UPDATE student
SET grade_code = 'GD-12'
WHERE student.person_id IN
    (SELECT person_id
    FROM score
    GROUP BY person_id
    HAVING count(score) = 3);

UPDATE student
SET grade_code = 'GD-09'
WHERE grade_code ISNULL;

SELECT * FROM student
ORDER BY person_id
LIMIT 5;

-- STAGE 7

/*Select all records from the score table. 
Calculate the average score as avg_score. 
Round to 2 decimal places. 
Display it if the grade_code is GD-12 in the student table. 
Group by person_id and order the results by avg_score in descending order;*/

SELECT 
    person_id, 
    ROUND(AVG(score),2) as avg_score
FROM score
WHERE score.person_id IN (
    SELECT person_id FROM student
    WHERE student.grade_code = 'GD-12')
GROUP BY person_id
ORDER BY avg_score DESC
;
