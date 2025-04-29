SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE prosody;
USE prosody;
/*M!999999\- enable the sandbox mode */ 
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `prosody` (
  `host` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `store` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `type` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  UNIQUE KEY `prosody_unique_index` (`host`(20),`user`(20),`store`(20),`key`(20)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sipwise_mam` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `key` binary(16) NOT NULL,
  `stanza` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `epoch` int(11) NOT NULL,
  `with` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `username` (`username`),
  KEY `with_idx` (`with`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sipwise_offline` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `stanza` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `UuidFromBin`(_bin BINARY(16)) RETURNS binary(36)
    DETERMINISTIC
    SQL SECURITY INVOKER
RETURN
    LCASE(CONCAT_WS('-',
        HEX(SUBSTR(_bin,  5, 4)),
        HEX(SUBSTR(_bin,  3, 2)),
        HEX(SUBSTR(_bin,  1, 2)),
        HEX(SUBSTR(_bin,  9, 2)),
        HEX(SUBSTR(_bin, 11))
             )) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `UuidToBin`(_uuid BINARY(36)) RETURNS binary(16)
    DETERMINISTIC
    SQL SECURITY INVOKER
RETURN
    UNHEX(CONCAT(
        SUBSTR(_uuid, 15, 4),
        SUBSTR(_uuid, 10, 4),
        SUBSTR(_uuid,  1, 8),
        SUBSTR(_uuid, 20, 4),
        SUBSTR(_uuid, 25) )) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*M!999999\- enable the sandbox mode */ 
/*M!999999\- enable the sandbox mode */ 
COMMIT;
