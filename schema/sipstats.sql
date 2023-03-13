/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mark` (
  `name` varchar(255) NOT NULL,
  `value` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `message_packets` (
  `message` bigint(20) unsigned NOT NULL,
  `packet` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`message`,`packet`),
  KEY `packet` (`packet`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci
 PARTITION BY RANGE (`message`)
(PARTITION `p700000` VALUES LESS THAN (700000) ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` decimal(17,6) NOT NULL,
  `protocol` enum('IPv4','IPv6') NOT NULL,
  `transport` enum('UDP','TCP') NOT NULL,
  `src_ip` varchar(39) NOT NULL,
  `dst_ip` varchar(39) NOT NULL,
  `src_port` smallint(5) unsigned NOT NULL,
  `dst_port` smallint(5) unsigned NOT NULL,
  `payload` blob NOT NULL,
  `method` varchar(20) NOT NULL,
  `cseq_method` varchar(16) NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `request_uri` varchar(255) NOT NULL,
  `from_uri` varchar(255) NOT NULL,
  `caller_uuid` varchar(255) NOT NULL,
  `callee_uuid` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `call_id_idx` (`call_id`),
  KEY `caller_uuid_idx` (`caller_uuid`),
  KEY `callee_uuid_idx` (`callee_uuid`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci
 PARTITION BY RANGE (`id`)
(PARTITION `p700000` VALUES LESS THAN (700000) ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` decimal(17,6) NOT NULL,
  `src_mac` binary(6) NOT NULL,
  `dst_mac` binary(6) NOT NULL,
  `header` blob NOT NULL,
  `payload` blob NOT NULL,
  `trailer` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uniq` (`timestamp`,`src_mac`,`dst_mac`,`header`(80))
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci
 PARTITION BY RANGE (`id`)
(PARTITION `p700000` VALUES LESS THAN (700000) ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` decimal(17,6) NOT NULL,
  `req_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_register` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_invite` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_bye` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_ack` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_prack` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_cancel` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_update` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_options` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_publish` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_subscribe` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_notify` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_message` bigint(20) unsigned NOT NULL DEFAULT 0,
  `req_other` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_18x` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_1xx` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_2xx` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_3xx` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_401` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_407` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_403` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_404` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_480` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_486` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_487` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_4xx` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_5xx` bigint(20) unsigned NOT NULL DEFAULT 0,
  `res_6xx` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci
 PARTITION BY RANGE (floor(`timestamp`))
(PARTITION `p_old` VALUES LESS THAN (600) ENGINE = InnoDB);
/*!40101 SET character_set_client = @saved_cs_client */;
