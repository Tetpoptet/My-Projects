/*Разработайте базу данных для управления курсами. База данных содержит следующие сущности:
a. students: student_no, teacher_no, course_no, student_name, email, birth_date. b. teachers: teacher_no, teacher_name, phone_no
c. courses: course_no, course_name, start_date, end_date.
● Секционировать по годам, таблицу students по полю birth_date с помощью механизма range
● В таблице students сделать первичный ключ в сочетании двух полей student_no и birth_date
● Создать индекс по полю students.email
● Создать уникальный индекс по полю teachers.phone_no*/
Drop database School;
create database if not exists School;
use School;
CREATE TABLE IF NOT EXISTS Students (
    student_no INT AUTO_INCREMENT,
    teacher_no INT,
    course_no INT,
    First_name VARCHAR(15) NOT NULL,
    Last_name VARCHAR(15) NOT NULL,
    email VARCHAR(50),
    birth_date DATE,
    PRIMARY KEY (student_no, birth_date),
    FOREIGN KEY (teacher_no) REFERENCES Teachers (teacher_no),
    FOREIGN KEY (course_no) REFERENCES Courses (course_no)
) ENGINE=INNODB;
use School;
CREATE TABLE IF NOT EXISTS Teachers (
    teacher_no INT AUTO_INCREMENT,
    First_name VARCHAR(15) NOT NULL,
    Last_name VARCHAR(15) NOT NULL,
    Pnone_no VARCHAR(15),
    PRIMARY KEY (teacher_no)
) ENGINE=INNODB;
create unique index idx_phone_no on teachers (phone);
Use School;
CREATE TABLE IF NOT EXISTS Courses (
    course_no INT AUTO_INCREMENT,
    course_name VARCHAR(50) NOT NULL,
    start_date Date,
    end_date Date,
    PRIMARY KEY (course_no)
) ENGINE=INNODB;
CREATE INDEX idx_students_email ON students (email);
/*На свое усмотрение добавить тестовые данные (7-10 строк) в наши три таблицы*/
INSERT INTO students (First_name, Last_name, email,birth_date) VALUES ('Tetiana','Polishchuk', 'tety@ukr.net', '1985-12-13'),
('Olga','Krochuk', 'olga@ukr.net', '1989-10-13'), ('Kostia','Kostik', 'kos@ukr.net', '2005-12-13'), 
('Natasha','Poli', 'nata@ukr.net', '1989-01-13'), ('Alex','Kovsh', 'alex@ukr.net', '2010-12-13'), 
('Max','Maximenko', 'max@ukr.net', '1980-12-13'), ('Tetiana','Kil', 'tkil@ukr.net', '1999-12-13');
INSERT INTO teachers (First_name,Last_name,Pnone_no) VALUES ('Oxana','Pelypenko', '068 198 51 23'),
('Kyrylo','Pelypenko', '098 198 51 23'),('Inna','Dud', '068 200 51 48'),('Felix','Pele', '050 198 51 23'),
('Tania','Lypenko', '068 198 55 66'),('Lina','Peko', '089 198 51 23'),('Solia','Guz', '068 555 51 23');
INSERT INTO courses (course_name, start_date, end_date) VALUES ('SQL','2023-01-01','2023-05-01'),
('Python','2022-01-01', '2023-02-01'), ('English','2022-07-01', '2023-07-01'), ('Pilates','2020-01-01', '2022-05-01'),
('Yoga','2021-01-01', '2021-05-01'), ('Math','2019-01-01', '2019-05-01'), ('Biology','2018-01-01', '2018-05-01');
/*Отобразить данные за любой год из таблицы students и зафиксировать в виду
комментария план выполнения запроса, где будет видно что запрос будет выполняться по
конкретной секции.*/
/*Отобразить данные учителя, по любому одному номеру телефона и зафиксировать план
выполнения запроса, где будет видно, что запрос будет выполняться по индексу, а не
методом ALL. Далее индекс из поля teachers.phone_no сделать невидимым и
зафиксировать план выполнения запроса, где ожидаемый результат - метод ALL. В итоге
индекс оставить в статусе - видимый.*/
explain SELECT * FROM school.teachers where Pnone_no = '068 200 51 48';
alter table school.teachers alter index idx_teachers.phone_no invisible;
explain SELECT * FROM school.teachers where Pnone_no = '068 200 51 48';
alter table school.teachers alter index idx_teachers.phone_no visible;
/*Специально сделаем 3 дубляжа в таблице students (добавим еще 3 одинаковые строки).*/
INSERT INTO students (First_name, Last_name, email,birth_date) VALUES ('Tetiana','Polishchuk', 'tety@ukr.net', '1985-12-13'),
('Olga','Krochuk', 'olga@ukr.net', '1989-10-13'), ('Kostia','Kostik', 'kos@ukr.net', '2005-12-13');
/*Написать запрос, который выводит строки с дубляжами*/
use school;
SELECT email, COUNT(*) AS count FROM students GROUP BY emails HAVING count > 1;
