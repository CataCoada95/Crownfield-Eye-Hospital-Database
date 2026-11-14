USE crownfield_eye_hospital;

-- ==========================================
-- Database security and user roles
-- ==========================================

-- Create four database roles

CREATE ROLE IF NOT EXISTS
    'administrator',
    'doctor',
    'patient',
    'receptionist';


-- Administrator privileges

GRANT ALL PRIVILEGES
ON crownfield_eye_hospital.*
TO 'administrator';


-- Doctor privileges (Figure 17)

GRANT SELECT
ON crownfield_eye_hospital.ap_tbl
TO 'doctor';

GRANT SELECT
ON crownfield_eye_hospital.pat_tbl
TO 'doctor';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.diag_tbl
TO 'doctor';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.pre_tbl
TO 'doctor';


-- Patient privileges
-- Educational demonstration.
-- Table-level SELECT does not restrict access
-- to an individual patient's own record.

GRANT SELECT
ON crownfield_eye_hospital.pat_tbl
TO 'patient';


-- Receptionist privileges
-- Example permissions based on administrative duties.

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.ap_tbl
TO 'receptionist';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.pat_tbl
TO 'receptionist';

GRANT SELECT
ON crownfield_eye_hospital.dr_tbl
TO 'receptionist';

GRANT SELECT
ON crownfield_eye_hospital.clinic_tbl
TO 'receptionist';

GRANT SELECT, INSERT, UPDATE
ON crownfield_eye_hospital.follow_up
TO 'receptionist';


-- ==========================================
-- Create demonstration user accounts
-- ==========================================

-- MySQL generates passwords rather than storing
-- real passwords in this public repository.

CREATE USER 'test_admin'@'localhost'
IDENTIFIED BY RANDOM PASSWORD;

CREATE USER 'test_doctor'@'localhost'
IDENTIFIED BY RANDOM PASSWORD;

CREATE USER 'test_patient'@'localhost'
IDENTIFIED BY RANDOM PASSWORD;

CREATE USER 'test_receptionist'@'localhost'
IDENTIFIED BY RANDOM PASSWORD;


-- Assign roles to users

GRANT 'administrator'
TO 'test_admin'@'localhost';

GRANT 'doctor'
TO 'test_doctor'@'localhost';

GRANT 'patient'
TO 'test_patient'@'localhost';

GRANT 'receptionist'
TO 'test_receptionist'@'localhost';


-- Activate assigned roles by default

SET DEFAULT ROLE ALL TO
    'test_admin'@'localhost',
    'test_doctor'@'localhost',
    'test_patient'@'localhost',
    'test_receptionist'@'localhost';


-- ==========================================
-- Check user privileges
-- ==========================================

SHOW GRANTS FOR 'administrator';
SHOW GRANTS FOR 'doctor';
SHOW GRANTS FOR 'patient';
SHOW GRANTS FOR 'receptionist';


-- ==========================================
-- SHA-256 hashing demonstration (Figure 19)
-- ==========================================

SELECT
    pat_id,
    SHA2(pat_id, 256) AS hashed_patient_id
FROM pat_tbl
LIMIT 5;


-- ==========================================
-- Transaction: UPDATE and ROLLBACK (Figure 20)
-- ==========================================

START TRANSACTION;

UPDATE ap_tbl
SET ap_time = '10:30:00'
WHERE ap_id = 1;

SELECT *
FROM ap_tbl
WHERE ap_id = 1;

ROLLBACK;

SELECT *
FROM ap_tbl
WHERE ap_id = 1;


-- ==========================================
-- Transaction: COMMIT (Figure 21)
-- ==========================================

DROP TEMPORARY TABLE IF EXISTS transaction_test;

CREATE TEMPORARY TABLE transaction_test (
    test_id INT PRIMARY KEY,
    test_note VARCHAR(50)
) ENGINE = InnoDB;

START TRANSACTION;

INSERT INTO transaction_test
VALUES (1, 'COMMIT test');

COMMIT;

SELECT *
FROM transaction_test;
