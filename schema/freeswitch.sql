SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE freeswitch;
USE freeswitch;
/*M!999999\- enable the sandbox mode */ 
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aliases` (
  `sticky` int(11) DEFAULT NULL,
  `alias` varchar(128) DEFAULT NULL,
  `command` varchar(4096) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  KEY `alias1` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `basic_calls` AS SELECT
 1 AS `uuid`,
  1 AS `direction`,
  1 AS `created`,
  1 AS `created_epoch`,
  1 AS `name`,
  1 AS `state`,
  1 AS `cid_name`,
  1 AS `cid_num`,
  1 AS `ip_addr`,
  1 AS `dest`,
  1 AS `presence_id`,
  1 AS `presence_data`,
  1 AS `accountcode`,
  1 AS `callstate`,
  1 AS `callee_name`,
  1 AS `callee_num`,
  1 AS `callee_direction`,
  1 AS `call_uuid`,
  1 AS `hostname`,
  1 AS `sent_callee_name`,
  1 AS `sent_callee_num`,
  1 AS `b_uuid`,
  1 AS `b_direction`,
  1 AS `b_created`,
  1 AS `b_created_epoch`,
  1 AS `b_name`,
  1 AS `b_state`,
  1 AS `b_cid_name`,
  1 AS `b_cid_num`,
  1 AS `b_ip_addr`,
  1 AS `b_dest`,
  1 AS `b_presence_id`,
  1 AS `b_presence_data`,
  1 AS `b_accountcode`,
  1 AS `b_callstate`,
  1 AS `b_callee_name`,
  1 AS `b_callee_num`,
  1 AS `b_callee_direction`,
  1 AS `b_sent_callee_name`,
  1 AS `b_sent_callee_num`,
  1 AS `call_created_epoch` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calls` (
  `call_uuid` varchar(255) DEFAULT NULL,
  `call_created` varchar(128) DEFAULT NULL,
  `call_created_epoch` int(11) DEFAULT NULL,
  `caller_uuid` varchar(256) DEFAULT NULL,
  `callee_uuid` varchar(256) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  KEY `callsidx1` (`hostname`),
  KEY `eruuindex` (`caller_uuid`,`hostname`),
  KEY `eeuuindex` (`callee_uuid`),
  KEY `eeuuindex2` (`call_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `channels` (
  `uuid` varchar(256) DEFAULT NULL,
  `direction` varchar(32) DEFAULT NULL,
  `created` varchar(128) DEFAULT NULL,
  `created_epoch` int(11) DEFAULT NULL,
  `name` varchar(1024) DEFAULT NULL,
  `state` varchar(64) DEFAULT NULL,
  `cid_name` varchar(1024) DEFAULT NULL,
  `cid_num` varchar(256) DEFAULT NULL,
  `ip_addr` varchar(256) DEFAULT NULL,
  `dest` varchar(1024) DEFAULT NULL,
  `application` varchar(128) DEFAULT NULL,
  `application_data` text DEFAULT NULL,
  `dialplan` varchar(128) DEFAULT NULL,
  `context` varchar(128) DEFAULT NULL,
  `read_codec` varchar(128) DEFAULT NULL,
  `read_rate` varchar(32) DEFAULT NULL,
  `read_bit_rate` varchar(32) DEFAULT NULL,
  `write_codec` varchar(128) DEFAULT NULL,
  `write_rate` varchar(32) DEFAULT NULL,
  `write_bit_rate` varchar(32) DEFAULT NULL,
  `secure` varchar(64) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  `presence_id` varchar(4096) DEFAULT NULL,
  `presence_data` text DEFAULT NULL,
  `accountcode` varchar(256) DEFAULT NULL,
  `callstate` varchar(64) DEFAULT NULL,
  `callee_name` varchar(1024) DEFAULT NULL,
  `callee_num` varchar(256) DEFAULT NULL,
  `callee_direction` varchar(5) DEFAULT NULL,
  `call_uuid` varchar(256) DEFAULT NULL,
  `sent_callee_name` varchar(1024) DEFAULT NULL,
  `sent_callee_num` varchar(256) DEFAULT NULL,
  `initial_cid_name` varchar(1024) DEFAULT NULL,
  `initial_cid_num` varchar(256) DEFAULT NULL,
  `initial_ip_addr` varchar(256) DEFAULT NULL,
  `initial_dest` varchar(1024) DEFAULT NULL,
  `initial_dialplan` varchar(128) DEFAULT NULL,
  `initial_context` varchar(128) DEFAULT NULL,
  KEY `chidx1` (`hostname`),
  KEY `uuindex` (`uuid`,`hostname`),
  KEY `uuindex2` (`call_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `complete` (
  `sticky` int(11) DEFAULT NULL,
  `a1` varchar(128) DEFAULT NULL,
  `a2` varchar(128) DEFAULT NULL,
  `a3` varchar(128) DEFAULT NULL,
  `a4` varchar(128) DEFAULT NULL,
  `a5` varchar(128) DEFAULT NULL,
  `a6` varchar(128) DEFAULT NULL,
  `a7` varchar(128) DEFAULT NULL,
  `a8` varchar(128) DEFAULT NULL,
  `a9` varchar(128) DEFAULT NULL,
  `a10` varchar(128) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  KEY `complete1` (`a1`,`hostname`),
  KEY `complete2` (`a2`,`hostname`),
  KEY `complete3` (`a3`,`hostname`),
  KEY `complete4` (`a4`,`hostname`),
  KEY `complete5` (`a5`,`hostname`),
  KEY `complete6` (`a6`,`hostname`),
  KEY `complete7` (`a7`,`hostname`),
  KEY `complete8` (`a8`,`hostname`),
  KEY `complete9` (`a9`,`hostname`),
  KEY `complete10` (`a10`,`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `detailed_calls` AS SELECT
 1 AS `uuid`,
  1 AS `direction`,
  1 AS `created`,
  1 AS `created_epoch`,
  1 AS `name`,
  1 AS `state`,
  1 AS `cid_name`,
  1 AS `cid_num`,
  1 AS `ip_addr`,
  1 AS `dest`,
  1 AS `application`,
  1 AS `application_data`,
  1 AS `dialplan`,
  1 AS `context`,
  1 AS `read_codec`,
  1 AS `read_rate`,
  1 AS `read_bit_rate`,
  1 AS `write_codec`,
  1 AS `write_rate`,
  1 AS `write_bit_rate`,
  1 AS `secure`,
  1 AS `hostname`,
  1 AS `presence_id`,
  1 AS `presence_data`,
  1 AS `accountcode`,
  1 AS `callstate`,
  1 AS `callee_name`,
  1 AS `callee_num`,
  1 AS `callee_direction`,
  1 AS `call_uuid`,
  1 AS `sent_callee_name`,
  1 AS `sent_callee_num`,
  1 AS `b_uuid`,
  1 AS `b_direction`,
  1 AS `b_created`,
  1 AS `b_created_epoch`,
  1 AS `b_name`,
  1 AS `b_state`,
  1 AS `b_cid_name`,
  1 AS `b_cid_num`,
  1 AS `b_ip_addr`,
  1 AS `b_dest`,
  1 AS `b_application`,
  1 AS `b_application_data`,
  1 AS `b_dialplan`,
  1 AS `b_context`,
  1 AS `b_read_codec`,
  1 AS `b_read_rate`,
  1 AS `b_read_bit_rate`,
  1 AS `b_write_codec`,
  1 AS `b_write_rate`,
  1 AS `b_write_bit_rate`,
  1 AS `b_secure`,
  1 AS `b_hostname`,
  1 AS `b_presence_id`,
  1 AS `b_presence_data`,
  1 AS `b_accountcode`,
  1 AS `b_callstate`,
  1 AS `b_callee_name`,
  1 AS `b_callee_num`,
  1 AS `b_callee_direction`,
  1 AS `b_call_uuid`,
  1 AS `b_sent_callee_name`,
  1 AS `b_sent_callee_num`,
  1 AS `call_created_epoch` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `interfaces` (
  `type` varchar(128) DEFAULT NULL,
  `name` varchar(1024) DEFAULT NULL,
  `description` varchar(4096) DEFAULT NULL,
  `ikey` varchar(1024) DEFAULT NULL,
  `filename` varchar(4096) DEFAULT NULL,
  `syntax` varchar(4096) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nat` (
  `sticky` int(11) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `proto` int(11) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  KEY `nat_map_port_proto` (`port`,`proto`,`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recovery` (
  `runtime_uuid` varchar(255) DEFAULT NULL,
  `technology` varchar(255) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `metadata` text DEFAULT NULL,
  KEY `recovery1` (`technology`),
  KEY `recovery2` (`profile_name`),
  KEY `recovery3` (`uuid`),
  KEY `recovery4` (`runtime_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `registrations` (
  `reg_user` varchar(256) DEFAULT NULL,
  `realm` varchar(256) DEFAULT NULL,
  `token` varchar(256) DEFAULT NULL,
  `url` text DEFAULT NULL,
  `expires` int(11) DEFAULT NULL,
  `network_ip` varchar(256) DEFAULT NULL,
  `network_port` varchar(256) DEFAULT NULL,
  `network_proto` varchar(256) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  `metadata` varchar(256) DEFAULT NULL,
  KEY `regindex1` (`reg_user`,`realm`,`hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_authentication` (
  `nonce` varchar(255) DEFAULT NULL,
  `expires` bigint(20) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `last_nc` int(11) DEFAULT NULL,
  `algorithm` int(11) NOT NULL DEFAULT 1,
  KEY `sa_nonce` (`nonce`),
  KEY `sa_hostname` (`hostname`),
  KEY `sa_expires` (`expires`),
  KEY `sa_last_nc` (`last_nc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_dialogs` (
  `call_id` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `sip_to_user` varchar(255) DEFAULT NULL,
  `sip_to_host` varchar(255) DEFAULT NULL,
  `sip_from_user` varchar(255) DEFAULT NULL,
  `sip_from_host` varchar(255) DEFAULT NULL,
  `contact_user` varchar(255) DEFAULT NULL,
  `contact_host` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `direction` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `presence_id` varchar(255) DEFAULT NULL,
  `presence_data` varchar(255) DEFAULT NULL,
  `call_info` varchar(255) DEFAULT NULL,
  `call_info_state` varchar(255) DEFAULT '',
  `expires` bigint(20) DEFAULT 0,
  `status` varchar(255) DEFAULT NULL,
  `rpid` varchar(255) DEFAULT NULL,
  `sip_to_tag` varchar(255) DEFAULT NULL,
  `sip_from_tag` varchar(255) DEFAULT NULL,
  `rcd` int(11) NOT NULL DEFAULT 0,
  KEY `sd_uuid` (`uuid`),
  KEY `sd_hostname` (`hostname`),
  KEY `sd_presence_data` (`presence_data`),
  KEY `sd_call_info` (`call_info`),
  KEY `sd_call_info_state` (`call_info_state`),
  KEY `sd_expires` (`expires`),
  KEY `sd_rcd` (`rcd`),
  KEY `sd_sip_to_tag` (`sip_to_tag`),
  KEY `sd_sip_from_user` (`sip_from_user`),
  KEY `sd_sip_from_host` (`sip_from_host`),
  KEY `sd_sip_to_host` (`sip_to_host`),
  KEY `sd_presence_id` (`presence_id`),
  KEY `sd_call_id` (`call_id`),
  KEY `sd_sip_from_tag` (`sip_from_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_presence` (
  `sip_user` varchar(255) DEFAULT NULL,
  `sip_host` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `rpid` varchar(255) DEFAULT NULL,
  `expires` bigint(20) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `network_ip` varchar(255) DEFAULT NULL,
  `network_port` varchar(6) DEFAULT NULL,
  `open_closed` varchar(255) DEFAULT NULL,
  KEY `sp_hostname` (`hostname`),
  KEY `sp_open_closed` (`open_closed`),
  KEY `sp_sip_user` (`sip_user`),
  KEY `sp_sip_host` (`sip_host`),
  KEY `sp_profile_name` (`profile_name`),
  KEY `sp_expires` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_registrations` (
  `call_id` varchar(255) DEFAULT NULL,
  `sip_user` varchar(255) DEFAULT NULL,
  `sip_host` varchar(255) DEFAULT NULL,
  `presence_hosts` varchar(255) DEFAULT NULL,
  `contact` varchar(1024) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `ping_status` varchar(255) DEFAULT NULL,
  `ping_count` int(11) DEFAULT NULL,
  `ping_time` bigint(20) DEFAULT NULL,
  `force_ping` int(11) DEFAULT NULL,
  `rpid` varchar(255) DEFAULT NULL,
  `expires` bigint(20) DEFAULT NULL,
  `ping_expires` int(11) NOT NULL DEFAULT 0,
  `user_agent` varchar(255) DEFAULT NULL,
  `server_user` varchar(255) DEFAULT NULL,
  `server_host` varchar(255) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `network_ip` varchar(255) DEFAULT NULL,
  `network_port` varchar(6) DEFAULT NULL,
  `sip_username` varchar(255) DEFAULT NULL,
  `sip_realm` varchar(255) DEFAULT NULL,
  `mwi_user` varchar(255) DEFAULT NULL,
  `mwi_host` varchar(255) DEFAULT NULL,
  `orig_server_host` varchar(255) DEFAULT NULL,
  `orig_hostname` varchar(255) DEFAULT NULL,
  `sub_host` varchar(255) DEFAULT NULL,
  KEY `sr_call_id` (`call_id`),
  KEY `sr_sip_user` (`sip_user`),
  KEY `sr_sip_host` (`sip_host`),
  KEY `sr_sub_host` (`sub_host`),
  KEY `sr_mwi_user` (`mwi_user`),
  KEY `sr_mwi_host` (`mwi_host`),
  KEY `sr_profile_name` (`profile_name`),
  KEY `sr_presence_hosts` (`presence_hosts`),
  KEY `sr_contact` (`contact`),
  KEY `sr_expires` (`expires`),
  KEY `sr_ping_expires` (`ping_expires`),
  KEY `sr_hostname` (`hostname`),
  KEY `sr_status` (`status`),
  KEY `sr_ping_status` (`ping_status`),
  KEY `sr_network_ip` (`network_ip`),
  KEY `sr_network_port` (`network_port`),
  KEY `sr_sip_username` (`sip_username`),
  KEY `sr_sip_realm` (`sip_realm`),
  KEY `sr_orig_server_host` (`orig_server_host`),
  KEY `sr_orig_hostname` (`orig_hostname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_shared_appearance_dialogs` (
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `contact_str` varchar(255) DEFAULT NULL,
  `call_id` varchar(255) DEFAULT NULL,
  `network_ip` varchar(255) DEFAULT NULL,
  `expires` bigint(20) DEFAULT NULL,
  KEY `ssd_profile_name` (`profile_name`),
  KEY `ssd_hostname` (`hostname`),
  KEY `ssd_contact_str` (`contact_str`),
  KEY `ssd_call_id` (`call_id`),
  KEY `ssd_expires` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_shared_appearance_subscriptions` (
  `subscriber` varchar(255) DEFAULT NULL,
  `call_id` varchar(255) DEFAULT NULL,
  `aor` varchar(255) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `contact_str` varchar(255) DEFAULT NULL,
  `network_ip` varchar(255) DEFAULT NULL,
  KEY `ssa_hostname` (`hostname`),
  KEY `ssa_network_ip` (`network_ip`),
  KEY `ssa_subscriber` (`subscriber`),
  KEY `ssa_profile_name` (`profile_name`),
  KEY `ssa_aor` (`aor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sip_subscriptions` (
  `proto` varchar(255) DEFAULT NULL,
  `sip_user` varchar(255) DEFAULT NULL,
  `sip_host` varchar(255) DEFAULT NULL,
  `sub_to_user` varchar(255) DEFAULT NULL,
  `sub_to_host` varchar(255) DEFAULT NULL,
  `presence_hosts` varchar(255) DEFAULT NULL,
  `event` varchar(255) DEFAULT NULL,
  `contact` varchar(1024) DEFAULT NULL,
  `call_id` varchar(255) DEFAULT NULL,
  `full_from` varchar(255) DEFAULT NULL,
  `full_via` varchar(255) DEFAULT NULL,
  `expires` bigint(20) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `accept` varchar(255) DEFAULT NULL,
  `profile_name` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `network_port` varchar(6) DEFAULT NULL,
  `network_ip` varchar(255) DEFAULT NULL,
  `version` int(11) NOT NULL DEFAULT 0,
  `orig_proto` varchar(255) DEFAULT NULL,
  `full_to` varchar(255) DEFAULT NULL,
  KEY `ss_call_id` (`call_id`),
  KEY `ss_multi` (`call_id`,`profile_name`,`hostname`),
  KEY `ss_hostname` (`hostname`),
  KEY `ss_network_ip` (`network_ip`),
  KEY `ss_sip_user` (`sip_user`),
  KEY `ss_sip_host` (`sip_host`),
  KEY `ss_presence_hosts` (`presence_hosts`),
  KEY `ss_event` (`event`),
  KEY `ss_proto` (`proto`),
  KEY `ss_sub_to_user` (`sub_to_user`),
  KEY `ss_sub_to_host` (`sub_to_host`),
  KEY `ss_expires` (`expires`),
  KEY `ss_orig_proto` (`orig_proto`),
  KEY `ss_network_port` (`network_port`),
  KEY `ss_profile_name` (`profile_name`),
  KEY `ss_version` (`version`),
  KEY `ss_full_from` (`full_from`),
  KEY `ss_contact` (`contact`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `task_id` int(11) DEFAULT NULL,
  `task_desc` varchar(4096) DEFAULT NULL,
  `task_group` varchar(1024) DEFAULT NULL,
  `task_runtime` bigint(20) DEFAULT NULL,
  `task_sql_manager` int(11) DEFAULT NULL,
  `hostname` varchar(256) DEFAULT NULL,
  KEY `tasks1` (`hostname`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50001 DROP VIEW IF EXISTS `basic_calls`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `basic_calls` AS select `a`.`uuid` AS `uuid`,`a`.`direction` AS `direction`,`a`.`created` AS `created`,`a`.`created_epoch` AS `created_epoch`,`a`.`name` AS `name`,`a`.`state` AS `state`,`a`.`cid_name` AS `cid_name`,`a`.`cid_num` AS `cid_num`,`a`.`ip_addr` AS `ip_addr`,`a`.`dest` AS `dest`,`a`.`presence_id` AS `presence_id`,`a`.`presence_data` AS `presence_data`,`a`.`accountcode` AS `accountcode`,`a`.`callstate` AS `callstate`,`a`.`callee_name` AS `callee_name`,`a`.`callee_num` AS `callee_num`,`a`.`callee_direction` AS `callee_direction`,`a`.`call_uuid` AS `call_uuid`,`a`.`hostname` AS `hostname`,`a`.`sent_callee_name` AS `sent_callee_name`,`a`.`sent_callee_num` AS `sent_callee_num`,`b`.`uuid` AS `b_uuid`,`b`.`direction` AS `b_direction`,`b`.`created` AS `b_created`,`b`.`created_epoch` AS `b_created_epoch`,`b`.`name` AS `b_name`,`b`.`state` AS `b_state`,`b`.`cid_name` AS `b_cid_name`,`b`.`cid_num` AS `b_cid_num`,`b`.`ip_addr` AS `b_ip_addr`,`b`.`dest` AS `b_dest`,`b`.`presence_id` AS `b_presence_id`,`b`.`presence_data` AS `b_presence_data`,`b`.`accountcode` AS `b_accountcode`,`b`.`callstate` AS `b_callstate`,`b`.`callee_name` AS `b_callee_name`,`b`.`callee_num` AS `b_callee_num`,`b`.`callee_direction` AS `b_callee_direction`,`b`.`sent_callee_name` AS `b_sent_callee_name`,`b`.`sent_callee_num` AS `b_sent_callee_num`,`c`.`call_created_epoch` AS `call_created_epoch` from ((`channels` `a` left join `calls` `c` on(`a`.`uuid` = `c`.`caller_uuid` and `a`.`hostname` = `c`.`hostname`)) left join `channels` `b` on(`b`.`uuid` = `c`.`callee_uuid` and `b`.`hostname` = `c`.`hostname`)) where `a`.`uuid` = `c`.`caller_uuid` or !(`a`.`uuid` in (select `calls`.`callee_uuid` from `calls`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `detailed_calls`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `detailed_calls` AS select `a`.`uuid` AS `uuid`,`a`.`direction` AS `direction`,`a`.`created` AS `created`,`a`.`created_epoch` AS `created_epoch`,`a`.`name` AS `name`,`a`.`state` AS `state`,`a`.`cid_name` AS `cid_name`,`a`.`cid_num` AS `cid_num`,`a`.`ip_addr` AS `ip_addr`,`a`.`dest` AS `dest`,`a`.`application` AS `application`,`a`.`application_data` AS `application_data`,`a`.`dialplan` AS `dialplan`,`a`.`context` AS `context`,`a`.`read_codec` AS `read_codec`,`a`.`read_rate` AS `read_rate`,`a`.`read_bit_rate` AS `read_bit_rate`,`a`.`write_codec` AS `write_codec`,`a`.`write_rate` AS `write_rate`,`a`.`write_bit_rate` AS `write_bit_rate`,`a`.`secure` AS `secure`,`a`.`hostname` AS `hostname`,`a`.`presence_id` AS `presence_id`,`a`.`presence_data` AS `presence_data`,`a`.`accountcode` AS `accountcode`,`a`.`callstate` AS `callstate`,`a`.`callee_name` AS `callee_name`,`a`.`callee_num` AS `callee_num`,`a`.`callee_direction` AS `callee_direction`,`a`.`call_uuid` AS `call_uuid`,`a`.`sent_callee_name` AS `sent_callee_name`,`a`.`sent_callee_num` AS `sent_callee_num`,`b`.`uuid` AS `b_uuid`,`b`.`direction` AS `b_direction`,`b`.`created` AS `b_created`,`b`.`created_epoch` AS `b_created_epoch`,`b`.`name` AS `b_name`,`b`.`state` AS `b_state`,`b`.`cid_name` AS `b_cid_name`,`b`.`cid_num` AS `b_cid_num`,`b`.`ip_addr` AS `b_ip_addr`,`b`.`dest` AS `b_dest`,`b`.`application` AS `b_application`,`b`.`application_data` AS `b_application_data`,`b`.`dialplan` AS `b_dialplan`,`b`.`context` AS `b_context`,`b`.`read_codec` AS `b_read_codec`,`b`.`read_rate` AS `b_read_rate`,`b`.`read_bit_rate` AS `b_read_bit_rate`,`b`.`write_codec` AS `b_write_codec`,`b`.`write_rate` AS `b_write_rate`,`b`.`write_bit_rate` AS `b_write_bit_rate`,`b`.`secure` AS `b_secure`,`b`.`hostname` AS `b_hostname`,`b`.`presence_id` AS `b_presence_id`,`b`.`presence_data` AS `b_presence_data`,`b`.`accountcode` AS `b_accountcode`,`b`.`callstate` AS `b_callstate`,`b`.`callee_name` AS `b_callee_name`,`b`.`callee_num` AS `b_callee_num`,`b`.`callee_direction` AS `b_callee_direction`,`b`.`call_uuid` AS `b_call_uuid`,`b`.`sent_callee_name` AS `b_sent_callee_name`,`b`.`sent_callee_num` AS `b_sent_callee_num`,`c`.`call_created_epoch` AS `call_created_epoch` from ((`channels` `a` left join `calls` `c` on(`a`.`uuid` = `c`.`caller_uuid` and `a`.`hostname` = `c`.`hostname`)) left join `channels` `b` on(`b`.`uuid` = `c`.`callee_uuid` and `b`.`hostname` = `c`.`hostname`)) where `a`.`uuid` = `c`.`caller_uuid` or !(`a`.`uuid` in (select `calls`.`callee_uuid` from `calls`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*M!999999\- enable the sandbox mode */ 
/*M!999999\- enable the sandbox mode */ 
COMMIT;
