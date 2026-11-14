-- Crownfield Eye Hospital: schema and sample data
-- Fresh MySQL 8+ database only. Load before creating triggers.
-- Patient names/postcodes and staff names are replaced for public submission.
CREATE DATABASE IF NOT EXISTS `crownfield_eye_hospital`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `crownfield_eye_hospital`;

CREATE TABLE `clinic_tbl` (
  `clinic_id` varchar(5) NOT NULL,
  `clinic_name` varchar(20) NOT NULL,
  PRIMARY KEY (`clinic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dr_tbl` (
  `dr_id` varchar(5) NOT NULL,
  `dr_name` varchar(20) NOT NULL,
  `specialty` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`dr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `pat_tbl` (
  `pat_id` varchar(10) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `post_code` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`pat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `med_tbl` (
  `med_id` varchar(10) NOT NULL,
  `med_name` varchar(50) NOT NULL,
  PRIMARY KEY (`med_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ap_tbl` (
  `ap_id` int NOT NULL AUTO_INCREMENT,
  `dr_id` varchar(5) NOT NULL,
  `pat_id` varchar(10) NOT NULL,
  `clinic_id` varchar(5) NOT NULL,
  `ap_date` date NOT NULL,
  `ap_time` time NOT NULL,
  PRIMARY KEY (`ap_id`),
  KEY `fk_dr` (`dr_id`),
  KEY `fk_pat` (`pat_id`),
  KEY `fk_clinic` (`clinic_id`),
  CONSTRAINT `fk_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinic_tbl` (`clinic_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_dr` FOREIGN KEY (`dr_id`) REFERENCES `dr_tbl` (`dr_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pat` FOREIGN KEY (`pat_id`) REFERENCES `pat_tbl` (`pat_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `diag_tbl` (
  `diag_id` int NOT NULL AUTO_INCREMENT,
  `ap_id` int NOT NULL,
  `diag` varchar(50) DEFAULT NULL,
  `notes` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`diag_id`),
  KEY `fk_ap` (`ap_id`),
  CONSTRAINT `fk_ap` FOREIGN KEY (`ap_id`) REFERENCES `ap_tbl` (`ap_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `follow_up` (
  `follow_id` int NOT NULL AUTO_INCREMENT,
  `ap_id` int NOT NULL,
  `sta` enum('complete','in progress','cancelled') NOT NULL,
  `priority` enum('H','U','R') NOT NULL,
  `next_ap(weeks)` int DEFAULT NULL,
  `review_date` date DEFAULT NULL,
  PRIMARY KEY (`follow_id`),
  UNIQUE KEY `ap_id` (`ap_id`),
  UNIQUE KEY `ap_id_2` (`ap_id`),
  CONSTRAINT `fk_appp` FOREIGN KEY (`ap_id`) REFERENCES `ap_tbl` (`ap_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_followup_weeks` CHECK ((`next_ap(weeks)` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `pre_tbl` (
  `pre_id` varchar(10) NOT NULL,
  `ap_id` int NOT NULL,
  `pre_date` date DEFAULT NULL,
  PRIMARY KEY (`pre_id`),
  KEY `fk_appoitment` (`ap_id`),
  CONSTRAINT `fk_appoitment` FOREIGN KEY (`ap_id`) REFERENCES `ap_tbl` (`ap_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `pre_detail` (
  `det_id` int NOT NULL AUTO_INCREMENT,
  `pre_id` varchar(10) NOT NULL,
  `med_id` varchar(10) NOT NULL,
  `route` varchar(25) NOT NULL,
  `dose` varchar(25) NOT NULL,
  `freq` varchar(25) NOT NULL,
  `duration` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`det_id`),
  KEY `fk_med` (`med_id`),
  KEY `fk_prescription` (`pre_id`),
  CONSTRAINT `fk_med` FOREIGN KEY (`med_id`) REFERENCES `med_tbl` (`med_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription` FOREIGN KEY (`pre_id`) REFERENCES `pre_tbl` (`pre_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `clinic_tbl` (`clinic_id`, `clinic_name`) VALUES
('cl1','City Road'),
('cl10','Sheep Hole'),
('cl11','Westgate Clinic'),
('cl2','Bedford'),
('cl3','Croydon'),
('cl4','Corby'),
('cl5','Peterborough'),
('cl6','Tamworth'),
('cl7','Telford'),
('cl8','Birmingham'),
('cl9','Bristol');

INSERT INTO `dr_tbl` (`dr_id`, `dr_name`, `specialty`) VALUES
('Dr1','Doctor 1','Glaucoma'),
('Dr2','Doctor 2','Retina'),
('Dr3','Doctor 3','Cornea'),
('dr4','Doctor 4',NULL),
('dr5','Doctor 5','Oculoplastic'),
('dr6','Doctor 6','Pediatric Ophthalmology'),
('dr7','Doctor 7','Retina'),
('dr8','Doctor 8','Cataract'),
('dr9','Doctor 9','Glaucoma'),
('emp1','Receptionist 1','receptionist'),
('emp2','Receptionist 2','receptionist');

INSERT INTO `pat_tbl` (`pat_id`, `first_name`, `last_name`, `post_code`) VALUES
('OP001','Patient','Sample001',NULL),
('OP002','Patient','Sample002',NULL),
('OP003','Patient','Sample003',NULL),
('OP004','Patient','Sample004',NULL),
('OP005','Patient','Sample005',NULL),
('OP006','Patient','Sample006',NULL),
('OP007','Patient','Sample007',NULL),
('OP008','Patient','Sample008',NULL),
('OP009','Patient','Sample009',NULL),
('OP010','Patient','Sample010',NULL),
('OP011','Patient','Sample011',NULL),
('OP012','Patient','Sample012',NULL),
('OP013','Patient','Sample013',NULL);

INSERT INTO `med_tbl` (`med_id`, `med_name`) VALUES
('med1','Latanoprost'),
('med10','Visine drops'),
('med11','Dorzolamide'),
('med12','Brimonidine'),
('med2','Timolol'),
('med3','Aflibercept'),
('med4','Sodium Chloride'),
('med5','Natamycin'),
('med6','Phenylephrine'),
('med7','Tropicamide'),
('med8','Cococamole'),
('med9','Ketorolac');

INSERT INTO `ap_tbl` (`ap_id`, `dr_id`, `pat_id`, `clinic_id`, `ap_date`, `ap_time`) VALUES
(1,'Dr1','OP001','cl1','2026-10-05','09:00:00'),
(2,'Dr2','OP002','cl1','2026-10-05','09:30:00'),
(3,'Dr1','OP003','cl1','2026-10-06','11:00:00'),
(4,'Dr3','OP004','cl3','2026-10-07','14:00:00'),
(5,'Dr1','OP001','cl2','2026-11-16','10:15:00'),
(7,'Dr3','OP005','cl2','2026-11-26','16:30:00'),
(11,'Dr1','OP006','cl1','2026-12-30','16:30:00'),
(12,'Dr2','OP009','cl2','2026-12-15','11:45:00'),
(13,'dr7','OP007','cl4','2027-01-13','10:00:00'),
(16,'dr5','OP006','cl5','2027-01-20','11:30:00'),
(18,'Dr5','OP010','cl6','2027-01-25','12:00:00'),
(19,'dr1','OP008','cl6','2026-12-12','11:30:00'),
(20,'Dr9','OP012','cl11','2026-12-12','13:00:00'),
(21,'Dr9','OP011','cl11','2026-12-12','13:30:00'),
(22,'Dr1','OP011','cl1','2026-12-21','10:00:00');

INSERT INTO `diag_tbl` (`diag_id`, `ap_id`, `diag`, `notes`) VALUES
(1,1,'Ocular hypertension','Review IOP'),
(2,2,'Diabetic macular oedema','OCT before review'),
(3,3,'Glaucoma suspect','Monitor'),
(4,4,'Keratoconus','Corneal topography'),
(5,5,'Ocular hypertension','Visual test'),
(6,7,'Laser eye correction','Long sightedness (hyperopia) needed correction'),
(7,11,'Lens disorders and refractive errors','Cataract extraction, premium IOLs, LASIK/PRK'),
(8,12,'Nerve disorders','Neuro-Optic nerve disorders, visual pathway lesions'),
(9,16,'Glaucoma suspect','IOP monitoring required'),
(10,13,'Dry eye syndrome','Mild irritation and blurred vision. Artificial tears recommended'),
(11,18,'new_patient','Patient complain on double vision'),
(13,19,'eye check','routine vision check'),
(14,21,'Primary open-angle glaucoma in the right eye','Eye pressure remains above target despite timolol'),
(15,21,'Age-related cataract in the right eye','Cataract to be monitored'),
(16,20,'Ocular hypertension','Raised pressure in left eye; topical beta-blocker unsuitable.');

INSERT INTO `follow_up` (`follow_id`, `ap_id`, `sta`, `priority`, `next_ap(weeks)`, `review_date`) VALUES
(1,1,'complete','H',6,'2026-11-16'),
(2,2,'complete','U',4,'2026-11-02'),
(3,3,'in progress','R',26,'2027-04-06'),
(4,4,'in progress','R',8,'2026-12-02'),
(5,5,'in progress','R',12,'2027-02-08'),
(7,7,'in progress','R',4,'2026-12-24'),
(8,11,'in progress','H',6,'2027-02-10'),
(9,12,'in progress','U',8,'2027-02-09'),
(10,13,'in progress','R',4,'2027-02-10'),
(12,16,'in progress','R',4,'2027-02-17'),
(13,21,'in progress','H',4,'2027-01-09'),
(14,20,'in progress','R',6,'2027-01-23'),
(15,19,'complete','R',NULL,NULL);

INSERT INTO `pre_tbl` (`pre_id`, `ap_id`, `pre_date`) VALUES
('pre1',1,'2026-10-05'),
('pre10',16,'2027-01-20'),
('pre11',18,'2027-01-25'),
('pre12',21,'2026-12-12'),
('pre14',20,NULL),
('pre2',2,'2026-10-05'),
('pre4',4,'2026-10-07'),
('pre5',5,'2026-11-16'),
('pre6',7,'2026-11-26'),
('pre7',11,'2026-12-30'),
('pre8',12,'2026-12-15'),
('pre9',13,'2027-01-13');

INSERT INTO `pre_detail` (`det_id`, `pre_id`, `med_id`, `route`, `dose`, `freq`, `duration`) VALUES
(1,'pre1','med1','eye drops','1 drops','2 x day','5 days'),
(2,'pre1','med2','eye drops','1 drop','3 x day','5 days'),
(3,'pre2','med3','Intravitreal injection','2 mg','1 x monthly','3 months'),
(5,'pre4','med4','eye drops','1 drop','2 x day','5 days'),
(6,'pre5','med1','eye drops','1 drop','once daily','30 days'),
(7,'pre6','med2','eye drops','1 drop','twice daily','30 days'),
(8,'pre7','med4','eye drops','1 drop','twice daily','7 days'),
(9,'pre8','med9','eye drops','1 drop','four times daily','7 days'),
(10,'pre9','med1','eye drops','1 drop','once daily','30 days'),
(12,'pre10','med1','eye drops','1 drop','once daily','7 days'),
(15,'pre12','med2','Ophthalmic','1 drop in right eye','Twice daily','Ongoing until review'),
(16,'pre12','med11','Ophthalmic','1 drop in right eye','Twice daily','Ongoing until review'),
(17,'pre14','med12','Ophthalmic','1 drop','Twice daily','Ongoing');

CREATE VIEW `full_history` AS
select `pat_tbl`.`pat_id` AS `pat_id`,`pat_tbl`.`first_name` AS `first_name`,`pat_tbl`.`last_name` AS `last_name`,`pat_tbl`.`post_code` AS `post_code`,`ap_tbl`.`ap_id` AS `ap_id`,`ap_tbl`.`pat_id` AS `appointment_pat_id`,`ap_tbl`.`dr_id` AS `dr_id`,`ap_tbl`.`clinic_id` AS `clinic_id`,`ap_tbl`.`ap_date` AS `ap_date`,`ap_tbl`.`ap_time` AS `ap_time`,`clinic_tbl`.`clinic_id` AS `clinic_record_id`,`clinic_tbl`.`clinic_name` AS `clinic_name`,`dr_tbl`.`dr_id` AS `clinician_record_id`,`dr_tbl`.`dr_name` AS `dr_name`,`dr_tbl`.`specialty` AS `specialty`,`diag_tbl`.`diag_id` AS `diag_id`,`diag_tbl`.`ap_id` AS `diagnosis_ap_id`,`diag_tbl`.`diag` AS `diag`,`diag_tbl`.`notes` AS `notes`,`follow_up`.`follow_id` AS `follow_id`,`follow_up`.`ap_id` AS `follow_up_ap_id`,`follow_up`.`sta` AS `sta`,`follow_up`.`priority` AS `priority`,`follow_up`.`next_ap(weeks)` AS `next_ap(weeks)`,`follow_up`.`review_date` AS `review_date`,`pre_tbl`.`pre_id` AS `pre_id`,`pre_tbl`.`ap_id` AS `prescription_ap_id`,`pre_tbl`.`pre_date` AS `pre_date`,`pre_detail`.`det_id` AS `det_id`,`pre_detail`.`pre_id` AS `detail_pre_id`,`pre_detail`.`med_id` AS `detail_med_id`,`pre_detail`.`route` AS `route`,`pre_detail`.`dose` AS `dose`,`pre_detail`.`freq` AS `freq`,`pre_detail`.`duration` AS `duration`,`med_tbl`.`med_id` AS `med_id`,`med_tbl`.`med_name` AS `med_name` from ((((((((`pat_tbl` left join `ap_tbl` on((`pat_tbl`.`pat_id` = `ap_tbl`.`pat_id`))) left join `clinic_tbl` on((`ap_tbl`.`clinic_id` = `clinic_tbl`.`clinic_id`))) left join `dr_tbl` on((`ap_tbl`.`dr_id` = `dr_tbl`.`dr_id`))) left join `diag_tbl` on((`ap_tbl`.`ap_id` = `diag_tbl`.`ap_id`))) left join `follow_up` on((`ap_tbl`.`ap_id` = `follow_up`.`ap_id`))) left join `pre_tbl` on((`ap_tbl`.`ap_id` = `pre_tbl`.`ap_id`))) left join `pre_detail` on((`pre_tbl`.`pre_id` = `pre_detail`.`pre_id`))) left join `med_tbl` on((`pre_detail`.`med_id` = `med_tbl`.`med_id`))) order by `ap_tbl`.`ap_date`,`ap_tbl`.`ap_time`;

CREATE VIEW `patient_history` AS
select `pat_tbl`.`pat_id` AS `pat_id`,`pat_tbl`.`first_name` AS `first_name`,`pat_tbl`.`last_name` AS `last_name`,`ap_tbl`.`ap_date` AS `ap_date`,`ap_tbl`.`ap_time` AS `ap_time`,`clinic_tbl`.`clinic_name` AS `clinic_name`,`diag_tbl`.`diag` AS `diag`,`diag_tbl`.`notes` AS `notes`,`med_tbl`.`med_name` AS `med_name`,`pre_detail`.`dose` AS `dose`,`pre_detail`.`freq` AS `freq` from ((((((`pat_tbl` left join `ap_tbl` on((`pat_tbl`.`pat_id` = `ap_tbl`.`pat_id`))) left join `clinic_tbl` on((`ap_tbl`.`clinic_id` = `clinic_tbl`.`clinic_id`))) left join `diag_tbl` on((`diag_tbl`.`ap_id` = `ap_tbl`.`ap_id`))) left join `pre_tbl` on((`pre_tbl`.`ap_id` = `ap_tbl`.`ap_id`))) left join `pre_detail` on((`pre_detail`.`pre_id` = `pre_tbl`.`pre_id`))) left join `med_tbl` on((`med_tbl`.`med_id` = `pre_detail`.`med_id`)));
