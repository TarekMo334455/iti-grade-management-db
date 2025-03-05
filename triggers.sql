-- create table company
CREATE TABLE COMPANY (
    ID SERIAL PRIMARY KEY,
    NAME TEXT,
    SALARY INT
);

-- create table log
CREATE TABLE LOG (
    EMP_ID INT,
    ENTRY_DATE DATE
);

-- create function logfunc to insert log record after any insert in company table
CREATE OR REPLACE FUNCTION logfunc() RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO LOG (EMP_ID, ENTRY_DATE)
    VALUES (NEW.ID, NOW());

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- create trigger example_trigger to call logfunc after insert in company table
CREATE TRIGGER example_trigger
AFTER INSERT ON COMPANY
FOR EACH ROW
EXECUTE FUNCTION logfunc();


--1. Create Table called Deleted_Students which will hold the deleted
--students info (same columns as in student tables)
--2. Create trigger to save the deleted student from Student table to
--Deleted_Students.
--3. Try to delete student from students table and check the
--Deleted_Students if it contain the deleted students or not


CREATE TABLE Deleted_Students(id INT,
gender TEXT CHECK (gender IN ('male', 'female')), birth_date DATE,  first_name TEXT,  last_name TEXT,
 contact_info contact_info);

CREATE OR REPLACE FUNCTION save_deleted_student()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Students (id, gender, birth_date, first_name, last_name, contact_info)
    VALUES (OLD.id, OLD.gender, OLD.birth_date, OLD.first_name, OLD.last_name, OLD.contact_info);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_delete_student
BEFORE DELETE ON Students
FOR EACH ROW
EXECUTE FUNCTION save_deleted_student();

DELETE FROM Students WHERE id = 1;
SELECT * FROM Deleted_Students;


--4. Create trigger to prevent insert new Course with name length greater
--than 20 chars;

CREATE OR REPLACE FUNCTION check_subject_name() RETURNS TRIGGER AS $$
BEGIN
     IF LENGTH(NEW.name) > 20 THEN
         RAISE EXCEPTION 'Subject name must not exceed 20 characters';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_course_name_length
BEFORE INSERT ON Subjects
FOR EACH ROW
EXECUTE FUNCTION check_subject_name();


--5. Create trigger to prevent update student names.

CREATE OR REPLACE FUNCTION prevent_student_name_update()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.first_name <> OLD.first_name OR NEW.last_name <> OLD.last_name THEN
        RAISE EXCEPTION 'Updating student names is not allowed!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_student_name_update
BEFORE UPDATE ON Students
FOR EACH ROW
EXECUTE FUNCTION prevent_student_name_update();

UPDATE Students
SET first_name = 'Ahmed'
WHERE id = 1;


--6. Create trigger to prevent update scores of students.

CREATE OR REPLACE FUNCTION prevent_score_update()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.score <> OLD.score THEN
        RAISE EXCEPTION 'Updating student scores is not allowed!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_score_update
BEFORE UPDATE ON student_exam
FOR EACH ROW
EXECUTE FUNCTION prevent_score_update();

UPDATE student_exam
SET score = 95
WHERE student_id = 1 AND exam_id = 2;


--7. Create trigger to prevent user to insert or update Exam with Score
--greater than 100 or less than zero.

CREATE OR REPLACE FUNCTION check_score_range()
RETURNS TRIGGER AS $$
BEGIN

    IF NEW.score < 0 OR NEW.score > 100 THEN
        RAISE EXCEPTION 'Score must be between 0 and 100. You entered: %', NEW.score;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_invalid_scores
BEFORE INSERT OR UPDATE ON student_exam
FOR EACH ROW
EXECUTE FUNCTION check_score_range();

INSERT INTO student_exam (student_id, exam_id, score)
VALUES (1, 2, 150);

--8-Create trigger to prevent any user to update/insert/delete to
--table (Students) after 7:00 PM


CREATE OR REPLACE FUNCTION prevent_after_hours()
RETURNS TRIGGER AS $$
BEGIN

    IF EXTRACT(HOUR FROM CURRENT_TIME) >= 19 THEN
        RAISE EXCEPTION 'Operations are not allowed after 7:00 PM!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER prevent_students_after_hours
BEFORE INSERT OR UPDATE OR DELETE ON Students
FOR EACH ROW
EXECUTE FUNCTION prevent_after_hours();

INSERT INTO Students (first_name, last_name, birth_date)
VALUES ('Ahmed', 'Ali', '2001-05-10');


--9. Backup your Database to external file
--10.Backup your Student table to external file

pg_dump -U postgres -d iti_grade_management_system -F c -f /backups/iti_backup.dump


pg_dump -U postgres -d iti_grade_management_system -t Students -F c -f /backups/students_backup.dump

COPY Students TO '/backups/students_backup.csv' WITH (FORMAT CSV, HEADER);
OR
COPY Students TO '/backups/students_backup.txt' WITH (FORMAT TEXT);



Restore
pg_restore -U postgres -d database_name -F c /path/to/backup/database_backup.dump
COPY Students FROM '/backups/students_backup.txt' WITH (FORMAT TEXT);





















