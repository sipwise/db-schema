SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE stats;
USE stats;
/*M!999999\- enable the sandbox mode */ 
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `call_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sip_code` varchar(3) NOT NULL,
  `period` datetime NOT NULL,
  `amount` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `call_info_sip_code_period_idx` (`sip_code`,`period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cdr_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `peer_in_total` int(11) unsigned NOT NULL DEFAULT 0,
  `peer_in_rated` int(11) unsigned NOT NULL DEFAULT 0,
  `peer_out_total` int(11) unsigned NOT NULL DEFAULT 0,
  `peer_out_rated` int(11) unsigned NOT NULL DEFAULT 0,
  `peer_cost` decimal(14,6) DEFAULT 0.000000,
  `reseller_in_total` int(11) unsigned NOT NULL DEFAULT 0,
  `reseller_in_rated` int(11) unsigned NOT NULL DEFAULT 0,
  `reseller_out_total` int(11) unsigned NOT NULL DEFAULT 0,
  `reseller_out_rated` int(11) unsigned NOT NULL DEFAULT 0,
  `reseller_cost` decimal(14,6) DEFAULT 0.000000,
  `customer_in_total` int(11) unsigned NOT NULL DEFAULT 0,
  `customer_in_rated` int(11) unsigned NOT NULL DEFAULT 0,
  `customer_out_total` int(11) unsigned NOT NULL DEFAULT 0,
  `customer_out_rated` int(11) unsigned NOT NULL DEFAULT 0,
  `customer_cost` decimal(14,6) DEFAULT 0.000000,
  `period` datetime NOT NULL,
  `last_rated_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cdr_info_period_idx` (`period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*M!999999\- enable the sandbox mode */ 
/*M!999999\- enable the sandbox mode */ 
COMMIT;
