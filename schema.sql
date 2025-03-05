-- DDL

CREATE TABLE Students (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    address TEXT
);

CREATE TABLE Phones (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_id BIGINT REFERENCES Students(id),
    phone_number TEXT NOT NULL UNIQUE
);

CREATE TABLE Tracks (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL
);

CREATE TABLE Subjects (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    max_score INT NOT NULL
);

CREATE TABLE Exams (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_id INT REFERENCES Subjects(id),
    exam_date DATE NOT NULL
);

CREATE TABLE Student_Track (
    student_id INT REFERENCES Students(id),
    track_id BIGINT REFERENCES Tracks(id),
    PRIMARY KEY (student_id, track_id)
);

CREATE TABLE Track_Subject (
    track_id BIGINT REFERENCES Tracks(id),
    subject_id INT REFERENCES Subjects(id),
    PRIMARY KEY (track_id, subject_id)
);

CREATE TABLE Student_Subject (
    student_id INT REFERENCES Students(id),
    subject_id INT REFERENCES Subjects(id),
    PRIMARY KEY (student_id, subject_id)
);

CREATE TABLE Student_Exam (
    student_id INT REFERENCES Students(id),
    exam_id INT REFERENCES Exams(id),
    score INT NOT NULL,
    PRIMARY KEY (student_id, exam_id)
);

-- Insert Data

INSERT INTO Students (name, email, address) VALUES
('Ahmesd Mohamed', 'alice@example.com', '123 Main St'),
('Mohammed Ahmed', 'bob@example.com', '456 Elm St'),
('Tarek Mohammed', 'charlie@example.com', '789 Maple St'),
('Omar Ahmed', 'david@example.com', '101 Oak St'),
('Emad Ali', 'eva@example.com', '202 Pine St');


INSERT INTO Phones (student_id, phone_number) VALUES
(1, '555-1234'),
(1, '555-5678'),
(2, '555-8765'),
(3, '555-4321'),
(4, '555-6789');


INSERT INTO Tracks (name) VALUES
('Telecom'),
('OpenSource'),
('Java'),
('Game'),
('Data Science');


INSERT INTO Subjects (name, description, max_score) VALUES
('C Programming', 'Introduction to C', 100),
('CPP Programming', 'Advanced C++', 100),
('HTML', 'Web Development Basics', 100),
('Java', 'Java Programming', 100),
('Python', 'Python for Data Science', 100);



INSERT INTO Exams (subject_id, exam_date) VALUES
(1, '2023-10-01'),
(2, '2023-10-02'),
(3, '2023-10-03'),
(4, '2023-10-04'),
(5, '2023-10-05');



INSERT INTO Student_Track (student_id, track_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);





INSERT INTO Track_Subject (track_id, subject_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);




-- Insert Student_Subject
INSERT INTO Student_Subject (student_id, subject_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO Student_Exam (student_id, exam_id, score) VALUES
(1, 1, 85),
(2, 2, 90),
(3, 3, 75),
(4, 4, 80),
(5, 5, 95),
(1, 2, 88),
(2, 3, 92),
(3, 4, 78),
(4, 5, 82),
(5, 1, 97);




