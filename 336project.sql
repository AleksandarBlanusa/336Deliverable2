CREATE DATABASE  IF NOT EXISTS `336project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `336project`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: 336project
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `airline`
--

DROP TABLE IF EXISTS `airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airline` (
  `airline_id` varchar(5) NOT NULL,
  `airline` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airline`
--

LOCK TABLES `airline` WRITE;
/*!40000 ALTER TABLE `airline` DISABLE KEYS */;
INSERT INTO `airline` VALUES ('AA','American Airlines'),('DL','Delta'),('EK','Emirates'),('UA','United'),('WN','Southwest');
/*!40000 ALTER TABLE `airline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `airports` (
  `airport_code` varchar(3) NOT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`airport_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES ('BOS','Boston','Massachusetts'),('EWR','Newark','New Jersey'),('ORD','Chicago','Illinois'),('RDU','Raleigh','North Carolina');
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flights`
--

DROP TABLE IF EXISTS `flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flights` (
  `flight_id` int NOT NULL AUTO_INCREMENT,
  `airline_id` varchar(5) NOT NULL,
  `total_first_class_seats` int DEFAULT NULL,
  `total_business_seats` int DEFAULT NULL,
  `total_economy_seats` int DEFAULT NULL,
  `sold_firstclass_seats` int DEFAULT '0',
  `sold_business_seats` int DEFAULT '0',
  `sold_economy_seats` int DEFAULT '0',
  `firstclass_price` int DEFAULT NULL,
  `business_price` int DEFAULT NULL,
  `economy_price` int DEFAULT NULL,
  `stops` int DEFAULT NULL,
  `takeoff_time` datetime DEFAULT NULL,
  `landing_time` datetime DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `origin_airport_code` varchar(3) DEFAULT NULL,
  `destination_airport_code` varchar(3) DEFAULT NULL,
  `total_seats_sold` int DEFAULT '0',
  PRIMARY KEY (`flight_id`),
  KEY `airline_id` (`airline_id`),
  KEY `origin_airport_code` (`origin_airport_code`),
  KEY `destination_airport_code` (`destination_airport_code`),
  CONSTRAINT `flights_ibfk_1` FOREIGN KEY (`airline_id`) REFERENCES `airline` (`airline_id`),
  CONSTRAINT `flights_ibfk_2` FOREIGN KEY (`origin_airport_code`) REFERENCES `airports` (`airport_code`),
  CONSTRAINT `flights_ibfk_3` FOREIGN KEY (`destination_airport_code`) REFERENCES `airports` (`airport_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights`
--

LOCK TABLES `flights` WRITE;
/*!40000 ALTER TABLE `flights` DISABLE KEYS */;
INSERT INTO `flights` VALUES (1,'AA',5,5,20,0,0,0,200,100,50,0,'2025-05-01 14:00:00','2025-05-01 18:30:00',270,'ORD','EWR',0),(2,'UA',2,5,20,0,0,0,200,100,50,0,'2025-04-21 12:00:00','2025-04-21 16:00:00',240,'EWR','RDU',0),(3,'EK',3,3,20,0,0,0,200,100,50,0,'2025-03-01 08:00:00','2025-03-01 12:00:00',240,'BOS','RDU',0);
/*!40000 ALTER TABLE `flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `role` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('Dev','Patel','test','test@gmail.com','test','customer'),('admin','admin','admin','admin@gmail.com','admin','admin'),('Neelesh','Talasila','Neelesh','test1@gmail.com','test','customer'),('Pranav','Gummaluri','Pranav','test2@gmail.com','test','customer_rep'),('Alek','test','Alek','test3@gmail.com','test','customer');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-27 17:42:18
