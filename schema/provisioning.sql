SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE provisioning;
USE provisioning;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_configs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `version` varchar(255) NOT NULL,
  `content_type` varchar(255) NOT NULL,
  `data` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_config_device_idx` (`device_id`),
  CONSTRAINT `fk_config_device_idx` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_device_extensions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `extension_id` int(11) unsigned NOT NULL,
  `order` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_dev_dev_const` (`device_id`),
  KEY `fk_dev_ext_const` (`extension_id`),
  CONSTRAINT `fk_dev_dev_const` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dev_ext_const` FOREIGN KEY (`extension_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_device_line_annotations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `range_id` int(11) unsigned NOT NULL,
  `line_index` int(4) unsigned NOT NULL,
  `x` int(4) unsigned NOT NULL DEFAULT 0,
  `y` int(4) unsigned NOT NULL DEFAULT 0,
  `position` enum('top','bottom','left','right','bottomleft','bottomright','topleft','topright') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `range_idx_k` (`range_id`,`line_index`),
  KEY `fk_anno_range` (`range_id`),
  CONSTRAINT `fk_anno_range` FOREIGN KEY (`range_id`) REFERENCES `autoprov_device_line_ranges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_device_line_ranges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `num_lines` int(4) unsigned NOT NULL DEFAULT 0,
  `can_private` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `can_shared` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `can_blf` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `can_speeddial` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `can_forward` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `can_transfer` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_device_line` (`device_id`),
  CONSTRAINT `fk_device_line` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_devices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `vendor` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `front_image` mediumblob DEFAULT NULL,
  `front_image_type` varchar(32) DEFAULT NULL,
  `front_thumbnail` mediumblob DEFAULT NULL,
  `front_thumbnail_type` varchar(32) DEFAULT NULL,
  `mac_image` mediumblob DEFAULT NULL,
  `mac_image_type` varchar(32) DEFAULT NULL,
  `num_lines` int(5) unsigned DEFAULT NULL,
  `bootstrap_method` enum('http','redirect_panasonic','redirect_yealink','redirect_polycom','redirect_snom','redirect_grandstream','redirect_ale') DEFAULT 'http',
  `bootstrap_uri` varchar(255) DEFAULT '',
  `type` enum('phone','extension') DEFAULT 'phone',
  `extensions_num` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reseller_idx` (`reseller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_field_device_lines` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `subscriber_id` int(11) unsigned NOT NULL,
  `linerange_id` int(11) unsigned NOT NULL,
  `key_num` int(11) unsigned NOT NULL,
  `line_type` enum('private','shared','blf','speeddial','forward','transfer') DEFAULT 'private',
  `extension_unit` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `deviceid_dbaliases_id` int(11) unsigned DEFAULT NULL,
  `target_number` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fdev_line_const` (`device_id`),
  KEY `fk_sub_line_const` (`subscriber_id`),
  KEY `fk_fielddevlines_devlinerange_idx` (`linerange_id`),
  CONSTRAINT `autoprov_field_device_lines_ibfk_1` FOREIGN KEY (`linerange_id`) REFERENCES `autoprov_device_line_ranges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fdev_line_const` FOREIGN KEY (`device_id`) REFERENCES `autoprov_field_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sub_line_const` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_field_devices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `profile_id` int(11) unsigned NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `bootstrapped` tinyint(1) NOT NULL DEFAULT 0,
  `insecure_transfer` tinyint(1) NOT NULL DEFAULT 0,
  `station_name` varchar(255) NOT NULL,
  `encryption_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_identifier_idx` (`identifier`),
  KEY `fk_fdev_subscriber_idx` (`contract_id`),
  KEY `fk_fdev_profile_idx` (`profile_id`),
  CONSTRAINT `fk_fdev_profile_idx` FOREIGN KEY (`profile_id`) REFERENCES `autoprov_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_firmwares` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `version` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL,
  `tag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_device_idx` (`device_id`),
  KEY `version_idx` (`device_id`,`version`),
  CONSTRAINT `fk_device_idx` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_firmwares_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fw_id` int(11) unsigned NOT NULL,
  `data` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `afd_fw_id_idx` (`fw_id`),
  CONSTRAINT `fk_fw_idx` FOREIGN KEY (`fw_id`) REFERENCES `autoprov_firmwares` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_profiles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `config_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_profile_config_idx` (`config_id`),
  CONSTRAINT `fk_profile_config_idx` FOREIGN KEY (`config_id`) REFERENCES `autoprov_configs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_redirect_credentials` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `user` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ap_devid_fk` (`device_id`),
  CONSTRAINT `autoprov_redirect_credentials_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_sync` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL,
  `parameter_id` int(10) unsigned NOT NULL,
  `parameter_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `a_s_paramid_ref` (`parameter_id`),
  KEY `a_s_deviceid_ref` (`device_id`),
  CONSTRAINT `a_s_deviceid_ref` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `a_s_paramid_ref` FOREIGN KEY (`parameter_id`) REFERENCES `autoprov_sync_parameters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `autoprov_sync_parameters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bootstrap_method` enum('http','redirect_panasonic','redirect_yealink','redirect_polycom','redirect_snom','redirect_grandstream') DEFAULT 'http',
  `parameter_name` enum('sync_uri','sync_method','sync_params','security_handler','profile','cid','key','product_family') DEFAULT NULL,
  `parameter_constraint` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sync_parameter` (`bootstrap_method`,`parameter_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emergency_containers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `res_name_idx` (`reseller_id`,`name`),
  KEY `reseller_idx` (`reseller_id`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emergency_mappings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `emergency_container_id` int(11) unsigned NOT NULL,
  `code` varchar(32) NOT NULL,
  `prefix` varchar(32) DEFAULT NULL,
  `suffix` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ec_code_idx` (`emergency_container_id`,`code`),
  CONSTRAINT `container_fk` FOREIGN KEY (`emergency_container_id`) REFERENCES `emergency_containers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `language_strings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(63) NOT NULL,
  `language` char(2) NOT NULL,
  `string` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codelang_idx` (`code`,`language`)
) ENGINE=InnoDB AUTO_INCREMENT=1252 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recording_calls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `call_id` varchar(250) NOT NULL,
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `end_time` datetime DEFAULT NULL,
  `start_timestamp` decimal(13,3) DEFAULT NULL,
  `end_timestamp` decimal(13,3) DEFAULT NULL,
  `status` enum('recording','completed','confirmed') DEFAULT 'recording',
  PRIMARY KEY (`id`),
  KEY `call_id` (`call_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recording_metakeys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `call` int(10) unsigned NOT NULL,
  `key` char(255) NOT NULL,
  `value` char(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prim_lookup` (`value`,`key`),
  KEY `fk_call_idx` (`call`),
  CONSTRAINT `fk_call_idx` FOREIGN KEY (`call`) REFERENCES `recording_calls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recording_streams` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `call` int(10) unsigned NOT NULL,
  `local_filename` varchar(250) NOT NULL,
  `full_filename` varchar(250) NOT NULL,
  `file_format` varchar(10) NOT NULL,
  `output_type` enum('mixed','single') NOT NULL,
  `stream_id` int(10) unsigned NOT NULL,
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `end_time` datetime DEFAULT NULL,
  `sample_rate` int(10) unsigned NOT NULL DEFAULT 0,
  `channels` int(10) unsigned NOT NULL DEFAULT 0,
  `ssrc` int(10) unsigned NOT NULL,
  `start_timestamp` decimal(13,3) DEFAULT NULL,
  `end_timestamp` decimal(13,3) DEFAULT NULL,
  `tag_label` varchar(255) NOT NULL DEFAULT '',
  `stream` longblob NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `call` (`call`),
  CONSTRAINT `fk_call_id` FOREIGN KEY (`call`) REFERENCES `recording_calls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtc_session` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `rtc_session_id` varchar(36) NOT NULL,
  `rtc_network_tag` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rtc_session_idx` (`rtc_session_id`),
  KEY `subscriber_idx` (`subscriber_id`),
  CONSTRAINT `tl_subscriber_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtc_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `rtc_user_id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reseller_idx` (`reseller_id`),
  UNIQUE KEY `rtc_user_idx` (`rtc_user_id`),
  CONSTRAINT `tl_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sms_journal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(10) unsigned NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `direction` enum('in','out','forward') NOT NULL DEFAULT 'in',
  `caller` varchar(255) NOT NULL,
  `callee` varchar(255) NOT NULL,
  `text` mediumtext NOT NULL,
  `reason` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(255) NOT NULL DEFAULT '',
  `coding` varchar(16) NOT NULL,
  `pcc_status` enum('none','pending','complete','failed') NOT NULL DEFAULT 'none',
  `pcc_token` varchar(64) NOT NULL DEFAULT '',
  `cli` varchar(128) NOT NULL DEFAULT '',
  `smsc_peer` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `sms_journal_sub_dir_idx` (`subscriber_id`,`direction`),
  KEY `sms_journal_time_idx` (`time`),
  KEY `pcc_token_idx` (`id`,`pcc_token`,`pcc_status`),
  CONSTRAINT `smsj_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upn_rewrite_set` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `new_cli` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `upn_rewrite_sources` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `upn_rewrite_set_id` int(11) unsigned NOT NULL,
  `pattern` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_upn_rewrite_sources_1` (`upn_rewrite_set_id`),
  CONSTRAINT `fk_upn_rewrite_sources_1` FOREIGN KEY (`upn_rewrite_set_id`) REFERENCES `upn_rewrite_set` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_sound_set_files` AS SELECT
 1 AS `set_id`,
  1 AS `reseller_id`,
  1 AS `contract_id`,
  1 AS `name`,
  1 AS `description`,
  1 AS `handle_id`,
  1 AS `handle_name`,
  1 AS `file_id`,
  1 AS `filename`,
  1 AS `loopplay`,
  1 AS `parent_chain`,
  1 AS `data_set_id`,
  1 AS `data` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_subscriber_cfs` AS SELECT
 1 AS `id`,
  1 AS `uuid`,
  1 AS `cf_type`,
  1 AS `subscriber_id`,
  1 AS `source_name`,
  1 AS `source_mode`,
  1 AS `source_is_regex`,
  1 AS `source`,
  1 AS `destination_name`,
  1 AS `destination`,
  1 AS `priority`,
  1 AS `timeout`,
  1 AS `announcement_id`,
  1 AS `bnumber_name`,
  1 AS `bnumber_mode`,
  1 AS `bnumber_is_regex`,
  1 AS `bnumber`,
  1 AS `time_name`,
  1 AS `year`,
  1 AS `month`,
  1 AS `mday`,
  1 AS `wday`,
  1 AS `hour`,
  1 AS `minute` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_time_periods_ical` AS SELECT
 1 AS `id`,
  1 AS `time_set_id`,
  1 AS `start`,
  1 AS `end`,
  1 AS `comment`,
  1 AS `rrule_ical`,
  1 AS `event_ical` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_time_sets_ical` AS SELECT
 1 AS `id`,
  1 AS `name`,
  1 AS `ical` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_aig_sequence` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_allowed_ip_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL,
  `ipnet` varchar(46) NOT NULL,
  `_ipv4_net_from` varbinary(4) DEFAULT NULL,
  `_ipv4_net_to` varbinary(4) DEFAULT NULL,
  `_ipv6_net_from` varbinary(16) DEFAULT NULL,
  `_ipv6_net_to` varbinary(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groupnet_idx` (`group_id`,`ipnet`),
  KEY `groupid_idx` (`group_id`),
  KEY `ipnet_idx` (`ipnet`),
  KEY `aig_groupid_ipv4_from_to_idx` (`group_id`,`_ipv4_net_from`,`_ipv4_net_to`),
  KEY `aig_groupid_ipv6_from_to_idx` (`group_id`,`_ipv6_net_from`,`_ipv6_net_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cc_mappings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `auth_key` varchar(255) NOT NULL,
  `source_uuid` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uuid_idx` (`uuid`),
  KEY `uuid_authkey_idx` (`uuid`,`auth_key`),
  CONSTRAINT `vs_uuid_ref` FOREIGN KEY (`uuid`) REFERENCES `voip_subscribers` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_bnumber_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `mode` enum('whitelist','blacklist') NOT NULL DEFAULT 'whitelist',
  `is_regex` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_bnumbersets_sid_name_unique` (`subscriber_id`,`name`),
  KEY `name_idx` (`name`),
  CONSTRAINT `vcbs_subid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_bnumbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bnumber_set_id` int(11) unsigned NOT NULL,
  `bnumber` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bset_idx` (`bnumber_set_id`),
  KEY `bnumber_idx` (`bnumber`),
  CONSTRAINT `v_cf_bsetid_ref` FOREIGN KEY (`bnumber_set_id`) REFERENCES `voip_cf_bnumber_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_destination_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sub_idx` (`subscriber_id`),
  KEY `name_idx` (`name`),
  CONSTRAINT `v_s_subid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_destinations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `destination_set_id` int(11) unsigned NOT NULL,
  `destination` varchar(255) NOT NULL,
  `priority` int(3) unsigned DEFAULT NULL,
  `timeout` int(11) unsigned NOT NULL DEFAULT 300,
  `announcement_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dset_idx` (`destination_set_id`),
  KEY `destination_idx` (`destination`),
  KEY `d_s_announceid_ref` (`announcement_id`),
  CONSTRAINT `d_s_announceid_ref` FOREIGN KEY (`announcement_id`) REFERENCES `voip_sound_handles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `v_cf_dsetid_ref` FOREIGN KEY (`destination_set_id`) REFERENCES `voip_cf_destination_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_mappings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `type` enum('cfu','cfb','cfna','cft','cfs','cfr','cfo') NOT NULL DEFAULT 'cfu',
  `destination_set_id` int(11) unsigned DEFAULT NULL,
  `time_set_id` int(11) unsigned DEFAULT NULL,
  `source_set_id` int(11) unsigned DEFAULT NULL,
  `bnumber_set_id` int(11) unsigned DEFAULT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `sub_idx` (`subscriber_id`),
  KEY `type_idx` (`type`),
  KEY `cfmap_time_ref` (`time_set_id`),
  KEY `cfmap_dest_ref` (`destination_set_id`),
  KEY `vcm_bnumset_ref` (`bnumber_set_id`),
  KEY `cfmap_sset_idx` (`source_set_id`),
  CONSTRAINT `cfmap_dest_ref` FOREIGN KEY (`destination_set_id`) REFERENCES `voip_cf_destination_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cfmap_time_ref` FOREIGN KEY (`time_set_id`) REFERENCES `voip_cf_time_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_cfmap_subid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vcm_bnumset_ref` FOREIGN KEY (`bnumber_set_id`) REFERENCES `voip_cf_bnumber_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vcm_sourceset_ref` FOREIGN KEY (`source_set_id`) REFERENCES `voip_cf_source_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_periods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `time_set_id` int(11) unsigned NOT NULL,
  `year` varchar(255) DEFAULT NULL,
  `month` varchar(255) DEFAULT NULL,
  `mday` varchar(255) DEFAULT NULL,
  `wday` varchar(255) DEFAULT NULL,
  `hour` varchar(255) DEFAULT NULL,
  `minute` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tset_idx` (`time_set_id`),
  CONSTRAINT `v_cf_tsetid_ref` FOREIGN KEY (`time_set_id`) REFERENCES `voip_cf_time_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_source_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `mode` enum('whitelist','blacklist') NOT NULL DEFAULT 'whitelist',
  `is_regex` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cf_sourcesets_sid_name_unique` (`subscriber_id`,`name`),
  KEY `sub_idx` (`subscriber_id`),
  KEY `name_idx` (`name`),
  CONSTRAINT `vcss_subid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_sources` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `source_set_id` int(11) unsigned NOT NULL,
  `source` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sset_idx` (`source_set_id`),
  KEY `source_idx` (`source`),
  CONSTRAINT `v_cf_ssetid_ref` FOREIGN KEY (`source_set_id`) REFERENCES `voip_cf_source_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_cf_time_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sub_idx` (`subscriber_id`),
  KEY `name_idx` (`name`),
  CONSTRAINT `v_cf_ts_subid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_contacts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `firstname` varchar(127) DEFAULT NULL,
  `lastname` varchar(127) DEFAULT NULL,
  `company` varchar(127) DEFAULT NULL,
  `phonenumber` varchar(31) DEFAULT NULL,
  `homephonenumber` varchar(31) DEFAULT NULL,
  `mobilenumber` varchar(31) DEFAULT NULL,
  `faxnumber` varchar(31) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `homepage` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriberid_idx` (`subscriber_id`),
  CONSTRAINT `v_c_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_contacts_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_contract_location_blocks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(11) unsigned NOT NULL,
  `ip` varchar(39) NOT NULL,
  `mask` tinyint(1) unsigned DEFAULT NULL,
  `_ipv4_net_from` varbinary(4) DEFAULT NULL,
  `_ipv4_net_to` varbinary(4) DEFAULT NULL,
  `_ipv6_net_from` varbinary(16) DEFAULT NULL,
  `_ipv6_net_to` varbinary(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vclb_unique_location_block` (`location_id`,`ip`,`mask`),
  KEY `vclb_ipv4_from_idx` (`_ipv4_net_from`),
  KEY `vclb_ipv4_to_idx` (`_ipv4_net_to`),
  KEY `vclb_ipv6_from_idx` (`_ipv6_net_from`),
  KEY `vclb_ipv6_to_idx` (`_ipv6_net_to`),
  KEY `vclb_location_ref` (`location_id`),
  CONSTRAINT `vclb_location_ref` FOREIGN KEY (`location_id`) REFERENCES `voip_contract_locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_contract_locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vcl_contract_name_idx` (`contract_id`,`name`),
  CONSTRAINT `vcl_contract_ref` FOREIGN KEY (`contract_id`) REFERENCES `billing`.`contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_contract_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `location_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `conidattrid_idx` (`contract_id`,`attribute_id`),
  KEY `contractid_idx` (`contract_id`),
  KEY `attributeid_idx` (`attribute_id`),
  KEY `v_c_p_locationid_ref` (`location_id`),
  CONSTRAINT `v_c_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_c_p_locationid_ref` FOREIGN KEY (`location_id`) REFERENCES `voip_contract_locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_contract_preferences_blob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `preference_id` int(11) unsigned NOT NULL,
  `content_type` varchar(128) NOT NULL DEFAULT 'application/data',
  `value` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `preference_id` (`preference_id`),
  CONSTRAINT `fk_contract_blob_pref_id` FOREIGN KEY (`preference_id`) REFERENCES `voip_contract_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci `PAGE_COMPRESSED`=1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_contract_speed_dial` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `slot` varchar(64) NOT NULL,
  `destination` varchar(192) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contractid_slot_idx` (`contract_id`,`slot`),
  CONSTRAINT `v_csd_contractid_ref` FOREIGN KEY (`contract_id`) REFERENCES `billing`.`contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_dbaliases` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(127) NOT NULL,
  `domain_id` int(11) unsigned NOT NULL,
  `subscriber_id` int(11) unsigned NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `is_devid` tinyint(1) NOT NULL DEFAULT 0,
  `devid_alias` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_dom_idx` (`username`,`domain_id`),
  KEY `domainid_idx` (`domain_id`),
  KEY `subscriberid_idx` (`subscriber_id`),
  CONSTRAINT `v_da_domainid_ref` FOREIGN KEY (`domain_id`) REFERENCES `voip_domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_da_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_dbaliases_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `voip_domains` (`id`),
  CONSTRAINT `voip_dbaliases_ibfk_2` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_dev_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `devidattrid_idx` (`device_id`,`attribute_id`),
  KEY `deviceid_idx` (`device_id`),
  KEY `attributeid_idx` (`attribute_id`),
  CONSTRAINT `v_d_p_deviceid_ref` FOREIGN KEY (`device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_dev_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_devprof_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `devprofidattrid_idx` (`profile_id`,`attribute_id`),
  KEY `devprofileid_idx` (`profile_id`),
  KEY `attributeid_idx` (`attribute_id`),
  CONSTRAINT `v_devprof_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_p_p_deviceid_ref` FOREIGN KEY (`profile_id`) REFERENCES `autoprov_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_dom_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `domidattrid_idx` (`domain_id`,`attribute_id`),
  KEY `domainid_idx` (`domain_id`),
  KEY `attributeid_idx` (`attribute_id`),
  CONSTRAINT `v_d_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_d_p_domainid_ref` FOREIGN KEY (`domain_id`) REFERENCES `voip_domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_dom_preferences_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `voip_domains` (`id`),
  CONSTRAINT `voip_dom_preferences_ibfk_2` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_dom_preferences_blob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `preference_id` int(11) unsigned NOT NULL,
  `content_type` varchar(128) NOT NULL DEFAULT 'application/data',
  `value` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `preference_id` (`preference_id`),
  CONSTRAINT `fk_dom_blob_pref_id` FOREIGN KEY (`preference_id`) REFERENCES `voip_dom_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci `PAGE_COMPRESSED`=1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_domains` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(127) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_idx` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_fax_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(10) unsigned NOT NULL,
  `sid` varchar(255) NOT NULL,
  `size` int(11) unsigned NOT NULL,
  `checksum` char(32) NOT NULL,
  `data` mediumblob NOT NULL,
  `time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `v_fd_sid_ref` (`sid`),
  KEY `v_fd_subid_idx` (`subscriber_id`),
  CONSTRAINT `v_fd_sid_ref` FOREIGN KEY (`sid`) REFERENCES `voip_fax_journal` (`sid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_fax_destinations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `destination` varchar(255) NOT NULL,
  `filetype` enum('PS','TIFF','PDF','PDF14') NOT NULL DEFAULT 'TIFF',
  `cc` tinyint(1) NOT NULL DEFAULT 0,
  `incoming` tinyint(1) NOT NULL DEFAULT 1,
  `outgoing` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subdest_idx` (`subscriber_id`,`destination`),
  CONSTRAINT `v_f_d_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_fax_destinations_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_fax_journal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(10) unsigned NOT NULL,
  `time` decimal(13,3) NOT NULL,
  `direction` enum('in','out','mtf') NOT NULL,
  `duration` int(11) unsigned NOT NULL DEFAULT 0,
  `caller` varchar(255) NOT NULL,
  `callee` varchar(255) NOT NULL,
  `pages` int(10) unsigned NOT NULL DEFAULT 0,
  `reason` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `signal_rate` int(10) unsigned NOT NULL DEFAULT 0,
  `quality` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `sid` varchar(255) NOT NULL,
  `caller_uuid` char(36) DEFAULT NULL,
  `callee_uuid` char(36) DEFAULT NULL,
  `call_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `voip_fj_sub_dir_idx` (`subscriber_id`,`direction`),
  KEY `voip_fj_time_idx` (`time`),
  KEY `caller_uuid_idx` (`caller_uuid`),
  KEY `callee_uuid_idx` (`callee_uuid`),
  KEY `v_fj_sid_idx` (`sid`),
  KEY `callid_idx` (`call_id`),
  CONSTRAINT `v_fj_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_fax_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `password` varchar(64) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `send_status` tinyint(1) NOT NULL DEFAULT 1,
  `send_copy` tinyint(1) NOT NULL DEFAULT 1,
  `t38` tinyint(1) NOT NULL DEFAULT 1,
  `ecm` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subscriberid_idx` (`subscriber_id`),
  CONSTRAINT `v_f_p_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_fax_preferences_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_fielddev_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fielddevidattrid_idx` (`device_id`,`attribute_id`),
  KEY `fielddeviceid_idx` (`device_id`),
  KEY `attributeid_idx` (`attribute_id`),
  CONSTRAINT `v_fd_p_fielddeviceid_ref` FOREIGN KEY (`device_id`) REFERENCES `autoprov_field_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_fdev_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_header_rule_actions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(11) unsigned NOT NULL,
  `header` varchar(255) NOT NULL,
  `header_part` enum('full','username','domain','port') NOT NULL DEFAULT 'full',
  `action_type` enum('set','add','remove','rsub','header','preference') NOT NULL,
  `value_part` enum('full','username','domain','port') NOT NULL DEFAULT 'full',
  `value` varchar(255) DEFAULT NULL,
  `rwr_set_id` int(11) unsigned DEFAULT NULL,
  `rwr_dp_id` int(11) unsigned DEFAULT NULL,
  `priority` int(11) unsigned NOT NULL DEFAULT 100,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `rule_id_idx` (`rule_id`),
  KEY `rwr_set_id_idx` (`rwr_set_id`),
  KEY `rwr_dp_id_idx` (`rwr_dp_id`),
  KEY `priority_idx` (`priority`),
  KEY `enabled_idx` (`enabled`),
  CONSTRAINT `v_hra_ruleid_ref` FOREIGN KEY (`rule_id`) REFERENCES `voip_header_rules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_hra_rwrset_ref` FOREIGN KEY (`rwr_set_id`) REFERENCES `voip_rewrite_rule_sets` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_header_rule_condition_values` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `condition_id` int(11) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `condition_id_idx` (`condition_id`),
  CONSTRAINT `v_hrcv_conditionid_ref` FOREIGN KEY (`condition_id`) REFERENCES `voip_header_rule_conditions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_header_rule_conditions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(11) unsigned NOT NULL,
  `match_type` enum('header','preference','avp') NOT NULL DEFAULT 'header',
  `match_part` enum('full','username','domain','port') NOT NULL DEFAULT 'full',
  `match_name` varchar(255) NOT NULL,
  `expression` enum('is','contains','matches','regexp') NOT NULL,
  `expression_negation` tinyint(1) NOT NULL DEFAULT 0,
  `value_type` enum('input','preference','avp') NOT NULL,
  `rwr_set_id` int(11) unsigned DEFAULT NULL,
  `rwr_dp_id` int(11) unsigned DEFAULT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `rule_id_idx` (`rule_id`),
  KEY `rwr_set_id_idx` (`rwr_set_id`),
  KEY `rwr_dp_id_idx` (`rwr_dp_id`),
  KEY `enabled_idx` (`enabled`),
  CONSTRAINT `v_hrc_ruleid_ref` FOREIGN KEY (`rule_id`) REFERENCES `voip_header_rules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_hrc_rwrset_ref` FOREIGN KEY (`rwr_set_id`) REFERENCES `voip_rewrite_rule_sets` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_header_rule_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL DEFAULT 1,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `res_name_idx` (`reseller_id`,`name`),
  UNIQUE KEY `vhrs_subscriber_idx` (`subscriber_id`),
  CONSTRAINT `vhrs_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vhrs_subscriber_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_header_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `priority` int(11) unsigned NOT NULL DEFAULT 100,
  `direction` enum('inbound','outbound','local','peer','cf_inbound','cf_outbound','reply') NOT NULL DEFAULT 'inbound',
  `stopper` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `set_name_idx` (`set_id`,`name`),
  KEY `direction_idx` (`direction`),
  KEY `priority_idx` (`priority`),
  KEY `enabled_idx` (`enabled`),
  CONSTRAINT `v_hr_setid_ref` FOREIGN KEY (`set_id`) REFERENCES `voip_header_rule_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_mail_to_fax_acl` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `from_email` varchar(255) DEFAULT NULL,
  `received_from` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `use_regex` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `mtf_acl_sub_idx` (`subscriber_id`),
  KEY `voip_mtf_acl_fe_idx` (`from_email`),
  CONSTRAINT `v_mtf_acl_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_mail_to_fax_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `secret_key` varchar(255) DEFAULT NULL,
  `last_secret_key_modify` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `secret_key_renew` enum('never','daily','weekly','monthly') NOT NULL DEFAULT 'never',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mtf_p_sub_idx` (`subscriber_id`),
  CONSTRAINT `v_mtf_p_subscriber_id_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_mail_to_fax_secret_renew_notify` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `destination` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mtf_srn_subdest_idx` (`subscriber_id`,`destination`),
  CONSTRAINT `v_mtf_secret_renew_notify_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_pbx_autoattendants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `uuid` char(36) NOT NULL,
  `choice` varchar(16) NOT NULL,
  `destination` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uuid_choice_idx` (`uuid`,`choice`),
  KEY `fk_aa_sub_idx` (`subscriber_id`),
  CONSTRAINT `voip_pbx_autoattendant_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_pbx_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriber_idx` (`subscriber_id`),
  KEY `group_idx` (`group_id`),
  CONSTRAINT `fk_v_sub_group` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_peer_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(127) NOT NULL,
  `priority` tinyint(3) NOT NULL DEFAULT 1,
  `description` varchar(255) DEFAULT NULL,
  `peering_contract_id` int(11) unsigned DEFAULT NULL,
  `has_inbound_rules` tinyint(1) NOT NULL DEFAULT 0,
  `time_set_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `vpg_time_set_ref` (`time_set_id`),
  CONSTRAINT `vpg_time_set_ref` FOREIGN KEY (`time_set_id`) REFERENCES `voip_time_sets` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_peer_hosts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL,
  `name` varchar(64) NOT NULL DEFAULT '',
  `ip` varchar(64) NOT NULL,
  `host` varchar(64) DEFAULT NULL,
  `port` int(5) NOT NULL DEFAULT 5060,
  `transport` tinyint(3) unsigned DEFAULT NULL,
  `weight` tinyint(3) NOT NULL DEFAULT 0,
  `via_route` varchar(255) DEFAULT NULL,
  `via_lb` tinyint(1) NOT NULL DEFAULT 0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `probe` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `grpname` (`group_id`,`name`),
  KEY `grpidx` (`group_id`),
  CONSTRAINT `v_ps_groupid_ref` FOREIGN KEY (`group_id`) REFERENCES `voip_peer_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_peer_inbound_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL,
  `field` varchar(255) NOT NULL,
  `pattern` varchar(1023) NOT NULL,
  `reject_code` int(3) DEFAULT NULL,
  `reject_reason` varchar(64) DEFAULT NULL,
  `priority` int(11) unsigned NOT NULL DEFAULT 50,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `grpidx` (`group_id`),
  CONSTRAINT `v_pig_groupid_ref` FOREIGN KEY (`group_id`) REFERENCES `voip_peer_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_peer_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `peer_host_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `peerhostid_idx` (`peer_host_id`),
  KEY `attributeid_idx` (`attribute_id`),
  CONSTRAINT `v_p_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_p_p_peerhostid_ref` FOREIGN KEY (`peer_host_id`) REFERENCES `voip_peer_hosts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_peer_preferences_ibfk_1` FOREIGN KEY (`peer_host_id`) REFERENCES `voip_peer_hosts` (`id`),
  CONSTRAINT `voip_peer_preferences_ibfk_2` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_peer_preferences_blob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `preference_id` int(11) unsigned NOT NULL,
  `content_type` varchar(128) NOT NULL DEFAULT 'application/data',
  `value` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `preference_id` (`preference_id`),
  CONSTRAINT `fk_peer_blob_pref_id` FOREIGN KEY (`preference_id`) REFERENCES `voip_peer_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci `PAGE_COMPRESSED`=1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_peer_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL,
  `callee_prefix` varchar(64) NOT NULL DEFAULT '',
  `callee_pattern` varchar(64) DEFAULT '',
  `caller_pattern` varchar(64) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `stopper` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `grpidx` (`group_id`),
  CONSTRAINT `v_pg_groupid_ref` FOREIGN KEY (`group_id`) REFERENCES `voip_peer_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_preference_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_preference_relations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `voip_preference_id` int(11) unsigned NOT NULL,
  `autoprov_device_id` int(11) unsigned DEFAULT NULL,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `voip_pref_rel_devices` (`voip_preference_id`,`autoprov_device_id`),
  KEY `voip_pref_rel_reselle` (`voip_preference_id`,`reseller_id`),
  KEY `vpid_ref` (`voip_preference_id`),
  KEY `adid_ref` (`autoprov_device_id`),
  KEY `rid_ref` (`reseller_id`),
  CONSTRAINT `adid_ref` FOREIGN KEY (`autoprov_device_id`) REFERENCES `autoprov_devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vpid_ref` FOREIGN KEY (`voip_preference_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `voip_preference_groups_id` int(11) unsigned NOT NULL,
  `attribute` varchar(31) NOT NULL,
  `label` varchar(255) NOT NULL,
  `type` tinyint(3) NOT NULL DEFAULT 0,
  `max_occur` tinyint(3) unsigned NOT NULL,
  `usr_pref` tinyint(1) NOT NULL DEFAULT 0,
  `prof_pref` tinyint(1) NOT NULL DEFAULT 0,
  `dom_pref` tinyint(1) NOT NULL DEFAULT 0,
  `peer_pref` tinyint(1) NOT NULL DEFAULT 0,
  `contract_pref` tinyint(1) NOT NULL DEFAULT 0,
  `contract_location_pref` tinyint(1) NOT NULL DEFAULT 0,
  `dev_pref` tinyint(1) NOT NULL DEFAULT 0,
  `devprof_pref` tinyint(1) NOT NULL DEFAULT 0,
  `fielddev_pref` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `internal` tinyint(1) NOT NULL DEFAULT 0,
  `expose_to_customer` tinyint(1) NOT NULL DEFAULT 0,
  `data_type` enum('boolean','int','string','enum','blob') DEFAULT NULL,
  `read_only` tinyint(1) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `dynamic` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `reseller_pref` tinyint(1) NOT NULL DEFAULT 0,
  `expose_to_subscriber` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_idx` (`attribute`),
  KEY `vpgid_ref` (`voip_preference_groups_id`),
  CONSTRAINT `vpgid_ref` FOREIGN KEY (`voip_preference_groups_id`) REFERENCES `voip_preference_groups` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_preferences_enum` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `preference_id` int(11) unsigned DEFAULT NULL,
  `label` varchar(128) DEFAULT NULL,
  `value` varchar(128) DEFAULT NULL,
  `usr_pref` tinyint(1) DEFAULT 0,
  `prof_pref` tinyint(1) DEFAULT 0,
  `dom_pref` tinyint(1) DEFAULT 0,
  `peer_pref` tinyint(1) DEFAULT 0,
  `contract_pref` tinyint(1) DEFAULT NULL,
  `contract_location_pref` tinyint(1) NOT NULL DEFAULT 0,
  `dev_pref` tinyint(1) NOT NULL DEFAULT 0,
  `devprof_pref` tinyint(1) NOT NULL DEFAULT 0,
  `fielddev_pref` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `default_val` tinyint(1) DEFAULT NULL,
  `reseller_pref` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `preference_id` (`preference_id`),
  CONSTRAINT `voip_preferences_enum_ibfk_1` FOREIGN KEY (`preference_id`) REFERENCES `voip_preferences` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=391 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_prof_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `profidattrid_idx` (`profile_id`,`attribute_id`),
  KEY `profid_idx` (`profile_id`),
  KEY `attrid_idx` (`attribute_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_reminder` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `time` time NOT NULL,
  `recur` enum('never','weekdays','always') NOT NULL DEFAULT 'never',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subscriber_id` (`subscriber_id`),
  KEY `active_time_idx` (`active`,`time`),
  CONSTRAINT `v_rem_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_reseller_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `attributeid_idx` (`attribute_id`),
  KEY `v_r_p_reseller_ref` (`reseller_id`),
  CONSTRAINT `v_r_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_r_p_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_rewrite_rule_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL DEFAULT 1,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `caller_in_dpid` int(11) unsigned DEFAULT NULL,
  `callee_in_dpid` int(11) unsigned DEFAULT NULL,
  `caller_out_dpid` int(11) unsigned DEFAULT NULL,
  `callee_out_dpid` int(11) unsigned DEFAULT NULL,
  `caller_lnp_dpid` int(11) unsigned DEFAULT NULL,
  `callee_lnp_dpid` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_idx` (`name`),
  KEY `vrwrs_reseller_ref` (`reseller_id`),
  CONSTRAINT `vrwrs_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_rewrite_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(11) unsigned NOT NULL,
  `match_pattern` varchar(128) NOT NULL DEFAULT '',
  `replace_pattern` varchar(255) NOT NULL,
  `description` varchar(127) NOT NULL DEFAULT '',
  `direction` enum('in','out','lnp') NOT NULL DEFAULT 'in',
  `field` enum('caller','callee') NOT NULL DEFAULT 'caller',
  `priority` int(11) unsigned NOT NULL DEFAULT 50,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `setidx` (`set_id`),
  KEY `dirfieldidx` (`direction`,`field`),
  CONSTRAINT `v_rwr_setid_ref` FOREIGN KEY (`set_id`) REFERENCES `voip_rewrite_rule_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_rwrs_sequence` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_sound_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(256) DEFAULT NULL,
  `data` longblob DEFAULT NULL,
  `handle_id` int(11) DEFAULT NULL,
  `set_id` int(11) DEFAULT NULL,
  `loopplay` tinyint(1) DEFAULT 0,
  `codec` varchar(16) NOT NULL DEFAULT '',
  `use_parent` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `set_id_ref` (`set_id`),
  KEY `handle_set_id_idx` (`handle_id`,`set_id`),
  CONSTRAINT `handle_id_ref` FOREIGN KEY (`handle_id`) REFERENCES `voip_sound_handles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `set_id_ref` FOREIGN KEY (`set_id`) REFERENCES `voip_sound_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_sound_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_sound_handles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `group_id` int(11) unsigned NOT NULL,
  `expose_to_customer` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `v_s_h_group_ref` (`group_id`),
  CONSTRAINT `v_s_h_group_ref` FOREIGN KEY (`group_id`) REFERENCES `voip_sound_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_sound_set_handle_parents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `set_id` int(11) NOT NULL,
  `handle_id` int(11) NOT NULL,
  `parent_set_id` int(11) DEFAULT NULL,
  `parent_chain` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `handle_id_idx` (`handle_id`),
  KEY `parent_set_id_idx` (`parent_set_id`),
  KEY `set_handle_id_idx` (`set_id`,`handle_id`),
  CONSTRAINT `vshh_handle_id_ref` FOREIGN KEY (`handle_id`) REFERENCES `voip_sound_handles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_sound_sets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL DEFAULT 1,
  `contract_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contract_default` tinyint(1) NOT NULL DEFAULT 0,
  `parent_id` int(11) DEFAULT NULL,
  `expose_to_customer` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `vss_reseller_ref` (`reseller_id`),
  KEY `contract_id_idx` (`contract_id`),
  KEY `parent_id_idx` (`parent_id`),
  KEY `expose_to_customer_idx` (`expose_to_customer`),
  CONSTRAINT `vss_parent_id_ref` FOREIGN KEY (`parent_id`) REFERENCES `voip_sound_sets` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `vss_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `billing`.`resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_speed_dial` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `slot` varchar(64) NOT NULL,
  `destination` varchar(192) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subscriberid_slot_idx` (`subscriber_id`,`slot`),
  CONSTRAINT `v_sd_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_subscriber_location_mappings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `location` varchar(255) NOT NULL,
  `caller_pattern` varchar(255) DEFAULT NULL,
  `callee_pattern` varchar(255) DEFAULT NULL,
  `mode` enum('add','replace','offline','forward') NOT NULL DEFAULT 'replace',
  `to_username` varchar(255) DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `subscriber_id_idx` (`subscriber_id`),
  KEY `external_id_idx` (`external_id`),
  CONSTRAINT `v_subscriber_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_subscriber_profile_attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prof_attr_idx` (`profile_id`,`attribute_id`),
  KEY `attribute_id` (`attribute_id`),
  KEY `profile_idx` (`profile_id`),
  CONSTRAINT `voip_subscriber_profile_attributes_ibfk_1` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_subscriber_profile_attributes_ibfk_2` FOREIGN KEY (`profile_id`) REFERENCES `voip_subscriber_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_subscriber_profile_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vsp_resname_idx` (`reseller_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_subscriber_profiles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `set_default` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `set_name_idx` (`set_id`,`name`),
  CONSTRAINT `voip_subscriber_profile_sets_ibfk_1` FOREIGN KEY (`set_id`) REFERENCES `voip_subscriber_profile_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_subscribers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(127) NOT NULL,
  `domain_id` int(11) unsigned NOT NULL,
  `uuid` char(36) NOT NULL,
  `password` varchar(40) DEFAULT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT 0,
  `account_id` int(11) unsigned DEFAULT NULL,
  `webusername` varchar(127) DEFAULT NULL,
  `webpassword` char(56) DEFAULT NULL,
  `is_pbx_pilot` tinyint(1) NOT NULL DEFAULT 0,
  `is_pbx_group` tinyint(1) NOT NULL DEFAULT 0,
  `pbx_hunt_policy` enum('serial','parallel','random','circular','none') DEFAULT 'none',
  `pbx_hunt_timeout` int(4) unsigned DEFAULT NULL,
  `pbx_hunt_cancel_mode` enum('bye','cancel') DEFAULT 'cancel',
  `pbx_extension` varchar(255) DEFAULT NULL,
  `profile_set_id` int(11) unsigned DEFAULT NULL,
  `profile_id` int(11) unsigned DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_dom_idx` (`username`,`domain_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  UNIQUE KEY `webuser_dom_idx` (`webusername`,`domain_id`),
  KEY `accountid_idx` (`account_id`),
  KEY `domainid_idx` (`domain_id`),
  CONSTRAINT `v_s_domainid_ref` FOREIGN KEY (`domain_id`) REFERENCES `voip_domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_subscribers_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `voip_domains` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_time_periods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `time_set_id` int(11) unsigned NOT NULL,
  `start` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `end` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `freq` enum('secondly','minutely','hourly','daily','weekly','monthly','yearly') DEFAULT NULL,
  `until` timestamp NULL DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `interval` int(11) DEFAULT NULL,
  `bysecond` varchar(45) DEFAULT NULL,
  `byminute` varchar(45) DEFAULT NULL,
  `byhour` varchar(45) DEFAULT NULL,
  `byday` varchar(45) DEFAULT NULL,
  `bymonthday` varchar(45) DEFAULT NULL,
  `byyearday` varchar(45) DEFAULT NULL,
  `byweekno` varchar(45) DEFAULT NULL,
  `bymonth` varchar(45) DEFAULT NULL,
  `bysetpos` varchar(45) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `duration` varchar(45) DEFAULT NULL,
  `wkst` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `v_tp_tsid_ref` (`time_set_id`),
  CONSTRAINT `v_tp_tsid_ref` FOREIGN KEY (`time_set_id`) REFERENCES `voip_time_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_time_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `contract_id` int(11) unsigned DEFAULT NULL,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(90) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `v_ts_rid_idx` (`reseller_id`),
  KEY `v_ts_cid_idx` (`contract_id`),
  KEY `v_ts_sid_ref` (`subscriber_id`),
  CONSTRAINT `v_ts_sid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_trusted_sources` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(10) unsigned NOT NULL,
  `src_ip` varchar(50) NOT NULL,
  `protocol` varchar(4) NOT NULL,
  `from_pattern` varchar(64) DEFAULT NULL,
  `uuid` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `peer_idx` (`src_ip`),
  KEY `subscriber_id_ref` (`subscriber_id`),
  CONSTRAINT `subscriber_id_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_usr_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(128) NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `subidattrid_idx` (`subscriber_id`,`attribute_id`),
  KEY `subscriberid_idx` (`subscriber_id`),
  KEY `attributeid_idx` (`attribute_id`),
  CONSTRAINT `v_u_p_attributeid_ref` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_u_p_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `voip_usr_preferences_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`),
  CONSTRAINT `voip_usr_preferences_ibfk_2` FOREIGN KEY (`attribute_id`) REFERENCES `voip_preferences` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_usr_preferences_blob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `preference_id` int(11) unsigned NOT NULL,
  `content_type` varchar(128) NOT NULL DEFAULT 'application/data',
  `value` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `preference_id` (`preference_id`),
  CONSTRAINT `fk_usr_blob_pref_id` FOREIGN KEY (`preference_id`) REFERENCES `voip_usr_preferences` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci `PAGE_COMPRESSED`=1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmlgroups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gname` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmlhostgroups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned NOT NULL,
  `host_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gidx` (`group_id`),
  KEY `xhg_hostid_ref` (`host_id`),
  CONSTRAINT `xhg_groupid_ref` FOREIGN KEY (`group_id`) REFERENCES `xmlgroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `xhg_hostid_ref` FOREIGN KEY (`host_id`) REFERENCES `xmlhosts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmlhosts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(15) NOT NULL,
  `port` int(5) unsigned NOT NULL,
  `path` varchar(64) NOT NULL DEFAULT '/',
  `sip_port` int(5) unsigned DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xmlqueue` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `target` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `ctime` int(10) unsigned NOT NULL,
  `atime` int(10) unsigned NOT NULL,
  `tries` int(10) unsigned NOT NULL,
  `next_try` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `next_try` (`next_try`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `bin_to_hex`(_bin VARCHAR(1023)
) RETURNS varchar(1023) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  DECLARE _i int DEFAULT 1;
  DECLARE _digits VARCHAR(4);
  DECLARE _result VARCHAR(1023) DEFAULT "";

  digits_loop: LOOP
    SET _digits = SUBSTR(_bin,-4 * _i,4);
    IF LENGTH(_digits) = 0 THEN
      LEAVE digits_loop;
    END IF;
    SET _result = CONCAT(COALESCE(CONV(_digits,2,16),"0"),_result);
    SET _i = _i + 1;
  END LOOP digits_loop;

  RETURN _result;

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `hex_add`(_a VARCHAR(255),
  _b VARCHAR(255)
) RETURNS varchar(256) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  DECLARE _i int DEFAULT 1;
  DECLARE _a_digit, _b_digit VARCHAR(1);
  DECLARE _carry, _result_digit INT DEFAULT 0;
  DECLARE _result VARCHAR(256) DEFAULT "";

  digits_loop: LOOP
    SET _a_digit = SUBSTR(_a, -1 * _i,1);
    SET _b_digit = SUBSTR(_b, -1 * _i,1);
    IF LENGTH(_a_digit) = 0 AND LENGTH(_b_digit) = 0 AND _carry = 0 THEN
      LEAVE digits_loop;
    END IF;
    SET _result_digit = COALESCE(CONV(_a_digit,16,10),0) + COALESCE(CONV(_b_digit,16,10),0) + _carry;
    SET _result = CONCAT(HEX(_result_digit & 15),_result);
    IF _result_digit > 15 THEN
      SET _carry = 1;
    ELSE
      SET _carry = 0;
    END IF;
    SET _i = _i + 1;
  END LOOP digits_loop;

  RETURN _result;

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `hex_and`(_a VARCHAR(255),
  _b VARCHAR(255)
) RETURNS varchar(255) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  DECLARE _i int DEFAULT 1;
  DECLARE _a_digit, _b_digit VARCHAR(1);
  DECLARE _result VARCHAR(255) DEFAULT "";

  digits_loop: LOOP
    SET _a_digit = SUBSTR(_a,_i,1);
    SET _b_digit = SUBSTR(_b,_i,1);
    IF LENGTH(_a_digit) = 0 AND LENGTH(_b_digit) = 0 THEN
      LEAVE digits_loop;
    END IF;
    SET _result = CONCAT(_result,HEX(COALESCE(conv(_a_digit,16,10),0) & COALESCE(CONV(_b_digit,16,10),0)));
    SET _i = _i + 1;
  END LOOP digits_loop;

  RETURN _result;

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `ip_get_broadcast_address`(_ipnet VARCHAR(46)
) RETURNS varbinary(16)
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  DECLARE _network_hex VARCHAR(32);
  DECLARE _broadcast_bytes VARBINARY(16);
  DECLARE _mask_hex VARCHAR(32);
  DECLARE _mask_len INT;

  IF ip_is_cidr(_ipnet) THEN
    SET _mask_len = SUBSTR(_ipnet,LOCATE("/",_ipnet) + 1);
    SET _mask_hex = bin_to_hex(CONCAT(REPEAT("1",_mask_len),REPEAT("0",IF(ip_is_ipv6(_ipnet),128,32) - _mask_len)));
    SET _network_hex = hex_and(
      HEX(INET6_ATON(substr(_ipnet,1,LOCATE("/",_ipnet) - 1))),
      _mask_hex
    );
    SET _broadcast_bytes = UNHEX(hex_add(
      _network_hex,
      bin_to_hex(CONCAT(REPEAT("0",_mask_len),REPEAT("1",IF(ip_is_ipv6(_ipnet),128,32) - _mask_len)))
    ));
  ELSE
    SET _broadcast_bytes = INET6_ATON(_ipnet);
  END IF;

  RETURN _broadcast_bytes;

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `ip_get_network_address`(_ipnet VARCHAR(46)
) RETURNS varbinary(16)
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  DECLARE _network_bytes VARBINARY(16);
  DECLARE _mask_hex VARCHAR(32);
  DECLARE _mask_len INT;

  IF ip_is_cidr(_ipnet) THEN
    SET _mask_len = SUBSTR(_ipnet,LOCATE("/",_ipnet) + 1);
    SET _mask_hex = bin_to_hex(CONCAT(REPEAT("1",_mask_len),REPEAT("0",IF(ip_is_ipv6(_ipnet),128,32) - _mask_len)));
    SET _network_bytes = UNHEX(
      hex_and(
        HEX(INET6_ATON(SUBSTR(_ipnet,1,locate("/",_ipnet) - 1))),
        _mask_hex
      )
    );
  ELSE
    SET _network_bytes = INET6_ATON(_ipnet);
  END IF;

  RETURN _network_bytes;

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `ip_is_allowed`(_uuid VARCHAR(36),
  _ip VARCHAR(46)
) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  DECLARE _network_bytes VARBINARY(16);
  DECLARE _is_valid_ip, _is_ipv6 BOOLEAN DEFAULT 0;
  DECLARE _aig_id, _aig_ids_done INT DEFAULT 0;
  DECLARE _is_allowed BOOLEAN DEFAULT NULL;
  
  DECLARE usr_aig_id_cursor CURSOR FOR SELECT
      v.value
    FROM provisioning.voip_usr_preferences v
    JOIN provisioning.voip_subscribers s on v.subscriber_id = s.id
    JOIN provisioning.voip_preferences a ON v.attribute_id = a.id
    WHERE
      s.uuid = _uuid
      AND a.attribute IN ("man_allowed_ips_grp","allowed_ips_grp");

  DECLARE dom_aig_id_cursor CURSOR FOR SELECT
      v.value
    FROM provisioning.voip_dom_preferences v
    JOIN provisioning.voip_subscribers s on v.domain_id = s.domain_id
    JOIN provisioning.voip_preferences a ON v.attribute_id = a.id
    WHERE
      s.uuid = _uuid
      AND a.attribute IN ("man_allowed_ips_grp","allowed_ips_grp");

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET _aig_ids_done = _aig_ids_done + 1;

  IF IF(EXISTS(SELECT 1 FROM provisioning.voip_subscribers WHERE uuid = _uuid),0,1) THEN
    
    RETURN 0;
  END IF;

  SET _network_bytes = INET6_ATON(_ip);
  SET _is_valid_ip = IF(_network_bytes IS NULL OR HEX(_network_bytes) = "00000000",0,1);
  SET _is_ipv6 = IF(_is_valid_ip,ip_is_ipv6(_ip),0);

  OPEN usr_aig_id_cursor;
  aig_ids_loop: LOOP
    IF _aig_ids_done = 0 THEN
      FETCH usr_aig_id_cursor INTO _aig_id;
      IF _aig_ids_done = 1 THEN
        CLOSE usr_aig_id_cursor;
        IF _is_allowed IS NOT NULL THEN
          RETURN _is_allowed;
        ELSE
          SET _is_allowed = NULL;
          OPEN dom_aig_id_cursor;
        END IF;
      END IF;
    END IF;
    IF _aig_ids_done = 1 THEN
      FETCH dom_aig_id_cursor INTO _aig_id;
      IF _aig_ids_done = 2 THEN
        CLOSE dom_aig_id_cursor;
        IF _is_allowed IS NOT NULL THEN
          RETURN _is_allowed;
        ELSE
          LEAVE aig_ids_loop;
        END IF;
      END IF;
    END IF;
    IF _is_allowed IS NULL THEN
      SET _is_allowed = 0;
    END IF;
    IF _is_valid_ip THEN
      IF _is_ipv6 THEN
        SET _is_allowed = IF(_is_allowed,1,COALESCE((SELECT 1
          FROM provisioning.voip_allowed_ip_groups aig
          WHERE
            aig.group_id = _aig_id 
            AND aig._ipv6_net_from <= _network_bytes
            AND aig._ipv6_net_to >= _network_bytes
        LIMIT 1),0));
      ELSE
        SET _is_allowed = IF(_is_allowed,1,COALESCE((SELECT 1
          FROM provisioning.voip_allowed_ip_groups aig
          WHERE
            aig.group_id = _aig_id 
            AND aig._ipv4_net_from <= _network_bytes
            AND aig._ipv4_net_to >= _network_bytes
        LIMIT 1),0));
      END IF;
    ELSE
      
      RETURN 0;
    END IF;
  END LOOP aig_ids_loop;
  
  
  RETURN 1;

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `ip_is_cidr`(_ipnet VARCHAR(46)
) RETURNS tinyint(1)
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  RETURN IF(LOCATE("/",_ipnet) = 0,0,1);

END ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `ip_is_ipv6`(_ipnet VARCHAR(46)
) RETURNS tinyint(1)
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN

  RETURN IF(LOCATE(".",_ipnet) = 0,1,0);

END ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_sound_set_handle_parents`(IN u_sound_set_id INT, IN u_handle_id INT)
BEGIN
    IF u_sound_set_id IS NOT NULL THEN
        DELETE p FROM voip_sound_set_handle_parents p
         WHERE set_id = u_sound_set_id
           AND NOT EXISTS (SELECT id
                             FROM voip_sound_sets
                            WHERE id = u_sound_set_id);

        IF u_handle_id IS NOT NULL THEN
            DELETE p FROM voip_sound_set_handle_parents p
             WHERE set_id IN (
                WITH RECURSIVE cte as (
                    SELECT s.id
                      FROM voip_sound_sets s
                     WHERE id = u_sound_set_id
                    UNION
                    SELECT s.id
                      FROM voip_sound_sets s
                      JOIN cte ON cte.id = s.parent_id
                )
                SELECT id
                  FROM cte
             )
               AND handle_id = u_handle_id;

            INSERT INTO voip_sound_set_handle_parents(set_id, handle_id, parent_set_id, parent_chain)
            WITH RECURSIVE cte as (
                SELECT v.id AS set_id, v.handle_id,
                           v.id AS data_set_id,
                           CAST('' AS CHAR(4096)) AS parent_chain,
                           CAST(0 as unsigned) AS affected
                  FROM (SELECT s.*, h.id as handle_id
                          FROM (voip_sound_sets s, voip_sound_handles h)
                       ) AS v
                  LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                 WHERE v.id = (
                    WITH RECURSIVE cte as (
                        SELECT s.id, s.parent_id, CAST(0 as unsigned) as iter
                          FROM voip_sound_sets s
                         WHERE id = u_sound_set_id
                        UNION
                        SELECT s.id, s.parent_id, iter+1 as iter
                          FROM voip_sound_sets s
                          JOIN cte ON cte.parent_id = s.id
                    )
                    SELECT id
                      FROM cte
                     WHERE iter = (SELECT max(iter) from cte)
                 )
                   AND v.handle_id = u_handle_id
                 UNION
                SELECT v.id AS set_id, v.handle_id,
                       IF(f.use_parent = 0, v.id, cte.data_set_id) AS data_set_id,
                       CONCAT(v.parent_id, IF(LENGTH(cte.parent_chain) > 1, ':', ''), cte.parent_chain) as parent_chain,
                       IF(v.id = u_sound_set_id OR v.parent_id = u_sound_set_id OR affected = 1, 1, 0)
                  FROM (SELECT s.*, h.id as handle_id, h.name as handle_name
                        FROM (voip_sound_sets s, voip_sound_handles h)
                       ) AS v
                  LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                  JOIN cte ON cte.set_id = v.parent_id AND cte.handle_id = v.handle_id
            )
            SELECT set_id, handle_id,
                   IF(data_set_id = set_id, NULL, data_set_id) as data_set_id,
                   parent_chain
              FROM cte
             WHERE set_id = u_sound_set_id OR affected = 1;
        ELSE
            DELETE p FROM voip_sound_set_handle_parents p
             WHERE set_id IN (
                WITH RECURSIVE cte as (
                    SELECT s.id
                      FROM voip_sound_sets s
                     WHERE id = u_sound_set_id
                    UNION
                    SELECT s.id
                      FROM voip_sound_sets s
                      JOIN cte ON cte.id = s.parent_id
                )
                SELECT id
                  FROM cte
             );

            INSERT INTO voip_sound_set_handle_parents(set_id, handle_id, parent_set_id, parent_chain)
            WITH RECURSIVE cte as (
                SELECT v.id AS set_id, v.handle_id,
                           v.id AS data_set_id,
                           CAST('' AS CHAR(4096)) AS parent_chain,
                           CAST(0 as unsigned) AS affected
                  FROM (SELECT s.*, h.id as handle_id
                          FROM (voip_sound_sets s, voip_sound_handles h)
                       ) AS v
                  LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                 WHERE v.id = (
                    WITH RECURSIVE cte as (
                        SELECT s.id, s.parent_id, CAST(0 as unsigned) as iter
                          FROM voip_sound_sets s
                         WHERE id = u_sound_set_id
                        UNION
                        SELECT s.id, s.parent_id, iter+1 as iter
                          FROM voip_sound_sets s
                          JOIN cte ON cte.parent_id = s.id
                    )
                    SELECT id
                      FROM cte
                     WHERE iter = (SELECT max(iter) from cte)
                 )
                 UNION
                SELECT v.id AS set_id, v.handle_id,
                       IF(f.use_parent = 0, v.id, cte.data_set_id) AS data_set_id,
                       CONCAT(v.parent_id, IF(LENGTH(cte.parent_chain) > 1, ':', ''), cte.parent_chain) as parent_chain,
                       IF(v.id = u_sound_set_id OR v.parent_id = u_sound_set_id OR affected = 1, 1, 0)
                  FROM (SELECT s.*, h.id as handle_id, h.name as handle_name
                        FROM (voip_sound_sets s, voip_sound_handles h)
                       ) AS v
                  LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                  JOIN cte ON cte.set_id = v.parent_id AND cte.handle_id = v.handle_id
            )
            SELECT set_id, handle_id,
                   IF(data_set_id = set_id, NULL, data_set_id) as data_set_id,
                   parent_chain
              FROM cte
             WHERE set_id = u_sound_set_id OR affected = 1;
        END IF;
    ELSE
        IF u_handle_id IS NOT NULL THEN
            DELETE FROM voip_sound_set_handle_parents WHERE handle_id = u_handle_id;

            INSERT INTO voip_sound_set_handle_parents(set_id, handle_id, parent_set_id, parent_chain)
            WITH RECURSIVE cte as (
                    SELECT v.id AS set_id, v.handle_id,
                           v.id AS data_set_id,
                           CAST('' AS CHAR(4096)) AS parent_chain
                      FROM (SELECT s.*, h.id as handle_id
                            FROM (voip_sound_sets s, voip_sound_handles h)
                           ) AS v
                      LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                     WHERE v.parent_id IS NULL
                       AND v.handle_id = u_handle_id
                     UNION
                    SELECT v.id AS set_id, v.handle_id,
                           IF(f.use_parent = 0, v.id, cte.data_set_id) AS data_set_id,
                           CONCAT(v.parent_id, IF(LENGTH(cte.parent_chain) > 1, ':', ''), cte.parent_chain) as parent_chain
                      FROM (SELECT s.*, h.id as handle_id, h.name as handle_name
                            FROM (voip_sound_sets s, voip_sound_handles h)
                           ) AS v
                      LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                      JOIN cte ON cte.set_id = v.parent_id AND cte.handle_id = v.handle_id
            )
            SELECT set_id, handle_id,
                   IF(data_set_id = set_id, NULL, data_set_id) as data_set_id,
                   parent_chain
              FROM cte;
        ELSE
            DELETE FROM voip_sound_set_handle_parents;

            INSERT INTO voip_sound_set_handle_parents(set_id, handle_id, parent_set_id, parent_chain)
            WITH RECURSIVE cte as (
                    SELECT v.id AS set_id, v.handle_id,
                           v.id AS data_set_id,
                           CAST('' AS CHAR(4096)) AS parent_chain
                      FROM (SELECT s.*, h.id as handle_id
                            FROM (voip_sound_sets s, voip_sound_handles h)
                           ) AS v
                      LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                     WHERE v.parent_id IS NULL
                     UNION
                    SELECT v.id AS set_id, v.handle_id,
                           IF(f.use_parent = 0, v.id, cte.data_set_id) AS data_set_id,
                           CONCAT(v.parent_id, IF(LENGTH(cte.parent_chain) > 1, ':', ''), cte.parent_chain) as parent_chain
                      FROM (SELECT s.*, h.id as handle_id, h.name as handle_name
                            FROM (voip_sound_sets s, voip_sound_handles h)
                           ) AS v
                      LEFT JOIN voip_sound_files f ON f.handle_id = v.handle_id AND f.set_id = v.id
                      JOIN cte ON cte.set_id = v.parent_id AND cte.handle_id = v.handle_id
            )
            SELECT set_id, handle_id,
                   IF(data_set_id = set_id, NULL, data_set_id) as data_set_id,
                   parent_chain
              FROM cte;
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50001 DROP VIEW IF EXISTS `v_sound_set_files`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sound_set_files` AS select `r`.`set_id` AS `set_id`,`s`.`reseller_id` AS `reseller_id`,`s`.`contract_id` AS `contract_id`,`s`.`name` AS `name`,`s`.`description` AS `description`,`r`.`handle_id` AS `handle_id`,`h`.`name` AS `handle_name`,if(`r`.`parent_set_id` is not null,`vsf_p`.`id`,`vsf`.`id`) AS `file_id`,if(`r`.`parent_set_id` is not null,`vsf_p`.`filename`,`vsf`.`filename`) AS `filename`,if(`r`.`parent_set_id` is not null,`vsf_p`.`loopplay`,`vsf`.`loopplay`) AS `loopplay`,replace(replace(replace(json_remove(`r`.`parent_chain`,'$[0]'),'[',''),']',''),', ',':') AS `parent_chain`,`r`.`parent_set_id` AS `data_set_id`,if(`r`.`parent_set_id` is not null,`vsf_p`.`data`,`vsf`.`data`) AS `data` from ((((`voip_sound_set_handle_parents` `r` join `voip_sound_sets` `s` on(`s`.`id` = `r`.`set_id`)) join `voip_sound_handles` `h` on(`h`.`id` = `r`.`handle_id`)) left join `voip_sound_files` `vsf` on(`vsf`.`set_id` = `r`.`set_id` and `vsf`.`handle_id` = `r`.`handle_id`)) left join `voip_sound_files` `vsf_p` on(`vsf_p`.`set_id` = `r`.`parent_set_id` and `vsf_p`.`handle_id` = `r`.`handle_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_subscriber_cfs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_subscriber_cfs` AS select `cfm`.`id` AS `id`,`vs`.`uuid` AS `uuid`,`cfm`.`type` AS `cf_type`,`cfm`.`subscriber_id` AS `subscriber_id`,`cfss`.`name` AS `source_name`,`cfss`.`mode` AS `source_mode`,`cfss`.`is_regex` AS `source_is_regex`,`cfs`.`source` AS `source`,`cfds`.`name` AS `destination_name`,`cfd`.`destination` AS `destination`,`cfd`.`priority` AS `priority`,`cfd`.`timeout` AS `timeout`,`cfd`.`announcement_id` AS `announcement_id`,`cfbs`.`name` AS `bnumber_name`,`cfbs`.`mode` AS `bnumber_mode`,`cfbs`.`is_regex` AS `bnumber_is_regex`,`cfb`.`bnumber` AS `bnumber`,`cfts`.`name` AS `time_name`,`cft`.`year` AS `year`,`cft`.`month` AS `month`,`cft`.`mday` AS `mday`,`cft`.`wday` AS `wday`,`cft`.`hour` AS `hour`,`cft`.`minute` AS `minute` from ((((((((`voip_cf_destinations` `cfd` left join (`voip_cf_destination_sets` `cfds` left join `voip_cf_mappings` `cfm` on(`cfm`.`destination_set_id` = `cfds`.`id`)) on(`cfd`.`destination_set_id` = `cfds`.`id`)) left join `voip_cf_source_sets` `cfss` on(`cfm`.`source_set_id` = `cfss`.`id`)) left join `voip_cf_sources` `cfs` on(`cfs`.`source_set_id` = `cfss`.`id`)) left join `voip_cf_bnumber_sets` `cfbs` on(`cfm`.`bnumber_set_id` = `cfbs`.`id`)) left join `voip_cf_bnumbers` `cfb` on(`cfb`.`bnumber_set_id` = `cfbs`.`id`)) left join `voip_cf_time_sets` `cfts` on(`cfm`.`time_set_id` = `cfts`.`id`)) left join `voip_cf_periods` `cft` on(`cft`.`time_set_id` = `cfts`.`id`)) left join `voip_subscribers` `vs` on(`vs`.`id` = `cfm`.`subscriber_id`)) where `cfm`.`enabled` = 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_time_periods_ical`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_time_periods_ical` AS select `p`.`id` AS `id`,`p`.`time_set_id` AS `time_set_id`,`p`.`start` AS `start`,`p`.`end` AS `end`,`p`.`comment` AS `comment`,concat('DTSTART:',date_format(`p`.`start`,'%Y%m%dT%H%i%s'),'\n',ifnull(concat('RRULE:','FREQ=',`p`.`freq`,ifnull(concat(';COUNT=',`p`.`count`),''),ifnull(concat(';UNTIL=',date_format(`p`.`until`,'%Y%m%dT%H%i%s')),''),ifnull(concat(';INTERVAL=',`p`.`interval`),''),ifnull(concat(';BYSECOND=',`p`.`bysecond`),''),ifnull(concat(';BYMINUTE=',`p`.`byminute`),''),ifnull(concat(';BYHOUR=',`p`.`byhour`),''),ifnull(concat(';BYDAY=',`p`.`byday`),''),ifnull(concat(';BYMONTHDAY=',`p`.`bymonthday`),''),ifnull(concat(';BYYEARDAY=',`p`.`byyearday`),''),ifnull(concat(';BYWEEKNO=',`p`.`byweekno`),''),ifnull(concat(';BYMONTH=',`p`.`bymonth`),''),ifnull(concat(';BYSETPOS=',`p`.`bysetpos`),''),ifnull(concat(';WKST=',`p`.`wkst`),'')),'')) AS `rrule_ical`,concat('BEGIN:VEVENT\n','UID:','sipwise',`p`.`id`,'@sipwise',`s`.`id`,'\n','SUMMARY:',`s`.`name`,' event ',`p`.`id`,'\n','DTSTART:',date_format(`p`.`start`,'%Y%m%dT%H%i%s'),'\n',if(year(`p`.`end`) <> '0000',concat('DTEND:',date_format(`p`.`end`,'%Y%m%dT%H%i%s'),'\n'),''),ifnull(concat('DURATION:',`p`.`duration`,'\n'),''),ifnull(concat('RRULE:','FREQ=',`p`.`freq`,ifnull(concat(';COUNT=',`p`.`count`),''),ifnull(concat(';UNTIL=',date_format(`p`.`until`,'%Y%m%dT%H%i%s')),''),ifnull(concat(';INTERVAL=',`p`.`interval`),''),ifnull(concat(';BYSECOND=',`p`.`bysecond`),''),ifnull(concat(';BYMINUTE=',`p`.`byminute`),''),ifnull(concat(';BYHOUR=',`p`.`byhour`),''),ifnull(concat(';BYDAY=',`p`.`byday`),''),ifnull(concat(';BYMONTHDAY=',`p`.`bymonthday`),''),ifnull(concat(';BYYEARDAY=',`p`.`byyearday`),''),ifnull(concat(';BYWEEKNO=',`p`.`byweekno`),''),ifnull(concat(';BYMONTH=',`p`.`bymonth`),''),ifnull(concat(';BYSETPOS=',`p`.`bysetpos`),''),ifnull(concat(';WKST=',`p`.`wkst`),''),'\n'),''),ifnull(concat('DESCRIPTION:',`p`.`comment`,'\n'),''),'END:VEVENT\n') AS `event_ical` from (`voip_time_sets` `s` join `voip_time_periods` `p` on(`s`.`id` = `p`.`time_set_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_time_sets_ical`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_time_sets_ical` AS select `s`.`id` AS `id`,`s`.`name` AS `name`,concat('BEGIN:VCALENDAR\n','PRODID:-//Mozilla.org/NONSGML Mozilla Calendar V1.1//EN\n',ifnull(concat('NAME:',`s`.`name`,'\n'),''),'VERSION:2.0\n\n',group_concat(`p`.`event_ical` separator '\n'),'END:VCALENDAR\n') AS `ical` from (`voip_time_sets` `s` left join `v_time_periods_ical` `p` on(`s`.`id` = `p`.`time_set_id`)) group by `s`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
INSERT INTO `autoprov_sync_parameters` VALUES (1,'http','sync_uri','');
INSERT INTO `autoprov_sync_parameters` VALUES (2,'http','sync_params','');
INSERT INTO `autoprov_sync_parameters` VALUES (3,'http','sync_method','/^(?:GET|POST)$/i');
INSERT INTO `autoprov_sync_parameters` VALUES (4,'http','security_handler','');
INSERT INTO `autoprov_sync_parameters` VALUES (5,'redirect_grandstream','cid','');
INSERT INTO `autoprov_sync_parameters` VALUES (6,'redirect_grandstream','key','');
INSERT INTO `autoprov_sync_parameters` VALUES (7,'redirect_polycom','profile','');
INSERT INTO `autoprov_sync_parameters` VALUES (8,'redirect_snom','profile','');
INSERT INTO `autoprov_sync_parameters` VALUES (9,'redirect_snom','product_family','');
INSERT INTO `language_strings` VALUES (1,'Client.Billing.MalformedAmount','de','Bitte geben Sie einen ganzzahligen Betrag ein.');
INSERT INTO `language_strings` VALUES (2,'Client.Billing.MalformedAmount','en','Please specify the amount as an integral number.');
INSERT INTO `language_strings` VALUES (3,'Client.Billing.MalformedAmount','es','Por favor, especifique la cantidad como un número entero.');
INSERT INTO `language_strings` VALUES (4,'Client.Billing.MalformedAmount','fr','Spécifiez la quantité comme un numéro intégral.');
INSERT INTO `language_strings` VALUES (5,'Client.Billing.NoPayType','de','Bitte wählen Sie eine Zahlungsweise aus.');
INSERT INTO `language_strings` VALUES (6,'Client.Billing.NoPayType','en','Please choose a payment type.');
INSERT INTO `language_strings` VALUES (7,'Client.Billing.NoPayType','es','Por favor, elija un método de pago.');
INSERT INTO `language_strings` VALUES (8,'Client.Billing.NoPayType','fr','Choisissez un type de paiement.');
INSERT INTO `language_strings` VALUES (9,'Client.Syntax.Date','de','Bitte geben Sie ein gültiges Datum ein.');
INSERT INTO `language_strings` VALUES (10,'Client.Syntax.Date','en','Invalid date format.');
INSERT INTO `language_strings` VALUES (11,'Client.Syntax.Date','es','Formato de fecha inválido.');
INSERT INTO `language_strings` VALUES (12,'Client.Syntax.Date','fr','Format date invalide.');
INSERT INTO `language_strings` VALUES (13,'Client.Syntax.Email','de','Ungültige E-Mail Adresse.');
INSERT INTO `language_strings` VALUES (14,'Client.Syntax.Email','en','Invalid e-mail address.');
INSERT INTO `language_strings` VALUES (15,'Client.Syntax.Email','es','Dirección de correo inválida.');
INSERT INTO `language_strings` VALUES (16,'Client.Syntax.Email','fr','Adresse électronique Invalide.');
INSERT INTO `language_strings` VALUES (17,'Client.Syntax.MalformedDomain','de','Ungültige Zeichen in der Domain.');
INSERT INTO `language_strings` VALUES (18,'Client.Syntax.MalformedDomain','en','Invalid characters in domain.');
INSERT INTO `language_strings` VALUES (19,'Client.Syntax.MalformedDomain','es','Caracteres inválidos en dominio.');
INSERT INTO `language_strings` VALUES (20,'Client.Syntax.MalformedDomain','fr','Caractères Invalides dans domaine.');
INSERT INTO `language_strings` VALUES (21,'Client.Syntax.MalformedUsername','de','Ungültige Zeichen im Usernamen.');
INSERT INTO `language_strings` VALUES (22,'Client.Syntax.MalformedUsername','en','Invalid characters in username.');
INSERT INTO `language_strings` VALUES (23,'Client.Syntax.MalformedUsername','es','Caracteres inválidos en el nombre de usuario.');
INSERT INTO `language_strings` VALUES (24,'Client.Syntax.MalformedUsername','fr','Nom d\'utilisateur Invalides.');
INSERT INTO `language_strings` VALUES (25,'Client.Syntax.MissingDomain','de','Bitte geben Sie Ihren Usernamen inklusive Domain ein.');
INSERT INTO `language_strings` VALUES (26,'Client.Syntax.MissingDomain','en','Please enter username including domain.');
INSERT INTO `language_strings` VALUES (27,'Client.Syntax.MissingDomain','es','Por favor, introduzca el nombre de usuario incluyendo el dominio.');
INSERT INTO `language_strings` VALUES (28,'Client.Syntax.MissingDomain','fr','Entrez nom d\'utilisateur incluant le domaine.');
INSERT INTO `language_strings` VALUES (29,'Client.Syntax.MissingParam','en','A mandatory parameter is missing.');
INSERT INTO `language_strings` VALUES (30,'Client.Syntax.MissingParam','de','Ein verplichtender Parameter fehlt.');
INSERT INTO `language_strings` VALUES (31,'Client.Syntax.MissingParam','es','Falta un campo obligatorio.');
INSERT INTO `language_strings` VALUES (32,'Client.Syntax.MissingParam','fr','Il manque un paramètre obligatoire.');
INSERT INTO `language_strings` VALUES (33,'Client.Syntax.MalformedUri','en','Invalid SIP URI.');
INSERT INTO `language_strings` VALUES (34,'Client.Syntax.MalformedUri','de','Ungültige SIP URI.');
INSERT INTO `language_strings` VALUES (35,'Client.Syntax.MalformedUri','es','Caracteres inválidos en el URI SIP.');
INSERT INTO `language_strings` VALUES (36,'Client.Syntax.MalformedUri','fr','SIP URI Invalides.');
INSERT INTO `language_strings` VALUES (37,'Client.Syntax.MissingUsername','de','Bitte geben Sie einen Usernamen ein.');
INSERT INTO `language_strings` VALUES (38,'Client.Syntax.MissingUsername','en','Please enter a username.');
INSERT INTO `language_strings` VALUES (39,'Client.Syntax.MissingUsername','es','Por favor,introduzca un nombre de usuario.');
INSERT INTO `language_strings` VALUES (40,'Client.Syntax.MissingUsername','fr','Entrez un nom d\'utilisateur.');
INSERT INTO `language_strings` VALUES (41,'Client.Syntax.VoiceBoxPin','de','Bitte geben Sie 4 Ziffern ein oder lassen Sie das Feld leer.');
INSERT INTO `language_strings` VALUES (42,'Client.Syntax.VoiceBoxPin','en','Please enter 4 digits, or leave the textfield empty.');
INSERT INTO `language_strings` VALUES (43,'Client.Syntax.VoiceBoxPin','es','Por favor, introduzca 4 dígitos o deje el campo en blanco.');
INSERT INTO `language_strings` VALUES (44,'Client.Syntax.VoiceBoxPin','fr','Entrez 4 chiffres, ou laissez le champ texte vide.');
INSERT INTO `language_strings` VALUES (45,'Client.Voip.AssignedExtension','de','Die gewählte Durchwahl ist bereits vergeben.');
INSERT INTO `language_strings` VALUES (46,'Client.Voip.AssignedExtension','en','This extension is already in use.');
INSERT INTO `language_strings` VALUES (47,'Client.Voip.AssignedExtension','es','Esta extensión ya se encuentra en uso.');
INSERT INTO `language_strings` VALUES (48,'Client.Voip.AssignedExtension','fr','Cette extension est déjà utilisée.');
INSERT INTO `language_strings` VALUES (49,'Client.Voip.AssignedNumber','de','Die Telefonnummer ist nicht mehr verfügbar.');
INSERT INTO `language_strings` VALUES (50,'Client.Voip.AssignedNumber','en','The specified telephone number is not available any more.');
INSERT INTO `language_strings` VALUES (51,'Client.Voip.AssignedNumber','es','Este número ya no se encuentra disponible.');
INSERT INTO `language_strings` VALUES (52,'Client.Voip.AssignedNumber','fr','Le numéro de téléphone indiqué n\'est désormais plus disponible.');
INSERT INTO `language_strings` VALUES (53,'Client.Voip.AuthFailed','de','Login fehlgeschlagen, bitte überprüfen Sie Ihren Usernamen und Ihr Passwort.');
INSERT INTO `language_strings` VALUES (54,'Client.Voip.AuthFailed','en','Login failed, please verify username and password.');
INSERT INTO `language_strings` VALUES (55,'Client.Voip.AuthFailed','es','Acceso denegado. Por favor, compruebe el nombre de usuario y la contraseña.');
INSERT INTO `language_strings` VALUES (56,'Client.Voip.AuthFailed','fr','L\'établissement de la connexion a échoué, vérifiez le nom d’utilisateur et le mot de passe.');
INSERT INTO `language_strings` VALUES (57,'Client.Voip.ChooseNumber','de','Bitte wählen Sie eine Nummer aus der Liste.');
INSERT INTO `language_strings` VALUES (58,'Client.Voip.ChooseNumber','en','Please select a number from the list.');
INSERT INTO `language_strings` VALUES (59,'Client.Voip.ChooseNumber','es','Por favor, seleccione un número de la lista.');
INSERT INTO `language_strings` VALUES (60,'Client.Voip.ChooseNumber','fr','Choisissez s\'il vous plaît un numéro de la liste.');
INSERT INTO `language_strings` VALUES (61,'Client.Voip.DeniedNumber','de','Die Telefonnummer ist nicht mehr verfügbar.');
INSERT INTO `language_strings` VALUES (62,'Client.Voip.DeniedNumber','en','The specified telephonenumber is not available.');
INSERT INTO `language_strings` VALUES (63,'Client.Voip.DeniedNumber','es','Este número no se encuentra disponible.');
INSERT INTO `language_strings` VALUES (64,'Client.Voip.DeniedNumber','fr','Le numéro de téléphone indiqué n\'est pas disponible.');
INSERT INTO `language_strings` VALUES (65,'Client.Voip.ExistingSubscriber','de','Dieser Username ist nicht mehr verfügbar.');
INSERT INTO `language_strings` VALUES (66,'Client.Voip.ExistingSubscriber','en','This username is already in use.');
INSERT INTO `language_strings` VALUES (67,'Client.Voip.ExistingSubscriber','es','El nombre de usuario ya se encuentra en uso.');
INSERT INTO `language_strings` VALUES (68,'Client.Voip.ExistingSubscriber','fr','Ce nom d\'utilisateur est déjà utilisé');
INSERT INTO `language_strings` VALUES (69,'Client.Voip.ForwardSelect','de','Bitte wählen Sie unter welchen Umständen ein Anruf weitergeleitet werden soll.');
INSERT INTO `language_strings` VALUES (70,'Client.Voip.ForwardSelect','en','Please select when to forward a call.');
INSERT INTO `language_strings` VALUES (71,'Client.Voip.ForwardSelect','es','Por favor, seleccione cuándo desea reenviar llamadas.');
INSERT INTO `language_strings` VALUES (72,'Client.Voip.ForwardSelect','fr','Choisissez quand transféré un appel.');
INSERT INTO `language_strings` VALUES (73,'Client.Voip.IncorrectPass','de','Das Passwort ist nicht korrekt, bitte überprüfen Sie die Eingabe.');
INSERT INTO `language_strings` VALUES (74,'Client.Voip.IncorrectPass','en','Wrong password, please verify your input.');
INSERT INTO `language_strings` VALUES (75,'Client.Voip.IncorrectPass','es','Contraseña incorrecta. Por favor, verifique que la ha escrito correctamente.');
INSERT INTO `language_strings` VALUES (76,'Client.Voip.IncorrectPass','fr','Mauvais mot de passe, vérifiez votre saisie.');
INSERT INTO `language_strings` VALUES (77,'Client.Voip.InputErrorFound','de','Fehlende oder fehlerhafte Eingabedaten gefunden.');
INSERT INTO `language_strings` VALUES (78,'Client.Voip.InputErrorFound','en','Missing or invalid input found.');
INSERT INTO `language_strings` VALUES (79,'Client.Voip.InputErrorFound','es','Entrada inválida o ausente.');
INSERT INTO `language_strings` VALUES (80,'Client.Voip.InputErrorFound','fr','La saisie trouvée est invalide.');
INSERT INTO `language_strings` VALUES (81,'Client.Voip.MalformedAc','de','Ungültige Ortsvorwahl, bitte geben Sie nur Ziffern, ohne führende Null ein.');
INSERT INTO `language_strings` VALUES (82,'Client.Voip.MalformedAc','en','Invalid area code, please use digits only and don\'t enter a leading zero.');
INSERT INTO `language_strings` VALUES (83,'Client.Voip.MalformedAc','es','Código de área erroneo. Por favor, use dígitos únicamente y no introduzca un cero inicial.');
INSERT INTO `language_strings` VALUES (84,'Client.Voip.MalformedAc','fr','L\'indicatif invalide, utilisez uniquement des chiffres et n\'entrez pas dans un zéro principal.');
INSERT INTO `language_strings` VALUES (85,'Client.Voip.MalformedCc','de','Ungültige Ländervorwahl, bitte geben Sie nur Ziffern, ohne führende Nullen ein.');
INSERT INTO `language_strings` VALUES (86,'Client.Voip.MalformedCc','en','Invalid country code, please use digits only, without leading zeros.');
INSERT INTO `language_strings` VALUES (87,'Client.Voip.MalformedCc','es','Código de país erroneo. Por favor, use dígitos únicamente y no introduzca un cero inicial.');
INSERT INTO `language_strings` VALUES (88,'Client.Voip.MalformedCc','fr','Le code du pays est invalide, utilisez uniquement des chiffres, sans zéros principaux.');
INSERT INTO `language_strings` VALUES (89,'Client.Voip.MalformedSn','de','Ungültige Rufnummer, bitte geben Sie nur Ziffern ein. (Die Nummer darf nicht mit Null beginnen.)');
INSERT INTO `language_strings` VALUES (90,'Client.Voip.MalformedSn','en','Invalid subscriber number, please use digits only. (The number can not start with a zero.)');
INSERT INTO `language_strings` VALUES (91,'Client.Voip.MalformedSn','es','Número de suscriptor inválido. Por favor, use dígitos unicamente. (El número no puede empezar por cero).');
INSERT INTO `language_strings` VALUES (92,'Client.Voip.MalformedSn','fr','Le numéro de l\'abonné est invalide, utilisez uniquement des chiffres. (Le numéro ne peut pas commencer par un zéro).');
INSERT INTO `language_strings` VALUES (93,'Client.Voip.MalformedNumber','de','Ungültige Eingabe, bitte geben Sie Rufnummern numerisch und inklusive Vorwahl an.');
INSERT INTO `language_strings` VALUES (94,'Client.Voip.MalformedNumber','en','Invalid number, please use digits only and include the area code.');
INSERT INTO `language_strings` VALUES (95,'Client.Voip.MalformedNumber','es','Número inválido. Por favor, use dígitos únicamente e incluya el código de área.');
INSERT INTO `language_strings` VALUES (96,'Client.Voip.MalformedNumber','fr','Le numéro est invalide, utilisez uniquement des chiffres et incluez l\'indicatif.');
INSERT INTO `language_strings` VALUES (97,'Client.Voip.MalformedNumberPattern','de','Ungültiger Eintrag, bitte verwenden Sie nur Ziffern und \"?\" bzw. \"*\" als Platzhalter für ein, bzw. beliebig viele Zeichen.');
INSERT INTO `language_strings` VALUES (98,'Client.Voip.MalformedNumberPattern','en','Invalid entry, please use numbers only and \"?\" or \"*\" as placeholder for one or an arbitrary number of digits.');
INSERT INTO `language_strings` VALUES (99,'Client.Voip.MalformedNumberPattern','es','Entrada inválida. Por favor, use dígitos únicamente y \"?\" o \"*\" como comodines para uno o un número arbitrario de dígitos.');
INSERT INTO `language_strings` VALUES (100,'Client.Voip.MalformedNumberPattern','fr','Saisie invalide, utilisez uniquement des numéros et \"?\" Ou \"*\" comme détenteur d’endroit pour un ou un numéro arbitraire de chiffres.');
INSERT INTO `language_strings` VALUES (101,'Client.Voip.MalformedTargetClass','de','Bitte wählen Sie ein Ziel.');
INSERT INTO `language_strings` VALUES (102,'Client.Voip.MalformedTargetClass','en','Please choose a target.');
INSERT INTO `language_strings` VALUES (103,'Client.Voip.MalformedTargetClass','es','Por favor, escoja un objetivo.');
INSERT INTO `language_strings` VALUES (104,'Client.Voip.MalformedTargetClass','fr','Choisissez une destination (cible).');
INSERT INTO `language_strings` VALUES (105,'Client.Voip.MalformedTarget','de','Ungültige Zielangabe, bitte verwenden Sie entweder nur Ziffern, oder geben Sie einen gültigen SIP User ein.');
INSERT INTO `language_strings` VALUES (106,'Client.Voip.MalformedTarget','en','Invalid destination, please use digits only or enter a valid SIP URI.');
INSERT INTO `language_strings` VALUES (107,'Client.Voip.MalformedTarget','es','Destino inválido. Por favor, use dígitos exclusivamente o introduzca una SIP URI válida.');
INSERT INTO `language_strings` VALUES (108,'Client.Voip.MalformedTarget','fr','La destination invalide, utilisez uniquement des chiffres ou entrez dans une SIP URI valide');
INSERT INTO `language_strings` VALUES (109,'Client.Voip.MalformedTimeout','de','Ungültiger Timeout, bitte verwenden Sie nur Ziffern.');
INSERT INTO `language_strings` VALUES (110,'Client.Voip.MalformedTimeout','en','Invalid timeout, please use digits only.');
INSERT INTO `language_strings` VALUES (111,'Client.Voip.MalformedTimeout','es','Invalid timeout, please use digits only.');
INSERT INTO `language_strings` VALUES (112,'Client.Voip.MalformedTimeout','fr','Invalid timeout, please use digits only.');
INSERT INTO `language_strings` VALUES (113,'Client.Voip.MissingName','de','Bitte geben Sie zumindest Vor- oder Nachnamen ein.');
INSERT INTO `language_strings` VALUES (114,'Client.Voip.MissingName','en','Please enter at least a first or last name.');
INSERT INTO `language_strings` VALUES (115,'Client.Voip.MissingName','es','Por favor, introduzca al menos un nombre o un apellido.');
INSERT INTO `language_strings` VALUES (116,'Client.Voip.MissingName','fr','Entrez au moins un prénom ou nom de famille.');
INSERT INTO `language_strings` VALUES (117,'Client.Voip.MissingOldPass','de','Bitte geben Sie Ihr aktuelles Passwort ein.');
INSERT INTO `language_strings` VALUES (118,'Client.Voip.MissingOldPass','en','Please enter your current password.');
INSERT INTO `language_strings` VALUES (119,'Client.Voip.MissingOldPass','es','Por favor, introduzca su contraseña actual.');
INSERT INTO `language_strings` VALUES (120,'Client.Voip.MissingOldPass','fr','Entrez votre mot de passe actuel.');
INSERT INTO `language_strings` VALUES (121,'Client.Voip.MissingPass2','de','Bitte geben Sie das Passwort in beide Felder ein.');
INSERT INTO `language_strings` VALUES (122,'Client.Voip.MissingPass2','en','Please enter the password in both fields.');
INSERT INTO `language_strings` VALUES (123,'Client.Voip.MissingPass2','es','Por favor, introduzca la contraseña en ambos campos.');
INSERT INTO `language_strings` VALUES (124,'Client.Voip.MissingPass2','fr','Entrez le mot de passe dans les deux champs.');
INSERT INTO `language_strings` VALUES (125,'Client.Voip.MissingPass','de','Bitte geben Sie ein Passwort ein.');
INSERT INTO `language_strings` VALUES (126,'Client.Voip.MissingPass','en','Please enter a password.');
INSERT INTO `language_strings` VALUES (127,'Client.Voip.MissingPass','es','Por favor, introduzca una contraseña.');
INSERT INTO `language_strings` VALUES (128,'Client.Voip.MissingPass','fr','Entrez votre mot de passe.');
INSERT INTO `language_strings` VALUES (129,'Client.Voip.MissingRingtimeout','de','Bitte wählen Sie die Zeitdauer nach der Anrufe weitergeleitet werden sollen. (In Sekunden, von 5 bis 300).');
INSERT INTO `language_strings` VALUES (130,'Client.Voip.MissingRingtimeout','en','Please specify a timeout for incoming calls. (In seconds from 5 to 300).');
INSERT INTO `language_strings` VALUES (131,'Client.Voip.MissingRingtimeout','es','Por favor, especifique un tiempo límite para llamadas entrantes. (En segundos, en el rango de 5 a 300).');
INSERT INTO `language_strings` VALUES (132,'Client.Voip.MissingRingtimeout','fr','Spécifiez un temps mort pour des appels entrants. (En secondes 5 à 300).');
INSERT INTO `language_strings` VALUES (133,'Client.Voip.NoSuchDomain','de','Die angegebene Domain existiert nicht in der Datenbank.');
INSERT INTO `language_strings` VALUES (134,'Client.Voip.NoSuchDomain','en','The specified domain does not exist.');
INSERT INTO `language_strings` VALUES (135,'Client.Voip.NoSuchDomain','es','El dominio especificado no existe.');
INSERT INTO `language_strings` VALUES (136,'Client.Voip.NoSuchDomain','fr','Le domaine indiqué n\'existe pas.');
INSERT INTO `language_strings` VALUES (137,'Client.Voip.NoSuchNumber','de','Die Telefonnummer ist nicht verfügbar.');
INSERT INTO `language_strings` VALUES (138,'Client.Voip.NoSuchNumber','en','The specified telephonenumber is not available.');
INSERT INTO `language_strings` VALUES (139,'Client.Voip.NoSuchNumber','es','El número especificado no se encuentra disponible.');
INSERT INTO `language_strings` VALUES (140,'Client.Voip.NoSuchNumber','fr','Le numéro de téléphone indiqué n\'est pas disponible.');
INSERT INTO `language_strings` VALUES (141,'Client.Voip.PassLength','de','The password is too short');
INSERT INTO `language_strings` VALUES (142,'Client.Voip.PassLength','en','The password is too short');
INSERT INTO `language_strings` VALUES (143,'Client.Voip.PassLength','es','The password is too short');
INSERT INTO `language_strings` VALUES (144,'Client.Voip.PassLength','fr','The password is too short');
INSERT INTO `language_strings` VALUES (145,'Client.Voip.PassNoMatch','de','Die Passwörter stimmen nicht überein, bitte überprüfen Sie die Eingabe.');
INSERT INTO `language_strings` VALUES (146,'Client.Voip.PassNoMatch','en','Passwords do not match, please try again.');
INSERT INTO `language_strings` VALUES (147,'Client.Voip.PassNoMatch','es','Las contraseñas no coinciden. Por favor, inténtelo de nuevo.');
INSERT INTO `language_strings` VALUES (148,'Client.Voip.PassNoMatch','fr','Les mots de passe ne correspondent pas, essayez de nouveau.');
INSERT INTO `language_strings` VALUES (149,'Client.Voip.ToManyPreference','de','Maximale Anzahl von Einträgen erreicht.');
INSERT INTO `language_strings` VALUES (150,'Client.Voip.ToManyPreference','en','Maximum number of entries reached.');
INSERT INTO `language_strings` VALUES (151,'Client.Voip.ToManyPreference','es','Alcanzado el número máximo de entradas.');
INSERT INTO `language_strings` VALUES (152,'Client.Voip.ToManyPreference','fr','Le nombre maximal d\'entrées est atteint.');
INSERT INTO `language_strings` VALUES (153,'Server.Billing.Success','de','Ihr Konto wurde erfolgreich aufgeladen.');
INSERT INTO `language_strings` VALUES (154,'Server.Billing.Success','en','Your account has been topped up successfully.');
INSERT INTO `language_strings` VALUES (155,'Server.Billing.Success','es','Su cobro se ha realizado correctamente.');
INSERT INTO `language_strings` VALUES (156,'Server.Billing.Success','fr','Votre compte a été rechargé avec succès.');
INSERT INTO `language_strings` VALUES (157,'Server.Internal','de','Ein interner Systemfehler ist aufgetreten, bitte versuchen Sie es später wieder.');
INSERT INTO `language_strings` VALUES (158,'Server.Internal','en','Internal error, please try again later.');
INSERT INTO `language_strings` VALUES (159,'Server.Internal','es','Se ha detectado un error interno. Por favor, inténtelo de nuevo más tarde.');
INSERT INTO `language_strings` VALUES (160,'Server.Internal','fr','Erreur interne, essayez de nouveau plus tard.');
INSERT INTO `language_strings` VALUES (161,'Server.Paypal.Error','de','Bitte folgen Sie den Anweisungen auf der PayPal Webseite um die Überweisung durchzuführen.');
INSERT INTO `language_strings` VALUES (162,'Server.Paypal.Error','en','Please follow the instrutions on the PayPal website to transfer the credit.');
INSERT INTO `language_strings` VALUES (163,'Server.Paypal.Error','es','Por favor, siga las instrucciones en la web de PayPal para realizar la transferencia.');
INSERT INTO `language_strings` VALUES (164,'Server.Paypal.Error','fr','Suivez s\'il vous plaît les instructions sur le site Web PayPal pour transférer le crédit.');
INSERT INTO `language_strings` VALUES (165,'Server.Paypal.Fault','de','Fehler in der Kommunikation mit PayPal, bitte versuchen Sie es etwas später noch einmal.');
INSERT INTO `language_strings` VALUES (166,'Server.Paypal.Fault','en','Communication error with PayPal server, please try again later.');
INSERT INTO `language_strings` VALUES (167,'Server.Paypal.Fault','es','No se puede comunicar con el servidor de PayPal. Por favor, inténtelo de nuevo más tarde.');
INSERT INTO `language_strings` VALUES (168,'Server.Paypal.Fault','fr','Erreur de communication avec le serveur PayPal, essayez de nouveau plus tard.');
INSERT INTO `language_strings` VALUES (169,'Server.Paypal.Invalid','de','Fehler in der Kommunikation mit PayPal, bitte versuchen Sie es etwas später noch einmal.');
INSERT INTO `language_strings` VALUES (170,'Server.Paypal.Invalid','en','Communication error with PayPal server, please try again later.');
INSERT INTO `language_strings` VALUES (171,'Server.Paypal.Invalid','es','Ha ocurrido un error de comunicación con el servidor de PayPal. Por favor, inténtelo de nuevo más tarde.');
INSERT INTO `language_strings` VALUES (172,'Server.Paypal.Invalid','fr','Erreur de communication avec le serveur PayPal, essayez de nouveau plus tard.');
INSERT INTO `language_strings` VALUES (173,'Server.Voip.RemovedContact','de','Der Kontakteintrag wurde gelöscht.');
INSERT INTO `language_strings` VALUES (174,'Server.Voip.RemovedContact','en','The contact entry has been deleted.');
INSERT INTO `language_strings` VALUES (175,'Server.Voip.RemovedContact','es','El contacto ha sido eliminado.');
INSERT INTO `language_strings` VALUES (176,'Server.Voip.RemovedContact','fr','Le contact saisi a été supprimée.');
INSERT INTO `language_strings` VALUES (177,'Server.Voip.RemovedRegisteredContact','de','Die Registrierung wurde gelöscht.');
INSERT INTO `language_strings` VALUES (178,'Server.Voip.RemovedRegisteredContact','en','The registered contact has been deleted.');
INSERT INTO `language_strings` VALUES (179,'Server.Voip.RemovedRegisteredContact','es','El contacto ha sido eliminado.');
INSERT INTO `language_strings` VALUES (180,'Server.Voip.RemovedRegisteredContact','fr','Le contact enregistré a été supprimé.');
INSERT INTO `language_strings` VALUES (181,'Server.Voip.AddedRegisteredContact','de','Permanenter Registrierungseintrag wurde hinzugefügt.');
INSERT INTO `language_strings` VALUES (182,'Server.Voip.AddedRegisteredContact','en','Permanent registration contact has been added.');
INSERT INTO `language_strings` VALUES (183,'Server.Voip.AddedRegisteredContact','es','Contacto permanente guardado correctamente.');
INSERT INTO `language_strings` VALUES (184,'Server.Voip.AddedRegisteredContact','fr','Le contact enregistré a été ajouté.');
INSERT INTO `language_strings` VALUES (185,'Server.Voip.RemovedVoicemail','de','Die Sprachnachricht wurde gelöscht.');
INSERT INTO `language_strings` VALUES (186,'Server.Voip.RemovedVoicemail','en','The voicemail has been deleted.');
INSERT INTO `language_strings` VALUES (187,'Server.Voip.RemovedVoicemail','es','El buzón de voz ha sido eliminado.');
INSERT INTO `language_strings` VALUES (188,'Server.Voip.RemovedVoicemail','fr','La boîte vocale a été supprimé.');
INSERT INTO `language_strings` VALUES (189,'Server.Voip.SavedContact','de','Der Kontakteintrag wurde gespeichert.');
INSERT INTO `language_strings` VALUES (190,'Server.Voip.SavedContact','en','The contact entry bas been saved.');
INSERT INTO `language_strings` VALUES (191,'Server.Voip.SavedContact','es','Contacto guardado correctamente.');
INSERT INTO `language_strings` VALUES (192,'Server.Voip.SavedContact','fr','Le contact saisi a été enregistré.');
INSERT INTO `language_strings` VALUES (193,'Server.Voip.SavedPass','de','Ihr Passwort wurde erfolgreich geändert.');
INSERT INTO `language_strings` VALUES (194,'Server.Voip.SavedPass','en','The password has been changed successfully.');
INSERT INTO `language_strings` VALUES (195,'Server.Voip.SavedPass','es','Su contraseña ha sido modificada correctamente.');
INSERT INTO `language_strings` VALUES (196,'Server.Voip.SavedPass','fr','Le mot de passe a été changé avec succès.');
INSERT INTO `language_strings` VALUES (197,'Server.Voip.SavedSettings','de','Ihre Einstellungen wurden gespeichert.');
INSERT INTO `language_strings` VALUES (198,'Server.Voip.SavedSettings','en','Your settings have been saved.');
INSERT INTO `language_strings` VALUES (199,'Server.Voip.SavedSettings','es','Sus preferencias han sido guardadas.');
INSERT INTO `language_strings` VALUES (200,'Server.Voip.SavedSettings','fr','Vos paramètres ont été enregistrés.');
INSERT INTO `language_strings` VALUES (201,'Server.Voip.SubscriberCreated','de','Der Benutzer wurde gespeichert und kann jetzt konfiguriert werden.');
INSERT INTO `language_strings` VALUES (202,'Server.Voip.SubscriberCreated','en','The user has been saved and may be configured.');
INSERT INTO `language_strings` VALUES (203,'Server.Voip.SubscriberCreated','es','El usuario ha sido guardado y puede ser configurado.');
INSERT INTO `language_strings` VALUES (204,'Server.Voip.SubscriberCreated','fr','L\'utilisateur a été enregistré et peut être configuré.');
INSERT INTO `language_strings` VALUES (205,'Server.Voip.SubscriberDeleted','de','Der Benutzer wurde gelöscht.');
INSERT INTO `language_strings` VALUES (206,'Server.Voip.SubscriberDeleted','en','The user has been deleted.');
INSERT INTO `language_strings` VALUES (207,'Server.Voip.SubscriberDeleted','es','El usuario ha sido eliminado.');
INSERT INTO `language_strings` VALUES (208,'Server.Voip.SubscriberDeleted','fr','L\'utilisateur a été supprimé.');
INSERT INTO `language_strings` VALUES (209,'Server.System.RRDOpenError','en','Failed to open RRD file.');
INSERT INTO `language_strings` VALUES (210,'Server.System.RRDOpenError','de','Fehler beim Öffnen der RRD-Datei.');
INSERT INTO `language_strings` VALUES (211,'Server.System.RRDOpenError','es','No se ha podido abrir el ficherp RRD.');
INSERT INTO `language_strings` VALUES (212,'Server.System.RRDOpenError','fr','Tentative d’ouverture du fichier RRD à échoué.');
INSERT INTO `language_strings` VALUES (213,'Server.System.RRDBinmodeError','en','Failed to switch to BIN mode in RRD file.');
INSERT INTO `language_strings` VALUES (214,'Server.System.RRDBinmodeError','de','Fehler beim Wechsel auf BIN mode in RRD-Datei.');
INSERT INTO `language_strings` VALUES (215,'Server.System.RRDBinmodeError','es','No se ha podido pasar a modo BIN en el fichero RRD.');
INSERT INTO `language_strings` VALUES (216,'Server.System.RRDBinmodeError','fr','Echec de switch en mode BIN dans le fichier RRD.');
INSERT INTO `language_strings` VALUES (217,'Server.System.RRDReadError','en','Failed to read RRD file.');
INSERT INTO `language_strings` VALUES (218,'Server.System.RRDReadError','de','Fehler beim Lesen der RRD-Datei.');
INSERT INTO `language_strings` VALUES (219,'Server.System.RRDReadError','es','No se ha podido leer el fichero RRD.');
INSERT INTO `language_strings` VALUES (220,'Server.System.RRDReadError','fr','Tentative de lecture du fichier RRD à échoué.');
INSERT INTO `language_strings` VALUES (221,'Web.Addressbook.Fax','de','Fax');
INSERT INTO `language_strings` VALUES (222,'Web.Addressbook.Fax','en','Fax');
INSERT INTO `language_strings` VALUES (223,'Web.Addressbook.Fax','es','Fax');
INSERT INTO `language_strings` VALUES (224,'Web.Addressbook.Fax','fr','Fax');
INSERT INTO `language_strings` VALUES (225,'Web.Addressbook.Home','de','Privat');
INSERT INTO `language_strings` VALUES (226,'Web.Addressbook.Home','en','Home');
INSERT INTO `language_strings` VALUES (227,'Web.Addressbook.Home','es','Domicilio');
INSERT INTO `language_strings` VALUES (228,'Web.Addressbook.Home','fr','Domicile');
INSERT INTO `language_strings` VALUES (229,'Web.Addressbook.Mobile','de','Mobil');
INSERT INTO `language_strings` VALUES (230,'Web.Addressbook.Mobile','en','Mobile');
INSERT INTO `language_strings` VALUES (231,'Web.Addressbook.Mobile','es','Móvil');
INSERT INTO `language_strings` VALUES (232,'Web.Addressbook.Mobile','fr','Portable');
INSERT INTO `language_strings` VALUES (233,'Web.Addressbook.Office','de','Büro');
INSERT INTO `language_strings` VALUES (234,'Web.Addressbook.Office','en','Office');
INSERT INTO `language_strings` VALUES (235,'Web.Addressbook.Office','es','Trabajo');
INSERT INTO `language_strings` VALUES (236,'Web.Addressbook.Office','fr','Travail');
INSERT INTO `language_strings` VALUES (237,'Web.MissingRedInput','de','Bitte füllen Sie alle rot umrandeten Felder aus.');
INSERT INTO `language_strings` VALUES (238,'Web.MissingRedInput','en','Please fill in at least all red bordered input fields.');
INSERT INTO `language_strings` VALUES (239,'Web.MissingRedInput','es','Por favor, rellene al menos todos los campos con borde rojo.');
INSERT INTO `language_strings` VALUES (240,'Web.MissingRedInput','fr','Remplissez au moins tous les champs de saisie de bordure rouges.');
INSERT INTO `language_strings` VALUES (241,'Web.Months.01','de','Jänner');
INSERT INTO `language_strings` VALUES (242,'Web.Months.01','en','January');
INSERT INTO `language_strings` VALUES (243,'Web.Months.01','es','Enero');
INSERT INTO `language_strings` VALUES (244,'Web.Months.01','fr','Janvier');
INSERT INTO `language_strings` VALUES (245,'Web.Months.02','de','Februar');
INSERT INTO `language_strings` VALUES (246,'Web.Months.02','en','February');
INSERT INTO `language_strings` VALUES (247,'Web.Months.02','es','Febrero');
INSERT INTO `language_strings` VALUES (248,'Web.Months.02','fr','Février');
INSERT INTO `language_strings` VALUES (249,'Web.Months.03','de','März');
INSERT INTO `language_strings` VALUES (250,'Web.Months.03','en','March');
INSERT INTO `language_strings` VALUES (251,'Web.Months.03','es','Marzo');
INSERT INTO `language_strings` VALUES (252,'Web.Months.03','fr','Mars');
INSERT INTO `language_strings` VALUES (253,'Web.Months.04','de','April');
INSERT INTO `language_strings` VALUES (254,'Web.Months.04','en','April');
INSERT INTO `language_strings` VALUES (255,'Web.Months.04','es','Abril');
INSERT INTO `language_strings` VALUES (256,'Web.Months.04','fr','Avril');
INSERT INTO `language_strings` VALUES (257,'Web.Months.05','de','Mai');
INSERT INTO `language_strings` VALUES (258,'Web.Months.05','en','May');
INSERT INTO `language_strings` VALUES (259,'Web.Months.05','es','Mayo');
INSERT INTO `language_strings` VALUES (260,'Web.Months.05','fr','Mai');
INSERT INTO `language_strings` VALUES (261,'Web.Months.06','de','Juni');
INSERT INTO `language_strings` VALUES (262,'Web.Months.06','en','June');
INSERT INTO `language_strings` VALUES (263,'Web.Months.06','es','Junio');
INSERT INTO `language_strings` VALUES (264,'Web.Months.06','fr','Juin');
INSERT INTO `language_strings` VALUES (265,'Web.Months.07','de','Juli');
INSERT INTO `language_strings` VALUES (266,'Web.Months.07','en','July');
INSERT INTO `language_strings` VALUES (267,'Web.Months.07','es','Julio');
INSERT INTO `language_strings` VALUES (268,'Web.Months.07','fr','Juillet');
INSERT INTO `language_strings` VALUES (269,'Web.Months.08','de','August');
INSERT INTO `language_strings` VALUES (270,'Web.Months.08','en','August');
INSERT INTO `language_strings` VALUES (271,'Web.Months.08','es','Agosto');
INSERT INTO `language_strings` VALUES (272,'Web.Months.08','fr','Août');
INSERT INTO `language_strings` VALUES (273,'Web.Months.09','de','September');
INSERT INTO `language_strings` VALUES (274,'Web.Months.09','en','September');
INSERT INTO `language_strings` VALUES (275,'Web.Months.09','es','Septiembre');
INSERT INTO `language_strings` VALUES (276,'Web.Months.09','fr','Septembre');
INSERT INTO `language_strings` VALUES (277,'Web.Months.10','de','Oktober');
INSERT INTO `language_strings` VALUES (278,'Web.Months.10','en','October');
INSERT INTO `language_strings` VALUES (279,'Web.Months.10','es','Octubre');
INSERT INTO `language_strings` VALUES (280,'Web.Months.10','fr','Octobre');
INSERT INTO `language_strings` VALUES (281,'Web.Months.11','de','November');
INSERT INTO `language_strings` VALUES (282,'Web.Months.11','en','November');
INSERT INTO `language_strings` VALUES (283,'Web.Months.11','es','Noviembre');
INSERT INTO `language_strings` VALUES (284,'Web.Months.11','fr','Novembre');
INSERT INTO `language_strings` VALUES (285,'Web.Months.12','de','Dezember');
INSERT INTO `language_strings` VALUES (286,'Web.Months.12','en','December');
INSERT INTO `language_strings` VALUES (287,'Web.Months.12','es','Diciembre');
INSERT INTO `language_strings` VALUES (288,'Web.Months.12','fr','Decembre');
INSERT INTO `language_strings` VALUES (289,'Client.Syntax.AccountID','de','Ungültige ID, bitte verwenden Sie nur Ziffern.');
INSERT INTO `language_strings` VALUES (290,'Client.Syntax.AccountID','en','Invalid ID, please use numbers only.');
INSERT INTO `language_strings` VALUES (291,'Client.Syntax.AccountID','es','ID inválido. Por favor use dígitos exclusivamente.');
INSERT INTO `language_strings` VALUES (292,'Client.Syntax.AccountID','fr','Identifiant invalide utilisé uniquement des numéros.');
INSERT INTO `language_strings` VALUES (293,'Client.Syntax.CashValue','de','Ungültiger Betrag, bitte geben Sie nur Ziffern ein, mit Beistrich oder Punkt als Dezimaltrenner.');
INSERT INTO `language_strings` VALUES (294,'Client.Syntax.CashValue','en','Invalid amount, please use numbers only, with comma or dot as decimal separator.');
INSERT INTO `language_strings` VALUES (295,'Client.Syntax.CashValue','es','Cantidad inválida. Por favor, use dígitos exclusivamente, con coma o punto como separador decimal.');
INSERT INTO `language_strings` VALUES (296,'Client.Syntax.CashValue','fr','La quantité (somme) est invalide, utilisez des numéros uniquement des nombres, avec la virgule ou le point comme le séparateur décimal.');
INSERT INTO `language_strings` VALUES (297,'Client.Syntax.TimeValue','de','Ungültige Eingabe, bitte geben Sie eine ganze Zahl ein.');
INSERT INTO `language_strings` VALUES (298,'Client.Syntax.TimeValue','en','Invalid input, please use numbers only.');
INSERT INTO `language_strings` VALUES (299,'Client.Syntax.TimeValue','es','Entrada inválida. Por favor, use dígitos exclusivamente.');
INSERT INTO `language_strings` VALUES (300,'Client.Syntax.TimeValue','fr','La saisie est invalide, utilisez uniquement des nombres.');
INSERT INTO `language_strings` VALUES (301,'Client.Syntax.LoginMissingUsername','de','Bitte geben Sie Ihren Usernamen ein.');
INSERT INTO `language_strings` VALUES (302,'Client.Syntax.LoginMissingUsername','en','Please enter your username.');
INSERT INTO `language_strings` VALUES (303,'Client.Syntax.LoginMissingUsername','es','Por favor, introduzca su nombre de usuario.');
INSERT INTO `language_strings` VALUES (304,'Client.Syntax.LoginMissingUsername','fr','Entrer votre nom d’utilisateur.');
INSERT INTO `language_strings` VALUES (305,'Client.Syntax.LoginMissingPass','de','Bitte geben Sie Ihr Passwort ein.');
INSERT INTO `language_strings` VALUES (306,'Client.Syntax.LoginMissingPass','en','Please enter your password.');
INSERT INTO `language_strings` VALUES (307,'Client.Syntax.LoginMissingPass','es','Por favor, introduzca su contraseña.');
INSERT INTO `language_strings` VALUES (308,'Client.Syntax.LoginMissingPass','fr','Entrer votre mot de passe.');
INSERT INTO `language_strings` VALUES (309,'Client.Voip.NoSuchAccount','de','Der Account existiert nicht.');
INSERT INTO `language_strings` VALUES (310,'Client.Voip.NoSuchAccount','en','This account does not exist.');
INSERT INTO `language_strings` VALUES (311,'Client.Voip.NoSuchAccount','es','La cuenta no existe.');
INSERT INTO `language_strings` VALUES (312,'Client.Voip.NoSuchAccount','fr','Ce compte n’existe pas.');
INSERT INTO `language_strings` VALUES (313,'Client.Voip.ExistingDomain','de','Diese Domain existiert bereits.');
INSERT INTO `language_strings` VALUES (314,'Client.Voip.ExistingDomain','en','This domain already exists.');
INSERT INTO `language_strings` VALUES (315,'Client.Voip.ExistingDomain','es','El dominio ya existe.');
INSERT INTO `language_strings` VALUES (316,'Client.Voip.ExistingDomain','fr','Ce domaine existe déjà.');
INSERT INTO `language_strings` VALUES (317,'Web.Domain.Created','de','Die Domain wurde gespeichert.');
INSERT INTO `language_strings` VALUES (318,'Web.Domain.Created','en','The domain has been saved.');
INSERT INTO `language_strings` VALUES (319,'Web.Domain.Created','es','El dominio ha sido guardado.');
INSERT INTO `language_strings` VALUES (320,'Web.Domain.Created','fr','Le domaine a été enregistré.');
INSERT INTO `language_strings` VALUES (321,'Web.Domain.Deleted','de','Die Domain wurde gelöscht.');
INSERT INTO `language_strings` VALUES (322,'Web.Domain.Deleted','en','The domain has been deleted.');
INSERT INTO `language_strings` VALUES (323,'Web.Domain.Deleted','es','El dominio ha sido eliminado.');
INSERT INTO `language_strings` VALUES (324,'Web.Domain.Deleted','fr','Le domaine a été supprimé.');
INSERT INTO `language_strings` VALUES (325,'Client.Admin.ExistingAdmin','de','Dieser username ist bereits in Verwendung.');
INSERT INTO `language_strings` VALUES (326,'Client.Admin.ExistingAdmin','en','This username is already in use.');
INSERT INTO `language_strings` VALUES (327,'Client.Admin.ExistingAdmin','es','El nombre de usuario ya se encuentra en uso.');
INSERT INTO `language_strings` VALUES (328,'Client.Admin.ExistingAdmin','fr','Ce nom d’utilisateur existe déjà.');
INSERT INTO `language_strings` VALUES (329,'Client.Admin.NoSuchAdmin','de','Dieser Administrator existiert nicht.');
INSERT INTO `language_strings` VALUES (330,'Client.Admin.NoSuchAdmin','en','This administrator does not exist.');
INSERT INTO `language_strings` VALUES (331,'Client.Admin.NoSuchAdmin','es','El administrador no existe.');
INSERT INTO `language_strings` VALUES (332,'Client.Admin.NoSuchAdmin','fr','Cet administrateur n’existe pas.');
INSERT INTO `language_strings` VALUES (333,'Client.Syntax.MalformedLogin','de','Ungültig Zeichen im Loginnamen. Bitte verwenden Sie nur Buchstaben und Zahlen.');
INSERT INTO `language_strings` VALUES (334,'Client.Syntax.MalformedLogin','en','Invalid characters in login name. Please use alphanumeric characters only.');
INSERT INTO `language_strings` VALUES (335,'Client.Syntax.MalformedLogin','es','Caracteres inválidos en nombre de usuario. Por favor use únicamente caracteres alfanuméricos.');
INSERT INTO `language_strings` VALUES (336,'Client.Syntax.MalformedLogin','fr','Caractères invalides de nom d\'établissement de la connexion. Utilisez uniquement caractères alphanumériques.');
INSERT INTO `language_strings` VALUES (337,'Web.Admin.Created','de','Der Administrator wurde gespeichert.');
INSERT INTO `language_strings` VALUES (338,'Web.Admin.Created','en','The administrator has been saved.');
INSERT INTO `language_strings` VALUES (339,'Web.Admin.Created','es','El administrador ha sido guardado.');
INSERT INTO `language_strings` VALUES (340,'Web.Admin.Created','fr','L\'administrateur a été enregistré.');
INSERT INTO `language_strings` VALUES (341,'Web.Admin.Deleted','de','Der Administrator wurde gelöscht.');
INSERT INTO `language_strings` VALUES (342,'Web.Admin.Deleted','en','The administrator has been deleted.');
INSERT INTO `language_strings` VALUES (343,'Web.Admin.Deleted','es','El administrador ha sido eliminado.');
INSERT INTO `language_strings` VALUES (344,'Web.Admin.Deleted','fr','L\'administrateur a été supprimé.');
INSERT INTO `language_strings` VALUES (345,'Web.Account.Created','de','Der Account wurde gespeichert.');
INSERT INTO `language_strings` VALUES (346,'Web.Account.Created','en','The account has been saved.');
INSERT INTO `language_strings` VALUES (347,'Web.Account.Created','es','La cuenta ha sido guardada.');
INSERT INTO `language_strings` VALUES (348,'Web.Account.Created','fr','Le compte a été enregistré.');
INSERT INTO `language_strings` VALUES (349,'Web.Payment.UnknownError','de','Bei der Initialisierung des Zahlvorgangs ist ein Fehler aufgetreten. Bitte versuchen Sie es etwas späeter nochmals und überprüfen Sie Ihre Eingaben.');
INSERT INTO `language_strings` VALUES (350,'Web.Payment.UnknownError','en','Failed to initialize the transaction. Please try again later and verify your input.');
INSERT INTO `language_strings` VALUES (351,'Web.Payment.UnknownError','es','Se ha detectado un error al inicial la transacción. Por favor, verifique los datos e inténtelo de nuevo más tarde.');
INSERT INTO `language_strings` VALUES (352,'Web.Payment.UnknownError','fr','Echec d’initialisation de la transaction. Essayez de nouveau plus tard et vérifiez votre saisie.');
INSERT INTO `language_strings` VALUES (353,'Web.Payment.HttpFailed','de','Der Payment Server konnte nicht erreicht werden. Bitte versuchen Sie es etwas später nochmals.');
INSERT INTO `language_strings` VALUES (354,'Web.Payment.HttpFailed','en','The payment server could not be reached. Please try again later.');
INSERT INTO `language_strings` VALUES (355,'Web.Payment.HttpFailed','es','Se ha detectado un error al intertar conectar con el servidor de pagos. Por favor, inténtelo de nuevo más tarde.');
INSERT INTO `language_strings` VALUES (356,'Web.Payment.HttpFailed','fr','Le serveur de paiement ne pouvait pas être atteint. Essayez de nouveau plus tard.');
INSERT INTO `language_strings` VALUES (357,'Web.Syntax.Numeric','de','Ungültige Zahlenangabe, bitte verwenden Sie nur Ziffern.');
INSERT INTO `language_strings` VALUES (358,'Web.Syntax.Numeric','en','Invalid number, please use numerics only.');
INSERT INTO `language_strings` VALUES (359,'Web.Syntax.Numeric','es','Número inválido. Por favor, use números exclusivamente.');
INSERT INTO `language_strings` VALUES (360,'Web.Syntax.Numeric','fr','Numéro invalide, utilisez des données numériques uniquement.');
INSERT INTO `language_strings` VALUES (361,'Web.MissingContactInfo','de','Bitte selektieren Sie das Kästchen \"wie oben\", oder füllen Sie alle anderen Eingabefelder aus.');
INSERT INTO `language_strings` VALUES (362,'Web.MissingContactInfo','en','Please check the box \"like above\" or fill in all additional input fields.');
INSERT INTO `language_strings` VALUES (363,'Web.MissingContactInfo','es','Por favor, compruebe la casilla \"como arriba\" o rellene todos los campos adicionales.');
INSERT INTO `language_strings` VALUES (364,'Web.MissingContactInfo','fr','Vérifiez la boîte \" like above \" ou remplissez tous les champs de saisie supplémentaires.');
INSERT INTO `language_strings` VALUES (365,'Web.MissingInput','de','Bitte füllen Sie alle Eingabefelder aus.');
INSERT INTO `language_strings` VALUES (366,'Web.MissingInput','en','Please fill in all input fields.');
INSERT INTO `language_strings` VALUES (367,'Web.MissingInput','es','Por favor, rellene todos los campos.');
INSERT INTO `language_strings` VALUES (368,'Web.MissingInput','fr','Remplissez tous les champs de saisie.');
INSERT INTO `language_strings` VALUES (369,'Web.Subscriber.Lockforeign','de','Der Subscriber ist für ausgehende Anrufe die das System verlassen gesperrt.');
INSERT INTO `language_strings` VALUES (370,'Web.Subscriber.Lockforeign','en','The subscriber is locked for calls that leave the system.');
INSERT INTO `language_strings` VALUES (371,'Web.Subscriber.Lockforeign','es','El suscriptor tiene restringidas las llamadas salientes hacia fuera del sistema.');
INSERT INTO `language_strings` VALUES (372,'Web.Subscriber.Lockforeign','fr','L\'abonné est locké pour les appels qui sort du système.');
INSERT INTO `language_strings` VALUES (373,'Web.Subscriber.Lockoutgoing','de','Der Subscriber ist für ausgehende Anrufe gesperrt.');
INSERT INTO `language_strings` VALUES (374,'Web.Subscriber.Lockoutgoing','en','The subscriber is locked for outgoing calls.');
INSERT INTO `language_strings` VALUES (375,'Web.Subscriber.Lockoutgoing','es','El suscriptor tiene restringidas las llamadas salientes.');
INSERT INTO `language_strings` VALUES (376,'Web.Subscriber.Lockoutgoing','fr','L’abonné est locké pour les appels sortant.');
INSERT INTO `language_strings` VALUES (377,'Web.Subscriber.Lockincoming','de','Der Subscriber ist für eingehende und ausgehende Anrufe gesperrt.');
INSERT INTO `language_strings` VALUES (378,'Web.Subscriber.Lockincoming','en','The subscriber is locked for incoming and outgoing calls.');
INSERT INTO `language_strings` VALUES (379,'Web.Subscriber.Lockincoming','es','El suscriptor tiene restringidas las llamadas entrantes y salientes.');
INSERT INTO `language_strings` VALUES (380,'Web.Subscriber.Lockincoming','fr','L\'abonné est locké pour les appels entrants et sortants.');
INSERT INTO `language_strings` VALUES (381,'Web.Subscriber.Lockglobal','de','Der Subscriber ist für alle Services gesperrt.');
INSERT INTO `language_strings` VALUES (382,'Web.Subscriber.Lockglobal','en','The subscriber is locked for all services.');
INSERT INTO `language_strings` VALUES (383,'Web.Subscriber.Lockglobal','es','El suscriptor tiene restringidos todos los servicios.');
INSERT INTO `language_strings` VALUES (384,'Web.Subscriber.Lockglobal','fr','L\'abonné est locké pour tous les services des appels sortants.');
INSERT INTO `language_strings` VALUES (385,'Web.Payment.ExternalError','de','Der Zahlvorgang ist fehlgeschlagen. Bitte versuchen Sie es etwas späeter nochmals und befolgen Sie alle Anweisungen der externen Webseite.');
INSERT INTO `language_strings` VALUES (386,'Web.Payment.ExternalError','en','The transaction failed. Please try again later and follow all instructions on the external website.');
INSERT INTO `language_strings` VALUES (387,'Web.Payment.ExternalError','es','Se ha detectado un error externo al realizar la transacción. Por favor, inténtelo de nuevo más tarde y siga las instrucciones de la web externa.');
INSERT INTO `language_strings` VALUES (388,'Web.Payment.ExternalError','fr','La transaction a échoué. Essayez de nouveau plus tard et suivez toutes les instructions sur le site Web externe.');
INSERT INTO `language_strings` VALUES (389,'Client.Voip.NoGroupName','de','Bitte geben Sie einen Gruppennamen ein.');
INSERT INTO `language_strings` VALUES (390,'Client.Voip.NoGroupName','en','Please provide a group name.');
INSERT INTO `language_strings` VALUES (391,'Client.Voip.NoGroupName','es','Por favor, introduzca un nombre de grupo.');
INSERT INTO `language_strings` VALUES (392,'Client.Voip.NoGroupName','fr','Fournissez un nom de groupe.');
INSERT INTO `language_strings` VALUES (393,'Client.Voip.NoGroupExt','de','Bitte geben Sie eine numerische Gruppendurchwahl ein.');
INSERT INTO `language_strings` VALUES (394,'Client.Voip.NoGroupExt','en','Please provide a numeric group extension.');
INSERT INTO `language_strings` VALUES (395,'Client.Voip.NoGroupExt','es','Por favor, introduzca una extensión numérica de grupo.');
INSERT INTO `language_strings` VALUES (396,'Client.Voip.NoGroupExt','fr','Fournissez une extension de groupe numérique.');
INSERT INTO `language_strings` VALUES (397,'Client.Voip.MacInUse','en','MAC address is already in use.');
INSERT INTO `language_strings` VALUES (398,'Client.Voip.MacInUse','de','MAC Adresse wird bereits verwendet.');
INSERT INTO `language_strings` VALUES (399,'Client.Voip.MacInUse','es','La dirección MAC ya se encuentra en uso.');
INSERT INTO `language_strings` VALUES (400,'Client.Voip.MacInUse','fr','L\'adresse de MAC est déjà en cours d\'utilisation.');
INSERT INTO `language_strings` VALUES (401,'Web.MissingSystem','de','Bitte wählen Sie die Nebenstellenanlage die Sie verwenden möchten.');
INSERT INTO `language_strings` VALUES (402,'Web.MissingSystem','en','Please choose the IP PBX you want to use.');
INSERT INTO `language_strings` VALUES (403,'Web.MissingSystem','es','Por favor, escoja la IP PBX que desea utilizar.');
INSERT INTO `language_strings` VALUES (404,'Web.MissingSystem','fr','Choisissez PBX IP que vous voulez utiliser.');
INSERT INTO `language_strings` VALUES (405,'Web.MissingAGB','de','Sie müssen den Allgemeinen Geschäftsbedingungen zustimmen.');
INSERT INTO `language_strings` VALUES (406,'Web.MissingAGB','en','Please agree to our general terms and conditions.');
INSERT INTO `language_strings` VALUES (407,'Web.MissingAGB','es','Por favor, acepte los términos y condiciones generales.');
INSERT INTO `language_strings` VALUES (408,'Web.MissingAGB','fr','Soyez en accord avec nos conditions générales.');
INSERT INTO `language_strings` VALUES (409,'Web.Account.Activated','de','Der account wurde aktiviert.');
INSERT INTO `language_strings` VALUES (410,'Web.Account.Activated','en','The account has been activated.');
INSERT INTO `language_strings` VALUES (411,'Web.Account.Activated','es','La cuenta ha sido activada.');
INSERT INTO `language_strings` VALUES (412,'Web.Account.Activated','fr','Le compte a été activé.');
INSERT INTO `language_strings` VALUES (413,'Client.Billing.AuthFailed','de','Login fehlgeschlagen, bitte überprüfen Sie Ihren Usernamen und Ihr Passwort.');
INSERT INTO `language_strings` VALUES (414,'Client.Billing.AuthFailed','en','Login failed, please verify your username and password.');
INSERT INTO `language_strings` VALUES (415,'Client.Billing.AuthFailed','es','Acceso fallido. Por favor, compruebe su usuario y contraseña.');
INSERT INTO `language_strings` VALUES (416,'Client.Billing.AuthFailed','fr','L\'établissement de la connexion a échoué, vérifiez votre nom d’utilisateur et le mot de passe.');
INSERT INTO `language_strings` VALUES (417,'Web.MissingSearchString','de','Bitte geben Sie einen Suchstring ein.');
INSERT INTO `language_strings` VALUES (418,'Web.MissingSearchString','en','Please enter a search string.');
INSERT INTO `language_strings` VALUES (419,'Web.MissingSearchString','es','Por favor, introduzca un término de búsqueda.');
INSERT INTO `language_strings` VALUES (420,'Web.MissingSearchString','fr','Entrez s\'il vous plaît dans une série de recherche.');
INSERT INTO `language_strings` VALUES (421,'Client.Billing.ContactIncomplete','de','Bitte geben Sie zumindest einen Vornamen, Nachnamen oder Firmennamen ein.');
INSERT INTO `language_strings` VALUES (422,'Client.Billing.ContactIncomplete','en','Please enter at least a firstname, lastname or company name.');
INSERT INTO `language_strings` VALUES (423,'Client.Billing.ContactIncomplete','es','Por favor, introduzca el menos un nombre, un apellido o una compañía.');
INSERT INTO `language_strings` VALUES (424,'Client.Billing.ContactIncomplete','fr','Entrez au moins dans un nom, prénom ou nom de l’entreprise.');
INSERT INTO `language_strings` VALUES (425,'Client.Billing.ExistingShopuser','de','Dieser Benutzername ist bereits in Verwendung.');
INSERT INTO `language_strings` VALUES (426,'Client.Billing.ExistingShopuser','en','This username is already in use.');
INSERT INTO `language_strings` VALUES (427,'Client.Billing.ExistingShopuser','es','Este usuario ya se encuentra en uso.');
INSERT INTO `language_strings` VALUES (428,'Client.Billing.ExistingShopuser','fr','Ce nom d’utilisateur est déjà utilisé.');
INSERT INTO `language_strings` VALUES (429,'Client.Billing.ExistingProduct','de','Ein Produkt mit diesem Produkt-Identifikator existiert bereits.');
INSERT INTO `language_strings` VALUES (430,'Client.Billing.ExistingProduct','en','A product with this product-handle already exists.');
INSERT INTO `language_strings` VALUES (431,'Client.Billing.ExistingProduct','es','Ya existe un producto con este identificador.');
INSERT INTO `language_strings` VALUES (432,'Client.Billing.ExistingProduct','fr','A produit avec cet identifiant \"product-handle\" exist dejà.');
INSERT INTO `language_strings` VALUES (433,'Client.Billing.NoSuchProduct','de','Das Produkt mit dem angegebenen Produkt-Identifikator wurde nicht gefunden.');
INSERT INTO `language_strings` VALUES (434,'Client.Billing.NoSuchProduct','en','No product with the specified product-handle found.');
INSERT INTO `language_strings` VALUES (435,'Client.Billing.NoSuchProduct','es','No se han encontrado productos con el identificador especificado.');
INSERT INTO `language_strings` VALUES (436,'Client.Billing.NoSuchProduct','fr','Aucun produit trouvé avec l\'identifiant spécifié \"product-handle\".');
INSERT INTO `language_strings` VALUES (437,'Client.Billing.ExistingProfile','de','Ein Billing Profil mit dem angegebenen Profil-Identifikator existiert bereits.');
INSERT INTO `language_strings` VALUES (438,'Client.Billing.ExistingProfile','en','A billing profile with the specified profile-handle already exists.');
INSERT INTO `language_strings` VALUES (439,'Client.Billing.ExistingProfile','es','Ya existe un perfil de facturación con este identificador.');
INSERT INTO `language_strings` VALUES (440,'Client.Billing.ExistingProfile','fr','A profile de facturation avec l\'identifiant spécifié \"profile-handle\" exist dejà.');
INSERT INTO `language_strings` VALUES (441,'Client.Billing.NoSuchProfile','de','Das Billing Profil mit dem angegebenen Profil-Identifikator wurde nicht gefunden.');
INSERT INTO `language_strings` VALUES (442,'Client.Billing.NoSuchProfile','en','No billing profile with the specified profile-handle found.');
INSERT INTO `language_strings` VALUES (443,'Client.Billing.NoSuchProfile','es','No se han encontrado perfiles de facturación con el identificador especificado.');
INSERT INTO `language_strings` VALUES (444,'Client.Billing.NoSuchProfile','fr','Aucun profile de facturation trouvé avec l\'identifiant spécifié \"profile-handle\".');
INSERT INTO `language_strings` VALUES (445,'Web.Product.Created','de','Der Produkt-Eintrag wurde erstellt.');
INSERT INTO `language_strings` VALUES (446,'Web.Product.Created','en','The product entry has been created.');
INSERT INTO `language_strings` VALUES (447,'Web.Product.Created','es','El producto ha sido creado.');
INSERT INTO `language_strings` VALUES (448,'Web.Product.Created','fr','Le produit saisi a été créée.');
INSERT INTO `language_strings` VALUES (449,'Web.Product.Updated','de','Der Produkt-Eintrag wurde geändert.');
INSERT INTO `language_strings` VALUES (450,'Web.Product.Updated','en','The product entry has been changed.');
INSERT INTO `language_strings` VALUES (451,'Web.Product.Updated','es','El producto ha sido modificado.');
INSERT INTO `language_strings` VALUES (452,'Web.Product.Updated','fr','Le produit saisi a été changé.');
INSERT INTO `language_strings` VALUES (453,'Web.Product.Deleted','de','Der Produkt-Eintrag wurde gelöscht.');
INSERT INTO `language_strings` VALUES (454,'Web.Product.Deleted','en','The product entry has been deleted.');
INSERT INTO `language_strings` VALUES (455,'Web.Product.Deleted','es','El producto ha sido eliminado.');
INSERT INTO `language_strings` VALUES (456,'Web.Product.Deleted','fr','Le produit saisi a été supprimé.');
INSERT INTO `language_strings` VALUES (457,'Web.Bilprof.Created','de','Das Billing Profil wurde erstellt.');
INSERT INTO `language_strings` VALUES (458,'Web.Bilprof.Created','en','The billing profile has been created.');
INSERT INTO `language_strings` VALUES (459,'Web.Bilprof.Created','es','El perfil de facturación ha sido creado.');
INSERT INTO `language_strings` VALUES (460,'Web.Bilprof.Created','fr','Le profil de facturation a été créé.');
INSERT INTO `language_strings` VALUES (461,'Web.Bilprof.Updated','de','Das Billing Profil wurde geändert.');
INSERT INTO `language_strings` VALUES (462,'Web.Bilprof.Updated','en','The billing profile has been changed.');
INSERT INTO `language_strings` VALUES (463,'Web.Bilprof.Updated','es','El perfil de facturación ha sido modificado.');
INSERT INTO `language_strings` VALUES (464,'Web.Bilprof.Updated','fr','Le profil de facturation a été changé.');
INSERT INTO `language_strings` VALUES (465,'Web.Bilprof.Deleted','de','Das Billing Profil wurde gelöscht.');
INSERT INTO `language_strings` VALUES (466,'Web.Bilprof.Deleted','en','The billing profile has been deleted.');
INSERT INTO `language_strings` VALUES (467,'Web.Bilprof.Deleted','es','El perfil de facturación ha sido eliminado.');
INSERT INTO `language_strings` VALUES (468,'Web.Bilprof.Deleted','fr','Le profil de facturation a été supprimé.');
INSERT INTO `language_strings` VALUES (469,'Web.Fees.MissingFilename','de','Bitte geben Sie einen Dateinamen an.');
INSERT INTO `language_strings` VALUES (470,'Web.Fees.MissingFilename','en','Please enter a filename.');
INSERT INTO `language_strings` VALUES (471,'Web.Fees.MissingFilename','es','Por favor, inserte un nombre de fichero.');
INSERT INTO `language_strings` VALUES (472,'Web.Fees.MissingFilename','fr','Entrez un nom de fichier.');
INSERT INTO `language_strings` VALUES (473,'Web.Fees.Fieldcount','de','Falsche Anzahl von Feldern');
INSERT INTO `language_strings` VALUES (474,'Web.Fees.Fieldcount','en','Wrong number of elements');
INSERT INTO `language_strings` VALUES (475,'Web.Fees.Fieldcount','es','Número incorrecto de elementos');
INSERT INTO `language_strings` VALUES (476,'Web.Fees.Fieldcount','fr','Mauvais numéro d\'éléments');
INSERT INTO `language_strings` VALUES (477,'Web.Fees.FieldsFoundRequired','de','Felder gefunden/benötigt:');
INSERT INTO `language_strings` VALUES (478,'Web.Fees.FieldsFoundRequired','en','Elements found/required:');
INSERT INTO `language_strings` VALUES (479,'Web.Fees.FieldsFoundRequired','es','Elementos encontrados/requeridos:');
INSERT INTO `language_strings` VALUES (480,'Web.Fees.FieldsFoundRequired','fr','Éléments trouvés/exigés: ');
INSERT INTO `language_strings` VALUES (481,'Web.Fees.InvalidDestination','de','Ungültiger Ziel-Präfix / -Suffix');
INSERT INTO `language_strings` VALUES (482,'Web.Fees.InvalidDestination','en','Invalid destination prefix/suffix');
INSERT INTO `language_strings` VALUES (483,'Web.Fees.InvalidDestination','es','Prefijo/sufijo de destino inválido.');
INSERT INTO `language_strings` VALUES (484,'Web.Fees.InvalidDestination','fr','Préfixe/suffixe de destination invalide');
INSERT INTO `language_strings` VALUES (485,'Client.Billing.NoSuchCustomer','de','Der angegebene Kunde existiert nicht.');
INSERT INTO `language_strings` VALUES (486,'Client.Billing.NoSuchCustomer','en','The specified customer does not exist.');
INSERT INTO `language_strings` VALUES (487,'Client.Billing.NoSuchCustomer','es','El cliente especificado no existe.');
INSERT INTO `language_strings` VALUES (488,'Client.Billing.NoSuchCustomer','fr','Le client indiqué n\'existe pas.');
INSERT INTO `language_strings` VALUES (489,'Client.Syntax.MalformedDaytime','de','Ungültige Zeitangabe, bitte geben Sie Stunden, Minuten und Sekunden in der Form HH::MM::SS ein.');
INSERT INTO `language_strings` VALUES (490,'Client.Syntax.MalformedDaytime','en','Invalid time specification, please enter hours, minutes and seconds in the form HH:MM:SS.');
INSERT INTO `language_strings` VALUES (491,'Client.Syntax.MalformedDaytime','es','Formato horario inválido. Por favor, inserte horas, minutos y segundos en la forma HH:MM:SS.');
INSERT INTO `language_strings` VALUES (492,'Client.Syntax.MalformedDaytime','fr','Temps spécifié invalide, entrez des heures, des minutes et des secondes sous forme HH:MM:SS.');
INSERT INTO `language_strings` VALUES (493,'Web.Fees.SavedPeaktimes','de','Die Zeit-Einträge wurden aktualisiert.');
INSERT INTO `language_strings` VALUES (494,'Web.Fees.SavedPeaktimes','en','The time-entries have been updated.');
INSERT INTO `language_strings` VALUES (495,'Web.Fees.SavedPeaktimes','es','Las entradas de tiempos han sido actualizadas.');
INSERT INTO `language_strings` VALUES (496,'Web.Fees.SavedPeaktimes','fr','Les entrées de temps ont été mises à jour.');
INSERT INTO `language_strings` VALUES (497,'Client.Voip.DuplicatedNumber','de','Eine Rufnummer wurde mehr als einmal angegeben.');
INSERT INTO `language_strings` VALUES (498,'Client.Voip.DuplicatedNumber','en','A phone number was specified more than once.');
INSERT INTO `language_strings` VALUES (499,'Client.Voip.DuplicatedNumber','es','Un número de teléfono ha sido especificado más de una vez.');
INSERT INTO `language_strings` VALUES (500,'Client.Voip.DuplicatedNumber','fr','Un numéro de téléphone a été spécifié plus d’une fois.');
INSERT INTO `language_strings` VALUES (501,'Client.Voip.SlotAlreadyExists','de','Der Kurzwahl-Eintrag ist bereits in Verwendung.');
INSERT INTO `language_strings` VALUES (502,'Client.Voip.SlotAlreadyExists','en','The speed dial slot is already in use.');
INSERT INTO `language_strings` VALUES (503,'Client.Voip.SlotAlreadyExists','es','La posición de marcación rápida ya está en uso.');
INSERT INTO `language_strings` VALUES (504,'Client.Voip.SlotAlreadyExists','fr','La numérotation abrégée est déjà utilisé.');
INSERT INTO `language_strings` VALUES (505,'Client.Voip.SlotNotExistent','en','The speed dial slot does not exist.');
INSERT INTO `language_strings` VALUES (506,'Client.Voip.SlotNotExistent','de','Der Kurzwahl-Eintrag ist nicht vorhanden.');
INSERT INTO `language_strings` VALUES (507,'Client.Voip.SlotNotExistent','es','La posición de marcación rápida no existe.');
INSERT INTO `language_strings` VALUES (508,'Client.Voip.SlotNotExistent','fr','La numérotation abrégée n\'existe pas.');
INSERT INTO `language_strings` VALUES (509,'Client.Syntax.MalformedSpeedDialDestination','en','The speed dial slot destination is invalid.');
INSERT INTO `language_strings` VALUES (510,'Client.Syntax.MalformedSpeedDialDestination','de','Das Ziel des Kurzwahl-Eintrag ist ungültig.');
INSERT INTO `language_strings` VALUES (511,'Client.Syntax.MalformedSpeedDialDestination','es','La posición de marcación rápida escogida es inválida.');
INSERT INTO `language_strings` VALUES (512,'Client.Syntax.MalformedSpeedDialDestination','fr','Le slot de la numérotation abrégée est invalide.');
INSERT INTO `language_strings` VALUES (513,'Client.Syntax.MalformedVSC','en','The vertical service code (VSC) is invalid.');
INSERT INTO `language_strings` VALUES (514,'Client.Syntax.MalformedVSC','de','Der VSC (vertical service code) ist ungültig.');
INSERT INTO `language_strings` VALUES (515,'Client.Syntax.MalformedVSC','es','El código de servicio vertical (VSC) es inválido.');
INSERT INTO `language_strings` VALUES (516,'Client.Syntax.MalformedVSC','fr','Le code de service vertical (VSC) est invalide.');
INSERT INTO `language_strings` VALUES (517,'Client.Syntax.MalformedIPNet','en','Malformed ipnet, please use dotted decimal notation and specify the mask as number of bits.');
INSERT INTO `language_strings` VALUES (518,'Client.Syntax.MalformedIPNet','de','Ungültiges Netzwerk, bitte verwenden Sie die Dezimalschreibweise mit Punkt und geben Sie die Netzmaske als Anzahl von Bits an.');
INSERT INTO `language_strings` VALUES (519,'Client.Syntax.MalformedIPNet','es','Sintaxis de red inválida. Por favor, use notación decimal y especifique la máscara como número de bits.');
INSERT INTO `language_strings` VALUES (520,'Client.Syntax.MalformedIPNet','fr','Malformed ipnet, please use dotted decimal notation and specify the mask as number of bits.');
INSERT INTO `language_strings` VALUES (521,'Client.Syntax.MalformedIP','en','Malformed ip, please use dotted decimal notation for IPv4 or address without square brackets for IPv6.');
INSERT INTO `language_strings` VALUES (522,'Client.Syntax.MalformedIP','de','Ungültige IP, bitte verwenden Sie dotted decimal Notation für IPv4 bzw. Format ohne eckige Klammern für IPv6.');
INSERT INTO `language_strings` VALUES (523,'Client.Syntax.MalformedIP','es','Sintaxis de IP inválida. Por favor, use notación decimal.');
INSERT INTO `language_strings` VALUES (524,'Client.Syntax.MalformedIP','fr','IP mal construite, utilisez la notation décimale pointillée.');
INSERT INTO `language_strings` VALUES (525,'Server.Voip.PeerGroupDeleted','en','The peering group has been deleted.');
INSERT INTO `language_strings` VALUES (526,'Server.Voip.PeerGroupDeleted','de','Die Peering-Gruppe wurde gelöscht.');
INSERT INTO `language_strings` VALUES (527,'Server.Voip.PeerGroupDeleted','es','El grupo de peering ha sido eliminado.');
INSERT INTO `language_strings` VALUES (528,'Server.Voip.PeerGroupDeleted','fr','Le groupe peering a été supprimé.');
INSERT INTO `language_strings` VALUES (529,'Client.Voip.NoSuchPeerGroup','en','The peering group does not exist.');
INSERT INTO `language_strings` VALUES (530,'Client.Voip.NoSuchPeerGroup','de','Die Peering-Gruppe existiert nicht.');
INSERT INTO `language_strings` VALUES (531,'Client.Voip.NoSuchPeerGroup','es','El grupo de peering no existe.');
INSERT INTO `language_strings` VALUES (532,'Client.Voip.NoSuchPeerGroup','fr','Le groupe peering n’existe pas.');
INSERT INTO `language_strings` VALUES (533,'Client.Voip.NoPeerContract','en','No peering contract selected.');
INSERT INTO `language_strings` VALUES (534,'Client.Voip.NoPeerContract','de','Kein Peering Contract ausgewählt.');
INSERT INTO `language_strings` VALUES (535,'Client.Voip.NoPeerContract','es','No se ha seleccionado un contrato de peering.');
INSERT INTO `language_strings` VALUES (536,'Client.Voip.NoPeerContract','fr','Aucun peering contract n’est sélectionné.');
INSERT INTO `language_strings` VALUES (537,'Client.Voip.ExistingPeerGroup','en','The peering group already exists.');
INSERT INTO `language_strings` VALUES (538,'Client.Voip.ExistingPeerGroup','de','Die Peering-Gruppe existiert bereits.');
INSERT INTO `language_strings` VALUES (539,'Client.Voip.ExistingPeerGroup','es','El grupo de peering ya existe.');
INSERT INTO `language_strings` VALUES (540,'Client.Voip.ExistingPeerGroup','fr','Le peering group existe déjà.');
INSERT INTO `language_strings` VALUES (541,'Client.Syntax.MalformedPeerGroupName','en','Invalid characters in peering group name.');
INSERT INTO `language_strings` VALUES (542,'Client.Syntax.MalformedPeerGroupName','de','Ungültige Zeichen im Name der Peering-Gruppe.');
INSERT INTO `language_strings` VALUES (543,'Client.Syntax.MalformedPeerGroupName','es','Encontrados caracteres inválidos en el nombre del grupo de peering.');
INSERT INTO `language_strings` VALUES (544,'Client.Syntax.MalformedPeerGroupName','fr','Caractères invalides dans le peering group name.');
INSERT INTO `language_strings` VALUES (545,'Client.Voip.NoSuchPeerRule','en','The peering rule does not exist.');
INSERT INTO `language_strings` VALUES (546,'Client.Voip.NoSuchPeerRule','de','Die Peering-Regel existiert nicht.');
INSERT INTO `language_strings` VALUES (547,'Client.Voip.NoSuchPeerRule','es','La regla de peering no existe.');
INSERT INTO `language_strings` VALUES (548,'Client.Voip.NoSuchPeerRule','fr','Le peering rule n’existe pas.');
INSERT INTO `language_strings` VALUES (549,'Client.Voip.NoSuchPeerHost','en','The peering host does not exist.');
INSERT INTO `language_strings` VALUES (550,'Client.Voip.NoSuchPeerHost','de','Der Peering-Server existiert nicht.');
INSERT INTO `language_strings` VALUES (551,'Client.Voip.NoSuchPeerHost','es','El servidor de peering no existe.');
INSERT INTO `language_strings` VALUES (552,'Client.Voip.NoSuchPeerHost','fr','Le peering host n’existe pas.');
INSERT INTO `language_strings` VALUES (553,'Client.Voip.ExistingPeerHost','en','A peering host with this name already exists in this group.');
INSERT INTO `language_strings` VALUES (554,'Client.Voip.ExistingPeerHost','de','Es existiert bereits ein Peering-Host dieses Namens in dieser Gruppe.');
INSERT INTO `language_strings` VALUES (555,'Client.Voip.ExistingPeerHost','es','Ya existe un servidor de peering con este nombre en el grupo.');
INSERT INTO `language_strings` VALUES (556,'Client.Voip.ExistingPeerHost','fr','Un peering host avec ce nom existe déjà dans ce groupe.');
INSERT INTO `language_strings` VALUES (557,'Client.Voip.ExistingPeerIp','en','A peering host with this IP address already exists.');
INSERT INTO `language_strings` VALUES (558,'Client.Voip.ExistingPeerIp','de','Es existiert bereits ein Peering-Host mit dieser IP-Adresse.');
INSERT INTO `language_strings` VALUES (559,'Client.Voip.ExistingPeerIp','es','Ya existe un servidor de peering con esta IP.');
INSERT INTO `language_strings` VALUES (560,'Client.Voip.ExistingPeerIp','fr','Un peering host avec cette adresse IP existe déjà.');
INSERT INTO `language_strings` VALUES (561,'Client.Voip.NoSuchPeerRewriteRule','en','The peering rewrite rule does not exist.');
INSERT INTO `language_strings` VALUES (562,'Client.Voip.NoSuchPeerRewriteRule','de','Die Peering-Rewrite-Regel existiert nicht.');
INSERT INTO `language_strings` VALUES (563,'Client.Voip.NoSuchPeerRewriteRule','es','La regla de reescritura de peering no existe.');
INSERT INTO `language_strings` VALUES (564,'Client.Voip.NoSuchPeerRewriteRule','fr','Le peering rewrite rule n’existe pas.');
INSERT INTO `language_strings` VALUES (565,'Client.Voip.NoSuchDomainRewriteRule','en','The domain rewrite rule does not exist.');
INSERT INTO `language_strings` VALUES (566,'Client.Voip.NoSuchDomainRewriteRule','de','Die Domain-Rewrite-Regel existiert nicht.');
INSERT INTO `language_strings` VALUES (567,'Client.Voip.NoSuchDomainRewriteRule','es','La regla de reescritura de dominio no existe.');
INSERT INTO `language_strings` VALUES (568,'Client.Voip.NoSuchDomainRewriteRule','fr','Le domaine rewrite rule n’existe pas.');
INSERT INTO `language_strings` VALUES (569,'Client.Voip.NoSuchCfDestSet','en','The call-forward destination set does not exist.');
INSERT INTO `language_strings` VALUES (570,'Client.Voip.NoSuchCfDestSet','es','The call-forward destination set does not exist.');
INSERT INTO `language_strings` VALUES (571,'Client.Voip.NoSuchCfDestSet','de','Die Rufumleitungs-Gruppe existiert nicht.');
INSERT INTO `language_strings` VALUES (572,'Client.Voip.NoSuchCfDestSet','fr','The call-forward destination set does not exist.');
INSERT INTO `language_strings` VALUES (573,'Client.Voip.ExistingCfDestSet','en','The call-forward destination set already exists.');
INSERT INTO `language_strings` VALUES (574,'Client.Voip.ExistingCfDestSet','es','The call-forward destination set already exists.');
INSERT INTO `language_strings` VALUES (575,'Client.Voip.ExistingCfDestSet','de','Die Rufumleitungs-Gruppe existiert bereits.');
INSERT INTO `language_strings` VALUES (576,'Client.Voip.ExistingCfDestSet','fr','The call-forward destination set already exists.');
INSERT INTO `language_strings` VALUES (577,'Client.Voip.NoSuchCfDest','en','The call-forward destination does not exist.');
INSERT INTO `language_strings` VALUES (578,'Client.Voip.NoSuchCfDest','es','The call-forward destination does not exist.');
INSERT INTO `language_strings` VALUES (579,'Client.Voip.NoSuchCfDest','de','Die Rufumleitung existiert nicht.');
INSERT INTO `language_strings` VALUES (580,'Client.Voip.NoSuchCfDest','fr','The call-forward destination does not exist.');
INSERT INTO `language_strings` VALUES (581,'Client.Voip.ExistingCfDest','en','The call-forward destination already exists.');
INSERT INTO `language_strings` VALUES (582,'Client.Voip.ExistingCfDest','es','The call-forward destination already exists.');
INSERT INTO `language_strings` VALUES (583,'Client.Voip.ExistingCfDest','de','Die Rufumleitung existiert bereits.');
INSERT INTO `language_strings` VALUES (584,'Client.Voip.ExistingCfDest','fr','The call-forward destination already exists.');
INSERT INTO `language_strings` VALUES (585,'Client.Voip.NoSuchCfTimeSet','en','The call-forward time set does not exist.');
INSERT INTO `language_strings` VALUES (586,'Client.Voip.NoSuchCfTimeSet','es','The call-forward time set does not exist.');
INSERT INTO `language_strings` VALUES (587,'Client.Voip.NoSuchCfTimeSet','de','Die Rufumleitungs-Zeit-Gruppe existiert nicht.');
INSERT INTO `language_strings` VALUES (588,'Client.Voip.NoSuchCfTimeSet','fr','The call-forward time set does not exist.');
INSERT INTO `language_strings` VALUES (589,'Client.Voip.ExistingCfTimeSet','en','The call-forward time set already exists.');
INSERT INTO `language_strings` VALUES (590,'Client.Voip.ExistingCfTimeSet','es','The call-forward time set already exists.');
INSERT INTO `language_strings` VALUES (591,'Client.Voip.ExistingCfTimeSet','de','Die Rufumleitungs-Zeit-Gruppe existiert bereits.');
INSERT INTO `language_strings` VALUES (592,'Client.Voip.ExistingCfTimeSet','fr','The call-forward time set already exists.');
INSERT INTO `language_strings` VALUES (593,'Client.Voip.NoSuchCfPeriod','en','The call-forward time period does not exist.');
INSERT INTO `language_strings` VALUES (594,'Client.Voip.NoSuchCfPeriod','es','The call-forward time period does not exist.');
INSERT INTO `language_strings` VALUES (595,'Client.Voip.NoSuchCfPeriod','de','Die Rufumleitungs-Zeitperiode existiert nicht.');
INSERT INTO `language_strings` VALUES (596,'Client.Voip.NoSuchCfPeriod','fr','The call-forward time period does not exist.');
INSERT INTO `language_strings` VALUES (597,'Client.Voip.MalformedFaxDestination','en','\'destination\' must be an email address or phone number.');
INSERT INTO `language_strings` VALUES (598,'Client.Voip.MalformedFaxDestination','de','\'destination\' muss eine E-Mail Adresse oder Telefonnummer enthalten.');
INSERT INTO `language_strings` VALUES (599,'Client.Voip.MalformedFaxDestination','es','\'destination\' ha de ser una dirección de correo o un número de teléfono.');
INSERT INTO `language_strings` VALUES (600,'Client.Voip.MalformedFaxDestination','fr','\'destination\' doit être une adresse électronique ou un numéro de téléphone.');
INSERT INTO `language_strings` VALUES (601,'Client.Syntax.FaxPassLength','en','The password is to short, please use ${faxpw_min_char} characters at least.');
INSERT INTO `language_strings` VALUES (602,'Client.Syntax.FaxPassLength','de','Das Passwort ist zu kurz, bitte verwenden Sie mindestens ${faxpw_min_char} Zeichen.');
INSERT INTO `language_strings` VALUES (603,'Client.Syntax.FaxPassLength','es','La contraseña es demasiado corta. Por favor use al menos ${faxpw_min_char} caracteres.');
INSERT INTO `language_strings` VALUES (604,'Client.Syntax.FaxPassLength','fr','Le mot de passe est trop court, utilisez le caractères $ {faxpw_min_char} au moins.');
INSERT INTO `language_strings` VALUES (605,'Web.Syntax.ID','en','Invalid ID, please enter a numeric value.');
INSERT INTO `language_strings` VALUES (606,'Web.Syntax.ID','de','Ungültige ID, bitte geben Sie einen numerischen Wert ein.');
INSERT INTO `language_strings` VALUES (607,'Web.Syntax.ID','es','ID inválido. Por favor, introduzca un valor numérico.');
INSERT INTO `language_strings` VALUES (608,'Web.Syntax.ID','fr','ID invalide, entrez dans une valeur numérique.');
INSERT INTO `language_strings` VALUES (609,'Web.Syntax.LNPProvName','en','Please enter a provider name in the text field.');
INSERT INTO `language_strings` VALUES (610,'Web.Syntax.LNPProvName','de','Bitte geben Sie einen Provider-Namen in das Textfeld ein.');
INSERT INTO `language_strings` VALUES (611,'Web.Syntax.LNPProvName','es','Por favor, introduzca el nombre de un proveedor en el campo de texto.');
INSERT INTO `language_strings` VALUES (612,'Web.Syntax.LNPProvName','fr','Entrez un nom de fournisseur dans le champ texte.');
INSERT INTO `language_strings` VALUES (613,'Web.LNPProvider.Created','en','The LNP provider has been created.');
INSERT INTO `language_strings` VALUES (614,'Web.LNPProvider.Created','de','Der LNP Provider wurde erstellt.');
INSERT INTO `language_strings` VALUES (615,'Web.LNPProvider.Created','es','El proveedor LNP ha sido creado.');
INSERT INTO `language_strings` VALUES (616,'Web.LNPProvider.Created','fr','Le fournisseur LNP a été créé.');
INSERT INTO `language_strings` VALUES (617,'Web.LNPProvider.Updated','en','The LNP provider has been changed.');
INSERT INTO `language_strings` VALUES (618,'Web.LNPProvider.Updated','de','Der LNP Provider wurde geändert.');
INSERT INTO `language_strings` VALUES (619,'Web.LNPProvider.Updated','es','El proveedor LNP ha sido modificado.');
INSERT INTO `language_strings` VALUES (620,'Web.LNPProvider.Updated','fr','Le fournisseur LNP a été changé.');
INSERT INTO `language_strings` VALUES (621,'Web.LNPProvider.Deleted','en','The LNP provider has been deleted.');
INSERT INTO `language_strings` VALUES (622,'Web.LNPProvider.Deleted','de','Der LNP Provider wurde gelöscht.');
INSERT INTO `language_strings` VALUES (623,'Web.LNPProvider.Deleted','es','El proveedor LNP ha sido eliminado.');
INSERT INTO `language_strings` VALUES (624,'Web.LNPProvider.Deleted','fr','Le fournisseur LNP a été supprimé.');
INSERT INTO `language_strings` VALUES (625,'Web.LNPNumber.Created','en','The LNP number has been stored.');
INSERT INTO `language_strings` VALUES (626,'Web.LNPNumber.Created','de','Die LNP Nummer wurde gespeichert.');
INSERT INTO `language_strings` VALUES (627,'Web.LNPNumber.Created','es','El número LNP ha sido guardado.');
INSERT INTO `language_strings` VALUES (628,'Web.LNPNumber.Created','fr','Le numéro LNP a été stocké.');
INSERT INTO `language_strings` VALUES (629,'Web.LNPNumber.Updated','en','The LNP number has been changed.');
INSERT INTO `language_strings` VALUES (630,'Web.LNPNumber.Updated','de','Die LNP Nummer wurde geändert.');
INSERT INTO `language_strings` VALUES (631,'Web.LNPNumber.Updated','es','El número LNP ha sido modificado.');
INSERT INTO `language_strings` VALUES (632,'Web.LNPNumber.Updated','fr','Le numéro LNP a été changé.');
INSERT INTO `language_strings` VALUES (633,'Web.LNPNumber.Deleted','en','The LNP number has been deleted.');
INSERT INTO `language_strings` VALUES (634,'Web.LNPNumber.Deleted','de','Die LNP Nummer wurde gelöscht.');
INSERT INTO `language_strings` VALUES (635,'Web.LNPNumber.Deleted','es','El número LNP ha sido eliminado.');
INSERT INTO `language_strings` VALUES (636,'Web.LNPNumber.Deleted','fr','Le numéro LNP a été supprimé.');
INSERT INTO `language_strings` VALUES (637,'Client.Syntax.MalformedE164Number','en','Invalid E.164 number. Please use numbers only and include the international prefix.');
INSERT INTO `language_strings` VALUES (638,'Client.Syntax.MalformedE164Number','de','Ungültige E.164 Nummer. Bitte verwenden Sie nur Zahlen und geben sie den internationalen Prefix mit an.');
INSERT INTO `language_strings` VALUES (639,'Client.Syntax.MalformedE164Number','es','Número E.164 inválido. Por favor, use dígitos exclusivamente e incluya el prefijo internacional.');
INSERT INTO `language_strings` VALUES (640,'Client.Syntax.MalformedE164Number','fr','Numéro E.164.est invalide Utilisez des nombres uniquement en incluant le préfixe international.');
INSERT INTO `language_strings` VALUES (641,'Client.Syntax.MalformedDate','en','Invalid date, please check your syntax.');
INSERT INTO `language_strings` VALUES (642,'Client.Syntax.MalformedDate','de','Ungültiges Datum, bitte überprüfen Sie die Syntax.');
INSERT INTO `language_strings` VALUES (643,'Client.Syntax.MalformedDate','es','Fecha inválida. Por favor, revise la sintaxis.');
INSERT INTO `language_strings` VALUES (644,'Client.Syntax.MalformedDate','fr','La date est invalide, vérifiez votre syntaxe.');
INSERT INTO `language_strings` VALUES (645,'Client.Syntax.MissingNCOSLevel','en','Please specify an NCOS level identifier string.');
INSERT INTO `language_strings` VALUES (646,'Client.Syntax.MissingNCOSLevel','de','Bitte geben Sie eine Bezeichnung für den NCOS Level an.');
INSERT INTO `language_strings` VALUES (647,'Client.Syntax.MissingNCOSLevel','es','Por favor, especifique una cadena identificadora para el nivel NCOS.');
INSERT INTO `language_strings` VALUES (648,'Client.Syntax.MissingNCOSLevel','fr','Spécifiez une série d\'identificateur de niveau de NCOS.');
INSERT INTO `language_strings` VALUES (649,'Client.NCOS.ExistingLevel','en','The NCOS level already exists.');
INSERT INTO `language_strings` VALUES (650,'Client.NCOS.ExistingLevel','de','Die NCOS Level Bezeichnung existiert bereits.');
INSERT INTO `language_strings` VALUES (651,'Client.NCOS.ExistingLevel','es','El nivel NCOS ya existe.');
INSERT INTO `language_strings` VALUES (652,'Client.NCOS.ExistingLevel','fr','Le niveau de NCOS existe déjà.');
INSERT INTO `language_strings` VALUES (653,'Client.NCOS.NoSuchLevel','en','The NCOS level does not exist.');
INSERT INTO `language_strings` VALUES (654,'Client.NCOS.NoSuchLevel','de','Die NCOS Level Bezeichnung existiert nicht.');
INSERT INTO `language_strings` VALUES (655,'Client.NCOS.NoSuchLevel','es','El nivel NCOS no existe.');
INSERT INTO `language_strings` VALUES (656,'Client.NCOS.NoSuchLevel','fr','The NCOS level does not exist.');
INSERT INTO `language_strings` VALUES (657,'Web.NCOSLevel.Created','en','The NCOS level has been created.');
INSERT INTO `language_strings` VALUES (658,'Web.NCOSLevel.Created','de','Der NCOS Level wurde erstellt.');
INSERT INTO `language_strings` VALUES (659,'Web.NCOSLevel.Created','es','El nivel NCOS ha sido creado.');
INSERT INTO `language_strings` VALUES (660,'Web.NCOSLevel.Created','fr','Le niveau de NCOS a été créé.');
INSERT INTO `language_strings` VALUES (661,'Web.NCOSLevel.Updated','en','The NCOS level has been changed.');
INSERT INTO `language_strings` VALUES (662,'Web.NCOSLevel.Updated','de','Der NCOS Level wurde geändert.');
INSERT INTO `language_strings` VALUES (663,'Web.NCOSLevel.Updated','es','El nivel NCOS ha sido modificado.');
INSERT INTO `language_strings` VALUES (664,'Web.NCOSLevel.Updated','fr','Le niveau de NCOS a été changé.');
INSERT INTO `language_strings` VALUES (665,'Web.NCOSLevel.Deleted','en','The NCOS level has been deleted.');
INSERT INTO `language_strings` VALUES (666,'Web.NCOSLevel.Deleted','de','Der NCOS Level wurde gelöscht.');
INSERT INTO `language_strings` VALUES (667,'Web.NCOSLevel.Deleted','es','El nivel NCOS ha sido eliminado.');
INSERT INTO `language_strings` VALUES (668,'Web.NCOSLevel.Deleted','fr','Le niveau de NCOS a été supprimé.');
INSERT INTO `language_strings` VALUES (669,'Web.NCOSPattern.Created','en','The pattern has been stored.');
INSERT INTO `language_strings` VALUES (670,'Web.NCOSPattern.Created','de','Der Filter wurde gespeichert.');
INSERT INTO `language_strings` VALUES (671,'Web.NCOSPattern.Created','es','El patrón ha sido guardado.');
INSERT INTO `language_strings` VALUES (672,'Web.NCOSPattern.Created','fr','Le modèle a été stocké.');
INSERT INTO `language_strings` VALUES (673,'Web.NCOSPattern.Updated','en','The pattern has been replaced.');
INSERT INTO `language_strings` VALUES (674,'Web.NCOSPattern.Updated','de','Der Filter wurde ersetzt.');
INSERT INTO `language_strings` VALUES (675,'Web.NCOSPattern.Updated','es','El patrón ha sido modificado.');
INSERT INTO `language_strings` VALUES (676,'Web.NCOSPattern.Updated','fr','Le modèle a été remplacé.');
INSERT INTO `language_strings` VALUES (677,'Web.NCOSPattern.Deleted','en','The pattern has been deleted.');
INSERT INTO `language_strings` VALUES (678,'Web.NCOSPattern.Deleted','de','Der Filter wurde entfernt.');
INSERT INTO `language_strings` VALUES (679,'Web.NCOSPattern.Deleted','es','El patrón ha sido eliminado.');
INSERT INTO `language_strings` VALUES (680,'Web.NCOSPattern.Deleted','fr','Le modèle a été supprimé.');
INSERT INTO `language_strings` VALUES (681,'Web.NCOSLNP.Created','en','The provider has been added to the list.');
INSERT INTO `language_strings` VALUES (682,'Web.NCOSLNP.Created','de','Der LNP Provider wurde der Liste hinzugefügt.');
INSERT INTO `language_strings` VALUES (683,'Web.NCOSLNP.Created','es','El proveedor ha sido añadido a la lista.');
INSERT INTO `language_strings` VALUES (684,'Web.NCOSLNP.Created','fr','Le fournisseur a été ajouté à la liste.');
INSERT INTO `language_strings` VALUES (685,'Web.NCOSLNP.Updated','en','The provider has been updated.');
INSERT INTO `language_strings` VALUES (686,'Web.NCOSLNP.Updated','de','Der LNP Provider wurde geändert.');
INSERT INTO `language_strings` VALUES (687,'Web.NCOSLNP.Updated','es','El proveedor ha sido modificado.');
INSERT INTO `language_strings` VALUES (688,'Web.NCOSLNP.Updated','fr','Le fournisseur a été mis à jour.');
INSERT INTO `language_strings` VALUES (689,'Web.NCOSLNP.Deleted','en','The provider has been removed from the list.');
INSERT INTO `language_strings` VALUES (690,'Web.NCOSLNP.Deleted','de','Der LNP Provider wurde von der Liste entfernt.');
INSERT INTO `language_strings` VALUES (691,'Web.NCOSLNP.Deleted','es','El proveedor ha sido eliminado de la lista.');
INSERT INTO `language_strings` VALUES (692,'Web.NCOSLNP.Deleted','fr','Le fournisseur a été enlevé de la liste.');
INSERT INTO `language_strings` VALUES (693,'Client.Syntax.MalformedNCOSPattern','en','The pattern may not be empty, please specify a regular expression.');
INSERT INTO `language_strings` VALUES (694,'Client.Syntax.MalformedNCOSPattern','de','Der Filter darf nicht leer sein, bitte geben Sie einen regulären Ausdruck an.');
INSERT INTO `language_strings` VALUES (695,'Client.Syntax.MalformedNCOSPattern','es','El patrón podría no estar vacío. Por favor, introduzca una expresión regular.');
INSERT INTO `language_strings` VALUES (696,'Client.Syntax.MalformedNCOSPattern','fr','Le modèle ne peut pas être vide, spécifiez une expression régulière.');
INSERT INTO `language_strings` VALUES (697,'Client.Syntax.MalformedAudioData','en','Invalid audio data, please provide an audio stream in wave format.');
INSERT INTO `language_strings` VALUES (698,'Client.Syntax.MalformedAudioData','de','Ungültige Audio-Daten, bitte geben Sie einen Stream im Wave-Format an.');
INSERT INTO `language_strings` VALUES (699,'Client.Syntax.MalformedAudioData','es','Audio incorrecto. Por favor proporcione un flujo de audio en formato wav.');
INSERT INTO `language_strings` VALUES (700,'Client.Syntax.MalformedAudioData','fr','Données audio invalides, fournissez un format audio courant.');
INSERT INTO `language_strings` VALUES (701,'Client.Voip.ExistingAudioFile','en','The audio file handle is already in use.');
INSERT INTO `language_strings` VALUES (702,'Client.Voip.ExistingAudioFile','de','Der Audio-Datei-Identifikator wird bereits verwendet.');
INSERT INTO `language_strings` VALUES (703,'Client.Voip.ExistingAudioFile','es','El fichero de audio ya está en uso.');
INSERT INTO `language_strings` VALUES (704,'Client.Voip.ExistingAudioFile','fr','Le fichier audio traité est déjà dans.');
INSERT INTO `language_strings` VALUES (705,'Client.Voip.NoSuchAudioFile','en','The audio file handle does not exist.');
INSERT INTO `language_strings` VALUES (706,'Client.Voip.NoSuchAudioFile','de','Der Audio-Datei-Identifikator existiert noch nicht.');
INSERT INTO `language_strings` VALUES (707,'Client.Voip.NoSuchAudioFile','es','El fichero de audio no existe.');
INSERT INTO `language_strings` VALUES (708,'Client.Voip.NoSuchAudioFile','fr','Le fichier audio traité n\'existe pas.');
INSERT INTO `language_strings` VALUES (709,'Web.AudioFile.Created','en','The audio file has been created.');
INSERT INTO `language_strings` VALUES (710,'Web.AudioFile.Created','de','Die Audio-Datei wurde gespeichert.');
INSERT INTO `language_strings` VALUES (711,'Web.AudioFile.Created','es','El fichero de audio ha sido creado.');
INSERT INTO `language_strings` VALUES (712,'Web.AudioFile.Created','fr','Le fichier audio a été créé.');
INSERT INTO `language_strings` VALUES (713,'Web.AudioFile.Updated','en','The audio file has been changed.');
INSERT INTO `language_strings` VALUES (714,'Web.AudioFile.Updated','de','Die Audio-Datei wurde geändert.');
INSERT INTO `language_strings` VALUES (715,'Web.AudioFile.Updated','es','El fichero de audio ha sido modificado.');
INSERT INTO `language_strings` VALUES (716,'Web.AudioFile.Updated','fr','Le fichier audio a été changé.');
INSERT INTO `language_strings` VALUES (717,'Web.AudioFile.Deleted','en','The audio file has been deleted.');
INSERT INTO `language_strings` VALUES (718,'Web.AudioFile.Deleted','de','Die Audio-Datei wurde gelöscht.');
INSERT INTO `language_strings` VALUES (719,'Web.AudioFile.Deleted','es','El fichero de audio ha sido eliminado.');
INSERT INTO `language_strings` VALUES (720,'Web.AudioFile.Deleted','fr','Le fichier audio a été supprimé.');
INSERT INTO `language_strings` VALUES (721,'Client.Syntax.MalformedHandle','en','Invalid handle, please specify an alpha-numeric string.');
INSERT INTO `language_strings` VALUES (722,'Client.Syntax.MalformedHandle','de','Ungültiger Identifikator, bitte geben Sie eine alphanumerische Zeichenkette ein.');
INSERT INTO `language_strings` VALUES (723,'Client.Syntax.MalformedHandle','es','Nombre incorrecto. Por favor use caracteres alfanuméricos exclusivamente.');
INSERT INTO `language_strings` VALUES (724,'Client.Syntax.MalformedHandle','fr','Traitement invalide, spécifiez une série alphanumérique.');
INSERT INTO `language_strings` VALUES (725,'Client.VSC.NoSuchAction','en','The VSC action does not exist.');
INSERT INTO `language_strings` VALUES (726,'Client.VSC.NoSuchAction','de','Die VSC Aktion existiert nicht.');
INSERT INTO `language_strings` VALUES (727,'Client.VSC.NoSuchAction','es','La acción VSC no existe.');
INSERT INTO `language_strings` VALUES (728,'Client.VSC.NoSuchAction','fr','L\'action VSC n\'existe pas.');
INSERT INTO `language_strings` VALUES (729,'Client.VSC.ExistingAction','en','The VSC action has already been defined.');
INSERT INTO `language_strings` VALUES (730,'Client.VSC.ExistingAction','de','Die VSC Aktion wurde bereits definiert.');
INSERT INTO `language_strings` VALUES (731,'Client.VSC.ExistingAction','es','La acción VSC ya ha sido definida.');
INSERT INTO `language_strings` VALUES (732,'Client.VSC.ExistingAction','fr','L\'action VSC a déjà été définie.');
INSERT INTO `language_strings` VALUES (733,'Client.VSC.ExistingDigits','en','The digits are already in use for another VSC action.');
INSERT INTO `language_strings` VALUES (734,'Client.VSC.ExistingDigits','de','Die Zahlenkombination wird bereits für eine andere VSC Aktion verwendet.');
INSERT INTO `language_strings` VALUES (735,'Client.VSC.ExistingDigits','es','Los dígitos ya se encuentran definidos para otra acción VSC.');
INSERT INTO `language_strings` VALUES (736,'Client.VSC.ExistingDigits','fr','Les chiffres sont déjà en cours d’utilisation pour une autre action de VSC.');
INSERT INTO `language_strings` VALUES (737,'Client.Syntax.MalformedVSCDigits','en','Invalid VSC digits setting, please specify exactly two digits.');
INSERT INTO `language_strings` VALUES (738,'Client.Syntax.MalformedVSCDigits','de','Ungültige Zahlenkombination, bitte geben Sie genau zwei Ziffern an.');
INSERT INTO `language_strings` VALUES (739,'Client.Syntax.MalformedVSCDigits','es','Especificación de dígitos inválida. Por favor, especifica exactamente dos dígitos.');
INSERT INTO `language_strings` VALUES (740,'Client.Syntax.MalformedVSCDigits','fr','La configuration de chiffres VSC est invalide, spécifiez exactement deux chiffres.');
INSERT INTO `language_strings` VALUES (741,'Web.VSC.Created','en','The VSC entry has been created.');
INSERT INTO `language_strings` VALUES (742,'Web.VSC.Created','de','Der VSC Eintrag wurde gespeichert.');
INSERT INTO `language_strings` VALUES (743,'Web.VSC.Created','es','La entrada VSC ha sido creada.');
INSERT INTO `language_strings` VALUES (744,'Web.VSC.Created','fr','L\'entrée VSC a été créée.');
INSERT INTO `language_strings` VALUES (745,'Web.VSC.Updated','en','The VSC entry has been changed.');
INSERT INTO `language_strings` VALUES (746,'Web.VSC.Updated','de','Der VSC Eintrag wurde geändert.');
INSERT INTO `language_strings` VALUES (747,'Web.VSC.Updated','es','La entrada VSC ha sido modificada.');
INSERT INTO `language_strings` VALUES (748,'Web.VSC.Updated','fr','L\'entrée VSC a été changée.');
INSERT INTO `language_strings` VALUES (749,'Web.VSC.Deleted','en','The VSC entry has been deleted.');
INSERT INTO `language_strings` VALUES (750,'Web.VSC.Deleted','de','Der VSC Eintrag wurde gelöscht.');
INSERT INTO `language_strings` VALUES (751,'Web.VSC.Deleted','es','La entrada VSC ha sido eliminada.');
INSERT INTO `language_strings` VALUES (752,'Web.VSC.Deleted','fr','L\'entrée VSC a été supprimée.');
INSERT INTO `language_strings` VALUES (753,'Client.Voip.AudioFileInUse','en','The audio file is in use and can\'t be deleted.');
INSERT INTO `language_strings` VALUES (754,'Client.Voip.AudioFileInUse','de','Die Audio-Datei wird verwendet und kann nicht gelöscht werden.');
INSERT INTO `language_strings` VALUES (755,'Client.Voip.AudioFileInUse','es','El fichero de audio se encuentra actualmente en uso y no puede ser eliminado.');
INSERT INTO `language_strings` VALUES (756,'Client.Voip.AudioFileInUse','fr','Le fichier audio est en cours d\'utilisation et ne peut pas être supprimé.');
INSERT INTO `language_strings` VALUES (757,'Web.Contract.Created','en','The contract has been created.');
INSERT INTO `language_strings` VALUES (758,'Web.Contract.Created','de','Der Vertrag wurde gespeichert.');
INSERT INTO `language_strings` VALUES (759,'Web.Contract.Created','es','El contrato ha sido creado.');
INSERT INTO `language_strings` VALUES (760,'Web.Contract.Created','fr','Le contrat a été créé.');
INSERT INTO `language_strings` VALUES (761,'Web.Contract.Updated','en','The contract has been changed.');
INSERT INTO `language_strings` VALUES (762,'Web.Contract.Updated','de','Der Vertrag wurde geändert.');
INSERT INTO `language_strings` VALUES (763,'Web.Contract.Updated','es','El contrato ha sido modificado.');
INSERT INTO `language_strings` VALUES (764,'Web.Contract.Updated','fr','Le contrat a été changé.');
INSERT INTO `language_strings` VALUES (765,'Web.Contract.Deleted','en','The contract has been deleted.');
INSERT INTO `language_strings` VALUES (766,'Web.Contract.Deleted','de','Der Vertrag wurde gelöscht.');
INSERT INTO `language_strings` VALUES (767,'Web.Contract.Deleted','es','El contrato ha sido eliminado.');
INSERT INTO `language_strings` VALUES (768,'Web.Contract.Deleted','fr','Le contrat a été supprimé.');
INSERT INTO `language_strings` VALUES (769,'Web.NCOSLevel.LACSet','en','The caller\'s area code has been added to the list.');
INSERT INTO `language_strings` VALUES (770,'Web.NCOSLevel.LACSet','de','Die Vorwahl des Anrufers wurde zur Liste hinzugefügt.');
INSERT INTO `language_strings` VALUES (771,'Web.NCOSLevel.LACSet','es','El código de área de llamante ha sido añadido a la lista.');
INSERT INTO `language_strings` VALUES (772,'Web.NCOSLevel.LACSet','fr','L\'indicatif de l\'interlocuteur a été ajouté à la liste.');
INSERT INTO `language_strings` VALUES (773,'Web.NCOSLevel.LACUnset','en','The caller\'s area code has been removed from the list.');
INSERT INTO `language_strings` VALUES (774,'Web.NCOSLevel.LACUnset','de','Die Vorwahl des Anrufers wurde von der Liste entfernt.');
INSERT INTO `language_strings` VALUES (775,'Web.NCOSLevel.LACUnset','es','El código de área de llamante ha sido eliminado de la lista.');
INSERT INTO `language_strings` VALUES (776,'Web.NCOSLevel.LACUnset','fr','L\'indicatif de l\'interlocuteur a été enlevé de la liste.');
INSERT INTO `language_strings` VALUES (777,'Web.NumberBlock.Created','en','The number block has been created.');
INSERT INTO `language_strings` VALUES (778,'Web.NumberBlock.Created','de','Der Nummernblock wurde gespeichert.');
INSERT INTO `language_strings` VALUES (779,'Web.NumberBlock.Created','es','El bloque de numeración ha sido creado.');
INSERT INTO `language_strings` VALUES (780,'Web.NumberBlock.Created','fr','Le bloc de numéro a été créé.');
INSERT INTO `language_strings` VALUES (781,'Web.NumberBlock.Updated','en','The number block has been changed.');
INSERT INTO `language_strings` VALUES (782,'Web.NumberBlock.Updated','de','Der Nummernblock wurde geändert.');
INSERT INTO `language_strings` VALUES (783,'Web.NumberBlock.Updated','es','El bloque de numeración ha sido modificado.');
INSERT INTO `language_strings` VALUES (784,'Web.NumberBlock.Updated','fr','Le bloc de numéro a été changé.');
INSERT INTO `language_strings` VALUES (785,'Web.NumberBlock.Deleted','en','The number block has been deleted.');
INSERT INTO `language_strings` VALUES (786,'Web.NumberBlock.Deleted','de','Der Nummernblock wurde gelöscht.');
INSERT INTO `language_strings` VALUES (787,'Web.NumberBlock.Deleted','es','El bloque de numeración ha sido eliminado.');
INSERT INTO `language_strings` VALUES (788,'Web.NumberBlock.Deleted','fr','Le bloc de numéro a été supprimé.');
INSERT INTO `language_strings` VALUES (789,'Client.Syntax.MalformedReminderTime','en','Invalid time string, please use \'hh:mm\' format.');
INSERT INTO `language_strings` VALUES (790,'Client.Syntax.MalformedReminderTime','de','Ungültige Zeitangabe, bitte verwenden Sie das \'hh:mm\' Format.');
INSERT INTO `language_strings` VALUES (791,'Client.Syntax.MalformedReminderTime','es','Formato de tiempo inválido. Por favor, utilice el formato \'hh:mm\'.');
INSERT INTO `language_strings` VALUES (792,'Client.Syntax.MalformedReminderTime','fr','Série de temps invalide, utiliser le format de \'hh:mm\'.');
INSERT INTO `language_strings` VALUES (793,'Web.Fax.ExistingFaxDestination','en','This destination is already on the list.');
INSERT INTO `language_strings` VALUES (794,'Web.Fax.ExistingFaxDestination','de','Dieses Destination steht bereits auf der Liste.');
INSERT INTO `language_strings` VALUES (795,'Web.Fax.ExistingFaxDestination','es','Este destino ya se encuentra en la lista.');
INSERT INTO `language_strings` VALUES (796,'Web.Fax.ExistingFaxDestination','fr','Cette destination est déjà dans la liste.');
INSERT INTO `language_strings` VALUES (797,'Client.Voip.ReservedSubscriber','en','This username is reserved for internal use.');
INSERT INTO `language_strings` VALUES (798,'Client.Voip.ReservedSubscriber','de','Dieser Username ist für interne Verwendung reserviert.');
INSERT INTO `language_strings` VALUES (799,'Client.Voip.ReservedSubscriber','es','El nombre de usuario está reservado para uso interno.');
INSERT INTO `language_strings` VALUES (800,'Client.Voip.ReservedSubscriber','fr','Ce non d’utilisateur est réservé pour l’utilisation interne.');
INSERT INTO `language_strings` VALUES (801,'Server.Voip.NoProxy','de','Es wurde kein SIP Proxy für Click-To-Dial konfiguriert.');
INSERT INTO `language_strings` VALUES (802,'Server.Voip.NoProxy','en','No SIP Proxy has been configured for click-to-dial.');
INSERT INTO `language_strings` VALUES (803,'Server.Voip.NoProxy','es','No se ha configurado ningún proxy SIP para click-to-dial.');
INSERT INTO `language_strings` VALUES (804,'Server.Voip.NoProxy','fr','Aucun SIP Proxy n\'a été configuré pour Cliquer et composer le numéro.');
INSERT INTO `language_strings` VALUES (805,'Client.Fees.DuplicateDestination','de','Ein Ziel-Präfix / -Suffix wurde mehrfach angegeben.');
INSERT INTO `language_strings` VALUES (806,'Client.Fees.DuplicateDestination','en','A destination prefix/suffix has been specified twice.');
INSERT INTO `language_strings` VALUES (807,'Client.Fees.DuplicateDestination','es','Prefijo/sufijo de destino duplicado.');
INSERT INTO `language_strings` VALUES (808,'Client.Fees.DuplicateDestination','fr','Un préfixe/suffixe de destination a été spécifié deux fois.');
INSERT INTO `language_strings` VALUES (809,'Client.Billing.ExistingExternalCID','en','This external ID is already in use for another customer.');
INSERT INTO `language_strings` VALUES (810,'Client.Billing.ExistingExternalCID','de','Diese externe ID ist bereits bei einem anderen Kunden in Verwendung.');
INSERT INTO `language_strings` VALUES (811,'Client.Billing.ExistingExternalCID','es','Este ID externo ya está siendo usado por otro cliente.');
INSERT INTO `language_strings` VALUES (812,'Client.Billing.ExistingExternalCID','fr','Cet ID externe est déjà utilisé pour un autre client.');
INSERT INTO `language_strings` VALUES (813,'Client.Billing.ExistingExternalAID','en','This external ID is already in use for another account.');
INSERT INTO `language_strings` VALUES (814,'Client.Billing.ExistingExternalAID','de','Diese externe ID ist bereits bei einem anderen Vertrag in Verwendung.');
INSERT INTO `language_strings` VALUES (815,'Client.Billing.ExistingExternalAID','es','Este ID externo ya está siendo usado por otra cuenta.');
INSERT INTO `language_strings` VALUES (816,'Client.Billing.ExistingExternalAID','fr','Cet ID externe est déjà utilisé pour un autre compte.');
INSERT INTO `language_strings` VALUES (817,'Client.Billing.ExistingExternalSID','en','This external ID is already in use for another subscriber.');
INSERT INTO `language_strings` VALUES (818,'Client.Billing.ExistingExternalSID','de','Diese externe ID ist bereits bei einem anderen Subscriber in Verwendung.');
INSERT INTO `language_strings` VALUES (819,'Client.Billing.ExistingExternalSID','es','Este ID externo ya está siendo usado por otro subscriptor.');
INSERT INTO `language_strings` VALUES (820,'Client.Billing.ExistingExternalSID','fr','Cet ID externe est déjà utilisé pour un autre abonné.');
INSERT INTO `language_strings` VALUES (821,'Web.Syntax.MissingExternalID','en','Please enter an external ID in the search box.');
INSERT INTO `language_strings` VALUES (822,'Web.Syntax.MissingExternalID','de','Bitte geben Sie eine externe ID in das Suchfeld ein.');
INSERT INTO `language_strings` VALUES (823,'Web.Syntax.MissingExternalID','es','Por favor, introduzca un ID externo en el campo de búsqueda.');
INSERT INTO `language_strings` VALUES (824,'Web.Syntax.MissingExternalID','fr','Entrez ID externe dans la boîte de recherche.');
INSERT INTO `language_strings` VALUES (825,'Client.Voip.ExistingRewriteRuleSet','en','The rewrite rule set name is already in use.');
INSERT INTO `language_strings` VALUES (826,'Client.Voip.ExistingRewriteRuleSet','de','Der Name ist bereits für ein anderes Regelset in Verwendung.');
INSERT INTO `language_strings` VALUES (827,'Client.Voip.ExistingRewriteRuleSet','es','El nombre de grupo de reglas de reescritura ya está en uso.');
INSERT INTO `language_strings` VALUES (828,'Client.Voip.ExistingRewriteRuleSet','fr','Le groupe rewrite rule est déja utilisé.');
INSERT INTO `language_strings` VALUES (829,'Client.Voip.NoSuchRewriteRuleSet','en','The rewrite rule set does not exist.');
INSERT INTO `language_strings` VALUES (830,'Client.Voip.NoSuchRewriteRuleSet','de','Das angegebene Regelset existiert nicht.');
INSERT INTO `language_strings` VALUES (831,'Client.Voip.NoSuchRewriteRuleSet','es','El grupo de reglas de reescritura no existe.');
INSERT INTO `language_strings` VALUES (832,'Client.Voip.NoSuchRewriteRuleSet','fr','Le groupe rewrite rule n’existe pas.');
INSERT INTO `language_strings` VALUES (833,'Client.Voip.NoSuchRewriteRule','en','The rewrite rule does not exist.');
INSERT INTO `language_strings` VALUES (834,'Client.Voip.NoSuchRewriteRule','de','Die angegebene Regel existiert nicht.');
INSERT INTO `language_strings` VALUES (835,'Client.Voip.NoSuchRewriteRule','es','La regla de reescritura no existe.');
INSERT INTO `language_strings` VALUES (836,'Client.Voip.NoSuchRewriteRule','fr','Le rewrite rule n’existe pas');
INSERT INTO `language_strings` VALUES (837,'Web.Rewrite.RuleSetDeleted','en','The rewrite rule set has been deleted.');
INSERT INTO `language_strings` VALUES (838,'Web.Rewrite.RuleSetDeleted','de','Das Regelset wurde gelöscht.');
INSERT INTO `language_strings` VALUES (839,'Web.Rewrite.RuleSetDeleted','es','La regla de reescritura ha sido borrada.');
INSERT INTO `language_strings` VALUES (840,'Web.Rewrite.RuleSetDeleted','fr','Le groupe rewrite rule a été supprimé.');
INSERT INTO `language_strings` VALUES (841,'Web.Fees.InvalidCharset','en','Invalid character set detected, please provide all data in UTF-8 encoding.');
INSERT INTO `language_strings` VALUES (842,'Web.Fees.InvalidCharset','de','Ungültiger Zeichensatz, bitte verwenden Sie für alle Daten die UTF-8 Kodierung.');
INSERT INTO `language_strings` VALUES (843,'Web.Fees.InvalidCharset','es','Detectada codificación de caracter inválida. Por favor, use codificación UTF-8.');
INSERT INTO `language_strings` VALUES (844,'Web.Fees.InvalidCharset','fr','Jeu de caractères non valide détecté, s\'il vous plaît fournir toutes les données en UTF-8.');
INSERT INTO `language_strings` VALUES (845,'Web.Fees.InvalidZone','en','Invalid zone specification, should be a non-empty string');
INSERT INTO `language_strings` VALUES (846,'Web.Fees.InvalidZone','de','Ungültige Zonenbeschreibung, bitte geben Sie einen Text ein');
INSERT INTO `language_strings` VALUES (847,'Web.Fees.InvalidZone','es','Zona especificada no válida. Debe ser una cadena de caracteres no vacía.');
INSERT INTO `language_strings` VALUES (848,'Web.Fees.InvalidZone','fr','Zone de la spécification non valide détecté. Doit être une chaîne non vide.');
INSERT INTO `language_strings` VALUES (849,'Web.Fees.InvalidZoneDetail','en','Invalid zone detail specification, should be a non-empty string');
INSERT INTO `language_strings` VALUES (850,'Web.Fees.InvalidZoneDetail','de','Ungültige Zonendetailbeschreibung, bitte geben Sie einen Text ein');
INSERT INTO `language_strings` VALUES (851,'Web.Fees.InvalidZoneDetail','es','Detalle de zona especificada no válida. Debe ser una cadena de caracteres no vacía.');
INSERT INTO `language_strings` VALUES (852,'Web.Fees.InvalidZoneDetail','fr','Invalid Spécification de zone, doit être une chaîne non vide.');
INSERT INTO `language_strings` VALUES (853,'Web.Fees.InvalidRate','en','Invalid rate specification, should be a floating point number');
INSERT INTO `language_strings` VALUES (854,'Web.Fees.InvalidRate','de','Ungültige Gebührenangabe, bitte geben Sie eine Gleitpunktzahl ein');
INSERT INTO `language_strings` VALUES (855,'Web.Fees.InvalidRate','es','Campo rate inválido. Debe ser un número flotante.');
INSERT INTO `language_strings` VALUES (856,'Web.Fees.InvalidRate','fr','Invalid spécification du taux, devrait être un nombre à virgule flottante');
INSERT INTO `language_strings` VALUES (857,'Web.Fees.InvalidInterval','en','Invalid interval specification, should be an integer');
INSERT INTO `language_strings` VALUES (858,'Web.Fees.InvalidInterval','de','Ungültige Intervallangabe, bitte geben Sie eine Ganzzahl ein');
INSERT INTO `language_strings` VALUES (859,'Web.Fees.InvalidInterval','es','Intervalo especificado inválido. Debe ser un número entero.');
INSERT INTO `language_strings` VALUES (860,'Web.Fees.InvalidInterval','fr','Invalide la spécification d\'intervalle, doit être un entier');
INSERT INTO `language_strings` VALUES (861,'Client.Syntax.InvalidYear','en','Invalid year.');
INSERT INTO `language_strings` VALUES (862,'Client.Syntax.InvalidYear','de','Ungültiges Jahr.	');
INSERT INTO `language_strings` VALUES (863,'Client.Syntax.InvalidYear','es','Año inválido');
INSERT INTO `language_strings` VALUES (864,'Client.Syntax.InvalidYear','fr','Invalid year.');
INSERT INTO `language_strings` VALUES (865,'Client.Syntax.InvalidMonth','en','Invalid month.');
INSERT INTO `language_strings` VALUES (866,'Client.Syntax.InvalidMonth','de','Ungültiges Monat.');
INSERT INTO `language_strings` VALUES (867,'Client.Syntax.InvalidMonth','es','Mes no válido');
INSERT INTO `language_strings` VALUES (868,'Client.Syntax.InvalidMonth','fr','Invalid month.');
INSERT INTO `language_strings` VALUES (869,'Client.Syntax.InvalidMDay','en','Invalid day of month.');
INSERT INTO `language_strings` VALUES (870,'Client.Syntax.InvalidMDay','de','Ungültiger Tag.	');
INSERT INTO `language_strings` VALUES (871,'Client.Syntax.InvalidMDay','es','Día del mes no válido');
INSERT INTO `language_strings` VALUES (872,'Client.Syntax.InvalidMDay','fr','Invalid day of month.');
INSERT INTO `language_strings` VALUES (873,'Client.Syntax.InvalidWDay','en','Invalid day of week.');
INSERT INTO `language_strings` VALUES (874,'Client.Syntax.InvalidWDay','de','Ungültiger Wochentagl');
INSERT INTO `language_strings` VALUES (875,'Client.Syntax.InvalidWDay','es','Día de la semana no válido');
INSERT INTO `language_strings` VALUES (876,'Client.Syntax.InvalidWDay','fr','Invalid day of week.');
INSERT INTO `language_strings` VALUES (877,'Client.Syntax.InvalidHour','en','Invalid hour.');
INSERT INTO `language_strings` VALUES (878,'Client.Syntax.InvalidHour','de','Ungültige Stunde.');
INSERT INTO `language_strings` VALUES (879,'Client.Syntax.InvalidHour','es','Hora no válida');
INSERT INTO `language_strings` VALUES (880,'Client.Syntax.InvalidHour','fr','Invalid hour.');
INSERT INTO `language_strings` VALUES (881,'Client.Syntax.InvalidMinute','en','Invalid minute.');
INSERT INTO `language_strings` VALUES (882,'Client.Syntax.InvalidMinute','de','Ungültige Minute.');
INSERT INTO `language_strings` VALUES (883,'Client.Syntax.InvalidMinute','es','Minuto no válido');
INSERT INTO `language_strings` VALUES (884,'Client.Syntax.InvalidMinute','fr','Invalid minute.');
INSERT INTO `language_strings` VALUES (885,'Client.Syntax.FromMissing','en','Beginning missing.');
INSERT INTO `language_strings` VALUES (886,'Client.Syntax.FromMissing','de','Beginn fehlt.');
INSERT INTO `language_strings` VALUES (887,'Client.Syntax.FromMissing','es','Falta el inicio');
INSERT INTO `language_strings` VALUES (888,'Client.Syntax.FromMissing','fr','Beginning missing.');
INSERT INTO `language_strings` VALUES (889,'Client.Syntax.FromAfterTo','en','Beginning after End.');
INSERT INTO `language_strings` VALUES (890,'Client.Syntax.FromAfterTo','de','Beginn nach Ende.');
INSERT INTO `language_strings` VALUES (891,'Client.Syntax.FromAfterTo','es','Inicio después de final');
INSERT INTO `language_strings` VALUES (892,'Client.Syntax.FromAfterTo','fr','Beginning after End.');
INSERT INTO `language_strings` VALUES (893,'Client.Syntax.EmptySetName','en','Setname can not be empty.');
INSERT INTO `language_strings` VALUES (894,'Client.Syntax.EmptySetName','de','Setname darf nicht leer sein.');
INSERT INTO `language_strings` VALUES (895,'Client.Syntax.EmptySetName','es','No se ha asignado un nombre');
INSERT INTO `language_strings` VALUES (896,'Client.Syntax.EmptySetName','fr','Setname can not be empty.');
INSERT INTO `language_strings` VALUES (897,'Client.Syntax.MissingDestinationSet','en','Please choose a destination set.');
INSERT INTO `language_strings` VALUES (898,'Client.Syntax.MissingDestinationSet','de','Bitte wählen Sie eine Zielgruppe.');
INSERT INTO `language_strings` VALUES (899,'Client.Syntax.MissingDestinationSet','es','Por favor, elija un grupo de destinos');
INSERT INTO `language_strings` VALUES (900,'Client.Syntax.MissingDestinationSet','fr','Please choose a destination set.');
INSERT INTO `language_strings` VALUES (901,'Client.Syntax.UnknownProtocol','en','Unknown protocol');
INSERT INTO `language_strings` VALUES (902,'Client.Syntax.UnknownProtocol','de','Unbekanntes Protokoll');
INSERT INTO `language_strings` VALUES (903,'Client.Syntax.UnknownProtocol','es','Protocolo desconocido');
INSERT INTO `language_strings` VALUES (904,'Client.Syntax.UnknownProtocol','fr','Unknown protocol');
INSERT INTO `language_strings` VALUES (905,'Client.Voip.InvalidEnum','en','Invalid enum');
INSERT INTO `language_strings` VALUES (906,'Client.Voip.InvalidEnum','de','Ungültiger Wert');
INSERT INTO `language_strings` VALUES (907,'Client.Voip.InvalidEnum','es','Valor inválido');
INSERT INTO `language_strings` VALUES (908,'Client.Voip.InvalidEnum','fr','Invalid enum');
INSERT INTO `language_strings` VALUES (909,'Client.Syntax.UnknownLock','en','Unknown locklevel');
INSERT INTO `language_strings` VALUES (910,'Client.Syntax.UnknownLock','de','Unbekannter Locklevel');
INSERT INTO `language_strings` VALUES (911,'Client.Syntax.UnknownLock','fr','Unknown locklevel');
INSERT INTO `language_strings` VALUES (912,'Client.Syntax.UnknownLock','es','Nivel de bloqueo inválido');
INSERT INTO `language_strings` VALUES (913,'Server.Voip.SoundSetDeleted','en','Soundset deleted');
INSERT INTO `language_strings` VALUES (914,'Server.Voip.SoundSetDeleted','de','Soundset gelöscht');
INSERT INTO `language_strings` VALUES (915,'Server.Voip.SoundSetDeleted','fr','Soundset deleted');
INSERT INTO `language_strings` VALUES (916,'Server.Voip.SoundSetDeleted','es','Grupo de locuciones eliminado');
INSERT INTO `language_strings` VALUES (917,'Server.Voip.SoundSetMapped','en','Soundset still mapped');
INSERT INTO `language_strings` VALUES (918,'Server.Voip.SoundSetMapped','de','Soundset in Verwendung');
INSERT INTO `language_strings` VALUES (919,'Server.Voip.SoundSetMapped','fr','Soundset still mapped');
INSERT INTO `language_strings` VALUES (920,'Server.Voip.SoundSetMapped','es','El grupo de locuciones aún está asignado');
INSERT INTO `language_strings` VALUES (921,'Server.Voip.NoSuchSoundSet','en','Soundset does not exist ');
INSERT INTO `language_strings` VALUES (922,'Server.Voip.NoSuchSoundSet','de','Soundset existiert nicht ');
INSERT INTO `language_strings` VALUES (923,'Server.Voip.NoSuchSoundSet','fr','Soundset does not exist ');
INSERT INTO `language_strings` VALUES (924,'Server.Voip.NoSuchSoundSet','es','El grupo de locuciones no existe');
INSERT INTO `language_strings` VALUES (925,'Client.Syntax.MissingSoundFile','en','Soundfile missing ');
INSERT INTO `language_strings` VALUES (926,'Client.Syntax.MissingSoundFile','de','Soundfile fehlt ');
INSERT INTO `language_strings` VALUES (927,'Client.Syntax.MissingSoundFile','es','Locución no encontrada');
INSERT INTO `language_strings` VALUES (928,'Client.Syntax.MissingSoundFile','fr','Soundfile missing ');
INSERT INTO `language_strings` VALUES (929,'Client.Syntax.InvalidE164Number','en','Invalid E.164 Number');
INSERT INTO `language_strings` VALUES (930,'Client.Syntax.InvalidE164Number','de','Ungültige E.164 Nummer');
INSERT INTO `language_strings` VALUES (931,'Client.Syntax.InvalidE164Number','es','Número E164 inválido');
INSERT INTO `language_strings` VALUES (932,'Client.Syntax.InvalidE164Number','fr','Invalid E.164 Number');
INSERT INTO `language_strings` VALUES (933,'Client.Syntax.InvalidSipUsernamePattern','en','Invalid SIP username pattern, please use numbers, letters, \"*\", \"?\" and bracket expressions only. Bracket expressions may contain single characters, ranges and the leading negation. Eg.: [0-9a-z], [^abc].');
INSERT INTO `language_strings` VALUES (934,'Client.Syntax.InvalidSipUsernamePattern','de','Ungültiges SIP username Muster, bitte verwenden Sie nur Ziffern, Buchstaben, \"*\", \"?\" und Klammerausdrücke. In Klammerausdrücke erlaubt sind einzelne Zeichen, Bereiche und Negation. Zb: [0-9a-z], [^abc].');
INSERT INTO `language_strings` VALUES (935,'Client.Syntax.InvalidSipUsernamePattern','es','Patrón de usuario SIP no válido. Por favor, use números, letras, \"*\", \"?\" y corchetes únicamente. Los corchetes pueden contener caracteres, rangos y negaciones. Ej: [0-9a-z], [^abc]');
INSERT INTO `language_strings` VALUES (936,'Client.Syntax.InvalidSipUsernamePattern','fr','Invalid SIP username pattern, please use numbers, letters, \"*\", \"?\" and bracket expressions only. Bracket expressions may contain single characters, ranges and the leading negation. Eg.: [0-9a-z], [^abc].');
INSERT INTO `language_strings` VALUES (937,'Client.Syntax.InvalidSipUsername','en','Invalid sip username');
INSERT INTO `language_strings` VALUES (938,'Client.Syntax.InvalidSipUsername','de','Ungültiger sip username');
INSERT INTO `language_strings` VALUES (939,'Client.Syntax.InvalidSipUsername','es','Usuario SIP no válido');
INSERT INTO `language_strings` VALUES (940,'Client.Syntax.InvalidSipUsername','fr','Invalid sip username');
INSERT INTO `language_strings` VALUES (941,'Client.Voip.ExistingWebUser','en','This webuser is already in use.');
INSERT INTO `language_strings` VALUES (942,'Client.Voip.ExistingWebUser','de','Dieser Webuser ist nicht mehr verfügbar.');
INSERT INTO `language_strings` VALUES (943,'Client.Voip.ExistingWebUser','es','El usuario web ya se encuentra en uso');
INSERT INTO `language_strings` VALUES (944,'Client.Voip.ExistingWebUser','fr','This webuser is already in use.');
INSERT INTO `language_strings` VALUES (945,'Server.Voip.SoundFileExists','en','Soundfile already exists');
INSERT INTO `language_strings` VALUES (946,'Server.Voip.SoundFileExists','de','Soundfile existiert bereits');
INSERT INTO `language_strings` VALUES (947,'Server.Voip.SoundFileExists','fr','Soundfile already exists');
INSERT INTO `language_strings` VALUES (948,'Server.Voip.SoundFileExists','es','La locución ya existe');
INSERT INTO `language_strings` VALUES (949,'Server.System.WaveTranscodeFailed','en','Failed to transcode sound file');
INSERT INTO `language_strings` VALUES (950,'Server.System.WaveTranscodeFailed','de','Transkodieren der Sounddatei fehlgeschlagen');
INSERT INTO `language_strings` VALUES (951,'Server.System.WaveTranscodeFailed','es','Ha fallado la transcodificación de la locución');
INSERT INTO `language_strings` VALUES (952,'Server.System.WaveTranscodeFailed','fr','Failed to transcode sound file');
INSERT INTO `language_strings` VALUES (953,'Client.Syntax.InvalidFileType','en','Invalid file type');
INSERT INTO `language_strings` VALUES (954,'Client.Syntax.InvalidFileType','de','Ungültiger Dateityp');
INSERT INTO `language_strings` VALUES (955,'Client.Syntax.InvalidFileType','es','Tipo de fichero inválido');
INSERT INTO `language_strings` VALUES (956,'Client.Syntax.InvalidFileType','fr','Invalid file type');
INSERT INTO `language_strings` VALUES (957,'Client.Voip.DuplicatePeeringRule','en','This peering rule already exists.');
INSERT INTO `language_strings` VALUES (958,'Client.Voip.DuplicatePeeringRule','de','Diese Peering-Regel existiert bereits.');
INSERT INTO `language_strings` VALUES (959,'Client.Voip.DuplicatePeeringRule','es','Regla de peering duplicada');
INSERT INTO `language_strings` VALUES (960,'Client.Voip.DuplicatePeeringRule','fr','This peering rule already exists.');
INSERT INTO `language_strings` VALUES (961,'Client.Voip.NoSuchSubscriber','en','Subscriber does not exist');
INSERT INTO `language_strings` VALUES (962,'Client.Voip.NoSuchSubscriber','de','Subscriber existiert nicht');
INSERT INTO `language_strings` VALUES (963,'Client.Voip.NoSuchSubscriber','es','No existe el subscriber');
INSERT INTO `language_strings` VALUES (964,'Client.Voip.NoSuchSubscriber','fr','Subscriber does not exist');
INSERT INTO `language_strings` VALUES (965,'Client.Billing.MalformedAmount','it','Per favore specificare l\'ammontare con un numero intero.');
INSERT INTO `language_strings` VALUES (966,'Client.Billing.NoPayType','it','Per favore scegliere un tipo di pagamento.');
INSERT INTO `language_strings` VALUES (967,'Client.Syntax.Date','it','Formato data non valido.');
INSERT INTO `language_strings` VALUES (968,'Client.Syntax.Email','it','Indirizzo e-mail non valido.');
INSERT INTO `language_strings` VALUES (969,'Client.Syntax.MalformedDomain','it','caratteri non valido nel dominio.');
INSERT INTO `language_strings` VALUES (970,'Client.Syntax.MalformedUsername','it','caratteri non validi nello username.');
INSERT INTO `language_strings` VALUES (971,'Client.Syntax.MissingDomain','it','Per favore immettere lo username e il dominio.');
INSERT INTO `language_strings` VALUES (972,'Client.Syntax.MissingParam','it','Manca un parametro obbligatorio.');
INSERT INTO `language_strings` VALUES (973,'Client.Syntax.MalformedUri','it','SIP URI non valida.');
INSERT INTO `language_strings` VALUES (974,'Client.Syntax.MissingUsername','it','Per favore inserire uno username.');
INSERT INTO `language_strings` VALUES (975,'Client.Syntax.VoiceBoxPin','it','Per favore inserire 4 cifre, oppure lasciare il campo testo vuoto.');
INSERT INTO `language_strings` VALUES (976,'Client.Voip.AssignedExtension','it','L\'interno e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (977,'Client.Voip.AssignedNumber','it','Il numero telefono specificato non e\' piu\' disponibile. ');
INSERT INTO `language_strings` VALUES (978,'Client.Voip.AuthFailed','it','Login fallito, prego verificare le credenziali.');
INSERT INTO `language_strings` VALUES (979,'Client.Voip.ChooseNumber','it','Prego selezionare un numero dalla lista.');
INSERT INTO `language_strings` VALUES (980,'Client.Voip.DeniedNumber','it','Il numero di telefono specificato non e\' disponibile.');
INSERT INTO `language_strings` VALUES (981,'Client.Voip.ExistingSubscriber','it','Lo username e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (982,'Client.Voip.ForwardSelect','it','Per favore selezionare quando deviare la chiamata.');
INSERT INTO `language_strings` VALUES (983,'Client.Voip.IncorrectPass','it','Password errata, prego verificare.');
INSERT INTO `language_strings` VALUES (984,'Client.Voip.InputErrorFound','it','Trovato un valore mancato o non valido.');
INSERT INTO `language_strings` VALUES (985,'Client.Voip.MalformedAc','it','Prefisso non valido, prego utilizzare solo cifre e non utilizzare lo zero come prima cifra.');
INSERT INTO `language_strings` VALUES (986,'Client.Voip.MalformedCc','it','Prefisso internazionale non valido, prego utilizzare solo cifre e non utilizzare lo zero come prima cifra.)');
INSERT INTO `language_strings` VALUES (987,'Client.Voip.MalformedSn','it','Numero interno non valido, prego utilizzare solo cifre. (Il numero non deve iniziare con lo zero.)');
INSERT INTO `language_strings` VALUES (988,'Client.Voip.MalformedNumber','it','Numero non valido, prego utilizzare solo cifre ed includere il prefisso.');
INSERT INTO `language_strings` VALUES (989,'Client.Voip.MalformedNumberPattern','it','Valore non valido, prego utilizzare solo numeri e “?” o “*” rispettivamente per una o un numero arbitrario di cifre.');
INSERT INTO `language_strings` VALUES (990,'Client.Voip.MalformedTargetClass','it','Prego scegliere un target.');
INSERT INTO `language_strings` VALUES (991,'Client.Voip.MalformedTarget','it','Destinazione non valida, prego utilizzare solo cifre o inserire una SIP URI valida.');
INSERT INTO `language_strings` VALUES (992,'Client.Voip.MalformedTimeout','it','Timeout non valido, prego utilizzare solo cifre.');
INSERT INTO `language_strings` VALUES (993,'Client.Voip.MissingName','it','Prego immettere almeno il nome o il cognome.');
INSERT INTO `language_strings` VALUES (994,'Client.Voip.MissingOldPass','it','Prego immettere la propria password.');
INSERT INTO `language_strings` VALUES (995,'Client.Voip.MissingPass2','it','Prego immettere la password in entrambi i campi.');
INSERT INTO `language_strings` VALUES (996,'Client.Voip.MissingPass','it','Prego immettere una password.');
INSERT INTO `language_strings` VALUES (997,'Client.Voip.MissingRingtimeout','it','Prego specificare un timeout per le chiamate in ingresso. (In secondi da 5 a 300).');
INSERT INTO `language_strings` VALUES (998,'Client.Voip.NoSuchDomain','it','Il dominio specificato non esiste.');
INSERT INTO `language_strings` VALUES (999,'Client.Voip.NoSuchNumber','it','Il numero di telefono speficato non e\' disponibile.');
INSERT INTO `language_strings` VALUES (1000,'Client.Voip.PassLength','it','The password is too short');
INSERT INTO `language_strings` VALUES (1001,'Client.Voip.PassNoMatch','it','Le password non coincidono, prego verificare.');
INSERT INTO `language_strings` VALUES (1002,'Client.Voip.ToManyPreference','it','Massimo numero di valori raggiunto.');
INSERT INTO `language_strings` VALUES (1003,'Server.Billing.Success','it','L\'account e\' stato compilato con successo.');
INSERT INTO `language_strings` VALUES (1004,'Server.Internal','it','Errore interno, prego riprovare.');
INSERT INTO `language_strings` VALUES (1005,'Server.Paypal.Error','it','Prego seguire le istruzioni sul sito PayPal per trasferire il credito.');
INSERT INTO `language_strings` VALUES (1006,'Server.Paypal.Fault','it','Errore di comunicazione con il server PayPal, prego riprovare piu\' tardi.');
INSERT INTO `language_strings` VALUES (1007,'Server.Paypal.Invalid','it','Errore di comunicazione con il server PayPal, prego riprovare piu\' tardi.');
INSERT INTO `language_strings` VALUES (1008,'Server.Voip.RemovedContact','it','Il valore contact e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1009,'Server.Voip.RemovedRegisteredContact','it','Il valore contact registrato e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1010,'Server.Voip.AddedRegisteredContact','it','Il valore contact registrato permanentemente e\' stato aggiunto.');
INSERT INTO `language_strings` VALUES (1011,'Server.Voip.RemovedVoicemail','it','Il messaggio vocale e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1012,'Server.Voip.SavedContact','it','Il valore contact e\' stato salvato.');
INSERT INTO `language_strings` VALUES (1013,'Server.Voip.SavedPass','it','La password e\' stata modificata con successo.');
INSERT INTO `language_strings` VALUES (1014,'Server.Voip.SavedSettings','it','Le impostazioni sono state salvate.');
INSERT INTO `language_strings` VALUES (1015,'Server.Voip.SubscriberCreated','it','L\'utente e\' stato salvato e puo\' essere configurato.');
INSERT INTO `language_strings` VALUES (1016,'Server.Voip.SubscriberDeleted','it','L\'utente e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1017,'Server.System.RRDOpenError','it','Apertura del file RRD fallita');
INSERT INTO `language_strings` VALUES (1018,'Server.System.RRDBinmodeError','it','Switch a BIN del file RRD fallito. ');
INSERT INTO `language_strings` VALUES (1019,'Server.System.RRDReadError','it','Lettura del file RRD fallita.');
INSERT INTO `language_strings` VALUES (1020,'Web.Addressbook.Fax','it','Fax');
INSERT INTO `language_strings` VALUES (1021,'Web.Addressbook.Home','it','Casa');
INSERT INTO `language_strings` VALUES (1022,'Web.Addressbook.Mobile','it','Cellulare');
INSERT INTO `language_strings` VALUES (1023,'Web.Addressbook.Office','it','Ufficio');
INSERT INTO `language_strings` VALUES (1024,'Web.MissingRedInput','it','Prego riempire almeno tutti I campi in rosso.');
INSERT INTO `language_strings` VALUES (1025,'Web.Months.01','it','Gennaio');
INSERT INTO `language_strings` VALUES (1026,'Web.Months.02','it','Febbraio');
INSERT INTO `language_strings` VALUES (1027,'Web.Months.03','it','Marzo');
INSERT INTO `language_strings` VALUES (1028,'Web.Months.04','it','Aprile');
INSERT INTO `language_strings` VALUES (1029,'Web.Months.05','it','Maggio');
INSERT INTO `language_strings` VALUES (1030,'Web.Months.06','it','Giugno');
INSERT INTO `language_strings` VALUES (1031,'Web.Months.07','it','Luglio');
INSERT INTO `language_strings` VALUES (1032,'Web.Months.08','it','Agosto');
INSERT INTO `language_strings` VALUES (1033,'Web.Months.09','it','Settembre');
INSERT INTO `language_strings` VALUES (1034,'Web.Months.10','it','Ottobre');
INSERT INTO `language_strings` VALUES (1035,'Web.Months.11','it','Novembre');
INSERT INTO `language_strings` VALUES (1036,'Web.Months.12','it','Dicembre');
INSERT INTO `language_strings` VALUES (1037,'Client.Syntax.AccountID','it','ID non valido, prego utilizzare solo cifre.');
INSERT INTO `language_strings` VALUES (1038,'Client.Syntax.CashValue','it','Ammontare non valito, prego utilizzare solo numeri, com virgola o punto come separatore decimale.');
INSERT INTO `language_strings` VALUES (1039,'Client.Syntax.TimeValue','it','Valore non valido, prego utilizzare solo numeri.');
INSERT INTO `language_strings` VALUES (1040,'Client.Syntax.LoginMissingUsername','it','Prego immettere il proprio username.');
INSERT INTO `language_strings` VALUES (1041,'Client.Syntax.LoginMissingPass','it','Prego immettere la propria password.');
INSERT INTO `language_strings` VALUES (1042,'Client.Voip.NoSuchAccount','it','Questo utente non esiste.');
INSERT INTO `language_strings` VALUES (1043,'Client.Voip.ExistingDomain','it','Il dominio esiste gia\'.');
INSERT INTO `language_strings` VALUES (1044,'Web.Domain.Created','it','Il dominio e\' stato salvato.');
INSERT INTO `language_strings` VALUES (1045,'Web.Domain.Deleted','it','Il dominio e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1046,'Client.Admin.ExistingAdmin','it','Lo username e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (1047,'Client.Admin.NoSuchAdmin','it','L\'amministratore non esiste.');
INSERT INTO `language_strings` VALUES (1048,'Client.Syntax.MalformedLogin','it','Carattere non valido nel nome di Login. Prego utilizzare solo caratteri alfanumerici.');
INSERT INTO `language_strings` VALUES (1049,'Web.Admin.Created','it','L\'amministratore e\' stato salvato.');
INSERT INTO `language_strings` VALUES (1050,'Web.Admin.Deleted','it','L\'amministratore e\' stato eliminato');
INSERT INTO `language_strings` VALUES (1051,'Web.Account.Created','it','L\'utente e\' stato salvato.');
INSERT INTO `language_strings` VALUES (1052,'Web.Payment.UnknownError','it','Fallimento nell\'inizializzare la transazione. Prego riprovare piu\' tardi o verificare I valori inseriti.');
INSERT INTO `language_strings` VALUES (1053,'Web.Payment.HttpFailed','it','Il server per il pagamento non puo\' essere raggiunto. Prego riprovare piu\' tardi.');
INSERT INTO `language_strings` VALUES (1054,'Web.Syntax.Numeric','it','Numero non valido, prego usare solo cifre numeriche.');
INSERT INTO `language_strings` VALUES (1055,'Web.MissingContactInfo','it','Prego controllare la casella “come sopra” o riempire tutti I campi addizionali.');
INSERT INTO `language_strings` VALUES (1056,'Web.MissingInput','it','Prego riempire tutti I campi.');
INSERT INTO `language_strings` VALUES (1057,'Web.Subscriber.Lockforeign','it','L\'interno e\' bloccato per le chiamate che lasciano il sistema.');
INSERT INTO `language_strings` VALUES (1058,'Web.Subscriber.Lockoutgoing','it','L\'interno e\' bloccato per le chiamate in uscita.');
INSERT INTO `language_strings` VALUES (1059,'Web.Subscriber.Lockincoming','it','L\'interno e\' bloccato chiamate in uscita e in ingresso.');
INSERT INTO `language_strings` VALUES (1060,'Web.Subscriber.Lockglobal','it','L\'interno e\' bloccato per tutti I servizi.');
INSERT INTO `language_strings` VALUES (1061,'Web.Payment.ExternalError','it','La transizione e\' fallita. Prego riprovare piu\' tardi e seguire tutte le istruzioni sul sito web esterno.');
INSERT INTO `language_strings` VALUES (1062,'Client.Voip.NoGroupName','it','Prego immettere un nome per il gruppo.');
INSERT INTO `language_strings` VALUES (1063,'Client.Voip.NoGroupExt','it','Prego immettere un interno numerico per il gruppo.');
INSERT INTO `language_strings` VALUES (1064,'Client.Voip.MacInUse','it','Indirizzo MAC gia\' utilizzato.');
INSERT INTO `language_strings` VALUES (1065,'Web.MissingSystem','it','Prego scegliere il PBX IP che si intende utilizzare.');
INSERT INTO `language_strings` VALUES (1066,'Web.MissingAGB','it','Prego sottoscrivere alle nostre condizioni generali di contratto.');
INSERT INTO `language_strings` VALUES (1067,'Web.Account.Activated','it','L\'utente e\' stato attivato.');
INSERT INTO `language_strings` VALUES (1068,'Client.Billing.AuthFailed','it','Login fallito, prego verificare le proprie credenziali.');
INSERT INTO `language_strings` VALUES (1069,'Web.MissingSearchString','it','Prego immettere un valore di ricerca.');
INSERT INTO `language_strings` VALUES (1070,'Client.Billing.ContactIncomplete','it','Prego immettere almeno un nome, cognome o azienda.');
INSERT INTO `language_strings` VALUES (1071,'Client.Billing.ExistingShopuser','it','Questo username e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (1072,'Client.Billing.ExistingProduct','it','Un prodotto con il seguente identificativo esiste gia\'.');
INSERT INTO `language_strings` VALUES (1073,'Client.Billing.NoSuchProduct','it','Nessun prodotto con il seguente identificativo e\' stato trovato.');
INSERT INTO `language_strings` VALUES (1074,'Client.Billing.ExistingProfile','it','Un profilo di billing con il seguente identificativo esiste gia\'.');
INSERT INTO `language_strings` VALUES (1075,'Client.Billing.NoSuchProfile','it','Nessun profilo di billing con il seguente identificativo e\' stato trovato.');
INSERT INTO `language_strings` VALUES (1076,'Web.Product.Created','it','Il prodotto inserito e\' stato creato.');
INSERT INTO `language_strings` VALUES (1077,'Web.Product.Updated','it','Il prodotto inserito e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1078,'Web.Product.Deleted','it','Il prodotto inserito e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1079,'Web.Bilprof.Created','it','Il profilo tariffario e\' stato creato.');
INSERT INTO `language_strings` VALUES (1080,'Web.Bilprof.Updated','it','Il profilo tariffario e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1081,'Web.Bilprof.Deleted','it','Il profilo tariffario e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1082,'Web.Fees.MissingFilename','it','Prego immettere un nome file.');
INSERT INTO `language_strings` VALUES (1083,'Web.Fees.Fieldcount','it','Numero di elementi errato');
INSERT INTO `language_strings` VALUES (1084,'Web.Fees.FieldsFoundRequired','it','Elementi trovati/richiesti:');
INSERT INTO `language_strings` VALUES (1085,'Web.Fees.InvalidDestination','it','Prefisso/suffisso di destinazione non valido');
INSERT INTO `language_strings` VALUES (1086,'Client.Billing.NoSuchCustomer','it','Il cliente specificato non esiste.');
INSERT INTO `language_strings` VALUES (1087,'Client.Syntax.MalformedDaytime','it','Orario inserito non valido, prego immettere ore, minuti e secondi nel formato HH:MM:SS.');
INSERT INTO `language_strings` VALUES (1088,'Web.Fees.SavedPeaktimes','it','Gli orari inseriti sono stati aggiornati.');
INSERT INTO `language_strings` VALUES (1089,'Client.Voip.DuplicatedNumber','it','Un numero di telefono e\' stato specificato piu\' di una volta.');
INSERT INTO `language_strings` VALUES (1090,'Client.Voip.SlotAlreadyExists','it','Il codice di chiamata rapida e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (1091,'Client.Voip.SlotNotExistent','it','Il codice di chiamata rapida non esiste.');
INSERT INTO `language_strings` VALUES (1092,'Client.Syntax.MalformedSpeedDialDestination','it','La destinazione associata al codice di chiamata rapida non e\' valida.');
INSERT INTO `language_strings` VALUES (1093,'Client.Syntax.MalformedVSC','it','Il codice di servizio (VSC) non e\' valido.');
INSERT INTO `language_strings` VALUES (1094,'Client.Syntax.MalformedIPNet','it','ipnet non valido, prego utilizzare la notazione decimale puntata e specificare la maschera com numero di bits.');
INSERT INTO `language_strings` VALUES (1095,'Client.Syntax.MalformedIP','it','ip non valido, pre utilizzare la notazione decimale puntata per IPv4 o indirizzi senza parentesi quadre per IPv6.');
INSERT INTO `language_strings` VALUES (1096,'Server.Voip.PeerGroupDeleted','it','Il peering group e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1097,'Client.Voip.NoSuchPeerGroup','it','Il peering group non esiste.');
INSERT INTO `language_strings` VALUES (1098,'Client.Voip.NoPeerContract','it','Nessun peering contract selezionato.');
INSERT INTO `language_strings` VALUES (1099,'Client.Voip.ExistingPeerGroup','it','Il peering group esiste gia\'.');
INSERT INTO `language_strings` VALUES (1100,'Client.Syntax.MalformedPeerGroupName','it','Carattere non valido nel nome del peering group.');
INSERT INTO `language_strings` VALUES (1101,'Client.Voip.NoSuchPeerRule','it','La regola non esiste.');
INSERT INTO `language_strings` VALUES (1102,'Client.Voip.NoSuchPeerHost','it','L\'host non esiste.');
INSERT INTO `language_strings` VALUES (1103,'Client.Voip.ExistingPeerHost','it','Un host con questo nome esiste gia\' in questo gruppo.');
INSERT INTO `language_strings` VALUES (1104,'Client.Voip.ExistingPeerIp','it','Un host con questo IP esiste gia\' in questo gruppo.');
INSERT INTO `language_strings` VALUES (1105,'Client.Voip.NoSuchPeerRewriteRule','it','Le regole di riscrittura per questo peering non esistono.');
INSERT INTO `language_strings` VALUES (1106,'Client.Voip.NoSuchDomainRewriteRule','it','Le regole di riscrittura per questo dominio non esistono.');
INSERT INTO `language_strings` VALUES (1107,'Client.Voip.NoSuchCfDestSet','it','La tipologia di destinazione per la deviazione di chiamata non esiste.');
INSERT INTO `language_strings` VALUES (1108,'Client.Voip.ExistingCfDestSet','it','La tipologia di destinazione per la deviazione di chiamata  esiste gia\'.');
INSERT INTO `language_strings` VALUES (1109,'Client.Voip.NoSuchCfDest','it','La destinazione per la deviazione di chiamata non esiste.');
INSERT INTO `language_strings` VALUES (1110,'Client.Voip.ExistingCfDest','it','La destinazione per la deviazione di chiamata  esiste gia\'.');
INSERT INTO `language_strings` VALUES (1111,'Client.Voip.NoSuchCfTimeSet','it','Le regole temporali per la deviazione di chiamata non esistono.');
INSERT INTO `language_strings` VALUES (1112,'Client.Voip.ExistingCfTimeSet','it','La regole temporali per la deviazione di chiamata  esistono gia\'.');
INSERT INTO `language_strings` VALUES (1113,'Client.Voip.NoSuchCfPeriod','it','Il periodo temporale per la deviazione di chiamata non esiste.');
INSERT INTO `language_strings` VALUES (1114,'Client.Voip.MalformedFaxDestination','it','\'destination\' deve essere un indirizzo email o un numero di telefono.');
INSERT INTO `language_strings` VALUES (1115,'Client.Syntax.FaxPassLength','it','La password e\' troppo breve, prego usare ${faxpw_min_char} caratteri almeno.');
INSERT INTO `language_strings` VALUES (1116,'Web.Syntax.ID','it','ID non valido, prego immettere un valore numerico.');
INSERT INTO `language_strings` VALUES (1117,'Web.Syntax.LNPProvName','it','Prego immettere un nome per il campo provider.');
INSERT INTO `language_strings` VALUES (1118,'Web.LNPProvider.Created','it','Il provider LNP e\' stato creato.');
INSERT INTO `language_strings` VALUES (1119,'Web.LNPProvider.Updated','it','Il provider LNP e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1120,'Web.LNPProvider.Deleted','it','Il provider LNP e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1121,'Web.LNPNumber.Created','it','Il numero LNP e\' stato memorizzato.');
INSERT INTO `language_strings` VALUES (1122,'Web.LNPNumber.Updated','it','Il numero LNP e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1123,'Web.LNPNumber.Deleted','it','Il numero LNP e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1124,'Client.Syntax.MalformedE164Number','it','Numerazione E.164 non valida. Prego utilizzare solo numeri ed includere il prefisso internazionale.');
INSERT INTO `language_strings` VALUES (1125,'Client.Syntax.MalformedDate','it','Data non valida, prego controllare la sintassi.');
INSERT INTO `language_strings` VALUES (1126,'Client.Syntax.MissingNCOSLevel','it','Prego specificare un livello NCOS.');
INSERT INTO `language_strings` VALUES (1127,'Client.NCOS.ExistingLevel','it','Il livello NCOS esiste gia\'.');
INSERT INTO `language_strings` VALUES (1128,'Client.NCOS.NoSuchLevel','it','Il livello NCOS non esiste.');
INSERT INTO `language_strings` VALUES (1129,'Web.NCOSLevel.Created','it','Il livello NCOS e\' stato creato.');
INSERT INTO `language_strings` VALUES (1130,'Web.NCOSLevel.Updated','it','Il livello NCOS e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1131,'Web.NCOSLevel.Deleted','it','Il livello NCOS e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1132,'Web.NCOSPattern.Created','it','Il pattern e\' stato memorizzato.');
INSERT INTO `language_strings` VALUES (1133,'Web.NCOSPattern.Updated','it','Il pattern e\' stato aggiornato.');
INSERT INTO `language_strings` VALUES (1134,'Web.NCOSPattern.Deleted','it','Il pattern e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1135,'Web.NCOSLNP.Created','it','Il provider e\' stato aggiunto alla lista.');
INSERT INTO `language_strings` VALUES (1136,'Web.NCOSLNP.Updated','it','Il provider e\' stato aggiornato.');
INSERT INTO `language_strings` VALUES (1137,'Web.NCOSLNP.Deleted','it','Il provider e\' stato rimosso dalla lista.');
INSERT INTO `language_strings` VALUES (1138,'Client.Syntax.MalformedNCOSPattern','it','Il pattern non puo\' essere vuoto, prego specificare una espressione regolare.');
INSERT INTO `language_strings` VALUES (1139,'Client.Syntax.MalformedAudioData','it','File audio non valido, prego immettere una file audio in formato wav.');
INSERT INTO `language_strings` VALUES (1140,'Client.Voip.ExistingAudioFile','it','Identificativo per il file audio gia\' in uso.');
INSERT INTO `language_strings` VALUES (1141,'Client.Voip.NoSuchAudioFile','it','L\'dentificativo per il file audio non esiste..');
INSERT INTO `language_strings` VALUES (1142,'Web.AudioFile.Created','it','Il file audio e\' stato creato.');
INSERT INTO `language_strings` VALUES (1143,'Web.AudioFile.Updated','it','Il file audio e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1144,'Web.AudioFile.Deleted','it','Il file audio e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1145,'Client.Syntax.MalformedHandle','it','Identificativo non valido, prego specificare una stringa alfanumerica.');
INSERT INTO `language_strings` VALUES (1146,'Client.VSC.NoSuchAction','it','L\'azione per il codice VSC non esiste.');
INSERT INTO `language_strings` VALUES (1147,'Client.VSC.ExistingAction','it','L\'azione per il codice VSC e\' stata gia\' definita.');
INSERT INTO `language_strings` VALUES (1148,'Client.VSC.ExistingDigits','it','Le cifre sono gia\' utilizzate da un altro codice VSC.');
INSERT INTO `language_strings` VALUES (1149,'Client.Syntax.MalformedVSCDigits','it','Codice VSC non valido, prego immettere esattamente due cifre.');
INSERT INTO `language_strings` VALUES (1150,'Web.VSC.Created','it','Codice VSC creato.');
INSERT INTO `language_strings` VALUES (1151,'Web.VSC.Updated','it','Codice VSC modificato.');
INSERT INTO `language_strings` VALUES (1152,'Web.VSC.Deleted','it','Codice VSC eliminato.');
INSERT INTO `language_strings` VALUES (1153,'Client.Voip.AudioFileInUse','it','Il file audio e\' in uso e non puo\' essere eliminato.');
INSERT INTO `language_strings` VALUES (1154,'Web.Contract.Created','it','Il contract e\' stato creato.');
INSERT INTO `language_strings` VALUES (1155,'Web.Contract.Updated','it','Il contract e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1156,'Web.Contract.Deleted','it','Il contract e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1157,'Web.NCOSLevel.LACSet','it','Il prefisso chiamante e\' stato aggiunto alla lista.');
INSERT INTO `language_strings` VALUES (1158,'Web.NCOSLevel.LACUnset','it','Il prefisso chiamante e\' stato rimosso dalla lista.');
INSERT INTO `language_strings` VALUES (1159,'Web.NumberBlock.Created','it','Il blocco numero e\' stato creato.');
INSERT INTO `language_strings` VALUES (1160,'Web.NumberBlock.Updated','it','Il blocco numero e\' stato modificato.');
INSERT INTO `language_strings` VALUES (1161,'Web.NumberBlock.Deleted','it','Il blocco numero e\' stato eliminato.');
INSERT INTO `language_strings` VALUES (1162,'Client.Syntax.MalformedReminderTime','it','Stringa temporale non valida, prego usare il formato \'hh:mm\'');
INSERT INTO `language_strings` VALUES (1163,'Web.Fax.ExistingFaxDestination','it','Questa destinazione e\' gia\' nella lista.');
INSERT INTO `language_strings` VALUES (1164,'Client.Voip.ReservedSubscriber','it','Questo username e\' riservato per uso interno.');
INSERT INTO `language_strings` VALUES (1165,'Server.Voip.NoProxy','it','Nessun SIP Proxy e\' stato configurato per il click-to-dial.');
INSERT INTO `language_strings` VALUES (1166,'Client.Fees.DuplicateDestination','it','Un prefisso/suffisso di destinazione e\' stato specificato due volte.');
INSERT INTO `language_strings` VALUES (1167,'Client.Billing.ExistingExternalCID','it','Questo External ID e\' gia\' in utilizzato da un altro cliente.');
INSERT INTO `language_strings` VALUES (1168,'Client.Billing.ExistingExternalAID','it','Questo External ID e\' gia\' in utilizzato da un altro utente.');
INSERT INTO `language_strings` VALUES (1169,'Client.Billing.ExistingExternalSID','it','Questo External ID e\' gia\' in utilizzato da un altro interno.');
INSERT INTO `language_strings` VALUES (1170,'Web.Syntax.MissingExternalID','it','Prego immettere un external ID nel campo di ricerca.');
INSERT INTO `language_strings` VALUES (1171,'Client.Voip.ExistingRewriteRuleSet','it','Il nome per le regole di riscrittura  e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (1172,'Client.Voip.NoSuchRewriteRuleSet','it','La tipologia di regola di riscrittura non esiste.');
INSERT INTO `language_strings` VALUES (1173,'Client.Voip.NoSuchRewriteRule','it','La regola di riscrittura non esiste.');
INSERT INTO `language_strings` VALUES (1174,'Web.Rewrite.RuleSetDeleted','it','La tipologia di regola di riscrittura e\' stata eliminata.');
INSERT INTO `language_strings` VALUES (1175,'Web.Fees.InvalidCharset','it','Gruppo di caratteri non valido, prego immettere tutti I dati codificati UTF-8.');
INSERT INTO `language_strings` VALUES (1176,'Web.Fees.InvalidZone','it','Zona specificata non valida, dovrebbe essere una stringa non vuota.');
INSERT INTO `language_strings` VALUES (1177,'Web.Fees.InvalidZoneDetail','it','Dettaglio zona specificato non valido, dovrebbe essere una stringa non vuota.');
INSERT INTO `language_strings` VALUES (1178,'Web.Fees.InvalidRate','it','Prezzo non valido, dovrebbe essere un numero in virgola mobile.');
INSERT INTO `language_strings` VALUES (1179,'Web.Fees.InvalidInterval','it','Intervallo specificato non valido, dovrebbe essere un numero intero.');
INSERT INTO `language_strings` VALUES (1180,'Client.Syntax.InvalidYear','it','Anno non valido.');
INSERT INTO `language_strings` VALUES (1181,'Client.Syntax.InvalidMonth','it','Mese non valido.');
INSERT INTO `language_strings` VALUES (1182,'Client.Syntax.InvalidMDay','it','Giorno del mese non valido.');
INSERT INTO `language_strings` VALUES (1183,'Client.Syntax.InvalidWDay','it','Giorno della settimana.');
INSERT INTO `language_strings` VALUES (1184,'Client.Syntax.InvalidHour','it','Ora non valida.');
INSERT INTO `language_strings` VALUES (1185,'Client.Syntax.InvalidMinute','it','Minuto non valido.');
INSERT INTO `language_strings` VALUES (1186,'Client.Syntax.FromMissing','it','Manca un inizio.');
INSERT INTO `language_strings` VALUES (1187,'Client.Syntax.FromAfterTo','it','Inizio dopo fine.');
INSERT INTO `language_strings` VALUES (1188,'Client.Syntax.EmptySetName','it','Setname non puo\' essere vuoto.');
INSERT INTO `language_strings` VALUES (1189,'Client.Syntax.MissingDestinationSet','it','Prego scegliere una tipologia di destinazione.');
INSERT INTO `language_strings` VALUES (1190,'Client.Syntax.UnknownProtocol','it','Protocollo sconosciuto.');
INSERT INTO `language_strings` VALUES (1191,'Client.Voip.InvalidEnum','it','ENUM non valido.');
INSERT INTO `language_strings` VALUES (1192,'Client.Syntax.UnknownLock','it','Locklevel non valido.');
INSERT INTO `language_strings` VALUES (1193,'Server.Voip.SoundSetDeleted','it','Tipologia di suoni eliminata.');
INSERT INTO `language_strings` VALUES (1194,'Server.Voip.SoundSetMapped','it','Tipologia di suoni ancora assegnata.');
INSERT INTO `language_strings` VALUES (1195,'Server.Voip.NoSuchSoundSet','it','La tipologia di suoni non esiste.');
INSERT INTO `language_strings` VALUES (1196,'Client.Syntax.MissingSoundFile','it','File audio mancante.');
INSERT INTO `language_strings` VALUES (1197,'Client.Syntax.InvalidE164Number','it','Numerazione E.164 non valida.');
INSERT INTO `language_strings` VALUES (1198,'Client.Syntax.InvalidSipUsernamePattern','it','Pattern specificato per username SIP non valido, prego utilizzare solo numeri, lettere, “*”, “?” e “[n-m]”');
INSERT INTO `language_strings` VALUES (1199,'Client.Syntax.InvalidSipUsername','it','Username SIP non valido.');
INSERT INTO `language_strings` VALUES (1200,'Client.Voip.ExistingWebUser','it','L\'utente webuser e\' gia\' in uso.');
INSERT INTO `language_strings` VALUES (1201,'Server.Voip.SoundFileExists','it','Il file audio esiste gia\'.');
INSERT INTO `language_strings` VALUES (1202,'Server.System.WaveTranscodeFailed','it','Transcodifica del file audio fallita.');
INSERT INTO `language_strings` VALUES (1203,'Client.Syntax.InvalidFileType','it','Tipo di file non valido.');
INSERT INTO `language_strings` VALUES (1204,'Client.Voip.DuplicatePeeringRule','it','Questa regola esiste gia\'.');
INSERT INTO `language_strings` VALUES (1205,'Client.Voip.FaxQueued','en','Fax is going to be sent');
INSERT INTO `language_strings` VALUES (1206,'Client.Voip.FaxQueued','de','Fax wird gesendet');
INSERT INTO `language_strings` VALUES (1207,'Client.Voip.FaxQueued','es','Fax se transmite');
INSERT INTO `language_strings` VALUES (1208,'Client.Voip.FaxQueued','it','Fax verrà trasmesso');
INSERT INTO `language_strings` VALUES (1209,'Client.Voip.FaxQueued','fr','Fax sera transmis');
INSERT INTO `language_strings` VALUES (1210,'Client.Voip.NoFaxData','en','No Fax content specified');
INSERT INTO `language_strings` VALUES (1211,'Client.Voip.NoFaxData','de','Kein Inhalt zur Fax-Übertragung angegeben');
INSERT INTO `language_strings` VALUES (1212,'Client.Voip.NoFaxData','es','No se especifica el contenido del fax');
INSERT INTO `language_strings` VALUES (1213,'Client.Voip.NoFaxData','it','Nessun contenuto fax è specificato');
INSERT INTO `language_strings` VALUES (1214,'Client.Voip.NoFaxData','fr','Aucun contenu du fax est spécifié');
INSERT INTO `language_strings` VALUES (1215,'Client.Voip.InvalidFaxFileType','en','Invalid File Type for Fax');
INSERT INTO `language_strings` VALUES (1216,'Client.Voip.InvalidFaxFileType','de','Ungültiger Datei-Typ für Fax');
INSERT INTO `language_strings` VALUES (1217,'Client.Voip.InvalidFaxFileType','es','Tipo de archivo no válido para el fax');
INSERT INTO `language_strings` VALUES (1218,'Client.Voip.InvalidFaxFileType','it','Tipo di file non valido per il fax');
INSERT INTO `language_strings` VALUES (1219,'Client.Voip.InvalidFaxFileType','fr','Type de fichier non valide pour fax');
INSERT INTO `language_strings` VALUES (1220,'Web.Fees.InvalidDirection','en','Invalid fee direction');
INSERT INTO `language_strings` VALUES (1221,'Web.Fees.InvalidDirection','de','Ungültige Gebühren-Richtung');
INSERT INTO `language_strings` VALUES (1222,'Web.Fees.InvalidDirection','fr','Invalid fee direction');
INSERT INTO `language_strings` VALUES (1223,'Web.Fees.InvalidDirection','es','Invalid fee direction');
INSERT INTO `language_strings` VALUES (1224,'Client.Voip.PasswordMinLength','en','The password is too short');
INSERT INTO `language_strings` VALUES (1225,'Client.Voip.PasswordMinLength','de','The password is too short');
INSERT INTO `language_strings` VALUES (1226,'Client.Voip.PasswordMinLength','es','The password is too short');
INSERT INTO `language_strings` VALUES (1227,'Client.Voip.PasswordMinLength','fr','The password is too short');
INSERT INTO `language_strings` VALUES (1228,'Client.Voip.PasswordMinLength','it','The password is too short');
INSERT INTO `language_strings` VALUES (1229,'Client.Voip.PasswordMaxLength','en','The password is too long');
INSERT INTO `language_strings` VALUES (1230,'Client.Voip.PasswordMaxLength','de','The password is too long');
INSERT INTO `language_strings` VALUES (1231,'Client.Voip.PasswordMaxLength','es','The password is too long');
INSERT INTO `language_strings` VALUES (1232,'Client.Voip.PasswordMaxLength','fr','The password is too long');
INSERT INTO `language_strings` VALUES (1233,'Client.Voip.PasswordMaxLength','it','The password is too long');
INSERT INTO `language_strings` VALUES (1234,'Client.Voip.PasswordMusthaveLowercase','en','The password must contain lower-case character');
INSERT INTO `language_strings` VALUES (1235,'Client.Voip.PasswordMusthaveLowercase','de','Kleinbuchstaben müssen enthalten sein');
INSERT INTO `language_strings` VALUES (1236,'Client.Voip.PasswordMusthaveLowercase','fr','The password must contain lower-case character');
INSERT INTO `language_strings` VALUES (1237,'Client.Voip.PasswordMusthaveLowercase','es','The password must contain lower-case character');
INSERT INTO `language_strings` VALUES (1238,'Client.Voip.PasswordMusthaveLowercase','it','The password must contain lower-case character');
INSERT INTO `language_strings` VALUES (1239,'Client.Voip.PasswordMusthaveUppercase','en','The password must contain upper-case character');
INSERT INTO `language_strings` VALUES (1240,'Client.Voip.PasswordMusthaveUppercase','de','Spezialzeichen müssen enthalten sein');
INSERT INTO `language_strings` VALUES (1241,'Client.Voip.PasswordMusthaveUppercase','fr','The password must contain upper-case character');
INSERT INTO `language_strings` VALUES (1242,'Client.Voip.PasswordMusthaveUppercase','es','The password must contain upper-case character');
INSERT INTO `language_strings` VALUES (1243,'Client.Voip.PasswordMusthaveUppercase','it','The password must contain upper-case character');
INSERT INTO `language_strings` VALUES (1244,'Client.Voip.PasswordMusthaveDigit','en','The password must contain digit');
INSERT INTO `language_strings` VALUES (1245,'Client.Voip.PasswordMusthaveDigit','de','Ziffern müssen enthalten sein');
INSERT INTO `language_strings` VALUES (1246,'Client.Voip.PasswordMusthaveDigit','fr','The password must contain digit');
INSERT INTO `language_strings` VALUES (1247,'Client.Voip.PasswordMusthaveDigit','es','The password must contain digit');
INSERT INTO `language_strings` VALUES (1248,'Client.Voip.PasswordMusthaveSpecialchar','en','The password must contain special characters');
INSERT INTO `language_strings` VALUES (1249,'Client.Voip.PasswordMusthaveSpecialchar','de','Spezialzeichen müssen enthalten sein');
INSERT INTO `language_strings` VALUES (1250,'Client.Voip.PasswordMusthaveSpecialchar','fr','The password must contain special characters');
INSERT INTO `language_strings` VALUES (1251,'Client.Voip.PasswordMusthaveSpecialchar','es','The password must contain special characters');
INSERT INTO `voip_aig_sequence` VALUES (100);
INSERT INTO `voip_dom_preferences` VALUES (1,2,62,'no','0000-00-00 00:00:00');
INSERT INTO `voip_dom_preferences` VALUES (2,2,66,'UPDATE_FALLBACK_INVITE','0000-00-00 00:00:00');
INSERT INTO `voip_dom_preferences` VALUES (3,2,90,'ice_strip_candidates','2023-10-25 11:10:06');
INSERT INTO `voip_dom_preferences` VALUES (6,2,101,'strip','2023-10-25 11:10:09');
INSERT INTO `voip_dom_preferences` VALUES (7,2,91,'auto','2023-10-25 11:10:09');
INSERT INTO `voip_dom_preferences` VALUES (8,2,107,'never','2023-10-25 11:10:10');
INSERT INTO `voip_dom_preferences` VALUES (9,2,124,'override_by_usernpn','2023-10-25 11:10:12');
INSERT INTO `voip_dom_preferences` VALUES (10,2,135,'extended_send_dialed','2023-10-25 11:10:13');
INSERT INTO `voip_dom_preferences` VALUES (11,2,136,'callee','2023-10-25 11:10:13');
INSERT INTO `voip_dom_preferences` VALUES (12,2,139,'en','2023-10-25 11:10:13');
INSERT INTO `voip_dom_preferences` VALUES (13,2,152,'transparent','2023-10-25 11:10:14');
INSERT INTO `voip_dom_preferences` VALUES (14,2,152,'transparent','2023-10-25 11:10:14');
INSERT INTO `voip_dom_preferences` VALUES (15,2,165,'libswrate','2023-10-25 11:10:16');
INSERT INTO `voip_dom_preferences` VALUES (16,2,178,'enabled','2023-10-25 11:10:17');
INSERT INTO `voip_dom_preferences` VALUES (17,2,260,'yes','2023-10-25 11:10:24');
INSERT INTO `voip_dom_preferences` VALUES (18,2,263,'no','2023-10-25 11:10:25');
INSERT INTO `voip_dom_preferences` VALUES (19,2,267,'internal','2023-10-25 11:10:25');
INSERT INTO `voip_dom_preferences` VALUES (20,2,292,'no','2023-10-25 11:10:28');
INSERT INTO `voip_dom_preferences` VALUES (21,2,293,'yes','2023-10-25 11:10:28');
INSERT INTO `voip_dom_preferences` VALUES (22,2,294,'whitelist','2023-10-25 11:10:28');
INSERT INTO `voip_dom_preferences` VALUES (23,2,60,'never','2023-10-25 11:10:28');
INSERT INTO `voip_dom_preferences` VALUES (24,2,108,'no','2023-10-25 11:10:32');
INSERT INTO `voip_dom_preferences` VALUES (25,2,331,'npn','2023-10-25 11:10:32');
INSERT INTO `voip_dom_preferences` VALUES (26,2,334,'external','2023-10-25 11:10:33');
INSERT INTO `voip_dom_preferences` VALUES (27,2,305,'never','2023-10-25 11:10:35');
INSERT INTO `voip_dom_preferences` VALUES (28,2,77,'never','2023-10-25 11:10:35');
INSERT INTO `voip_dom_preferences` VALUES (29,2,380,'ring','2023-10-25 11:10:36');
INSERT INTO `voip_domains` VALUES (2,'voip.sipwise.local');
INSERT INTO `voip_preference_groups` VALUES (1,'Call Forwards');
INSERT INTO `voip_preference_groups` VALUES (2,'Call Blockings');
INSERT INTO `voip_preference_groups` VALUES (3,'Access Restrictions');
INSERT INTO `voip_preference_groups` VALUES (4,'Number Manipulations');
INSERT INTO `voip_preference_groups` VALUES (5,'NAT and Media Flow Control');
INSERT INTO `voip_preference_groups` VALUES (6,'Remote Authentication');
INSERT INTO `voip_preference_groups` VALUES (7,'Session Timers');
INSERT INTO `voip_preference_groups` VALUES (8,'Internals');
INSERT INTO `voip_preference_groups` VALUES (9,'Cloud PBX');
INSERT INTO `voip_preference_groups` VALUES (10,'XMPP Settings');
INSERT INTO `voip_preference_groups` VALUES (12,'Applications');
INSERT INTO `voip_preference_groups` VALUES (13,'CPBX Device Administration');
INSERT INTO `voip_preference_groups` VALUES (14,'CPBX Device Firmware Settings');
INSERT INTO `voip_preference_groups` VALUES (15,'IMS Application Server');
INSERT INTO `voip_preference_groups` VALUES (16,'SIP Response Codes');
INSERT INTO `voip_preference_groups` VALUES (17,'Media Codec Transcoding Options');
INSERT INTO `voip_preference_groups` VALUES (18,'CDR/EDR Export Settings');
INSERT INTO `voip_preferences` VALUES (1,3,'lock','Lock Level',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'enum',1,'For a list of possible values, see the \"lock\" field in the API doc for /api/subscribers. A lock value of \"none\" will not be returned to the caller. Read-only setting.',0,0,0);
INSERT INTO `voip_preferences` VALUES (2,2,'block_in_mode','Block Mode for inbound calls',1,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Specifies the operational mode of the incoming block list. If unset or set to a false value, it is a blacklist (accept all calls except from numbers listed in the block list), with a true value it is a whitelist (reject all calls except from numbers listed in the block list).',0,0,1);
INSERT INTO `voip_preferences` VALUES (3,2,'block_in_list','Block List for inbound calls',0,0,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Contains wildcarded SIP usernames (the localpart of the whole SIP URI, eg., \"user\" of SIP URI \"user@example.com\") that are (not) allowed to call the subscriber. \"*\", \"?\" and \"[x-y]\" with \"x\" and \"y\" representing numbers from 0 to 9 may be used as wildcards like in shell patterns.',0,0,1);
INSERT INTO `voip_preferences` VALUES (4,2,'block_in_clir','Block anonymous inbound calls',1,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Incoming anonymous calls (with calling line identification restriction) are blocked if set to true.',0,0,1);
INSERT INTO `voip_preferences` VALUES (5,2,'block_out_mode','Block Mode for outbound calls',1,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Specifies the operational mode of the outgoing block list. If unset or set to a false value, it is a blacklist (allow all calls except to numbers listed in the block list), with a true value it is a whitelist (deny all calls except to numbers listed in the block list).',0,0,1);
INSERT INTO `voip_preferences` VALUES (6,2,'block_out_list','Block List for outbound calls',0,0,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Contains wildcarded SIP usernames (the localpart of the whole SIP URI, eg., \"user\" of SIP URI \"user@example.com\") that are (not) allowed to be called by the subscriber. \"*\", \"?\" and \"[x-y]\" with \"x\" and \"y\" representing numbers from 0 to 9 may be used as wildcards like in shell patterns.',0,0,1);
INSERT INTO `voip_preferences` VALUES (7,2,'adm_block_in_mode','Administrative Block Mode for inbound calls',1,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Same as \"block_in_mode\" but may only be set by administrators.',0,0,0);
INSERT INTO `voip_preferences` VALUES (8,2,'adm_block_in_list','Administrative Block List for inbound calls',0,0,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Same as \"block_in_list\" but may only be set by administrators and is applied prior to the user setting.',0,0,0);
INSERT INTO `voip_preferences` VALUES (9,2,'adm_block_in_clir','Administratively block anonymous inbound calls',1,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Same as \"block_in_clir\" but may only be set by administrators and is applied prior to the user setting.',0,0,0);
INSERT INTO `voip_preferences` VALUES (10,2,'adm_block_out_mode','Administrative Block Mode for outbound calls',1,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Same as \"block_out_mode\" but may only be set by administrators.',0,0,0);
INSERT INTO `voip_preferences` VALUES (11,2,'adm_block_out_list','Administrative Block List for outbound calls',0,0,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Same as \"block_out_list\" but may only be set by administrators and is applied prior to the user setting.',0,0,0);
INSERT INTO `voip_preferences` VALUES (12,1,'cfu','Internal Call Forward Unconditional #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'int',1,'The id pointing to the \"Call Forward Unconditional\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (13,1,'cfb','Internal Call Forward Busy map #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'int',1,'The id pointing to the \"Call Forward Busy\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (14,1,'cfna','Internal Call Forward Unavailable #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'int',1,'The id pointing to the \"Call Forward Unavailable\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (15,1,'cft','Internal Call Forward Timeout #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'int',1,'The id pointing to the \"Call Forward Timeout\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (16,8,'ringtimeout','Ring Timeout for CFT',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,0,'int',0,'Specifies how many seconds the system should wait before redirecting the call if \"cft\" is set.',0,0,0);
INSERT INTO `voip_preferences` VALUES (17,4,'cli','Network-Provided CLI',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'SIP username (the localpart of the whole SIP URI, eg., \"user\" of SIP URI \"user@example.com\"). \"network-provided calling line identification\" - specifies the SIP username that is used for outgoing calls in the SIP \"From\" and \"P-Asserted-Identity\" headers (as user- and network-provided calling numbers). The content of the \"From\" header may be overridden by the \"user_cli\" preference and client (if allowed by the \"allowed_clis\" preference) SIP signalling. Automatically set to the primary E.164 number specified in the subscriber details.',0,0,0);
INSERT INTO `voip_preferences` VALUES (18,4,'clir','Hide own number for outbound calls',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'\"Calling line identification restriction\" - if set to true, the CLI is not displayed on outgoing calls.',0,0,1);
INSERT INTO `voip_preferences` VALUES (19,4,'cc','Country Code',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'The country code that will be used for routing of dialed numbers without a country code. Defaults to the country code of the E.164 number if the subscriber has one.',0,0,0);
INSERT INTO `voip_preferences` VALUES (20,4,'ac','Area Code',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'The area code that will be used for routing of dialed numbers without an area code. Defaults to the area code of the E.164 number if the subscriber has one.',0,0,0);
INSERT INTO `voip_preferences` VALUES (22,4,'emergency_prefix','Emergency Prefix variable',0,1,1,0,0,0,1,1,0,0,0,'2023-10-25 11:10:17',0,0,'string',0,'A numeric string intended to be used in rewrite rules for emergency numbers.',0,0,0);
INSERT INTO `voip_preferences` VALUES (23,2,'ncos_id','Internal NCOS Level #',1,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:38',1,1,'int',0,NULL,0,0,1);
INSERT INTO `voip_preferences` VALUES (24,2,'adm_ncos_id','Internal Administrative NCOS Level #',1,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:19',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (29,2,'ncos','NCOS Level',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',-1,1,'string',0,'Specifies the NCOS level that applies to the user.',0,0,1);
INSERT INTO `voip_preferences` VALUES (30,2,'adm_ncos','Administrative NCOS Level',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:19',-1,0,'string',0,'Same as \"ncos\", but may only be set by administrators and is applied prior to the user setting.',0,0,0);
INSERT INTO `voip_preferences` VALUES (31,2,'block_out_override_pin','PIN to bypass outbound Block List',0,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'A PIN code which may be used in a VSC to disable the outgoing user block list and NCOS level for a call.',0,0,1);
INSERT INTO `voip_preferences` VALUES (32,2,'adm_block_out_override_pin','Administrative PIN to bypass outbound Block List',0,1,1,1,0,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Same as \"block_out_override_pin\" but additionally disables the administrative block list and NCOS level.',0,0,0);
INSERT INTO `voip_preferences` VALUES (33,6,'peer_auth_user','Peer Authentication User',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'A username used for authentication against the peer host.',0,0,0);
INSERT INTO `voip_preferences` VALUES (34,6,'peer_auth_pass','Peer Authentication Password',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'A password used for authentication against the peer host.',0,0,0);
INSERT INTO `voip_preferences` VALUES (35,3,'unauth_inbound_calls','Allow inbound calls from foreign subscribers',1,1,0,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'boolean',0,'Allow unauthenticated inbound calls from FOREIGN domain to users within this domain. Use with care - it allows to flood your users with voice spam.',0,0,0);
INSERT INTO `voip_preferences` VALUES (36,6,'peer_auth_realm','Peer Authentication Domain',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'A realm (hostname) used to identify and for authentication against a peer host.',0,0,0);
INSERT INTO `voip_preferences` VALUES (40,6,'peer_auth_register','Enable Peer Authentication',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'boolean',0,'Specifies whether registration at the peer host is desired.',0,0,0);
INSERT INTO `voip_preferences` VALUES (41,3,'concurrent_max','Maximum number of concurrent calls',1,1,1,1,1,1,1,1,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Maximum number of overall (incoming and outgoing) concurrent on-net and off-net calls for a subscriber or peer, excluding calls from subscriber to the application server and intra-PBX calls.',0,1,0);
INSERT INTO `voip_preferences` VALUES (42,3,'concurrent_max_out','Maximum number of outbound concurrent calls',1,1,1,1,1,1,1,1,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Maximum number of outgoing concurrent on-net and off-net calls coming from a subscriber or going to a peer, excluding calls from subscriber to the application server and intra-PBX calls.',0,1,0);
INSERT INTO `voip_preferences` VALUES (43,3,'allowed_clis','Allowed CLIs for outbound calls',0,0,1,0,0,0,1,0,0,0,0,'2023-10-25 11:10:12',0,0,'string',0,'A list of shell patterns specifying which CLIs are allowed to be set by the subscriber. \"*\", \"?\" and \"[x-y]\" with \"x\" and \"y\" representing numbers from 0 to 9 may be used as wildcards as usual in shell patterns.',0,0,0);
INSERT INTO `voip_preferences` VALUES (45,8,'account_id','Internal Contract #',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (46,8,'ext_contract_id','External Contract #',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'string',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (47,8,'ext_subscriber_id','External Subscriber #',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'string',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (48,6,'find_subscriber_by_uuid','Find Subscriber by UUID',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'boolean',0,'For incoming calls from this peer, find the destination subscriber by a uuid parameter in R-URI which has been sent in Contact at outbound registration.',0,0,0);
INSERT INTO `voip_preferences` VALUES (50,4,'rewrite_rule_set','Rewrite Rule Set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',-1,0,'int',0,'Specifies the list of caller and callee rewrite rules which should be applied for incoming and outgoing calls.',0,0,0);
INSERT INTO `voip_preferences` VALUES (51,4,'rewrite_caller_in_dpid','Internal # for inbound caller rewrite rule set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (52,4,'rewrite_callee_in_dpid','Internal # for inbound callee rewrite rule set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (53,4,'rewrite_caller_out_dpid','Internal # for outbound caller rewrite rule set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (54,4,'rewrite_callee_out_dpid','Internal # for outbound callee rewrite rule set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (55,4,'e164_to_ruri','Use Number instead of Contact first for outbound calls',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'boolean',0,'Send the E164 number instead of SIP AOR as request username when sending INVITE to the subscriber. If a 404 is received the SIP AOR is sent as request URI as fallback.',0,0,0);
INSERT INTO `voip_preferences` VALUES (56,4,'user_cli','User-Provided Number',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'SIP username (the localpart of the whole SIP URI, eg., \"user\" of SIP URI \"user@example.com\"). \"user-provided calling line identification\" - specifies the SIP username that is used for outgoing calls. If set, this is put in the SIP \"From\" header (as user-provided calling number) if a client sends a CLI which is not allowed by \"allowed_clis\" or if \"allowed_clis\" is not set.',0,0,0);
INSERT INTO `voip_preferences` VALUES (57,8,'prepaid','Enable Prepaid',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:28',1,0,'boolean',0,'Deprecated, no longer used by the system.',0,0,0);
INSERT INTO `voip_preferences` VALUES (60,8,'force_inbound_calls_to_peer','Force inbound calls to peer',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:28',0,0,'enum',0,'Force calls to this user to be treated as if the user was not local. This helps in migration scenarios.',0,0,0);
INSERT INTO `voip_preferences` VALUES (61,4,'emergency_suffix','Emergency Suffix variable',0,1,1,0,0,0,1,1,0,0,0,'2023-10-25 11:10:17',0,0,'string',0,'A numeric string intended to be used in rewrite rules for emergency numbers.',0,0,0);
INSERT INTO `voip_preferences` VALUES (62,7,'sst_enable','Enable Session-Timers',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Enable SIP Session Timers.',0,0,0);
INSERT INTO `voip_preferences` VALUES (63,7,'sst_expires','Session-Timer Refresh Interval',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'int',0,'SIP Session Timers refresh interval (seconds). Should be always greater than min_timer preference. SBC will make refresh at the half of this interval.',0,0,0);
INSERT INTO `voip_preferences` VALUES (64,7,'sst_min_timer','Session-Timer Min Refresh Interval',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'int',0,'Set Min-SE value in SBC. This is also used to build 422 reply if remote Min-SE is smaller than local Min-SE.',0,0,0);
INSERT INTO `voip_preferences` VALUES (65,7,'sst_max_timer','Session-Timer Max Refresh Interval',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'int',0,'Sets upper limit on accepted Min-SE value in in SBC.',0,0,0);
INSERT INTO `voip_preferences` VALUES (66,7,'sst_refresh_method','Session-Timer Refresh Method',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'SIP Session Timers refresh method.',0,0,0);
INSERT INTO `voip_preferences` VALUES (67,5,'sound_set','System Sound Set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:30',0,0,'int',0,'Sound Set used for system prompts like error announcements etc.',0,0,0);
INSERT INTO `voip_preferences` VALUES (68,3,'reject_emergency','Reject Emergency Calls',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'boolean',0,'Reject emergency calls from this user or domain.',0,0,0);
INSERT INTO `voip_preferences` VALUES (69,4,'emergency_cli','Emergency CLI',0,1,1,0,0,0,1,1,0,0,0,'2023-10-25 11:10:17',0,0,'string',0,'SIP username (the localpart of the whole SIP URI, eg., \"user\" of SIP URI \"user@example.com\"). Emergency CLI which can be used in rewrite rules as substitution value.',0,0,0);
INSERT INTO `voip_preferences` VALUES (70,8,'outbound_socket','Force outbound call via socket',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'enum',0,'Outbound socket to be used for SIP communication to this entity',0,0,0);
INSERT INTO `voip_preferences` VALUES (71,4,'inbound_upn','Inbound User-Provided Number',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'The SIP header field to fetch the user-provided-number from for inbound calls',0,0,0);
INSERT INTO `voip_preferences` VALUES (72,4,'inbound_npn','Inbound Network-Provided Number',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'enum',0,'The SIP header field to fetch the network-provided-number from for inbound calls',0,0,0);
INSERT INTO `voip_preferences` VALUES (73,4,'outbound_from_user','Outbound From-Username Field',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'The content to put into the From username for outbound calls from the platform to the subscriber',0,0,0);
INSERT INTO `voip_preferences` VALUES (74,4,'outbound_from_display','Outbound From-Display Field',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:36',0,0,'enum',0,'The content to put into the From display-name for outbound calls from the platform to the subscriber/peer',0,0,0);
INSERT INTO `voip_preferences` VALUES (75,4,'outbound_pai_user','Outbound PAI-Username Field',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'The content to put into the P-Asserted-Identity username for outbound calls from the platform to the subscriber (use \"None\" to not set header at all)',0,0,0);
INSERT INTO `voip_preferences` VALUES (76,4,'outbound_ppi_user','Outbound PPI-Username Field',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'The content to put into the P-Preferred-Identity username for outbound calls from the platform to the subscriber (use \"None\" to not set header at all)',0,0,0);
INSERT INTO `voip_preferences` VALUES (77,8,'mobile_push_enable','Enable Apple/Google Mobile Push',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:35',0,0,'enum',0,'Send inbound call to Mobile Push server when called subscriber is not registered. This can not be used together with CFNA as call will be then simply forwarded.',0,0,0);
INSERT INTO `voip_preferences` VALUES (78,4,'extension_in_npn','Use valid Alias CLI as NPN',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'boolean',0,'Search for partial match of user-provided number (UPN) to subscriber\'s  primary E164 number and aliases. If it mathes, take UPN as valid wihout allowed_clis check and copy UPN to network-provided number (NPN).',0,0,0);
INSERT INTO `voip_preferences` VALUES (79,3,'concurrent_max_per_account','Maximum number of concurrent calls of Customer',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'int',0,'Maximum number of overall (incoming and outgoing) concurrent on-net and off-net calls for subscribers within the same Customer account, excluding calls to the application server and intra-PBX calls.',0,0,0);
INSERT INTO `voip_preferences` VALUES (80,3,'concurrent_max_out_per_account','Maximum number of outbound concurrent calls of Customer',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'int',0,'Maximum number of outgoing concurrent on-net and off-net calls for subscribers within the same Customer account, excluding calls to the application server and intra-PBX calls.',0,0,0);
INSERT INTO `voip_preferences` VALUES (81,4,'inbound_uprn','Inbound User-Provided Redirecting Number',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Specifies the way to obtain the User-Provided Redirecting CLI. Possible options are use NPN of forwarding subscriber or respect inbound Diversion header. Same validation rules as for UPN apply to UPRN. NGCP does not stack UPRNs up if the call is forwarded several times.',0,0,0);
INSERT INTO `voip_preferences` VALUES (82,4,'outbound_diversion','Outbound Diversion Header',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'The content to put into the Diversion header for outbound calls (use \"None\" to not set header at all)',0,0,0);
INSERT INTO `voip_preferences` VALUES (83,3,'allowed_ips_grp','Internal allowed source IP group #',1,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',1,0,'string',0,'Group of addresses and/or IP nets allowed access.',0,0,0);
INSERT INTO `voip_preferences` VALUES (84,3,'man_allowed_ips_grp','Internal manual allowed source IP group #',1,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',1,0,'string',0,'Group of addresses and/or IP nets allowed access.',0,0,0);
INSERT INTO `voip_preferences` VALUES (85,3,'allowed_ips','Allowed source IPs',1,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Allow access from the given list of IP addresses and/or IP nets.',0,0,0);
INSERT INTO `voip_preferences` VALUES (86,3,'man_allowed_ips','Manually defined allowed source IPs',1,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Allow access from the given list of IP addresses and/or IP nets.',0,0,0);
INSERT INTO `voip_preferences` VALUES (87,3,'ignore_allowed_ips','Ignore allowed IPs',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Ignore preferences \"allowed_ips\" and \"man_allowed_ips\".',0,0,0);
INSERT INTO `voip_preferences` VALUES (89,8,'ip_header','IP Header Field',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'string',0,'The SIP header to take the IP address for logging it into CDRs.',0,0,0);
INSERT INTO `voip_preferences` VALUES (90,5,'use_rtpproxy','RTP-Proxy Mode',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Set RTP relay mode for this peer/domain/user',0,0,0);
INSERT INTO `voip_preferences` VALUES (91,5,'ipv46_for_rtpproxy','IPv4/IPv6 briding mode',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Choose the logic of IPv4/IPv6 autodetection for the RTP relay',0,0,0);
INSERT INTO `voip_preferences` VALUES (92,3,'allow_out_foreign_domain','Allow calls to foreign domains',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'boolean',0,'Allow outbound calls of local subscribers to foreign domains',0,0,0);
INSERT INTO `voip_preferences` VALUES (93,8,'mobile_push_expiry','Mobile Push Expiry Timeout',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'int',0,'The expiry interval of sent push request. Client is expected to register within this time, otherwise he should treat the request as outdated and ignore.',0,0,0);
INSERT INTO `voip_preferences` VALUES (94,9,'cloud_pbx','CloudPBX Subscriber',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',1,0,'boolean',0,'Send the calls from/to the subscribers through the cloud pbx module.',0,0,0);
INSERT INTO `voip_preferences` VALUES (97,9,'cloud_pbx_hunt_policy','CloudPBX Hunt Policy',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'enum',0,'The hunting policy for PBX hunt groups.',0,0,0);
INSERT INTO `voip_preferences` VALUES (98,9,'cloud_pbx_hunt_timeout','CloudPBX Hunt Timeout',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,0,'int',0,'The timeout for hunting in PBX hunt groups.',0,0,0);
INSERT INTO `voip_preferences` VALUES (99,9,'cloud_pbx_hunt_group','CloudPBX Hunt Group List',0,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'string',0,'The members (as SIP URIs) of the PBX hunt group.',0,0,0);
INSERT INTO `voip_preferences` VALUES (100,9,'cloud_pbx_base_cli','CLI of CloudPBX Pilot Subscriber',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',1,0,'string',0,'The base CLI for the PBX extension.',0,0,0);
INSERT INTO `voip_preferences` VALUES (101,8,'ua_header_mode','User-Agent header passing mode',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'User-Agent header passing mode.',0,0,0);
INSERT INTO `voip_preferences` VALUES (102,8,'ua_header_replace','User-Agent header replacement (if mode is \"replace\")',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'string',0,'The string to be used as a User-Agent header replacement if ua_header_mode is set to \"replace\".',0,0,0);
INSERT INTO `voip_preferences` VALUES (103,4,'outbound_history_info','Outbound History-Info Field',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'The content to put into the History-Info  header for outbound calls (use \"None\" to not set header at all)',0,0,0);
INSERT INTO `voip_preferences` VALUES (104,10,'shared_buddylist_visibility','Export subscriber to shared XMPP Buddylist',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'boolean',0,'Export this subscriber into the shared XMPP buddy list for the customer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (105,4,'display_name','Network-Provided Display Name',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:09',0,0,'string',0,'The network-provided display name used for XMPP contacts and optionally SIP outbound header manipulation.',0,0,0);
INSERT INTO `voip_preferences` VALUES (106,5,'contract_sound_set','Customer Sound Set',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'int',0,'Customer specific Sound Set used for PBX auto-attendant prompts, customer-specific announcements etc.',0,0,1);
INSERT INTO `voip_preferences` VALUES (107,8,'force_outbound_calls_to_peer','Force outbound calls from user or peer to peer',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:16',0,0,'enum',0,'Force calls from this user/domain/peer to be routed to the peering servers after optional check of called number (if offline, non-local user or user of another customer). To enable peer relay set to \"If callee is not local\" or \"Always\" on the originating peer. Use with caution, as this setting may increase your costs!',0,0,0);
INSERT INTO `voip_preferences` VALUES (108,8,'serial_forking_by_q_value','Perform serial forking based on q-value of registered contacts',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:32',0,0,'enum',0,'Select which type of forking based on q-value you want to perform. Select \'Standard\' for the serial forking defined by q-value priority: the higher the q value number the more priority is given, same values mean parallel ringing. Select \'Probability\' for a serial forking based on probability: higher q-value means higher probability to be contacted as first, contacts with q-value 0 have the lowest priority and they are tried after all the others.',0,0,0);
INSERT INTO `voip_preferences` VALUES (109,5,'music_on_hold','Music on Hold',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'\"Music on Hold\" - if set to true and a music on hold file is provided, a calling party gets that file played when put on hold',0,0,1);
INSERT INTO `voip_preferences` VALUES (110,4,'clir_intrapbx','Hide own number for calls within own PBX',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'\"Calling line identification restriction\" - if set to true, the CLI is not displayed on outgoing calls to other users within the same PBX.',0,0,1);
INSERT INTO `voip_preferences` VALUES (111,5,'bypass_rtpproxy','Disable RTP-Proxy in the selected case',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Set to \'if both parties are behind same NAT\' if you want to allow RTP to bypass RTP-Proxy if the SIP UAs are within the same LAN of each other as determined by the \'received\' IP address check (peer-to-peer mode)',0,0,0);
INSERT INTO `voip_preferences` VALUES (112,9,'cloud_pbx_ext','Extension of CloudPBX Subscriber',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:12',1,0,'string',0,'The extension for the PBX subscriber',0,0,0);
INSERT INTO `voip_preferences` VALUES (113,8,'speed_dial','Speed Dial',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,1,'boolean',0,'\"Speed Dial\" - An internal flag for the speed dial pseudo-preference feature to be able to map it do subscriber profiles. Not directly used.',0,0,1);
INSERT INTO `voip_preferences` VALUES (114,8,'reminder','Reminder',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,1,'boolean',0,'\"Reminder\" - An internal flag for the reminder pseudo-preference feature to be able to map it do subscriber profiles. Not directly used.',0,0,1);
INSERT INTO `voip_preferences` VALUES (115,8,'auto_attendant','Auto Attendant',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,1,'boolean',0,'\"Auto Attendant\" - An internal flag for the auto_attendant pseudo-preference feature to be able to map it do subscriber profiles. Not directly used.',0,0,1);
INSERT INTO `voip_preferences` VALUES (116,8,'voice_mail','Voice Mail',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,1,'boolean',0,'\"Voice Mail\" - An internal flag for the voice_mail pseudo-preference feature to be able to map it do subscriber profiles. Not directly used.',0,0,1);
INSERT INTO `voip_preferences` VALUES (117,8,'fax_server','Fax Server',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',1,1,'boolean',0,'\"Fax Server\" - An internal flag for the fax_server pseudo-preference feature to be able to map it do subscriber profiles. Not directly used.',0,0,1);
INSERT INTO `voip_preferences` VALUES (119,4,'emergency_location_object','MIME encapsulated Location Information in the INVITE',2,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'blob',0,'SDP MIME object related to location to be added on an emergency call',0,0,0);
INSERT INTO `voip_preferences` VALUES (120,3,'concurrent_max_total','Total max number of overall concurrent calls',1,1,1,1,1,0,1,1,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Maximum total number of overall (incoming and outgoing) concurrent calls for subscribers.',0,1,0);
INSERT INTO `voip_preferences` VALUES (121,3,'concurrent_max_out_total','Total max number of outbound concurrent calls',1,1,1,1,1,0,1,1,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Maximum total number of outgoing concurrent calls coming from subscribers.',0,1,0);
INSERT INTO `voip_preferences` VALUES (122,4,'voicemail_echo_number','Number to be played in voicebox',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:12',0,0,'string',0,'If set, will be played as Number of the voicebox owner. Otherwise the number of the preference \"cli\" is used.',0,0,0);
INSERT INTO `voip_preferences` VALUES (123,5,'lbrtp_set','The cluster set used for SIP lb and RTP',0,1,0,1,1,1,0,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Use a particular cluster set of load-balancers for SIP towards this endpoint (only for peers, as for subscribers it is defined by Path during registration) and of RTP relays (both peers and subscribers).',0,0,0);
INSERT INTO `voip_preferences` VALUES (124,3,'allowed_clis_reject_policy','User-Provided CLI rejection mode',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:13',0,0,'enum',0,'Define an action to be executed if User-Provided Number doesn\'t match the \'allowed_clis\' list',0,0,0);
INSERT INTO `voip_preferences` VALUES (125,8,'gpp0','General Purpose Parameter 0',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp0 or destination_gpp0, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (126,8,'gpp1','General Purpose Parameter 1',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp1 or destination_gpp1, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (127,8,'gpp2','General Purpose Parameter 2',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp2 or destination_gpp2, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (128,8,'gpp3','General Purpose Parameter 3',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp3 or destination_gpp3, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (129,8,'gpp4','General Purpose Parameter 4',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp4 or destination_gpp4, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (130,8,'gpp5','General Purpose Parameter 5',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp5 or destination_gpp5, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (131,8,'gpp6','General Purpose Parameter 6',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp6 or destination_gpp6, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (132,8,'gpp7','General Purpose Parameter 7',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp7 or destination_gpp7, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (133,8,'gpp8','General Purpose Parameter 8',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp8 or destination_gpp8, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (134,8,'gpp9','General Purpose Parameter 9',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'string',0,'A general purpose parameter, which is reflected in CDRs of this subscriber either as source_gpp9 or destination_gpp9, depending on the call direction.',0,0,0);
INSERT INTO `voip_preferences` VALUES (135,4,'extended_dialing_mode','Incoming Dialed Number Matching',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'\"Incoming Dialed Number Matching\" - configure between strict number matching for incoming calls where dialing arbitrary extension behind subscriber number is not allowed and the extended number matching, where the system will locate the subscriber by longest matching prefix and will send either the base matching number or the original dialed number with extension (with possible fallback to user on 404 response from callee).',0,0,0);
INSERT INTO `voip_preferences` VALUES (136,4,'outbound_to_user',' Outbound To-Username Field ',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:16',0,0,'enum',0,'The content to put into the To username for outbound calls from the platform to the subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (138,9,'cloud_pbx_callqueue','PBX Call Queue',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Marks subscriber for CloudPBX Call Queue that queues incoming calls if it is busy and serves them to this subscriber when it becomes available',0,0,1);
INSERT INTO `voip_preferences` VALUES (139,8,'language','Language for voicemail and app server',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'enum',0,'Voice prompts language for voicemail, conference and application server.',0,0,1);
INSERT INTO `voip_preferences` VALUES (140,2,'adm_cf_ncos_id','Internal Administrative NCOS Level for Call Forward #',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:14',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (141,2,'adm_cf_ncos','Administrative NCOS Level For Call Forward',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:14',-1,0,'string',0,'Specifies the Administrative NCOS Level that applies for the Call Forward from the user.',0,0,0);
INSERT INTO `voip_preferences` VALUES (142,8,'conference_pin','PIN for access to pin-protected conference',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'PIN for access to private conferencing service.',0,0,1);
INSERT INTO `voip_preferences` VALUES (143,9,'max_queue_length','Call Queue length',0,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Maximum number of callers in a PBX Call Queue. By default 5',0,0,1);
INSERT INTO `voip_preferences` VALUES (144,9,'queue_wrap_up_time','Call Queue wrap-up time, sec',0,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Idle interval before connecting first caller in PBX Call Queue. By default it is 10 seconds',0,0,1);
INSERT INTO `voip_preferences` VALUES (145,5,'rtp_interface','RTP interface',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Logical RTP interface to use for media packets',0,0,0);
INSERT INTO `voip_preferences` VALUES (146,9,'ignore_cf_when_hunting','Ignore Members Call Forwards when Hunting',1,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Ignore the Members Call Forwards from a Cloud PBX subscriber when it is called within a huntgroup',0,0,1);
INSERT INTO `voip_preferences` VALUES (151,8,'conference_max_participants','Maximum Number of Participants in Conference Room',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Maximum Number of simultaneous participants in one conference room.',0,0,1);
INSERT INTO `voip_preferences` VALUES (152,5,'transport_protocol','Media transport protocol',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:14',0,0,'enum',0,'Which transport protocol (e.g. RTP, SRTP, etc) to use',0,0,0);
INSERT INTO `voip_preferences` VALUES (165,8,'prepaid_library','Prepaid library',0,1,0,0,1,0,1,0,0,0,0,'2023-10-25 11:10:28',0,0,'enum',0,'The prepaid billing interface for customer with prepaid billing profile. Deprecated, no longer used by the system.',0,0,0);
INSERT INTO `voip_preferences` VALUES (166,12,'malicious_call_identification','Malicious Call Identification',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:16',0,0,'boolean',0,'Report last call as malicious by calling at malicious_call@',0,0,0);
INSERT INTO `voip_preferences` VALUES (167,8,'identifier','Identifier name',0,1,0,0,1,1,0,0,0,0,0,'2023-10-25 11:10:16',0,0,'string',0,'Identifier name for a domain or a peer host (e.g. SIPWISE_1 or ACME_SBC). You can set it to any friendly name you prefer to identify this exchange point',0,0,0);
INSERT INTO `voip_preferences` VALUES (169,4,'outbound_from_user_is_phone','Add user=phone to calling number',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Add user=phone URI parameters to the calling party number (in From, P-Asserted-Identity etc headers)',0,0,0);
INSERT INTO `voip_preferences` VALUES (170,4,'outbound_to_user_is_phone','Add user=phone to calling number',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Add user=phone URI parameters to the called party number (in To header and Request-URI)',0,0,0);
INSERT INTO `voip_preferences` VALUES (171,4,'clir_override','Override clir',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'If true, calling party number is shown regardles of caller CLIR settings.',0,0,1);
INSERT INTO `voip_preferences` VALUES (172,4,'rewrite_caller_lnp_dpid','Internal # for lnp caller rewrite rule set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:17',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (173,4,'rewrite_callee_lnp_dpid','Internal # for lnp callee rewrite rule set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:17',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (174,8,'default_lnp_prefix','Default LNP prefix',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Defines a default caller LNP prefix which is written into CDRs if no LNP entry is found for the caller number in the LNP database. This prefix is NOT used for routing purposes like rewrite rules, only for CDR tagging.',0,0,0);
INSERT INTO `voip_preferences` VALUES (175,8,'caller_lnp_lookup','Enable Caller LNP lookup',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:22',0,0,'boolean',0,'If enabled, an LNP lookup is performed for calls from this peer using the network-provided calling party number. The resulting LNP prefix is written to CDRs as source_lnp_prefix.',0,0,0);
INSERT INTO `voip_preferences` VALUES (176,8,'emergency_priorization','Emergency Priorization',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Defines whether the subscriber can still register and send/receive calls if Emergency Mode is enabled for the domain of the subscriber. If disabled, registrations and calls are blocked and dropped.',0,0,0);
INSERT INTO `voip_preferences` VALUES (177,8,'emergency_mode_enabled','Emergency Mode Enabled',1,1,0,0,1,0,0,0,0,0,0,'2023-10-25 11:10:17',0,0,'boolean',0,'If activated for this domain, subscribers not having the emergency_priorization flag set are no longer able to register and place calls except for emergency calls.',0,0,0);
INSERT INTO `voip_preferences` VALUES (178,8,'call_deflection','Enable Call Deflection',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Call Deflection allows a called endpoint to redirect the unanswered call to another destination during the call setup phase by sending 302 redirect message in ringing phase. Disabling the preference will make the platform ignore the redirect message. Setting Immediate the redirection will be immediately executed cancelling the other active brances.',0,0,0);
INSERT INTO `voip_preferences` VALUES (179,8,'lnp_to_rn','LNP Routing number to rn param',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Defines how to provide the routing number after a LNP query. If enabled, rn parameter will be used.',0,0,0);
INSERT INTO `voip_preferences` VALUES (180,8,'lnp_add_npdi','LNP npdi param',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If enabled, npdi parameter will be added if there is a LNP query.',0,0,0);
INSERT INTO `voip_preferences` VALUES (181,8,'lnp_for_local_sub','LNP for local subscribers',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If enabled allows LNP queries for local subscribers.',0,0,0);
INSERT INTO `voip_preferences` VALUES (182,8,'lawful_interception','Lawful Interception',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:20',0,0,'boolean',0,'Enables lawful interception for the subscriber.',0,0,0);
INSERT INTO `voip_preferences` VALUES (183,8,'disable_prack_method','Disable PRACK Method',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Disables PRACK method (RFC3262) by filtering the 100rel tag from SIP Supported header.',0,0,0);
INSERT INTO `voip_preferences` VALUES (184,5,'set_moh_sendonly','MoH sendonly',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Subscriber put on hold is notified with a=sendonly in reINVITE.',0,0,0);
INSERT INTO `voip_preferences` VALUES (185,4,'anonymize_from_user','Anonymize From User',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:21',0,0,'boolean',0,'Anonymize the From-Username in addition to From-Displayname in case of CLIR call to this peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (186,5,'codecs_filter','Codecs filter by name',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Switch between blacklisting (bl) or whitelisting (wl) of codecs listed in codecs_list (1 for wl, 0 bl).',0,0,0);
INSERT INTO `voip_preferences` VALUES (187,5,'codecs_list','Codecs list of names',0,1,1,0,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'List of audio and video codecs to whitelist or blacklist. Valid codecs names are G722, PCMU, PCMA, speex, GSM, G723, DVI4, L16, QCELP, CN, MPA, G728, DVI4, G729, AMR, AMR-WB, opus, telephone-event, CelB, JPEG, H261, H263, H263-1998, MPV, MP2T, nv, vp8, vp9 and h264.',0,0,0);
INSERT INTO `voip_preferences` VALUES (188,4,'emergency_mapping_container','Emergency Mapping Container',0,1,1,1,1,0,1,1,0,0,0,'2023-10-25 11:10:37',-1,0,'string',0,'Specifies the emergency mapping container to be used for this subscriber to map emergency numbers to emergency prefixes.',0,0,0);
INSERT INTO `voip_preferences` VALUES (189,4,'emergency_mapping_container_id','Internal Emergency Mapping Container #',1,1,1,1,1,0,1,1,0,0,0,'2023-10-25 11:10:37',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (190,3,'reject_vsc','Reject Vertical Service Codes sent by subscriber',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If enabled, any vertical service codes, e.g. *99*1234, are rejected by the system to disable the possibility of provisioning features via phones .',0,0,0);
INSERT INTO `voip_preferences` VALUES (193,8,'recent_calls_by_upn','Recent Calls by UPN',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:22',0,0,'boolean',0,'Use User-Provided-Number instead of Subscriber UUID when storing recent calls',0,0,0);
INSERT INTO `voip_preferences` VALUES (194,12,'play_announce_before_cf','Play announcement before routing to CFU/CFNA',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Playback announcement as early media before Call Forward Unconditional or Unavailable.',0,0,0);
INSERT INTO `voip_preferences` VALUES (195,4,'upn_rewrite_id','Internal User CLI rewrite #',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:22',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (197,13,'admin_name','Admin name',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'string',0,'Name of the phone administrator.',0,0,0);
INSERT INTO `voip_preferences` VALUES (198,13,'admin_pass','Admin pass',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'string',0,'Password of the phone administrator.',0,0,0);
INSERT INTO `voip_preferences` VALUES (199,13,'ntp_server','NTP server',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'string',0,'NTP server URL.',0,0,0);
INSERT INTO `voip_preferences` VALUES (200,13,'ntp_sync','NTP server sync interval',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'int',0,'Synchronisation interval of NTP server.',0,0,0);
INSERT INTO `voip_preferences` VALUES (201,13,'syslog_server','Syslog server',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'string',0,'Syslog server URL.',0,0,0);
INSERT INTO `voip_preferences` VALUES (202,13,'syslog_level','Syslog level',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'int',0,'Syslog logging level.',0,0,0);
INSERT INTO `voip_preferences` VALUES (203,13,'web_gui_dis','Disable web gui',0,1,0,0,0,0,0,0,0,1,1,'2023-10-25 11:10:27',0,0,'boolean',0,'Disable phone web interface.',0,0,0);
INSERT INTO `voip_preferences` VALUES (204,14,'FW_upg_dis','FW Upgrade disable',0,1,0,0,0,0,0,0,0,1,1,'2023-10-25 11:10:27',0,0,'boolean',0,'Disable firmware upgrade.',0,0,0);
INSERT INTO `voip_preferences` VALUES (205,14,'vnd_Panasonic_FW_ver','FW version',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:27',0,0,'string',0,'Expected firmware version.',0,0,0);
INSERT INTO `voip_preferences` VALUES (206,14,'vnd_Panasonic_FW_autoupg_dis','FW automatic upgrade disable',0,1,0,0,0,0,0,0,0,1,1,'2023-10-25 11:10:27',0,0,'boolean',0,'Disable auto upgrade feature.',0,0,0);
INSERT INTO `voip_preferences` VALUES (207,15,'ims_as_context','IMS Subscriber/Domain',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Defines whether this subscriber or domain is handled in an IMS application server context, so no direct registrations and calls are possible, but are signalled via an IMS S-CSCF instead',0,0,0);
INSERT INTO `voip_preferences` VALUES (208,5,'record_call','Record calls',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:38',0,1,'boolean',0,'Intercept and record media packets from or to this subscriber into a file.',0,0,1);
INSERT INTO `voip_preferences` VALUES (210,1,'cfs','Internal Cal Forward SMS #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:23',1,0,'int',1,'The id pointing to the \"Call Forward SMS\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (211,8,'reason_text_for_failover','Failover to next peer on 5xx with given Reason text',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:23',0,0,'string',0,'Failover to the next peer if it sends 5xx response with Reason text parameter matching provided value (regex).',0,0,0);
INSERT INTO `voip_preferences` VALUES (212,4,'outbound_diversion_counter','Force Diversion counter',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:23',0,0,'string',0,'If set, the value given here is forced as counter parameter in the outbound Diversion header.',0,0,0);
INSERT INTO `voip_preferences` VALUES (213,3,'max_call_duration','Maximum Call Duration (seconds)',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Maximum Call Duration (seconds).',0,0,0);
INSERT INTO `voip_preferences` VALUES (214,8,'skip_callee_lnp_lookup','Skip callee LNP lookup',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:23',0,0,'boolean',0,'Skip callee LNP lookup when receiving a call from this peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (215,16,'no_credit_code','Reject code if involved party has no credit',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if involved party has no credit',0,0,0);
INSERT INTO `voip_preferences` VALUES (216,16,'no_credit_reason','Reject reason if involved party has no credit',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if involved party has no credit',0,0,0);
INSERT INTO `voip_preferences` VALUES (217,16,'locked_in_code','Reject code if callee is locked',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is locked',0,0,0);
INSERT INTO `voip_preferences` VALUES (218,16,'locked_in_reason','Reject reason if callee is locked',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is locked',0,0,0);
INSERT INTO `voip_preferences` VALUES (219,16,'max_calls_in_code','Reject code if max inbound call limit reached',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if max inbound call limit reached',0,0,0);
INSERT INTO `voip_preferences` VALUES (220,16,'max_calls_in_reason','Reject reason if max inbound call limit reached',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if max inbound call limit reached',0,0,0);
INSERT INTO `voip_preferences` VALUES (221,16,'callee_tmp_unavailable_code','Reject code if callee is temporarily unavailable',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is temporarily unavailable',0,0,0);
INSERT INTO `voip_preferences` VALUES (222,16,'callee_tmp_unavailable_reason','Reject reason if callee is temporarily unavailable',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is temporarily unavailable',0,0,0);
INSERT INTO `voip_preferences` VALUES (223,16,'block_ncos_code','Reject code if callee is blocked by NCOS',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is blocked by NCOS',0,0,0);
INSERT INTO `voip_preferences` VALUES (224,16,'block_ncos_reason','Reject reason if callee is blocked by NCOS',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is blocked by NCOS',0,0,0);
INSERT INTO `voip_preferences` VALUES (225,16,'callee_busy_code','Reject code if callee is busy',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is busy',0,0,0);
INSERT INTO `voip_preferences` VALUES (226,16,'callee_busy_reason','Reject reason if callee is busy',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is busy',0,0,0);
INSERT INTO `voip_preferences` VALUES (227,16,'peering_unavailable_code','Reject code if no peering for callee is available',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if no peering for callee is available',0,0,0);
INSERT INTO `voip_preferences` VALUES (228,16,'peering_unavailable_reason','Reject reason if no peering for callee is available',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if no peering for callee is available',0,0,0);
INSERT INTO `voip_preferences` VALUES (229,16,'callee_unknown_code','Reject code if callee is unknown',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is unknown',0,0,0);
INSERT INTO `voip_preferences` VALUES (230,16,'callee_unknown_reason','Reject reason if callee is unknown',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is unknown',0,0,0);
INSERT INTO `voip_preferences` VALUES (231,16,'block_admin_code','Reject code if caller is blocked by admin',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if caller is blocked by admin',0,0,0);
INSERT INTO `voip_preferences` VALUES (232,16,'block_admin_reason','Reject reason if caller is blocked by admin',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if caller is blocked by admin',0,0,0);
INSERT INTO `voip_preferences` VALUES (233,16,'block_override_pin_code','Reject code if block override pin is wrong',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if block override pin is wrong',0,0,0);
INSERT INTO `voip_preferences` VALUES (234,16,'block_override_pin_reason','Reject reason if block override pin is wrong',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if block override pin is wrong',0,0,0);
INSERT INTO `voip_preferences` VALUES (235,16,'callee_offline_code','Reject code if callee is offline',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is offline',0,0,0);
INSERT INTO `voip_preferences` VALUES (236,16,'callee_offline_reason','Reject reason if callee is offline',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is offline',0,0,0);
INSERT INTO `voip_preferences` VALUES (237,16,'locked_out_code','Reject code if caller is locked',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if caller is locked',0,0,0);
INSERT INTO `voip_preferences` VALUES (238,16,'locked_out_reason','Reject reason if caller is locked',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if caller is locked',0,0,0);
INSERT INTO `voip_preferences` VALUES (239,16,'block_caller_code','Reject code if callee is blocked by caller',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is blocked by caller',0,0,0);
INSERT INTO `voip_preferences` VALUES (240,16,'block_caller_reason','Reject reason if callee is blocked by caller',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is blocked by caller',0,0,0);
INSERT INTO `voip_preferences` VALUES (241,16,'cf_loop_code','Reject code on call forward loop',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code on call forward loop',0,0,0);
INSERT INTO `voip_preferences` VALUES (242,16,'cf_loop_reason','Reject reason on call forward loop',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason on call forward loop',0,0,0);
INSERT INTO `voip_preferences` VALUES (243,16,'max_calls_peer_code','Reject code if max outbound call limit on peer reached',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if max outbound call limit on peer reached',0,0,0);
INSERT INTO `voip_preferences` VALUES (244,16,'max_calls_peer_reason','Reject reason if max outbound call limit on peer reached',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if max outbound call limit on peer reached',0,0,0);
INSERT INTO `voip_preferences` VALUES (245,16,'relaying_denied_code','Reject code if call relay is detected',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if call relay is detected',0,0,0);
INSERT INTO `voip_preferences` VALUES (246,16,'relaying_denied_reason','Reject reason if call relay is detected',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if call relay is detected',0,0,0);
INSERT INTO `voip_preferences` VALUES (247,16,'block_callee_code','Reject code if caller is blocked by callee',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if caller is blocked by callee',0,0,0);
INSERT INTO `voip_preferences` VALUES (248,16,'block_callee_reason','Reject reason if caller is blocked by callee',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if caller is blocked by callee',0,0,0);
INSERT INTO `voip_preferences` VALUES (249,16,'block_in_code','Reject code if caller is blocked by callee',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if caller is blocked by callee',0,0,0);
INSERT INTO `voip_preferences` VALUES (250,16,'block_in_reason','Reject reason if caller is blocked by callee',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if caller is blocked by callee',0,0,0);
INSERT INTO `voip_preferences` VALUES (251,16,'max_calls_out_code','Reject code if max outbound call limit reached',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if max outbound call limit reached',0,0,0);
INSERT INTO `voip_preferences` VALUES (252,16,'max_calls_out_reason','Reject reason if max outbound call limit reached',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if max outbound call limit reached',0,0,0);
INSERT INTO `voip_preferences` VALUES (253,16,'block_contract_code','Reject code if callee is blocked by caller contract',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is blocked by caller contract',0,0,0);
INSERT INTO `voip_preferences` VALUES (254,16,'block_contract_reason','Reject reason if callee is blocked by caller contract',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is blocked by caller contract',0,0,0);
INSERT INTO `voip_preferences` VALUES (255,16,'block_out_code','Reject code if callee is blocked by caller',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'int',0,'Reject code if callee is blocked by caller',0,0,0);
INSERT INTO `voip_preferences` VALUES (256,16,'block_out_reason','Reject reason if callee is blocked by caller',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Reject reason if callee is blocked by caller',0,0,0);
INSERT INTO `voip_preferences` VALUES (257,3,'ua_filter_list','SIP User-Agent Filter List',0,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'string',0,'Contains wildcard list of allowed or denied SIP User-Agents matched against the User-Agent header.',0,0,0);
INSERT INTO `voip_preferences` VALUES (258,3,'ua_filter_mode','Filter Mode for SIP User-Agent Filter List',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'boolean',0,'Specifies the operational mode of the SIP User-Agent Filter List. If unset or set to a false value, it is a blacklist (accept all requests except from user-agents listed in the filter list), with a true value it is a whitelist (reject all requests except from user-agents listed in the filter list).',0,0,0);
INSERT INTO `voip_preferences` VALUES (259,3,'ua_reject_missing','Reject requests w/o User-Agent header',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:24',0,0,'boolean',0,'Rejects any request if no User-Agent header is given. Usually goes together with the SIP User-Agent Filter List and Mode preferences.',0,0,0);
INSERT INTO `voip_preferences` VALUES (260,5,'nat_sipping','Enable SIP OPTIONS ping',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Controls whether to enable/disable NAT pings for a given domain/user. Requires re-registrations for the change in settings to take effect',0,0,0);
INSERT INTO `voip_preferences` VALUES (261,4,'secretary_numbers','Numbers used in the \"Manager Secretary\" call forwardings',0,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Contains a list of numbers used in the \"Manager Secretary\" call forwardings',0,0,1);
INSERT INTO `voip_preferences` VALUES (262,4,'manager_secretary','\"Manager Secretary\" call forwardings toggle',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Turns on and off \"Manager Secretary\" call forwardings',0,0,1);
INSERT INTO `voip_preferences` VALUES (263,4,'skip_upn_check_on_diversion','Skip UPN check if received Diversion/History-Info header',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'If set, the UPN of the calling party is not checked against the allowed CLIs provisioned for the subscriber if a Diversion or History-Info header that meets the selected criteria has been sent by the calling subscriber. The recommended mode here, for example when connecting external PBX to NGCP, is \"If user in received Diversion or History-Info header is in caller\'s alias list\", as this validates the forwarding number in received Diversion/History-Info header against subscriber\'s aliases and is a safer choice than enabling UPN check bypass when any header is present. If any mode other than \"Never\" is selected, the forwarding number in the History-Info header is checked and the History-Info is rewritten if it doesn\'t match any alias numbers.',0,0,0);
INSERT INTO `voip_preferences` VALUES (264,5,'set_moh_zeroconnection','MoH zero connection',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Subscriber put on hold is notified with SDP field c containing 0.0.0.0 in reINVITE.',0,0,0);
INSERT INTO `voip_preferences` VALUES (265,9,'csta_controller','CSTA Controller',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Allow this subscriber to initiate CTI sessions to other subscribers within the same customer using uaCSTA via SIP.',0,0,1);
INSERT INTO `voip_preferences` VALUES (266,9,'csta_client','CSTA Client',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Allow this subscriber to be controlled by a CTI subscriber within the same customer using uaCSTA via SIP.',0,0,1);
INSERT INTO `voip_preferences` VALUES (267,12,'callrecording_type','Call Recording Type',0,1,0,0,1,0,0,0,0,0,0,'2023-10-25 11:10:25',0,0,'enum',0,'Use integrated call recording functionality or notify external call recording server by providing SIP header specified in \'rtpproxy.recording.add_header_for_external_callrecording\' config.yml key',0,0,0);
INSERT INTO `voip_preferences` VALUES (268,17,'ptime','RTP packet interval',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'enum',0,'Alter the interval (in milliseconds) between RTP packets for media repacketization',0,0,0);
INSERT INTO `voip_preferences` VALUES (269,17,'transcode_PCMU','Transcode to G.711 u-Law',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:35',0,0,'boolean',0,'Always offer the audio codec G.711 u-Law (PCMU, 8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (270,17,'transcode_PCMA','Transcode to G.711 a-Law',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec G.711 a-Law (PCMA, 8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (271,17,'transcode_G722','Transcode to G.722',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec G.722 (16 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (272,17,'transcode_G723','Transcode to G.723.1',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec G.723.1 (8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (273,17,'transcode_G729','Transcode to G.729',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec G.729 (8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (274,17,'transcode_GSM','Transcode to GSM',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec GSM Full Rate 06.10 (8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (275,17,'transcode_AMR','Transcode to AMR',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec AMR (narrowband, 8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (276,17,'transcode_AMR_WB','Transcode to AMR-WB',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec AMR-WB (wideband, 16 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (277,17,'transcode_opus_mono','Transcode to Opus mono',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec Opus (1-channel mono, 48 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (278,17,'transcode_opus_stereo','Transcode to Opus stereo',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec Opus (2-channel stereo, 48 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (279,17,'transcode_speex_8','Transcode to Speex 8 kHz',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec Speex (8 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (280,17,'transcode_speex_16','Transcode to Speex 16 kHz',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec Speex (16 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (281,17,'transcode_speex_32','Transcode to Speex 32 kHz',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Always offer the audio codec Speex (32 kHz) to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (282,17,'opus_mono_bitrate','Opus mono bitrate',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'enum',0,'Encoding bitrate for Opus codec if 1-channel mono is in use',0,0,0);
INSERT INTO `voip_preferences` VALUES (283,17,'opus_stereo_bitrate','Opus stereo bitrate',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'enum',0,'Encoding bitrate for Opus codec if 2-channel stereo is in use',0,0,0);
INSERT INTO `voip_preferences` VALUES (284,17,'g723_bitrate','G.723.1 bitrate',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'enum',0,'Encoding bitrate for G.723.1 (5.3 kbit/s for 20-byte frames or 6.3 kbit/s for 24-byte frames',0,0,0);
INSERT INTO `voip_preferences` VALUES (285,8,'outbound_hostname_resolution','Hostname DNS resolution will be used instead of the Peer IP',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:26',0,0,'boolean',0,'Force the system to resolve the peer hostname using DNS to get the destination IP. If activated the peer IP configured in the systed is used for inbound calls only.',0,0,0);
INSERT INTO `voip_preferences` VALUES (286,2,'divert_block_out','Divert Outgoing Blocked Calls',0,1,1,0,0,0,1,0,0,0,0,'2023-10-25 11:10:27',0,0,'string',0,'If set to a number, any outbound calls which are blocked due to outbound block lists or NCOS levels are diverted to the given number.',0,0,0);
INSERT INTO `voip_preferences` VALUES (287,8,'smsc_peer','SMSC Peer',0,1,0,0,1,0,0,0,0,0,0,'2023-10-25 11:10:27',0,0,'enum',0,'SMSC peer to use for outgoing sms messages',0,0,0);
INSERT INTO `voip_preferences` VALUES (288,8,'lcr_peer_cf','Peer selection based on forwarder number',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:27',0,0,'boolean',0,'If set and a CF to an outbound number is configured on the subscriber, the selection of the outbound peer is done using the forwarder as caller number.',0,0,0);
INSERT INTO `voip_preferences` VALUES (289,8,'advice_of_charge','Advice of charge type',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'enum',0,'Define the way \"advice of charge\" message will be sent.',0,0,1);
INSERT INTO `voip_preferences` VALUES (290,4,'clip_no_screening','CLIP no screening',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'CLIP no screening, when enabled the UPN in From is not checked by allowed_clis',0,0,0);
INSERT INTO `voip_preferences` VALUES (291,4,'pai_clir','P-Asserted-Identity CLIR',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'P-Asserted-Identity is anonymized if enabled',0,0,0);
INSERT INTO `voip_preferences` VALUES (292,8,'support_auto_answer','Support Auto-Answer',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Provide Auto-Answer header to the called user if the UA provides this header or dials a Vertical Service Code',0,0,0);
INSERT INTO `voip_preferences` VALUES (293,8,'accept_auto_answer','Accept Auto-Answer',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'enum',0,'Provide Auto-Answer header to this subscriber if requested by the remote user agent',0,0,1);
INSERT INTO `voip_preferences` VALUES (294,8,'rerouting_mode','CFR Mode',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'enum',0,'Specifies the operational mode of the Call Forward on Response. If set to Whitelist (default) the CFR is executed only for reply codes included in the \'rerouting_codes\' list, if set to Blacklist the CFR is executed except for reply codes included in the list.',0,0,1);
INSERT INTO `voip_preferences` VALUES (295,8,'rerouting_codes','List of Response Codes that trigger CFR',0,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'int',0,'Contains a list of SIP codes that are matched with the one received in reply from the subscriber in case of call failure in order to execute the CFR.',0,0,1);
INSERT INTO `voip_preferences` VALUES (296,1,'cfr','Internal Call Forward on Response #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:32',1,0,'int',1,'The id pointing to the \"Call Forward on Response\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (297,3,'count_callforward_as_one','Do not increase outgoing call counter on CF',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If enabled, Call Forwarding does not count as an outgoing call towards concurrent_max limit of subscriber that is doing the forward',0,0,0);
INSERT INTO `voip_preferences` VALUES (298,2,'upn_block_clir','Block outgoing anonymous calls from this user',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If enabled, outgoing anonymous calls from this user will be dropped',0,0,0);
INSERT INTO `voip_preferences` VALUES (299,2,'upn_block_mode','Block Mode for UPN-based call blocking',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Specifies the operational mode of the User-Provided Number (UPN) based call blocking. If unset or set to a false value, it is a blacklist (accept all calls except from UPNs listed in the block list), with a true value it is a whitelist (reject all calls except from UPNs listed in the block list)',0,0,0);
INSERT INTO `voip_preferences` VALUES (300,2,'upn_block_list','Block List for UPN-based call blocking',0,0,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Contains wildcarded User-Provided Numbers that are (not) allowed to be used by the subscriber. \"*\", \"?\" and \"[x-y]\" with \"x\" and \"y\" representing numbers from 0 to 9 may be used as wildcards like in shell patterns.',0,0,0);
INSERT INTO `voip_preferences` VALUES (301,17,'always_transcode','Always transcode media from the user',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:29',0,0,'boolean',0,'If enabled, rtpengine will always trancode any received media to the first (highest priority) codec offered by the other side that is supported for transcoding.',0,0,0);
INSERT INTO `voip_preferences` VALUES (302,4,'force_outb_call_uses_peer_hdrs','Use peer-specific outbound headers when call is forced to peer',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:29',0,0,'boolean',0,'If enabled, set the outbound headers as per peer outbound_* preferences when the call is forced to the peer by force_outbound_calls_to_peer setting. Otherwise, the outbound headers are controlled by the user/domain settings of the subscriber which forces the call to peer (by default).',0,0,0);
INSERT INTO `voip_preferences` VALUES (304,12,'play_announce_before_call_setup','Play announcement before call setup',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Playback announcement as early media before send the call to callee.',0,0,0);
INSERT INTO `voip_preferences` VALUES (305,12,'play_announce_before_recording','Play announcement before recording',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'enum',0,'Playback announcement as early media before start call recording.',0,0,0);
INSERT INTO `voip_preferences` VALUES (306,8,'alert_info_type','Alert-Info Type',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Whether to send a specific Alert-Info to the called party to control the ring tone',0,0,0);
INSERT INTO `voip_preferences` VALUES (307,8,'alert_info_url','Alert-Info URL',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'If the Alert-Info Type is set to \"url\", then specify a URL to a ring tone file (e.g. a WAV file) here',0,0,0);
INSERT INTO `voip_preferences` VALUES (308,5,'original_sendrecv','Leave media direction attributes in SDP unchanged',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If enabled, the media direction attributes (sendrecv, sendonly, recvonly, inactive) from the original SDP will remain unchanged as they were received',0,0,0);
INSERT INTO `voip_preferences` VALUES (309,8,'header_rule_set','Header Rule Set',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'int',0,'Assign a \"Header Rule Set\" to manipulate SIP headers based on dynamic conditions',0,0,0);
INSERT INTO `voip_preferences` VALUES (310,5,'codecs_id_filter','Codecs filter by ID',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Switch between blacklisting (bl) or whitelisting (wl) of codec IDs listed in codecs_id_list (1 for wl, 0 bl).',0,0,0);
INSERT INTO `voip_preferences` VALUES (311,5,'codecs_id_list','Codecs list of IDs',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'string',0,'Comma separated list of audio and video codecs IDs to whitelist or blacklist.',0,0,0);
INSERT INTO `voip_preferences` VALUES (312,13,'DNS_SRV_enable','Enable DNS SRV',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:29',0,0,'boolean',0,'Enable DNS SRV on device when resolving server host',0,0,0);
INSERT INTO `voip_preferences` VALUES (314,5,'announce_error_codes_enable','Play an announcement for failure on outbound call',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If this option is set, the announcements defined in \'announce_error_codes_list\' preference will be played on behalf callee failure in case of outbound calls. In case of activation it is important that the remote endpoint doesn\'t play an announcement, otherwise the final result will be to have 2 announcements.',0,0,0);
INSERT INTO `voip_preferences` VALUES (315,5,'announce_error_codes_list','List of error codes and respective announcements',0,0,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Contains a list of the announcements that will be played to the caller in case the respective error code is returned back from the callee. Each entry of the list has to be a string composed in the following way: <error_code>;<announcement_name>, where error_code is the SIP return code and the announcement_name is name of the announcement taken from the sound_set list. \'*\', \'?\' and \'x-y\' with \'x\' and \'y\' representing numbers from 0 to 9 may be used as wildcards like in shell patterns. For example, to play callee_unknown message in case of 404 returned from the callee: 404;callee_unknown',0,0,0);
INSERT INTO `voip_preferences` VALUES (316,18,'cdr_export_field_separator','Field delimiter',0,1,0,0,0,0,0,0,0,0,0,'2023-10-25 11:10:30',0,0,'string',0,'Field delimiter symbol used in .cdr files.',0,1,0);
INSERT INTO `voip_preferences` VALUES (317,18,'cdr_export_sclidui_rwrs','Rewrite Rule Set for Source/Destination fields',0,1,0,0,0,0,0,0,0,0,0,'2023-10-25 11:10:30',-1,0,'int',0,'Rewrite rule set to apply caller outbound rule to \"SOURCE_CLI\", callee outbound rule to \"DESTINATION_USER_IN\" CDR export fields.',0,1,0);
INSERT INTO `voip_preferences` VALUES (318,18,'cdr_export_sclidui_rwrs_id','Internal Rewrite Rule Set # for Source/Destination fields',0,1,0,0,0,0,0,0,0,0,0,'2023-10-25 11:10:30',1,0,'int',0,NULL,0,1,0);
INSERT INTO `voip_preferences` VALUES (319,3,'allowed_ips_header','IP header to use for \"allowed_ips\" check',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'string',0,'Use IP address for \"allowed_ips\" check from a header name provided in this preference',0,0,0);
INSERT INTO `voip_preferences` VALUES (320,12,'play_announce_to_callee','Play announcement to callee after answer',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Playback announcement to callee after he answered the call (PRO and CARRIER only).',0,0,0);
INSERT INTO `voip_preferences` VALUES (321,4,'colp_cf','Show Call Forward Destination to Caller',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'When forwarding a call, send the destination number or user back to the calling party.',0,0,0);
INSERT INTO `voip_preferences` VALUES (322,17,'transcode_dtmf','Transcode to RFC DTMF events',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:36',0,0,'boolean',0,'Translate inband PCM DTMF tones to RFC DTMF events.',0,0,0);
INSERT INTO `voip_preferences` VALUES (323,1,'cfo','Internal Call Forward Overflow #',1,0,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:32',1,0,'int',1,'The id pointing to the \"Call Forward Overflow\" entry in the voip_cf_mappings table',0,0,0);
INSERT INTO `voip_preferences` VALUES (324,3,'concurrent_max_in_total','Total max number of inbound concurrent calls',1,1,1,1,1,0,1,1,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Maximum total number of incoming concurrent calls going to subscribers.',0,1,0);
INSERT INTO `voip_preferences` VALUES (325,3,'concurrent_max_in_per_account','Maximum number of inbound concurrent calls for Customer',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:32',0,0,'int',0,'Maximum number of incoming concurrent on-net and off-net calls to subscribers within the same Customer account, excluding calls from the application server and intra-PBX calls.',0,0,0);
INSERT INTO `voip_preferences` VALUES (326,3,'concurrent_max_in','Maximum number of inbound concurrent calls',1,1,1,1,1,1,1,1,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Maximum number of incoming concurrent on-net and off-net calls going to a subscriber or coming from a peer, excluding subscriber\'s intra-PBX calls.',0,1,0);
INSERT INTO `voip_preferences` VALUES (327,8,'last_number_redial','Enable last number redial VSC',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Enable the Vertical Service Code to redial latest dialed number for this subscriber/domain.',0,0,0);
INSERT INTO `voip_preferences` VALUES (328,17,'convert_dtmf_info','Convert DTMF INFO to RFC DTMF events',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:32',0,0,'boolean',0,'Convert SIP INFO messages containing application/dtmf-relay or application/dtmf payloads to RFC DTMF events. ATTENTION: for internal use only, external generated INFO messages will be not converted but passed through.',0,0,0);
INSERT INTO `voip_preferences` VALUES (329,8,'contact_ringtimeout','Ring Timeout of each single contact',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'int',0,'Specifies how many seconds each single contact should ring before the calls goes to the next one. It is considered only in case of forking based on Q value.',0,0,0);
INSERT INTO `voip_preferences` VALUES (330,8,'stop_forking_code_lists','List of response codes for which the forking is stopped',0,0,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'int',0,'Contains a list of SIP codes that is matched with the response code received in reply from the subscriber\'s contacts in case of call failure. In case of match, the forking (parallel or based on Q value) is stopped and the code is transparently signaled back to the caller, whereas also an announcement can be played if configured in the existing sound set or a call forward can be triggered if activated. Response codes 600, 603, 604, 606 are implicitly included in the list.',0,0,0);
INSERT INTO `voip_preferences` VALUES (331,4,'emergency_upn','Emergency User-Provided-Number Field',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Select if, in case of emergency calls, the subscriber\'s User-Provided-Number is ovewritten with the Network-Provided-Number (default) or not.',0,0,0);
INSERT INTO `voip_preferences` VALUES (332,4,'outbound_pai_display','Outbound PAI Display-Name Field',0,1,1,1,1,1,0,0,0,0,0,'0000-00-00 00:00:00',0,0,'enum',0,'The content to put into the PAI display-name for outbound calls',0,0,0);
INSERT INTO `voip_preferences` VALUES (333,8,'concurrent_calls_quota','A user defined quota for concurrent calls, does not block calls',1,1,1,1,1,1,1,1,0,0,0,'2023-10-25 11:10:33',0,0,'int',0,'Contains a user defined quota for concurrent calls, the preference does not have an impact on ongoing calls and used mostly for reporting reasons, when a soft limit for calls needs to defined, based on which the subscriber/customer/peer is reported or charged for making too many calls.',0,0,0);
INSERT INTO `voip_preferences` VALUES (334,3,'calllist_clir_scope','Option for defining when CLIR should be used',0,1,1,1,1,0,1,1,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Contains options for defining the scope in which CLIR is applied in the call lists: External(default; hide caller in clir enabled calls, except calls within the same customer) or All(hide caller for clir enabled calls)',0,0,0);
INSERT INTO `voip_preferences` VALUES (335,17,'T38_decode','Translate T.38 offer into T.30 audio',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'Any T.38 fax media that is offered to this subscriber or peer will be translated into audio media carrying T.30 fax data.',0,0,0);
INSERT INTO `voip_preferences` VALUES (336,17,'T38_force','Force translation of audio media to T.38 offer',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'Any audio media that is offered to this subscriber or peer will be translated into T.38 fax media.',0,0,0);
INSERT INTO `voip_preferences` VALUES (337,17,'T38_no_ECM','T.38: Disable ECM support',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, do not advertise support for, and do not negotiate, T.30 ECM (error correction mode). Support for ECM is enabled by default.',0,0,0);
INSERT INTO `voip_preferences` VALUES (338,17,'T38_no_V17','T.38: Disable V.17 support',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, do not support the V.17 fax modem protocol (12.0 and 14.4 kbit/s). Support for V.17 is enabled by default.',0,0,0);
INSERT INTO `voip_preferences` VALUES (339,17,'T38_no_V27ter','T.38: Disable V.27ter support',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, do not support the V.27ter fax modem protocol (2.4 and 4.8 kbit/s half-duplex). Support for V.27ter is enabled by default.',0,0,0);
INSERT INTO `voip_preferences` VALUES (340,17,'T38_no_V29','T.38: Disable V.29 support',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, do not support the V.29 fax modem protocol (between 4.8 and 9.6 kbit/s). Support for V.29 is enabled by default.',0,0,0);
INSERT INTO `voip_preferences` VALUES (341,17,'T38_no_V34','T.38: Disable V.34 support',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, do not support the V.34 fax modem protocol (up to 33.8 kbit/s). Support for V.34 is enabled by default.',0,0,0);
INSERT INTO `voip_preferences` VALUES (342,17,'T38_no_IAF','T.38: Disable IAF support',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, do not support the IAF fax protocol (Internet-Aware Fax). Support for IAF is enabled by default.',0,0,0);
INSERT INTO `voip_preferences` VALUES (343,17,'T38_FEC','T.38: Use FEC',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'When using the T.38 gateway, use UDPTL FEC (forward error correction) instead of the default UDPTL redundancy protocol. This is only useful in combination with T38_force as this is a negotiated parameter.',0,0,0);
INSERT INTO `voip_preferences` VALUES (344,5,'OSRTP_offer','Offer OSRTP',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:33',0,0,'boolean',0,'Offer optional opportunistic SRTP (OSRTP, RFC 8643) to the called party.',0,0,0);
INSERT INTO `voip_preferences` VALUES (346,17,'AMR_bitrate','AMR: initial bitrate',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Initial encoder bitrate (mode) to use when offering to transcode to AMR. The bitrate is further constrained by the mode-set and can change dynamically via a CMR.',0,0,0);
INSERT INTO `voip_preferences` VALUES (347,17,'AMR_octet_align','AMR: octet-aligned mode',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'Use octet-aligned mode instead of bandwidth-efficient mode when offering to transcode to AMR.',0,0,0);
INSERT INTO `voip_preferences` VALUES (348,17,'AMR_mode_set','AMR: mode-set',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'string',0,'Restrict the AMR encoders (both local and remote) to the given list of AMR bitrates (modes). Must be a comma-separated list of integer modes without spaces, e.g. \'2,3,4,5\'.',0,0,0);
INSERT INTO `voip_preferences` VALUES (349,17,'AMR_mode_change_period','AMR: mode change period',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Restrict the AMR encoders (both local and remote) to change modes only every other packet (period 2) instead of any packet (period 1, default).',0,0,0);
INSERT INTO `voip_preferences` VALUES (350,17,'AMR_mode_change_neighbor','AMR: mode change neighbor',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'Restrict the AMR encoders (both local and remote) to change mode only to neighbouring modes instead of any random mode.',0,0,0);
INSERT INTO `voip_preferences` VALUES (351,17,'AMR_CMR_interval','AMR: CMR interval',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'int',0,'Interval in milliseconds at which to send a Codec Mode Request (CMR) for a higher bitrate to the remote encoder if it isn\'t already sending at the highest allowed bitrate. Default is not to send any CMR.',0,0,0);
INSERT INTO `voip_preferences` VALUES (352,17,'AMR_mode_change_interval','AMR: mode change interval',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'int',0,'Interval in milliseconds at which to perform an unsolicited change to a higher bitrate if the local encoder isn\'t already sending at the highest allowed bitrate. Default is not to perform unsolicited mode changes.',0,0,0);
INSERT INTO `voip_preferences` VALUES (353,17,'AMR_WB_bitrate','AMR-WB: initial bitrate',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Initial encoder bitrate (mode) to use when offering to transcode to AMR-WB. The bitrate is further constrained by the mode-set and can change dynamically via a CMR.',0,0,0);
INSERT INTO `voip_preferences` VALUES (354,17,'AMR_WB_octet_align','AMR-WB: octet-aligned mode',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'Use octet-aligned mode instead of bandwidth-efficient mode when offering to transcode to AMR-WB.',0,0,0);
INSERT INTO `voip_preferences` VALUES (355,17,'AMR_WB_mode_set','AMR-WB: mode-set',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'string',0,'Restrict the AMR-WB encoders (both local and remote) to the given list of AMR-WB bitrates (modes). Must be a comma-separated list of integer modes without spaces, e.g. \'2,3,4,5\'.',0,0,0);
INSERT INTO `voip_preferences` VALUES (356,17,'AMR_WB_mode_change_period','AMR-WB: mode change period',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Restrict the AMR-WB encoders (both local and remote) to change modes only every other packet (period 2) instead of any packet (period 1, default).',0,0,0);
INSERT INTO `voip_preferences` VALUES (357,17,'AMR_WB_mode_change_neighbor','AMR-WB: mode change neighbor',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'Restrict the AMR-WB encoders (both local and remote) to change mode only to neighbouring modes instead of any random mode.',0,0,0);
INSERT INTO `voip_preferences` VALUES (358,17,'AMR_WB_CMR_interval','AMR-WB: CMR interval',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'int',0,'Interval in milliseconds at which to send a Codec Mode Request (CMR) for a higher bitrate to the remote encoder if it isn\'t already sending at the highest allowed bitrate. Default is not to send any CMR.',0,0,0);
INSERT INTO `voip_preferences` VALUES (359,17,'AMR_WB_mode_change_interval','AMR-WB: mode change interval',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'int',0,'Interval in milliseconds at which to perform an unsolicited change to a higher bitrate if the local encoder isn\'t already sending at the highest allowed bitrate. Default is not to perform unsolicited mode changes.',0,0,0);
INSERT INTO `voip_preferences` VALUES (360,17,'AMR_mode_change_capability','AMR: mode change capability',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Advertise to the peer that the AMR encoder is able to perform mode changes in a restricted interval (2), or that the encoder is not capable of doing that (1), or don\'t advertise that capability at all (omit).',0,0,0);
INSERT INTO `voip_preferences` VALUES (361,17,'AMR_WB_mode_change_capability','AMR-WB: mode change capability',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Advertise to the peer that the AMR-WB encoder is able to perform mode changes in a restricted interval (2), or that the encoder is not capable of doing that (1), or don\'t advertise that capability at all (omit).',0,0,0);
INSERT INTO `voip_preferences` VALUES (362,5,'single_codec','Single-codec answers',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'Restrict every answer to just the first preferred codec.',0,0,0);
INSERT INTO `voip_preferences` VALUES (363,5,'DTLS_fingerprint','DTLS fingerprint hashing function',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Use the specified hashing function to communicate the DTLS certificate\'s fingerprint to the peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (364,8,'lookup_all_registrations','Route incoming subscriber calls to all registered devices belonging to the subscriber',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'By default incoming calls to subscriber\'s primary number and standard aliases are routed only to devices registered by subscriber\'s username. Enabling this option allows to route the calls also to endpoints registered as devices (those who use subscriber\'s alias to register).',0,0,0);
INSERT INTO `voip_preferences` VALUES (365,9,'ext_range_min','Minimum value for subscriber extension number',1,1,0,0,0,0,1,1,0,0,0,'2023-10-25 11:10:34',0,0,'int',0,'Specifies the minimum value that can be assigned as extension to a subscriber. If left empty, only the maximum value will be considered. If both are empty, there is no extension range limit.',0,0,0);
INSERT INTO `voip_preferences` VALUES (366,9,'ext_range_max','Maximum value for subscriber extension number',1,1,0,0,0,0,1,1,0,0,0,'2023-10-25 11:10:34',0,0,'int',0,'Specifies the maximum value that can be assigned as extension to a subscriber. If left empty, only the minimum value will be considered. If both are empty, there is no extension range limit.',0,0,0);
INSERT INTO `voip_preferences` VALUES (367,5,'ICE_lite','Restrict ICE support to ICE-lite',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'When ICE support is enabled towards this peer, act as an ICE agent that supports only ICE-lite instead of full ICE.',0,0,0);
INSERT INTO `voip_preferences` VALUES (368,17,'transcode_cn','Transcode to comfort noise payload',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:36',0,0,'boolean',0,'Enable detection of silence in received RTP audio and transcode to CN (comfort noise) RTP packets if supported by the peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (369,5,'generate_rtcp','Generate RTCP',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'boolean',0,'Locally track RTP statistics for each media stream and generate RTCP reports to send to the peers, instead of just passing through RTCP reports sent by the peers.',0,0,0);
INSERT INTO `voip_preferences` VALUES (370,4,'no_404_fallback','Do not fallback after a callee 404 response',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'If set, do not try to fallback if the callee UAc replies with a \'404 Not found\' message after receiving an extension included in the base number or a e164 number (if e164_to_ruri is set)',0,0,0);
INSERT INTO `voip_preferences` VALUES (371,8,'emergency_provider_info','Emergency Provider info',2,1,0,0,1,0,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'blob',0,'XML with the ProviderInfo data that will be added as MIME object on an emergency call',0,0,0);
INSERT INTO `voip_preferences` VALUES (372,4,'emergency_location_format','Emergency location format',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:34',0,0,'enum',0,'Defines the format of emergency_location_object',0,0,0);
INSERT INTO `voip_preferences` VALUES (373,5,'rtp_debug','Enable RTP proxy debugging',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:35',0,0,'boolean',0,'Enables full debug logging in the RTP proxy for all calls from or to this subscriber or peer.',0,0,0);
INSERT INTO `voip_preferences` VALUES (374,12,'play_emulated_ringback_tone','Play emulated ringback tone after pre-call announcements',0,1,1,1,1,1,1,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Play an emulated ringback tone as early media after the pre-call announcements. The ringback tone is played while the final callee is ringing and only if a 180 Ringing message is received from the callee endpoint.',0,0,0);
INSERT INTO `voip_preferences` VALUES (375,8,'stir_pub_url','Public key HTTP URL',0,1,0,0,1,0,0,0,0,0,0,'2023-10-25 11:10:35',0,0,'string',0,'RFC8224 Authenticated Identity Management in the Session Initiation Protocol',0,0,0);
INSERT INTO `voip_preferences` VALUES (376,8,'stir_check','Enable STIR Identity validation',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'RFC8224 Authenticated Identity Management in the Session Initiation Protocol',0,0,0);
INSERT INTO `voip_preferences` VALUES (377,6,'peer_auth_hf_user','Specific value for the Authorization username',0,1,1,0,0,1,0,0,0,0,0,'2023-10-25 11:10:35',0,0,'string',0,'This value will be specifically used as the \'username\' parameter in the Proxy-Authorization/Authorization header (an invitation/a registration session accordingly)',0,0,0);
INSERT INTO `voip_preferences` VALUES (378,5,'sdp_crypto_base64_padding','SDP Crypto base64 padding',1,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'With this flag set, Trailing `=\' characters used for base64 SDP crypto padding, will be left in place',0,0,0);
INSERT INTO `voip_preferences` VALUES (379,8,'allow_lm_forward_loop','Allow loop to same peering group for location mapping \'forward\'',1,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:36',0,0,'boolean',0,'By default calls that come from a peer group and are looped back to the same peer group due to a subscriber location mappings \'forward\' entry are blocked to avoid loop creation. This preference allows to override the default behavior and permit the loop over the same peering group. It has to be used with caution and activated only if necessary.',0,0,0);
INSERT INTO `voip_preferences` VALUES (380,9,'busy_hg_member_mode','Busy huntgroup member mode',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Defines whether a subscriber can accept a hunt group call when busy in another call or to exclude it from the hunt group targets based on either \'totaluser\' or \'activeuser\' call counters',0,0,0);
INSERT INTO `voip_preferences` VALUES (381,8,'csc_calls','CSC calls',1,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'Defines if a subscriber can initiate calls from the CSC',0,0,0);
INSERT INTO `voip_preferences` VALUES (382,17,'opus_complexity','Opus encoding complexity',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'enum',0,'Encoding complexity (compression level) for Opus codec',0,0,0);
INSERT INTO `voip_preferences` VALUES (383,2,'ncos_set_id','Internal NCOS Set #',1,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:38',1,1,'int',0,NULL,0,0,1);
INSERT INTO `voip_preferences` VALUES (384,2,'ncos_set','NCOS Set',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',-1,1,'string',0,'Specifies the NCOS Set that applies to the user',0,0,1);
INSERT INTO `voip_preferences` VALUES (385,2,'adm_ncos_set_id','Internal Administrative NCOS Set #',1,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (386,2,'adm_ncos_set','Administrative NCOS Set',0,1,1,1,1,0,1,0,0,0,0,'2023-10-25 11:10:37',-1,0,'string',0,'Same as \"ncos_set\", but may only be set by administrators and is applied prior to the user setting.',0,0,0);
INSERT INTO `voip_preferences` VALUES (387,2,'adm_cf_ncos_set_id','Internal Administrative NCOS Set for Call Forward#',1,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (388,2,'adm_cf_ncos_set','Administrative NCOS Set for Call Forward',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',-1,0,'string',0,'Specifies the Administrative NCOS Set that applies for the Call Forward from the user.',0,0,0);
INSERT INTO `voip_preferences` VALUES (389,13,'user_conf_priority','User config priority over provisioning',0,1,0,0,0,0,0,0,1,1,1,'2023-10-25 11:10:37',0,0,'boolean',0,'If set, the configuration done by the user directly on the phone have priority over the provisioning (attention: not all the phones support this option).',0,0,0);
INSERT INTO `voip_preferences` VALUES (390,4,'colp_pstn','Show PSTN Destination to Caller',0,1,1,1,1,0,0,0,0,0,0,'2023-10-25 11:10:37',0,1,'boolean',0,'When calling PSTN, show the destination number or user back to the calling party.',0,0,0);
INSERT INTO `voip_preferences` VALUES (391,17,'opus_legacy_mono','Legacy Opus mono format',0,1,1,1,1,1,0,0,0,0,0,'2023-10-25 11:10:37',0,0,'boolean',0,'Use legacy non-standard method to signal single-channel Opus. The default is the standards-compliant method of always advertising Opus as a two-channel format while hinting to mono usage as a format parameter.',0,0,0);
INSERT INTO `voip_preferences` VALUES (392,8,'csc_registered_devices','CSC Registered Devices',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:38',1,1,'boolean',0,'\'CSC Registered Devices\' - An internal flag to be able to map Registered Devices visibility to subscriber profiles. Not directly used',0,0,1);
INSERT INTO `voip_preferences` VALUES (393,8,'csc_conversations','CSC Conversations',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:38',1,1,'boolean',0,'\'CSC Conversations\' - An internal flag to be able to map Conversations visibility to subscriber profiles. Not directly used',0,0,1);
INSERT INTO `voip_preferences` VALUES (394,8,'csc_device_provisioning','CSC Device Provisioning',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:38',1,1,'boolean',0,'\'CSC Device Provisioning\' - An internal flag to be able to map Device Provisioning visibility to subscriber profiles. Not directly used',0,0,1);
INSERT INTO `voip_preferences` VALUES (395,8,'csc_hunt_groups','CSC Hunt Groups',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:38',1,1,'boolean',0,'\'CSC Hunt Groups\' - An internal flag to be able to map Hunt Groups visibility to subscriber profiles. Not directly used',0,0,1);
INSERT INTO `voip_preferences` VALUES (396,6,'peer_auth_registrar_server','Specific value for the registrar server',0,1,0,0,0,1,0,0,0,0,0,'2023-10-25 11:10:38',0,0,'string',0,'Registrar server value is used as a registration R-URI as well as From/To domain in the outbound REGISTER.',0,0,0);
INSERT INTO `voip_preferences` VALUES (397,8,'reseller_id','Internal Reseller #\'',1,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:38',1,0,'int',0,NULL,0,0,0);
INSERT INTO `voip_preferences` VALUES (398,9,'cloud_pbx_hunt_cancel_mode','termination mode for early stage legs',0,1,1,0,0,0,0,0,0,0,0,'2023-10-25 11:10:38',1,1,'enum',0,'This is a termination mode for call legs in the early dialog stage. Can be: bye or cancel.',0,0,0);
INSERT INTO `voip_preferences` VALUES (399,5,'sip_ping_notify','Enable CSTA notification',0,1,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:38',0,0,'boolean',0,'When a user fails answering to our SIP ping, trigger a CSTA notification.',0,0,0);
INSERT INTO `voip_preferences` VALUES (400,5,'sip_ping_notify_codecs_list','Reply code triggering notify',0,0,1,1,0,0,0,0,0,0,0,'2023-10-25 11:10:38',0,0,'int',0,'Specify the list of SIP responses to the SIP ping that triggers a CSTA event notification. NOTE: the following reply codes will never trigger an event because they are considered positive answers: 200, 403, 404, 405, 486.',0,0,0);
INSERT INTO `voip_preferences_enum` VALUES (8,62,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (9,62,'no','no',1,1,0,0,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (10,62,'no','no',0,0,1,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (11,62,'no','no',0,0,0,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (12,62,'yes','yes',1,1,1,1,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (13,66,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (14,66,'UPDATE_FALLBACK_INVITE','UPDATE_FALLBACK_INVITE',1,1,0,0,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (15,66,'UPDATE_FALLBACK_INVITE','UPDATE_FALLBACK_INVITE',0,0,1,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (16,66,'UPDATE_FALLBACK_INVITE','UPDATE_FALLBACK_INVITE',0,0,0,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (17,66,'UPDATE','UPDATE',1,1,1,1,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (18,66,'INVITE','INVITE',1,1,1,1,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (19,70,'default',NULL,1,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (20,71,'From-Username',NULL,0,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (21,71,'From-Displayname','from_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (22,71,'P-Asserted-Identity','pai_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (23,71,'P-Preferred-Identity','ppi_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (24,71,'Remote-Party-ID','rpid_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (25,72,'From-Username',NULL,0,0,0,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (26,72,'From-Displayname','from_display',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (27,72,'P-Asserted-Identity','pai_user',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (28,72,'P-Preferred-Identity','ppi_user',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (29,72,'Remote-Party-ID','rpid_user',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (30,73,'Network-Provided-Number','npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (31,73,'User-Provided-Number','upn',0,0,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (32,73,'Authentication-User','auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (33,73,'Received Display-name','rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (34,74,'None',NULL,0,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (35,74,'Network-Provided-Number','npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (36,74,'User-Provided-Number','upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (37,74,'Authentication-User','auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (38,74,'Received Display-name','rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (39,75,'None',NULL,0,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (40,75,'Network-Provided-Number','npn',0,0,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (41,75,'User-Provided-Number','upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (42,75,'Authentication-User','auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (43,75,'Received Display-name','rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (44,76,'None',NULL,0,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (45,76,'Network-Provided-Number','npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (46,76,'User-Provided-Number','upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (47,76,'Authentication-User','auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (48,76,'Received Display-name','rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (49,71,'use domain default',NULL,1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (50,71,'From-Username','from_user',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (51,73,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (53,74,'use domain default',NULL,1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (54,74,'None','none',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (55,75,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (56,75,'None','none',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (57,76,'use domain default',NULL,1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (58,76,'None','none',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (59,75,'Network-Provided-Number ','npn',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (60,73,'User-Provided-Number','upn',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (61,81,'None','none',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (62,81,'Forwarder\'s NPN','npn',0,0,1,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (63,81,'Forwarder\'s NPN','npn',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (64,81,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (65,81,'Forwarder\'s NPN / Received Diversion','npn_diversion',1,1,1,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (66,81,'Received Diversion','diversion',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (67,82,'None',NULL,0,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (68,82,'None','none',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (69,82,'use domain default',NULL,1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (70,82,'UPRN','uprn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (71,73,'UPRN (if set) or Network-Provided-Number','uprn/npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (72,73,'UPRN (if set) or User-Provided-Number','uprn/upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (73,73,'UPRN (if set) or Authentication-User','uprn/auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (74,73,'UPRN (if set) or Received Display-name','uprn/rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (75,74,'UPRN (if set) or Network-Provided-Number','uprn/npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (76,74,'UPRN (if set) or User-Provided-Number','uprn/upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (77,74,'UPRN (if set) or Authentication-User','uprn/auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (78,74,'UPRN (if set) or Received Display-name','uprn/rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (79,75,'UPRN (if set) or Network-Provided-Number','uprn/npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (80,75,'UPRN (if set) or User-Provided-Number','uprn/upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (81,75,'UPRN (if set) or Authentication-User','uprn/auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (82,75,'UPRN (if set) or Received Display-name','uprn/rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (83,76,'UPRN (if set) or Network-Provided-Number','uprn/npn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (84,76,'UPRN (if set) or User-Provided-Number','uprn/upn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (85,76,'UPRN (if set) or Authentication-User','uprn/auth_user',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (86,76,'UPRN (if set) or Received Display-name','uprn/rcv_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (87,90,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (88,90,'Always with plain SDP','ice_strip_candidates',0,0,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (89,90,'Always with rtpproxy as additional ICE candidate','ice_add_candidates',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (90,90,'Always with rtpproxy as only ICE candidate','ice_replace_candidates',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (91,90,'Never','never',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (92,91,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (93,91,'Force IPv4','force_ipv4',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (94,91,'Force IPv6','force_ipv6',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (105,97,'serial','serial',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (106,97,'parallel','parallel',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (107,101,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (108,101,'Strip','strip',0,0,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (109,101,'Pass-through','passthrough',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (110,101,'Replace','replace',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (111,103,'None',NULL,0,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (112,103,'None','none',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (113,103,'use domain default',NULL,1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (114,103,'UPRN','uprn',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (115,74,'Network-Provided Display-name','np_display',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (116,73,'Peer authentication name','peer_auth_user',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (117,75,'Peer authentication name','peer_auth_user',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (118,76,'Peer authentication name','peer_auth_user',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (119,90,'Always with plain SDP','ice_strip_candidates',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (120,91,'Auto-detect','auto',0,0,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (121,91,'Auto-detect','auto',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (122,107,'use domain default',NULL,1,1,0,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (123,107,'Never','never',0,0,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (124,107,'If callee is offline','force_offline',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (125,107,'If callee is offline and number is primary','force_offline_primary',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (126,107,'If callee is offline and number is alias','force_offline_alias',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (127,107,'Always','force',1,1,1,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (128,107,'If callee is not local','force_nonlocal',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (129,111,'use domain default',NULL,1,0,0,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (130,111,'Never','never',1,1,1,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (131,111,'If both parties are behind same NAT','same_nat',1,1,1,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (132,107,'Never','never',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (133,123,'None',NULL,0,1,1,1,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (134,124,'use customer/domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (135,124,'Replace with Network-Provided Number','override_by_usernpn',1,1,0,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (136,124,'Replace with Network-Provided Number','override_by_usernpn',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (137,124,'Force CLIR','override_by_clir',1,1,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (138,124,'Reject with 403','reject',1,1,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (139,124,'use domain default',NULL,0,1,0,0,1,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (140,97,'random','random',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (141,97,'circular','circular',1,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (142,135,'use domain default',NULL,1,1,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (143,135,'Strict number matching','strict',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (144,135,'Extended matching, send dialed number with extension','extended_send_dialed',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (145,135,'Extended matching, send dialed number with extension','extended_send_dialed',1,1,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (146,135,'Extended matching, send base matching number','extended_send_base',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (147,136,'use domain default',NULL,1,1,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (148,136,'Called user','callee',0,0,1,1,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (149,136,'Called user','callee',1,1,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (150,136,'Received To header','rcvd_to',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (151,136,'Original (Forwarding) called user','orig_callee',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (152,139,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (153,139,'German','de',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (154,139,'English','en',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (155,139,'English','en',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (156,139,'Spanish','es',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (157,139,'Italian','it',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (159,145,'default',NULL,1,1,1,1,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (165,152,'use domain default',NULL,1,1,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (166,152,'Transparent','transparent',1,1,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (167,152,'Transparent','transparent',0,0,1,1,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (168,152,'RTP/AVP (plain RTP)','RTP/AVP',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (169,152,'RTP/SAVP (encrypted SRTP)','RTP/SAVP',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (170,152,'RTP/AVPF (RTP with RTCP feedback)','RTP/AVPF',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (171,152,'RTP/SAVPF (encrypted SRTP with RTCP feedback)','RTP/SAVPF',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (172,152,'UDP/TLS/RTP/SAVP (encrypted SRTP using DTLS-SRTP)','UDP/TLS/RTP/SAVP',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (173,152,'UDP/TLS/RTP/SAVPF (encrypted SRTP using DTLS-SRTP with RTCP feedback)','UDP/TLS/RTP/SAVPF',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (176,107,'Always force calls to other customers','force_interpbx',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (177,111,'If both parties are on public IP','both_public',1,0,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (178,165,'libswrate','libswrate',0,0,1,0,1,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (180,139,'Romanian','ro',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (181,101,'Strip','strip',1,1,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (182,81,'Forwarder\'s UPN','upn',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (183,107,'If callee is not local and is ported','force_nonlocal_lnp',0,0,0,1,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (184,178,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (185,178,'Enabled','enabled',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (186,178,'Enabled','enabled',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (187,178,'Disabled','disabled',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (188,90,'Always with rtpproxy as ICE relay candidate','ice_force_relay_candidates',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (189,107,'If caller and callee belong to different domains','force_interdomain',1,0,1,0,1,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (190,260,'use domain default',NULL,1,1,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (191,260,'When behind NAT','yes',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (192,260,'When behind NAT','yes',1,1,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (193,260,'No','no',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (194,1,'none',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (195,1,'foreign','1',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (196,1,'outgoing','2',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (197,1,'incoming and outgoing','3',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (198,1,'global','4',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (199,1,'ported','5',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (200,1,'none','0',0,0,0,0,NULL,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (201,263,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (202,263,'Never','no',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (203,263,'Never','no',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (204,263,'If received Diversion or History-Info header','yes',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (205,263,'If user in received Diversion or History-Info header is in caller\'s alias list','check_aliases',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (206,263,'If user in received Diversion or History-Info header is in caller\'s alias list or allowed_clis','check_allowed_clis',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (207,82,'Network-Provided Number','npn',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (208,267,'Internal','internal',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (209,267,'External','external',0,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (210,263,'If received Diversion header','diversion',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (211,263,'If received History-Info header','historyinfo',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (212,268,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (213,268,'unchanged/default','default',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (214,268,'5 ms','5',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (215,268,'10 ms','10',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (216,268,'20 ms','20',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (217,268,'30 ms','30',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (218,268,'40 ms','40',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (219,268,'50 ms','50',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (220,268,'60 ms','60',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (221,282,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (222,282,'default (auto)','default',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (223,282,'10 kbit/s','10000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (224,282,'24 kbit/s','24000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (225,282,'32 kbit/s','32000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (226,283,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (227,283,'default (auto)','default',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (228,283,'24 kbit/s','24000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (229,283,'32 kbit/s','32000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (230,283,'64 kbit/s','64000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (231,283,'128 kbit/s','128000',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (232,284,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (233,284,'default (auto)','default',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (234,284,'5.3 kbit/s','5300',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (235,284,'6.3 kbit/s','6300',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (236,287,'default','default_smsc',0,0,1,0,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (244,289,'no',NULL,1,0,1,0,1,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (245,289,'Currency','currency',1,0,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (246,289,'Pulse','pulse',1,0,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (247,292,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (248,292,'No','no',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (249,292,'No','no',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (250,292,'If provided by phone','phone',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (251,292,'If provided by phone or dialed VSC','vsc',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (252,293,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (253,293,'Yes','yes',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (254,293,'Yes','yes',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (255,293,'No','no',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (256,294,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (257,294,'Whitelist','whitelist',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (258,294,'Whitelist','whitelist',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (259,294,'Blacklist','blacklist',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (260,60,'use domain default',NULL,1,1,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (261,60,'Never','never',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (262,60,'Never','never',1,1,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (263,60,'Always','force',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (264,60,'If callee is offline','force_offline',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (265,60,'If callee is offline and number is primary','force_offline_primary',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (266,60,'If callee is offline and number is alias','force_offline_alias',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (267,306,'default',NULL,1,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (268,306,'internal_external','internal_external',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (269,306,'url','url',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (272,139,'French','fr',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (273,260,'Force ping','always',1,1,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (274,108,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (275,108,'No','no',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (276,108,'No','no',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (277,108,'Standard','standard',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (278,108,'Probability','probability',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (279,331,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (280,331,'Network-Provided-Number','npn',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (281,331,'Network-Provided-Number','npn',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (282,331,'User-Provided-Number','upn',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (283,332,'None',NULL,0,1,1,1,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (284,332,'None','none',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (285,332,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (286,332,'Network-Provided-Number','npn',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (287,332,'User-Provided-Number','upn',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (288,332,'Authentication-User','auth_user',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (289,332,'Received Display-name','rcv_display',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (290,332,'UPRN (if set) or Network-Provided-Number','uprn/npn',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (291,332,'UPRN (if set) or User-Provided-Number','uprn/upn',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (292,332,'UPRN (if set) or Authentication-User','uprn/auth_user',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (293,332,'UPRN (if set) or Received Display-name','uprn/rcv_display',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (294,332,'Network-Provided Display-name','np_display',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (295,178,'Enabled and Immediate','immediate',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (296,73,'intra-PBX extension OR UPN','pbx_extension',1,0,1,1,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (297,74,'PBX extension OR UPN','pbx_extension',1,0,1,1,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (298,74,'PBX extension OR Network-Provided Display-Name','pbx_extension/np_display',1,0,1,1,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (299,334,'use domain default',NULL,0,0,0,0,1,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (300,334,'use customer/domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (301,334,'External','external',1,0,0,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (302,334,'External','external',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (303,334,'All','all',1,0,1,0,0,1,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (304,139,'Arabic','ar',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (305,139,'Hebrew','he',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (306,139,'Dutch','nl',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (307,346,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (308,346,'default (auto)','',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (309,346,'4.75 kbit/s (mode 0)','4750',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (310,346,'5.15 kbit/s (mode 1)','5150',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (311,346,'5.9 kbit/s (mode 2)','5900',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (312,346,'6.7 kbit/s (mode 3)','6700',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (313,346,'7.4 kbit/s (mode 4)','7400',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (314,346,'7.95 kbit/s (mode 5)','7950',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (315,346,'10.2 kbit/s (mode 6)','10200',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (316,346,'12.2 kbit/s (mode 7)','12200',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (317,349,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (318,349,'1','',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (319,349,'2','2',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (320,353,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (321,353,'default (auto)','',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (322,353,'6.6 kbit/s (mode 0)','6600',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (323,353,'8.85 kbit/s (mode 1)','8850',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (324,353,'12.65 kbit/s (mode 2)','12650',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (325,353,'14.25 kbit/s (mode 3)','14250',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (326,353,'15.85 kbit/s (mode 4)','15850',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (327,353,'18.25 kbit/s (mode 5)','18250',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (328,353,'19.85 kbit/s (mode 6)','19850',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (329,353,'23.05 kbit/s (mode 7)','23050',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (330,353,'23.85 kbit/s (mode 8)','23850',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (331,356,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (332,356,'1','',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (333,356,'2','2',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (334,136,'intra-PBX extension OR Called user','pbx_extension',1,0,1,1,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (335,75,'intra-PBX extension or UPN','pbx_extension',1,0,1,1,0,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (336,360,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (337,360,'omit','',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (338,360,'1','1',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (339,360,'2','2',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (340,361,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (341,361,'omit','',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (342,361,'1','1',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (343,361,'2','2',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (344,363,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (345,363,'SHA-1','sha-1',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (346,363,'SHA-224','sha-224',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (347,363,'SHA-256','sha-256',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (348,363,'SHA-384','sha-384',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (349,363,'SHA-512','sha-512',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (350,90,'Use remote client\'s ICE preference','ice_client_preference',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (351,372,'Presence Information Data Format Location\n   Object','PIDF-LO',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (352,372,'cirpack','cirpack',1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (353,135,'Extended matching, send primary number with extension','extended_send_primary_plus_extension',1,1,1,0,NULL,0,0,0,0,NULL,NULL);
INSERT INTO `voip_preferences_enum` VALUES (354,305,'Use domain default / contract default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (355,305,'Use domain default',NULL,0,0,0,0,1,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (356,305,'Always','always',1,0,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (357,305,'External calls only','external_calls_only',1,0,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (358,305,'Internal calls only','internal_calls_only',1,0,1,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (359,305,'Never','never',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (360,77,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (361,77,'Never send push','never',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (362,77,'Never send push','never',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (363,77,'Always send push','always',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (364,77,'Send push only if no device registered','no_reg',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (365,77,'Always send push, skip registered devices','only_push',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (366,77,'Registered devices, then send push','reg_then_push',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (367,77,'Send push, then registered devices','push_then_reg',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (368,305,'Never','never',1,0,0,0,1,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (369,97,'none','none',1,0,0,0,NULL,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (370,380,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (371,380,'ring','ring',1,0,0,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (372,380,'ring','ring',0,0,1,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (373,380,'skip based on totaluser','skip_totaluser',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (374,380,'skip based on activeuser','skip_activeuser',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (375,382,'use domain default',NULL,1,0,0,0,0,0,0,0,0,1,NULL);
INSERT INTO `voip_preferences_enum` VALUES (376,382,'default (10 = slowest)','default',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (377,382,'0 (fastest, worst quality)','0',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (378,382,'1','1',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (379,382,'2 (faster, worse quality)','2',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (380,382,'3','3',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (381,382,'4','4',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (382,382,'5 (medium)','5',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (383,382,'6','6',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (384,382,'7','7',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (385,382,'8 (slower, better quality)','8',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (386,382,'9','9',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (387,382,'10 (slowest, best quality)','10',1,1,1,1,0,0,0,0,0,0,NULL);
INSERT INTO `voip_preferences_enum` VALUES (388,398,'bye','bye',1,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `voip_preferences_enum` VALUES (389,398,'cancel','cancel',1,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `voip_preferences_enum` VALUES (390,139,'Brazilian Portuguese','pt_br',1,0,1,0,0,0,0,0,0,0,NULL);
INSERT INTO `voip_sound_groups` VALUES (1,'early_rejects');
INSERT INTO `voip_sound_groups` VALUES (2,'pbx');
INSERT INTO `voip_sound_groups` VALUES (3,'calling_card');
INSERT INTO `voip_sound_groups` VALUES (4,'music_on_hold');
INSERT INTO `voip_sound_groups` VALUES (5,'mobile_push');
INSERT INTO `voip_sound_groups` VALUES (6,'voucher_recharge');
INSERT INTO `voip_sound_groups` VALUES (7,'play_balance');
INSERT INTO `voip_sound_groups` VALUES (8,'digits');
INSERT INTO `voip_sound_groups` VALUES (9,'conference');
INSERT INTO `voip_sound_groups` VALUES (10,'malicious_call_identification');
INSERT INTO `voip_sound_groups` VALUES (11,'custom_announcements');
INSERT INTO `voip_sound_groups` VALUES (12,'recent_calls');
INSERT INTO `voip_sound_groups` VALUES (13,'early_media');
INSERT INTO `voip_sound_handles` VALUES (1,'block_in',1,1);
INSERT INTO `voip_sound_handles` VALUES (2,'block_out',1,1);
INSERT INTO `voip_sound_handles` VALUES (3,'block_ncos',1,1);
INSERT INTO `voip_sound_handles` VALUES (4,'block_override_pin_wrong',1,1);
INSERT INTO `voip_sound_handles` VALUES (5,'locked_in',1,1);
INSERT INTO `voip_sound_handles` VALUES (6,'locked_out',1,1);
INSERT INTO `voip_sound_handles` VALUES (7,'max_calls_in',1,1);
INSERT INTO `voip_sound_handles` VALUES (8,'max_calls_out',1,1);
INSERT INTO `voip_sound_handles` VALUES (9,'max_calls_peer',1,1);
INSERT INTO `voip_sound_handles` VALUES (10,'unauth_caller_ip',1,1);
INSERT INTO `voip_sound_handles` VALUES (11,'relaying_denied',1,1);
INSERT INTO `voip_sound_handles` VALUES (12,'invalid_speeddial',1,1);
INSERT INTO `voip_sound_handles` VALUES (13,'cf_loop',1,1);
INSERT INTO `voip_sound_handles` VALUES (14,'callee_offline',1,1);
INSERT INTO `voip_sound_handles` VALUES (15,'callee_busy',1,1);
INSERT INTO `voip_sound_handles` VALUES (16,'callee_unknown',1,1);
INSERT INTO `voip_sound_handles` VALUES (17,'callee_tmp_unavailable',1,1);
INSERT INTO `voip_sound_handles` VALUES (18,'peering_unavailable',1,1);
INSERT INTO `voip_sound_handles` VALUES (19,'voicebox_unavailable',1,1);
INSERT INTO `voip_sound_handles` VALUES (20,'music_on_hold',4,1);
INSERT INTO `voip_sound_handles` VALUES (21,'emergency_unsupported',1,1);
INSERT INTO `voip_sound_handles` VALUES (22,'no_credit',1,1);
INSERT INTO `voip_sound_handles` VALUES (23,'and',3,1);
INSERT INTO `voip_sound_handles` VALUES (24,'busy_ringback_tone',3,1);
INSERT INTO `voip_sound_handles` VALUES (25,'calling_card_not_found',3,1);
INSERT INTO `voip_sound_handles` VALUES (26,'connecting',3,1);
INSERT INTO `voip_sound_handles` VALUES (27,'could_not_connect',3,1);
INSERT INTO `voip_sound_handles` VALUES (28,'credits_successfully_transfered',3,1);
INSERT INTO `voip_sound_handles` VALUES (29,'declined_ringback_tone',3,1);
INSERT INTO `voip_sound_handles` VALUES (30,'dollar',3,1);
INSERT INTO `voip_sound_handles` VALUES (31,'enter_callingcard_number_to_transfer',3,1);
INSERT INTO `voip_sound_handles` VALUES (32,'enter_callingcard_number',3,1);
INSERT INTO `voip_sound_handles` VALUES (33,'enter_destination_number',3,1);
INSERT INTO `voip_sound_handles` VALUES (34,'error_please_try_later',3,1);
INSERT INTO `voip_sound_handles` VALUES (35,'euro_cents',3,1);
INSERT INTO `voip_sound_handles` VALUES (36,'euro_unit',3,1);
INSERT INTO `voip_sound_handles` VALUES (37,'you_have_in_your_account',3,1);
INSERT INTO `voip_sound_handles` VALUES (38,'aa_welcome',2,1);
INSERT INTO `voip_sound_handles` VALUES (39,'aa_1_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (40,'aa_1_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (41,'aa_2_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (42,'aa_2_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (43,'aa_3_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (44,'aa_3_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (45,'aa_4_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (46,'aa_4_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (47,'aa_5_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (48,'aa_5_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (49,'aa_6_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (50,'aa_6_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (51,'aa_7_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (52,'aa_7_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (53,'aa_8_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (54,'aa_8_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (55,'aa_9_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (56,'aa_9_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (57,'aa_0_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (58,'aa_0_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (59,'office_hours',2,1);
INSERT INTO `voip_sound_handles` VALUES (60,'push_connecting',5,1);
INSERT INTO `voip_sound_handles` VALUES (61,'enter_voucher_number',6,1);
INSERT INTO `voip_sound_handles` VALUES (62,'voucher_incorrect',6,1);
INSERT INTO `voip_sound_handles` VALUES (63,'error_please_try_later',6,1);
INSERT INTO `voip_sound_handles` VALUES (64,'credits_successfully_transferred',6,1);
INSERT INTO `voip_sound_handles` VALUES (65,'units',6,1);
INSERT INTO `voip_sound_handles` VALUES (66,'you_have_in_your_account',7,1);
INSERT INTO `voip_sound_handles` VALUES (67,'units',7,1);
INSERT INTO `voip_sound_handles` VALUES (68,'and',7,1);
INSERT INTO `voip_sound_handles` VALUES (69,'cents',7,1);
INSERT INTO `voip_sound_handles` VALUES (70,'queue_greeting',2,1);
INSERT INTO `voip_sound_handles` VALUES (71,'queue_full',2,1);
INSERT INTO `voip_sound_handles` VALUES (72,'queue_prefix',2,1);
INSERT INTO `voip_sound_handles` VALUES (73,'queue_suffix',2,1);
INSERT INTO `voip_sound_handles` VALUES (74,'queue_waiting_music',2,1);
INSERT INTO `voip_sound_handles` VALUES (75,'0',8,1);
INSERT INTO `voip_sound_handles` VALUES (76,'1',8,1);
INSERT INTO `voip_sound_handles` VALUES (77,'2',8,1);
INSERT INTO `voip_sound_handles` VALUES (78,'3',8,1);
INSERT INTO `voip_sound_handles` VALUES (79,'4',8,1);
INSERT INTO `voip_sound_handles` VALUES (80,'5',8,1);
INSERT INTO `voip_sound_handles` VALUES (81,'6',8,1);
INSERT INTO `voip_sound_handles` VALUES (82,'7',8,1);
INSERT INTO `voip_sound_handles` VALUES (83,'8',8,1);
INSERT INTO `voip_sound_handles` VALUES (84,'9',8,1);
INSERT INTO `voip_sound_handles` VALUES (85,'1-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (86,'2-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (87,'3-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (88,'4-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (89,'5-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (90,'6-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (91,'7-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (92,'8-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (93,'9-and',8,1);
INSERT INTO `voip_sound_handles` VALUES (94,'10',8,1);
INSERT INTO `voip_sound_handles` VALUES (95,'11',8,1);
INSERT INTO `voip_sound_handles` VALUES (96,'12',8,1);
INSERT INTO `voip_sound_handles` VALUES (97,'13',8,1);
INSERT INTO `voip_sound_handles` VALUES (98,'14',8,1);
INSERT INTO `voip_sound_handles` VALUES (99,'15',8,1);
INSERT INTO `voip_sound_handles` VALUES (100,'16',8,1);
INSERT INTO `voip_sound_handles` VALUES (101,'17',8,1);
INSERT INTO `voip_sound_handles` VALUES (102,'18',8,1);
INSERT INTO `voip_sound_handles` VALUES (103,'19',8,1);
INSERT INTO `voip_sound_handles` VALUES (104,'20',8,1);
INSERT INTO `voip_sound_handles` VALUES (105,'30',8,1);
INSERT INTO `voip_sound_handles` VALUES (106,'40',8,1);
INSERT INTO `voip_sound_handles` VALUES (107,'50',8,1);
INSERT INTO `voip_sound_handles` VALUES (108,'60',8,1);
INSERT INTO `voip_sound_handles` VALUES (109,'70',8,1);
INSERT INTO `voip_sound_handles` VALUES (110,'80',8,1);
INSERT INTO `voip_sound_handles` VALUES (111,'90',8,1);
INSERT INTO `voip_sound_handles` VALUES (112,'100',8,1);
INSERT INTO `voip_sound_handles` VALUES (113,'conference_greeting',9,1);
INSERT INTO `voip_sound_handles` VALUES (115,'conference_pin_wrong',9,1);
INSERT INTO `voip_sound_handles` VALUES (116,'conference_joined',9,1);
INSERT INTO `voip_sound_handles` VALUES (117,'conference_join',9,1);
INSERT INTO `voip_sound_handles` VALUES (118,'conference_leave',9,1);
INSERT INTO `voip_sound_handles` VALUES (119,'goodbye',9,1);
INSERT INTO `voip_sound_handles` VALUES (120,'conference_first',9,1);
INSERT INTO `voip_sound_handles` VALUES (121,'conference_pin',9,1);
INSERT INTO `voip_sound_handles` VALUES (122,'conference_waiting_music',9,1);
INSERT INTO `voip_sound_handles` VALUES (123,'conference_max_participants',9,1);
INSERT INTO `voip_sound_handles` VALUES (124,'malicious_call_report',10,1);
INSERT INTO `voip_sound_handles` VALUES (125,'reject_vsc',1,1);
INSERT INTO `voip_sound_handles` VALUES (126,'emergency_geo_unavailable',1,1);
INSERT INTO `voip_sound_handles` VALUES (127,'announce_before_cf',13,1);
INSERT INTO `voip_sound_handles` VALUES (128,'custom_announcement_0',11,1);
INSERT INTO `voip_sound_handles` VALUES (129,'custom_announcement_1',11,1);
INSERT INTO `voip_sound_handles` VALUES (130,'custom_announcement_2',11,1);
INSERT INTO `voip_sound_handles` VALUES (131,'custom_announcement_3',11,1);
INSERT INTO `voip_sound_handles` VALUES (132,'custom_announcement_4',11,1);
INSERT INTO `voip_sound_handles` VALUES (133,'custom_announcement_5',11,1);
INSERT INTO `voip_sound_handles` VALUES (134,'custom_announcement_6',11,1);
INSERT INTO `voip_sound_handles` VALUES (135,'custom_announcement_7',11,1);
INSERT INTO `voip_sound_handles` VALUES (136,'custom_announcement_8',11,1);
INSERT INTO `voip_sound_handles` VALUES (137,'custom_announcement_9',11,1);
INSERT INTO `voip_sound_handles` VALUES (138,'aa_star_for',2,1);
INSERT INTO `voip_sound_handles` VALUES (139,'aa_star_option',2,1);
INSERT INTO `voip_sound_handles` VALUES (140,'aa_enter_extension',2,1);
INSERT INTO `voip_sound_handles` VALUES (141,'aa_invalid_extension',2,1);
INSERT INTO `voip_sound_handles` VALUES (142,'announce_before_call_setup',13,1);
INSERT INTO `voip_sound_handles` VALUES (143,'announce_before_recording',13,1);
INSERT INTO `voip_sound_handles` VALUES (144,'announce_to_callee',13,1);
INSERT INTO `voip_sound_handles` VALUES (145,'recent_call_play_number',12,1);
INSERT INTO `voip_sound_handles` VALUES (146,'recent_call_confirmation',12,1);
INSERT INTO `voip_sound_handles` VALUES (147,'recent_call_anonymous',12,1);
INSERT INTO `voip_sound_handles` VALUES (148,'recent_call_empty',12,1);
INSERT INTO `voip_sound_handles` VALUES (149,'recent_call_deleted',12,1);
INSERT INTO `voip_sound_handles` VALUES (150,'ringback_tone',13,1);
INSERT INTO `voip_sound_handles` VALUES (151,'aa_timeout',2,1);
INSERT INTO `voip_sound_handles` VALUES (152,'aa_default',2,1);
INSERT INTO `voip_subscribers` VALUES (3,'no_such_number',2,'9bcb88b6-541a-43da-8fdc-816f5557ff93','cc8790c0df09320e655ef543c2c9d569',0,NULL,NULL,NULL,0,0,'none',NULL,'cancel',NULL,NULL,NULL,'2023-10-25 11:10:36','2012-12-31 23:00:00');
INSERT INTO `voip_usr_preferences` VALUES (1,3,97,'none','2023-10-25 11:10:36');
INSERT INTO `voip_usr_preferences` VALUES (7,3,372,'cirpack','2023-10-25 11:10:34');
INSERT INTO `voip_usr_preferences` VALUES (8,3,305,'never','2023-10-25 11:10:35');
INSERT INTO `xmlgroups` VALUES (5,'appserver');
INSERT INTO `xmlgroups` VALUES (4,'loadbalancer');
INSERT INTO `xmlgroups` VALUES (3,'presence');
INSERT INTO `xmlgroups` VALUES (1,'proxy');
INSERT INTO `xmlgroups` VALUES (6,'proxy-ng');
INSERT INTO `xmlgroups` VALUES (2,'registrar');
INSERT INTO `xmlgroups` VALUES (7,'xmpp');
INSERT INTO `xmlhostgroups` VALUES (1,1,1);
INSERT INTO `xmlhostgroups` VALUES (2,5,2);
INSERT INTO `xmlhostgroups` VALUES (3,6,3);
INSERT INTO `xmlhostgroups` VALUES (4,4,4);
INSERT INTO `xmlhostgroups` VALUES (5,7,5);
INSERT INTO `xmlhosts` VALUES (1,'127.0.0.1',8000,'/RPC2',5062,'Kamailio');
INSERT INTO `xmlhosts` VALUES (2,'127.0.0.1',8090,'/',NULL,'Sems');
INSERT INTO `xmlhosts` VALUES (3,'127.0.0.1',5062,'/',NULL,'Kamailio-SR');
INSERT INTO `xmlhosts` VALUES (4,'127.0.0.1',5060,'/',NULL,'Loadbalancer');
INSERT INTO `xmlhosts` VALUES (5,'127.0.0.1',5582,'/',NULL,'Prosody');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER provisioning.aig_create_trig before insert on provisioning.voip_allowed_ip_groups
FOR EACH ROW SET
  NEW._ipv4_net_from = if(ip_is_ipv6(NEW.ipnet),null,ip_get_network_address(NEW.ipnet)),
  NEW._ipv4_net_to = if(ip_is_ipv6(NEW.ipnet),null,ip_get_broadcast_address(NEW.ipnet)),
  NEW._ipv6_net_from = if(ip_is_ipv6(NEW.ipnet),ip_get_network_address(NEW.ipnet),null),
  NEW._ipv6_net_to = if(ip_is_ipv6(NEW.ipnet),ip_get_broadcast_address(NEW.ipnet),null) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_aig_crepl_trig AFTER INSERT ON voip_allowed_ip_groups
  FOR EACH ROW BEGIN

  INSERT INTO kamailio.address (id, grp, ip_addr, mask)
                         VALUES(NEW.id, NEW.group_id,
                                IF(LOCATE('/', NEW.ipnet), SUBSTRING_INDEX(NEW.ipnet, '/', 1), NEW.ipnet),
                                IF(LOCATE('/', NEW.ipnet), SUBSTRING_INDEX(NEW.ipnet, '/', -1), 32));

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER provisioning.aig_update_trig before update on provisioning.voip_allowed_ip_groups
FOR EACH ROW SET
  NEW._ipv4_net_from = if(ip_is_ipv6(NEW.ipnet),null,ip_get_network_address(NEW.ipnet)),
  NEW._ipv4_net_to = if(ip_is_ipv6(NEW.ipnet),null,ip_get_broadcast_address(NEW.ipnet)),
  NEW._ipv6_net_from = if(ip_is_ipv6(NEW.ipnet),ip_get_network_address(NEW.ipnet),null),
  NEW._ipv6_net_to = if(ip_is_ipv6(NEW.ipnet),ip_get_broadcast_address(NEW.ipnet),null) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_aig_urepl_trig AFTER UPDATE ON voip_allowed_ip_groups
  FOR EACH ROW BEGIN

  UPDATE kamailio.address SET id = NEW.id, grp = NEW.group_id,
                              ip_addr = IF(LOCATE('/', NEW.ipnet), SUBSTRING_INDEX(NEW.ipnet, '/', 1), NEW.ipnet),
                              mask = IF(LOCATE('/', NEW.ipnet), SUBSTRING_INDEX(NEW.ipnet, '/', -1), 32)
                        WHERE id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_aig_drepl_trig BEFORE DELETE ON voip_allowed_ip_groups
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.address WHERE id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_contractpref_crepl_trig AFTER INSERT ON voip_contract_preferences
  FOR EACH ROW BEGIN

  INSERT INTO kamailio.contract_preferences
              (id, uuid, location_id, attribute, type, value, last_modified)
       SELECT NEW.id, NEW.contract_id, NEW.location_id, attribute, type, NEW.value, '0'
         FROM provisioning.voip_preferences
        WHERE id <=> NEW.attribute_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_contractpref_urepl_trig AFTER UPDATE ON voip_contract_preferences
  FOR EACH ROW BEGIN

  UPDATE kamailio.contract_preferences pp, provisioning.voip_preferences vp
     SET pp.id = NEW.id, pp.uuid = NEW.contract_id, pp.location_id = NEW.location_id,
         pp.type = vp.type, pp.attribute = vp.attribute,
         pp.value = NEW.value, pp.last_modified = '0'
   WHERE pp.id <=> OLD.id
     AND vp.id <=> NEW.attribute_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_contractpref_drepl_trig BEFORE DELETE ON voip_contract_preferences
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.contract_preferences
        WHERE id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_contract_prefences_blob_insert AFTER INSERT ON voip_contract_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_contract_preferences
       SET value = NEW.id
     WHERE id = NEW.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_contract_preferences_blob_delete AFTER DELETE ON voip_contract_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_contract_preferences
       SET value = ''
     WHERE preference_id = OLD.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_contract_sd_crepl_trig AFTER INSERT ON voip_contract_speed_dial
  FOR EACH ROW BEGIN
  DECLARE sd_domain varchar(64);
  DECLARE target_domain varchar(64);
  DECLARE at_end_pos smallint;
  SET target_domain = 'local.sd.customer.domain';
  SET at_end_pos = LOCATE('@', NEW.destination);
  SET sd_domain = SUBSTR(NEW.destination FROM at_end_pos+1);

  INSERT INTO kamailio.speed_dial (username, domain, sd_username, sd_domain,
                                   new_uri, fname, lname, description)
                          VALUES(NEW.contract_id, target_domain,
                                 NEW.slot, sd_domain,
                                 NEW.destination, '', '', '');
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_contract_sd_urepl_trig AFTER UPDATE ON voip_contract_speed_dial
  FOR EACH ROW BEGIN
  DECLARE sd_domain varchar(64);
  DECLARE target_domain varchar(64);
  DECLARE at_end_pos smallint;
  SET target_domain = 'local.sd.customer.domain';
  SET at_end_pos = LOCATE('@', NEW.destination);
  SET sd_domain = SUBSTR(NEW.destination FROM at_end_pos+1);

  UPDATE kamailio.speed_dial SET username = NEW.contract_id, domain = target_domain,
                               sd_username = NEW.slot, sd_domain = sd_domain,
                               new_uri = NEW.destination
                           WHERE username <=> OLD.contract_id
                           AND domain <=> target_domain
                           AND sd_username <=> OLD.slot;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_contract_sd_drepl_trig BEFORE DELETE ON voip_contract_speed_dial
  FOR EACH ROW BEGIN
  DECLARE target_domain varchar(64);
  SET target_domain = 'local.sd.customer.domain';

  DELETE FROM kamailio.speed_dial WHERE username <=> OLD.contract_id
                                  AND domain <=> target_domain
                                  AND sd_username <=> OLD.slot;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dba_crepl_trig AFTER INSERT ON voip_dbaliases
  FOR EACH ROW BEGIN
  DECLARE dbalias_domain varchar(127);
  DECLARE target_username varchar(127);
  DECLARE target_domain varchar(127);

  SELECT domain INTO dbalias_domain FROM voip_domains where id = NEW.domain_id;
  SELECT a.username, b.domain INTO target_username, target_domain
    FROM voip_subscribers a, voip_domains b
    WHERE a.id <=> NEW.subscriber_id
    AND b.id <=> a.domain_id;

  INSERT INTO kamailio.dbaliases (alias_username, alias_domain,
    username, domain, is_primary, is_devid, devid_alias)
    VALUES(NEW.username, dbalias_domain, target_username, target_domain, NEW.is_primary, NEW.is_devid, NEW.devid_alias);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dba_urepl_trig AFTER UPDATE ON voip_dbaliases
  FOR EACH ROW BEGIN
  DECLARE old_dbalias_domain varchar(127);
  DECLARE new_dbalias_domain varchar(127);
  DECLARE target_username varchar(127);
  DECLARE target_domain varchar(127);

  SELECT domain INTO old_dbalias_domain FROM voip_domains where id = OLD.domain_id;
  SELECT domain INTO new_dbalias_domain FROM voip_domains where id = NEW.domain_id;
  SELECT a.username, b.domain INTO target_username, target_domain
    FROM voip_subscribers a, voip_domains b
    WHERE a.id <=> NEW.subscriber_id
    AND b.id <=> a.domain_id;

  UPDATE kamailio.dbaliases SET alias_username = NEW.username, alias_domain = new_dbalias_domain,
    username = target_username, domain = target_domain, is_primary = NEW.is_primary,
    is_devid = NEW.is_devid, devid_alias = NEW.devid_alias
    WHERE alias_username <=> OLD.username
    AND alias_domain <=> old_dbalias_domain
	AND is_primary <=> OLD.is_primary
	AND is_devid <=> OLD.is_devid
	AND devid_alias <=> OLD.devid_alias;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dba_drepl_trig BEFORE DELETE ON voip_dbaliases
  FOR EACH ROW BEGIN
  DECLARE dbalias_domain varchar(127);

  SELECT domain INTO dbalias_domain FROM voip_domains where id = OLD.domain_id;

  DELETE FROM kamailio.dbaliases WHERE alias_username <=> OLD.username
                                  AND alias_domain <=> dbalias_domain;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dompref_crepl_trig AFTER INSERT ON voip_dom_preferences
  FOR EACH ROW BEGIN
  DECLARE domain_name varchar(127);
  DECLARE attribute_name varchar(31);
  DECLARE attribute_type tinyint(3);

  SELECT domain INTO domain_name
                FROM voip_domains
               WHERE id <=> NEW.domain_id;
  SELECT attribute, type INTO attribute_name, attribute_type
                         FROM voip_preferences
                        WHERE id <=> NEW.attribute_id;

  INSERT INTO kamailio.dom_preferences (domain, attribute, type, value)
                                 VALUES(domain_name, attribute_name, attribute_type, NEW.value);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dompref_urepl_trig AFTER UPDATE ON voip_dom_preferences
  FOR EACH ROW BEGIN
  DECLARE old_domain_name varchar(127);
  DECLARE new_domain_name varchar(127);
  DECLARE old_attribute_name varchar(31);
  DECLARE new_attribute_name varchar(31);

  SELECT domain INTO old_domain_name
                FROM voip_domains
               WHERE id <=> OLD.domain_id;
  SELECT domain INTO new_domain_name
                FROM voip_domains
               WHERE id <=> NEW.domain_id;
  SELECT attribute INTO old_attribute_name
                   FROM voip_preferences
                  WHERE id <=> OLD.attribute_id;
  SELECT attribute INTO new_attribute_name
                   FROM voip_preferences
                  WHERE id <=> NEW.attribute_id;

  UPDATE kamailio.dom_preferences SET domain = new_domain_name,
                                      attribute = new_attribute_name,
                                      value = NEW.value
                                WHERE domain <=> old_domain_name
                                  AND attribute <=> old_attribute_name
                                  AND value <=> OLD.value;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dompref_drepl_trig BEFORE DELETE ON voip_dom_preferences
  FOR EACH ROW BEGIN
  DECLARE domain_name varchar(127);
  DECLARE attribute_name varchar(31);

  SELECT domain INTO domain_name
                FROM voip_domains
               WHERE id <=> OLD.domain_id;
  SELECT attribute INTO attribute_name
                   FROM voip_preferences
                  WHERE id <=> OLD.attribute_id;

  DELETE FROM kamailio.dom_preferences WHERE domain <=> domain_name
                                         AND attribute <=> attribute_name
                                         AND value <=> OLD.value;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_dom_prefences_blob_insert AFTER INSERT ON voip_dom_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_dom_preferences
       SET value = NEW.id
     WHERE id = NEW.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_dom_prefences_blob_delete AFTER DELETE ON voip_dom_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_dom_preferences
       SET value = ''
     WHERE id = OLD.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dom_crepl_trig AFTER INSERT ON voip_domains
FOR EACH ROW BEGIN
    
    INSERT INTO kamailio.domain (domain) VALUES(NEW.domain);
   
    
    INSERT INTO voip_dom_preferences (domain_id, attribute_id, value)
    SELECT NEW.id, p.id, pe.value
    FROM voip_preferences p, voip_preferences_enum pe
    WHERE p.id <=> preference_id AND p.dom_pref=1 AND pe.dom_pref=1 AND pe.default_val=1 AND pe.value IS NOT NULL;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_dom_drepl_trig BEFORE DELETE ON voip_domains
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.domain WHERE domain <=> OLD.domain;

  
  
  DELETE FROM kamailio.dom_preferences WHERE domain <=> OLD.domain;
  
  DELETE FROM provisioning.voip_subscribers WHERE domain_id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_pgrp_urepl_trig AFTER UPDATE ON voip_peer_groups
  FOR EACH ROW BEGIN

  UPDATE kamailio.lcr_rule_target rt, kamailio.lcr_gw gw
     SET rt.priority = NEW.priority
   WHERE gw.id <=> rt.gw_id
     AND gw.lcr_id = 1
     AND gw.group_id <=> NEW.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_pgrp_drepl_trig AFTER DELETE ON voip_peer_groups
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.lcr_rule WHERE group_id <=> OLD.id;
  DELETE FROM kamailio.lcr_gw WHERE group_id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_phost_crepl_trig AFTER INSERT ON voip_peer_hosts
  FOR EACH ROW BEGIN

  DECLARE m_proto CHAR(4);
  IF NEW.transport = 2 THEN
    SET m_proto := 'TCP';
  ELSEIF NEW.transport = 3 THEN
    SET m_proto := 'TLS';
  ELSE
    SET m_proto := 'UDP';
  END IF;

  IF NEW.enabled THEN
    INSERT INTO kamailio.lcr_gw (id, lcr_id, gw_name, ip_addr, hostname, port, uri_scheme, transport, strip, group_id)
      VALUES(NEW.id, 1, NEW.name, NEW.ip, NEW.host, NEW.port, 1, NEW.transport, 0, NEW.group_id);

    INSERT INTO kamailio.lcr_rule_target (lcr_id, rule_id, gw_id, priority, weight)
           SELECT rule.lcr_id, rule.id, NEW.id, vpg.priority, NEW.weight
             FROM kamailio.lcr_rule rule
             INNER JOIN provisioning.voip_peer_groups vpg ON vpg.id = rule.group_id
            WHERE vpg.id <=> NEW.group_id;

    INSERT INTO voip_peer_preferences (peer_host_id, attribute_id, value)
    SELECT NEW.id, p.id, pe.value
    FROM voip_preferences p, voip_preferences_enum pe
    WHERE p.id <=> preference_id AND p.peer_pref=1 AND pe.peer_pref=1 AND pe.default_val=1 AND pe.value IS NOT NULL;

    IF NEW.probe = 1 THEN
      INSERT INTO kamailio.dispatcher (setid, destination, flags, priority, attrs, description)
        VALUES(100, CONCAT('sip:', NEW.ip, ':', NEW.port, ';transport=', m_proto), 0, 0, CONCAT('peerid=', NEW.id, ';peername="', NEW.name, '";peergid=', NEW.group_id, ';'), 'Peer Probe');
    END IF;

  END IF;


  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_phost_urepl_trig AFTER UPDATE ON voip_peer_hosts
  FOR EACH ROW BEGIN

  DECLARE m_proto CHAR(4);
  DECLARE m_probechange INTEGER;

  IF NEW.transport = 2 THEN
    SET m_proto := 'TCP';
  ELSEIF NEW.transport = 3 THEN
    SET m_proto := 'TLS';
  ELSE
    SET m_proto := 'UDP';
  END IF;

  IF OLD.enabled = 1 AND NEW.enabled = 1 THEN

    UPDATE kamailio.lcr_gw
       SET gw_name = NEW.name, ip_addr = NEW.ip, hostname = NEW.host, port = NEW.port, transport = NEW.transport
     WHERE lcr_id = 1
       AND id <=> NEW.id;

    UPDATE kamailio.lcr_rule_target rt, kamailio.lcr_gw gw
       SET rt.weight = NEW.weight
     WHERE gw.id <=> rt.gw_id
       AND gw.lcr_id = 1
       AND gw.group_id <=> NEW.group_id;

    IF OLD.probe = 1 AND (OLD.ip != NEW.ip OR OLD.port != NEW.port OR OLD.transport != NEW.transport OR OLD.name != NEW.name OR OLD.group_id != NEW.group_id) THEN
      DELETE FROM kamailio.dispatcher WHERE attrs LIKE CONCAT('%peerid=', OLD.id, ';%');
      SET m_probechange := 1;
    ELSEIF OLD.probe = 1 and NEW.probe = 0 THEN
      DELETE FROM kamailio.dispatcher WHERE attrs LIKE CONCAT('%peerid=', OLD.id, ';%');
    END IF;
    IF NEW.probe = 1 AND (m_probechange = 1 OR OLD.probe = 0) THEN
      INSERT INTO kamailio.dispatcher (setid, destination, flags, priority, attrs, description)
        VALUES(100, CONCAT('sip:', NEW.ip, ':', NEW.port, ';transport=', m_proto), 0, 0, CONCAT('peerid=', NEW.id, ';peername="', NEW.name, '";peergid=', NEW.group_id, ';'), 'Peer Probe');
    END IF;

  ELSEIF OLD.enabled = 0 AND NEW.enabled = 1 THEN

    INSERT INTO kamailio.lcr_gw (id, lcr_id, gw_name, ip_addr, hostname, port, uri_scheme, transport, strip, group_id)
      VALUES(NEW.id, 1, NEW.name, NEW.ip, NEW.host, NEW.port, 1, NEW.transport, 0, NEW.group_id);

    INSERT INTO kamailio.lcr_rule_target (lcr_id, rule_id, gw_id, priority, weight)
           SELECT rule.lcr_id, rule.id, NEW.id, vpg.priority, NEW.weight
             FROM kamailio.lcr_rule rule
             INNER JOIN provisioning.voip_peer_groups vpg ON vpg.id = rule.group_id
            WHERE vpg.id <=> NEW.group_id;

    IF NEW.probe = 1 THEN
      INSERT INTO kamailio.dispatcher (setid, destination, flags, priority, attrs, description)
        VALUES(100, CONCAT('sip:', NEW.ip, ':', NEW.port, ';transport=', m_proto), 0, 0, CONCAT('peerid=', NEW.id, ';peername="', NEW.name, '";peergid=', NEW.group_id, ';'), 'Peer Probe');
    END IF;

  ELSEIF OLD.enabled = 1 AND NEW.enabled = 0 THEN

    DELETE FROM kamailio.lcr_gw
          WHERE lcr_id = 1
            AND id <=> NEW.id;

    IF OLD.probe = 1 THEN
      DELETE FROM kamailio.dispatcher WHERE attrs LIKE CONCAT('%peerid=', NEW.id, ';%');
    END IF;

  END IF;


  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_phost_drepl_trig AFTER DELETE ON voip_peer_hosts
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.lcr_gw
    WHERE id <=> OLD.id;

  DELETE FROM kamailio.peer_preferences
    WHERE uuid = OLD.id;

  IF OLD.enabled = 1 AND OLD.probe = 1 THEN
    DELETE FROM kamailio.dispatcher WHERE attrs LIKE CONCAT('%peerid=', OLD.id, ';%');
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_peerpref_crepl_trig AFTER INSERT ON voip_peer_preferences
  FOR EACH ROW BEGIN

  INSERT INTO kamailio.peer_preferences
              (id, uuid, attribute, type, value, last_modified)
       SELECT NEW.id, NEW.peer_host_id, attribute, type, NEW.value, '0'
         FROM provisioning.voip_preferences
        WHERE id <=> NEW.attribute_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_peerpref_urepl_trig AFTER UPDATE ON voip_peer_preferences
  FOR EACH ROW BEGIN

  UPDATE kamailio.peer_preferences pp, provisioning.voip_preferences vp
     SET pp.id = NEW.id, pp.uuid = NEW.peer_host_id, pp.type = vp.type,
         pp.attribute = vp.attribute, pp.value = NEW.value, pp.last_modified = '0'
   WHERE pp.id <=> OLD.id
     AND vp.id <=> NEW.attribute_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_peerpref_drepl_trig BEFORE DELETE ON voip_peer_preferences
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.peer_preferences
        WHERE id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_peer_preferences_blob_insert AFTER INSERT ON voip_peer_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_peer_preferences
       SET value = NEW.id
     WHERE id = NEW.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_peer_preferences_blob_delete AFTER DELETE ON voip_peer_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_peer_preferences
       SET value = ''
     WHERE id = OLD.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_prul_crepl_trig AFTER INSERT ON voip_peer_rules
  FOR EACH ROW BEGIN

  IF NEW.enabled = 1 THEN
    INSERT INTO kamailio.lcr_rule (lcr_id, prefix, request_uri, from_uri, stopper, enabled, group_id)
      VALUES(1, NEW.callee_prefix, NEW.callee_pattern, NEW.caller_pattern, NEW.stopper, 1, NEW.group_id);

    INSERT INTO kamailio.lcr_rule_target (lcr_id, rule_id, gw_id, priority, weight)
           SELECT gw.lcr_id, LAST_INSERT_ID(), gw.id, vpg.priority, vph.weight
             FROM kamailio.lcr_gw gw
             INNER JOIN provisioning.voip_peer_hosts vph ON vph.name = gw.gw_name
                                                        AND gw.lcr_id = 1
                                                        AND vph.group_id = gw.group_id
             INNER JOIN provisioning.voip_peer_groups vpg ON vpg.id = vph.group_id
            WHERE vph.group_id <=> NEW.group_id;
  END IF;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_prul_urepl_trig AFTER UPDATE ON voip_peer_rules
  FOR EACH ROW BEGIN

  IF OLD.enabled = 1 AND NEW.enabled = 1 THEN
    UPDATE kamailio.lcr_rule
       SET prefix = NEW.callee_prefix,
           request_uri = NEW.callee_pattern,
           from_uri = NEW.caller_pattern,
           stopper = NEW.stopper,
           group_id = NEW.group_id
     WHERE prefix <=> OLD.callee_prefix
       AND request_uri <=> OLD.callee_pattern
       AND from_uri <=> OLD.caller_pattern
       AND group_id <=> OLD.group_id
       AND stopper <=> OLD.stopper;
    IF OLD.group_id != NEW.group_id THEN
        DELETE FROM kamailio.lcr_rule_target WHERE rule_id = OLD.id;
        INSERT INTO kamailio.lcr_rule_target (lcr_id, rule_id, gw_id, priority, weight)
           SELECT gw.lcr_id, OLD.id, gw.id, vpg.priority, vph.weight
             FROM kamailio.lcr_gw gw
            INNER JOIN provisioning.voip_peer_hosts vph ON vph.name = gw.gw_name
                                                        AND gw.lcr_id = 1
                                                        AND vph.group_id = gw.group_id
            INNER JOIN provisioning.voip_peer_groups vpg ON vpg.id = vph.group_id
            WHERE vph.group_id <=> NEW.group_id;
    END IF;
  ELSEIF OLD.enabled = 0 AND NEW.enabled = 1 THEN
    INSERT INTO kamailio.lcr_rule (lcr_id, prefix, request_uri, from_uri, stopper, enabled, group_id)
      VALUES(1, NEW.callee_prefix, NEW.callee_pattern, NEW.caller_pattern, NEW.stopper, 1, NEW.group_id);

    INSERT INTO kamailio.lcr_rule_target (lcr_id, rule_id, gw_id, priority, weight)
        SELECT gw.lcr_id, LAST_INSERT_ID(), gw.id, vpg.priority, vph.weight
          FROM kamailio.lcr_gw gw
         INNER JOIN provisioning.voip_peer_hosts vph ON vph.name = gw.gw_name
                                                    AND gw.lcr_id = 1
                                                    AND vph.group_id = gw.group_id
         INNER JOIN provisioning.voip_peer_groups vpg ON vpg.id = vph.group_id
         WHERE vph.group_id <=> NEW.group_id;
  ELSEIF OLD.enabled = 1 AND NEW.enabled = 0 THEN
    DELETE FROM kamailio.lcr_rule
          WHERE prefix <=> OLD.callee_prefix
            AND request_uri <=> OLD.callee_pattern
            AND from_uri <=> OLD.caller_pattern
            AND group_id <=> OLD.group_id
            AND stopper <=> OLD.stopper
            LIMIT 1;
  END IF;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER provisioning.voip_prul_drepl_trig AFTER DELETE ON voip_peer_rules
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.lcr_rule
        WHERE prefix <=> OLD.callee_prefix
          AND request_uri <=> OLD.callee_pattern
          AND from_uri <=> OLD.caller_pattern
          AND group_id <=> OLD.group_id;

  

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_pref_icheck_trig BEFORE INSERT ON voip_preferences
FOR EACH ROW BEGIN
    IF ( ((NEW.attribute like '\_\_%') and !NEW.dynamic)
        or ((NEW.attribute not like '\_\_%') and NEW.dynamic)
    ) THEN
        SIGNAL sqlstate '45001' set message_text = "voip_preferences attributes are allowed either '__' prefixed + dynamic=1 or without the '__' prefix and dynamic=0";
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_pref_ucheck_trig BEFORE UPDATE ON voip_preferences
FOR EACH ROW BEGIN
    IF ( ((NEW.attribute like '\_\_%') and !NEW.dynamic)
        or ((NEW.attribute not like '\_\_%') and NEW.dynamic)
    ) THEN
        SIGNAL sqlstate '45001' set message_text = "voip_preferences attributes are allowed either '__' prefixed + dynamic=1 or without the '__' prefix and dynamic=0";
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_pref_urepl_trig AFTER UPDATE ON voip_preferences
  FOR EACH ROW BEGIN

  IF OLD.attribute != NEW.attribute THEN
    UPDATE kamailio.usr_preferences
       SET attribute = NEW.attribute
     WHERE attribute <=> OLD.attribute;
    UPDATE kamailio.dom_preferences
       SET attribute = NEW.attribute
     WHERE attribute <=> OLD.attribute;
    UPDATE kamailio.peer_preferences
       SET attribute = NEW.attribute
     WHERE attribute <=> OLD.attribute;
    UPDATE kamailio.contract_preferences
       SET attribute = NEW.attribute
     WHERE attribute <=> OLD.attribute;
    UPDATE kamailio.prof_preferences
       SET attribute = NEW.attribute
     WHERE attribute <=> OLD.attribute;
  END IF; 

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_pref_drepl_trig BEFORE DELETE ON voip_preferences
  FOR EACH ROW BEGIN

  DELETE FROM voip_usr_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_dom_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_peer_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_contract_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_prof_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_fielddev_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_dev_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_devprof_preferences WHERE attribute_id <=> OLD.id;
  DELETE FROM voip_reseller_preferences WHERE attribute_id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER enum_set_default AFTER INSERT ON voip_preferences_enum
FOR EACH ROW BEGIN

    DECLARE do_insert tinyint(3) unsigned;

    SELECT IF(NEW.default_val = 1 AND NEW.value IS NOT NULL
        AND (a.attribute NOT IN ("lock") 
        OR NEW.value != "0"),1,0) INTO do_insert FROM voip_preferences a WHERE a.id = NEW.preference_id;

    IF (NEW.dom_pref=1 AND do_insert=1) THEN
        INSERT into voip_dom_preferences (domain_id, attribute_id, value)
            SELECT e.id, NEW.preference_id, NEW.value
            FROM voip_domains e
            LEFT JOIN voip_dom_preferences v ON v.attribute_id = NEW.preference_id AND v.domain_id = e.id
            WHERE v.id IS NULL;
    END IF;
    IF (NEW.peer_pref=1 AND do_insert=1) THEN
        INSERT into voip_peer_preferences (peer_host_id, attribute_id, value)
            SELECT e.id, NEW.preference_id, NEW.value
            FROM voip_peer_hosts e
            LEFT JOIN voip_peer_preferences v ON v.attribute_id = NEW.preference_id AND v.peer_host_id = e.id
            WHERE v.id IS NULL;
    END IF;
    IF (NEW.usr_pref=1 AND do_insert=1) THEN
        INSERT into voip_usr_preferences (subscriber_id, attribute_id, value)
            SELECT e.id, NEW.preference_id, NEW.value
            FROM voip_subscribers e
            LEFT JOIN voip_usr_preferences v ON v.attribute_id = NEW.preference_id AND v.subscriber_id = e.id
            WHERE v.id IS NULL;
    END IF;
    IF (NEW.prof_pref=1 AND do_insert=1) THEN
        INSERT into voip_prof_preferences (profile_id, attribute_id, value)
            SELECT e.id, NEW.preference_id, NEW.value
            FROM voip_subscriber_profiles e
            LEFT JOIN voip_prof_preferences v ON v.attribute_id = NEW.preference_id AND v.profile_id = e.id
            WHERE v.id IS NULL;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER enum_update AFTER UPDATE ON voip_preferences_enum
FOR EACH ROW BEGIN
    UPDATE voip_usr_preferences SET value=NEW.value
    WHERE attribute_id <=> NEW.preference_id AND value <=> OLD.value;
    UPDATE voip_dom_preferences SET value=NEW.value
    WHERE attribute_id <=> NEW.preference_id AND value <=> OLD.value;
    UPDATE voip_peer_preferences SET value=NEW.value
    WHERE attribute_id <=> NEW.preference_id AND value <=> OLD.value;
    UPDATE voip_prof_preferences SET value=NEW.value
    WHERE attribute_id <=> NEW.preference_id AND value <=> OLD.value;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_profpref_crepl_trig AFTER INSERT ON voip_prof_preferences
  FOR EACH ROW BEGIN
  DECLARE attribute_name varchar(31);
  DECLARE attribute_type tinyint(3);

  SELECT attribute, type INTO attribute_name, attribute_type
                         FROM voip_preferences
                        WHERE id <=> NEW.attribute_id;

  INSERT INTO kamailio.prof_preferences (uuid, attribute, type, value)
                                 VALUES(NEW.profile_id, attribute_name, attribute_type, NEW.value);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_profpref_urepl_trig AFTER UPDATE ON voip_prof_preferences
  FOR EACH ROW BEGIN
  DECLARE old_attribute_name varchar(31);
  DECLARE new_attribute_name varchar(31);

  SELECT attribute INTO old_attribute_name
                   FROM voip_preferences
                  WHERE id <=> OLD.attribute_id;
  SELECT attribute INTO new_attribute_name
                   FROM voip_preferences
                  WHERE id <=> NEW.attribute_id;

  UPDATE kamailio.prof_preferences SET uuid = NEW.profile_id,
                                      attribute = new_attribute_name,
                                      value = NEW.value
                                WHERE uuid <=> OLD.profile_id
                                  AND attribute <=> old_attribute_name
                                  AND value <=> OLD.value;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_profpref_drepl_trig BEFORE DELETE ON voip_prof_preferences
  FOR EACH ROW BEGIN
  DECLARE attribute_name varchar(31);

  SELECT attribute INTO attribute_name
                   FROM voip_preferences
                  WHERE id <=> OLD.attribute_id;

  DELETE FROM kamailio.prof_preferences WHERE uuid <=> OLD.profile_id
                                         AND attribute <=> attribute_name
                                         AND value <=> OLD.value;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_resellerpref_crepl_trig AFTER INSERT ON voip_reseller_preferences
  FOR EACH ROW BEGIN

  INSERT INTO kamailio.reseller_preferences
              (id, uuid, attribute, type, value, last_modified)
       SELECT NEW.id, NEW.reseller_id, attribute, type, NEW.value, '0'
         FROM provisioning.voip_preferences
        WHERE id <=> NEW.attribute_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_resellerpref_urepl_trig AFTER UPDATE ON voip_reseller_preferences
  FOR EACH ROW BEGIN

  UPDATE kamailio.reseller_preferences pp, provisioning.voip_preferences vp
     SET pp.id = NEW.id, pp.uuid = NEW.reseller_id, pp.type = vp.type,
         pp.attribute = vp.attribute, pp.value = NEW.value, pp.last_modified = '0'
   WHERE pp.id <=> OLD.id
     AND vp.id <=> NEW.attribute_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_resellerpref_drepl_trig BEFORE DELETE ON voip_reseller_preferences
  FOR EACH ROW BEGIN

  DELETE FROM kamailio.reseller_preferences
        WHERE id <=> OLD.id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_rwrulesets_crepl_trig BEFORE INSERT ON voip_rewrite_rule_sets
  FOR EACH ROW BEGIN

  IF NEW.caller_in_dpid IS NULL THEN
    INSERT INTO voip_rwrs_sequence VALUES();
    SET NEW.caller_in_dpid = (SELECT LAST_INSERT_ID());
  END IF;
  IF NEW.callee_in_dpid IS NULL THEN
    INSERT INTO voip_rwrs_sequence VALUES();
    SET NEW.callee_in_dpid = (SELECT LAST_INSERT_ID());
  END IF;
  IF NEW.caller_out_dpid IS NULL THEN
    INSERT INTO voip_rwrs_sequence VALUES();
    SET NEW.caller_out_dpid = (SELECT LAST_INSERT_ID());
  END IF;
  IF NEW.callee_out_dpid IS NULL THEN
    INSERT INTO voip_rwrs_sequence VALUES();
    SET NEW.callee_out_dpid = (SELECT LAST_INSERT_ID());
  END IF;
  IF NEW.caller_lnp_dpid IS NULL THEN
    INSERT INTO voip_rwrs_sequence VALUES();
    SET NEW.caller_lnp_dpid = (SELECT LAST_INSERT_ID());
  END IF;
  IF NEW.callee_lnp_dpid IS NULL THEN
    INSERT INTO voip_rwrs_sequence VALUES();
    SET NEW.callee_lnp_dpid = (SELECT LAST_INSERT_ID());
  END IF;

  DELETE a FROM voip_rwrs_sequence a, voip_rwrs_sequence b WHERE a.id < b.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_rwrulesets_urepl_trig AFTER UPDATE ON voip_rewrite_rule_sets
  FOR EACH ROW BEGIN

  IF NEW.caller_in_dpid != OLD.caller_in_dpid THEN
    UPDATE kamailio.dialplan SET dpid = NEW.caller_in_dpid WHERE dpid <=> OLD.caller_in_dpid;
    UPDATE voip_usr_preferences a, voip_preferences b
       SET a.value = NEW.caller_in_dpid
     WHERE b.attribute <=> 'rewrite_caller_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_in_dpid;
    UPDATE voip_dom_preferences a, voip_preferences b
       SET a.value = NEW.caller_in_dpid
     WHERE b.attribute <=> 'rewrite_caller_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_in_dpid;
    UPDATE voip_peer_preferences a, voip_preferences b
       SET a.value = NEW.caller_in_dpid
     WHERE b.attribute <=> 'rewrite_caller_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_in_dpid;
    UPDATE voip_prof_preferences a, voip_preferences b
       SET a.value = NEW.caller_in_dpid
     WHERE b.attribute <=> 'rewrite_caller_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_in_dpid;
  END IF;

  IF NEW.callee_in_dpid != OLD.callee_in_dpid THEN
    UPDATE kamailio.dialplan SET dpid = NEW.callee_in_dpid WHERE dpid <=> OLD.callee_in_dpid;
    UPDATE voip_usr_preferences a, voip_preferences b
       SET a.value = NEW.callee_in_dpid
     WHERE b.attribute <=> 'rewrite_callee_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_in_dpid;
    UPDATE voip_dom_preferences a, voip_preferences b
       SET a.value = NEW.callee_in_dpid
     WHERE b.attribute <=> 'rewrite_callee_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_in_dpid;
    UPDATE voip_peer_preferences a, voip_preferences b
       SET a.value = NEW.callee_in_dpid
     WHERE b.attribute <=> 'rewrite_callee_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_in_dpid;
    UPDATE voip_prof_preferences a, voip_preferences b
       SET a.value = NEW.callee_in_dpid
     WHERE b.attribute <=> 'rewrite_callee_in_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_in_dpid;
  END IF;

  IF NEW.caller_out_dpid != OLD.caller_out_dpid THEN
    UPDATE kamailio.dialplan SET dpid = NEW.caller_out_dpid WHERE dpid <=> OLD.caller_out_dpid;
    UPDATE voip_usr_preferences a, voip_preferences b
       SET a.value = NEW.caller_out_dpid
     WHERE b.attribute <=> 'rewrite_caller_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_out_dpid;
    UPDATE voip_dom_preferences a, voip_preferences b
       SET a.value = NEW.caller_out_dpid
     WHERE b.attribute <=> 'rewrite_caller_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_out_dpid;
    UPDATE voip_peer_preferences a, voip_preferences b
       SET a.value = NEW.caller_out_dpid
     WHERE b.attribute <=> 'rewrite_caller_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_out_dpid;
    UPDATE voip_prof_preferences a, voip_preferences b
       SET a.value = NEW.caller_out_dpid
     WHERE b.attribute <=> 'rewrite_caller_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_out_dpid;
  END IF;

  IF NEW.callee_out_dpid != OLD.callee_out_dpid THEN
    UPDATE kamailio.dialplan SET dpid = NEW.callee_out_dpid WHERE dpid <=> OLD.callee_out_dpid;
    UPDATE voip_usr_preferences a, voip_preferences b
       SET a.value = NEW.callee_out_dpid
     WHERE b.attribute <=> 'rewrite_callee_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_out_dpid;
    UPDATE voip_dom_preferences a, voip_preferences b
       SET a.value = NEW.callee_out_dpid
     WHERE b.attribute <=> 'rewrite_callee_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_out_dpid;
    UPDATE voip_peer_preferences a, voip_preferences b
       SET a.value = NEW.callee_out_dpid
     WHERE b.attribute <=> 'rewrite_callee_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_out_dpid;
    UPDATE voip_prof_preferences a, voip_preferences b
       SET a.value = NEW.callee_out_dpid
     WHERE b.attribute <=> 'rewrite_callee_out_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_out_dpid;
  END IF;

  IF NEW.caller_lnp_dpid != OLD.caller_lnp_dpid THEN
    UPDATE kamailio.dialplan SET dpid = NEW.caller_lnp_dpid WHERE dpid <=> OLD.caller_lnp_dpid;
    UPDATE voip_usr_preferences a, voip_preferences b
       SET a.value = NEW.caller_lnp_dpid
     WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_lnp_dpid;
    UPDATE voip_dom_preferences a, voip_preferences b
       SET a.value = NEW.caller_lnp_dpid
     WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_lnp_dpid;
    UPDATE voip_peer_preferences a, voip_preferences b
       SET a.value = NEW.caller_lnp_dpid
     WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_lnp_dpid;
    UPDATE voip_prof_preferences a, voip_preferences b
       SET a.value = NEW.caller_lnp_dpid
     WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.caller_lnp_dpid;
  END IF;

  IF NEW.callee_lnp_dpid != OLD.callee_lnp_dpid THEN
    UPDATE kamailio.dialplan SET dpid = NEW.callee_lnp_dpid WHERE dpid <=> OLD.callee_lnp_dpid;
    UPDATE voip_usr_preferences a, voip_preferences b
       SET a.value = NEW.callee_lnp_dpid
     WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_lnp_dpid;
    UPDATE voip_dom_preferences a, voip_preferences b
       SET a.value = NEW.callee_lnp_dpid
     WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_lnp_dpid;
    UPDATE voip_peer_preferences a, voip_preferences b
       SET a.value = NEW.callee_lnp_dpid
     WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_lnp_dpid;
    UPDATE voip_prof_preferences a, voip_preferences b
       SET a.value = NEW.callee_lnp_dpid
     WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
       AND a.attribute_id <=> b.id
       AND a.value <=> OLD.callee_lnp_dpid;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_rwrulesets_drepl_trig BEFORE DELETE ON voip_rewrite_rule_sets
  FOR EACH ROW BEGIN

  DELETE a FROM voip_usr_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_in_dpid;
  DELETE a FROM voip_usr_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_in_dpid;
  DELETE a FROM voip_usr_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_out_dpid;
  DELETE a FROM voip_usr_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_out_dpid;
  DELETE a FROM voip_usr_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_lnp_dpid;
  DELETE a FROM voip_usr_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_lnp_dpid;

  DELETE a FROM voip_dom_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_in_dpid;
  DELETE a FROM voip_dom_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_in_dpid;
  DELETE a FROM voip_dom_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_out_dpid;
  DELETE a FROM voip_dom_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_out_dpid;
  DELETE a FROM voip_dom_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_lnp_dpid;
  DELETE a FROM voip_dom_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_lnp_dpid;

  DELETE a FROM voip_peer_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_in_dpid;
  DELETE a FROM voip_peer_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_in_dpid;
  DELETE a FROM voip_peer_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_out_dpid;
  DELETE a FROM voip_peer_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_out_dpid;
  DELETE a FROM voip_peer_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_lnp_dpid;
  DELETE a FROM voip_peer_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_lnp_dpid;

  DELETE a FROM voip_prof_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_in_dpid;
  DELETE a FROM voip_prof_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_in_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_in_dpid;
  DELETE a FROM voip_prof_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_out_dpid;
  DELETE a FROM voip_prof_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_out_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_out_dpid;
  DELETE a FROM voip_prof_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_caller_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.caller_lnp_dpid;
  DELETE a FROM voip_prof_preferences a, voip_preferences b
   WHERE b.attribute <=> 'rewrite_callee_lnp_dpid'
     AND a.attribute_id <=> b.id
     AND a.value <=> OLD.callee_lnp_dpid;

  DELETE FROM kamailio.dialplan WHERE dpid <=> OLD.caller_in_dpid;
  DELETE FROM kamailio.dialplan WHERE dpid <=> OLD.callee_in_dpid;
  DELETE FROM kamailio.dialplan WHERE dpid <=> OLD.caller_out_dpid;
  DELETE FROM kamailio.dialplan WHERE dpid <=> OLD.callee_out_dpid;
  DELETE FROM kamailio.dialplan WHERE dpid <=> OLD.caller_lnp_dpid;
  DELETE FROM kamailio.dialplan WHERE dpid <=> OLD.callee_lnp_dpid;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_rwrules_crepl_trig AFTER INSERT ON voip_rewrite_rules
  FOR EACH ROW BEGIN

  DECLARE new_set_id int(11) unsigned;

  IF NEW.enabled = 1 THEN

    IF NEW.direction = 'in' THEN
      SELECT IF(NEW.field = 'caller', caller_in_dpid, callee_in_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    ELSEIF NEW.direction = 'out' THEN
      SELECT IF(NEW.field = 'caller', caller_out_dpid, callee_out_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    ELSEIF NEW.direction = 'lnp' THEN
      SELECT IF(NEW.field = 'caller', caller_lnp_dpid, callee_lnp_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    END IF;

    INSERT INTO kamailio.dialplan (dpid,pr,match_op,match_exp,match_len,subst_exp,repl_exp,attrs)
        VALUES(new_set_id,NEW.priority,1,NEW.match_pattern,0,NEW.match_pattern,NEW.replace_pattern,'');
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_rwrules_urepl_trig AFTER UPDATE ON voip_rewrite_rules
  FOR EACH ROW BEGIN

  DECLARE old_set_id int(11) unsigned;
  DECLARE new_set_id int(11) unsigned;

  IF OLD.enabled = 1 AND NEW.enabled = 1 THEN

    IF OLD.direction = 'in' THEN
      SELECT IF(OLD.field = 'caller', caller_in_dpid, callee_in_dpid)
        INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
    ELSEIF OLD.direction = 'out' THEN
      SELECT IF(OLD.field = 'caller', caller_out_dpid, callee_out_dpid)
        INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
    ELSEIF OLD.direction = 'lnp' THEN
      SELECT IF(OLD.field = 'caller', caller_lnp_dpid, callee_lnp_dpid)
        INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
    END IF;

    IF NEW.direction = 'in' THEN
      SELECT IF(NEW.field = 'caller', caller_in_dpid, callee_in_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    ELSEIF NEW.direction = 'out' THEN
      SELECT IF(NEW.field = 'caller', caller_out_dpid, callee_out_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    ELSEIF NEW.direction = 'lnp' THEN
      SELECT IF(NEW.field = 'caller', caller_lnp_dpid, callee_lnp_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    END IF;

    UPDATE kamailio.dialplan
       SET dpid      = new_set_id,
           pr        = NEW.priority,
           match_exp = NEW.match_pattern,
           subst_exp = NEW.match_pattern,
           repl_exp  = NEW.replace_pattern
     WHERE dpid      <=> old_set_id
       AND pr        <=> OLD.priority
       AND match_exp <=> OLD.match_pattern
       AND subst_exp <=> OLD.match_pattern
       AND repl_exp  <=> OLD.replace_pattern;
  ELSEIF OLD.enabled = 0 AND NEW.enabled = 1 THEN

    IF NEW.direction = 'in' THEN
      SELECT IF(NEW.field = 'caller', caller_in_dpid, callee_in_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    ELSEIF NEW.direction = 'out' THEN
      SELECT IF(NEW.field = 'caller', caller_out_dpid, callee_out_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    ELSEIF NEW.direction = 'lnp' THEN
      SELECT IF(NEW.field = 'caller', caller_lnp_dpid, callee_lnp_dpid)
        INTO new_set_id FROM voip_rewrite_rule_sets WHERE id <=> NEW.set_id;
    END IF;

    INSERT INTO kamailio.dialplan (dpid,pr,match_op,match_exp,match_len,subst_exp,repl_exp,attrs)
                          VALUES(new_set_id,NEW.priority,1,NEW.match_pattern,0,NEW.match_pattern,NEW.replace_pattern,'');
  ELSEIF OLD.enabled = 1 AND NEW.enabled = 0 THEN

    IF OLD.direction = 'in' THEN
      SELECT IF(OLD.field = 'caller', caller_in_dpid, callee_in_dpid)
        INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
    ELSEIF OLD.direction = 'out' THEN
      SELECT IF(OLD.field = 'caller', caller_out_dpid, callee_out_dpid)
        INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
    ELSEIF OLD.direction = 'lnp' THEN
      SELECT IF(OLD.field = 'caller', caller_lnp_dpid, callee_lnp_dpid)
        INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
    END IF;

    DELETE FROM kamailio.dialplan
     WHERE dpid      <=> old_set_id
       AND pr        <=> OLD.priority
       AND match_exp <=> OLD.match_pattern
       AND subst_exp <=> OLD.match_pattern
       AND repl_exp  <=> OLD.replace_pattern;
  END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_rwrules_drepl_trig BEFORE DELETE ON voip_rewrite_rules
  FOR EACH ROW BEGIN

  DECLARE old_set_id int(11) unsigned;

  IF OLD.direction = 'in' THEN
    SELECT IF(OLD.field = 'caller', caller_in_dpid, callee_in_dpid)
  	  INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
  ELSEIF OLD.direction = 'out' THEN
    SELECT IF(OLD.field = 'caller', caller_out_dpid, callee_out_dpid)
	  INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
  ELSEIF OLD.direction = 'lnp' THEN
    SELECT IF(OLD.field = 'caller', caller_lnp_dpid, callee_lnp_dpid)
	  INTO old_set_id FROM voip_rewrite_rule_sets WHERE id <=> OLD.set_id;
  END IF;

  DELETE FROM kamailio.dialplan
   WHERE dpid      <=> old_set_id
     AND pr        <=> OLD.priority
     AND match_exp <=> OLD.match_pattern
     AND subst_exp <=> OLD.match_pattern
     AND repl_exp  <=> OLD.replace_pattern;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_sound_files_create_trig AFTER INSERT ON voip_sound_files
FOR each ROW BEGIN

    CALL update_sound_set_handle_parents(NEW.set_id, NEW.handle_id);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_sound_files_update_trig AFTER UPDATE ON voip_sound_files
FOR each ROW BEGIN

    CALL update_sound_set_handle_parents(NEW.set_id, NEW.handle_id);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_sound_files_delete_trig AFTER DELETE ON voip_sound_files
FOR each ROW BEGIN

    DECLARE done INT DEFAULT 0;
    DECLARE set_id INT DEFAULT 0;
    DECLARE x CURSOR FOR
        SELECT DISTINCT set_id
          FROM voip_sound_set_handle_parents
         WHERE parent_set_id = OLD.set_id
           AND handle_id = OLD.handle_id;
    DECLARE continue handler FOR NOT FOUND SET done = true;

    OPEN x;
    iter: LOOP
        FETCH x INTO set_id;
        IF done THEN
            LEAVE iter;
        END IF;
        CALL update_sound_set_handle_parents(set_id, OLD.handle_id);
    END LOOP;
    CLOSE x;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_sound_sets_create_trig AFTER INSERT ON voip_sound_sets
FOR each ROW BEGIN

    CALL update_sound_set_handle_parents(NEW.id, NULL);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_sound_sets_update_trig AFTER UPDATE ON voip_sound_sets
FOR each ROW BEGIN

    IF NOT (OLD.parent_id <=> NEW.parent_id) THEN
        CALL update_sound_set_handle_parents(NEW.id, NULL);
    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_sound_sets_delete_trig AFTER DELETE ON voip_sound_sets
FOR each ROW BEGIN

    DECLARE done INT DEFAULT 0;
    DECLARE set_id INT DEFAULT 0;
    DECLARE x CURSOR FOR
        SELECT DISTINCT set_id
          FROM voip_sound_set_handle_parents
         WHERE parent_set_id = OLD.id;
    DECLARE continue handler FOR NOT FOUND SET done = true;

    OPEN x;
    iter: LOOP
        FETCH x INTO set_id;
        IF done THEN
            LEAVE iter;
        END IF;
        CALL update_sound_set_handle_parents(set_id, NULL);
    END LOOP;
    CLOSE x;

    CALL update_sound_set_handle_parents(OLD.id, NULL);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_sd_crepl_trig AFTER INSERT ON voip_speed_dial
  FOR EACH ROW BEGIN
  DECLARE target_username varchar(64);
  DECLARE target_domain varchar(64);

  SELECT a.username, b.domain INTO target_username, target_domain
                              FROM voip_subscribers a, voip_domains b
                              WHERE a.id <=> NEW.subscriber_id
                              AND b.id <=> a.domain_id;

  INSERT INTO kamailio.speed_dial (username, domain, sd_username, sd_domain,
                                  new_uri, fname, lname, description)
                          VALUES(target_username, target_domain,
                                 NEW.slot, target_domain,
                                 NEW.destination, '', '', '');
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_sd_urepl_trig AFTER UPDATE ON voip_speed_dial
  FOR EACH ROW BEGIN
  DECLARE old_username varchar(127);
  DECLARE old_domain varchar(127);
  DECLARE new_username varchar(127);
  DECLARE new_domain varchar(127);

  SELECT a.username, b.domain INTO old_username, old_domain
                              FROM voip_subscribers a, voip_domains b
                             WHERE a.id <=> OLD.subscriber_id
                               AND b.id <=> a.domain_id;
  SELECT a.username, b.domain INTO new_username, new_domain
                              FROM voip_subscribers a, voip_domains b
                             WHERE a.id <=> NEW.subscriber_id
                               AND b.id <=> a.domain_id;

  UPDATE kamailio.speed_dial SET username = new_username, domain = new_domain,
                               sd_username = NEW.slot, sd_domain = new_domain,
                               new_uri = NEW.destination
                           WHERE username <=> old_username
                           AND domain <=> old_domain
                           AND sd_username <=> OLD.slot;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_sd_drepl_trig BEFORE DELETE ON voip_speed_dial
  FOR EACH ROW BEGIN
  DECLARE old_username varchar(127);
  DECLARE old_domain varchar(127);

  SELECT a.username, b.domain INTO old_username, old_domain
                              FROM voip_subscribers a, voip_domains b
                             WHERE a.id <=> OLD.subscriber_id
                               AND b.id <=> a.domain_id;

  DELETE FROM kamailio.speed_dial WHERE username <=> old_username
                                  AND domain <=> old_domain
                                  AND sd_username <=> OLD.slot;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_prof_crepl_trig AFTER INSERT ON voip_subscriber_profiles
FOR EACH ROW BEGIN

    INSERT INTO voip_prof_preferences (profile_id, attribute_id, value)
    SELECT NEW.id, p.id, pe.value
    FROM voip_preferences p, voip_preferences_enum pe
    WHERE p.id <=> preference_id AND p.prof_pref=1 AND pe.prof_pref=1 AND pe.default_val=1 AND pe.value IS NOT NULL;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_sub_crepl_trig AFTER INSERT ON voip_subscribers
FOR EACH ROW BEGIN
    
    DECLARE subscriber_domain varchar(127);
  
    SELECT domain INTO subscriber_domain FROM voip_domains where id = NEW.domain_id;
  
    INSERT INTO kamailio.subscriber (username, domain, uuid, password, datetime_created, ha1, ha1b)
                     VALUES(NEW.username, subscriber_domain, NEW.uuid, NEW.password, '0',
                            MD5(CONCAT(NEW.username, ':', subscriber_domain, ':', NEW.password)),
                            MD5(CONCAT(NEW.username, '@', subscriber_domain, ':', subscriber_domain, ':', NEW.password)));

    
    INSERT INTO voip_usr_preferences (subscriber_id, attribute_id, value)
    SELECT NEW.id, p.id, pe.value
    FROM voip_preferences p, voip_preferences_enum pe
    WHERE p.id <=> preference_id AND p.usr_pref=1 AND pe.usr_pref=1 AND pe.default_val=1 AND pe.value IS NOT NULL;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_sub_urepl_trig AFTER UPDATE ON voip_subscribers
  FOR EACH ROW BEGIN
  DECLARE old_subscriber_domain varchar(127);
  DECLARE new_subscriber_domain varchar(127);

  SELECT domain INTO old_subscriber_domain FROM voip_domains where id = OLD.domain_id;
  SELECT domain INTO new_subscriber_domain FROM voip_domains where id = NEW.domain_id;

  UPDATE kamailio.subscriber SET username = NEW.username, domain = new_subscriber_domain,
                                uuid = NEW.uuid, password = NEW.password,
                                ha1 = MD5(CONCAT(NEW.username, ':', new_subscriber_domain, ':', NEW.password)),
                                ha1b = MD5(CONCAT(NEW.username, '@', new_subscriber_domain, ':', new_subscriber_domain, ':', NEW.password))
                          WHERE username <=> OLD.username
                            AND domain <=> old_subscriber_domain;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_sub_drepl_trig BEFORE DELETE ON voip_subscribers
  FOR EACH ROW BEGIN
  DECLARE subscriber_domain varchar(127);
  DECLARE os_subscriber_id int(10) UNSIGNED;

  SELECT domain INTO subscriber_domain FROM voip_domains where id = OLD.domain_id;
  SELECT id INTO os_subscriber_id FROM kamailio.subscriber
   WHERE username <=> OLD.username AND domain <=> subscriber_domain;

  DELETE FROM kamailio.subscriber WHERE username <=> OLD.username
                                   AND domain <=> subscriber_domain;

  
  
  DELETE FROM kamailio.voicemail_users WHERE customer_id <=> OLD.uuid;

  
  
  DELETE FROM kamailio.usr_preferences WHERE username <=> OLD.username
                                        AND domain <=> subscriber_domain;
  DELETE FROM kamailio.dbaliases WHERE username <=> OLD.username
                                  AND domain <=> subscriber_domain;
  DELETE FROM kamailio.speed_dial WHERE username <=> OLD.username
                                  AND domain <=> subscriber_domain;
  DELETE FROM kamailio.fax_preferences WHERE subscriber_id <=> os_subscriber_id;
  DELETE FROM kamailio.fax_destinations WHERE subscriber_id <=> os_subscriber_id;
  DELETE FROM kamailio.trusted WHERE tag <=> OLD.uuid;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER trusted_sources_insert AFTER INSERT ON voip_trusted_sources
FOR EACH ROW
    INSERT INTO kamailio.trusted (src_ip, proto, from_pattern, tag)
    VALUES (NEW.src_ip, NEW.protocol, NEW.from_pattern, NEW.uuid) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trusted_sources_update BEFORE UPDATE ON voip_trusted_sources
FOR EACH ROW
    UPDATE kamailio.trusted SET
        src_ip=NEW.src_ip, proto=NEW.protocol, from_pattern=NEW.from_pattern, tag=NEW.uuid
    WHERE
        src_ip <=> OLD.src_ip and proto <=> OLD.protocol and from_pattern <=> OLD.from_pattern and tag <=> OLD.uuid */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trusted_sources_delete BEFORE DELETE ON voip_trusted_sources
FOR EACH ROW
    DELETE FROM kamailio.trusted 
    WHERE src_ip <=> OLD.src_ip and proto <=> OLD.protocol and from_pattern <=> OLD.from_pattern and tag <=> OLD.uuid */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_usrpref_crepl_trig AFTER INSERT ON voip_usr_preferences
  FOR EACH ROW BEGIN
  DECLARE subscriber_username varchar(127);
  DECLARE subscriber_domain varchar(127);
  DECLARE subscriber_uuid char(36);
  DECLARE attribute_name varchar(31);
  DECLARE attribute_type tinyint(3);

  SELECT a.username, b.domain, a.uuid INTO subscriber_username, subscriber_domain, subscriber_uuid
                                      FROM voip_subscribers a, voip_domains b
                                     WHERE a.id <=> NEW.subscriber_id
                                       AND a.domain_id <=> b.id;
  SELECT attribute, type INTO attribute_name, attribute_type
                         FROM voip_preferences
                        WHERE id <=> NEW.attribute_id;

  INSERT INTO kamailio.usr_preferences (uuid, username, domain, attribute, type, value)
                                VALUES(subscriber_uuid, subscriber_username, subscriber_domain,
                                       attribute_name, attribute_type, NEW.value);
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_usrpref_urepl_trig AFTER UPDATE ON voip_usr_preferences
  FOR EACH ROW BEGIN
  DECLARE old_subscriber_username varchar(127);
  DECLARE new_subscriber_username varchar(127);
  DECLARE old_subscriber_domain varchar(127);
  DECLARE new_subscriber_domain varchar(127);
  DECLARE old_attribute_name varchar(31);
  DECLARE new_attribute_name varchar(31);

  SELECT a.username, b.domain INTO old_subscriber_username, old_subscriber_domain
                              FROM voip_subscribers a, voip_domains b
                             WHERE a.id <=> OLD.subscriber_id
                               AND a.domain_id <=> b.id;
  SELECT a.username, b.domain INTO new_subscriber_username, new_subscriber_domain
                              FROM voip_subscribers a, voip_domains b
                             WHERE a.id <=> NEW.subscriber_id
                               AND a.domain_id <=> b.id;
  SELECT attribute INTO old_attribute_name
                   FROM voip_preferences
                  WHERE id <=> OLD.attribute_id;
  SELECT attribute INTO new_attribute_name
                   FROM voip_preferences
                  WHERE id <=> NEW.attribute_id;

  UPDATE kamailio.usr_preferences SET username = new_subscriber_username, domain = new_subscriber_domain,
                                     attribute = new_attribute_name, value = NEW.value
                               WHERE username <=> old_subscriber_username
                                 AND domain <=> old_subscriber_domain
                                 AND attribute <=> old_attribute_name
                                 AND value <=> OLD.value;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER voip_usrpref_drepl_trig BEFORE DELETE ON voip_usr_preferences
  FOR EACH ROW BEGIN
  DECLARE subscriber_username varchar(127);
  DECLARE subscriber_domain varchar(127);
  DECLARE attribute_name varchar(31);

  SELECT a.username, b.domain INTO subscriber_username, subscriber_domain
                              FROM voip_subscribers a, voip_domains b
                             WHERE a.id <=> OLD.subscriber_id
                               AND a.domain_id <=> b.id;
  SELECT attribute INTO attribute_name
                   FROM voip_preferences
                  WHERE id <=> OLD.attribute_id;

  DELETE FROM kamailio.usr_preferences WHERE username <=> subscriber_username
                                        AND domain <=> subscriber_domain
                                        AND attribute <=> attribute_name
                                        AND value <=> OLD.value;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_usr_preferences_blob_insert AFTER INSERT ON voip_usr_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_usr_preferences
       SET value = NEW.id
     WHERE id = NEW.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER voip_usr_preferences_blob_delete AFTER DELETE ON voip_usr_preferences_blob
  FOR EACH ROW BEGIN

  UPDATE voip_usr_preferences
       SET value = ''
     WHERE id = OLD.preference_id;

  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
COMMIT;
