-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: localhost    Database: hydra
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `hydra`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hydra` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hydra`;

--
-- Table structure for table `hydra_client`
--

DROP TABLE IF EXISTS `hydra_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_client` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_secret` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect_uris` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `grant_types` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `response_types` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `policy_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tos_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `contacts` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_secret_expires_at` int NOT NULL DEFAULT '0',
  `sector_identifier_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `jwks` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `jwks_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_uris` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token_endpoint_auth_method` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `request_object_signing_alg` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `userinfo_signed_response_alg` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `subject_type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `allowed_cors_origins` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pk` int unsigned NOT NULL AUTO_INCREMENT,
  `audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `frontchannel_logout_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `frontchannel_logout_session_required` tinyint(1) NOT NULL DEFAULT '0',
  `post_logout_redirect_uris` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `backchannel_logout_uri` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `backchannel_logout_session_required` tinyint(1) NOT NULL DEFAULT '0',
  `metadata` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token_endpoint_auth_signing_alg` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `registration_access_token_signature` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`pk`),
  UNIQUE KEY `hydra_client_idx_id_uq` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_jwk`
--

DROP TABLE IF EXISTS `hydra_jwk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_jwk` (
  `sid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` int NOT NULL DEFAULT '0',
  `keydata` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pk` int unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`pk`),
  UNIQUE KEY `hydra_jwk_idx_id_uq` (`sid`,`kid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_authentication_session`
--

DROP TABLE IF EXISTS `hydra_oauth2_authentication_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_authentication_session` (
  `id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `authenticated_at` timestamp NULL DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `hydra_oauth2_authentication_session_sub_idx` (`subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_authentication_request`
--

DROP TABLE IF EXISTS `hydra_oauth2_authentication_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_authentication_request` (
  `challenge` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `verifier` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `csrf` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `skip` tinyint(1) NOT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `authenticated_at` timestamp NULL DEFAULT NULL,
  `oidc_context` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_session_id` varchar(40) COLLATE utf8mb4_unicode_ci,
  `requested_at_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`challenge`),
  UNIQUE KEY `hydra_oauth2_authentication_request_veri_idx` (`verifier`),
  KEY `hydra_oauth2_authentication_request_cid_idx` (`client_id`),
  KEY `hydra_oauth2_authentication_request_sub_idx` (`subject`),
  KEY `hydra_oauth2_authentication_request_login_session_id_idx` (`login_session_id`),
  CONSTRAINT `hydra_oauth2_authentication_request_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_authentication_request_login_session_id_fk` FOREIGN KEY (`login_session_id`) REFERENCES `hydra_oauth2_authentication_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_consent_request`
--

DROP TABLE IF EXISTS `hydra_oauth2_consent_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_consent_request` (
  `challenge` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verifier` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `skip` tinyint(1) NOT NULL,
  `requested_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `csrf` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `authenticated_at` timestamp NULL DEFAULT NULL,
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `oidc_context` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `forced_subject_identifier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `login_session_id` varchar(40) COLLATE utf8mb4_unicode_ci,
  `login_challenge` varchar(40) COLLATE utf8mb4_unicode_ci,
  `requested_at_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `acr` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `context` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `amr` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`challenge`),
  UNIQUE KEY `hydra_oauth2_consent_request_veri_idx` (`verifier`),
  KEY `hydra_oauth2_consent_request_cid_idx` (`client_id`),
  KEY `hydra_oauth2_consent_request_sub_idx` (`subject`),
  KEY `hydra_oauth2_consent_request_login_session_id_idx` (`login_session_id`),
  KEY `hydra_oauth2_consent_request_login_challenge_idx` (`login_challenge`),
  KEY `hydra_oauth2_consent_request_client_id_subject_idx` (`client_id`,`subject`),
  CONSTRAINT `hydra_oauth2_consent_request_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_consent_request_login_challenge_fk` FOREIGN KEY (`login_challenge`) REFERENCES `hydra_oauth2_authentication_request` (`challenge`) ON DELETE SET NULL,
  CONSTRAINT `hydra_oauth2_consent_request_login_session_id_fk` FOREIGN KEY (`login_session_id`) REFERENCES `hydra_oauth2_authentication_session` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_consent_request_handled`
--

DROP TABLE IF EXISTS `hydra_oauth2_consent_request_handled`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_consent_request_handled` (
  `challenge` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember` tinyint(1) NOT NULL,
  `remember_for` int NOT NULL,
  `error` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `session_access_token` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_id_token` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `authenticated_at` timestamp NULL DEFAULT NULL,
  `was_used` tinyint(1) NOT NULL,
  `granted_at_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `handled_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`challenge`),
  CONSTRAINT `hydra_oauth2_consent_request_handled_challenge_fk` FOREIGN KEY (`challenge`) REFERENCES `hydra_oauth2_consent_request` (`challenge`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_access`
--

DROP TABLE IF EXISTS `hydra_oauth2_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_access` (
  `signature` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `form_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `requested_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `challenge_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`signature`),
  KEY `hydra_oauth2_access_requested_at_idx` (`requested_at`),
  KEY `hydra_oauth2_access_client_id_idx` (`client_id`),
  KEY `hydra_oauth2_access_challenge_id_idx` (`challenge_id`),
  KEY `hydra_oauth2_access_client_id_subject_idx` (`client_id`,`subject`),
  KEY `hydra_oauth2_access_request_id_idx` (`request_id`),
  CONSTRAINT `hydra_oauth2_access_challenge_id_fk` FOREIGN KEY (`challenge_id`) REFERENCES `hydra_oauth2_consent_request_handled` (`challenge`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_access_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_authentication_request_handled`
--

DROP TABLE IF EXISTS `hydra_oauth2_authentication_request_handled`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_authentication_request_handled` (
  `challenge` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember` tinyint(1) NOT NULL,
  `remember_for` int NOT NULL,
  `error` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `acr` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `authenticated_at` timestamp NULL DEFAULT NULL,
  `was_used` tinyint(1) NOT NULL,
  `forced_subject_identifier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `context` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `amr` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`challenge`),
  CONSTRAINT `hydra_oauth2_authentication_request_handled_challenge_fk` FOREIGN KEY (`challenge`) REFERENCES `hydra_oauth2_authentication_request` (`challenge`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_code`
--

DROP TABLE IF EXISTS `hydra_oauth2_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_code` (
  `signature` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `form_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `requested_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `challenge_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`signature`),
  KEY `hydra_oauth2_code_client_id_idx` (`client_id`),
  KEY `hydra_oauth2_code_challenge_id_idx` (`challenge_id`),
  KEY `hydra_oauth2_code_request_id_idx` (`request_id`),
  CONSTRAINT `hydra_oauth2_code_challenge_id_fk` FOREIGN KEY (`challenge_id`) REFERENCES `hydra_oauth2_consent_request_handled` (`challenge`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_code_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_jti_blacklist`
--

DROP TABLE IF EXISTS `hydra_oauth2_jti_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_jti_blacklist` (
  `signature` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`signature`),
  KEY `hydra_oauth2_jti_blacklist_expiry` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_logout_request`
--

DROP TABLE IF EXISTS `hydra_oauth2_logout_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_logout_request` (
  `challenge` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verifier` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sid` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `request_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `redir_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `was_used` tinyint(1) NOT NULL DEFAULT '0',
  `accepted` tinyint(1) NOT NULL DEFAULT '0',
  `rejected` tinyint(1) NOT NULL DEFAULT '0',
  `rp_initiated` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`challenge`),
  UNIQUE KEY `hydra_oauth2_logout_request_veri_idx` (`verifier`),
  KEY `hydra_oauth2_logout_request_client_id_idx` (`client_id`),
  CONSTRAINT `hydra_oauth2_logout_request_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_obfuscated_authentication_session`
--

DROP TABLE IF EXISTS `hydra_oauth2_obfuscated_authentication_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_obfuscated_authentication_session` (
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_obfuscated` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`subject`,`client_id`),
  UNIQUE KEY `hydra_oauth2_obfuscated_authentication_session_so_idx` (`client_id`,`subject_obfuscated`),
  CONSTRAINT `hydra_oauth2_obfuscated_authentication_session_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_oidc`
--

DROP TABLE IF EXISTS `hydra_oauth2_oidc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_oidc` (
  `signature` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `form_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `requested_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `challenge_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`signature`),
  KEY `hydra_oauth2_oidc_client_id_idx` (`client_id`),
  KEY `hydra_oauth2_oidc_challenge_id_idx` (`challenge_id`),
  KEY `hydra_oauth2_oidc_request_id_idx` (`request_id`),
  CONSTRAINT `hydra_oauth2_oidc_challenge_id_fk` FOREIGN KEY (`challenge_id`) REFERENCES `hydra_oauth2_consent_request_handled` (`challenge`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_oidc_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_pkce`
--

DROP TABLE IF EXISTS `hydra_oauth2_pkce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_pkce` (
  `signature` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `form_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `requested_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `challenge_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`signature`),
  KEY `hydra_oauth2_pkce_client_id_idx` (`client_id`),
  KEY `hydra_oauth2_pkce_challenge_id_idx` (`challenge_id`),
  KEY `hydra_oauth2_pkce_request_id_idx` (`request_id`),
  CONSTRAINT `hydra_oauth2_pkce_challenge_id_fk` FOREIGN KEY (`challenge_id`) REFERENCES `hydra_oauth2_consent_request_handled` (`challenge`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_pkce_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_refresh`
--

DROP TABLE IF EXISTS `hydra_oauth2_refresh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_refresh` (
  `signature` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `form_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `requested_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `granted_audience` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `challenge_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`signature`),
  KEY `hydra_oauth2_refresh_client_id_idx` (`client_id`),
  KEY `hydra_oauth2_refresh_challenge_id_idx` (`challenge_id`),
  KEY `hydra_oauth2_refresh_client_id_subject_idx` (`client_id`,`subject`),
  KEY `hydra_oauth2_refresh_request_id_idx` (`request_id`),
  CONSTRAINT `hydra_oauth2_refresh_challenge_id_fk` FOREIGN KEY (`challenge_id`) REFERENCES `hydra_oauth2_consent_request_handled` (`challenge`) ON DELETE CASCADE,
  CONSTRAINT `hydra_oauth2_refresh_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `hydra_client` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hydra_oauth2_trusted_jwt_bearer_issuer`
--

DROP TABLE IF EXISTS `hydra_oauth2_trusted_jwt_bearer_issuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hydra_oauth2_trusted_jwt_bearer_issuer` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issuer` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scope` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `key_set` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `key_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `allow_any_subject` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `issuer` (`issuer`,`subject`,`key_id`),
  KEY `key_set` (`key_set`,`key_id`),
  KEY `hydra_oauth2_trusted_jwt_bearer_issuer_expires_at_idx` (`expires_at`),
  CONSTRAINT `hydra_oauth2_trusted_jwt_bearer_issuer_ibfk_1` FOREIGN KEY (`key_set`, `key_id`) REFERENCES `hydra_jwk` (`sid`, `kid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migration`
--

DROP TABLE IF EXISTS `schema_migration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migration` (
  `version` varchar(48) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version_self` int NOT NULL DEFAULT '0',
  UNIQUE KEY `schema_migration_version_idx` (`version`),
  KEY `schema_migration_version_self_idx` (`version_self`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-22 11:01:58
