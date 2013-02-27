-- phpMyAdmin SQL Dump
-- version 3.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 19, 2012 at 05:15 PM
-- Server version: 5.5.25a
-- PHP Version: 5.4.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `virtualmusiclessons`
--

-- --------------------------------------------------------

--
-- Table structure for table `t_lesson`
--

CREATE TABLE IF NOT EXISTS `t_lesson` (
  `P_Lesson_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Lesson` varchar(30) NOT NULL,
  `Artist` varchar(30) NOT NULL,
  `Song` varchar(30) NOT NULL,
  `Instrument` varchar(30) NOT NULL,
  `Genre` varchar(30) NOT NULL,
  `Difficulty` int(11) NOT NULL,
  `Description` text NOT NULL,
  `Uploader` varchar(30) NOT NULL,
  `Tab_Path` varchar(150) NOT NULL,
  `Video1_Path` varchar(150) NOT NULL,
  `Video2_Path` varchar(150) NOT NULL,
  `Video3_Path` varchar(150) NOT NULL,
  `Thumbnail` varchar(150) NOT NULL,
  `Track_Path` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`P_Lesson_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=143 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
