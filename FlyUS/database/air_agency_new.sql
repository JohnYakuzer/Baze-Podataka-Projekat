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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `korisnici`
--

LOCK TABLES `korisnici` WRITE;
/*!40000 ALTER TABLE `korisnici` DISABLE KEYS */;
INSERT INTO `korisnici` VALUES (3,'Admin','root','admin@example.com','scrypt:32768:8:1$EJMcOmgl8L9O3Fjf$9666313c79cc5d1011abe852fee91bae3f118576397126db9b25e5a9abe8d62546c63a900d868e0992bbe3245314f73135609ba16769a4dddb122ff3dd392438',NULL,NULL,1),(18,'Marko ','Spasovic','markospasovic@gmail.com','scrypt:32768:8:1$CjESyKQJB0ovBndn$c7798f7a6e269987b029caf981ea871ce76037a70ee769f58052fcad11f7b88e9800f3901cffc542c0a3d0cbb8e1fb5d23903656cd4258fa95162229646935b6','+38269001932',NULL,0),(20,'Mirko','Dragojevic','dark_master_mirko@hackerman.com','scrypt:32768:8:1$oAwfwQiyUcZvREST$a741097ae912bfbb251ef8caa475d9e7e28ab6590d1ac30bf69bf8d975f329b8b3e2b3b4403849ad588cdad8713055067a044447eb6f67b7f452edfb146e720b',NULL,NULL,0),(22,'Marta','Kesic','marta_ke12@gmail.com','scrypt:32768:8:1$WepYDXYtRExpZVxP$a6780f7a8ad25d91346d8792b5bff4da93f551b91dcc0a7cbd3e57d2662d815509930ec4b9c0a6671f0d2a21f765f046c8fdd4ac412c3fa41e96de23a1c52223','+01846018',NULL,0),(23,'Janus','Ristovski','jane@gmail.com','scrypt:32768:8:1$Z33H2GplG91UDz1h$ecfd75906c2d1f245af7c305e673d715b75253edd75ad1931ec51002ebd98ea45953e5757ae3c813244855f777a48c347ee52c767a510ef21f7937e4396997e4','+23001841',NULL,0),(24,'Adrijana ','Bulajic','ba113@gmail.com','scrypt:32768:8:1$4kaWnGSByhkmPTKo$30af90f4b757041669c3855116503a0e8042fdd3b3b990a1a92a44d7f19bc22591327e522d1e53a29bf3e1e983ace59fdf0a3cc794995c4bbb7480d2a1ef75cc','+018814954',NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `letovi`
--

LOCK TABLES `letovi` WRITE;
/*!40000 ALTER TABLE `letovi` DISABLE KEYS */;
INSERT INTO `letovi` VALUES (8,'Beograd Nikola Tesla','Šarl de Gol (Pariz)','Srbija','Francuska','2025-07-10T08:30','2025-07-10T11:20',125,'Ekonomska','Air Serbia',37,'1','A5','2h 50m','Uključen ručni prtljag.'),(9,'Međunarodni aerodrom Sarajevo','Šiphol (Amsterdam)','Bosna i Hercegovina','Holandija','2025-06-15T06:10','2025-06-15T09:00',170,'Ekonomska','KLM',22,'1A','C3','2h 50m','1 komad ručnog prtljaga.'),(10,'Podgorica','Cirih','Crna Gora','Švajcarska','2025-08-25T17:40','2025-08-25T19:30',380,'Biznis','Swiss',4,'C','D7','1h 50m','VIP salon uključen.'),(12,'Split','Oslo Gardermoen','Hrvatska','Norveška','2025-07-22T09:20','2025-07-19T12:40',180,'Ekonomska','Norwegian',19,'A','E2','3h 20m',''),(15,'Mostar','Beč Schwechat','Bosna i Hercegovina','Austrija','2025-08-10T06:50','2025-08-10T08:30',310,'Biznis','Austrian Airlines',9,'A','A2','1h 40m',''),(16,'Rijeka','Kopenhagen','Hrvatska','Danska','2025-06-28T18:10','2025-06-28T20:35',175,'Ekonomska','SAS Scandinavian',17,' C','D5','2h 25m',' Elektronska karta obavezna pri ukrcavanju.');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (18,NULL,'Stefan','Marijanovic','scrypt:32768:8:1$ESjeUyyd4XxlLMVs$eae2bc63360fe63e6506fa41e7d976c40cc5ba7973073b05fc21cbf91de7848294ffaeca31791ecd610ac2ab9b19c20526688b5405256f98ea010ad916f793ea','04/28','scrypt:32768:8:1$Dg0f4CG9niB6TTGj$26637876a19a36080160d9ef909e814496cece2abaf0b76ed97df195d091ad527ea5c6dbf6f85807f78b1fbe1bec416d47bf03d678019b78d58315d0c28e5b9c','Cukaricka bb','Crna Gora'),(19,23,'Jane','Ristovski','scrypt:32768:8:1$2umvzFexO0Vvrrg4$22686698c101446761367a133134744c808ff5103f732fb0efdd78d6a2a456f1b2b9037415dd1da2dde363f57fbc463e1af153e561a8c26082def2ea226da93b','02/29','scrypt:32768:8:1$akvRZpFxhLTmA2oa$4021396bc26853e63cddc8975de53cbd1ecdc851cfc6a7f5f2c93ab95c9fea6f6c3998633503382f4ebbb48420a8ca2121a373a26132bd00d23887af672b9b11','Kumbor 1001','Austrija'),(20,20,'Mirko','Dragojevic','scrypt:32768:8:1$zQZCH8XTjhyDztXR$89f0e71558ac70e0b33f3a03bf0a39c97a3461892e559f4faa9e7c0e8552a670d44283530b45aa33a1f7d7a9da3b61df984744d3dc8c08bd7bd3a401b9d21878','12/30','scrypt:32768:8:1$hItqEN8MAQtFMSsP$31221b910d9d45abbca0c05f925708cab18381532570110e636e533c9501a44785d150a0eac09066f915aa917ea96e1de841d32eb56bc2bc9a6a923f08d2af98','Zlatica 211,','Srbija'),(22,22,'Marta','Kesic','scrypt:32768:8:1$idlqGimp56ogx4G8$1d6656090b4ee14bdd557f60e8dfc4de1a15921d8853ce91510d908a295f64cbc52ebba6cbfaf5ea4872190bfec5bb069d757c0d2a0301b77835d0915e6fc0b4','12/25','scrypt:32768:8:1$fBhPQTTEfwLT5JdX$319390f21d9761c8ce7783e11f7195241a78cc7de0b6db6d70b67042265a6c2752d7be40337b5a71cee22cb5f49f4b4ed3f6b7d90d0277aa6ab724a18eda082e','-----','Makedonija');
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rezervacije`
--

LOCK TABLES `rezervacije` WRITE;
/*!40000 ALTER TABLE `rezervacije` DISABLE KEYS */;
INSERT INTO `rezervacije` VALUES (44,NULL,NULL,'2025-06-13','potvrdjeno',4,1400),(47,NULL,NULL,'2025-06-13','potvrdjeno',4,1400),(48,NULL,8,'2025-06-15','potvrdjeno',1,125),(49,23,8,'2025-06-15','potvrdjeno',4,500),(50,20,9,'2025-06-15','potvrdjeno',1,170),(51,20,10,'2025-06-15','potvrdjeno',2,760),(52,22,15,'2025-06-15','potvrdjeno',3,930);
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (5,3,1),(6,NULL,0),(7,NULL,0),(8,NULL,1),(9,NULL,0),(10,NULL,0),(11,NULL,0),(12,NULL,0),(13,NULL,0),(14,NULL,0),(15,NULL,0),(16,NULL,0),(17,NULL,0),(18,NULL,0),(19,NULL,0),(20,18,0),(21,NULL,0),(22,20,0),(23,NULL,0),(24,22,0),(25,23,0),(26,24,0);
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

-- Dump completed on 2025-06-15 23:12:42
