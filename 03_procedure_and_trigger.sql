USE crownfield_eye_hospital;

DELIMITER $$

-- Stored procedure: Retrieve appointments for a selected patient
-- Figure 15
-- Reconstructed from the assessment evidence.

CREATE PROCEDURE GetPatientAppointments(
    IN patient_id VARCHAR(10)
)
BEGIN
    SELECT
        a.ap_id,
        a.pat_id,
        d.dr_name,
        a.ap_date,
        a.ap_time
    FROM ap_tbl AS a
    INNER JOIN dr_tbl AS d
        ON a.dr_id = d.dr_id
    WHERE a.pat_id = patient_id
    ORDER BY a.ap_date, a.ap_time;
END$$


-- Trigger 1: Prevent appointments with dates in the past
-- Figure 16

CREATE TRIGGER check_appointment_date
BEFORE INSERT ON ap_tbl
FOR EACH ROW
BEGIN
    IF NEW.ap_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Appointment date cannot be in the past';
    END IF;
END$$


-- Trigger 2: Prevent doctor double bookings at the same time

CREATE TRIGGER CheckDoctorAvailability
BEFORE INSERT ON ap_tbl
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT *
        FROM ap_tbl
        WHERE dr_id = NEW.dr_id
          AND ap_date = NEW.ap_date
          AND ap_time = NEW.ap_time
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor already has an appointment';
    END IF;
END$$


-- Trigger 3: Calculate the follow-up review date

CREATE TRIGGER CalculateNextAp
BEFORE INSERT ON follow_up
FOR EACH ROW
BEGIN
    SET NEW.review_date = (
        SELECT DATE_ADD(
            ap_date,
            INTERVAL NEW.`next_ap(weeks)` WEEK
        )
        FROM ap_tbl
        WHERE ap_id = NEW.ap_id
    );
END$$


-- Trigger 4: Recalculate the follow-up review date

CREATE TRIGGER UpdateNextAp
BEFORE UPDATE ON follow_up
FOR EACH ROW
BEGIN
    SET NEW.review_date = (
        SELECT DATE_ADD(
            ap_date,
            INTERVAL NEW.`next_ap(weeks)` WEEK
        )
        FROM ap_tbl
        WHERE ap_id = NEW.ap_id
    );
END$$

DELIMITER ;


-- Stored procedure test

CALL GetPatientAppointments('OP001');


-- Appointment date trigger test
-- Run separately. Expected result: Error 1644.

-- INSERT INTO ap_tbl
--     (ap_id, pat_id, dr_id, clinic_id, ap_date, ap_time)
-- SELECT
--     999, pat_id, dr_id, clinic_id, '2020-01-01', ap_time
-- FROM ap_tbl
-- WHERE ap_id = 1;
