-- =====================================================
-- SOAL JOIN QUERY SQL
-- Nama: Angga Fadzar
-- NIM: 2306201
-- Kelas: SIK A5
-- Dosen: Willdan Aprizal Arifin, S.Pd., M.Kom
-- MK: Bisnis Intelijen
-- =====================================================
-- 

-- departemen
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
)

-- mahasiswa
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    entry_year INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
)

-- Dosen
CREATE TABLE lecturers (
    lect_id INT PRIMARY KEY,
    lect_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
)

-- Mata kuliah
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE,
    course_title VARCHAR(150),
    credits INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
)

-- Kelas (penyelenggaraan MK per semester & dosen)
CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    course_id INT,
    lect_id INT,
    semester VARCHAR(10), -- misal: '2025-1'
    FOREIGN KEY (course_id) REFERENCES courses (course_id),
    FOREIGN KEY (lect_id) REFERENCES lecturers (lect_id)
)

-- Ruang
CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(50),
    capacity INT
)

-- Jadwal kelas di ruang
CREATE TABLE schedules (
    schedule_id INT PRIMARY KEY,
    class_id INT,
    room_id INT,
    day_of_week VARCHAR(10), -- Mon.Sun (silakan sesuaikan)
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (class_id) REFERENCES classes (class_id),
    FOREIGN KEY (room_id) REFERENCES rooms (room_id)
)

-- KRS (relasi many-to-many mhs <-> kelas)
CREATE TABLE enrollments (
    student_id INT,
    class_id INT,
    grade VARCHAR(2), -- contoh: 'A','B','C', NULL bila belum nilai
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id),
    FOREIGN KEY (class_id) REFERENCES classes (class_id)
)

-- Prasyarat MK (self-join pada courses)
CREATE TABLE prerequisites (
    course_id INT,
    prereq_id INT,
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES courses (course_id),
    FOREIGN KEY (prereq_id) REFERENCES courses (course_id)
)

-- Hierarki dosen (self-join lecturers: atasan/pembina)
CREATE TABLE lecturer_supervisions (
    lect_id INT,
    supervisor_id INT,
    PRIMARY KEY (lect_id, supervisor_id),
    FOREIGN KEY (lect_id) REFERENCES lecturers (lect_id),
    FOREIGN KEY (supervisor_id) REFERENCES lecturers (lect_id)
)

 INSERT INTO departments VALUES
 (10,'Sistem Informasi Kelautan'),
 (20,'Ilmu Komputer'),
 (30,'Biologi Kelautan');

  INSERT INTO students VALUES
 (2103118,'Roni Antonius Sinabutar',2021,10),
 (2103120,'Salsa Aurelia',2021,10),
 (2204101,'Rakhil Syakira Yusuf',2022,10),
 (2205205,'Adit Pratama',2022,20),
 (2306102,'Nadia Putri',2023,20),
 (2307107,'Bima Mahesa',2023,30);

  INSERT INTO lecturers VALUES
 (501, 'Willdan',10),
 (502,'Supriadi',10),
 (503,'Ayang',20),
 (504, 'Alam',30),
 (505,'Luthfi',10);

 INSERT INTO courses VALUES
 (1001,'KL202','Algoritma & Pemrograman',3,10),
 (1002,'KL218','Sistem Basis Data',3,10),
 (1003,'CS101','Pengantar Ilmu Komputer',2,20),
 (1004,'CS205','Basis Data Lanjut',3,20),
(1005,'MB110','Biologi Laut Dasar',2,30),
 (1006,'KL305','SIG Kelautan',3,10);

  INSERT INTO classes VALUES
 (9001,1002,501,'2025-1'),-- SBD oleh Willdan
 (9002,1001,502,'2025-1'),-- Algo oleh Supriadi
 (9003,1003,503,'2025-1'),-- Pengantar IK oleh Ayang
 (9004,1005,504,'2025-1'),-- Biologi Laut Dasar oleh Alam
 (9005,1004,503,'2025-1'),-- Basis Data Lanjut oleh Ayang
 (9006,1006,505,'2025-1');-- SIG Kelautan oleh Luthfi

  INSERT INTO rooms VALUES
 (1,'Lab Big Data',30),
 (2,'Ruang Kuliah 201',40),
 (3,'Lab Komputasi 1',25),
 (4,'Aula 3',100);

  INSERT INTO schedules VALUES
 (7001,9001,3,'Monday','08:00','10:30'),
 (7002,9002,2,'Tuesday','10:00','12:00'),
 (7003,9003,2,'Wednesday','08:00','10:00'),
 (7004,9004,4,'Thursday','13:00','15:00'),
 (7005,9005,3,'Friday','09:00','11:30'),
 (7006,9006,1,'Monday','13:00','15:30');

  INSERT INTO enrollments VALUES
(2103118,9001,'A'),
 (2103118,9002,'B'),
 (2103120,9001,'B'),
 (2103120,9006,'A'),
 (2204101,9001,NULL),
 (2204101,9005,NULL),
 (2205205,9003,'A'),
 (2306102,9003,'B'),
 (2306102,9005,NULL),
 (2307107,9004,'A');

  INSERT INTO prerequisites VALUES
 (1004,1002),-- Basis Data Lanjut mensyaratkan Sistem Basis Data
 (1006,1001);-- SIG Kelautan mensyaratkan Algoritma & Pemrograman

  INSERT INTO lecturer_supervisions VALUES
 (501,505),-- Willdan dibina oleh Luthfi
 (502,501),-- Supriadi dibina oleh Willdan
 (503,501),-- Ayang dibina oleh Willdan
 (504,505);-- Alam dibina oleh Luthfi

 
-- JAWABAN 25 SOAL JOIN QUERY:

-- 1. Nama mahasiswa dan nama departemennya
SELECT s.student_name, d.dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id;

-- 2. Daftar kelas beserta mata kuliah dan dosen pengajarnya
SELECT cl.class_id, co.course_code, co.course_title, l.lect_name, cl.semester
FROM classes cl
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN lecturers l ON cl.lect_id = l.lect_id;

-- 3. Mahasiswa yang mengambil kelas 'Sistem Basis Data' (1002)
SELECT s.student_name, co.course_title, cl.class_id
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
WHERE co.course_id = 1002;

-- 4. Jadwal lengkap kelas (hari, jam, ruang) untuk tiap mata kuliah
SELECT co.course_code, co.course_title, sc.day_of_week, sc.start_time, sc.end_time, r.room_name
FROM courses co
INNER JOIN classes cl ON co.course_id = cl.course_id
INNER JOIN schedules sc ON cl.class_id = sc.class_id
INNER JOIN rooms r ON sc.room_id = r.room_id;

-- 5. Jumlah mahasiswa per departemen yang terdaftar di semester '2025-1'
SELECT d.dept_name, COUNT(DISTINCT s.student_id) AS jumlah_mahasiswa
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN classes cl ON e.class_id = cl.class_id
WHERE cl.semester = '2025-1' OR cl.semester IS NULL
GROUP BY d.dept_id, d.dept_name;

-- 6. Kelas yang diajar oleh dosen satu departemen dengan mata kuliah yang diajarkan
SELECT cl.class_id, co.course_title, l.lect_name, d1.dept_name AS course_dept, d2.dept_name AS lecturer_dept
FROM classes cl
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN lecturers l ON cl.lect_id = l.lect_id
INNER JOIN departments d1 ON co.dept_id = d1.dept_id
INNER JOIN departments d2 ON l.dept_id = d2.dept_id
WHERE co.dept_id = l.dept_id;

-- 7. Mahasiswa SIK (dept 10) yang mengambil kelas di luar dept-nya
SELECT s.student_name, co.course_title, d1.dept_name AS student_dept, d2.dept_name AS course_dept
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN departments d1 ON s.dept_id = d1.dept_id
INNER JOIN departments d2 ON co.dept_id = d2.dept_id
WHERE s.dept_id = 10 AND co.dept_id != s.dept_id;

-- 8. Mata kuliah beserta prasyaratnya (self-join pada courses via prerequisites)
SELECT co1.course_code, co1.course_title, co2.course_code AS prereq_code, co2.course_title AS prereq_title
FROM courses co1
INNER JOIN prerequisites p ON co1.course_id = p.course_id
INNER JOIN courses co2 ON p.prereq_id = co2.course_id;

-- 9. Daftar dosen dan dosen pembinanya (self-join lecturers)
SELECT l1.lect_name AS dosen, l2.lect_name AS pembina
FROM lecturers l1
INNER JOIN lecturer_supervisions ls ON l1.lect_id = ls.lect_id
INNER JOIN lecturers l2 ON ls.supervisor_id = l2.lect_id;

-- 10. Kelas yang belum memiliki nilai untuk sebagian mahasiswa (grade NULL)
SELECT DISTINCT cl.class_id, co.course_title, s.student_name
FROM classes cl
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN enrollments e ON cl.class_id = e.class_id
INNER JOIN students s ON e.student_id = s.student_id
WHERE e.grade IS NULL;

-- 11. Mahasiswa yang tidak mengambil kelas 'SIG Kelautan' (1006) namun satu departemen dengan MK itu
SELECT s.student_name, d.dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id
INNER JOIN courses co ON d.dept_id = co.dept_id
WHERE co.course_id = 1006
AND s.student_id NOT IN (
    SELECT e.student_id
    FROM enrollments e
    INNER JOIN classes cl ON e.class_id = cl.class_id
    WHERE cl.course_id = 1006
);

-- 12. Jumlah kelas per hari beserta total kapasitas ruang yang dipakai hari itu
SELECT sc.day_of_week, COUNT(cl.class_id) AS jumlah_kelas, SUM(r.capacity) AS total_kapasitas
FROM schedules sc
INNER JOIN classes cl ON sc.class_id = cl.class_id
INNER JOIN rooms r ON sc.room_id = r.room_id
GROUP BY sc.day_of_week;

-- 13. Daftar mahasiswa dan total SKS yang sedang ditempuh (berdasarkan kelas yang diambil)
SELECT s.student_name, SUM(co.credits) AS total_sks
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
GROUP BY s.student_id, s.student_name;

-- 14. Mata kuliah lintas prodi: course dept ≠ lecturer dept pada kelas berjalan
SELECT co.course_code, co.course_title, d1.dept_name AS course_dept, l.lect_name, d2.dept_name AS lecturer_dept
FROM classes cl
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN lecturers l ON cl.lect_id = l.lect_id
INNER JOIN departments d1 ON co.dept_id = d1.dept_id
INNER JOIN departments d2 ON l.dept_id = d2.dept_id
WHERE co.dept_id != l.dept_id;

-- 15. Kelas beserta jumlah peserta & kapasitas ruang, dan status 'PENUH' jika jumlah ≥ kapasitas
SELECT cl.class_id, co.course_title, COUNT(e.student_id) AS jumlah_peserta, r.capacity,
       CASE 
           WHEN COUNT(e.student_id) >= r.capacity THEN 'PENUH'
           ELSE 'TERSEDIA'
       END AS status
FROM classes cl
INNER JOIN courses co ON cl.course_id = co.course_id
LEFT JOIN enrollments e ON cl.class_id = e.class_id
INNER JOIN schedules sc ON cl.class_id = sc.class_id
INNER JOIN rooms r ON sc.room_id = r.room_id
GROUP BY cl.class_id, co.course_title, r.capacity;

-- 16. Riwayat KRS tiap mahasiswa dalam semester '2025-1' (urut nama mhs, lalu course_code)
SELECT s.student_name, co.course_code, co.course_title, e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
WHERE cl.semester = '2025-1'
ORDER BY s.student_name, co.course_code;

-- 17. Daftar mata kuliah yang menjadi prasyarat untuk setidaknya satu mata kuliah lain
SELECT DISTINCT co.course_code, co.course_title
FROM courses co
INNER JOIN prerequisites p ON co.course_id = p.prereq_id;

-- 18. Dosen pembina beserta jumlah dosen yang dibinanya
SELECT l.lect_name AS pembina, COUNT(ls.lect_id) AS jumlah_bimbingan
FROM lecturers l
INNER JOIN lecturer_supervisions ls ON l.lect_id = ls.supervisor_id
GROUP BY l.lect_id, l.lect_name;

-- 19. Mahasiswa + kelas + ruang jika kelasnya hari 'Monday'
SELECT s.student_name, co.course_title, r.room_name, sc.start_time, sc.end_time
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN schedules sc ON cl.class_id = sc.class_id
INNER JOIN rooms r ON sc.room_id = r.room_id
WHERE sc.day_of_week = 'Monday';

-- 20. Mata kuliah yang diambil mahasiswa dari departemen berbeda (cross-dept enrollment)
SELECT s.student_name, d1.dept_name AS student_dept, co.course_title, d2.dept_name AS course_dept
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN departments d1 ON s.dept_id = d1.dept_id
INNER JOIN departments d2 ON co.dept_id = d2.dept_id
WHERE s.dept_id != co.dept_id;

-- 21. Semua dosen beserta kelas yang diajar (jika tidak mengajar, tetap tampil)
SELECT l.lect_name, co.course_title, cl.class_id, cl.semester
FROM lecturers l
LEFT JOIN classes cl ON l.lect_id = cl.lect_id
LEFT JOIN courses co ON cl.course_id = co.course_id;

-- 22. Semua mata kuliah beserta kelasnya pada semester '2025-1' (yang belum dibuka kelasnya tetap tampil)
SELECT co.course_code, co.course_title, cl.class_id, cl.semester, l.lect_name
FROM courses co
LEFT JOIN classes cl ON co.course_id = cl.course_id AND cl.semester = '2025-1'
LEFT JOIN lecturers l ON cl.lect_id = l.lect_id;

-- 23. Pasangan mata kuliah & prasyaratnya dalam satu baris, termasuk yang tidak punya prasyarat (tampilkan NULL)
SELECT co1.course_code, co1.course_title, co2.course_code AS prereq_code, co2.course_title AS prereq_title
FROM courses co1
LEFT JOIN prerequisites p ON co1.course_id = p.course_id
LEFT JOIN courses co2 ON p.prereq_id = co2.course_id;

-- 24. Daftar mahasiswa yang mengambil kelas dosen pembinanya (join berantai + self-join)
SELECT s.student_name, l1.lect_name AS dosen_pengajar, l2.lect_name AS dosen_pembina, co.course_title
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN classes cl ON e.class_id = cl.class_id
INNER JOIN courses co ON cl.course_id = co.course_id
INNER JOIN lecturers l1 ON cl.lect_id = l1.lect_id
INNER JOIN lecturer_supervisions ls ON l1.lect_id = ls.lect_id
INNER JOIN lecturers l2 ON ls.supervisor_id = l2.lect_id;

-- 25. Cek bentrok ruang: pasangan kelas di ruang yang sama pada hari & rentang waktu yang tumpang tindih
SELECT sc1.class_id AS class1, sc2.class_id AS class2, r.room_name, sc1.day_of_week,
       sc1.start_time AS start1, sc1.end_time AS end1,
       sc2.start_time AS start2, sc2.end_time AS end2
FROM schedules sc1
INNER JOIN schedules sc2 ON sc1.room_id = sc2.room_id 
                        AND sc1.day_of_week = sc2.day_of_week
                        AND sc1.class_id != sc2.class_id
INNER JOIN rooms r ON sc1.room_id = r.room_id
WHERE (sc1.start_time < sc2.end_time AND sc1.end_time > sc2.start_time)
ORDER BY r.room_name, sc1.day_of_week, sc1.start_time;