
DROP DATABASE IF EXISTS vr_fitness;

CREATE DATABASE vr_fitness;
USE vr_fitness;

CREATE TABLE app_user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    age INT,
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    experience_level VARCHAR(45)
);

CREATE TABLE trainer (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    specialty VARCHAR(100),
    certification VARCHAR(100)
);

CREATE TABLE workout_program (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT,
    CONSTRAINT fk_program_trainer
        FOREIGN KEY (trainer_id) REFERENCES trainer(trainer_id)
);

CREATE TABLE enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    program_id INT NOT NULL,
    enrolled_at DATE NOT NULL,
    CONSTRAINT fk_enroll_user
        FOREIGN KEY (user_id) REFERENCES app_user(user_id),
    CONSTRAINT fk_enroll_program
        FOREIGN KEY (program_id) REFERENCES workout_program(program_id)
);

CREATE TABLE session (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    start_at DATE NOT NULL,
    capacity INT,
    CONSTRAINT fk_session_program
        FOREIGN KEY (program_id) REFERENCES workout_program(program_id)
);

CREATE TABLE progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    program_id INT NOT NULL,
    progress_date DATE NOT NULL,
    calories_burned INT,
    time_spent_minutes INT,
    level_completed VARCHAR(45),
    CONSTRAINT fk_progress_user
        FOREIGN KEY (user_id) REFERENCES app_user(user_id),
    CONSTRAINT fk_progress_program
        FOREIGN KEY (program_id) REFERENCES workout_program(program_id)
);

CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    method ENUM('CreditCard','Cash','ApplePay') NOT NULL,
    pay_date DATE NOT NULL,
    CONSTRAINT fk_payment_user
        FOREIGN KEY (user_id) REFERENCES app_user(user_id)
);

INSERT INTO app_user (first_name, last_name, email, age, weight, height, experience_level)
VALUES 
('Alice', 'Smith', 'alice@example.com', 28, 60.5, 1.65, 'Beginner'),
('Bob', 'Johnson', 'bob@example.com', 35, 82.0, 1.80, 'Intermediate'),
('Carla', 'Martinez', 'carla@example.com', 24, 55.0, 1.60, 'Advanced');

INSERT INTO trainer (first_name, last_name, specialty, certification)
VALUES 
('David', 'Lopez', 'Strength Training', 'ACE Certified'),
('Emma', 'Garcia', 'Yoga', 'RYT-200');

INSERT INTO workout_program (trainer_id, title, description, duration)
VALUES
(1, 'Strength Basics', 'Introductory strength program', 30),
(1, 'Advanced Strength', 'High intensity program', 45),
(2, 'Morning Yoga', 'Gentle yoga sessions', 20);

INSERT INTO enrollment (user_id, program_id, enrolled_at)
VALUES
(1, 1, '2025-09-01'),
(2, 1, '2025-09-05'),
(3, 3, '2025-09-10');

INSERT INTO session (program_id, start_at, capacity)
VALUES
(1, '2025-09-20', 15),
(1, '2025-09-25', 15),
(3, '2025-09-22', 10);


INSERT INTO progress (user_id, program_id, progress_date, calories_burned, time_spent_minutes, level_completed)
VALUES
(1, 1, '2025-09-15', 300, 45, 'Level 1'),
(2, 1, '2025-09-16', 450, 60, 'Level 2'),
(3, 3, '2025-09-17', 200, 30, 'Level 1');


INSERT INTO payment (user_id, amount, method, pay_date)
VALUES
(1, 49.99, 'CreditCard', '2025-09-01'),
(2, 59.99, 'ApplePay', '2025-09-05'),
(3, 29.99, 'Cash', '2025-09-10');


SELECT wp.title AS program_title, s.start_at
FROM session s
JOIN workout_program wp ON wp.program_id = s.program_id
WHERE s.start_at >= NOW()
ORDER BY s.start_at;


SELECT u.first_name, u.last_name,
       SUM(p.time_spent_minutes) AS total_minutes,
       SUM(p.calories_burned) AS total_calories
FROM progress p
JOIN app_user u ON u.user_id = p.user_id
GROUP BY u.user_id;

SELECT t.first_name, t.last_name,
       COUNT(wp.program_id) AS programs_created
FROM trainer t
JOIN workout_program wp ON wp.trainer_id = t.trainer_id
GROUP BY t.trainer_id;

SELECT u.first_name, u.last_name, wp.title AS program_title, e.enrolled_at
FROM enrollment e
JOIN app_user u ON u.user_id = e.user_id
JOIN workout_program wp ON wp.program_id = e.program_id
WHERE e.enrolled_at <= CURDATE();
