-- MySQL dump 10.13  Distrib 9.3.0, for Linux (x86_64)
--
-- Host: localhost    Database: air_agency
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `korisnici`
--

DROP TABLE IF EXISTS `korisnici`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `korisnici` (
  `korisnik_id` int NOT NULL AUTO_INCREMENT,
  `ime` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prezime` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lozinka_hash` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `broj_telefona` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_slika` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`korisnik_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `korisnici`
--

LOCK TABLES `korisnici` WRITE;
/*!40000 ALTER TABLE `korisnici` DISABLE KEYS */;
INSERT INTO `korisnici` VALUES (3,'Admin','root','admin@example.com','scrypt:32768:8:1$s1hdEBQilJWwCEnU$5a161cc0d274f3795a2cd15156e4a2e5038255987cafab8fa1fc80b371c1ac598df3b739212b33bdcf7f18d17a8071200c0f8f1bf02ccefb450e18ae2f771134',NULL,NULL,1),(4,'joe','Shmoe','joe@example.com','scrypt:32768:8:1$z0oIyijR9aTsn7we$eca56d7814e4298456c99e3d51c9783ca7d8e1f480c714f48680ae7d65d52ef8e43691521db694339a0873cc3e030edc16b6be27cee0ed4b0d520b9081939683',NULL,NULL,0),(5,'Marko','Pesic','marko@example.com','scrypt:32768:8:1$IAUmQgoyKmzpiqCn$c5e3050d25e50273689dc36a88f90bd0e83b4f36f0e7c9ba9738cf8683242b80dd2db05db4e8b0f5588cc1db53fc82447293a22637e8d6aa5afbf856c15d0068',NULL,NULL,0),(6,'Admin','2','admin_2@example.com','scrypt:32768:8:1$f7w3Hi08NmJKOyUJ$4332224e4198d157fb045fa795d4b6137156d436f4aee2b30d3b773f1a9bbfafdc5ac512fd0033af48e2c686c993284985afd694c717c4b8207b70bafc487348',NULL,NULL,1);
/*!40000 ALTER TABLE `korisnici` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `letovi`
--

DROP TABLE IF EXISTS `letovi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `letovi` (
  `let_id` int NOT NULL AUTO_INCREMENT,
  `polazni_aerodrom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `odredisni_aerodrom` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `drzava_input` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `drzava_output` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vrijeme_i_datum_polaska` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vrijeme_i_datum_dolaska` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cijena` float DEFAULT NULL,
  `klasa` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avio_kompanija` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dostupna_sjedista` int DEFAULT NULL,
  `broj_terminala` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `broj_izlaza` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trajanje_leta` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dodatne_informacije` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`let_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `letovi`
--

LOCK TABLES `letovi` WRITE;
/*!40000 ALTER TABLE `letovi` DISABLE KEYS */;
INSERT INTO `letovi` VALUES (2,'Beograd','London','Srbija','UK','2025-07-01 08:00','2025-07-01 10:45',350,'Ekonomska','FlyUS',80,'T2','G5','2h 45min','Let bez presedanja'),(3,'Beograd','New York','Srbija','SAD','2025-07-01 09:00','2025-07-01 18:00',350,'ekonomska','FlyUS',150,'T1','G5','9h','Direktan let, ručak uključen'),(4,'Beograd','New York','Srbija','SAD','2025-07-01 09:00','2025-07-01 18:00',350,'ekonomska','FlyUS',150,'T1','G5','9h','Direktan let, ručak uključen');
/*!40000 ALTER TABLE `letovi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `korisnik_id` int DEFAULT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `card_number_hash` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_expiration` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `security_number_hash` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `fk_payment_korisnik` (`korisnik_id`),
  CONSTRAINT `fk_payment_korisnik` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnici` (`korisnik_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rezervacije`
--

DROP TABLE IF EXISTS `rezervacije`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rezervacije` (
  `rezervacija_id` int NOT NULL AUTO_INCREMENT,
  `korisnik_id` int DEFAULT NULL,
  `let_id` int DEFAULT NULL,
  `datum_rezervacije` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'potvrdjeno',
  `rezervisana_sjedista` int DEFAULT NULL,
  `ukupna_cijena` float DEFAULT NULL,
  PRIMARY KEY (`rezervacija_id`),
  KEY `fk_rezervacije_korisnik` (`korisnik_id`),
  KEY `fk_rezervacije_let` (`let_id`),
  CONSTRAINT `fk_rezervacije_korisnik` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnici` (`korisnik_id`),
  CONSTRAINT `fk_rezervacije_let` FOREIGN KEY (`let_id`) REFERENCES `letovi` (`let_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rezervacije`
--

LOCK TABLES `rezervacije` WRITE;
/*!40000 ALTER TABLE `rezervacije` DISABLE KEYS */;
/*!40000 ALTER TABLE `rezervacije` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_user_id` int NOT NULL AUTO_INCREMENT,
  `korisnik_id` int DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`role_user_id`),
  UNIQUE KEY `korisnik_id` (`korisnik_id`),
  CONSTRAINT `fk_roles_korisnik` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnici` (`korisnik_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (5,3,1),(6,4,0),(7,5,0),(8,6,1);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-12  0:28:39
