SET SESSION time_zone=UTC;
SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE fileshare;
USE fileshare;
/*M!999999\- enable the sandbox mode */ 
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `downloads` (
  `id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `state` enum('NEW','DOWNLOADED') NOT NULL DEFAULT 'NEW',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `upload_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `upload_id` (`upload_id`),
  KEY `downloads_expires_at` (`expires_at`),
  CONSTRAINT `downloads_ibfk_1` FOREIGN KEY (`upload_id`) REFERENCES `uploads` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `ttl` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `uploads` (
  `id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
  `data` longblob DEFAULT NULL,
  `original_name` varchar(255) DEFAULT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `ttl` int(11) DEFAULT NULL,
  `state` enum('NEW','UPLOADED') NOT NULL DEFAULT 'NEW',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `session_id` char(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `subscriber_id` int(10) unsigned DEFAULT NULL,
  `reseller_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `uploads_expires_at` (`expires_at`),
  KEY `subscriber_id_idx` (`subscriber_id`),
  KEY `reseller_id_idx` (`reseller_id`),
  CONSTRAINT `u_reseller_id_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `u_subscriber_id_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `billing`.`voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `uploads_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*M!999999\- enable the sandbox mode */ 
set autocommit=0;
commit;
set autocommit=0;
commit;
set autocommit=0;
commit;
/*M!999999\- enable the sandbox mode */ 
COMMIT;
