-- MySQL Script generated by MySQL Workbench
-- Sun Dec 15 06:00:58 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema apotek_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema apotek_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `apotek_db` DEFAULT CHARACTER SET utf8 ;
USE `apotek_db` ;

-- -----------------------------------------------------
-- Table `apotek_db`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`Users` (
  `id` INT NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(30) NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` TINYINT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_email` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`Profiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`Profiles` (
  `id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `profile_types` VARCHAR(255) NOT NULL,
  `profile_data` JSON NULL,
  `parent_profile_id` INT NULL,
  `is_primary` TINYINT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  INDEX `parent_profile_id_idx` (`parent_profile_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `apotek_db`.`Users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `parent_profile_id`
    FOREIGN KEY (`parent_profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`UserRoles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`UserRoles` (
  `id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `role_name` VARCHAR(255) NULL,
  `assigned_at` TIMESTAMP NULL,
  `is_active` TINYINT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id_idx` (`user_id` ASC) INVISIBLE,
  INDEX `idx_user_roles` (`role_name` ASC) VISIBLE,
  CONSTRAINT `user_id_alt2`
    FOREIGN KEY (`user_id`)
    REFERENCES `apotek_db`.`Users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`ProfessionalDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`ProfessionalDetails` (
  `id` INT NOT NULL,
  `profile_id` INT NOT NULL,
  `license_number` VARCHAR(255) NULL,
  `specialty` VARCHAR(255) NULL,
  `qualifications` JSON NULL,
  `signature` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `profile_id_idx` (`profile_id` ASC) VISIBLE,
  INDEX `idx_license` (`license_number` ASC) VISIBLE,
  CONSTRAINT `profile_id`
    FOREIGN KEY (`profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`Prescriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`Prescriptions` (
  `id` INT NOT NULL,
  `prescriber_profile_id` INT NOT NULL,
  `patient_profile_id` INT NOT NULL,
  `prescribed_at` TIMESTAMP NULL,
  `valid_until` TIMESTAMP NULL,
  `status` VARCHAR(255) NULL,
  `digital_signature` VARCHAR(255) NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_patient_prescriptions` (`prescriber_profile_id` ASC) INVISIBLE,
  INDEX `idx_prescriber_prescriptions` (`patient_profile_id` ASC) INVISIBLE,
  CONSTRAINT `prescriber_profile_id`
    FOREIGN KEY (`prescriber_profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `patient_profile_id`
    FOREIGN KEY (`patient_profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`therapeutic_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`therapeutic_categories` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `parent_category_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_category_name` (`name` ASC) VISIBLE,
  INDEX `parent_category_id_idx` (`parent_category_id` ASC) VISIBLE,
  CONSTRAINT `parent_category_id`
    FOREIGN KEY (`parent_category_id`)
    REFERENCES `apotek_db`.`therapeutic_categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`drugs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`drugs` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `generic_name` VARCHAR(255) NULL,
  `brand_name` VARCHAR(255) NULL,
  `therapeutic_category_id` INT NULL,
  `prescription_required` TINYINT NULL,
  `max_daily_dose` DECIMAL NULL,
  `dosage_form` VARCHAR(255) NULL,
  `route_admin` VARCHAR(255) NULL,
  `storage_conditions` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_drug_name` (`name` ASC) VISIBLE,
  INDEX `therapeutic_category_id_idx` (`therapeutic_category_id` ASC) VISIBLE,
  CONSTRAINT `therapeutic_category_id`
    FOREIGN KEY (`therapeutic_category_id`)
    REFERENCES `apotek_db`.`therapeutic_categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`PrescriptionItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`PrescriptionItems` (
  `id` INT NOT NULL,
  `prescription_id` INT NULL,
  `drug_id` INT NULL,
  `dosage` VARCHAR(255) NULL,
  `frequency` VARCHAR(255) NULL,
  `duration` VARCHAR(255) NULL,
  `instructions` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `prescription_id_idx` (`prescription_id` ASC) VISIBLE,
  INDEX `idx_prescription_drugs` (`drug_id` ASC) INVISIBLE,
  CONSTRAINT `prescription_id`
    FOREIGN KEY (`prescription_id`)
    REFERENCES `apotek_db`.`Prescriptions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `drug_id_alt4`
    FOREIGN KEY (`drug_id`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`DrugInventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`DrugInventory` (
  `id` INT NOT NULL,
  `drug_id` INT NULL,
  `pharmacy_profile_id` INT NULL,
  `quantity` INT NULL,
  `price` DECIMAL NULL,
  `expiry_date` DATE NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_pharmacy_inventory` (`quantity` ASC) VISIBLE,
  INDEX `drug_id_idx` (`drug_id` ASC) VISIBLE,
  INDEX `pharmacy_profile_id_idx` (`pharmacy_profile_id` ASC) VISIBLE,
  CONSTRAINT `drug_id_alt5`
    FOREIGN KEY (`drug_id`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pharmacy_profile_id`
    FOREIGN KEY (`pharmacy_profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`clinical_conditions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`clinical_conditions` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `severity` VARCHAR(255) NULL,
  `icd10_code` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `standard_treatment_notes` TEXT NULL,
  `treatment_metadata` JSON NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_condition_name` (`name` ASC) INVISIBLE,
  INDEX `idx_icd_code` (`icd10_code` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`condition_drug_recommendations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`condition_drug_recommendations` (
  `id` INT NOT NULL,
  `clinical_condition_id` INT NULL,
  `drug_id` INT NULL,
  `line_of_treatment` INT NULL,
  `evidence_level` VARCHAR(255) NULL,
  `dosing_details` JSON NULL,
  `usage_notes` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_condition_id` (`clinical_condition_id` ASC) VISIBLE,
  INDEX `idx_drug_id` (`drug_id` ASC) VISIBLE,
  CONSTRAINT `clinical_condition_id`
    FOREIGN KEY (`clinical_condition_id`)
    REFERENCES `apotek_db`.`clinical_conditions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `drug_id_alt6`
    FOREIGN KEY (`drug_id`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`contraindications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`contraindications` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `type` VARCHAR(255) NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_contra_name` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`drug_contraindications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`drug_contraindications` (
  `id` INT NOT NULL,
  `drug_id` INT NULL,
  `contraindiction_id` INT NULL,
  `severity` VARCHAR(255) NULL,
  `specific_notes` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_drug_contra` (`contraindiction_id` ASC) VISIBLE,
  INDEX `drug_id_idx` (`drug_id` ASC) VISIBLE,
  CONSTRAINT `drug_id_alt1`
    FOREIGN KEY (`drug_id`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `contraindication_id`
    FOREIGN KEY (`contraindiction_id`)
    REFERENCES `apotek_db`.`contraindications` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`adverse_effects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`adverse_effects` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `severity` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_effect_name` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`drug_adverse_effects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`drug_adverse_effects` (
  `id` INT NOT NULL,
  `drug_id` INT NULL,
  `adverse_effect_id` INT NULL,
  `frequency` VARCHAR(255) NULL,
  `age_group` VARCHAR(255) NULL,
  `specific_notes` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `drug_id_idx` (`drug_id` ASC) VISIBLE,
  INDEX `idx_drug_effect` (`adverse_effect_id` ASC) VISIBLE,
  CONSTRAINT `drug_id_alt2`
    FOREIGN KEY (`drug_id`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `adverse_effect_id`
    FOREIGN KEY (`adverse_effect_id`)
    REFERENCES `apotek_db`.`adverse_effects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`reproductive_safety`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`reproductive_safety` (
  `id` INT NOT NULL,
  `drug_id` INT NULL,
  `fertility_effects` VARCHAR(255) NULL,
  `pregnancy_category` VARCHAR(255) NULL,
  `pregnancy_trimester_details` JSON NULL,
  `lactation_safety` VARCHAR(255) NULL,
  `fertility_notes` TEXT NULL,
  `pregnancy_notes` TEXT NULL,
  `lactation_notes` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_drug_safety` (`lactation_safety` ASC) VISIBLE,
  INDEX `drug_id_idx` (`drug_id` ASC) VISIBLE,
  CONSTRAINT `drug_id_alt3`
    FOREIGN KEY (`drug_id`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`interaction_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`interaction_types` (
  `id` INT NOT NULL,
  `name` VARCHAR(255) NULL,
  `category` VARCHAR(255) NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_interaction_type` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`drug_interactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`drug_interactions` (
  `id` INT NOT NULL,
  `drug_id_1` INT NULL,
  `drug_id_2` INT NULL,
  `interaction_type_id` INT NULL,
  `severity` VARCHAR(255) NULL,
  `evidence_level` VARCHAR(255) NULL,
  `mechanism` TEXT NULL,
  `clinical_effects` TEXT NULL,
  `management` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_drug_pair1` (`drug_id_1` ASC) VISIBLE,
  INDEX `idx_drug_pair2` (`drug_id_2` ASC) VISIBLE,
  INDEX `interaction_type_id_idx` (`interaction_type_id` ASC) VISIBLE,
  INDEX `idx_severity` (`severity` ASC) VISIBLE,
  CONSTRAINT `drug_id_1`
    FOREIGN KEY (`drug_id_1`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `drug_id_2`
    FOREIGN KEY (`drug_id_2`)
    REFERENCES `apotek_db`.`drugs` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interaction_type_id`
    FOREIGN KEY (`interaction_type_id`)
    REFERENCES `apotek_db`.`interaction_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`Posts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`Posts` (
  `id` INT NOT NULL,
  `profile_id` INT NULL,
  `content` VARCHAR(255) NULL,
  `type` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_profile_posts` (`content` ASC) INVISIBLE,
  INDEX `profile_id_idx` (`profile_id` ASC) VISIBLE,
  CONSTRAINT `profile_id_alt`
    FOREIGN KEY (`profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`Messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`Messages` (
  `id` INT NOT NULL,
  `sender_profile_id` INT NULL,
  `receiver_profile_id` INT NULL,
  `content` VARCHAR(255) NULL,
  `is_read` TINYINT NULL,
  `created_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_user_messages` (`content` ASC) VISIBLE,
  INDEX `sender_profile_id_idx` (`sender_profile_id` ASC) VISIBLE,
  INDEX `receiver_profile_id_idx` (`receiver_profile_id` ASC) VISIBLE,
  CONSTRAINT `sender_profile_id`
    FOREIGN KEY (`sender_profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `receiver_profile_id`
    FOREIGN KEY (`receiver_profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `apotek_db`.`MedicationReminders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apotek_db`.`MedicationReminders` (
  `id` INT NOT NULL,
  `profile_id` INT NULL,
  `prescription_item_id` INT NULL,
  `reminder_time` TIMESTAMP NULL,
  `response_data` JSON NULL,
  PRIMARY KEY (`id`),
  INDEX `profile_id_idx` (`profile_id` ASC) VISIBLE,
  INDEX `prescription_item_id_idx` (`prescription_item_id` ASC) VISIBLE,
  CONSTRAINT `profile_id_alt1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `apotek_db`.`Profiles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prescription_item_id`
    FOREIGN KEY (`prescription_item_id`)
    REFERENCES `apotek_db`.`PrescriptionItems` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
