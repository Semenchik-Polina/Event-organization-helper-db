-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Event
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Event
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Event` DEFAULT CHARACTER SET utf8 ;
USE `Event` ;

-- -----------------------------------------------------
-- Table `Event`.`Adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Adress` (
  `id_adress` INT NOT NULL AUTO_INCREMENT,
  `country` CHAR(45) NOT NULL DEFAULT 'Беларусь',
  `city` CHAR(45) NOT NULL DEFAULT 'Минск',
  `street` CHAR(45) NOT NULL,
  `building` INT NOT NULL,
  PRIMARY KEY (`id_adress`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Event` (
  `id_event` INT NOT NULL AUTO_INCREMENT,
  `name` CHAR(45) NOT NULL,
  `subject_area` CHAR(30) NOT NULL,
  `description` VARCHAR(300) NULL DEFAULT NULL,
  `id_adress` INT NOT NULL,
  `beginning_date` DATE NOT NULL,
  `ending_date` DATE NOT NULL,
  PRIMARY KEY (`id_event`, `id_adress`),
  INDEX `fk_Event_Place1_idx` (`id_adress` ASC) VISIBLE,
  CONSTRAINT `fk_Event_Place1`
    FOREIGN KEY (`id_adress`)
    REFERENCES `Event`.`Adress` (`id_adress`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Part_Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Part_Event` (
  `id_part_event` INT NOT NULL AUTO_INCREMENT,
  `name` CHAR(45) NOT NULL,
  `type` CHAR(15) NOT NULL DEFAULT 'Лекция',
  `max_participant_count` INT NULL,
  `id_event` INT NOT NULL,
  PRIMARY KEY (`id_part_event`, `id_event`),
  INDEX `fk_Part_Event_Event_idx` (`id_event` ASC) VISIBLE,
  CONSTRAINT `fk_Part_Event_Event`
    FOREIGN KEY (`id_event`)
    REFERENCES `Event`.`Event` (`id_event`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Organization` (
  `id_organization` INT NOT NULL AUTO_INCREMENT,
  `name` CHAR(45) NOT NULL,
  `e-mail` CHAR(45) NOT NULL,
  `phone_number` CHAR(15) NOT NULL,
  `id_adress` INT NOT NULL,
  PRIMARY KEY (`id_organization`, `id_adress`),
  INDEX `fk_Organization_Adress1_idx` (`id_adress` ASC) VISIBLE,
  CONSTRAINT `fk_Organization_Adress1`
    FOREIGN KEY (`id_adress`)
    REFERENCES `Event`.`Adress` (`id_adress`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`User` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `login` CHAR(45) NOT NULL,
  `password_hash` INT NOT NULL,
  `first_name` CHAR(45) NULL,
  `last_name` CHAR(45) NULL,
  `city` CHAR(45) NOT NULL DEFAULT 'Минск',
  `phone_number` CHAR(15) NULL,
  `e_mail` CHAR(45) NOT NULL,
  `id_company` INT NULL,
  `position` CHAR(45) NULL,
  PRIMARY KEY (`id_user`),
  INDEX `fk_Person_Company1_idx` (`id_company` ASC) VISIBLE,
  CONSTRAINT `fk_Person_Company1`
    FOREIGN KEY (`id_company`)
    REFERENCES `Event`.`Organization` (`id_organization`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Rating` (
  `id_rating` INT NOT NULL AUTO_INCREMENT,
  `rating_value` INT NOT NULL,
  `comment` VARCHAR(300) NULL,
  PRIMARY KEY (`id_rating`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Participant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Participant` (
  `id_participant` INT NOT NULL AUTO_INCREMENT,
  `role` CHAR(15) NOT NULL DEFAULT 'Слушатель',
  `id_rating` INT NULL,
  `id_part_event` INT NOT NULL,
  `id_user` INT NULL,
  PRIMARY KEY (`id_participant`, `id_part_event`),
  INDEX `fk_Participant_Part_Event1_idx` (`id_part_event` ASC) VISIBLE,
  INDEX `fk_Participant_Person1_idx` (`id_user` ASC) VISIBLE,
  INDEX `fk_Participant_Rating1_idx` (`id_rating` ASC) VISIBLE,
  CONSTRAINT `fk_Participant_Part_Event1`
    FOREIGN KEY (`id_part_event`)
    REFERENCES `Event`.`Part_Event` (`id_part_event`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Participant_Person1`
    FOREIGN KEY (`id_user`)
    REFERENCES `Event`.`User` (`id_user`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Participant_Rating1`
    FOREIGN KEY (`id_rating`)
    REFERENCES `Event`.`Rating` (`id_rating`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Prize`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Prize` (
  `id_prize` INT NOT NULL AUTO_INCREMENT,
  `place_numb` INT NOT NULL DEFAULT 1,
  `type` CHAR(45) NOT NULL,
  `number` INT NOT NULL DEFAULT 1,
  `id_organization` INT NULL,
  PRIMARY KEY (`id_prize`, `id_organization`),
  INDEX `fk_Prize_Company1_idx` (`id_organization` ASC) VISIBLE,
  CONSTRAINT `fk_Prize_Company1`
    FOREIGN KEY (`id_organization`)
    REFERENCES `Event`.`Organization` (`id_organization`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Organizator`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Organizator` (
  `id_organization` INT NOT NULL,
  `id_event` INT NULL,
  INDEX `fk_Sponsor_Company1_idx` (`id_organization` ASC) VISIBLE,
  PRIMARY KEY (`id_event`, `id_organization`),
  CONSTRAINT `fk_Sponsor_Company1`
    FOREIGN KEY (`id_organization`)
    REFERENCES `Event`.`Organization` (`id_organization`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Sponsor_Event1`
    FOREIGN KEY (`id_event`)
    REFERENCES `Event`.`Event` (`id_event`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Part_Event_has_Prize`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Part_Event_has_Prize` (
  `id_part_event` INT NOT NULL,
  `id_prize` INT NULL,
  PRIMARY KEY (`id_part_event`, `id_prize`),
  INDEX `fk_Part_Event_has_Prize_Prize1_idx` (`id_prize` ASC) VISIBLE,
  INDEX `fk_Part_Event_has_Prize_Part_Event1_idx` (`id_part_event` ASC) VISIBLE,
  CONSTRAINT `fk_Part_Event_has_Prize_Part_Event1`
    FOREIGN KEY (`id_part_event`)
    REFERENCES `Event`.`Part_Event` (`id_part_event`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Part_Event_has_Prize_Prize1`
    FOREIGN KEY (`id_prize`)
    REFERENCES `Event`.`Prize` (`id_prize`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Event`.`Scedule_Info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Event`.`Scedule_Info` (
  `id_part_event` INT NOT NULL,
  `time` DATETIME NOT NULL,
  `duration` TIME NULL,
  `space` CHAR(45) NULL,
  PRIMARY KEY (`id_part_event`),
  INDEX `fk_Scedule_Info_Part_Event1_idx` (`id_part_event` ASC) VISIBLE,
  CONSTRAINT `fk_Scedule_Info_Part_Event1`
    FOREIGN KEY (`id_part_event`)
    REFERENCES `Event`.`Part_Event` (`id_part_event`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
