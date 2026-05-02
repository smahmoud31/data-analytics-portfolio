--this script's purpose is to clean the patient data from the diabetes_data table (imported from diabetic_data.csv)

--creating a new table to run queries on to preserve the original data
CREATE TABLE clean_diabetes_data LIKE diabetes_data;
INSERT INTO clean_diabetes_data SELECT * FROM diabetes_data;
--check if it worked properly
SELECT * FROM clean_diabetes_data LIMIT 5;

--shows that char length of readmitted values is too long to be just what we need, blankspace issue
SELECT readmitted,
LENGTH(readmitted) as LENGTH
FROM clean_diabetes_data;

-- check which characters are at the beginning and end of the values
SELECT 
    readmitted,
    LENGTH(readmitted) as original_length,
    ORD(LEFT(readmitted, 1)) as first_char_ascii,
    ORD(RIGHT(readmitted, 1)) as last_char_ascii
FROM clean_diabetes_data;
--ascii 13 is the last character for all of them, so we'll be sure to remove that

--first preview the change where we eliminate spaces and linebreaks
SELECT readmitted,
REPLACE(REPLACE(TRIM(readmitted), '\r', ''), '\n', '') as readmitted_new,
LENGTH(REPLACE(REPLACE(TRIM(readmitted), '\r', ''), '\n', '')) as new_length
FROM clean_diabetes_data;
--then safely make the change permanent in our duplcated table
UPDATE clean_diabetes_data
SET readmitted = REPLACE(REPLACE(TRIM(readmitted), '\r', ''), '\n', '');
--check if it worked as intended
SELECT readmitted,
LENGTH(readmitted) as LENGTH
FROM clean_diabetes_data;

