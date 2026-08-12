SELECT version();

SELECT current_database();

SELECT current_user;

-- CREATE — Create a table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    plan VARCHAR(30) NOT NULL
);

-- NSERT — Add users
INSERT INTO users (name, email, plan)
VALUES
('Aman', 'aman@example.com', 'premium'),
('Priya', 'priya@example.com', 'free'),
('Rahul', 'rahul@example.com', 'premium');

SELECT * FROM users;


-- READ — Filter users
SELECT *
FROM users
WHERE plan = 'premium';

-- UPDATE — Change Priya

Now lets change Priya from free to premium.

Run:
UPDATE users
SET plan = 'premium'
WHERE email = 'priya@example.com';

-- Check it:
SELECT *
FROM users
WHERE email = 'priya@example.com';

-- DELETE — Remove Rahul

DELETE FROM users
WHERE email = 'rahul@example.com';

-- Check:
SELECT * FROM users;

--------------------------------------------------
ANother Example
-- CREATE
CREATE TABLE scores (id INT, name TEXT, score INT);

-- INSERT
INSERT INTO scores VALUES (4, 'Mina', 91);

-- Update
UPDATE scores SET score = score + 5 WHERE score < 70;

-- DELETE
DELETE FROM scores WHERE score < 100;

