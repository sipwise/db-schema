SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8;
SET SESSION autocommit=0;
SET SESSION unique_checks=0;
CREATE DATABASE ldap;
USE ldap;
/*M!999999\- enable the sandbox mode */ 
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ldap_attr_mappings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `oc_map_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `sel_expr` varchar(255) NOT NULL,
  `sel_expr_u` varchar(255) DEFAULT NULL,
  `from_tbls` varchar(255) NOT NULL,
  `join_where` varchar(255) DEFAULT NULL,
  `add_proc` varchar(255) DEFAULT NULL,
  `delete_proc` varchar(255) DEFAULT NULL,
  `param_order` tinyint(4) NOT NULL,
  `expect_return` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `ldap_entries` AS SELECT
 1 AS `id`,
  1 AS `dn`,
  1 AS `oc_map_id`,
  1 AS `parent`,
  1 AS `keyval` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ldap_oc_mappings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `keytbl` varchar(64) NOT NULL,
  `keycol` varchar(64) NOT NULL,
  `create_proc` varchar(255) DEFAULT NULL,
  `delete_proc` varchar(255) DEFAULT NULL,
  `expect_return` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `org` AS SELECT
 1 AS `id`,
  1 AS `o`,
  1 AS `dc` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `users` AS SELECT
 1 AS `id`,
  1 AS `account_id`,
  1 AS `uuid`,
  1 AS `username`,
  1 AS `password`,
  1 AS `displayname`,
  1 AS `phone` */;
SET character_set_client = @saved_cs_client;
/*!50001 DROP VIEW IF EXISTS `ldap_entries`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ldap_entries` AS select `billing`.`contracts`.`id` AS `id`,concat('o=',`billing`.`contracts`.`id`,',dc=hpbx,dc=sipwise,dc=com') AS `dn`,3 AS `oc_map_id`,0 AS `parent`,`billing`.`contracts`.`id` AS `keyval` from `billing`.`contracts` union select `users`.`id` + 100000 AS `org_id`,concat('uid=',`users`.`uuid`,',o=',`users`.`account_id`,',dc=hpbx,dc=sipwise,dc=com') AS `Name_exp_2`,1 AS `1`,`users`.`account_id` AS `account_id`,`users`.`id` AS `id` from `ldap`.`users` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `org`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `org` AS select `billing`.`contracts`.`id` AS `id`,`billing`.`contracts`.`id` AS `o`,'dc=hpbx,dc=sipwise,dc=com' AS `dc` from `billing`.`contracts` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `users`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `users` AS select `pvs`.`id` AS `id`,`pvs`.`account_id` AS `account_id`,`pvs`.`uuid` AS `uuid`,`pvs`.`username` AS `username`,`pvs`.`password` AS `password`,`vup`.`value` AS `displayname`,`pvs`.`pbx_extension` AS `phone` from ((`provisioning`.`voip_subscribers` `pvs` left join `provisioning`.`voip_preferences` `vp` on(`vp`.`attribute` = 'display_name')) left join `provisioning`.`voip_usr_preferences` `vup` on(`vup`.`subscriber_id` = `pvs`.`id` and `vup`.`attribute_id` = `vp`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*M!999999\- enable the sandbox mode */ 
INSERT INTO `ldap_attr_mappings` VALUES (1,1,'uidNumber','users.id',NULL,'users',NULL,NULL,NULL,3,0);
INSERT INTO `ldap_attr_mappings` VALUES (2,1,'uid','users.uuid',NULL,'users',NULL,NULL,NULL,3,0);
INSERT INTO `ldap_attr_mappings` VALUES (3,1,'userPassword','users.password',NULL,'users',NULL,NULL,NULL,3,0);
INSERT INTO `ldap_attr_mappings` VALUES (4,1,'cn','users.username',NULL,'users',NULL,NULL,NULL,3,0);
INSERT INTO `ldap_attr_mappings` VALUES (5,1,'telephoneNumber','users.phone',NULL,'users',NULL,NULL,NULL,3,0);
INSERT INTO `ldap_attr_mappings` VALUES (6,1,'displayName','users.displayname',NULL,'users',NULL,NULL,NULL,3,0);
INSERT INTO `ldap_oc_mappings` VALUES (1,'inetOrgPerson','users','id',NULL,NULL,0);
INSERT INTO `ldap_oc_mappings` VALUES (3,'organization','org','id',NULL,NULL,0);
/*M!999999\- enable the sandbox mode */ 
COMMIT;
