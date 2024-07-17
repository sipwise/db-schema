SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE kamailio;
USE kamailio;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(16) NOT NULL DEFAULT '',
  `from_tag` varchar(128) NOT NULL DEFAULT '',
  `to_tag` varchar(128) NOT NULL DEFAULT '',
  `callid` varchar(255) NOT NULL DEFAULT '',
  `sip_code` varchar(3) NOT NULL DEFAULT '',
  `sip_reason` varchar(128) NOT NULL DEFAULT '',
  `time` datetime NOT NULL,
  `time_hires` decimal(13,3) NOT NULL,
  `src_leg` varchar(10240) DEFAULT NULL,
  `dst_leg` varchar(10240) DEFAULT NULL,
  `dst_user` varchar(64) NOT NULL DEFAULT '',
  `dst_ouser` varchar(64) NOT NULL DEFAULT '',
  `dst_domain` varchar(128) NOT NULL DEFAULT '',
  `src_user` varchar(64) NOT NULL DEFAULT '',
  `src_domain` varchar(128) NOT NULL DEFAULT '',
  `branch_id` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `callid_method_idx` (`callid`,`method`),
  KEY `method_idx` (`method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc_backup` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(16) NOT NULL DEFAULT '',
  `from_tag` varchar(128) NOT NULL DEFAULT '',
  `to_tag` varchar(128) NOT NULL DEFAULT '',
  `callid` varchar(255) NOT NULL DEFAULT '',
  `sip_code` varchar(3) NOT NULL DEFAULT '',
  `sip_reason` varchar(128) NOT NULL DEFAULT '',
  `time` datetime NOT NULL,
  `time_hires` decimal(13,3) NOT NULL,
  `src_leg` varchar(10240) DEFAULT NULL,
  `dst_leg` varchar(10240) DEFAULT NULL,
  `dst_user` varchar(64) NOT NULL DEFAULT '',
  `dst_ouser` varchar(64) NOT NULL DEFAULT '',
  `dst_domain` varchar(128) NOT NULL DEFAULT '',
  `src_user` varchar(64) NOT NULL DEFAULT '',
  `src_domain` varchar(128) NOT NULL DEFAULT '',
  `branch_id` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc_cdrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_time` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `end_time` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `duration` float(10,3) NOT NULL DEFAULT 0.000,
  PRIMARY KEY (`id`),
  KEY `start_time_idx` (`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc_trash` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(16) NOT NULL DEFAULT '',
  `from_tag` varchar(128) NOT NULL DEFAULT '',
  `to_tag` varchar(128) NOT NULL DEFAULT '',
  `callid` varchar(255) NOT NULL DEFAULT '',
  `sip_code` varchar(3) NOT NULL DEFAULT '',
  `sip_reason` varchar(128) NOT NULL DEFAULT '',
  `time` datetime NOT NULL,
  `time_hires` decimal(13,3) NOT NULL,
  `src_leg` varchar(10240) DEFAULT NULL,
  `dst_leg` varchar(10240) DEFAULT NULL,
  `dst_user` varchar(64) NOT NULL DEFAULT '',
  `dst_ouser` varchar(64) NOT NULL DEFAULT '',
  `dst_domain` varchar(128) NOT NULL DEFAULT '',
  `src_user` varchar(64) NOT NULL DEFAULT '',
  `src_domain` varchar(128) NOT NULL DEFAULT '',
  `branch_id` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_watchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `presentity_uri` varchar(255) NOT NULL,
  `watcher_username` varchar(64) NOT NULL,
  `watcher_domain` varchar(64) NOT NULL,
  `to_user` varchar(64) NOT NULL,
  `to_domain` varchar(64) NOT NULL,
  `event` varchar(64) NOT NULL DEFAULT 'presence',
  `event_id` varchar(64) DEFAULT NULL,
  `to_tag` varchar(128) NOT NULL,
  `from_tag` varchar(128) NOT NULL,
  `callid` varchar(255) NOT NULL,
  `local_cseq` int(11) NOT NULL,
  `remote_cseq` int(11) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `record_route` text DEFAULT NULL,
  `expires` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 2,
  `reason` varchar(64) DEFAULT NULL,
  `version` int(11) NOT NULL DEFAULT 0,
  `socket_info` varchar(64) NOT NULL,
  `local_contact` varchar(255) NOT NULL,
  `from_user` varchar(64) NOT NULL,
  `from_domain` varchar(64) NOT NULL,
  `updated` int(11) NOT NULL,
  `updated_winfo` int(11) NOT NULL,
  `flags` int(11) NOT NULL DEFAULT 0,
  `user_agent` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `active_watchers_idx` (`callid`,`to_tag`,`from_tag`),
  KEY `active_watchers_expires` (`expires`),
  KEY `updated_idx` (`updated`),
  KEY `updated_winfo_idx` (`updated_winfo`,`presentity_uri`),
  KEY `active_watchers_pres` (`presentity_uri`,`event`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grp` int(11) unsigned NOT NULL DEFAULT 1,
  `ip_addr` varchar(50) NOT NULL,
  `mask` int(11) NOT NULL DEFAULT 32,
  `port` smallint(5) unsigned NOT NULL DEFAULT 0,
  `tag` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ad_grp_idx` (`grp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents` (
  `name` varchar(255) DEFAULT NULL,
  `instance_id` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `contact` varchar(1024) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `max_no_answer` int(11) NOT NULL DEFAULT 0,
  `wrap_up_time` int(11) NOT NULL DEFAULT 0,
  `reject_delay_time` int(11) NOT NULL DEFAULT 0,
  `busy_delay_time` int(11) NOT NULL DEFAULT 0,
  `no_answer_delay_time` int(11) NOT NULL DEFAULT 0,
  `last_bridge_start` int(11) NOT NULL DEFAULT 0,
  `last_bridge_end` int(11) NOT NULL DEFAULT 0,
  `last_offered_call` int(11) NOT NULL DEFAULT 0,
  `last_status_change` int(11) NOT NULL DEFAULT 0,
  `no_answer_count` int(11) NOT NULL DEFAULT 0,
  `calls_answered` int(11) NOT NULL DEFAULT 0,
  `talk_time` int(11) NOT NULL DEFAULT 0,
  `ready_time` int(11) NOT NULL DEFAULT 0,
  `external_calls_count` int(11) NOT NULL DEFAULT 0,
  KEY `idx_name` (`name`),
  KEY `idx_state` (`state`),
  KEY `idx_last_offered_call` (`last_offered_call`),
  KEY `idx_name_status_state` (`status`,`state`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aliases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ruid` varchar(64) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `domain` varchar(64) DEFAULT NULL,
  `contact` varchar(255) NOT NULL DEFAULT '',
  `received` varchar(255) DEFAULT NULL,
  `path` varchar(128) DEFAULT NULL,
  `expires` datetime NOT NULL DEFAULT '2030-05-28 21:32:15',
  `q` float(10,2) NOT NULL DEFAULT 1.00,
  `callid` varchar(255) NOT NULL DEFAULT 'Default-Call-ID',
  `cseq` int(11) NOT NULL DEFAULT 1,
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  `flags` int(11) NOT NULL DEFAULT 0,
  `cflags` int(11) NOT NULL DEFAULT 0,
  `user_agent` varchar(255) NOT NULL DEFAULT '',
  `socket` varchar(64) DEFAULT NULL,
  `methods` int(11) DEFAULT NULL,
  `instance` varchar(255) DEFAULT NULL,
  `reg_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ruid_idx` (`ruid`),
  KEY `alias_idx` (`username`,`domain`,`contact`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `location_id` int(11) unsigned DEFAULT NULL,
  `username` varchar(128) NOT NULL DEFAULT '0',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT 0,
  `value` varchar(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbaliases` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias_username` varchar(64) NOT NULL DEFAULT '',
  `alias_domain` varchar(64) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `is_devid` tinyint(1) NOT NULL DEFAULT 0,
  `devid_alias` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `target_idx` (`username`,`domain`),
  KEY `alias_idx` (`alias_username`,`alias_domain`),
  KEY `alias_user_idx` (`alias_username`),
  KEY `devid_alias_dom_idx` (`devid_alias`,`alias_domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dialog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash_entry` int(10) unsigned NOT NULL,
  `hash_id` int(10) unsigned NOT NULL,
  `callid` varchar(255) NOT NULL,
  `from_uri` varchar(255) NOT NULL,
  `from_tag` varchar(128) NOT NULL,
  `to_uri` varchar(255) NOT NULL,
  `to_tag` varchar(128) NOT NULL,
  `caller_cseq` varchar(20) NOT NULL,
  `callee_cseq` varchar(20) NOT NULL,
  `caller_route_set` varchar(512) DEFAULT NULL,
  `callee_route_set` varchar(512) DEFAULT NULL,
  `caller_contact` varchar(256) NOT NULL,
  `callee_contact` varchar(256) NOT NULL,
  `caller_sock` varchar(64) NOT NULL,
  `callee_sock` varchar(64) NOT NULL,
  `state` int(10) unsigned NOT NULL,
  `start_time` int(10) unsigned NOT NULL,
  `timeout` int(10) unsigned NOT NULL DEFAULT 0,
  `sflags` int(10) unsigned NOT NULL DEFAULT 0,
  `toroute_name` varchar(32) DEFAULT NULL,
  `req_uri` varchar(255) NOT NULL,
  `iflags` int(10) unsigned NOT NULL DEFAULT 0,
  `xdata` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hash_idx` (`hash_entry`,`hash_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dialog_vars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash_entry` int(10) unsigned NOT NULL,
  `hash_id` int(10) unsigned NOT NULL,
  `dialog_key` varchar(128) NOT NULL,
  `dialog_value` varchar(512) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hash_idx` (`hash_entry`,`hash_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dialplan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dpid` int(11) NOT NULL,
  `pr` int(11) NOT NULL,
  `match_op` int(11) NOT NULL,
  `match_exp` varchar(128) NOT NULL,
  `match_len` int(11) NOT NULL,
  `subst_exp` varchar(128) NOT NULL,
  `repl_exp` varchar(256) NOT NULL,
  `attrs` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dispatcher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `setid` int(11) NOT NULL DEFAULT 0,
  `destination` varchar(192) NOT NULL DEFAULT '',
  `flags` int(11) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL DEFAULT 0,
  `attrs` varchar(128) NOT NULL DEFAULT '',
  `description` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dom_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `username` varchar(128) NOT NULL DEFAULT '0',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT 0,
  `value` varchar(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`),
  KEY `uda_idx` (`username`,`domain`,`attribute`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(64) NOT NULL,
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  `did` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_idx` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_attrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `did` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `type` int(10) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `domain_attrs_idx` (`did`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fax_destinations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(10) unsigned NOT NULL,
  `destination` varchar(64) NOT NULL,
  `filetype` enum('ps','tiff','pdf','pdf14') NOT NULL DEFAULT 'tiff',
  `cc` enum('true','false') NOT NULL DEFAULT 'false',
  `incoming` enum('true','false') NOT NULL DEFAULT 'true',
  `outgoing` enum('true','false') NOT NULL DEFAULT 'false',
  `status` enum('true','false') NOT NULL DEFAULT 'false',
  PRIMARY KEY (`id`),
  KEY `subscriber_id` (`subscriber_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fax_journal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(10) unsigned NOT NULL DEFAULT 0,
  `the_timestamp` int(11) unsigned NOT NULL DEFAULT 0,
  `duration` int(11) unsigned NOT NULL DEFAULT 0,
  `direction` enum('in','out') NOT NULL DEFAULT 'in',
  `peer_number` varchar(255) NOT NULL DEFAULT '',
  `peer_name` varchar(255) NOT NULL DEFAULT '',
  `pages` int(10) unsigned NOT NULL DEFAULT 0,
  `reason` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT '',
  `signal_rate` int(10) unsigned NOT NULL DEFAULT 0,
  `quality` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `selkey` (`subscriber_id`,`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fax_preferences` (
  `subscriber_id` int(10) unsigned NOT NULL,
  `password` varchar(64) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `active` enum('true','false') NOT NULL DEFAULT 'true',
  `send_status` enum('true','false') NOT NULL DEFAULT 'false',
  `send_copy` enum('true','false') NOT NULL DEFAULT 'false',
  `send_copy_cc` enum('true','false') NOT NULL DEFAULT 'false',
  PRIMARY KEY (`subscriber_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `htable` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key_name` varchar(64) NOT NULL DEFAULT '',
  `key_type` int(11) NOT NULL DEFAULT 0,
  `value_type` int(11) NOT NULL DEFAULT 0,
  `key_value` varchar(128) NOT NULL DEFAULT '',
  `expires` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lcr_gw` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lcr_id` smallint(5) unsigned NOT NULL,
  `gw_name` varchar(128) DEFAULT NULL,
  `ip_addr` varchar(50) DEFAULT NULL,
  `hostname` varchar(64) DEFAULT NULL,
  `port` smallint(5) unsigned DEFAULT NULL,
  `params` varchar(64) DEFAULT NULL,
  `uri_scheme` tinyint(3) unsigned DEFAULT NULL,
  `transport` tinyint(3) unsigned DEFAULT NULL,
  `strip` tinyint(3) unsigned DEFAULT NULL,
  `tag` varchar(64) DEFAULT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `defunct` int(10) unsigned DEFAULT NULL,
  `group_id` int(11) unsigned NOT NULL,
  `prefix` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lcr_id_gw_name_idx` (`lcr_id`,`gw_name`),
  KEY `lcr_id_idx` (`lcr_id`),
  KEY `lcr_id_ip_addr_idx` (`lcr_id`,`ip_addr`),
  CONSTRAINT `lcr_gw_id_ref` FOREIGN KEY (`id`) REFERENCES `provisioning`.`voip_peer_hosts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lcr_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lcr_id` smallint(5) unsigned NOT NULL,
  `prefix` varchar(16) DEFAULT NULL,
  `request_uri` varchar(64) DEFAULT '',
  `mt_tvalue` varchar(128) DEFAULT NULL,
  `from_uri` varchar(64) DEFAULT NULL,
  `stopper` int(10) unsigned NOT NULL DEFAULT 0,
  `enabled` int(10) unsigned NOT NULL DEFAULT 1,
  `group_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lcr_id_prefix_from_uri_idx` (`lcr_id`,`prefix`,`from_uri`,`request_uri`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lcr_rule_target` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lcr_id` smallint(5) unsigned NOT NULL,
  `rule_id` int(10) unsigned NOT NULL,
  `gw_id` int(10) unsigned NOT NULL,
  `priority` tinyint(3) unsigned NOT NULL,
  `weight` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rule_id_gw_id_idx` (`rule_id`,`gw_id`),
  KEY `lcr_id_idx` (`lcr_id`),
  KEY `gw_id_idx` (`gw_id`),
  CONSTRAINT `l_r_t_gwid_ref` FOREIGN KEY (`gw_id`) REFERENCES `lcr_gw` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `l_r_t_ruleid_ref` FOREIGN KEY (`rule_id`) REFERENCES `lcr_rule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `domain` varchar(64) DEFAULT NULL,
  `contact` varchar(512) NOT NULL DEFAULT '',
  `received` varchar(128) DEFAULT NULL,
  `path` varchar(512) DEFAULT NULL,
  `q` float(10,2) NOT NULL DEFAULT 1.00,
  `callid` varchar(255) NOT NULL DEFAULT 'Default-Call-ID',
  `cseq` int(11) NOT NULL DEFAULT 13,
  `flags` int(11) NOT NULL DEFAULT 0,
  `cflags` int(11) NOT NULL DEFAULT 0,
  `user_agent` varchar(255) NOT NULL DEFAULT '',
  `socket` varchar(64) DEFAULT NULL,
  `methods` int(11) DEFAULT NULL,
  `ruid` varchar(64) NOT NULL DEFAULT '',
  `reg_id` int(11) NOT NULL DEFAULT 0,
  `instance` varchar(255) DEFAULT NULL,
  `server_id` int(11) NOT NULL DEFAULT 0,
  `connection_id` int(11) NOT NULL DEFAULT 0,
  `keepalive` int(11) NOT NULL DEFAULT 0,
  `partition` int(11) NOT NULL DEFAULT 0,
  `expires` bigint(20) NOT NULL DEFAULT 2000000000,
  `last_modified` bigint(20) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ruid_idx` (`ruid`),
  KEY `account_contact_idx` (`username`,`domain`,`contact`),
  KEY `part_kal_idx` (`partition`,`keepalive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location_attrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ruid` varchar(64) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `DOMAIN` varchar(64) DEFAULT NULL,
  `aname` varchar(64) NOT NULL DEFAULT '',
  `atype` int(11) NOT NULL DEFAULT 0,
  `avalue` varchar(512) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `account_record_idx` (`username`,`DOMAIN`,`ruid`),
  KEY `last_modified_idx` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `queue` varchar(255) DEFAULT NULL,
  `instance_id` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) NOT NULL DEFAULT '',
  `session_uuid` varchar(255) NOT NULL DEFAULT '',
  `cid_number` varchar(255) DEFAULT NULL,
  `cid_name` varchar(255) DEFAULT NULL,
  `system_epoch` int(11) NOT NULL DEFAULT 0,
  `joined_epoch` int(11) NOT NULL DEFAULT 0,
  `rejoined_epoch` int(11) NOT NULL DEFAULT 0,
  `bridge_epoch` int(11) NOT NULL DEFAULT 0,
  `abandoned_epoch` int(11) NOT NULL DEFAULT 0,
  `base_score` int(11) NOT NULL DEFAULT 0,
  `skill_score` int(11) NOT NULL DEFAULT 0,
  `serving_agent` varchar(255) DEFAULT NULL,
  `serving_system` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  KEY `idx_serving_agent_system_state` (`state`,`serving_agent`,`serving_system`),
  KEY `idx_queue_cid_number_state` (`queue`,`cid_number`,`state`),
  KEY `idx_uuid_session_uuid_state_queue` (`uuid`,`session_uuid`,`state`,`queue`),
  KEY `idx_serving_agent_uuid_instance_id` (`serving_agent`,`uuid`,`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_push_registrations` (
  `reg_id` varbinary(3072) NOT NULL,
  `type` enum('gcm','apns') NOT NULL,
  `subscriber_id` int(10) unsigned NOT NULL,
  `device_id` varbinary(255) NOT NULL,
  `apns_type` varchar(255) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reg_token` (`reg_id`),
  KEY `device_id` (`device_id`),
  KEY `subscriber_id` (`subscriber_id`,`apns_type`),
  CONSTRAINT `mobile_push_registrations_ibfk_1` FOREIGN KEY (`subscriber_id`) REFERENCES `provisioning`.`voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mohqcalls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mohq_id` int(10) unsigned NOT NULL,
  `call_id` varchar(100) NOT NULL,
  `call_status` int(10) unsigned NOT NULL,
  `call_from` varchar(100) NOT NULL,
  `call_contact` varchar(100) DEFAULT NULL,
  `call_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mohqcalls_idx` (`call_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mohqueues` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(25) NOT NULL,
  `uri` varchar(100) NOT NULL,
  `mohdir` varchar(100) DEFAULT NULL,
  `mohfile` varchar(100) NOT NULL,
  `debug` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mohqueue_uri_idx` (`uri`),
  UNIQUE KEY `mohqueue_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peer_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `username` varchar(128) NOT NULL DEFAULT '0',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT 0,
  `value` varchar(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `presentity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `domain` varchar(64) NOT NULL,
  `event` varchar(64) NOT NULL,
  `etag` varchar(128) NOT NULL,
  `expires` int(11) NOT NULL,
  `received_time` int(11) NOT NULL,
  `body` blob NOT NULL,
  `sender` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `ruid` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `presentity_idx` (`username`,`domain`,`event`,`etag`),
  UNIQUE KEY `ruid_idx` (`ruid`),
  KEY `presentity_expires` (`expires`),
  KEY `account_idx` (`username`,`domain`,`event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prof_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `username` varchar(128) NOT NULL DEFAULT '0',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT 0,
  `value` varchar(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`),
  KEY `uda_idx` (`username`,`domain`,`attribute`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pua` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pres_uri` varchar(255) NOT NULL,
  `pres_id` varchar(255) NOT NULL,
  `event` int(11) NOT NULL,
  `expires` int(11) NOT NULL,
  `desired_expires` int(11) NOT NULL,
  `flag` int(11) NOT NULL,
  `etag` varchar(128) NOT NULL,
  `tuple_id` varchar(64) DEFAULT NULL,
  `watcher_uri` varchar(255) NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `to_tag` varchar(128) NOT NULL,
  `from_tag` varchar(128) NOT NULL,
  `cseq` int(11) NOT NULL,
  `record_route` text DEFAULT NULL,
  `contact` varchar(255) NOT NULL,
  `remote_contact` varchar(255) NOT NULL,
  `version` int(11) NOT NULL,
  `extra_headers` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pua_idx` (`etag`,`tuple_id`,`call_id`,`from_tag`),
  KEY `expires_idx` (`expires`),
  KEY `dialog2_idx` (`call_id`,`from_tag`),
  KEY `dialog1_idx` (`pres_id`,`pres_uri`),
  KEY `record_idx` (`pres_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queues` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `strategy` varchar(64) DEFAULT 'longest-idle-agent',
  `moh_sound` varchar(255) DEFAULT 'local_stream://moh',
  `time_base_score` varchar(64) DEFAULT 'queue',
  `max_wait_time` varchar(10) DEFAULT '0',
  `max_wait_time_with_no_agent` varchar(10) DEFAULT '0',
  `max_wait_time_with_no_agent_time_reached` varchar(10) DEFAULT '0',
  `tier_rules_apply` varchar(10) DEFAULT 'false',
  `tier_rule_wait_second` varchar(10) DEFAULT '300',
  `tier_rule_wait_multiply_level` varchar(10) DEFAULT 'true',
  `tier_rule_no_agent_no_wait` varchar(10) DEFAULT 'true',
  `discard_abandoned_after` varchar(10) DEFAULT '60',
  `abandoned_resume_allowed` varchar(10) DEFAULT 'false',
  `record_template` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reseller_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '0',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT 0,
  `value` varchar(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`),
  KEY `uda_idx` (`username`,`domain`,`attribute`),
  KEY `av_idx` (`attribute`,`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rls_presentity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rlsubs_did` varchar(255) NOT NULL,
  `resource_uri` varchar(255) NOT NULL,
  `content_type` varchar(255) NOT NULL,
  `presence_state` blob NOT NULL,
  `expires` int(11) NOT NULL,
  `updated` int(11) NOT NULL,
  `auth_state` int(11) NOT NULL,
  `reason` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rls_presentity_idx` (`rlsubs_did`,`resource_uri`),
  KEY `rlsubs_idx` (`rlsubs_did`),
  KEY `updated_idx` (`updated`),
  KEY `expires_idx` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rls_watchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `presentity_uri` varchar(255) NOT NULL,
  `to_user` varchar(64) NOT NULL,
  `to_domain` varchar(64) NOT NULL,
  `watcher_username` varchar(64) NOT NULL,
  `watcher_domain` varchar(64) NOT NULL,
  `event` varchar(64) NOT NULL DEFAULT 'presence',
  `event_id` varchar(64) DEFAULT NULL,
  `to_tag` varchar(128) NOT NULL,
  `from_tag` varchar(128) NOT NULL,
  `callid` varchar(255) NOT NULL,
  `local_cseq` int(11) NOT NULL,
  `remote_cseq` int(11) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `record_route` text DEFAULT NULL,
  `expires` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 2,
  `reason` varchar(64) NOT NULL,
  `version` int(11) NOT NULL DEFAULT 0,
  `socket_info` varchar(64) NOT NULL,
  `local_contact` varchar(255) NOT NULL,
  `from_user` varchar(64) NOT NULL,
  `from_domain` varchar(64) NOT NULL,
  `updated` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rls_watcher_idx` (`callid`,`to_tag`,`from_tag`),
  KEY `rls_watchers_update` (`watcher_username`,`watcher_domain`,`event`),
  KEY `rls_watchers_expires` (`expires`),
  KEY `updated_idx` (`updated`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rtpproxy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `setid` varchar(32) NOT NULL DEFAULT '0',
  `url` varchar(64) NOT NULL DEFAULT '',
  `flags` int(11) NOT NULL DEFAULT 0,
  `weight` int(11) NOT NULL DEFAULT 1,
  `description` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sca_subscriptions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber` varchar(255) NOT NULL,
  `aor` varchar(255) NOT NULL,
  `event` int(11) NOT NULL DEFAULT 0,
  `expires` int(11) NOT NULL DEFAULT 0,
  `state` int(11) NOT NULL DEFAULT 0,
  `app_idx` int(11) NOT NULL DEFAULT 0,
  `call_id` varchar(255) NOT NULL,
  `from_tag` varchar(128) NOT NULL,
  `to_tag` varchar(128) NOT NULL,
  `record_route` text DEFAULT NULL,
  `notify_cseq` int(11) NOT NULL,
  `subscribe_cseq` int(11) NOT NULL,
  `server_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sca_subscriptions_idx` (`subscriber`,`call_id`,`from_tag`,`to_tag`),
  KEY `sca_subscribers_idx` (`subscriber`,`event`),
  KEY `sca_expires_idx` (`server_id`,`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sems_registrations` (
  `subscriber_id` int(10) unsigned DEFAULT NULL,
  `registration_status` tinyint(1) NOT NULL DEFAULT 0,
  `last_registration` datetime DEFAULT NULL,
  `expiry` datetime DEFAULT NULL,
  `last_code` smallint(2) DEFAULT NULL,
  `last_reason` varchar(256) DEFAULT NULL,
  `contacts` varchar(512) DEFAULT NULL,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `peer_host_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sub_id_ref` (`subscriber_id`),
  KEY `lcr_gw_ref` (`peer_host_id`),
  CONSTRAINT `lcr_gw_ref` FOREIGN KEY (`peer_host_id`) REFERENCES `lcr_gw` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sub_id_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `subscriber` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `silo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `src_addr` varchar(255) NOT NULL DEFAULT '',
  `dst_addr` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(64) NOT NULL DEFAULT '',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `inc_time` int(11) NOT NULL DEFAULT 0,
  `exp_time` int(11) NOT NULL DEFAULT 0,
  `snd_time` int(11) NOT NULL DEFAULT 0,
  `ctype` varchar(32) NOT NULL DEFAULT 'text/plain',
  `body` blob DEFAULT NULL,
  `extra_hdrs` text DEFAULT NULL,
  `callid` varchar(128) NOT NULL DEFAULT '',
  `status` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `account_idx` (`username`,`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `speed_dial` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `sd_username` varchar(64) NOT NULL DEFAULT '',
  `sd_domain` varchar(64) NOT NULL DEFAULT '',
  `new_uri` varchar(255) NOT NULL DEFAULT '',
  `fname` varchar(64) NOT NULL DEFAULT '',
  `lname` varchar(64) NOT NULL DEFAULT '',
  `description` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `speed_dial_idx` (`username`,`domain`,`sd_domain`,`sd_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriber` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL DEFAULT '',
  `ha1` varchar(128) NOT NULL DEFAULT '',
  `ha1b` varchar(128) NOT NULL DEFAULT '',
  `uuid` char(36) NOT NULL,
  `timezone` varchar(64) NOT NULL DEFAULT '',
  `datetime_created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_idx` (`username`,`domain`),
  KEY `username_idx` (`username`),
  KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tiers` (
  `queue` varchar(255) DEFAULT NULL,
  `agent` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `position` int(11) NOT NULL DEFAULT 1,
  KEY `idx_queue_agent` (`queue`,`agent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trusted` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `src_ip` varchar(50) NOT NULL,
  `proto` varchar(4) NOT NULL,
  `from_pattern` varchar(64) DEFAULT NULL,
  `tag` varchar(64) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `ruri_pattern` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `peer_idx` (`src_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_credentials` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `auth_username` varchar(64) NOT NULL,
  `did` varchar(64) NOT NULL DEFAULT '_default',
  `realm` varchar(64) NOT NULL,
  `password` varchar(28) NOT NULL DEFAULT '',
  `flags` int(11) NOT NULL DEFAULT 0,
  `ha1` varchar(32) NOT NULL,
  `ha1b` varchar(32) NOT NULL DEFAULT '',
  `uid` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cred_idx` (`auth_username`,`did`),
  KEY `uid` (`uid`),
  KEY `did_idx` (`did`),
  KEY `realm_idx` (`realm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_domain` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `did` varchar(64) NOT NULL,
  `DOMAIN` varchar(64) NOT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_idx` (`DOMAIN`),
  KEY `did_idx` (`did`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_domain_attrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `did` varchar(64) DEFAULT NULL,
  `name` varchar(32) NOT NULL,
  `TYPE` int(11) NOT NULL DEFAULT 0,
  `VALUE` varchar(128) DEFAULT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_attr_idx` (`did`,`name`,`VALUE`),
  KEY `domain_did` (`did`,`flags`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_global_attrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `TYPE` int(11) NOT NULL DEFAULT 0,
  `VALUE` varchar(128) DEFAULT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `global_attrs_idx` (`name`,`VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_uri` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(64) NOT NULL,
  `did` varchar(64) NOT NULL,
  `username` varchar(64) NOT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `scheme` varchar(8) NOT NULL DEFAULT 'sip',
  PRIMARY KEY (`id`),
  KEY `uri_idx1` (`username`,`did`,`scheme`),
  KEY `uri_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_uri_attrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `did` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `VALUE` varchar(128) DEFAULT NULL,
  `TYPE` int(11) NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `scheme` varchar(8) NOT NULL DEFAULT 'sip',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uriattrs_idx` (`username`,`did`,`name`,`VALUE`,`scheme`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uid_user_attrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `VALUE` varchar(128) DEFAULT NULL,
  `TYPE` int(11) NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userattrs_idx` (`uid`,`name`,`VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_preferences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) NOT NULL,
  `username` varchar(255) NOT NULL DEFAULT '0',
  `domain` varchar(64) NOT NULL DEFAULT '',
  `attribute` varchar(32) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT 0,
  `value` varchar(128) NOT NULL DEFAULT '',
  `last_modified` datetime NOT NULL DEFAULT '1900-01-01 00:00:01',
  PRIMARY KEY (`id`),
  KEY `ua_idx` (`uuid`,`attribute`),
  KEY `av_idx` (`attribute`,`value`),
  KEY `uda_idx` (`username`,`domain`,`attribute`,`value`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_subscriber_devices` AS SELECT
 1 AS `username`,
  1 AS `sub_username`,
  1 AS `domain`,
  1 AS `uuid`,
  1 AS `password`,
  1 AS `ha1`,
  1 AS `ha1b`,
  1 AS `is_devid`,
  1 AS `devid_alias` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version` (
  `table_name` varchar(32) NOT NULL,
  `table_version` int(10) unsigned NOT NULL DEFAULT 0,
  UNIQUE KEY `table_name_idx` (`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voicemail_spool` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `msgnum` int(11) NOT NULL DEFAULT 0,
  `dir` varchar(127) DEFAULT '',
  `context` varchar(63) DEFAULT '',
  `macrocontext` varchar(63) DEFAULT '',
  `callerid` varchar(255) DEFAULT '',
  `origtime` varchar(16) DEFAULT '',
  `duration` varchar(16) DEFAULT '',
  `mailboxuser` varchar(255) DEFAULT '',
  `mailboxcontext` varchar(63) DEFAULT '',
  `recording` longblob DEFAULT NULL,
  `flag` varchar(128) DEFAULT '',
  `msg_id` varchar(40) DEFAULT NULL,
  `call_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dir` (`dir`),
  KEY `mailboxuser_idx` (`mailboxuser`),
  KEY `callid_idx` (`call_id`),
  CONSTRAINT `v_s_mailboxuser_ref` FOREIGN KEY (`mailboxuser`) REFERENCES `voicemail_users` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voicemail_users` (
  `uniqueid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` char(36) NOT NULL DEFAULT '',
  `context` varchar(63) NOT NULL DEFAULT 'default',
  `mailbox` varchar(64) NOT NULL,
  `password` varchar(31) NOT NULL DEFAULT '0',
  `fullname` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `pager` varchar(255) NOT NULL DEFAULT '',
  `tz` varchar(10) NOT NULL DEFAULT 'central',
  `attach` varchar(4) NOT NULL DEFAULT 'yes',
  `saycid` varchar(4) NOT NULL DEFAULT 'yes',
  `dialout` varchar(10) NOT NULL DEFAULT '',
  `callback` varchar(10) NOT NULL DEFAULT '',
  `review` varchar(4) NOT NULL DEFAULT 'no',
  `operator` varchar(4) NOT NULL DEFAULT 'no',
  `envelope` varchar(4) NOT NULL DEFAULT 'no',
  `sayduration` varchar(4) NOT NULL DEFAULT 'no',
  `saydurationm` tinyint(4) NOT NULL DEFAULT 1,
  `sendvoicemail` varchar(4) NOT NULL DEFAULT 'no',
  `delete` varchar(4) NOT NULL DEFAULT 'no',
  `nextaftercmd` varchar(4) NOT NULL DEFAULT 'yes',
  `forcename` varchar(4) NOT NULL DEFAULT 'no',
  `forcegreetings` varchar(4) NOT NULL DEFAULT 'no',
  `hidefromdir` varchar(4) NOT NULL DEFAULT 'yes',
  `stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`uniqueid`),
  KEY `customer_idx` (`customer_id`),
  KEY `mailbox_context` (`mailbox`,`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `presentity_uri` varchar(255) NOT NULL,
  `watcher_username` varchar(64) NOT NULL,
  `watcher_domain` varchar(64) NOT NULL,
  `event` varchar(64) NOT NULL DEFAULT 'presence',
  `status` int(11) NOT NULL,
  `reason` varchar(64) DEFAULT NULL,
  `inserted_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `watcher_idx` (`presentity_uri`,`watcher_username`,`watcher_domain`,`event`),
  KEY `inserted_time_status_idx` (`inserted_time`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xcap` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `domain` varchar(64) NOT NULL,
  `doc` mediumblob NOT NULL,
  `doc_type` int(11) NOT NULL,
  `etag` varchar(128) NOT NULL,
  `source` int(11) NOT NULL,
  `doc_uri` varchar(255) NOT NULL,
  `port` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `doc_uri_idx` (`doc_uri`),
  KEY `account_doc_type_idx` (`username`,`domain`,`doc_type`),
  KEY `account_doc_type_uri_idx` (`username`,`domain`,`doc_type`,`doc_uri`),
  KEY `account_doc_uri_idx` (`username`,`domain`,`doc_uri`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50001 DROP VIEW IF EXISTS `v_subscriber_devices`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_subscriber_devices` AS select `s`.`username` AS `username`,`s`.`username` AS `sub_username`,`s`.`domain` AS `domain`,`s`.`uuid` AS `uuid`,`s`.`password` AS `password`,`s`.`ha1` AS `ha1`,`s`.`ha1b` AS `ha1b`,0 AS `is_devid`,NULL AS `devid_alias` from `subscriber` `s` union select `d`.`alias_username` AS `username`,`s`.`username` AS `sub_username`,`d`.`alias_domain` AS `domain`,`s`.`uuid` AS `uuid`,`s`.`password` AS `password`,`s`.`ha1` AS `ha1`,`s`.`ha1b` AS `ha1b`,`d`.`is_devid` AS `is_devid`,`d`.`devid_alias` AS `devid_alias` from (`subscriber` `s` join `dbaliases` `d` on(`d`.`username` = `s`.`username` and `d`.`domain` = `s`.`domain` and `d`.`is_devid` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
INSERT INTO `dispatcher` VALUES (1,2,'sip:127.0.0.1:5070',0,0,'','Voicemail servers');
INSERT INTO `dispatcher` VALUES (2,3,'sip:127.0.0.1:5080',0,0,'','Application servers');
INSERT INTO `dispatcher` VALUES (3,4,'sip:127.0.0.1:5090',0,0,'','Fax2Mail servers');
INSERT INTO `dispatcher` VALUES (4,5,'sip:127.0.0.1:5085',0,0,'','Cloud PBX servers');
INSERT INTO `dispatcher` VALUES (5,5,'sip:127.0.0.1:5085',0,0,'','Cloud PBX servers');
INSERT INTO `dom_preferences` VALUES (1,'','0','voip.sipwise.local','sst_enable',0,'no','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (2,'','0','voip.sipwise.local','sst_refresh_method',0,'UPDATE_FALLBACK_INVITE','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (3,'','0','voip.sipwise.local','use_rtpproxy',0,'ice_strip_candidates','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (6,'','0','voip.sipwise.local','ua_header_mode',0,'strip','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (7,'','0','voip.sipwise.local','ipv46_for_rtpproxy',0,'auto','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (8,'','0','voip.sipwise.local','force_outbound_calls_to_peer',0,'never','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (9,'','0','voip.sipwise.local','allowed_clis_reject_policy',0,'override_by_usernpn','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (10,'','0','voip.sipwise.local','extended_dialing_mode',0,'extended_send_dialed','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (11,'','0','voip.sipwise.local','outbound_to_user',0,'callee','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (12,'','0','voip.sipwise.local','language',0,'en','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (13,'','0','voip.sipwise.local','transport_protocol',0,'transparent','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (14,'','0','voip.sipwise.local','transport_protocol',0,'transparent','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (15,'','0','voip.sipwise.local','prepaid_library',0,'libswrate','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (16,'','0','voip.sipwise.local','call_deflection',0,'enabled','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (17,'','0','voip.sipwise.local','nat_sipping',0,'yes','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (18,'','0','voip.sipwise.local','skip_upn_check_on_diversion',0,'no','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (19,'','0','voip.sipwise.local','callrecording_type',0,'internal','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (20,'','0','voip.sipwise.local','support_auto_answer',0,'no','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (21,'','0','voip.sipwise.local','accept_auto_answer',0,'yes','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (22,'','0','voip.sipwise.local','rerouting_mode',0,'whitelist','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (23,'','0','voip.sipwise.local','force_inbound_calls_to_peer',0,'never','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (24,'','0','voip.sipwise.local','serial_forking_by_q_value',0,'no','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (25,'','0','voip.sipwise.local','emergency_upn',0,'npn','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (26,'','0','voip.sipwise.local','calllist_clir_scope',0,'external','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (27,'','0','voip.sipwise.local','play_announce_before_recording',0,'never','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (28,'','0','voip.sipwise.local','mobile_push_enable',0,'never','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (29,'','0','voip.sipwise.local','busy_hg_member_mode',0,'ring','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (30,'','0','voip.sipwise.local','announce_conn_type',0,'early','1900-01-01 00:00:01');
INSERT INTO `dom_preferences` VALUES (31,'','0','voip.sipwise.local','record_call',0,'0','1900-01-01 00:00:01');
INSERT INTO `domain` VALUES (1,'voip.sipwise.local','1900-01-01 00:00:01',NULL);
INSERT INTO `subscriber` VALUES (1,'no_such_number','voip.sipwise.local','65406773946e0e06a21c48bbee0cad84','7e7447b2649c71be4817126b42a3196c','6836376098d5c8a8298e8548a319dbb0','9bcb88b6-541a-43da-8fdc-816f5557ff93','','0000-00-00 00:00:00');
INSERT INTO `usr_preferences` VALUES (1,'9bcb88b6-541a-43da-8fdc-816f5557ff93','no_such_number','voip.sipwise.local','cloud_pbx_hunt_policy',0,'none','1900-01-01 00:00:01');
INSERT INTO `usr_preferences` VALUES (5,'9bcb88b6-541a-43da-8fdc-816f5557ff93','no_such_number','voip.sipwise.local','emergency_location_format',0,'cirpack','1900-01-01 00:00:01');
INSERT INTO `usr_preferences` VALUES (6,'9bcb88b6-541a-43da-8fdc-816f5557ff93','no_such_number','voip.sipwise.local','play_announce_before_recording',0,'never','1900-01-01 00:00:01');
INSERT INTO `version` VALUES ('acc',5);
INSERT INTO `version` VALUES ('acc_cdrs',2);
INSERT INTO `version` VALUES ('active_watchers',12);
INSERT INTO `version` VALUES ('address',6);
INSERT INTO `version` VALUES ('aliases',6);
INSERT INTO `version` VALUES ('dbaliases',1);
INSERT INTO `version` VALUES ('dialog',7);
INSERT INTO `version` VALUES ('dialog_vars',1);
INSERT INTO `version` VALUES ('dialplan',2);
INSERT INTO `version` VALUES ('dispatcher',4);
INSERT INTO `version` VALUES ('domain',2);
INSERT INTO `version` VALUES ('domain_attrs',1);
INSERT INTO `version` VALUES ('htable',2);
INSERT INTO `version` VALUES ('lcr_gw',3);
INSERT INTO `version` VALUES ('lcr_rule',3);
INSERT INTO `version` VALUES ('lcr_rule_target',1);
INSERT INTO `version` VALUES ('location',9);
INSERT INTO `version` VALUES ('location_attrs',1);
INSERT INTO `version` VALUES ('mohqcalls',1);
INSERT INTO `version` VALUES ('mohqueues',1);
INSERT INTO `version` VALUES ('presentity',5);
INSERT INTO `version` VALUES ('pua',7);
INSERT INTO `version` VALUES ('rls_presentity',1);
INSERT INTO `version` VALUES ('rls_watchers',3);
INSERT INTO `version` VALUES ('rtpproxy',1);
INSERT INTO `version` VALUES ('sca_subscriptions',2);
INSERT INTO `version` VALUES ('silo',8);
INSERT INTO `version` VALUES ('speed_dial',2);
INSERT INTO `version` VALUES ('subscriber',7);
INSERT INTO `version` VALUES ('trusted',6);
INSERT INTO `version` VALUES ('usr_preferences',2);
INSERT INTO `version` VALUES ('watchers',3);
INSERT INTO `version` VALUES ('xcap',4);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER cdr_presentity_insert_trig AFTER INSERT ON kamailio.presentity
FOR EACH ROW
BEGIN
    

    DECLARE _call_id VARCHAR(255);
    
    SET _call_id = (SELECT REPLACE(REPLACE(TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(NEW.body, 'CallID:([^\n\r]+)'), 'CallID:', '')), '\r', ''), '\n', ''));
    IF LENGTH(_call_id) > 0 AND NEW.event = 'vq-rtcpxr' THEN
        INSERT INTO accounting.cdr_presentity (call_id,event,received_time,body) VALUES (_call_id,NEW.event,NEW.received_time,NEW.body);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER cdr_presentity_update_trig AFTER UPDATE ON kamailio.presentity
FOR EACH ROW
BEGIN
    

    DECLARE _call_id VARCHAR(255);
    
    SET _call_id = (SELECT REPLACE(REPLACE(TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(NEW.body, 'CallID:([^\n\r]+)'), 'CallID:', '')), '\r', ''), '\n', ''));
    IF LENGTH(_call_id) > 0 AND NEW.event = 'vq-rtcpxr' THEN
        INSERT INTO accounting.cdr_presentity (call_id,event,received_time,body) VALUES (_call_id,NEW.event,NEW.received_time,NEW.body);
    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
COMMIT;
