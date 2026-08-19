CREATE DATABASE studentdb;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    course VARCHAR(100)
);

INSERT INTO students (name, email, course)
VALUES ('Rahul', 'rahul@example.com', 'Computer Science');

SELECT * FROM students;
