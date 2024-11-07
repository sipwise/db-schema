SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE billing;
USE billing;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `_v_actual_effective_start_time` AS SELECT
 1 AS `contract_id`,
  1 AS `effective_start_time` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_role_mappings` (
  `accessor_id` int(11) unsigned NOT NULL,
  `has_access_to_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`accessor_id`,`has_access_to_id`),
  KEY `accessorid_idx` (`accessor_id`),
  KEY `hasaccesstoid_idx` (`has_access_to_id`),
  CONSTRAINT `arm_accessorid_ref` FOREIGN KEY (`accessor_id`) REFERENCES `acl_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `arm_hasaccessto_ref` FOREIGN KEY (`has_access_to_id`) REFERENCES `acl_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acl_roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `role` varchar(64) NOT NULL,
  `is_acl` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_idx` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_password_journal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) unsigned NOT NULL,
  `value` char(54) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `admin_created_idx` (`admin_id`,`created_at`),
  KEY `admin_value_idx` (`admin_id`,`value`),
  CONSTRAINT `admin_id_pass_j_fk` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admins` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `login` varchar(31) NOT NULL,
  `md5pass` char(32) DEFAULT NULL,
  `saltedpass` char(54) DEFAULT NULL,
  `is_master` tinyint(1) NOT NULL DEFAULT 0,
  `is_superuser` tinyint(1) NOT NULL DEFAULT 0,
  `is_ccare` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `read_only` tinyint(1) NOT NULL DEFAULT 0,
  `show_passwords` tinyint(1) NOT NULL DEFAULT 1,
  `call_data` tinyint(1) NOT NULL DEFAULT 0,
  `billing_data` tinyint(1) NOT NULL DEFAULT 1,
  `lawful_intercept` tinyint(1) NOT NULL DEFAULT 0,
  `ssl_client_m_serial` bigint(20) unsigned DEFAULT NULL,
  `ssl_client_certificate` text DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `can_reset_password` tinyint(1) NOT NULL DEFAULT 1,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `role_id` int(11) unsigned NOT NULL,
  `saltedpass_modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `ban_increment_stage` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_idx` (`login`),
  UNIQUE KEY `ssl_client_m_serial_UNIQUE` (`ssl_client_m_serial`),
  UNIQUE KEY `email` (`email`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `roleid_idx` (`role_id`),
  CONSTRAINT `a_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `a_roleid_ref` FOREIGN KEY (`role_id`) REFERENCES `acl_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_fees` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `billing_zone_id` int(11) unsigned DEFAULT NULL,
  `source` varchar(255) NOT NULL DEFAULT '.',
  `destination` varchar(255) NOT NULL,
  `direction` enum('in','out') NOT NULL DEFAULT 'out',
  `type` enum('call','sms') NOT NULL DEFAULT 'call',
  `onpeak_init_rate` double NOT NULL DEFAULT 0,
  `onpeak_init_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `onpeak_follow_rate` double NOT NULL DEFAULT 0,
  `onpeak_follow_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `offpeak_init_rate` double NOT NULL DEFAULT 0,
  `offpeak_init_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `offpeak_follow_rate` double NOT NULL DEFAULT 0,
  `offpeak_follow_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `onpeak_use_free_time` tinyint(1) NOT NULL DEFAULT 0,
  `match_mode` enum('regex_longest_pattern','regex_longest_match','prefix','exact_destination') NOT NULL DEFAULT 'regex_longest_pattern',
  `onpeak_extra_rate` double NOT NULL DEFAULT 0,
  `onpeak_extra_second` int(5) unsigned DEFAULT NULL,
  `offpeak_extra_rate` double NOT NULL DEFAULT 0,
  `offpeak_extra_second` int(5) unsigned DEFAULT NULL,
  `offpeak_use_free_time` tinyint(1) NOT NULL DEFAULT 0,
  `aoc_pulse_amount_per_message` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bf_srcdestdir_idx` (`billing_profile_id`,`type`,`match_mode`,`direction`,`source`,`destination`),
  KEY `profileid_idx` (`billing_profile_id`),
  KEY `zoneid_idx` (`billing_zone_id`),
  KEY `showfeesc_idx` (`billing_profile_id`,`billing_zone_id`,`destination`),
  KEY `bf_destsrcdir_idx` (`billing_profile_id`,`type`,`match_mode`,`destination`,`source`,`direction`),
  CONSTRAINT `b_f_bilprofid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `b_f_zoneid_ref` FOREIGN KEY (`billing_zone_id`) REFERENCES `billing_zones` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_fees_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bf_id` int(11) unsigned DEFAULT NULL,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `billing_zones_history_id` int(11) unsigned DEFAULT NULL,
  `source` varchar(255) NOT NULL DEFAULT '.',
  `destination` varchar(255) NOT NULL,
  `direction` enum('in','out') NOT NULL DEFAULT 'out',
  `type` enum('call','sms') NOT NULL DEFAULT 'call',
  `onpeak_init_rate` double NOT NULL DEFAULT 0,
  `onpeak_init_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `onpeak_follow_rate` double NOT NULL DEFAULT 0,
  `onpeak_follow_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `offpeak_init_rate` double NOT NULL DEFAULT 0,
  `offpeak_init_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `offpeak_follow_rate` double NOT NULL DEFAULT 0,
  `offpeak_follow_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `onpeak_use_free_time` tinyint(1) NOT NULL DEFAULT 0,
  `match_mode` enum('regex_longest_pattern','regex_longest_match','prefix','exact_destination') NOT NULL DEFAULT 'regex_longest_pattern',
  `onpeak_extra_rate` double NOT NULL DEFAULT 0,
  `onpeak_extra_second` int(5) unsigned DEFAULT NULL,
  `offpeak_extra_rate` double NOT NULL DEFAULT 0,
  `offpeak_extra_second` int(5) unsigned DEFAULT NULL,
  `offpeak_use_free_time` tinyint(1) NOT NULL DEFAULT 0,
  `aoc_pulse_amount_per_message` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `bfid_idx` (`bf_id`),
  KEY `zonehid_idx` (`billing_zones_history_id`),
  KEY `bfhdir_idx` (`direction`),
  KEY `bfh_srcdestdir_idx` (`billing_profile_id`,`type`,`match_mode`,`direction`,`bf_id`,`source`,`destination`),
  KEY `bfh_destsrcdir_idx` (`billing_profile_id`,`type`,`match_mode`,`destination`,`bf_id`,`source`,`direction`),
  CONSTRAINT `b_f_h_bfid_ref` FOREIGN KEY (`bf_id`) REFERENCES `billing_fees` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `b_f_h_bzhid_ref` FOREIGN KEY (`billing_zones_history_id`) REFERENCES `billing_zones_history` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_fees_raw` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `billing_zone_id` int(11) unsigned DEFAULT NULL,
  `source` varchar(255) NOT NULL DEFAULT '.',
  `destination` varchar(255) NOT NULL,
  `direction` enum('in','out') NOT NULL DEFAULT 'out',
  `type` enum('call','sms') NOT NULL DEFAULT 'call',
  `onpeak_init_rate` double NOT NULL DEFAULT 0,
  `onpeak_init_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `onpeak_follow_rate` double NOT NULL DEFAULT 0,
  `onpeak_follow_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `offpeak_init_rate` double NOT NULL DEFAULT 0,
  `offpeak_init_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `offpeak_follow_rate` double NOT NULL DEFAULT 0,
  `offpeak_follow_interval` int(5) unsigned NOT NULL DEFAULT 0,
  `onpeak_use_free_time` tinyint(1) NOT NULL DEFAULT 0,
  `match_mode` enum('regex_longest_pattern','regex_longest_match','prefix','exact_destination') NOT NULL DEFAULT 'regex_longest_pattern',
  `onpeak_extra_rate` double NOT NULL DEFAULT 0,
  `onpeak_extra_second` int(5) unsigned DEFAULT NULL,
  `offpeak_extra_rate` double NOT NULL DEFAULT 0,
  `offpeak_extra_second` int(5) unsigned DEFAULT NULL,
  `offpeak_use_free_time` tinyint(1) NOT NULL DEFAULT 0,
  `aoc_pulse_amount_per_message` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `profileid_idx` (`billing_profile_id`),
  KEY `zoneid_idx` (`billing_zone_id`),
  KEY `showfeesc_idx` (`billing_profile_id`,`billing_zone_id`,`destination`),
  KEY `bfr_destsrcdir_idx` (`billing_profile_id`,`type`,`match_mode`,`destination`,`source`,`direction`),
  KEY `bfr_srcdestdir_idx` (`billing_profile_id`,`type`,`match_mode`,`direction`,`source`,`destination`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_mappings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `billing_profile_id` int(11) unsigned DEFAULT NULL,
  `contract_id` int(11) unsigned NOT NULL,
  `product_id` int(11) unsigned DEFAULT NULL,
  `network_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profileid_idx` (`billing_profile_id`),
  KEY `contractid_idx` (`contract_id`),
  KEY `productid_idx` (`product_id`),
  KEY `billing_mappings_start_date` (`start_date`),
  KEY `bm_network_ref` (`network_id`),
  CONSTRAINT `b_m_bilprofid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `b_m_contractid_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `b_m_productid_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `bm_network_ref` FOREIGN KEY (`network_id`) REFERENCES `billing_networks` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_network_blocks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `network_id` int(11) unsigned NOT NULL,
  `ip` varchar(39) NOT NULL,
  `mask` tinyint(1) unsigned DEFAULT NULL,
  `_ipv4_net_from` varbinary(4) DEFAULT NULL,
  `_ipv4_net_to` varbinary(4) DEFAULT NULL,
  `_ipv6_net_from` varbinary(16) DEFAULT NULL,
  `_ipv6_net_to` varbinary(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bnb_ipv4_from_idx` (`_ipv4_net_from`),
  KEY `bnb_ipv4_to_idx` (`_ipv4_net_to`),
  KEY `bnb_ipv6_from_idx` (`_ipv6_net_from`),
  KEY `bnb_ipv6_to_idx` (`_ipv6_net_to`),
  KEY `bnb_network_ref` (`network_id`),
  CONSTRAINT `bnb_network_ref` FOREIGN KEY (`network_id`) REFERENCES `billing_networks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_networks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `status` enum('active','terminated') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bn_resname_idx` (`reseller_id`,`name`),
  CONSTRAINT `bn_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_peaktime_special` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profileid_idx` (`billing_profile_id`),
  CONSTRAINT `b_p_s_bilprofid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_peaktime_weekdays` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `weekday` tinyint(3) unsigned NOT NULL,
  `start` time DEFAULT NULL,
  `end` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `profileid_idx` (`billing_profile_id`),
  CONSTRAINT `b_p_w_bilprofid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_profiles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `handle` varchar(63) NOT NULL,
  `name` varchar(31) NOT NULL,
  `prepaid` tinyint(1) NOT NULL DEFAULT 0,
  `interval_charge` double NOT NULL DEFAULT 0,
  `interval_free_time` int(5) NOT NULL DEFAULT 0,
  `interval_free_cash` double NOT NULL DEFAULT 0,
  `interval_unit` enum('week','month') NOT NULL DEFAULT 'month',
  `interval_count` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `fraud_interval_limit` int(11) unsigned DEFAULT NULL,
  `fraud_interval_lock` tinyint(3) unsigned DEFAULT NULL,
  `fraud_interval_notify` varchar(255) DEFAULT NULL,
  `fraud_daily_limit` int(11) unsigned DEFAULT NULL,
  `fraud_daily_lock` tinyint(3) unsigned DEFAULT NULL,
  `fraud_daily_notify` varchar(255) DEFAULT NULL,
  `fraud_use_reseller_rates` tinyint(3) unsigned DEFAULT 0,
  `currency` varchar(31) DEFAULT NULL,
  `status` enum('active','terminated') NOT NULL DEFAULT 'active',
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `terminate_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `advice_of_charge` tinyint(1) NOT NULL DEFAULT 0,
  `prepaid_library` enum('libswrate','libinewrate') NOT NULL DEFAULT 'libswrate',
  `ignore_domain` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resnam_idx` (`reseller_id`,`name`,`terminate_timestamp`),
  UNIQUE KEY `reshand_idx` (`reseller_id`,`handle`,`terminate_timestamp`),
  KEY `resellerid_idx` (`reseller_id`),
  CONSTRAINT `b_p_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_zones` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `zone` varchar(127) NOT NULL,
  `detail` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profnamdes_idx` (`billing_profile_id`,`zone`,`detail`),
  CONSTRAINT `b_z_profileid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billing_zones_history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bz_id` int(11) unsigned DEFAULT NULL,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `zone` varchar(127) NOT NULL,
  `detail` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bzid_idx` (`bz_id`),
  CONSTRAINT `b_z_h_bzid_ref` FOREIGN KEY (`bz_id`) REFERENCES `billing_zones` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `call_list_suppressions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) NOT NULL DEFAULT '',
  `pattern` varchar(255) NOT NULL DEFAULT '.',
  `label` varchar(255) NOT NULL DEFAULT 'obfuscated',
  `direction` enum('outgoing','incoming') NOT NULL DEFAULT 'outgoing',
  `mode` enum('disabled','filter','obfuscate') NOT NULL DEFAULT 'disabled',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cls_domain_direction_pattern_idx` (`domain`,`direction`,`pattern`),
  KEY `cls_direction_mode_domain_idx` (`direction`,`mode`,`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `gender` enum('male','female') DEFAULT NULL,
  `firstname` varchar(127) DEFAULT NULL,
  `lastname` varchar(127) DEFAULT NULL,
  `comregnum` varchar(31) DEFAULT NULL,
  `company` varchar(127) DEFAULT NULL,
  `street` varchar(127) DEFAULT NULL,
  `postcode` varchar(16) DEFAULT NULL,
  `city` varchar(127) DEFAULT NULL,
  `country` char(2) DEFAULT NULL,
  `phonenumber` varchar(31) DEFAULT NULL,
  `mobilenumber` varchar(31) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `newsletter` tinyint(1) NOT NULL DEFAULT 0,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `faxnumber` varchar(31) DEFAULT NULL,
  `iban` varchar(34) DEFAULT NULL,
  `bic` varchar(11) DEFAULT NULL,
  `vatnum` varchar(127) DEFAULT NULL,
  `bankname` varchar(255) DEFAULT NULL,
  `gpp0` varchar(255) DEFAULT NULL,
  `gpp1` varchar(255) DEFAULT NULL,
  `gpp2` varchar(255) DEFAULT NULL,
  `gpp3` varchar(255) DEFAULT NULL,
  `gpp4` varchar(255) DEFAULT NULL,
  `gpp5` varchar(255) DEFAULT NULL,
  `gpp6` varchar(255) DEFAULT NULL,
  `gpp7` varchar(255) DEFAULT NULL,
  `gpp8` varchar(255) DEFAULT NULL,
  `gpp9` varchar(255) DEFAULT NULL,
  `status` enum('active','terminated') NOT NULL DEFAULT 'active',
  `terminate_timestamp` timestamp NULL DEFAULT NULL,
  `timezone` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ct_resellerid_ref` (`reseller_id`),
  KEY `email_idx` (`email`),
  CONSTRAINT `ct_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_balances` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `cash_balance` double DEFAULT NULL,
  `cash_balance_interval` double NOT NULL DEFAULT 0,
  `free_time_balance` int(11) DEFAULT NULL,
  `free_time_balance_interval` int(11) NOT NULL DEFAULT 0,
  `topup_count` int(3) unsigned NOT NULL DEFAULT 0,
  `timely_topup_count` int(3) unsigned NOT NULL DEFAULT 0,
  `start` datetime NOT NULL,
  `end` datetime NOT NULL,
  `invoice_id` int(11) unsigned DEFAULT NULL,
  `underrun_profiles` datetime DEFAULT NULL,
  `underrun_lock` datetime DEFAULT NULL,
  `initial_cash_balance` double DEFAULT NULL,
  `initial_free_time_balance` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `balance_interval` (`contract_id`,`start`,`end`),
  KEY `invoiceid_idx` (`invoice_id`),
  CONSTRAINT `c_b_contractid_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cb_invoiceid_ref` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_credits` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `balance_id` int(11) unsigned NOT NULL,
  `state` enum('init','transact','charged','failed','success') NOT NULL DEFAULT 'init',
  `amount` double DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `balanceid_idx` (`balance_id`),
  CONSTRAINT `cc_balanceid_ref` FOREIGN KEY (`balance_id`) REFERENCES `contract_balances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_fraud_preferences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `fraud_interval_limit` int(11) unsigned DEFAULT NULL,
  `fraud_interval_lock` tinyint(3) unsigned DEFAULT NULL,
  `fraud_interval_notify` varchar(255) DEFAULT NULL,
  `fraud_daily_limit` int(11) unsigned DEFAULT NULL,
  `fraud_daily_lock` tinyint(3) unsigned DEFAULT NULL,
  `fraud_daily_notify` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_id` (`contract_id`),
  CONSTRAINT `contract_id_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_phonebook` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `number` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rel_u_idx` (`contract_id`,`number`),
  KEY `name_idx` (`name`),
  KEY `number_idx` (`number`),
  CONSTRAINT `pb_contract_id_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_registers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `actor` varchar(15) DEFAULT NULL,
  `type` varchar(31) NOT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contractid_idx` (`contract_id`),
  CONSTRAINT `c_r_contractid_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contracts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `contact_id` int(11) unsigned DEFAULT NULL,
  `order_id` int(11) unsigned DEFAULT NULL,
  `profile_package_id` int(11) unsigned DEFAULT NULL,
  `status` enum('pending','active','locked','terminated') NOT NULL DEFAULT 'active',
  `external_id` varchar(255) DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `activate_timestamp` timestamp NULL DEFAULT NULL,
  `terminate_timestamp` timestamp NULL DEFAULT NULL,
  `max_subscribers` int(6) unsigned DEFAULT NULL,
  `send_invoice` tinyint(1) NOT NULL DEFAULT 1,
  `subscriber_email_template_id` int(11) unsigned DEFAULT NULL,
  `passreset_email_template_id` int(11) unsigned DEFAULT NULL,
  `invoice_email_template_id` int(11) unsigned DEFAULT NULL,
  `invoice_template_id` int(11) unsigned DEFAULT NULL,
  `vat_rate` decimal(14,6) NOT NULL DEFAULT 0.000000,
  `add_vat` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `product_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contactid_idx` (`contact_id`),
  KEY `customerid_idx` (`customer_id`),
  KEY `orderid_idx` (`order_id`),
  KEY `externalid_idx` (`external_id`),
  KEY `c_package_ref` (`profile_package_id`),
  KEY `c_productid_ref` (`product_id`),
  CONSTRAINT `c_customerid_ref` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `c_package_ref` FOREIGN KEY (`profile_package_id`) REFERENCES `profile_packages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `c_productid_ref` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `co_contactid_ref` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `co_orderid_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contracts_billing_profile_network` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `billing_profile_id` int(11) unsigned NOT NULL,
  `billing_network_id` int(11) unsigned DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `base` tinyint(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cbpn_natural_idx` (`contract_id`,`billing_profile_id`,`billing_network_id`,`start_date`,`end_date`,`base`),
  KEY `cbpn_pid_ref` (`billing_profile_id`),
  KEY `cbpn_nid_ref` (`billing_network_id`),
  CONSTRAINT `cbpn_cid_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cbpn_nid_ref` FOREIGN KEY (`billing_network_id`) REFERENCES `billing_networks` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `cbpn_pid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contracts_billing_profile_network_schedule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `profile_network_id` int(11) unsigned NOT NULL,
  `effective_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cbpns_pnid_est_idx` (`profile_network_id`,`effective_start_time`),
  CONSTRAINT `cbpns_cbpnid_ref` FOREIGN KEY (`profile_network_id`) REFERENCES `contracts_billing_profile_network` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credit_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `credit_id` int(11) unsigned NOT NULL,
  `payment_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `creditid_idx` (`credit_id`),
  KEY `paymentid_idx` (`payment_id`),
  CONSTRAINT `cp_creditid_ref` FOREIGN KEY (`credit_id`) REFERENCES `contract_credits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cp_paymentid_ref` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_registers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) unsigned NOT NULL,
  `actor` varchar(15) DEFAULT NULL,
  `type` varchar(31) NOT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customerid_idx` (`customer_id`),
  CONSTRAINT `c_r_customerid_ref` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `shopuser` varchar(31) DEFAULT NULL,
  `shoppass` varchar(31) DEFAULT NULL,
  `business` tinyint(1) NOT NULL DEFAULT 0,
  `contact_id` int(11) unsigned DEFAULT NULL,
  `tech_contact_id` int(11) unsigned DEFAULT NULL,
  `comm_contact_id` int(11) unsigned DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reseller_id` (`reseller_id`,`shopuser`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `contactid_idx` (`contact_id`),
  KEY `commcontactid_idx` (`comm_contact_id`),
  KEY `techcontact_idx` (`tech_contact_id`),
  KEY `externalid_idx` (`external_id`),
  CONSTRAINT `cu_commcontactid_ref` FOREIGN KEY (`comm_contact_id`) REFERENCES `contacts` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `cu_contactid_ref` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `cu_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `cu_techcontact_ref` FOREIGN KEY (`tech_contact_id`) REFERENCES `contacts` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain_resellers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) unsigned NOT NULL,
  `reseller_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `domainid_idx` (`domain_id`),
  KEY `resellerid_idx` (`reseller_id`),
  CONSTRAINT `dr_domainid_ref` FOREIGN KEY (`domain_id`) REFERENCES `domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dr_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domains` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(127) NOT NULL,
  `reseller_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain_idx` (`domain`),
  KEY `resellerid_idx` (`reseller_id`),
  CONSTRAINT `d_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `from_email` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` mediumtext NOT NULL,
  `attachment_name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `reseller_name_idx` (`reseller_id`,`name`),
  CONSTRAINT `fk_email_reseller` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `type` enum('svg','html') NOT NULL DEFAULT 'svg',
  `data` mediumblob DEFAULT NULL,
  `call_direction` enum('in','out','in_out') NOT NULL DEFAULT 'out',
  `category` enum('customer','peer','reseller','did') NOT NULL DEFAULT 'customer',
  PRIMARY KEY (`id`),
  KEY `invoice_templates_ibfk_1` (`reseller_id`),
  CONSTRAINT `invoice_templates_ibfk_1` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `serial` varchar(32) NOT NULL,
  `period_start` datetime NOT NULL,
  `period_end` datetime NOT NULL,
  `amount_net` double NOT NULL DEFAULT 0,
  `amount_vat` double NOT NULL DEFAULT 0,
  `amount_total` double NOT NULL DEFAULT 0,
  `data` longblob DEFAULT NULL,
  `sent_date` datetime DEFAULT NULL,
  `generator` enum('auto','web') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_idx` (`serial`),
  KEY `invoice_contract_fk` (`contract_id`),
  CONSTRAINT `invoice_contract_fk` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `journals` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `operation` enum('create','update','delete') NOT NULL DEFAULT 'create',
  `resource_name` varchar(64) NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `timestamp` decimal(13,3) NOT NULL,
  `username` varchar(127) DEFAULT NULL,
  `content_format` enum('storable','json','json_deflate','sereal') NOT NULL DEFAULT 'json',
  `content` longblob DEFAULT NULL,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `tx_id` varchar(36) DEFAULT NULL,
  `role_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `res_idx` (`resource_name`,`resource_id`),
  KEY `ts_idx` (`timestamp`),
  KEY `op_idx` (`operation`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `userid_idx` (`user_id`),
  KEY `roleid_idx` (`role_id`),
  KEY `txid_idx` (`tx_id`),
  CONSTRAINT `j_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`),
  CONSTRAINT `j_roleid_ref` FOREIGN KEY (`role_id`) REFERENCES `acl_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnp_numbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(31) NOT NULL,
  `routing_number` varchar(31) DEFAULT NULL,
  `lnp_provider_id` int(11) unsigned NOT NULL,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `number_idx` (`number`),
  KEY `l_n_lnpproid_ref` (`lnp_provider_id`),
  KEY `l_n_start_idx` (`start`),
  CONSTRAINT `l_n_lnpproid_ref` FOREIGN KEY (`lnp_provider_id`) REFERENCES `lnp_providers` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lnp_providers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `prefix` varchar(32) NOT NULL DEFAULT '',
  `authoritative` tinyint(1) NOT NULL DEFAULT 0,
  `skip_rewrite` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ncos_levels` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `level` varchar(31) NOT NULL,
  `mode` enum('blacklist','whitelist') NOT NULL DEFAULT 'blacklist',
  `local_ac` tinyint(1) NOT NULL DEFAULT 0,
  `intra_pbx` tinyint(1) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `time_set_id` int(11) unsigned DEFAULT NULL,
  `expose_to_customer` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reslev_idx` (`reseller_id`,`level`),
  KEY `nl_time_set_id_idx` (`time_set_id`),
  KEY `expose_to_customer_idx` (`expose_to_customer`),
  CONSTRAINT `c_l_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `nl_time_set_id_ref` FOREIGN KEY (`time_set_id`) REFERENCES `provisioning`.`voip_time_sets` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ncos_lnp_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ncos_level_id` int(11) unsigned NOT NULL,
  `lnp_provider_id` int(11) unsigned NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `levpro_idx` (`ncos_level_id`,`lnp_provider_id`),
  KEY `c_l_l_lnpproid_ref` (`lnp_provider_id`),
  CONSTRAINT `c_l_l_lnpproid_ref` FOREIGN KEY (`lnp_provider_id`) REFERENCES `lnp_providers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `c_l_l_ncoslevid_ref` FOREIGN KEY (`ncos_level_id`) REFERENCES `ncos_levels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ncos_lnp_pattern_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ncos_lnp_list_id` int(11) unsigned NOT NULL,
  `pattern` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `listpat_idx` (`ncos_lnp_list_id`,`pattern`),
  CONSTRAINT `c_p_l_ncoslnplist_ref` FOREIGN KEY (`ncos_lnp_list_id`) REFERENCES `ncos_lnp_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ncos_pattern_list` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ncos_level_id` int(11) unsigned NOT NULL,
  `pattern` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `levpat_idx` (`ncos_level_id`,`pattern`),
  CONSTRAINT `c_p_l_ncoslevid_ref` FOREIGN KEY (`ncos_level_id`) REFERENCES `ncos_levels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ncos_set_levels` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ncos_set_id` int(11) unsigned NOT NULL,
  `ncos_level_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `set_level_idx` (`ncos_set_id`,`ncos_level_id`),
  KEY `nlm_ncos_level_id_idx` (`ncos_level_id`),
  CONSTRAINT `nlm_ncos_level_id_ref` FOREIGN KEY (`ncos_level_id`) REFERENCES `ncos_levels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `nlm_ncos_set_id_ref` FOREIGN KEY (`ncos_set_id`) REFERENCES `ncos_sets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ncos_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `expose_to_customer` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resname_idx` (`reseller_id`,`name`),
  KEY `expose_to_customer_idx` (`expose_to_customer`),
  CONSTRAINT `n_c_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(11) unsigned NOT NULL,
  `payment_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `orderid_idx` (`order_id`),
  KEY `paymentid_idx` (`payment_id`),
  CONSTRAINT `op_orderid_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `op_paymentid_ref` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `delivery_contact_id` int(11) unsigned DEFAULT NULL,
  `type` varchar(31) DEFAULT NULL,
  `state` enum('init','transact','failed','success') NOT NULL DEFAULT 'init',
  `value` int(11) DEFAULT NULL,
  `shipping_costs` int(11) DEFAULT NULL,
  `invoice_id` int(11) unsigned DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `complete_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `customerid_idx` (`customer_id`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `contactid_idx` (`delivery_contact_id`),
  KEY `invoiceid_idx` (`invoice_id`),
  CONSTRAINT `o_contactid_ref` FOREIGN KEY (`delivery_contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `o_customerid_ref` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `o_invoiceid_ref` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `o_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package_profile_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `package_id` int(11) unsigned NOT NULL,
  `discriminator` enum('initial','underrun','topup') NOT NULL,
  `profile_id` int(11) unsigned NOT NULL,
  `network_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pps_packdiscr_idx` (`package_id`,`discriminator`),
  KEY `pps_profile_ref` (`profile_id`),
  KEY `pps_network_ref` (`network_id`),
  CONSTRAINT `pps_network_ref` FOREIGN KEY (`network_id`) REFERENCES `billing_networks` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `pps_package_ref` FOREIGN KEY (`package_id`) REFERENCES `profile_packages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pps_profile_ref` FOREIGN KEY (`profile_id`) REFERENCES `billing_profiles` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `uuid` char(36) NOT NULL,
  `timestamp` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uuid_idx` (`uuid`),
  KEY `fk_pwd_reset_sub` (`subscriber_id`),
  CONSTRAINT `fk_pwd_reset_sub` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `amount` int(11) DEFAULT NULL,
  `type` varchar(31) DEFAULT NULL,
  `state` enum('init','transact','failed','success') DEFAULT NULL,
  `mpaytid` int(11) unsigned DEFAULT NULL,
  `status` varchar(31) DEFAULT NULL,
  `errno` int(11) DEFAULT NULL,
  `returncode` varchar(63) DEFAULT NULL,
  `externalstatus` text DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `state_idx` (`state`),
  KEY `mpaytid_idx` (`mpaytid`),
  KEY `status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `class` enum('sippeering','pstnpeering','reseller','sipaccount','pbxaccount') NOT NULL,
  `handle` varchar(63) NOT NULL,
  `name` varchar(127) NOT NULL,
  `on_sale` tinyint(1) NOT NULL DEFAULT 0,
  `price` double DEFAULT NULL,
  `weight` mediumint(9) unsigned DEFAULT NULL,
  `billing_profile_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resnam_idx` (`reseller_id`,`name`),
  UNIQUE KEY `reshand_idx` (`reseller_id`,`handle`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `profileid_idx` (`billing_profile_id`),
  CONSTRAINT `p_bilprofid_ref` FOREIGN KEY (`billing_profile_id`) REFERENCES `billing_profiles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `p_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_packages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `initial_balance` double NOT NULL DEFAULT 0,
  `service_charge` double NOT NULL DEFAULT 0,
  `balance_interval_unit` enum('minute','hour','day','week','month') NOT NULL DEFAULT 'month',
  `balance_interval_value` int(3) unsigned NOT NULL DEFAULT 1,
  `balance_interval_start_mode` enum('create','create_tz','1st','1st_tz','topup','topup_interval') NOT NULL DEFAULT '1st',
  `carry_over_mode` enum('carry_over','carry_over_timely','discard') NOT NULL DEFAULT 'carry_over',
  `timely_duration_unit` enum('minute','hour','day','week','month') DEFAULT NULL,
  `timely_duration_value` int(3) unsigned DEFAULT NULL,
  `notopup_discard_intervals` int(3) unsigned DEFAULT NULL,
  `underrun_lock_threshold` double DEFAULT NULL,
  `underrun_lock_level` tinyint(3) DEFAULT NULL,
  `underrun_profile_threshold` double DEFAULT NULL,
  `topup_lock_level` tinyint(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pp_resname_idx` (`reseller_id`,`name`),
  CONSTRAINT `pp_reseller_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provisioning_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `lang` enum('perl','js') NOT NULL DEFAULT 'js',
  `yaml` text NOT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `resnam_idx` (`reseller_id`,`name`),
  CONSTRAINT `p_t_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reseller_brandings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `css` mediumtext DEFAULT NULL,
  `logo` mediumblob DEFAULT NULL,
  `logo_image_type` varchar(32) DEFAULT NULL,
  `csc_color_primary` varchar(45) DEFAULT NULL,
  `csc_color_secondary` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reseller_idx` (`reseller_id`),
  CONSTRAINT `branding_reseller_fk` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reseller_phonebook` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `number` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rel_u_idx` (`reseller_id`,`number`),
  KEY `name_idx` (`name`),
  KEY `number_idx` (`number`),
  CONSTRAINT `pb_reseller_id_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resellers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `name` varchar(63) NOT NULL,
  `status` enum('active','locked','terminated') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `contractid_idx` (`contract_id`),
  UNIQUE KEY `name_idx` (`name`),
  CONSTRAINT `r_contractid_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriber_phonebook` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `subscriber_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `number` varchar(255) NOT NULL,
  `shared` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rel_u_idx` (`subscriber_id`,`number`),
  KEY `name_idx` (`name`),
  KEY `number_idx` (`number`),
  CONSTRAINT `pb_subscriber_id_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topup_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(127) DEFAULT NULL,
  `timestamp` decimal(13,3) NOT NULL,
  `type` enum('cash','voucher','set_balance') NOT NULL,
  `outcome` enum('ok','failed') NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `contract_id` int(11) unsigned DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `voucher_id` int(11) unsigned DEFAULT NULL,
  `cash_balance_before` double DEFAULT NULL,
  `cash_balance_after` double DEFAULT NULL,
  `package_before_id` int(11) unsigned DEFAULT NULL,
  `package_after_id` int(11) unsigned DEFAULT NULL,
  `profile_before_id` int(11) unsigned DEFAULT NULL,
  `profile_after_id` int(11) unsigned DEFAULT NULL,
  `lock_level_before` tinyint(3) DEFAULT NULL,
  `lock_level_after` tinyint(3) DEFAULT NULL,
  `contract_balance_before_id` int(11) unsigned DEFAULT NULL,
  `contract_balance_after_id` int(11) unsigned DEFAULT NULL,
  `request_token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tl_requesttoken_idx` (`request_token`),
  KEY `tl_timestamp_idx` (`timestamp`),
  KEY `tl_subscriber_ref` (`subscriber_id`),
  KEY `tl_contract_ref` (`contract_id`),
  KEY `tl_voucher_ref` (`voucher_id`),
  KEY `tl_package_before_ref` (`package_before_id`),
  KEY `tl_package_after_ref` (`package_after_id`),
  KEY `tl_profile_before_ref` (`profile_before_id`),
  KEY `tl_profile_after_ref` (`profile_after_id`),
  KEY `tl_balance_before_ref` (`contract_balance_before_id`),
  KEY `tl_balance_after_ref` (`contract_balance_after_id`),
  CONSTRAINT `tl_balance_after_ref` FOREIGN KEY (`contract_balance_after_id`) REFERENCES `contract_balances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_balance_before_ref` FOREIGN KEY (`contract_balance_before_id`) REFERENCES `contract_balances` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_contract_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_package_after_ref` FOREIGN KEY (`package_after_id`) REFERENCES `profile_packages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_package_before_ref` FOREIGN KEY (`package_before_id`) REFERENCES `profile_packages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_profile_after_ref` FOREIGN KEY (`profile_after_id`) REFERENCES `billing_profiles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_profile_before_ref` FOREIGN KEY (`profile_before_id`) REFERENCES `billing_profiles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_subscriber_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tl_voucher_ref` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_actual_billing_profiles` AS SELECT
 1 AS `contract_id`,
  1 AS `billing_profile_id` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_contract_billing_profile_network_schedules` AS SELECT
 1 AS `id`,
  1 AS `contract_id`,
  1 AS `start_date`,
  1 AS `end_date`,
  1 AS `billing_profile_id`,
  1 AS `network_id`,
  1 AS `effective_start_time`,
  1 AS `effective_start_date`,
  1 AS `billing_profile_name`,
  1 AS `billing_profile_handle`,
  1 AS `billing_network_name` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_contract_timezone` AS SELECT
 1 AS `contact_id`,
  1 AS `contract_id`,
  1 AS `name` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_reseller_timezone` AS SELECT
 1 AS `contact_id`,
  1 AS `reseller_id`,
  1 AS `name` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_subscriber_timezone` AS SELECT
 1 AS `contact_id`,
  1 AS `subscriber_id`,
  1 AS `uuid`,
  1 AS `name` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_intercept` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `LIID` int(11) unsigned DEFAULT NULL,
  `number` varchar(63) DEFAULT NULL,
  `cc_required` tinyint(1) NOT NULL DEFAULT 0,
  `delivery_host` varchar(15) DEFAULT NULL,
  `delivery_port` smallint(5) unsigned DEFAULT NULL,
  `delivery_user` text DEFAULT NULL,
  `delivery_pass` text DEFAULT NULL,
  `modify_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_timestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `uuid` varchar(255) DEFAULT NULL,
  `sip_username` varchar(255) DEFAULT NULL,
  `sip_domain` varchar(255) DEFAULT NULL,
  `cc_delivery_host` varchar(64) DEFAULT NULL,
  `cc_delivery_port` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `number_idx` (`number`),
  KEY `deleted_idx` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_number_block_resellers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `number_block_id` int(11) unsigned NOT NULL,
  `reseller_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `numblockid_idx` (`number_block_id`),
  KEY `resellerid_idx` (`reseller_id`),
  CONSTRAINT `vnbr_numblockid_ref` FOREIGN KEY (`number_block_id`) REFERENCES `voip_number_blocks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vnbr_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_number_blocks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cc` int(4) unsigned NOT NULL,
  `ac` varchar(7) NOT NULL,
  `sn_prefix` varchar(31) NOT NULL,
  `sn_length` tinyint(2) unsigned NOT NULL,
  `allocable` tinyint(1) NOT NULL DEFAULT 0,
  `authoritative` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prefix_idx` (`cc`,`ac`,`sn_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_numbers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cc` int(4) unsigned NOT NULL,
  `ac` varchar(7) NOT NULL,
  `sn` varchar(31) NOT NULL,
  `reseller_id` int(11) unsigned DEFAULT NULL,
  `subscriber_id` int(11) unsigned DEFAULT NULL,
  `status` enum('active','reserved','locked','deported') NOT NULL DEFAULT 'active',
  `ported` tinyint(1) NOT NULL DEFAULT 0,
  `list_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `number_idx` (`cc`,`ac`,`sn`),
  KEY `listts_idx` (`list_timestamp`),
  KEY `resellerid_idx` (`reseller_id`),
  KEY `subscriberid_idx` (`subscriber_id`),
  CONSTRAINT `v_n_resellerid_ref` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `v_n_subscriberid_ref` FOREIGN KEY (`subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voip_subscribers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `uuid` char(36) NOT NULL,
  `username` varchar(127) NOT NULL,
  `domain_id` int(11) unsigned NOT NULL,
  `status` enum('active','locked','terminated') NOT NULL DEFAULT 'active',
  `primary_number_id` int(11) unsigned DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `contact_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `username_idx` (`username`),
  KEY `contractid_idx` (`contract_id`),
  KEY `domainid_idx` (`domain_id`),
  KEY `pnumid_idx` (`primary_number_id`),
  KEY `externalid_idx` (`external_id`),
  CONSTRAINT `v_s_contractid_ref` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_s_domainid_ref` FOREIGN KEY (`domain_id`) REFERENCES `domains` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `v_s_pnumid_ref` FOREIGN KEY (`primary_number_id`) REFERENCES `voip_numbers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vouchers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `amount` double NOT NULL DEFAULT 0,
  `reseller_id` int(11) unsigned NOT NULL,
  `customer_id` int(11) unsigned DEFAULT NULL,
  `package_id` int(11) unsigned DEFAULT NULL,
  `used_by_subscriber_id` int(11) unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `used_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `valid_until` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `vouchers_rescode_idx` (`reseller_id`,`code`),
  KEY `code_sub_valid_idx` (`code`,`used_by_subscriber_id`,`valid_until`),
  KEY `reseller_idx` (`reseller_id`),
  KEY `customer_idx` (`customer_id`),
  KEY `subscriber_idx` (`used_by_subscriber_id`),
  KEY `vouchers_package_ref` (`package_id`),
  CONSTRAINT `vouchers_ibfk_1` FOREIGN KEY (`reseller_id`) REFERENCES `resellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vouchers_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vouchers_ibfk_3` FOREIGN KEY (`used_by_subscriber_id`) REFERENCES `voip_subscribers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vouchers_package_ref` FOREIGN KEY (`package_id`) REFERENCES `profile_packages` (`id`) ON UPDATE CASCADE
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
CREATE DEFINER=`root`@`localhost` FUNCTION `check_billing_fee_offpeak`(_billing_profile_id int(11),
  _t decimal(13,3),
  _contract_id int(11)
) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
begin

  declare _call_start, _call_end decimal(13,3);
  declare _is_offpeak boolean;
  set _call_start = _t;
  set _call_end = _t;

  set _is_offpeak = (select coalesce((select 1 from (
    select
      unix_timestamp(
        if(_contract_id is null,
          concat(date_enum.d," ",pw.start),
          convert_tz(concat(date_enum.d," ",pw.start),
            @@session.time_zone,
            (select coalesce((select tz.name FROM billing.v_contract_timezone tz WHERE tz.contract_id = _contract_id LIMIT 1),@@session.time_zone))
          )
        )
      ) as start,
      unix_timestamp(
        if(_contract_id is null,
          concat(date_enum.d," ",pw.end),
          convert_tz(concat(date_enum.d," ",pw.end),
            @@session.time_zone,
            (select coalesce((select tz.name FROM billing.v_contract_timezone tz WHERE tz.contract_id = _contract_id LIMIT 1),@@session.time_zone))
          )
        )
      ) as end
    from
         ngcp.date_range_helper as date_enum
    join billing.billing_peaktime_weekdays pw on pw.weekday=weekday(date_enum.d)
    where
        pw.billing_profile_id = _billing_profile_id
    and date_enum.d >= date(from_unixtime(_call_start))
    and date_enum.d <= date(from_unixtime(_call_end))
  ) as offpeaks where offpeaks.start <= _t and offpeaks.end >= _t limit 1),0));

  if _is_offpeak != 1 then

    set _is_offpeak = (select coalesce((select 1 from (
      select
        unix_timestamp(
          if(_contract_id is null,
            ps.start,
            convert_tz(ps.start,
              @@session.time_zone,
              (select coalesce((select tz.name FROM billing.v_contract_timezone tz WHERE tz.contract_id = _contract_id LIMIT 1),@@session.time_zone))
            )
          )
        ) as start,
        unix_timestamp(
          if(_contract_id is null,
            ps.end,
            convert_tz(ps.end,
              @@session.time_zone,
              (select coalesce((select tz.name FROM billing.v_contract_timezone tz WHERE tz.contract_id = _contract_id LIMIT 1),@@session.time_zone))
            )
          )
        ) as end
      from
           billing.billing_peaktime_special as ps
      where
          ps.billing_profile_id = _billing_profile_id
      and (ps.start <= from_unixtime(_call_end) and ps.end >= from_unixtime(_call_start))
    ) as offpeaks where offpeaks.start <= _t and offpeaks.end >= _t limit 1),0));

  end if;

  return _is_offpeak;

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_fee`(_billing_profile_id int(11),
  _t decimal(13,3),
  _source varchar(511),
  _destination varchar(511),
  _contract_id int(11)
) RETURNS varchar(100) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    READS SQL DATA
    DETERMINISTIC
begin

  declare _fee_string varchar(100);

  set _fee_string = (select concat(
      if(pt.is_offpeak,bfh.offpeak_init_rate,bfh.onpeak_init_rate),":",
      if(pt.is_offpeak,bfh.offpeak_init_interval,bfh.onpeak_init_interval),":",
      if(pt.is_offpeak,bfh.offpeak_follow_rate,bfh.onpeak_follow_rate),":",
      if(pt.is_offpeak,bfh.offpeak_follow_interval,bfh.onpeak_follow_interval),":",
      bfh.aoc_pulse_amount_per_message
    ) from
           billing.billing_fees_history bfh
      join (select billing.check_billing_fee_offpeak(_billing_profile_id,_t,_contract_id) as is_offpeak) pt
    where
      bfh.id = billing.get_billing_fee_id(_billing_profile_id,"call","out",_source,_destination,null));

  return _fee_string;

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_fee_id`(_billing_profile_id int(11),
  _type enum('call','sms'),
  _direction enum('in','out'),
  _source varchar(511),
  _destination varchar(511),
  _match_mode enum('regex_longest_pattern', 'regex_longest_match', 'prefix', 'exact_destination')
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  declare _destination_prefix,_source_prefix varchar(511);
  declare _i, _j int(3);
  declare _fee_id int(11);

  if _fee_id is null and (_match_mode is null or _match_mode = "exact_destination")
      and (select exists (select 1 from billing.billing_fees_history use index (bfh_srcdestdir_idx) where
          billing_profile_id = _billing_profile_id
      and type = _type
      and match_mode = "exact_destination"
      and direction = _direction
      and bf_id is not null)) then

    set _fee_id = (select id from billing.billing_fees_history where
          billing_profile_id = _billing_profile_id
        and type = _type
        and match_mode = "exact_destination"
        and direction = _direction
        and bf_id is not null
        and destination = _destination
      limit 1);

  end if;

  if _fee_id is null and (_match_mode is null or _match_mode = "prefix")
      and (select exists (select 1 from billing.billing_fees_history use index (bfh_srcdestdir_idx) where
          billing_profile_id = _billing_profile_id
      and type = _type
      and match_mode = "prefix"
      and direction = _direction
      and bf_id is not null)) then

    set _j = length(_destination);

    destination_loop: loop
      if _j < 0 or _fee_id is not null then
        leave destination_loop;
      end if;
      set _destination_prefix = substr(coalesce(_destination,""),1,_j);
      if (select exists (select 1 from billing.billing_fees_history where
              billing_profile_id = _billing_profile_id
          and type = _type
          and match_mode = "prefix"
          and direction = _direction
          and bf_id is not null
          and destination = _destination_prefix)) then

        set _i = length(_source);

        source_loop: loop
          if _i < 0 or _fee_id is not null then
            leave source_loop;
          end if;
          set _source_prefix = substr(coalesce(_source,""),1,_i);
          set _fee_id = (select id from billing.billing_fees_history where
                  billing_profile_id = _billing_profile_id
              and type = _type
              and match_mode = "prefix"
              and direction = _direction
              and bf_id is not null
              and source = _source_prefix
              and destination = _destination_prefix
            limit 1);
          set _i = _i - 1;
        end loop source_loop;
      end if;
      set _j = _j - 1;
    end loop destination_loop;
  end if;

  if _fee_id is null and (_match_mode is null or _match_mode = "regex_longest_match")
     and (select exists (select 1 from billing.billing_fees_history use index (bfh_srcdestdir_idx) where
          billing_profile_id = _billing_profile_id
      and type = _type
      and match_mode = "regex_longest_match"
      and direction = _direction
      and bf_id is not null)) then

    set _fee_id = (select id from billing.billing_fees_history where
            billing_profile_id = _billing_profile_id
        and type = _type
        and match_mode = "regex_longest_match"
        and direction = _direction
        and bf_id is not null
        and _source regexp(source)
        and _destination regexp(destination)
      order by
        length(regexp_substr(_destination,destination)) desc,
        length(regexp_substr(_source,source)) desc limit 1);

  end if;

  if _fee_id is null and (_match_mode is null or _match_mode = "regex_longest_pattern")
      and (select exists (select 1 from billing.billing_fees_history use index (bfh_srcdestdir_idx) where
          billing_profile_id = _billing_profile_id
      and type = _type
      and match_mode = "regex_longest_pattern"
      and direction = _direction
      and bf_id is not null)) then

    set _fee_id = (select id from billing.billing_fees_history where
            billing_profile_id = _billing_profile_id
        and type = _type
        and match_mode = "regex_longest_pattern"
        and direction = _direction
        and bf_id is not null
        and _source regexp(source)
        and _destination regexp(destination)
      order by
        length(destination) desc,
        length(source) desc limit 1);

  end if;

  return _fee_id;

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_network_contract_cnt`(_network_id int,
  _limit int
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  if _limit >= 0 then
    return (select
        count(1)
      from (select
          1
        from billing.contracts_billing_profile_network_schedule cbpns
        join billing.contracts_billing_profile_network cbpn on cbpns.profile_network_id = cbpn.id
        join billing._v_actual_effective_start_time est on est.contract_id = cbpn.contract_id and cbpns.effective_start_time = est.effective_start_time
        join billing.contracts as c on est.contract_id = c.id
        where
        cbpn.billing_network_id = _network_id
        and c.status != 'terminated'
        limit _limit) as q
    );
  end if;

  return (select
      count(1)
    from billing.contracts_billing_profile_network_schedule cbpns
    join billing.contracts_billing_profile_network cbpn on cbpns.profile_network_id = cbpn.id
    join billing._v_actual_effective_start_time est on est.contract_id = cbpn.contract_id and cbpns.effective_start_time = est.effective_start_time
    join billing.contracts as c on est.contract_id = c.id
    where
    cbpn.billing_network_id = _network_id
    and c.status != 'terminated'
  );

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_by_contract_id`(_contract_id int(11),
  _epoch decimal(13,3)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  declare _effective_start_date decimal(13,3);
  declare _cbpn_id,_profile_id int(11);

  if _contract_id is null or _epoch is null then
    return null;
  end if;

  set _effective_start_date = (select max(cbpns.effective_start_time) from billing.contracts_billing_profile_network_schedule cbpns join
    billing.contracts_billing_profile_network cbpn on cbpn.id = cbpns.profile_network_id
    where cbpn.contract_id = _contract_id and cbpns.effective_start_time <= _epoch and cbpn.base = 1);

  if _effective_start_date is null then
    set _cbpn_id = (select min(id) from billing.contracts_billing_profile_network cbpn
      where cbpn.contract_id = _contract_id and cbpn.base = 1);
  else
    set _cbpn_id = (select cbpn.id from billing.contracts_billing_profile_network_schedule cbpns join
      billing.contracts_billing_profile_network cbpn on cbpn.id = cbpns.profile_network_id
      where cbpn.contract_id = _contract_id and cbpns.effective_start_time = _effective_start_date and cbpn.base = 1);
  end if;

  set _profile_id = (select billing_profile_id from billing.contracts_billing_profile_network where id = _cbpn_id);

  return _profile_id;

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_by_contract_id_network`(_contract_id int(11),
  _epoch decimal(13,3),
  _ip varchar(46)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  declare _effective_start_date decimal(13,3);
  declare _cbpn_id,_profile_id int(11);
  declare _network_bytes varbinary(16);
  declare _is_valid_ip,_is_ipv6 boolean default false;

  if _contract_id is null or _epoch is null then
    return null;
  end if;
  set _network_bytes = inet6_aton(_ip);
  set _is_valid_ip = if(_network_bytes is null or hex(_network_bytes) = "00000000",0,1);
  set _is_ipv6 = if(locate(".",_ip) = 0,1,0);

  set _effective_start_date = (select max(cbpns.effective_start_time) from billing.contracts_billing_profile_network_schedule cbpns join
    billing.contracts_billing_profile_network cbpn on cbpn.id = cbpns.profile_network_id
    left join billing.billing_networks bn on cbpn.billing_network_id = bn.id
    left join billing.billing_network_blocks bnb on bn.id = bnb.network_id
    where cbpn.contract_id = _contract_id and cbpns.effective_start_time <= _epoch
    and ((_is_valid_ip and if(_is_ipv6,bnb._ipv6_net_from <= _network_bytes and bnb._ipv6_net_to >= _network_bytes,
    bnb._ipv4_net_from <= _network_bytes and bnb._ipv4_net_to >= _network_bytes)) or cbpn.billing_network_id is null));

  if _effective_start_date is null then
    set _cbpn_id = (billing.get_billing_profile_by_contract_id(_contract_id,_epoch));
  else
    set _cbpn_id = (select cbpn.id from billing.contracts_billing_profile_network_schedule cbpns join
      billing.contracts_billing_profile_network cbpn on cbpn.id = cbpns.profile_network_id
      left join billing.billing_networks bn on cbpn.billing_network_id = bn.id
      left join billing.billing_network_blocks bnb on bn.id = bnb.network_id
      where cbpn.contract_id = _contract_id and cbpns.effective_start_time = _effective_start_date
      and ((_is_valid_ip and if(_is_ipv6,bnb._ipv6_net_from <= _network_bytes and bnb._ipv6_net_to >= _network_bytes,
      bnb._ipv4_net_from <= _network_bytes and bnb._ipv4_net_to >= _network_bytes)) or cbpn.billing_network_id is null)
      order by cbpn.billing_network_id desc limit 1);
  end if;

  set _profile_id = (select billing_profile_id from billing.contracts_billing_profile_network where id = _cbpn_id);

  return _profile_id;

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_by_peer_host_id`(_peer_host_id int(11),
  _epoch decimal(13,3)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  return billing.get_billing_profile_by_contract_id((select pg.peering_contract_id from provisioning.voip_peer_hosts ph join
    provisioning.voip_peer_groups pg on pg.id = ph.group_id where ph.id = _peer_host_id),_epoch);

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_by_peer_host_id_network`(_peer_host_id int(11),
  _epoch decimal(13,3),
  _ip varchar(46)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  return billing.get_billing_profile_by_contract_id_network((select pg.peering_contract_id from provisioning.voip_peer_hosts ph join
    provisioning.voip_peer_groups pg on pg.id = ph.group_id where ph.id = _peer_host_id),_epoch,_ip);

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_by_uuid`(_uuid varchar(36),
  _epoch decimal(13,3)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  return billing.get_billing_profile_by_contract_id((select account_id from provisioning.voip_subscribers where uuid = _uuid),_epoch);

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_by_uuid_network`(_uuid varchar(36),
  _epoch decimal(13,3),
  _ip varchar(46)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  return billing.get_billing_profile_by_contract_id_network((select account_id from provisioning.voip_subscribers where uuid = _uuid),
    _epoch,_ip);

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_billing_profile_contract_cnt`(_profile_id int,
  _limit int
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  if _limit >= 0 then
    return (select
        count(1)
      from (select
          1
        from billing.contracts_billing_profile_network_schedule cbpns
        join billing.contracts_billing_profile_network cbpn on cbpns.profile_network_id = cbpn.id
        join billing._v_actual_effective_start_time est on est.contract_id = cbpn.contract_id and cbpns.effective_start_time = est.effective_start_time
        join billing.contracts as c on est.contract_id = c.id
        where
        cbpn.billing_profile_id = _profile_id
        and c.status != 'terminated'
        limit _limit) as q
    );
  end if;

  return (select
      count(1)
    from billing.contracts_billing_profile_network_schedule cbpns
    join billing.contracts_billing_profile_network cbpn on cbpns.profile_network_id = cbpn.id
    join billing._v_actual_effective_start_time est on est.contract_id = cbpn.contract_id and cbpns.effective_start_time = est.effective_start_time
    join billing.contracts as c on est.contract_id = c.id
    where
    cbpn.billing_profile_id = _profile_id
    and c.status != 'terminated'
  );

end ;;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `get_lnp_number_id`(_destination varchar(511),
  _epoch decimal(13,3)
) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
begin

  declare _destination_prefix varchar(511);
  declare _i int(3);
  declare _number_id int(11);

  set _i = length(_destination);

  destination_loop: loop
    if _i < 0 or _number_id is not null then
      leave destination_loop;
    end if;
    set _destination_prefix = substr(coalesce(_destination,""),1,_i);
    set _number_id = (select id from billing.lnp_numbers 
        use index (number_idx)
        where number = _destination_prefix
	and (start <= from_unixtime(_epoch) or start is null) 
	and (end > from_unixtime(_epoch) or end is null) 
      limit 1);
    set _i = _i - 1;
  end loop destination_loop;

  return _number_id;

end ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_contract_billing_profile_network_schedule`(
  _contract_id int(11) unsigned,
  _last tinyint(3),
  _start_date datetime,
  _end_date datetime,
  _effective_start_date decimal(13,3),
  _profile_id int(11) unsigned,
  _network_id int(11) unsigned
)
begin

  declare _profile_network_id int(11) unsigned;

  set _profile_network_id = (select id from billing.contracts_billing_profile_network where contract_id = _contract_id and billing_profile_id = _profile_id
    and billing_network_id <=> _network_id and start_date <=> _start_date and end_date <=> _end_date and base = _last);

  if _profile_network_id is null then
    insert into billing.contracts_billing_profile_network values(null,_contract_id,_profile_id,_network_id,_start_date,_end_date,_last);
    set _profile_network_id = last_insert_id();
  end if;
  insert into billing.contracts_billing_profile_network_schedule values(null,_profile_network_id,_effective_start_date);

end ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_contract_billing_profile_network_from_package`(
  in _contract_id int(11) unsigned,
  in _start int(13) unsigned,
  in _package_id int(11) unsigned,
  in _package_profile_set varchar(32)
)
begin

  call billing.schedule_contract_billing_profile_network(_contract_id,null,(select group_concat(concat(from_unixtime(_start),",,",profile_id,",",
    if(network_id is null,"",network_id),",") order by id separator ";") from billing.package_profile_sets
    where package_id = _package_id and discriminator = _package_profile_set));

end ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_billing_fees`(in in_profile_id int)
begin

  declare columns varchar(1023);
  declare statement varchar(1023);

  set @profile_id = in_profile_id;

  select group_concat(column_name) into columns from information_schema.columns where table_schema = database() and table_name = "billing_fees_raw" and column_name not in ("id");

  set @statement = concat("insert into billing.billing_fees(id,",columns,")
 select min_id,",columns,"
 from billing.billing_fees_raw bnu
 inner join (
    select min(i_nu.id) min_id
    from billing.billing_fees_raw i_nu
    left join billing.billing_fees i_u
        on i_nu.billing_profile_id=i_u.billing_profile_id
        and i_nu.type=i_u.type
        and i_nu.match_mode=i_u.match_mode
        and i_nu.direction=i_u.direction
        and i_nu.source=i_u.source
        and i_nu.destination=i_u.destination
    where i_u.id is null ",
    if( @profile_id is not null, " and i_nu.billing_profile_id = ? ", " and 1 = ? "),
    " group by i_nu.billing_profile_id,i_nu.type,i_nu.match_mode,i_nu.direction,i_nu.source,i_nu.destination
 ) u on bnu.id=u.min_id");

  if @profile_id is null then
    set @profile_id = 1;
  end if;

  prepare stmt from @statement;
  execute stmt using @profile_id;
  deallocate prepare stmt;
end ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `schedule_contract_billing_profile_network`(
  in _contract_id int(11) unsigned,
  in _now datetime,
  in _future_mappings varchar(65535)
)
main: begin

  declare _new boolean default false;
  declare _line varchar(128);
  declare _start_date_str,_end_date_str varchar(19);
  declare _profile_id_str,_network_id_str varchar(11);
  declare _last_str,_col_sep,_row_sep varchar(1);

  declare _row_sep_length int;
  declare _contract_id_locked,_max_id,_id int(11) unsigned;

  if _future_mappings is null then
    leave main;
  end if;

  if _contract_id is null then
    signal sqlstate "45001" set message_text = "contract_id required";
  else
    
    set _contract_id_locked = (select id from billing.contracts where id = 1 for update);
    
    set _contract_id_locked = (select id from billing.contracts where id = _contract_id for update);
  end if;

  drop temporary table if exists tmp_billing_mappings;
  create temporary table tmp_billing_mappings
    (index (id), index (contract_id,start_date,end_date)) engine = memory
    select cbpn.id,cbpn.contract_id,cbpn.start_date,cbpn.end_date,cbpn.billing_profile_id,
    cbpn.billing_network_id as network_id,cbpn.base from
    billing.contracts_billing_profile_network_schedule cbpns join billing.contracts_billing_profile_network cbpn on cbpn.id = cbpns.profile_network_id
    where cbpn.contract_id = _contract_id and floor(cbpns.effective_start_time) = cbpns.effective_start_time and (_now is null or
    (cbpn.start_date <= _now or cbpn.start_date is null)) order by cbpns.effective_start_time asc, cbpn.base asc, cbpns.profile_network_id asc;

  set _max_id = (select max(id) from tmp_billing_mappings);
  set _new = if(_max_id is null,true,false);
  set _id = if(_max_id is null,0,_max_id);

  set _col_sep = ",";
  set _row_sep = ";";
  set _row_sep_length = length(_row_sep);

  parse_loop: loop
    if _future_mappings is null or length(_future_mappings) = 0 then
      leave parse_loop;
    end if;

    set _line = substring_index(_future_mappings,_row_sep,1);

    set _start_date_str = substring_index(substring_index(_line,_col_sep,1),_col_sep,-1);
    set _end_date_str = substring_index(substring_index(_line,_col_sep,2),_col_sep,-1);
    set _profile_id_str = substring_index(substring_index(_line,_col_sep,3),_col_sep,-1);
    set _network_id_str = substring_index(substring_index(_line,_col_sep,4),_col_sep,-1);
    set _last_str = substring_index(substring_index(_line,_col_sep,5),_col_sep,-1);

    if length(_start_date_str) > 0 and dayname(_start_date_str) is null then
      signal sqlstate "45001" set message_text = "invalid start date";
    end if;
    if length(_end_date_str) > 0 and dayname(_end_date_str) is null then
      signal sqlstate "45001" set message_text = "invalid end date";
    end if;
    if length(_end_date_str) > 0 and length(_start_date_str) = 0 then
      signal sqlstate "45001" set message_text = "mappings with end date but no start date are not allowed";
    end if;

    set _id = _id + 1;
    insert into tmp_billing_mappings values(_id,_contract_id, if(length(_start_date_str) > 0,_start_date_str,null), if(length(_end_date_str) > 0,
      _end_date_str,null), if(length(_profile_id_str) > 0,_profile_id_str,null), if(length(_network_id_str) > 0,_network_id_str,null),
      if(length(_last_str) > 0,if(_last_str > 0,1,0),1));

    set _future_mappings = insert(_future_mappings,1,length(_line) + _row_sep_length,"");
  end loop parse_loop;

  if _new and (select count(*) from tmp_billing_mappings where start_date is null and end_date is null and network_id is null) != 1 then
    signal sqlstate "45001" set message_text = "there must be exactly one initial mapping with open start date, open end date and no network";
  end if;

  if not _new and (select count(*) from tmp_billing_mappings where start_date is null and end_date is null and id > _max_id) > 0 then
    signal sqlstate "45001" set message_text = "adding mappings with open start date and open end date is not allowed";
  end if;

  drop temporary table if exists tmp_billing_mappings_clone;
  create temporary table tmp_billing_mappings_clone
    (index (id), index (contract_id,start_date,end_date)) engine = memory select * from tmp_billing_mappings;

  if not _new then
    delete from billing.contracts_billing_profile_network where contract_id = _contract_id;
  end if;

  nested1: begin

    declare _events_done, _mappings_done, _is_end boolean default false;
    declare _t datetime;

    declare _old_bm_ids varchar(65535);
    declare events_cur cursor for select t,is_end from (
      (select coalesce(bm.start_date,from_unixtime(0)) as t, 0 as is_end
        from tmp_billing_mappings bm join contracts c on bm.contract_id = c.id where contract_id = _contract_id)
      union all
      (select coalesce(end_date,from_unixtime(2147483647) - 0.001) as t, 1 as is_end from tmp_billing_mappings_clone where contract_id = _contract_id)
    ) as events group by t, is_end order by t, is_end;
    declare continue handler for not found set _events_done = true;

    set _old_bm_ids = "";
    set _events_done = false;
    open events_cur;
    events_loop: loop
      fetch events_cur into _t, _is_end;
      if _events_done then
        leave events_loop;
      end if;

      nested2: begin

        declare _bm_id, _default_bm_id, _profile_id, _network_id int(11) unsigned;
        declare _start_date, _end_date datetime;
        declare _effective_start_time decimal(13,3);
        declare _bm_ids varchar(65535);
        declare mappings_cur cursor for select bm1.id, bm1.start_date, bm1.end_date, bm1.billing_profile_id, bm1.network_id from
            tmp_billing_mappings bm1 where bm1.contract_id = _contract_id and bm1.start_date <=> (select bm2.start_date
            from tmp_billing_mappings_clone bm2 where
            bm2.contract_id = _contract_id
            and (bm2.start_date <= _t or bm2.start_date is null)
            and (if(_is_end,bm2.end_date > _t,bm2.end_date >= _t) or bm2.end_date is null)
            order by bm2.start_date desc limit 1) order by bm1.base asc, bm1.id asc;
        declare continue handler for not found set _mappings_done = true;

        set _effective_start_time = (select unix_timestamp(if(_is_end,_t + 0.001,_t)));
        set _bm_ids = "";
        set _mappings_done = false;
        open mappings_cur;
        mappings_loop1: loop
          fetch mappings_cur into _bm_id, _start_date, _end_date, _profile_id, _network_id;
          if _mappings_done then
            leave mappings_loop1;
          end if;
          set _bm_ids = (select concat(_bm_ids,"-",_bm_id));
          set _default_bm_id = _bm_id;
        end loop mappings_loop1;
        close mappings_cur;

        if _old_bm_ids != _bm_ids then
          set _mappings_done = false;
          open mappings_cur;
          mappings_loop2: loop
            fetch mappings_cur into _bm_id, _start_date, _end_date, _profile_id, _network_id;
            if _mappings_done then
              leave mappings_loop2;
            end if;

            call billing.add_contract_billing_profile_network_schedule(_contract_id,if(_bm_id = _default_bm_id,1,0),_start_date,_end_date,
              _effective_start_time,_profile_id,_network_id);

          end loop mappings_loop2;
          close mappings_cur;
        end if;
        set _old_bm_ids = _bm_ids;
      end nested2;
    end loop events_loop;
    close events_cur;
  end nested1;

  drop temporary table tmp_billing_mappings;
  drop temporary table tmp_billing_mappings_clone;

end ;;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `transform_billing_mappings`()
begin

  declare _contracts_done, _events_done, _mappings_done, _is_end boolean default false;
  declare _contract_id, _bm_id, _default_bm_id, _profile_id, _network_id int(11) unsigned;
  declare _t, _start_date, _end_date datetime;
  declare _effective_start_time decimal(13,3);
  declare _bm_ids, _old_bm_ids varchar(65535);

  declare contracts_cur cursor for select bm.contract_id
    from billing_mappings bm left join contracts_billing_profile_network cbpn on bm.contract_id = cbpn.contract_id
    where cbpn.id is null group by bm.contract_id;
  declare continue handler for not found set _contracts_done = true;

  set _old_bm_ids = "";

  open contracts_cur;
  contracts_loop: loop
    fetch contracts_cur into _contract_id;
    if _contracts_done then
      leave contracts_loop;
    end if;
    nested1: begin

      declare events_cur cursor for select t,is_end from (
        (select coalesce(bm.start_date,from_unixtime(0)) as t, 0 as is_end
          from billing_mappings bm join contracts c on bm.contract_id = c.id where contract_id = _contract_id)
        union all
        (select coalesce(end_date,from_unixtime(2147483647) - 0.001) as t, 1 as is_end from billing_mappings where contract_id = _contract_id)
      ) as events group by t, is_end order by t, is_end;
      declare continue handler for not found set _events_done = true;

      set _events_done = false;
      open events_cur;
      events_loop: loop
        fetch events_cur into _t, _is_end;
        if _events_done then
          leave events_loop;
        end if;

        nested2: begin

          declare mappings_cur cursor for select bm1.id, bm1.start_date, bm1.end_date, bm1.billing_profile_id, bm1.network_id from
              billing_mappings bm1 where bm1.contract_id = _contract_id and bm1.start_date <=> (select bm2.start_date
              from billing_mappings bm2 where
              bm2.contract_id = _contract_id
              and (bm2.start_date <= _t or bm2.start_date is null)
              and (if(_is_end,bm2.end_date > _t,bm2.end_date >= _t) or bm2.end_date is null)
              order by bm2.start_date desc limit 1) order by bm1.id asc;
          declare continue handler for not found set _mappings_done = true;

          set _effective_start_time = (select unix_timestamp(if(_is_end,_t + 0.001,_t)));
          set _bm_ids = "";
          set _mappings_done = false;
          open mappings_cur;
          mappings_loop1: loop
            fetch mappings_cur into _bm_id, _start_date, _end_date, _profile_id, _network_id;
            if _mappings_done then
              leave mappings_loop1;
            end if;
            set _bm_ids = (select concat(_bm_ids,"-",_bm_id));
            set _default_bm_id = _bm_id;
          end loop mappings_loop1;
          close mappings_cur;

          if _old_bm_ids != _bm_ids then
            set _mappings_done = false;
            open mappings_cur;
            mappings_loop2: loop
              fetch mappings_cur into _bm_id, _start_date, _end_date, _profile_id, _network_id;
              if _mappings_done then
                leave mappings_loop2;
              end if;

              call add_contract_billing_profile_network_schedule(_contract_id,if(_bm_id = _default_bm_id,1,0),_start_date,_end_date,
                _effective_start_time,_profile_id,_network_id);

            end loop mappings_loop2;
            close mappings_cur;
          end if;
          set _old_bm_ids = _bm_ids;
        end nested2;
      end loop events_loop;
      close events_cur;
    end nested1;
  end loop contracts_loop;
  close contracts_cur;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50001 DROP VIEW IF EXISTS `_v_actual_effective_start_time`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `_v_actual_effective_start_time` AS select `cbpn`.`contract_id` AS `contract_id`,max(`cbpns`.`effective_start_time`) AS `effective_start_time` from (`contracts_billing_profile_network_schedule` `cbpns` join `contracts_billing_profile_network` `cbpn` on(`cbpns`.`profile_network_id` = `cbpn`.`id`)) where `cbpns`.`effective_start_time` <= unix_timestamp(current_timestamp()) and `cbpn`.`base` = 1 group by `cbpn`.`contract_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_actual_billing_profiles`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_actual_billing_profiles` AS select `est`.`contract_id` AS `contract_id`,`cbpn`.`billing_profile_id` AS `billing_profile_id` from ((`contracts_billing_profile_network_schedule` `cbpns` join `contracts_billing_profile_network` `cbpn` on(`cbpns`.`profile_network_id` = `cbpn`.`id`)) join `_v_actual_effective_start_time` `est` on(`est`.`contract_id` = `cbpn`.`contract_id` and `cbpns`.`effective_start_time` = `est`.`effective_start_time`)) where `cbpn`.`base` = 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_contract_billing_profile_network_schedules`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_contract_billing_profile_network_schedules` AS select `cbpns`.`id` AS `id`,`cbpn`.`contract_id` AS `contract_id`,`cbpn`.`start_date` AS `start_date`,`cbpn`.`end_date` AS `end_date`,`cbpn`.`billing_profile_id` AS `billing_profile_id`,`cbpn`.`billing_network_id` AS `network_id`,`cbpns`.`effective_start_time` AS `effective_start_time`,from_unixtime(`cbpns`.`effective_start_time`) AS `effective_start_date`,`bp`.`name` AS `billing_profile_name`,`bp`.`handle` AS `billing_profile_handle`,`bn`.`name` AS `billing_network_name` from (((`contracts_billing_profile_network` `cbpn` join `contracts_billing_profile_network_schedule` `cbpns` on(`cbpns`.`profile_network_id` = `cbpn`.`id`)) join `billing_profiles` `bp` on(`bp`.`id` = `cbpn`.`billing_profile_id`)) left join `billing_networks` `bn` on(`bn`.`id` = `cbpn`.`billing_network_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_contract_timezone`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_contract_timezone` AS select `cc`.`id` AS `contact_id`,`c`.`id` AS `contract_id`,coalesce(`cc`.`timezone`,`rc`.`timezone`,`t`.`name`) AS `name` from (((((`billing`.`contracts` `c` join `billing`.`contacts` `cc` on(`cc`.`id` = `c`.`contact_id`)) left join `billing`.`resellers` `r` on(`r`.`id` = `cc`.`reseller_id`)) left join `billing`.`contracts` `i` on(`i`.`id` = `r`.`contract_id`)) left join `billing`.`contacts` `rc` on(`rc`.`id` = `i`.`contact_id`)) join `ngcp`.`timezone` `t`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_reseller_timezone`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_reseller_timezone` AS select `rc`.`id` AS `contact_id`,`r`.`id` AS `reseller_id`,coalesce(`rc`.`timezone`,`t`.`name`) AS `name` from (((`billing`.`resellers` `r` join `billing`.`contracts` `i` on(`i`.`id` = `r`.`contract_id`)) join `billing`.`contacts` `rc` on(`rc`.`id` = `i`.`contact_id`)) join `ngcp`.`timezone` `t`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `v_subscriber_timezone`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_subscriber_timezone` AS select `sc`.`id` AS `contact_id`,`s`.`id` AS `subscriber_id`,`s`.`uuid` AS `uuid`,coalesce(`sc`.`timezone`,`cc`.`timezone`,`rc`.`timezone`,`t`.`name`) AS `name` from (((((((`billing`.`voip_subscribers` `s` left join `billing`.`contacts` `sc` on(`sc`.`id` = `s`.`contact_id`)) join `billing`.`contracts` `c` on(`c`.`id` = `s`.`contract_id`)) join `billing`.`contacts` `cc` on(`cc`.`id` = `c`.`contact_id`)) join `billing`.`resellers` `r` on(`r`.`id` = `cc`.`reseller_id`)) join `billing`.`contracts` `i` on(`i`.`id` = `r`.`contract_id`)) join `billing`.`contacts` `rc` on(`rc`.`id` = `i`.`contact_id`)) join `ngcp`.`timezone` `t`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
INSERT INTO `acl_role_mappings` VALUES (1,1);
INSERT INTO `acl_role_mappings` VALUES (1,2);
INSERT INTO `acl_role_mappings` VALUES (1,3);
INSERT INTO `acl_role_mappings` VALUES (1,4);
INSERT INTO `acl_role_mappings` VALUES (1,5);
INSERT INTO `acl_role_mappings` VALUES (1,6);
INSERT INTO `acl_role_mappings` VALUES (2,2);
INSERT INTO `acl_role_mappings` VALUES (2,3);
INSERT INTO `acl_role_mappings` VALUES (2,4);
INSERT INTO `acl_role_mappings` VALUES (2,5);
INSERT INTO `acl_role_mappings` VALUES (3,3);
INSERT INTO `acl_role_mappings` VALUES (3,4);
INSERT INTO `acl_role_mappings` VALUES (3,5);
INSERT INTO `acl_role_mappings` VALUES (4,4);
INSERT INTO `acl_role_mappings` VALUES (4,5);
INSERT INTO `acl_role_mappings` VALUES (5,5);
INSERT INTO `acl_roles` VALUES (1,'system',0);
INSERT INTO `acl_roles` VALUES (2,'admin',0);
INSERT INTO `acl_roles` VALUES (3,'reseller',0);
INSERT INTO `acl_roles` VALUES (4,'ccareadmin',0);
INSERT INTO `acl_roles` VALUES (5,'ccare',0);
INSERT INTO `acl_roles` VALUES (6,'lintercept',0);
INSERT INTO `admins` VALUES (1,1,'administrator',NULL,'AtAFGhepIuEaQ.dSfdJ6b.$TNfqchYY76HTh2FAgD3l4r9JFYmFr9i',1,1,0,1,0,1,1,1,0,NULL,NULL,NULL,1,1,1,'2024-11-12 12:25:45',0);
INSERT INTO `billing_fees` VALUES (1,1,1,'.','.*','out','call',0,600,0,600,0,600,0,600,0,'regex_longest_pattern',0,NULL,0,NULL,0,0);
INSERT INTO `billing_fees_history` VALUES (1,NULL,1,1,'.','.*','out','call',0,600,0,600,0,600,0,600,0,'regex_longest_pattern',0,NULL,0,NULL,0,0);
INSERT INTO `billing_fees_history` VALUES (1000,1,1,1,'.','.*','out','call',0,600,0,600,0,600,0,600,0,'regex_longest_pattern',0,NULL,0,NULL,0,0);
INSERT INTO `billing_mappings` VALUES (1,NULL,NULL,1,1,3,NULL);
INSERT INTO `billing_profiles` VALUES (1,1,'default','Default Billing Profile',0,0,0,0,'month',1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'active','2024-11-12 12:25:39','0000-00-00 00:00:00','0000-00-00 00:00:00',0,'libswrate',0);
INSERT INTO `billing_zones` VALUES (1,1,'Free Default Zone','All Destinations');
INSERT INTO `billing_zones_history` VALUES (1,1,1,'Free Default Zone','All Destinations');
INSERT INTO `contacts` VALUES (1,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default-customer@default.invalid',0,'2024-11-12 12:25:25','0000-00-00 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',NULL,NULL);
INSERT INTO `contacts` VALUES (2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default-system@default.invalid',0,'2024-11-12 12:25:27','0000-00-00 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'active',NULL,NULL);
INSERT INTO `contract_balances` VALUES (1,1,0,0,0,0,0,0,'2014-01-01 00:00:00','2014-01-31 23:59:59',NULL,NULL,NULL,NULL,NULL);
INSERT INTO `contracts` VALUES (1,NULL,2,NULL,NULL,'active',NULL,'2024-11-12 12:25:37','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,1,NULL,NULL,NULL,NULL,0.000000,0,3);
INSERT INTO `contracts_billing_profile_network` VALUES (1,1,1,NULL,NULL,NULL,1);
INSERT INTO `contracts_billing_profile_network_schedule` VALUES (1,1,0.000);
INSERT INTO `email_templates` VALUES (1,NULL,'subscriber_default_email','default@sipwise.com','Subscriber created','Dear Customer,\n\nA new subscriber [% subscriber %] has been created for you.\n\nYour faithful Sipwise system\n\n-- \nThis is an automatically generated message. Do not reply.','');
INSERT INTO `email_templates` VALUES (2,NULL,'passreset_default_email','default@sipwise.com','Password reset email','Dear Customer,\n\nPlease go to [% url %] to set your password and log into your self-care interface.\n\nYour faithful Sipwise system\n\n-- \nThis is an automatically generated message. Do not reply.','');
INSERT INTO `email_templates` VALUES (3,NULL,'invoice_default_email','default@sipwise.com','Invoice #[%invoice.serial%] from [%invoice.period_start_obj.ymd%] to [%invoice.period_end_obj.ymd%]','Dear Customer,\n\nPlease find your invoice #[%invoice.serial%] for [%invoice.period_start_obj.month_name%], [%invoice.period_start_obj.year%] in attachment of this letter.\n\nYour faithful Sipwise system\n\n--\nThis is an automatically generated message. Do not reply.','');
INSERT INTO `email_templates` VALUES (4,NULL,'credit_warning_default_email','[% adminmail %]','Sipwise NGCP credit threshold notification','Credit threshold warning for: [% domain %]\nThe following contracts are below the configured threshold of [% threshold %]:\n\n[% contracts %]\n\nYour faithful Sipwise system\n\n-- \nThis is an automatically generated message. Do not reply.','');
INSERT INTO `email_templates` VALUES (5,NULL,'customer_fraud_lock_default_email','[% adminmail %]','Customer # [% customer_id %] locked by fraud detection','Customer # [% customer_id %] has been locked due to exceeding the configured\n[% IF interval == \"day\" -%]daily[% ELSIF interval == \"month\" -%]monthly[% END -%] credit balance threshold ([% interval_cost %] >= [% interval_limit %]) in the [% type %] settings.\n\nAffected subscribers:\n[% subscribers %]\n\nYour faithful Sipwise system\n\n-- \nThis is an automatically generated message. Do not reply.','');
INSERT INTO `email_templates` VALUES (6,NULL,'customer_fraud_warning_default_email','[% adminmail %]','Customer # [% customer_id %] exceeding fraud detection limit','Customer # [% customer_id %] is currently exceeding the configured\n[% IF interval == \"day\" -%]daily[% ELSIF interval == \"month\" -%]monthly[% END -%] credit balance threshold ([% interval_cost %] >= [% interval_limit %]) in the [% type %] settings,\nbut has not been locked due to configuration.\n\nAffected subscribers:\n[% subscribers %]\n\nYour faithful Sipwise system\n\n-- \nThis is an automatically generated message. Do not reply.','');
INSERT INTO `email_templates` VALUES (7,NULL,'fax_receive_ok_default_email','[% mail_from %]','Incoming fax from [% caller %]','        New fax received:\n\n        Status: [% status %]\n        From:   [% caller %]\n        To:     [% callee %]\n        Pages:  [% pages %]\n        Date:   [% date %]\n\n--\nPlease do not reply to this auto-generated E-Mail.','Fax_from_[% caller %]_at_[% date_file %]');
INSERT INTO `email_templates` VALUES (8,NULL,'fax_send_copy_default_email','[% mail_from %]','Copy of an outgoing fax to [% callee %]','        Copy of the sent fax:\n\n        From:  [% caller %]\n        To:    [% callee %]\n        Pages: [% pages %]\n\n--\nPlease do not reply to this auto-generated E-Mail.','Fax_from_[% caller %]_at_[% date_file %]');
INSERT INTO `email_templates` VALUES (9,NULL,'fax_notify_ok_default_email','[% mail_from %]','Fax transmission to [% callee %] is successful','        Fax from [% caller %] to [% callee %] has been successfully sent.\n\n        Pages:   [% pages %]\n        Quality: [% quality %]\n\n--\nPlease do not reply to this auto-generated E-Mail.','');
INSERT INTO `email_templates` VALUES (10,NULL,'fax_notify_error_default_email','[% mail_from %]','Fax transmission to [% callee %] has failed','        Fax from [% caller %] to [% callee %] has failed.\n\n        Status:     [% status %]\n        Attempts:   [% attempts %]\n        Sent pages: [% sent_pages %] of [% pages %]\n        Reason:     [% reason %]\n\n--\nPlease do not reply to this auto-generated E-Mail.','');
INSERT INTO `email_templates` VALUES (11,NULL,'fax_notify_secret_update_default_email','[% mail_from %]','Preferences update notification','        Secret key for subscriber [% subscriber %] has been updated.\n\n        New secret key: [% secret_key %]\n\n--\nPlease do not reply to this auto-generated E-Mail.','');
INSERT INTO `email_templates` VALUES (12,NULL,'admin_passreset_default_email','default@sipwise.com','Password reset email','Dear Customer,\n\nPlease go to [% url %] to set your password and log into your admin interface.\n\nYour faithful Sipwise system\n\n-- \nThis is an automatically generated message. Do not reply.','');
INSERT INTO `products` VALUES (1,NULL,'pstnpeering','PSTN_PEERING','PSTN Peering',1,NULL,NULL,NULL);
INSERT INTO `products` VALUES (2,NULL,'sippeering','SIP_PEERING','SIP Peering',1,NULL,NULL,NULL);
INSERT INTO `products` VALUES (3,NULL,'reseller','VOIP_RESELLER','VoIP Reseller',1,NULL,NULL,NULL);
INSERT INTO `products` VALUES (4,NULL,'sipaccount','SIP_ACCOUNT','Basic SIP Account',1,NULL,NULL,NULL);
INSERT INTO `products` VALUES (5,NULL,'pbxaccount','PBX_ACCOUNT','Cloud PBX Account',1,NULL,NULL,NULL);
INSERT INTO `resellers` VALUES (1,1,'default','active');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger billing.bill_fees_crepl_trig after insert on billing_fees
  for each row
  begin
  declare my_bzh_id int unsigned;

  select id into my_bzh_id from billing.billing_zones_history where bz_id = NEW.billing_zone_id;

  insert into billing.billing_fees_history
    values(NULL, NEW.id, NEW.billing_profile_id, my_bzh_id,
      NEW.source, NEW.destination, NEW.direction,
      NEW.type, NEW.onpeak_init_rate, NEW.onpeak_init_interval, NEW.onpeak_follow_rate,
      NEW.onpeak_follow_interval, NEW.offpeak_init_rate, NEW.offpeak_init_interval,
      NEW.offpeak_follow_rate, NEW.offpeak_follow_interval, NEW.onpeak_use_free_time,
      NEW.match_mode, NEW.onpeak_extra_rate, NEW.onpeak_extra_second, NEW.offpeak_extra_rate, NEW.offpeak_extra_second,
      NEW.offpeak_use_free_time, NEW.aoc_pulse_amount_per_message);

  end */;;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger billing.bill_fees_urepl_trig after update on billing_fees
  for each row
  begin
  declare my_bzh_id int unsigned;

  select id into my_bzh_id from billing.billing_zones_history where bz_id = NEW.billing_zone_id;

  update billing.billing_fees_history
    set bf_id = NEW.id, billing_profile_id = NEW.billing_profile_id,
      billing_zones_history_id = my_bzh_id,
      source = NEW.source, destination = NEW.destination, direction = NEW.direction,
      type = NEW.type,
      onpeak_init_rate = NEW.onpeak_init_rate, onpeak_init_interval = NEW.onpeak_init_interval,
      onpeak_follow_rate = NEW.onpeak_follow_rate, onpeak_follow_interval = NEW.onpeak_follow_interval,
      offpeak_init_rate = NEW.offpeak_init_rate, offpeak_init_interval = NEW.offpeak_init_interval,
      offpeak_follow_rate = NEW.offpeak_follow_rate, offpeak_follow_interval = NEW.offpeak_follow_interval,
      onpeak_use_free_time = NEW.onpeak_use_free_time, offpeak_use_free_time = NEW.offpeak_use_free_time,
      match_mode = NEW.match_mode,
      onpeak_extra_rate = NEW.onpeak_extra_rate, onpeak_extra_second = NEW.onpeak_extra_second,
      offpeak_extra_rate = NEW.offpeak_extra_rate, offpeak_extra_second = NEW.offpeak_extra_second, 
      aoc_pulse_amount_per_message = NEW.aoc_pulse_amount_per_message
    where bf_id = OLD.id;

  end */;;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER billing.bill_zones_crepl_trig AFTER INSERT ON billing_zones
  FOR EACH ROW BEGIN

  INSERT INTO billing_zones_history
       VALUES(NULL, NEW.id, NEW.billing_profile_id, NEW.zone, NEW.detail);

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
/*!50003 CREATE*/ /*!50017 DEFINER=`sipwise`@`localhost`*/ /*!50003 TRIGGER billing.bill_zones_urepl_trig AFTER UPDATE ON billing_zones
  FOR EACH ROW BEGIN

  UPDATE billing_zones_history
     SET bz_id = NEW.id, billing_profile_id = NEW.billing_profile_id,
         zone = NEW.zone, detail = NEW.detail
   WHERE bz_id <=> OLD.id;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER phonebook_on_contract_update AFTER UPDATE ON contracts
FOR EACH ROW
BEGIN
    IF new.status = 'terminated' THEN
        DELETE FROM contract_phonebook WHERE contract_id = old.id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER phonebook_on_reseller_update AFTER UPDATE ON resellers
FOR EACH ROW
BEGIN
    IF new.status = 'terminated' THEN
        DELETE FROM reseller_phonebook WHERE reseller_id = old.id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER phonebook_on_subscriber_update AFTER UPDATE ON voip_subscribers
FOR EACH ROW
BEGIN
    IF new.status = 'terminated' THEN
        DELETE FROM subscriber_phonebook WHERE subscriber_id = old.id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
COMMIT;
