--1. Create multiply function which take two number and return the multiply of them


CREATE FUNCTION multiply(a INT, b INT)
RETURNS INT AS $$
BEGIN
    RETURN a * b;
END;
$$ LANGUAGE plpgsql;

SELECT multiply(5, 6);



--2. Create Hello world function which take username and return welcome message
--to user using his name

CREATE FUNCTION hello_world(username TEXT)
RETURNS TEXT AS $$
BEGIN
      RETURN concat('Welcome ', username);
END;
$$ LANGUAGE plpgsql;

SELECT hello_world('Ahmed');


--3. Create function which takes number and return if this number is odd or even.

CREATE FUNCTION odd_or_even(num INT)
RETURNS TEXT AS $$
BEGIN
    IF num % 2 = 0 THEN
        RETURN 'Even';
    ELSE
        RETURN 'Odd';
    END IF;
END;
$$ LANGUAGE plpgsql;


SELECT odd_or_even(7);
SELECT odd_or_even(8);


--4. Create AddNewStudent function which take Student firstName and lastname and
--birthdate and TrackName and add this new student info at database

CREATE FUNCTION AddNewStudent(
    firstName TEXT, lastName TEXT, birthDate DATE, TrackName TEXT
) RETURNS VOID AS $$
DECLARE
    student_id INT;
    track_id INT;
BEGIN

    INSERT INTO Students (first_name, last_name, birth_date)
    VALUES (firstName, lastName, birthDate)
    RETURNING id INTO student_id;

    SELECT id INTO track_id FROM Tracks WHERE name = TrackName;


    IF track_id IS NULL THEN
        RAISE EXCEPTION 'This Track "%s" does not exist.', TrackName;
    END IF;


    INSERT INTO student_track (student_id, track_id)
    VALUES (student_id, track_id);

    RETURN;
END;
$$ LANGUAGE plpgsql;


SELECT AddNewStudent('Tarek', 'MOhammed', '2000-03-01', 'OpenSource');


--5. Create function which takes StudentId and return the string/text that describe the use info(firstname, last name, age, TrackName).


CREATE FUNCTION GetStudentInfo(StudentId INT)
RETURNS TEXT AS $$
DECLARE
    full_info TEXT;
BEGIN

    SELECT CONCAT(first_name, ' ', last_name, ' - Age: ', EXTRACT(YEAR FROM AGE(birth_date)))
    INTO full_info
    FROM Students
    WHERE id = StudentId;

    IF full_info IS NULL THEN
        RAISE EXCEPTION 'Student with ID % not found', StudentId;
    END IF;

    RETURN full_info;
END;
$$ LANGUAGE plpgsql;

SELECT GetStudentInfo(6);


--6. Create function which takes TrackName and return the students names in this track.

CREATE FUNCTION GetStudentsInTrack(TrackName TEXT)
RETURNS TABLE (full_name TEXT) AS $$
DECLARE
    track_var_id INT;
BEGIN

    SELECT id INTO track_var_id FROM Tracks WHERE name = TrackName;

    IF track_var_id IS NULL THEN
        RAISE EXCEPTION 'Track with name % not found', TrackName;
    END IF;

    RETURN QUERY
    SELECT CONCAT(s.first_name, ' ', s.last_name)
    FROM Students s
    JOIN student_track st ON st.student_id = s.id
    WHERE st.track_id = track_var_id;

END;
$$ LANGUAGE plpgsql;


SELECT * FROM GetStudentsInTrack('OpenSource');


--7. Create function which takes student id and subject id and return score the student in subject.


CREATE FUNCTION GetStudentScore(StudentId INT, SubjectId INT)
RETURNS INT AS $$
DECLARE
    score INT;
BEGIN
    SELECT SE.score INTO score
    FROM student_exam SE
    JOIN EXams E ON SE.exam_id = E.id
    WHERE SE.student_id = StudentId AND E.subject_id = SubjectId;

    RETURN score;
END;
$$ LANGUAGE plpgsql;

SELECT GetStudentScore(1, 2);



--8. Create function which takes subject id and return the number of students who
--failed in a subject (Score less than 50).


CREATE FUNCTION CountFailedStudents(SubjectId INT)
RETURNS INT AS $$
DECLARE
    failed_count INT;
BEGIN
    SELECT COUNT(SE.score) INTO failed_count
    FROM student_exam SE
    JOIN exams E ON SE.exam_id = E.id
    WHERE E.subject_id = SubjectId AND score < 50;

    RETURN failed_count;
END;
$$ LANGUAGE plpgsql;

SELECT CountFailedStudents(3);

--9-Create function which take subject name and return the average grades for
--subject


CREATE FUNCTION GetAverageGrade(SubjectId INT)
RETURNS NUMERIC(10,2) AS $$
BEGIN
    RETURN COALESCE(
        (SELECT AVG(SE.score)
         FROM student_exam SE
         JOIN exams E ON SE.exam_id = E.id
         WHERE E.subject_id = SubjectId), 0.0);
END;
$$ LANGUAGE plpgsql;

SELECT GetAverageGrade(3);











