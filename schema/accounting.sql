SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE accounting;
USE accounting;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(16) NOT NULL DEFAULT '',
  `from_tag` varchar(64) NOT NULL DEFAULT '',
  `to_tag` varchar(64) NOT NULL DEFAULT '',
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
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc_backup` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(16) NOT NULL DEFAULT '',
  `from_tag` varchar(64) NOT NULL DEFAULT '',
  `to_tag` varchar(64) NOT NULL DEFAULT '',
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
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc_cdi` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `callid` varchar(255) NOT NULL,
  `mark` decimal(13,3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acc_cdi_callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc_trash` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `method` varchar(16) NOT NULL DEFAULT '',
  `from_tag` varchar(64) NOT NULL DEFAULT '',
  `to_tag` varchar(64) NOT NULL DEFAULT '',
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
  PRIMARY KEY (`id`),
  KEY `callid_idx` (`callid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `source_user_id` char(36) NOT NULL,
  `source_provider_id` varchar(255) NOT NULL,
  `source_external_subscriber_id` varchar(255) DEFAULT NULL,
  `source_external_contract_id` varchar(255) DEFAULT NULL,
  `source_account_id` int(11) unsigned NOT NULL DEFAULT 0,
  `source_user` varchar(255) NOT NULL,
  `source_domain` varchar(255) NOT NULL,
  `source_cli` varchar(64) NOT NULL,
  `source_clir` tinyint(1) NOT NULL DEFAULT 0,
  `source_ip` varchar(64) NOT NULL,
  `source_gpp0` varchar(255) DEFAULT NULL,
  `source_gpp1` varchar(255) DEFAULT NULL,
  `source_gpp2` varchar(255) DEFAULT NULL,
  `source_gpp3` varchar(255) DEFAULT NULL,
  `source_gpp4` varchar(255) DEFAULT NULL,
  `source_gpp5` varchar(255) DEFAULT NULL,
  `source_gpp6` varchar(255) DEFAULT NULL,
  `source_gpp7` varchar(255) DEFAULT NULL,
  `source_gpp8` varchar(255) DEFAULT NULL,
  `source_gpp9` varchar(255) DEFAULT NULL,
  `source_lnp_prefix` varchar(255) NOT NULL DEFAULT '',
  `source_user_out` varchar(255) NOT NULL DEFAULT '',
  `destination_user_id` char(36) NOT NULL,
  `destination_provider_id` varchar(255) NOT NULL,
  `destination_external_subscriber_id` varchar(255) DEFAULT NULL,
  `destination_external_contract_id` varchar(255) DEFAULT NULL,
  `destination_account_id` int(11) unsigned NOT NULL DEFAULT 0,
  `destination_user` varchar(255) NOT NULL,
  `destination_domain` varchar(255) NOT NULL,
  `destination_user_dialed` varchar(255) NOT NULL,
  `destination_user_in` varchar(255) NOT NULL,
  `destination_domain_in` varchar(255) NOT NULL,
  `destination_gpp0` varchar(255) DEFAULT NULL,
  `destination_gpp1` varchar(255) DEFAULT NULL,
  `destination_gpp2` varchar(255) DEFAULT NULL,
  `destination_gpp3` varchar(255) DEFAULT NULL,
  `destination_gpp4` varchar(255) DEFAULT NULL,
  `destination_gpp5` varchar(255) DEFAULT NULL,
  `destination_gpp6` varchar(255) DEFAULT NULL,
  `destination_gpp7` varchar(255) DEFAULT NULL,
  `destination_gpp8` varchar(255) DEFAULT NULL,
  `destination_gpp9` varchar(255) DEFAULT NULL,
  `destination_lnp_prefix` varchar(255) NOT NULL DEFAULT '',
  `destination_user_out` varchar(255) NOT NULL DEFAULT '',
  `peer_auth_user` varchar(255) DEFAULT NULL,
  `peer_auth_realm` varchar(255) DEFAULT NULL,
  `call_type` enum('call','cfu','cft','cfb','cfna','cfs','sms','cfr','cfo') NOT NULL DEFAULT 'call',
  `call_status` enum('ok','busy','noanswer','cancel','offline','timeout','other','failed') NOT NULL DEFAULT 'ok',
  `call_code` char(3) NOT NULL,
  `init_time` decimal(13,3) NOT NULL,
  `start_time` decimal(13,3) NOT NULL,
  `duration` decimal(13,3) NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `source_carrier_cost` decimal(14,6) DEFAULT NULL,
  `source_reseller_cost` decimal(14,6) DEFAULT NULL,
  `source_customer_cost` decimal(14,6) DEFAULT NULL,
  `source_carrier_free_time` int(10) unsigned DEFAULT NULL,
  `source_reseller_free_time` int(10) unsigned DEFAULT NULL,
  `source_customer_free_time` int(10) unsigned DEFAULT NULL,
  `source_carrier_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `source_reseller_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `source_customer_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `source_carrier_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `source_reseller_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `source_customer_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `destination_carrier_cost` decimal(14,6) DEFAULT NULL,
  `destination_reseller_cost` decimal(14,6) DEFAULT NULL,
  `destination_customer_cost` decimal(14,6) DEFAULT NULL,
  `destination_carrier_free_time` int(10) unsigned DEFAULT NULL,
  `destination_reseller_free_time` int(10) unsigned DEFAULT NULL,
  `destination_customer_free_time` int(10) unsigned DEFAULT NULL,
  `destination_carrier_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `destination_reseller_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `destination_customer_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `destination_carrier_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `destination_reseller_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `destination_customer_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `frag_carrier_onpeak` tinyint(1) DEFAULT NULL,
  `frag_reseller_onpeak` tinyint(1) DEFAULT NULL,
  `frag_customer_onpeak` tinyint(1) DEFAULT NULL,
  `is_fragmented` tinyint(1) DEFAULT NULL,
  `split` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `rated_at` datetime DEFAULT NULL,
  `rating_status` enum('unrated','ok','failed') NOT NULL DEFAULT 'unrated',
  `exported_at` datetime DEFAULT NULL,
  `export_status` enum('unexported','ok','failed') NOT NULL DEFAULT 'unexported',
  `source_lnp_type` varchar(255) DEFAULT NULL,
  `destination_lnp_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`start_time`),
  KEY `suid` (`source_user_id`),
  KEY `duid` (`destination_user_id`),
  KEY `suri` (`source_user`,`source_domain`,`source_cli`),
  KEY `duri` (`destination_user`,`destination_domain`),
  KEY `sprov` (`source_provider_id`),
  KEY `dprov` (`destination_provider_id`),
  KEY `kcid` (`call_id`),
  KEY `stime_idx` (`start_time`),
  KEY `said_stime_idx` (`source_account_id`,`start_time`),
  KEY `duri_in_idx` (`destination_user_in`,`destination_domain_in`),
  KEY `rstatus_stime_idx` (`rating_status`,`start_time`),
  KEY `daid_stime` (`destination_account_id`,`start_time`),
  KEY `scli_idx` (`source_cli`),
  KEY `ecrstatus` (`export_status`,`call_status`,`rating_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_cash_balance` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('cash_balance') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ccbc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_cash_balance_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `cash_balance_id` int(3) unsigned NOT NULL,
  `val_before` decimal(14,6) NOT NULL,
  `val_after` decimal(14,6) NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`cash_balance_id`,`cdr_start_time`),
  KEY `cashbalancedata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_direction` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('source','destination') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cdc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_export_status` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cesc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_export_status_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `status_id` int(3) unsigned NOT NULL,
  `exported_at` datetime DEFAULT NULL,
  `export_status` enum('unexported','ok','failed','skipped') NOT NULL DEFAULT 'unexported',
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`status_id`,`cdr_start_time`),
  KEY `cdrexportstatusdata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_group` (
  `cdr_id` int(10) unsigned NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`call_id`,`cdr_start_time`),
  KEY `cdrgroup_callid_idx` (`call_id`),
  KEY `cdrgroup_stime_idx` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_mos_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `mos_average` decimal(5,1) DEFAULT NULL,
  `mos_average_packetloss` decimal(5,1) DEFAULT NULL,
  `mos_average_jitter` decimal(5,1) DEFAULT NULL,
  `mos_average_roundtrip` decimal(5,1) DEFAULT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_period_costs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `period` enum('month','day') NOT NULL,
  `period_date` date NOT NULL,
  `direction` enum('out','in') NOT NULL DEFAULT 'out',
  `customer_cost` decimal(16,6) NOT NULL DEFAULT 0.000000,
  `reseller_cost` decimal(16,6) NOT NULL DEFAULT 0.000000,
  `cdr_count` int(11) unsigned NOT NULL DEFAULT 0,
  `fraud_limit_exceeded` tinyint(1) unsigned DEFAULT NULL,
  `fraud_limit_type` enum('contract','billing_profile') DEFAULT NULL,
  `notify_status` enum('new','notified') NOT NULL DEFAULT 'new',
  `notified_at` datetime DEFAULT NULL,
  `first_cdr_start_time` decimal(13,3) NOT NULL,
  `first_cdr_id` int(10) unsigned DEFAULT NULL,
  `last_cdr_start_time` decimal(13,3) NOT NULL,
  `last_cdr_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_id` (`contract_id`,`period`,`period_date`,`direction`),
  KEY `cdrperiodcosts_pdfls` (`period`,`period_date`,`direction`,`fraud_limit_exceeded`,`notify_status`),
  KEY `cdrperiodcosts_fstime` (`first_cdr_start_time`),
  KEY `cdrperiodcosts_fcid` (`first_cdr_id`),
  KEY `cdrperiodcosts_lcid` (`last_cdr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_provider` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('carrier','reseller','customer') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cpc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_relation` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('profile_package_id','contract_balance_id','prev_fragment_id') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `crc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_relation_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `relation_id` int(3) unsigned NOT NULL,
  `val` int(10) unsigned NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`relation_id`,`cdr_start_time`),
  KEY `cdrrelationdata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_tag` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ctc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_tag_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `tag_id` int(3) unsigned NOT NULL,
  `val` text NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`tag_id`,`cdr_start_time`),
  KEY `cdrtagdata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_time_balance` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('free_time_balance') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ctbc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cdr_time_balance_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `time_balance_id` int(3) unsigned NOT NULL,
  `val_before` int(10) unsigned NOT NULL,
  `val_after` int(10) unsigned NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`time_balance_id`,`cdr_start_time`),
  KEY `timebalancedata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `subscriber_id` int(11) unsigned NOT NULL,
  `reseller_id` int(11) unsigned NOT NULL DEFAULT 1,
  `old_status` varchar(255) DEFAULT NULL,
  `new_status` varchar(255) NOT NULL,
  `timestamp` decimal(13,3) NOT NULL,
  `export_status` enum('unexported','ok','filtered','failed') NOT NULL DEFAULT 'unexported',
  `exported_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriber_idx` (`subscriber_id`),
  KEY `exstatus_idx` (`export_status`),
  KEY `event_ts` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_relation` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('primary_number_id','subscriber_profile_id','subscriber_profile_set_id','pilot_subscriber_id','pilot_primary_number_id','pilot_subscriber_profile_id','pilot_subscriber_profile_set_id') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_relation_data` (
  `event_id` int(11) unsigned NOT NULL,
  `relation_id` int(3) unsigned NOT NULL,
  `val` int(10) unsigned NOT NULL,
  `event_timestamp` decimal(13,3) NOT NULL,
  PRIMARY KEY (`event_id`,`relation_id`,`event_timestamp`),
  KEY `eventrelationdata_ts` (`event_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_tag` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('primary_number_cc','primary_number_ac','primary_number_sn','pilot_primary_number_cc','pilot_primary_number_ac','pilot_primary_number_sn','subscriber_profile_name','subscriber_profile_set_name','pilot_subscriber_profile_name','pilot_subscriber_profile_set_name','first_non_primary_alias_username_before','first_non_primary_alias_username_after','pilot_first_non_primary_alias_username_before','pilot_first_non_primary_alias_username_after','non_primary_alias_username','primary_alias_username_before','primary_alias_username_after','pilot_primary_alias_username_before','pilot_primary_alias_username_after') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `etc_type_idx` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_tag_data` (
  `event_id` int(11) unsigned NOT NULL,
  `tag_id` int(3) unsigned NOT NULL,
  `val` text NOT NULL,
  `event_timestamp` decimal(13,3) NOT NULL,
  PRIMARY KEY (`event_id`,`tag_id`,`event_timestamp`),
  KEY `eventrelationdata_ts` (`event_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `source_user_id` char(36) NOT NULL,
  `source_provider_id` varchar(255) NOT NULL,
  `source_external_subscriber_id` varchar(255) DEFAULT NULL,
  `source_external_contract_id` varchar(255) DEFAULT NULL,
  `source_account_id` int(11) unsigned NOT NULL DEFAULT 0,
  `source_user` varchar(255) NOT NULL,
  `source_domain` varchar(255) NOT NULL,
  `source_cli` varchar(64) NOT NULL,
  `source_clir` tinyint(1) NOT NULL DEFAULT 0,
  `source_ip` varchar(64) NOT NULL,
  `source_gpp0` varchar(255) DEFAULT NULL,
  `source_gpp1` varchar(255) DEFAULT NULL,
  `source_gpp2` varchar(255) DEFAULT NULL,
  `source_gpp3` varchar(255) DEFAULT NULL,
  `source_gpp4` varchar(255) DEFAULT NULL,
  `source_gpp5` varchar(255) DEFAULT NULL,
  `source_gpp6` varchar(255) DEFAULT NULL,
  `source_gpp7` varchar(255) DEFAULT NULL,
  `source_gpp8` varchar(255) DEFAULT NULL,
  `source_gpp9` varchar(255) DEFAULT NULL,
  `source_lnp_prefix` varchar(255) NOT NULL DEFAULT '',
  `source_user_out` varchar(255) NOT NULL DEFAULT '',
  `destination_user_id` char(36) NOT NULL,
  `destination_provider_id` varchar(255) NOT NULL,
  `destination_external_subscriber_id` varchar(255) DEFAULT NULL,
  `destination_external_contract_id` varchar(255) DEFAULT NULL,
  `destination_account_id` int(11) unsigned NOT NULL DEFAULT 0,
  `destination_user` varchar(255) NOT NULL,
  `destination_domain` varchar(255) NOT NULL,
  `destination_user_dialed` varchar(255) NOT NULL,
  `destination_user_in` varchar(255) NOT NULL,
  `destination_domain_in` varchar(255) NOT NULL,
  `destination_gpp0` varchar(255) DEFAULT NULL,
  `destination_gpp1` varchar(255) DEFAULT NULL,
  `destination_gpp2` varchar(255) DEFAULT NULL,
  `destination_gpp3` varchar(255) DEFAULT NULL,
  `destination_gpp4` varchar(255) DEFAULT NULL,
  `destination_gpp5` varchar(255) DEFAULT NULL,
  `destination_gpp6` varchar(255) DEFAULT NULL,
  `destination_gpp7` varchar(255) DEFAULT NULL,
  `destination_gpp8` varchar(255) DEFAULT NULL,
  `destination_gpp9` varchar(255) DEFAULT NULL,
  `destination_lnp_prefix` varchar(255) NOT NULL DEFAULT '',
  `destination_user_out` varchar(255) NOT NULL DEFAULT '',
  `peer_auth_user` varchar(255) DEFAULT NULL,
  `peer_auth_realm` varchar(255) DEFAULT NULL,
  `call_type` enum('call','cfu','cft','cfb','cfna','cfs','sms','cfr','cfo') NOT NULL DEFAULT 'call',
  `call_status` enum('ok','busy','noanswer','cancel','offline','timeout','other','failed') NOT NULL DEFAULT 'ok',
  `call_code` char(3) NOT NULL,
  `init_time` decimal(13,3) NOT NULL,
  `start_time` decimal(13,3) NOT NULL,
  `duration` decimal(13,3) NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `source_carrier_cost` decimal(14,6) DEFAULT NULL,
  `source_reseller_cost` decimal(14,6) DEFAULT NULL,
  `source_customer_cost` decimal(14,6) DEFAULT NULL,
  `source_carrier_free_time` int(10) unsigned DEFAULT NULL,
  `source_reseller_free_time` int(10) unsigned DEFAULT NULL,
  `source_customer_free_time` int(10) unsigned DEFAULT NULL,
  `source_carrier_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `source_reseller_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `source_customer_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `source_carrier_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `source_reseller_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `source_customer_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `destination_carrier_cost` decimal(14,6) DEFAULT NULL,
  `destination_reseller_cost` decimal(14,6) DEFAULT NULL,
  `destination_customer_cost` decimal(14,6) DEFAULT NULL,
  `destination_carrier_free_time` int(10) unsigned DEFAULT NULL,
  `destination_reseller_free_time` int(10) unsigned DEFAULT NULL,
  `destination_customer_free_time` int(10) unsigned DEFAULT NULL,
  `destination_carrier_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `destination_reseller_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `destination_customer_billing_fee_id` int(11) unsigned DEFAULT NULL,
  `destination_carrier_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `destination_reseller_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `destination_customer_billing_zone_id` int(11) unsigned DEFAULT NULL,
  `frag_carrier_onpeak` tinyint(1) DEFAULT NULL,
  `frag_reseller_onpeak` tinyint(1) DEFAULT NULL,
  `frag_customer_onpeak` tinyint(1) DEFAULT NULL,
  `is_fragmented` tinyint(1) DEFAULT NULL,
  `split` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `rated_at` datetime DEFAULT NULL,
  `rating_status` enum('unrated','ok','failed') NOT NULL DEFAULT 'unrated',
  `exported_at` datetime DEFAULT NULL,
  `export_status` enum('unexported','ok','failed') NOT NULL DEFAULT 'unexported',
  `source_lnp_type` varchar(255) DEFAULT NULL,
  `destination_lnp_type` varchar(255) DEFAULT NULL,
  `acc_ref` varchar(255) NOT NULL,
  PRIMARY KEY (`id`,`start_time`),
  UNIQUE KEY `acc_ref_uidx` (`acc_ref`),
  KEY `suid` (`source_user_id`),
  KEY `duid` (`destination_user_id`),
  KEY `suri` (`source_user`,`source_domain`,`source_cli`),
  KEY `duri` (`destination_user`,`destination_domain`),
  KEY `sprov` (`source_provider_id`),
  KEY `dprov` (`destination_provider_id`),
  KEY `kcid` (`call_id`),
  KEY `stime_idx` (`start_time`),
  KEY `said_stime_idx` (`source_account_id`,`start_time`),
  KEY `duri_in_idx` (`destination_user_in`,`destination_domain_in`),
  KEY `rstatus_stime_idx` (`rating_status`,`start_time`),
  KEY `daid_stime` (`destination_account_id`,`start_time`),
  KEY `scli_idx` (`source_cli`),
  KEY `ecrstatus` (`export_status`,`call_status`,`rating_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr_cash_balance_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `cash_balance_id` int(3) unsigned NOT NULL,
  `val_before` decimal(14,6) NOT NULL,
  `val_after` decimal(14,6) NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`cash_balance_id`,`cdr_start_time`),
  KEY `cashbalancedata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr_export_status_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `status_id` int(3) unsigned NOT NULL,
  `exported_at` datetime DEFAULT NULL,
  `export_status` enum('unexported','ok','failed','skipped') NOT NULL DEFAULT 'unexported',
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`status_id`,`cdr_start_time`),
  KEY `cdrexportstatusdata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr_group` (
  `cdr_id` int(10) unsigned NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`call_id`,`cdr_start_time`),
  KEY `cdrgroup_callid_idx` (`call_id`),
  KEY `cdrgroup_stime_idx` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr_relation_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `relation_id` int(3) unsigned NOT NULL,
  `val` int(10) unsigned NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`relation_id`,`cdr_start_time`),
  KEY `cdrrelationdata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr_tag_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `tag_id` int(3) unsigned NOT NULL,
  `val` text NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`tag_id`,`cdr_start_time`),
  KEY `cdrtagdata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `int_cdr_time_balance_data` (
  `cdr_id` int(10) unsigned NOT NULL,
  `provider_id` int(3) unsigned NOT NULL,
  `direction_id` int(3) unsigned NOT NULL,
  `time_balance_id` int(3) unsigned NOT NULL,
  `val_before` int(10) unsigned NOT NULL,
  `val_after` int(10) unsigned NOT NULL,
  `cdr_start_time` decimal(13,3) NOT NULL,
  PRIMARY KEY (`cdr_id`,`provider_id`,`direction_id`,`time_balance_id`,`cdr_start_time`),
  KEY `timebalancedata_stime` (`cdr_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `malicious_calls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `callee_uuid` varchar(255) NOT NULL,
  `call_id` varchar(255) NOT NULL,
  `start_time` decimal(13,3) NOT NULL,
  `duration` decimal(13,3) NOT NULL,
  `caller` varchar(255) NOT NULL,
  `callee` varchar(255) NOT NULL,
  `source` varchar(255) DEFAULT NULL,
  `reported_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `mcid_callid_idx` (`call_id`),
  KEY `mcid_callee_uuid_idx` (`callee_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mark` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collector` varchar(255) NOT NULL,
  `acc_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `collector_idx` (`collector`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prepaid_costs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `call_id` varchar(255) NOT NULL,
  `cost` double NOT NULL,
  `free_time_used` int(10) unsigned NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `source_user_id` char(36) NOT NULL,
  `destination_user_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `cdr_cash_balance` VALUES (1,'cash_balance');
INSERT INTO `cdr_direction` VALUES (1,'source');
INSERT INTO `cdr_direction` VALUES (2,'destination');
INSERT INTO `cdr_export_status` VALUES (2,'ama_ccs');
INSERT INTO `cdr_export_status` VALUES (1,'default');
INSERT INTO `cdr_provider` VALUES (1,'carrier');
INSERT INTO `cdr_provider` VALUES (2,'reseller');
INSERT INTO `cdr_provider` VALUES (3,'customer');
INSERT INTO `cdr_relation` VALUES (1,'profile_package_id');
INSERT INTO `cdr_relation` VALUES (2,'contract_balance_id');
INSERT INTO `cdr_relation` VALUES (3,'prev_fragment_id');
INSERT INTO `cdr_tag` VALUES (10,'balance_delta');
INSERT INTO `cdr_tag` VALUES (1,'calling_party_category');
INSERT INTO `cdr_tag` VALUES (7,'concurrent_calls_count');
INSERT INTO `cdr_tag` VALUES (8,'concurrent_calls_count_customer');
INSERT INTO `cdr_tag` VALUES (9,'concurrent_calls_quota');
INSERT INTO `cdr_tag` VALUES (6,'extra_rate');
INSERT INTO `cdr_tag` VALUES (2,'furnished_charging_info');
INSERT INTO `cdr_tag` VALUES (4,'header=Diversion');
INSERT INTO `cdr_tag` VALUES (11,'header=History-Info');
INSERT INTO `cdr_tag` VALUES (3,'header=P-Asserted-Identity');
INSERT INTO `cdr_tag` VALUES (5,'header=User-to-User');
INSERT INTO `cdr_tag` VALUES (12,'hg_ext_response');
INSERT INTO `cdr_tag` VALUES (14,'r_ua');
INSERT INTO `cdr_tag` VALUES (13,'r_user');
INSERT INTO `cdr_time_balance` VALUES (1,'free_time_balance');
INSERT INTO `events_relation` VALUES (1,'primary_number_id');
INSERT INTO `events_relation` VALUES (2,'subscriber_profile_id');
INSERT INTO `events_relation` VALUES (3,'subscriber_profile_set_id');
INSERT INTO `events_relation` VALUES (4,'pilot_subscriber_id');
INSERT INTO `events_relation` VALUES (5,'pilot_primary_number_id');
INSERT INTO `events_relation` VALUES (6,'pilot_subscriber_profile_id');
INSERT INTO `events_relation` VALUES (7,'pilot_subscriber_profile_set_id');
INSERT INTO `events_tag` VALUES (1,'primary_number_cc');
INSERT INTO `events_tag` VALUES (2,'primary_number_ac');
INSERT INTO `events_tag` VALUES (3,'primary_number_sn');
INSERT INTO `events_tag` VALUES (4,'pilot_primary_number_cc');
INSERT INTO `events_tag` VALUES (5,'pilot_primary_number_ac');
INSERT INTO `events_tag` VALUES (6,'pilot_primary_number_sn');
INSERT INTO `events_tag` VALUES (7,'subscriber_profile_name');
INSERT INTO `events_tag` VALUES (8,'subscriber_profile_set_name');
INSERT INTO `events_tag` VALUES (9,'pilot_subscriber_profile_name');
INSERT INTO `events_tag` VALUES (10,'pilot_subscriber_profile_set_name');
INSERT INTO `events_tag` VALUES (11,'first_non_primary_alias_username_before');
INSERT INTO `events_tag` VALUES (12,'first_non_primary_alias_username_after');
INSERT INTO `events_tag` VALUES (13,'pilot_first_non_primary_alias_username_before');
INSERT INTO `events_tag` VALUES (14,'pilot_first_non_primary_alias_username_after');
INSERT INTO `events_tag` VALUES (15,'non_primary_alias_username');
INSERT INTO `events_tag` VALUES (16,'primary_alias_username_before');
INSERT INTO `events_tag` VALUES (17,'primary_alias_username_after');
INSERT INTO `events_tag` VALUES (18,'pilot_primary_alias_username_before');
INSERT INTO `events_tag` VALUES (19,'pilot_primary_alias_username_after');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_cascade_update_trig after update on accounting.cdr
  for each row begin

  update accounting.cdr_relation_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.cdr_cash_balance_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.cdr_time_balance_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.cdr_tag_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.cdr_export_status_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.cdr_group set cdr_id = NEW.id where cdr_id = OLD.id;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_cascade_delete_trig after delete on accounting.cdr
  for each row begin

  delete from accounting.cdr_relation_data where cdr_id = OLD.id;
  delete from accounting.cdr_cash_balance_data where cdr_id = OLD.id;
  delete from accounting.cdr_time_balance_data where cdr_id = OLD.id;
  delete from accounting.cdr_tag_data where cdr_id = OLD.id;
  delete from accounting.cdr_export_status_data where cdr_id = OLD.id;
  delete from accounting.cdr_group where cdr_id = OLD.id;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_cash_balance_rest_cascade_delete_trig before delete on accounting.cdr_cash_balance
  for each row begin

    select * into @cb_count from (select count(1) from accounting.cdr_cash_balance_data where cash_balance_id = OLD.id limit 1) as cnt;
    if @cb_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_cash_balance, related data exists in accounting.cdr_cash_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @cb_count from (select count(1) from accounting.int_cdr_cash_balance_data where cash_balance_id = OLD.id limit 1) as cnt;
    if @cb_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_cash_balance, related data exists in accounting.int_cdr_cash_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_direction_rest_cascade_delete_trig before delete on accounting.cdr_direction
  for each row begin

    select * into @rel_dir_count
        from (select count(1) from accounting.cdr_relation_data where direction_id = OLD.id limit 1) as cnt;
    if @rel_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.cdr_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @cash_balance_dir_count
        from (select count(1) from accounting.cdr_cash_balance_data where direction_id = OLD.id limit 1) as cnt;
    if @cash_balance_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.cdr_cash_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @time_balance_dir_count
        from (select count(1) from accounting.cdr_time_balance_data where direction_id = OLD.id limit 1) as cnt;
    if @time_balance_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.cdr_time_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @tag_dir_count
        from (select count(1) from accounting.cdr_tag_data where direction_id = OLD.id limit 1) as cnt;
    if @tag_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.cdr_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;


    select * into @rel_dir_count
        from (select count(1) from accounting.int_cdr_relation_data where direction_id = OLD.id limit 1) as cnt;
    if @rel_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.int_cdr_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @cash_balance_dir_count
        from (select count(1) from accounting.int_cdr_cash_balance_data where direction_id = OLD.id limit 1) as cnt;
    if @cash_balance_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.int_cdr_cash_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @time_balance_dir_count
        from (select count(1) from accounting.int_cdr_time_balance_data where direction_id = OLD.id limit 1) as cnt;
    if @time_balance_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.int_cdr_time_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @tag_dir_count
        from (select count(1) from accounting.int_cdr_tag_data where direction_id = OLD.id limit 1) as cnt;
    if @tag_dir_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_direction, related data exists in accounting.int_cdr_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_export_status_rest_cascade_delete_trig before delete on accounting.cdr_export_status
  for each row begin

    select * into @es_count from (select count(1) from accounting.cdr_export_status_data where status_id = OLD.id limit 1) as cnt;
    if @ct_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_export_status, related data exists in accounting.cdr_export_status_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @es_count from (select count(1) from accounting.int_cdr_export_status_data where status_id = OLD.id limit 1) as cnt;
    if @ct_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_export_status, related data exists in accounting.int_cdr_export_status_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_provider_rest_cascade_delete_trig before delete on accounting.cdr_provider
  for each row begin

    select * into @rel_prov_count
        from (select count(1) from accounting.cdr_relation_data where provider_id = OLD.id limit 1) as cnt;
    if @rel_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.cdr_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @cash_balance_prov_count
        from (select count(1) from accounting.cdr_cash_balance_data where provider_id = OLD.id limit 1) as cnt;
    if @cash_balance_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.cdr_cash_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @time_balance_prov_count
        from (select count(1) from accounting.cdr_time_balance_data where provider_id = OLD.id limit 1) as cnt;
    if @time_balance_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.cdr_time_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @tag_prov_count
        from (select count(1) from accounting.cdr_tag_data where provider_id = OLD.id limit 1) as cnt;
    if @tag_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.cdr_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;



    select * into @rel_prov_count
        from (select count(1) from accounting.int_cdr_relation_data where provider_id = OLD.id limit 1) as cnt;
    if @rel_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.int_cdr_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @cash_balance_prov_count
        from (select count(1) from accounting.int_cdr_cash_balance_data where provider_id = OLD.id limit 1) as cnt;
    if @cash_balance_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.int_cdr_cash_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @time_balance_prov_count
        from (select count(1) from accounting.int_cdr_time_balance_data where provider_id = OLD.id limit 1) as cnt;
    if @time_balance_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.int_cdr_time_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @tag_prov_count
        from (select count(1) from accounting.int_cdr_tag_data where provider_id = OLD.id limit 1) as cnt;
    if @tag_prov_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_provider, related data exists in accounting.int_cdr_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_relation_rest_cascade_delete_trig before delete on accounting.cdr_relation
  for each row begin

    select * into @rel_count from (select count(1) from accounting.cdr_relation_data where relation_id = OLD.id limit 1) as cnt;
    if @rel_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_relation, related data exists in accounting.cdr_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @rel_count from (select count(1) from accounting.int_cdr_relation_data where relation_id = OLD.id limit 1) as cnt;
    if @rel_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_relation, related data exists in accounting.int_cdr_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_tag_rest_cascade_delete_trig before delete on accounting.cdr_tag
  for each row begin

    select * into @ct_count from (select count(1) from accounting.cdr_tag_data where tag_id = OLD.id limit 1) as cnt;
    if @ct_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_tag, related data exists in accounting.cdr_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @ct_count from (select count(1) from accounting.int_cdr_tag_data where tag_id = OLD.id limit 1) as cnt;
    if @ct_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_tag, related data exists in accounting.int_cdr_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger cdr_time_balance_rest_cascade_delete_trig before delete on accounting.cdr_time_balance
  for each row begin

    select * into @tb_count from (select count(1) from accounting.cdr_time_balance_data where time_balance_id = OLD.id limit 1) as cnt;
    if @tb_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_time_balance, related data exists in accounting.cdr_time_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

    select * into @tb_count from (select count(1) from accounting.int_cdr_time_balance_data where time_balance_id = OLD.id limit 1) as cnt;
    if @tb_count > 0 then
        set @err_msg = 'Error deleting data from accounting.cdr_time_balance, related data exists in accounting.int_cdr_time_balance_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger events_relation_rest_cascade_delete_trig before delete on accounting.events_relation
  for each row begin

    select count(1) into @rel_count from (select count(1) from accounting.events_relation_data where relation_id = OLD.id limit 1) as cnt;

    if @rel_count > 0 then
        set @err_msg = 'Error deleting data from accounting.events_relation, related data exists in accounting.events_relation_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger events_tag_rest_cascade_delete_trig before delete on accounting.events_tag
  for each row begin

    select count(1) into @tag_count from (select count(1) from accounting.events_tag_data where tag_id = OLD.id limit 1) as cnt;

    if @tag_count > 0 then
        set @err_msg = 'Error deleting data from accounting.events_tag, related data exists in accounting.events_tag_data';
        signal sqlstate '45000' set message_text = @err_msg;
    end if;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger int_cdr_cascade_update_trig after update on accounting.int_cdr
  for each row begin

  update accounting.int_cdr_relation_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.int_cdr_cash_balance_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.int_cdr_time_balance_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.int_cdr_tag_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.int_cdr_export_status_data set cdr_id = NEW.id where cdr_id = OLD.id;
  update accounting.int_cdr_group set cdr_id = NEW.id where cdr_id = OLD.id;

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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger int_cdr_cascade_delete_trig after delete on accounting.int_cdr
  for each row begin

  delete from accounting.int_cdr_relation_data where cdr_id = OLD.id;
  delete from accounting.int_cdr_cash_balance_data where cdr_id = OLD.id;
  delete from accounting.int_cdr_time_balance_data where cdr_id = OLD.id;
  delete from accounting.int_cdr_tag_data where cdr_id = OLD.id;
  delete from accounting.int_cdr_export_status_data where cdr_id = OLD.id;
  delete from accounting.int_cdr_group where cdr_id = OLD.id;

  end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
COMMIT;
