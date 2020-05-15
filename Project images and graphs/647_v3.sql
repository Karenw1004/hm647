-- phpMyAdmin SQL Dump
-- version 3.4.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 08, 2020 at 04:58 PM
-- Server version: 5.1.73
-- PHP Version: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `karenws`
--

-- --------------------------------------------------------

--
-- Table structure for table `bed`
--

CREATE TABLE IF NOT EXISTS `bed` (
  `BED_ID` int(255) NOT NULL,
  `START_DATE` datetime NOT NULL,
  `END_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`BED_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bed`
--

INSERT INTO `bed` (`BED_ID`, `START_DATE`, `END_DATE`) VALUES
(1111, '2020-04-17 13:37:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE IF NOT EXISTS `doctor` (
  `DOCTOR_ID` int(255) NOT NULL,
  `PASSWORD` varchar(255) NOT NULL,
  `ADDRESS` varchar(255) NOT NULL,
  `is_at_work` bit(1) NOT NULL,
  PRIMARY KEY (`DOCTOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`DOCTOR_ID`, `PASSWORD`, `ADDRESS`, `is_at_work`) VALUES
(1, '2222', '1325 REC RD', b'1');

-- --------------------------------------------------------

--
-- Table structure for table `full_name`
--

CREATE TABLE IF NOT EXISTS `full_name` (
  `NAME_ID` int(255) NOT NULL,
  `FIRST_NAME` varchar(255) NOT NULL,
  `MIDDLE_NAME` varchar(255) DEFAULT NULL,
  `LAST_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`NAME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `full_name`
--

INSERT INTO `full_name` (`NAME_ID`, `FIRST_NAME`, `MIDDLE_NAME`, `LAST_NAME`) VALUES
(1, 'Betsey', 'null', 'John'),
(2, 'Betsey', 'null', 'Polo');

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE IF NOT EXISTS `patient` (
  `PATIENT_ID` int(255) NOT NULL,
  `ADDRESS` varchar(255) NOT NULL,
  `SEX` enum('Female','Male') NOT NULL,
  `BLOOD` enum('A','B','O','AB') DEFAULT NULL,
  `HEART_RATE` int(255) DEFAULT NULL,
  `TEMPERATURE` int(255) DEFAULT NULL,
  `PULSE` int(255) DEFAULT NULL,
  `BED_ID` int(255) NOT NULL,
  `DOCTOR_ID` int(255) NOT NULL,
  PRIMARY KEY (`PATIENT_ID`),
  KEY `ROOM_ID` (`BED_ID`),
  KEY `DOCTOR_ID` (`DOCTOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `PATIENT_VIEW`
--

CREATE ALGORITHM=UNDEFINED DEFINER=`karenws`@`%` SQL SECURITY DEFINER VIEW `karenws`.`PATIENT_VIEW` AS select `karenws`.`patient`.`PATIENT_ID` AS `PATIENT_ID`,`karenws`.`patient`.`ROOM_ID` AS `ROOM_ID`,`karenws`.`room`.`START_DATE` AS `START_DATE`,`karenws`.`room`.`END_DATE` AS `END_DATE`,`karenws`.`patient`.`DOCTOR_ID` AS `DOCTOR_ID`,`karenws`.`pay_for`.`TREATMENT_ID` AS `TREATMENT_ID`,`karenws`.`treatment`.`NAME` AS `NAME` from (((`karenws`.`patient` join `karenws`.`pay_for`) join `karenws`.`treatment`) join `karenws`.`room`) where ((`karenws`.`patient`.`ROOM_ID` = `karenws`.`room`.`ROOM_ID`) and (`karenws`.`patient`.`PATIENT_ID` = `karenws`.`pay_for`.`PATIENT_ID`) and (`karenws`.`pay_for`.`TREATMENT_ID` = `karenws`.`treatment`.`TREATMENT_ID`)) group by `karenws`.`patient`.`PATIENT_ID`,`karenws`.`patient`.`DOCTOR_ID`,`karenws`.`patient`.`ROOM_ID`,`karenws`.`treatment`.`NAME`,`karenws`.`room`.`START_DATE`,`karenws`.`room`.`END_DATE`;
-- in use (#1356 - View 'karenws.PATIENT_VIEW' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them)

-- --------------------------------------------------------

--
-- Table structure for table `pay_for`
--

CREATE TABLE IF NOT EXISTS `pay_for` (
  `PATIENT_ID` int(255) NOT NULL,
  `TREATMENT_ID` int(255) NOT NULL,
  KEY `SSN` (`PATIENT_ID`,`TREATMENT_ID`),
  KEY `TREATMENT_ID` (`TREATMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Posts`
--

CREATE TABLE IF NOT EXISTS `Posts` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) NOT NULL,
  `author_id` varchar(255) NOT NULL,
  PRIMARY KEY (`post_id`),
  KEY `author_id` (`author_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `Posts`
--

INSERT INTO `Posts` (`post_id`, `content`, `author_id`) VALUES
(31, '', '123456'),
(32, '', '5555'),
(12, 'Bacon ipsum dolor amet cow turducken corned beef andouille kielbasa tenderloin swine venison. Kielbasa filet mignon frankfurter pork loin, hamburger landjaeger brisket chicken flank turkey strip steak beef ribs prosciutto. Sirloin pig strip steak.', 'apple'),
(17, 'I am lxy', 'lxy'),
(27, 'dfgrt', 'sahithireddy'),
(28, 'rfgvb', 'sahithireddy'),
(29, 'fgrthcujcvm', 'raja'),
(30, '1231', '123456'),
(25, 'rtg5tg', 'raja'),
(24, '', 'lxy'),
(20, '', 'sahithi'),
(21, 'hi how', 'raja'),
(22, '', 'raja'),
(23, '', 'sahithireddy'),
(26, 'sdfg', 'mugda'),
(15, 'Apple apple apple\r\nhii', 'john'),
(16, 'Iloveyouuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu\r\n', 'john');

-- --------------------------------------------------------

--
-- Table structure for table `prescribe`
--

CREATE TABLE IF NOT EXISTS `prescribe` (
  `DOCTOR_ID` int(255) NOT NULL,
  `TREATMENT_ID` int(255) NOT NULL,
  KEY `DOCTOR_ID` (`DOCTOR_ID`,`TREATMENT_ID`),
  KEY `TREATMENT_ID` (`TREATMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `treatment`
--

CREATE TABLE IF NOT EXISTS `treatment` (
  `TREATMENT_ID` int(255) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `PRICE` decimal(65,2) NOT NULL,
  PRIMARY KEY (`TREATMENT_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10004 ;

--
-- Dumping data for table `treatment`
--

INSERT INTO `treatment` (`TREATMENT_ID`, `NAME`, `PRICE`) VALUES
(10001, 'KILLME', '11.11'),
(10002, 'KILLME', '11.11'),
(10003, 'KILLME', '11.11');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `doctor`
--
ALTER TABLE `doctor`
  ADD CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`DOCTOR_ID`) REFERENCES `full_name` (`NAME_ID`);

--
-- Constraints for table `patient`
--
ALTER TABLE `patient`
  ADD CONSTRAINT `patient_ibfk_3` FOREIGN KEY (`DOCTOR_ID`) REFERENCES `doctor` (`DOCTOR_ID`),
  ADD CONSTRAINT `patient_ibfk_4` FOREIGN KEY (`PATIENT_ID`) REFERENCES `full_name` (`NAME_ID`),
  ADD CONSTRAINT `patient_ibfk_5` FOREIGN KEY (`BED_ID`) REFERENCES `bed` (`BED_ID`);

--
-- Constraints for table `pay_for`
--
ALTER TABLE `pay_for`
  ADD CONSTRAINT `pay_for_ibfk_1` FOREIGN KEY (`TREATMENT_ID`) REFERENCES `treatment` (`TREATMENT_ID`),
  ADD CONSTRAINT `pay_for_ibfk_2` FOREIGN KEY (`PATIENT_ID`) REFERENCES `patient` (`PATIENT_ID`);

--
-- Constraints for table `prescribe`
--
ALTER TABLE `prescribe`
  ADD CONSTRAINT `prescribe_ibfk_1` FOREIGN KEY (`DOCTOR_ID`) REFERENCES `doctor` (`DOCTOR_ID`),
  ADD CONSTRAINT `prescribe_ibfk_2` FOREIGN KEY (`TREATMENT_ID`) REFERENCES `treatment` (`TREATMENT_ID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
