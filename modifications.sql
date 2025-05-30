--Add gender column for the student table[Enum]. It holds two value (male or female)

-- Step 1: Add the gender column to the Students table
ALTER TABLE Students
ADD COLUMN gender TEXT CHECK (gender IN ('male', 'female'));

-- Step 2: Update existing student records with gender information
UPDATE Students SET gender = 'female' WHERE id = 1;
UPDATE Students SET gender = 'male' WHERE id = 2;
UPDATE Students SET gender = 'male' WHERE id = 3;
UPDATE Students SET gender = 'male' WHERE id = 4;
UPDATE Students SET gender = 'female' WHERE id = 5;


--2. Add birth date column for the student table.

-- Step 1: Add the birth_date column to the Students table
ALTER TABLE Students
ADD COLUMN birth_date DATE;

-- Step 2: Update existing student records with birth date information
UPDATE Students SET birth_date = '2000-01-15' WHERE id = 1;
UPDATE Students SET birth_date = '1999-05-22' WHERE id = 2;
UPDATE Students SET birth_date = '2001-03-10' WHERE id = 3;
UPDATE Students SET birth_date = '1998-07-30' WHERE id = 4;
UPDATE Students SET birth_date = '2000-11-05' WHERE id = 5;


--3-Delete the name column and replace it with two columns first name and last name

-- Step 1: Add the first_name and last_name columns to the Students table
ALTER TABLE Students
ADD COLUMN first_name TEXT,
ADD COLUMN last_name TEXT;

-- Step 2: Update existing student records with first_name and last_name
UPDATE Students SET first_name = 'Alice', last_name = 'Johnson' WHERE id = 1;
UPDATE Students SET first_name = 'Bob', last_name = 'Smith' WHERE id = 2;
UPDATE Students SET first_name = 'Charlie', last_name = 'Brown' WHERE id = 3;
UPDATE Students SET first_name = 'David', last_name = 'Wilson' WHERE id = 4;
UPDATE Students SET first_name = 'Eva', last_name = 'Green' WHERE id = 5;

-- Step 3: Drop the name column
ALTER TABLE Students
DROP COLUMN name;



--4. Delete the address and email column and replace it with contact info (Address, email) as object/Composite Data type.


-- Step 1: Create a composite type for contact_info
CREATE TYPE contact_info AS (
    address TEXT,
    email TEXT
);

-- Step 2: Add the contact_info column to the Students table
ALTER TABLE Students
ADD COLUMN contact_info contact_info;

-- Step 3: Update existing student records with contact_info
UPDATE Students SET contact_info = ROW('123 Main St', 'alice@example.com') WHERE id = 1;
UPDATE Students SET contact_info = ROW('456 Elm St', 'bob@example.com') WHERE id = 2;
UPDATE Students SET contact_info = ROW('789 Maple St', 'charlie@example.com') WHERE id = 3;
UPDATE Students SET contact_info = ROW('101 Oak St', 'david@example.com') WHERE id = 4;
UPDATE Students SET contact_info = ROW('202 Pine St', 'eva@example.com') WHERE id = 5;

-- Step 4: Drop the address and email columns
ALTER TABLE Students
DROP COLUMN address,
DROP COLUMN email;



--5. Change any Serial Datatype at your tables to smallInt

-- For Tracks table
ALTER TABLE Tracks ALTER COLUMN id TYPE smallint;

ALTER TABLE track_subject ALTER COLUMN track_id TYPE smallint;

ALTER TABLE student_track ALTER COLUMN track_id TYPE smallint;



--6. Add/Alter foreign key constrains in Tables.

-- Ensure foreign key constraints are set for Phones table
ALTER TABLE Phones
DROP CONSTRAINT IF EXISTS phones_student_id_fkey,
ADD CONSTRAINT phones_student_id_fkey FOREIGN KEY (student_id) REFERENCES Students(id);

-- Ensure foreign key constraints are set for Exams table
ALTER TABLE Exams
DROP CONSTRAINT IF EXISTS exams_subject_id_fkey,
ADD CONSTRAINT exams_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES Subjects(id);

-- Ensure foreign key constraints are set for Student_Track table
ALTER TABLE Student_Track
DROP CONSTRAINT IF EXISTS student_track_student_id_fkey,
DROP CONSTRAINT IF EXISTS student_track_track_id_fkey,
ADD CONSTRAINT student_track_student_id_fkey FOREIGN KEY (student_id) REFERENCES Students(id),
ADD CONSTRAINT student_track_track_id_fkey FOREIGN KEY (track_id) REFERENCES Tracks(id);

-- Ensure foreign key constraints are set for Track_Subject table
ALTER TABLE Track_Subject
DROP CONSTRAINT IF EXISTS track_subject_track_id_fkey,
DROP CONSTRAINT IF EXISTS track_subject_subject_id_fkey,
ADD CONSTRAINT track_subject_track_id_fkey FOREIGN KEY (track_id) REFERENCES Tracks(id),
ADD CONSTRAINT track_subject_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES Subjects(id);

-- Ensure foreign key constraints are set for Student_Subject table
ALTER TABLE Student_Subject
DROP CONSTRAINT IF EXISTS student_subject_student_id_fkey,
DROP CONSTRAINT IF EXISTS student_subject_subject_id_fkey,
ADD CONSTRAINT student_subject_student_id_fkey FOREIGN KEY (student_id) REFERENCES Students(id),
ADD CONSTRAINT student_subject_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES Subjects(id);

-- Ensure foreign key constraints are set for Student_Exam table
ALTER TABLE Student_Exam
DROP CONSTRAINT IF EXISTS student_exam_student_id_fkey,
DROP CONSTRAINT IF EXISTS student_exam_exam_id_fkey,
ADD CONSTRAINT student_exam_student_id_fkey FOREIGN KEY (student_id) REFERENCES Students(id),
ADD CONSTRAINT student_exam_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES Exams(id);



--8. Display all students’ information.
SELECT * FROM Students;

--9. Display male students only.

 SELECT * FROM Students WHERE gender = 'male';


--10.Display the number of female students.

 SELECT phone_number FROM phones JOIN students ON phones.student_id = students.id WHERE students.


--11.Display the students who are born before 1992-10-01.

 select first_name from students where birth_date < '2000-01-01';

--12.Display male students who are born before 1991-10-01.

select first_name from students where birth_date < '2000-01-01' and gender = 'male';

--13.Display subjects and their max score sorted by max score.

select name , max_score from subjects order by max_score;


--14.Display the subject with highest max score


SELECT name, max_score FROM subjects ORDER BY max_score DESC LIMIT 1;


--15.Display students’ names that begin with A.

 select first_name from students where first_name LIKE 'A%';


--16.Display the number of students’ their name is “Alice”


 select phone_number from phones join students on phones.student_id = students.id where students.
first_name = 'Alice';



--17.Display the number of males and females.


SELECT students.gender, phones.phone_number
FROM phones
JOIN students ON phones.student_id = students.id
GROUP BY students.gender, phones.phone_number;

--18.Display the repeated first names and their counts if higher than 2.


SELECT first_name, COUNT(first_name) AS count
FROM students
GROUP BY first_name
HAVING COUNT(first_name) > 2;




--19.Display the all Students and track name that belong to it


SELECT s.first_name, s.last_name, t.name AS track_name
FROM students s
LEFT JOIN student_track st ON s.id = st.student_id
LEFT JOIN tracks t ON st.track_id = t.id;




--20-Display students’ names, their score and subject name



select s.first_name, s.last_name , sub.name as subject, se.score as score
from students s
join student_subject on s.id = student_subject.student_id
join subjects sub on sub.id = student_subject.subject_id
join student_exam se on s.id = se.student_id;














