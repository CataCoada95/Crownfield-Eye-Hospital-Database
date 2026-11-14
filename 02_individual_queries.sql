USE crownfield_eye_hospital;

-- Query 1: Patients with more than one appointment
-- GROUP BY and HAVING (Figure 10)

SELECT
    pat_id,
    COUNT(*) AS total_appointments
FROM ap_tbl
GROUP BY pat_id
HAVING COUNT(*) > 1;


-- Query 2: Doctors with more than one appointment
-- INNER JOIN, GROUP BY and HAVING (Figure 11)

SELECT
    d.dr_name AS doctor_name,
    COUNT(a.ap_id) AS total_appointments
FROM dr_tbl AS d
INNER JOIN ap_tbl AS a
    ON d.dr_id = a.dr_id
GROUP BY d.dr_id, d.dr_name
HAVING COUNT(a.ap_id) > 1;


-- Query 3: Appointment workload for each doctor
-- Common Table Expression (Figure 12)

WITH DoctorAppointments AS (
    SELECT
        d.dr_id,
        d.dr_name,
        COUNT(a.ap_id) AS total_appointments
    FROM dr_tbl AS d
    LEFT JOIN ap_tbl AS a
        ON d.dr_id = a.dr_id
    WHERE d.specialty IS NULL
        OR LOWER(d.specialty) <> 'receptionist'
    GROUP BY d.dr_id, d.dr_name
)
SELECT
    dr_name,
    total_appointments
FROM DoctorAppointments
ORDER BY total_appointments DESC, dr_name;


-- Query 4: Find patients with multiple appointments
-- Subquery (Figure 13)

SELECT
    p.pat_id,
    p.first_name,
    p.last_name
FROM pat_tbl AS p
WHERE p.pat_id IN (
    SELECT a.pat_id
    FROM ap_tbl AS a
    GROUP BY a.pat_id
    HAVING COUNT(a.ap_id) > 1
);


-- Query 5: Appointments with and without follow-up records
-- LEFT JOIN (Figure 14)

SELECT
    a.ap_id,
    a.ap_date,
    f.sta AS follow_up_status,
    f.review_date
FROM ap_tbl AS a
LEFT JOIN follow_up AS f
    ON a.ap_id = f.ap_id
ORDER BY a.ap_id;


-- Query 6: Check the record counts in all nine tables
-- COUNT and UNION ALL (Figure 9)

SELECT 'pat_tbl' AS table_name, COUNT(*) AS total_records
FROM pat_tbl
UNION ALL
SELECT 'dr_tbl', COUNT(*) FROM dr_tbl
UNION ALL
SELECT 'clinic_tbl', COUNT(*) FROM clinic_tbl
UNION ALL
SELECT 'ap_tbl', COUNT(*) FROM ap_tbl
UNION ALL
SELECT 'diag_tbl', COUNT(*) FROM diag_tbl
UNION ALL
SELECT 'pre_tbl', COUNT(*) FROM pre_tbl
UNION ALL
SELECT 'pre_detail', COUNT(*) FROM pre_detail
UNION ALL
SELECT 'med_tbl', COUNT(*) FROM med_tbl
UNION ALL
SELECT 'follow_up', COUNT(*) FROM follow_up;
