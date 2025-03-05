--Insert new student and his score in exam in different subjects as transaction and save it.
--Insert new students and his score in exam in different subjects as transaction and undo it.

DO $$
DECLARE
    new_student_id INT;
    new_exam_id INT;
BEGIN

    INSERT INTO Students (first_name, last_name, gender, birth_date, contact_info)
    VALUES ('John', 'Doe', 'male', '2002-08-15', ROW('789 Birch St', 'john.doe@example.com'))
    RETURNING id INTO new_student_id;


    INSERT INTO Exams (subject_id, exam_date)
    VALUES (3, '2023-12-01')
    RETURNING id INTO new_exam_id;


    INSERT INTO Student_Exam (student_id, exam_id, score)
    VALUES (new_student_id, new_exam_id, 99);

    COMMIT;
END $$;




DO $$
DECLARE
    new_student_id INT;
    new_exam_id INT;
BEGIN

    INSERT INTO Students (first_name, last_name, gender, birth_date, contact_info)
    VALUES ('John', 'Doe', 'male', '2002-08-15', ROW('789 Birch St', 'john.doe@example.com'))
    RETURNING id INTO new_student_id;


    INSERT INTO Exams (subject_id, exam_date)
    VALUES (3, '2023-12-01')
    RETURNING id INTO new_exam_id;


    INSERT INTO Student_Exam (student_id, exam_id, score)
    VALUES (new_student_id, new_exam_id, 99);

    ROLLBACK;
END $$;


-- Create a view for student names with their Tracks names which is belong to it.

CREATE VIEW students_track AS
SELECT s.first_name, t.name AS track_name
FROM Students s
JOIN student_track st ON s.id = st.student_id
JOIN Tracks t ON st.track_id = t.id;


-- Create a view for Tracks names and the subjects which is belong/study to it.

CREATE VIEW subjects_track AS
SELECT t.name AS Tarck_Name, s.name AS subject_name
FROM Tracks t
JOIN track_subject ts ON t.id = ts.track_id
JOIN Subjects s ON ts.subject_id = s.id;


--Create a view for student names with their subject's names which will study.

CREATE VIEW Student_Subject_View AS
SELECT s.first_name , s.last_name , sj.name AS subject_name
FROM Students s
JOIN student_subject ss ON ss.student_id = s.id
JOIN subjects sj ON ss.subject_id = sj.id;


--Create a view for all students name (Full Name) with their score in each subject and its date.

CREATE VIEW students_scores_view AS
SELECT s.first_name,
       s.last_name,
       sj.name AS subject_name,
       se.score,
       e.exam_date
FROM Students s
JOIN student_exam se ON s.id = se.student_id
JOIN exams e ON e.id = se.exam_id
JOIN subjects sj ON e.subject_id = sj.id;


--Create a temporary view for all subjects with their max_score.

CREATE TEMP VIEW Temp_Subjects_MaxScore AS
SELECT name, max_score FROM subjects;

--Create user and give him all privileges.

CREATE USER Tarek WITH PASSWORD '123';
GRANT ALL ON Students TO Tarek;


-- Display the date of exam as the following: day 'month name' year.

SELECT TO_CHAR(exam_date, 'DD " " Month " " YYYY')
FROM students_scores_view;

--Display name and age of each students

SELECT first_name ,last_name ,
       EXTRACT(YEAR FROM AGE(birth_date))
FROM Students;



--Display the name of students with their Rounded score in each subject


SELECT s.first_name , sj.name AS subject ,round(se.score, 2) AS score
FROM Students s
JOIN student_exam se ON s.id = se.student_id
JOIN exams ON exams.id = se.exam_id
JOIN subjects sj ON exams.subject_id = sj.id;



--Display the name of students with the year of Birthdate

SELECT first_name ,last_name,
       EXTRACT(YEAR FROM birth_date) AS birth_year
FROM Students;



Add new exam result, in date column use NOW() function;

INSERT INTO Exams (subject_id, exam_date)
VALUES (2, NOW());


--CREATE NEW SCHEMA

-- Step 1: Create a new schema named Employee
CREATE SCHEMA Employee;

-- Step 2: Create tables within the Employee schema

-- Create an Employees table
CREATE TABLE Employee.Employees (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender TEXT CHECK (gender IN ('male', 'female')),
    birth_date DATE,
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Create a Departments table
CREATE TABLE Employee.Departments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    department_name TEXT NOT NULL,
    location TEXT
);

-- Create an Employee_Departments table to link Employees and Departments
CREATE TABLE Employee.Employee_Departments (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    employee_id BIGINT REFERENCES Employee.Employees(id),
    department_id BIGINT REFERENCES Employee.Departments(id),
    start_date DATE DEFAULT CURRENT_DATE
);



-- CREATE INDEXES FOR EMPLOYEE SCHEMA TABLES TO IMPROVE PERFORMANCE

CREATE INDEX idx_last_name ON Employee.Employees(last_name);


CREATE INDEX idx_department_name ON Employee.Departments(department_name);

-- Create a composite index on employee_id and department_id columns

CREATE INDEX idx_employee_department ON Employee.Employee_Departments(employee_id, department_id);


-- CREATE Transaction to insert new employee and new department and link them together

BEGIN;

INSERT INTO Employee.Employees (first_name, last_name, gender, birth_date, hire_date)
VALUES ('Ahmed', 'Ali', 'male', '1990-04-15', '2023-10-01')
RETURNING id INTO new_employee_id;

INSERT INTO Employee.Departments (department_name, location)
VALUES ('Research and Development', 'Cairo')
RETURNING id INTO new_department_id;


INSERT INTO Employee.Employee_Departments (employee_id, department_id, start_date)
VALUES (new_employee_id, new_department_id, CURRENT_DATE);

COMMIT;










