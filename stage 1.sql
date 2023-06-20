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