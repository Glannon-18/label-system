-- MySQL dump 10.13  Distrib 8.4.6, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: label
-- ------------------------------------------------------
-- Server version	8.4.6

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
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
                             `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
                             `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
                             `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
                             `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
                             `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
                             `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
                             `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
                             `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
                             `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
                             `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
                             `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
                             `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
                             `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
                             `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
                             `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
                             `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
                             `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                             `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                             `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                             `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                             `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                             PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
INSERT INTO `gen_table` VALUES (1,'sys_project','项目表',NULL,NULL,'SysProject','crud','element-plus','com.ruoyi.system','system','project','项目','ruoyi','0','/','{\"parentMenuId\":0}','admin','2025-09-30 14:41:27','','2025-09-30 15:21:37',NULL),(2,'sys_task_package','任务包表',NULL,NULL,'SysTaskPackage','crud','element-plus','com.ruoyi.system','system','package','任务包','ruoyi','0','/','{}','admin','2025-10-02 15:17:49','','2025-10-02 15:20:46',NULL),(3,'sys_task','任务表',NULL,NULL,'SysTask','crud','element-plus','com.ruoyi.system','system','task','任务','ruoyi','0','/','{\"parentMenuId\":0}','admin','2025-10-04 10:10:58','','2025-10-04 10:18:11',NULL),(4,'sys_annotation_data','标注数据表',NULL,NULL,'SysAnnotationData','crud','element-plus','com.ruoyi.label','label','data','标注数据','ruoyi','0','/','{}','admin','2025-10-14 10:55:57','','2025-10-14 11:03:51',NULL);
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
                                    `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
                                    `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
                                    `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
                                    `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
                                    `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
                                    `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
                                    `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
                                    `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
                                    `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
                                    `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
                                    `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
                                    `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
                                    `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
                                    `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
                                    `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
                                    `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
                                    `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
                                    `sort` int DEFAULT NULL COMMENT '排序',
                                    `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                    `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                    PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
INSERT INTO `gen_table_column` VALUES (1,1,'create_by','创建者','varchar(64)','String','createBy','0','0','0','0',NULL,'1','0','EQ','input','',1,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(2,1,'create_time','创建时间','datetime','Date','createTime','0','0','0','0',NULL,'1','1','EQ','datetime','',2,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(3,1,'update_by','更新者','varchar(64)','String','updateBy','0','0','0','0','0','1',NULL,'EQ','input','',3,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(4,1,'update_time','更新时间','datetime','Date','updateTime','0','0','0','0','0','1',NULL,'EQ','datetime','',4,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(5,1,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',5,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(6,1,'project_id','项目ID','bigint','Long','projectId','1','1','0','0',NULL,NULL,NULL,'EQ','input','',6,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(7,1,'name','项目名称','varchar(255)','String','name','0','0','1','1','1','1','1','LIKE','input','',7,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(8,1,'status','状态（0正常 1停用）','varchar(10)','String','status','0','0','0','1','1','1','1','EQ','select','project_status',8,'admin','2025-09-30 14:41:27','','2025-09-30 15:21:37'),(9,2,'create_by','创建者','varchar(64)','String','createBy','0','0','0','0',NULL,'1',NULL,'EQ','input','',1,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(10,2,'create_time','创建时间','datetime','Date','createTime','0','0','0','0',NULL,'1','1','BETWEEN','datetime','',2,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(11,2,'update_by','更新者','varchar(64)','String','updateBy','0','0','0','0','0',NULL,NULL,'EQ','input','',3,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(12,2,'update_time','更新时间','datetime','Date','updateTime','0','0','0','0','0',NULL,NULL,'EQ','datetime','',4,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(13,2,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',5,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(14,2,'task_package_id','任务包id','bigint','Long','taskPackageId','1','1','0','0',NULL,NULL,NULL,'EQ','input','',6,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(15,2,'project_id','关联的项目id','bigint','Long','projectId','0','0','0','0','0','0','0','EQ','input','',7,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(16,2,'name','任务包名','varchar(255)','String','name','0','0','1','1','1','1','1','LIKE','input','',8,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(17,2,'status','任务包状态','varchar(10)','String','status','0','0','0','1','1','1','1','EQ','select','package_status',9,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(18,2,'assigner','分配人账户名','varchar(64)','String','assigner','0','0','0','0','0','0','0','EQ','input','',10,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(19,2,'auditor','审核人账户名','varchar(64)','String','auditor','0','0','0','0','0','0','0','EQ','input','',11,'admin','2025-10-02 15:17:49','','2025-10-02 15:20:46'),(20,3,'task_id','任务ID','bigint','Long','taskId','1','1','0','0',NULL,NULL,NULL,'EQ','input','',1,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(21,3,'package_id','所属包的ID','bigint','Long','packageId','0','0','1','0','0','0','0','EQ','input','',2,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(22,3,'audio_file_name','音频文件名','varchar(255)','String','audioFileName','0','0','1','1','1','1','1','LIKE','fileUpload','',3,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(23,3,'audio_file_path','音频文件在服务器的路径','varchar(500)','String','audioFilePath','0','0','1','0','0','0','0','EQ','textarea','',4,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(24,3,'status','任务状态','varchar(20)','String','status','0','0','0','1','1','1','1','EQ','select','task_status',5,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(25,3,'annotator','分配人账户名','varchar(20)','String','annotator','0','0','0','1','1','1','1','EQ','input','',6,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(26,3,'auditor','审核人员账户名','varchar(20)','String','auditor','0','0','0','1','1','1','1','EQ','input','',7,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(27,3,'create_by','创建者','varchar(20)','String','createBy','0','0','0','0',NULL,'1','1','BETWEEN','input','',8,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(28,3,'create_time','创建时间','datetime','Date','createTime','0','0','0','0',NULL,'1','0','EQ','datetime','',9,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(29,3,'update_by','更新者','varchar(20)','String','updateBy','0','0','0','0','0',NULL,NULL,'EQ','input','',10,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(30,3,'update_time','更新时间','datetime','Date','updateTime','0','0','0','0','0',NULL,NULL,'EQ','datetime','',11,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(31,3,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',12,'admin','2025-10-04 10:10:58','','2025-10-04 10:18:11'),(32,4,'data_id','id主键','bigint unsigned','String','dataId','1','0','0','1',NULL,NULL,NULL,'EQ',NULL,'',1,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(33,4,'task_id','关联的task id','bigint unsigned','String','taskId','0','0','1','1','1','1','1','EQ',NULL,'',2,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(34,4,'data','标注数据（类型longtext）','longtext','String','data','0','0','1','1','1','1','1','EQ','textarea','',3,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(35,4,'version','数据版本号，每次保存递增','int unsigned','String','version','0','0','1','1','1','1','1','EQ',NULL,'',4,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(36,4,'create_time','创建时间','datetime','Date','createTime','0','0','1','1',NULL,NULL,NULL,'EQ','datetime','',5,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(37,4,'create_by','创建者','varchar(255)','String','createBy','0','0','1','1',NULL,NULL,NULL,'EQ','input','',6,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(38,4,'update_by','更新者','varchar(255)','String','updateBy','0','0','1','1','1',NULL,NULL,'EQ','input','',7,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(39,4,'update_time','更新时间','datetime','Date','updateTime','0','0','1','1','1',NULL,NULL,'EQ','datetime','',8,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51'),(40,4,'remark','备注','varchar(500)','String','remark','0','0','0','1','1','1',NULL,'EQ','textarea','',9,'admin','2025-10-14 10:55:58','','2025-10-14 11:03:51');
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
                                      `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                      `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                      `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                      `blob_data` blob COMMENT '存放持久化Trigger对象',
                                      PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
                                      CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
                                  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
                                  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
                                  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
                                      `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                      `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                      `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                      `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
                                      `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
                                      PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
                                      CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
                                       `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                       `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
                                       `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                       `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                       `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
                                       `fired_time` bigint NOT NULL COMMENT '触发的时间',
                                       `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
                                       `priority` int NOT NULL COMMENT '优先级',
                                       `state` varchar(16) NOT NULL COMMENT '状态',
                                       `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
                                       `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
                                       `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
                                       `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
                                       PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
                                    `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                    `job_name` varchar(200) NOT NULL COMMENT '任务名称',
                                    `job_group` varchar(200) NOT NULL COMMENT '任务组名',
                                    `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
                                    `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
                                    `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
                                    `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
                                    `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
                                    `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
                                    `job_data` blob COMMENT '存放持久化job对象',
                                    PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
                              `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                              `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
                              PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
                                            `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                            `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                            PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
                                        `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                        `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
                                        `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
                                        `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
                                        PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
                                        `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                        `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                        `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                        `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
                                        `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
                                        `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
                                        PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
                                        CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
                                         `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                         `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                         `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                         `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
                                         `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
                                         `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
                                         `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
                                         `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
                                         `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
                                         `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
                                         `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
                                         `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
                                         `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
                                         `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
                                         PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
                                         CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
                                 `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                 `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
                                 `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
                                 `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
                                 `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
                                 `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
                                 `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
                                 `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
                                 `priority` int DEFAULT NULL COMMENT '优先级',
                                 `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
                                 `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
                                 `start_time` bigint NOT NULL COMMENT '开始时间',
                                 `end_time` bigint DEFAULT NULL COMMENT '结束时间',
                                 `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
                                 `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
                                 `job_data` blob COMMENT '存放持久化job对象',
                                 PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
                                 KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
                                 CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_annotation_data`
--

DROP TABLE IF EXISTS `sys_annotation_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_annotation_data` (
                                       `data_id` bigint unsigned NOT NULL COMMENT 'id主键',
                                       `task_id` bigint unsigned NOT NULL COMMENT '关联的task id',
                                       `data` longtext NOT NULL COMMENT '标注数据（类型longtext）',
                                       `version` int unsigned NOT NULL DEFAULT '1' COMMENT '数据版本号，每次保存递增',
                                       `create_time` datetime NOT NULL COMMENT '创建时间',
                                       `create_by` varchar(255) NOT NULL COMMENT '创建者',
                                       `update_by` varchar(255) NOT NULL COMMENT '更新者',
                                       `update_time` datetime NOT NULL COMMENT '更新时间',
                                       `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                       PRIMARY KEY (`data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='标注数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_annotation_data`
--

LOCK TABLES `sys_annotation_data` WRITE;
/*!40000 ALTER TABLE `sys_annotation_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_annotation_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
                              `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
                              `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
                              `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
                              `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
                              `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
                              `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                              `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                              `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                              `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                              `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                              PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2025-09-28 15:57:11','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2025-09-28 15:57:11','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2025-09-28 15:57:11','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2025-09-28 15:57:11','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2025-09-28 15:57:11','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2025-09-28 15:57:11','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2025-09-28 15:57:11','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2025-09-28 15:57:11','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
                            `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
                            `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
                            `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
                            `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
                            `order_num` int DEFAULT '0' COMMENT '显示顺序',
                            `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
                            `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
                            `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
                            `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2025-09-28 15:57:08','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
                                 `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
                                 `dict_sort` int DEFAULT '0' COMMENT '字典排序',
                                 `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
                                 `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
                                 `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
                                 `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
                                 `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
                                 `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
                                 `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
                                 `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                 `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                 `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                 `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                 `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                 PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2025-09-28 15:57:11','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2025-09-28 15:57:11','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2025-09-28 15:57:11','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2025-09-28 15:57:11','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2025-09-28 15:57:11','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2025-09-28 15:57:11','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2025-09-28 15:57:11','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2025-09-28 15:57:11','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2025-09-28 15:57:11','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2025-09-28 15:57:11','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2025-09-28 15:57:11','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2025-09-28 15:57:11','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2025-09-28 15:57:11','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2025-09-28 15:57:11','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2025-09-28 15:57:11','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2025-09-28 15:57:11','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2025-09-28 15:57:11','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2025-09-28 15:57:11','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2025-09-28 15:57:11','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2025-09-28 15:57:11','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2025-09-28 15:57:11','',NULL,'停用状态'),(100,0,'越南语','vi','language',NULL,'default','N','0','admin','2025-09-29 15:10:43','',NULL,NULL),(101,1,'泰语','th','language',NULL,'default','N','0','admin','2025-09-29 15:10:58','',NULL,NULL),(102,2,'印尼语','id','language',NULL,'default','N','0','admin','2025-09-29 15:11:17','',NULL,NULL),(103,3,'马来语','ms','language',NULL,'default','N','0','admin','2025-09-29 15:11:32','',NULL,NULL),(104,4,'老挝语','lo','language',NULL,'default','N','0','admin','2025-09-29 15:12:58','',NULL,NULL),(105,5,'缅甸语','my','language',NULL,'default','N','0','admin','2025-09-29 15:13:24','',NULL,NULL),(106,6,'高棉语','km','language',NULL,'default','N','0','admin','2025-09-29 15:13:49','',NULL,NULL),(107,7,'中文','zh','language',NULL,'default','N','0','admin','2025-09-29 15:14:05','',NULL,NULL),(108,8,'英语','en','language',NULL,'default','N','0','admin','2025-09-29 15:14:26','',NULL,NULL),(109,9,'菲律宾语','th','language',NULL,'default','N','0','admin','2025-09-29 15:14:47','',NULL,NULL),(110,0,'进行中','underway','project_status',NULL,'default','N','0','admin','2025-09-30 09:49:41','',NULL,NULL),(111,1,'暂停中','paused','project_status',NULL,'default','N','0','admin','2025-09-30 09:50:20','',NULL,NULL),(112,2,'已完成','accomplish','project_status',NULL,'default','N','0','admin','2025-09-30 09:51:07','',NULL,NULL),(113,0,'未开始','unstart','task_status',NULL,'default','N','0','admin','2025-09-30 09:59:36','',NULL,NULL),(114,1,'标注中','underway','task_status',NULL,'default','N','0','admin','2025-09-30 10:03:11','',NULL,NULL),(115,2,'待审核','pending_review','task_status',NULL,'default','N','0','admin','2025-09-30 10:10:11','',NULL,NULL),(116,3,'审核中','under_review','task_status',NULL,'default','N','0','admin','2025-09-30 10:10:57','admin','2025-09-30 10:11:44',NULL),(117,4,'已驳回','reject','task_status',NULL,'default','N','0','admin','2025-09-30 10:21:34','admin','2025-09-30 10:22:46',NULL),(118,5,'审核通过','pass','task_status',NULL,'default','N','0','admin','2025-09-30 10:22:42','',NULL,NULL),(119,6,'已完成','completed','task_status',NULL,'default','N','0','admin','2025-09-30 10:23:17','',NULL,NULL),(120,0,'未分配','unallocated','package_status',NULL,'default','N','0','admin','2025-09-30 16:46:38','',NULL,NULL),(121,1,'已分配','allocated','package_status',NULL,'default','N','0','admin','2025-10-01 15:26:00','',NULL,NULL),(123,3,'待审核','check','package_status',NULL,'default','N','1','admin','2025-10-01 15:28:53','admin','2025-10-14 15:06:29',NULL),(124,4,'审核通过','pass','package_status',NULL,'default','N','1','admin','2025-10-01 15:29:11','admin','2025-10-14 15:06:33',NULL),(125,5,'审核不通过','no-go','package_status',NULL,'default','N','1','admin','2025-10-10 15:03:58','admin','2025-10-14 15:06:35',NULL),(126,2,'已接收','reception','package_status',NULL,'default','N','0','admin','2025-10-11 09:34:18','admin','2025-10-11 09:34:28',NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
                                 `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
                                 `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
                                 `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
                                 `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
                                 `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                 `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                 `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                 `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                 `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                 PRIMARY KEY (`dict_id`),
                                 UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2025-09-28 15:57:10','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2025-09-28 15:57:11','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2025-09-28 15:57:11','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2025-09-28 15:57:11','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2025-09-28 15:57:11','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2025-09-28 15:57:11','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2025-09-28 15:57:11','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2025-09-28 15:57:11','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2025-09-28 15:57:11','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2025-09-28 15:57:11','',NULL,'登录状态列表'),(100,'语言标识符','language','0','admin','2025-09-29 15:09:55','',NULL,'语言标识符'),(101,'项目状态','project_status','0','admin','2025-09-30 09:47:54','',NULL,NULL),(102,'任务状态','task_status','0','admin','2025-09-30 09:48:52','',NULL,NULL),(103,'任务包状态','package_status','0','admin','2025-09-30 16:44:13','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
                           `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
                           `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
                           `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
                           `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
                           `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
                           `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
                           `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
                           `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
                           `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                           `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                           `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                           `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                           `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
                           PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2025-09-28 15:57:11','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2025-09-28 15:57:11','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2025-09-28 15:57:11','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
                               `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
                               `job_name` varchar(64) NOT NULL COMMENT '任务名称',
                               `job_group` varchar(64) NOT NULL COMMENT '任务组名',
                               `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
                               `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
                               `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
                               `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
                               `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                               PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
                                  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
                                  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
                                  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
                                  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
                                  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
                                  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
                                  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
                                  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
                                  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
                                  PRIMARY KEY (`info_id`),
                                  KEY `idx_sys_logininfor_s` (`status`),
                                  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-29 15:00:19'),(101,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-30 09:20:27'),(102,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-09-30 14:24:34'),(103,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-01 15:21:34'),(104,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-02 13:21:49'),(105,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-02 15:17:18'),(106,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-02 16:25:35'),(107,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-10-03 19:38:44'),(108,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-10-03 19:40:35'),(109,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-03 19:40:38'),(110,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-03 22:08:33'),(111,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-04 10:10:43'),(112,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-04 13:13:55'),(113,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-09 09:31:36'),(114,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-09 10:32:57'),(115,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-10 10:34:14'),(116,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-10 12:01:32'),(117,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-10 14:43:50'),(118,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-10 16:11:12'),(119,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-10 17:27:06'),(120,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-11 09:33:02'),(121,'ruoyi','127.0.0.1','内网IP','Chrome 14','Windows 10','1','用户不存在/密码错误','2025-10-11 10:53:00'),(122,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-11 10:53:10'),(123,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-10-11 11:08:00'),(124,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-11 11:08:03'),(125,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-11 15:07:58'),(126,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-11 15:28:04'),(127,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-11 16:48:33'),(128,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-13 10:13:37'),(129,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-13 14:55:01'),(130,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-13 14:57:27'),(131,'ry','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-14 15:00:28'),(132,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2025-10-14 15:05:35'),(133,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码错误','2025-10-14 15:05:38'),(134,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2025-10-14 15:05:42');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
                            `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
                            `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
                            `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
                            `order_num` int DEFAULT '0' COMMENT '显示顺序',
                            `path` varchar(200) DEFAULT '' COMMENT '路由地址',
                            `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
                            `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
                            `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
                            `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
                            `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
                            `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
                            `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
                            `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
                            `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
                            `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT '' COMMENT '备注',
                            PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2025-09-28 15:57:08','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2025-09-28 15:57:09','',NULL,'系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2025-09-28 15:57:09','',NULL,'系统工具目录'),(4,'若依官网',0,4,'http://ruoyi.vip',NULL,'','',0,0,'M','0','1','','guide','admin','2025-09-28 15:57:09','admin','2025-09-30 15:03:58','若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2025-09-28 15:57:09','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2025-09-28 15:57:09','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2025-09-28 15:57:09','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2025-09-28 15:57:09','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2025-09-28 15:57:09','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2025-09-28 15:57:09','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2025-09-28 15:57:09','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2025-09-28 15:57:09','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2025-09-28 15:57:09','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2025-09-28 15:57:09','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2025-09-28 15:57:09','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2025-09-28 15:57:09','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2025-09-28 15:57:09','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2025-09-28 15:57:09','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2025-09-28 15:57:09','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2025-09-28 15:57:09','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2025-09-28 15:57:09','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2025-09-28 15:57:09','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2025-09-28 15:57:09','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2025-09-28 15:57:09','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2025-09-28 15:57:09','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2025-09-28 15:57:09','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2025-09-28 15:57:09','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2025-09-28 15:57:09','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2025-09-28 15:57:09','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2025-09-28 15:57:09','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2025-09-28 15:57:09','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2025-09-28 15:57:09','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2025-09-28 15:57:09','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2025-09-28 15:57:09','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2025-09-28 15:57:09','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2025-09-28 15:57:09','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2025-09-28 15:57:09','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2025-09-28 15:57:09','',NULL,''),(2000,'语音标注',0,3,'label',NULL,NULL,'',1,0,'M','0','0','','clipboard','admin','2025-09-30 15:03:53','admin','2025-09-30 15:04:22',''),(2001,'项目管理',2000,1,'project','label/index',NULL,'',1,0,'C','0','0','label:project:list','#','admin','2025-09-30 15:05:52','admin','2025-10-09 10:44:19','项目菜单'),(2002,'项目查询',2001,1,'#','',NULL,'',1,0,'F','0','0','label:project:query','#','admin','2025-09-30 15:05:53','admin','2025-10-02 16:58:34',''),(2003,'项目新增',2001,2,'#','',NULL,'',1,0,'F','0','0','label:project:add','#','admin','2025-09-30 15:05:53','admin','2025-10-02 16:58:38',''),(2004,'项目修改',2001,3,'#','',NULL,'',1,0,'F','0','0','label:project:edit','#','admin','2025-09-30 15:05:53','admin','2025-10-02 16:58:43',''),(2005,'项目删除',2001,4,'#','',NULL,'',1,0,'F','0','0','label:project:remove','#','admin','2025-09-30 15:05:53','admin','2025-10-02 16:58:47',''),(2006,'项目导出',2001,5,'#','',NULL,'',1,0,'F','0','0','label:project:export','#','admin','2025-09-30 15:05:53','admin','2025-10-02 16:58:56',''),(2007,'我的任务',2000,2,'annotator','label/annotator',NULL,'',1,0,'C','0','0','label:project:list','#','admin','2025-10-11 10:51:15','admin','2025-10-11 10:52:23',''),(2008,'我的审核',2000,3,'auditTask','label/auditTask',NULL,'auditTask',1,0,'C','0','0','label:project:list','#','admin','2025-10-14 15:25:47','admin','2025-10-14 15:26:01','');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
                              `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
                              `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
                              `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
                              `notice_content` longblob COMMENT '公告内容',
                              `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
                              `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                              `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                              `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                              `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                              `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                              PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2025-09-28 15:57:11','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2025-09-28 15:57:11','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
                                `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
                                `title` varchar(50) DEFAULT '' COMMENT '模块标题',
                                `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
                                `method` varchar(200) DEFAULT '' COMMENT '方法名称',
                                `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
                                `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
                                `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
                                `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
                                `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
                                `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
                                `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
                                `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
                                `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
                                `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
                                `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
                                `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
                                `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
                                PRIMARY KEY (`oper_id`),
                                KEY `idx_sys_oper_log_bt` (`business_type`),
                                KEY `idx_sys_oper_log_s` (`status`),
                                KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"语言标识符\",\"dictType\":\"language\",\"params\":{},\"remark\":\"语言标识符\",\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:09:55',12),(101,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"越南语\",\"dictSort\":0,\"dictType\":\"language\",\"dictValue\":\"vi\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:10:43',9),(102,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"泰语\",\"dictSort\":1,\"dictType\":\"language\",\"dictValue\":\"th\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:10:58',8),(103,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"印尼语\",\"dictSort\":2,\"dictType\":\"language\",\"dictValue\":\"id\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:11:17',7),(104,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"马来语\",\"dictSort\":3,\"dictType\":\"language\",\"dictValue\":\"ms\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:11:32',7),(105,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"老挝语\",\"dictSort\":4,\"dictType\":\"language\",\"dictValue\":\"lo\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:12:58',7),(106,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"缅甸语\",\"dictSort\":5,\"dictType\":\"language\",\"dictValue\":\"my\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:13:24',6),(107,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"高棉语\",\"dictSort\":6,\"dictType\":\"language\",\"dictValue\":\"km\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:13:49',7),(108,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"中文\",\"dictSort\":7,\"dictType\":\"language\",\"dictValue\":\"zh\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:14:05',5),(109,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"英语\",\"dictSort\":8,\"dictType\":\"language\",\"dictValue\":\"en\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:14:26',8),(110,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"菲律宾语\",\"dictSort\":9,\"dictType\":\"language\",\"dictValue\":\"th\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-29 15:14:47',7),(111,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"项目状态\",\"dictType\":\"project_status\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 09:47:54',12),(112,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"任务状态\",\"dictType\":\"task_status\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 09:48:52',7),(113,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"进行中\",\"dictSort\":0,\"dictType\":\"project_status\",\"dictValue\":\"underway\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 09:49:41',7),(114,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"暂停中\",\"dictSort\":1,\"dictType\":\"project_status\",\"dictValue\":\"paused\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 09:50:20',6),(115,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已完成\",\"dictSort\":2,\"dictType\":\"project_status\",\"dictValue\":\"accomplish\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 09:51:07',8),(116,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未开始\",\"dictSort\":0,\"dictType\":\"task_status\",\"dictValue\":\"unstart\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 09:59:36',8),(117,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"标注中\",\"dictSort\":1,\"dictType\":\"task_status\",\"dictValue\":\"underway\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:03:11',7),(118,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"待审核\",\"dictSort\":2,\"dictType\":\"task_status\",\"dictValue\":\"pending_review\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:10:11',8),(119,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"审核中\",\"dictSort\":4,\"dictType\":\"task_status\",\"dictValue\":\"under_review\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:10:57',7),(120,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-09-30 10:10:57\",\"default\":false,\"dictCode\":116,\"dictLabel\":\"审核中\",\"dictSort\":3,\"dictType\":\"task_status\",\"dictValue\":\"under_review\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:11:44',25),(121,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已驳回\",\"dictSort\":5,\"dictType\":\"task_status\",\"dictValue\":\"reject\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:21:34',8),(122,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"审核通过\",\"dictSort\":5,\"dictType\":\"task_status\",\"dictValue\":\"pass\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:22:42',6),(123,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-09-30 10:21:34\",\"default\":false,\"dictCode\":117,\"dictLabel\":\"已驳回\",\"dictSort\":4,\"dictType\":\"task_status\",\"dictValue\":\"reject\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:22:46',8),(124,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已完成\",\"dictSort\":6,\"dictType\":\"task_status\",\"dictValue\":\"completed\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 10:23:17',21),(125,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"sys_project\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 14:41:27',45),(126,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"project\",\"className\":\"SysProject\",\"columns\":[{\"capJavaField\":\"CreateBy\",\"columnComment\":\"创建者\",\"columnId\":1,\"columnName\":\"create_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CreateTime\",\"columnComment\":\"创建时间\",\"columnId\":2,\"columnName\":\"create_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createTime\",\"javaType\":\"Date\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UpdateBy\",\"columnComment\":\"更新者\",\"columnId\":3,\"columnName\":\"update_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"updateBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UpdateTime\",\"columnComment\":\"更新时间\",\"columnId\":4,\"columnName\":\"update_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"updateTime\",\"javaType\":\"Date\",\"list\":false,\"params\":','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 14:49:28',22),(127,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_project\"}',NULL,0,NULL,'2025-09-30 14:49:31',186),(128,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"project\",\"className\":\"SysProject\",\"columns\":[{\"capJavaField\":\"CreateBy\",\"columnComment\":\"创建者\",\"columnId\":1,\"columnName\":\"create_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 14:49:28\",\"usableColumn\":false},{\"capJavaField\":\"CreateTime\",\"columnComment\":\"创建时间\",\"columnId\":2,\"columnName\":\"create_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createTime\",\"javaType\":\"Date\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 14:49:28\",\"usableColumn\":false},{\"capJavaField\":\"UpdateBy\",\"columnComment\":\"更新者\",\"columnId\":3,\"columnName\":\"update_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"updateBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 14:49:28\",\"usableColumn\":false},{\"capJavaField\":\"UpdateTime\",\"columnComment\":\"更新时间\",\"columnId\":4,\"columnName\":\"update_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 14:59:34',33),(129,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_project\"}',NULL,0,NULL,'2025-09-30 15:00:09',35),(130,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"语音标注\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"/label\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:03:53',8),(131,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-09-28 15:57:09\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:03:58',5),(132,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2025-09-30 15:03:53\",\"icon\":\"clipboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"语音标注\",\"menuType\":\"M\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"label\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:04:22',5),(133,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"project\",\"className\":\"SysProject\",\"columns\":[{\"capJavaField\":\"CreateBy\",\"columnComment\":\"创建者\",\"columnId\":1,\"columnName\":\"create_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 14:59:34\",\"usableColumn\":false},{\"capJavaField\":\"CreateTime\",\"columnComment\":\"创建时间\",\"columnId\":2,\"columnName\":\"create_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createTime\",\"javaType\":\"Date\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 14:59:34\",\"usableColumn\":false},{\"capJavaField\":\"UpdateBy\",\"columnComment\":\"更新者\",\"columnId\":3,\"columnName\":\"update_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"updateBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 14:59:34\",\"usableColumn\":false},{\"capJavaField\":\"UpdateTime\",\"columnComment\":\"更新时间\",\"columnId\":4,\"columnName\":\"update_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:12:29',55),(134,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_project\"}',NULL,0,NULL,'2025-09-30 15:12:31',45),(135,'项目',1,'com.ruoyi.web.controller.system.SysProjectController.add()','POST',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createTime\":\"2025-09-30 15:16:32\",\"name\":\"111\",\"params\":{},\"projectId\":1,\"remark\":\"221\",\"status\":\"underway\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:16:32',12),(136,'项目',3,'com.ruoyi.web.controller.system.SysProjectController.remove()','DELETE',1,'admin','研发部门','/system/project/1','127.0.0.1','内网IP','[1]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:16:45',7),(137,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"project\",\"className\":\"SysProject\",\"columns\":[{\"capJavaField\":\"CreateBy\",\"columnComment\":\"创建者\",\"columnId\":1,\"columnName\":\"create_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createBy\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 15:12:29\",\"usableColumn\":false},{\"capJavaField\":\"CreateTime\",\"columnComment\":\"创建时间\",\"columnId\":2,\"columnName\":\"create_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"createTime\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 15:12:29\",\"usableColumn\":false},{\"capJavaField\":\"UpdateBy\",\"columnComment\":\"更新者\",\"columnId\":3,\"columnName\":\"update_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"updateBy\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2025-09-30 15:12:29\",\"usableColumn\":false},{\"capJavaField\":\"UpdateTime\",\"columnComment\":\"更新时间\",\"columnId\":4,\"columnName\":\"update_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-09-30 14:41:27\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:21:37',23),(138,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_project\"}',NULL,0,NULL,'2025-09-30 15:21:41',32),(139,'项目',1,'com.ruoyi.web.controller.system.SysProjectController.add()','POST',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createTime\":\"2025-09-30 15:23:51\",\"name\":\"111\",\"params\":{},\"projectId\":2,\"remark\":\"2222\",\"status\":\"underway\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 15:23:51',4),(140,'项目',1,'com.ruoyi.web.controller.system.SysProjectController.add()','POST',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createTime\":\"2025-09-30 16:05:22\",\"name\":\"1111\",\"params\":{},\"projectId\":3,\"remark\":\"1111\",\"status\":\"underway\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 16:05:22',81),(141,'项目',3,'com.ruoyi.web.controller.system.SysProjectController.remove()','DELETE',1,'admin','研发部门','/system/project/2','127.0.0.1','内网IP','[2]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 16:05:28',5),(142,'项目',3,'com.ruoyi.web.controller.system.SysProjectController.remove()','DELETE',1,'admin','研发部门','/system/project/3','127.0.0.1','内网IP','[3]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 16:05:30',7),(143,'项目',1,'com.ruoyi.web.controller.system.SysProjectController.add()','POST',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createTime\":\"2025-09-30 16:05:34\",\"name\":\"11\",\"params\":{},\"projectId\":4,\"remark\":\"22\",\"status\":\"underway\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 16:05:34',5),(144,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"任务包状态\",\"dictType\":\"package_status\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 16:44:13',10),(145,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未分配\",\"dictSort\":0,\"dictType\":\"package_status\",\"dictValue\":\"unallocated\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-09-30 16:46:38',8),(146,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已分配\",\"dictSort\":1,\"dictType\":\"package_status\",\"dictValue\":\"allocated\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-01 15:26:00',11),(147,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"标注中\",\"dictSort\":2,\"dictType\":\"package_status\",\"dictValue\":\"labeling\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-01 15:28:17',8),(148,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"待审核\",\"dictSort\":3,\"dictType\":\"package_status\",\"dictValue\":\"check\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-01 15:28:53',8),(149,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"审核通过\",\"dictSort\":4,\"dictType\":\"package_status\",\"dictValue\":\"pass\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-01 15:29:11',7),(150,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"sys_task_package\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 15:17:49',75),(151,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"package\",\"className\":\"SysTaskPackage\",\"columns\":[{\"capJavaField\":\"CreateBy\",\"columnComment\":\"创建者\",\"columnId\":9,\"columnName\":\"create_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-02 15:17:49\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"createBy\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CreateTime\",\"columnComment\":\"创建时间\",\"columnId\":10,\"columnName\":\"create_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-10-02 15:17:49\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"createTime\",\"javaType\":\"Date\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"BETWEEN\",\"required\":false,\"sort\":2,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UpdateBy\",\"columnComment\":\"更新者\",\"columnId\":11,\"columnName\":\"update_by\",\"columnType\":\"varchar(64)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-02 15:17:49\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":\"updateBy\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":true,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UpdateTime\",\"columnComment\":\"更新时间\",\"columnId\":12,\"columnName\":\"update_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2025-10-02 15:17:49\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isPk\":\"0\",\"isRequired\":\"0\",\"javaField\":','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 15:20:46',39),(152,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_task_package\"}',NULL,0,NULL,'2025-10-02 15:22:14',94),(153,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"system/project/index\",\"createTime\":\"2025-09-30 15:05:52\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"project\",\"perms\":\"label:project:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 16:58:29',19),(154,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-09-30 15:05:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"项目查询\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":2001,\"path\":\"#\",\"perms\":\"label:project:query\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 16:58:34',7),(155,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-09-30 15:05:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"项目新增\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":2001,\"path\":\"#\",\"perms\":\"label:project:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 16:58:38',6),(156,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-09-30 15:05:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"项目修改\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":2001,\"path\":\"#\",\"perms\":\"label:project:edit\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 16:58:43',7),(157,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-09-30 15:05:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"项目删除\",\"menuType\":\"F\",\"orderNum\":4,\"params\":{},\"parentId\":2001,\"path\":\"#\",\"perms\":\"label:project:remove\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 16:58:47',7),(158,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"\",\"createTime\":\"2025-09-30 15:05:53\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2006,\"menuName\":\"项目导出\",\"menuType\":\"F\",\"orderNum\":5,\"params\":{},\"parentId\":2001,\"path\":\"#\",\"perms\":\"label:project:export\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 16:58:56',8),(159,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/index\",\"createTime\":\"2025-09-30 15:05:52\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"项目\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"project\",\"perms\":\"label:project:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-02 17:01:19',26),(160,'项目',1,'com.ruoyi.web.controller.system.SysProjectController.add()','POST',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-03 19:44:50\",\"name\":\"22\",\"params\":{},\"projectId\":5,\"remark\":\"2222\",\"status\":\"underway\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-03 19:44:50',114),(161,'项目',2,'com.ruoyi.web.controller.system.SysProjectController.edit()','PUT',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createTime\":\"2025-09-30 16:05:34\",\"name\":\"112\",\"params\":{},\"projectId\":4,\"remark\":\"22\",\"status\":\"underway\",\"updateBy\":\"admin\",\"updateTime\":\"2025-10-03 20:14:44\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-03 20:14:44',8),(162,'项目',2,'com.ruoyi.web.controller.system.SysProjectController.edit()','PUT',1,'admin','研发部门','/system/project','127.0.0.1','内网IP','{\"createTime\":\"2025-09-30 16:05:34\",\"name\":\"1122333\",\"params\":{},\"projectId\":4,\"remark\":\"22\",\"status\":\"underway\",\"updateBy\":\"admin\",\"updateTime\":\"2025-10-03 20:15:41\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-03 20:15:41',6),(163,'任务包',1,'com.ruoyi.web.controller.system.SysTaskPackageController.add()','POST',1,'admin','研发部门','/system/package','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-03 22:10:24\",\"name\":\"1112\",\"params\":{},\"projectId\":4,\"remark\":\"333\",\"status\":\"unallocated\"}',NULL,1,'\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'status\' at row 1\r\n### The error may exist in file [D:\\label-system\\ruoyi-system\\target\\classes\\mapper\\system\\SysTaskPackageMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysTaskPackageMapper.insertSysTaskPackage-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_task_package          ( create_by,             create_time,                                       remark,             project_id,             name,             status )           values ( ?,             ?,                                       ?,             ?,             ?,             ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'status\' at row 1\n; Data truncation: Data too long for column \'status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'status\' at row 1','2025-10-03 22:10:24',53),(164,'任务包',1,'com.ruoyi.web.controller.system.SysTaskPackageController.add()','POST',1,'admin','研发部门','/system/package','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-03 22:10:41\",\"name\":\"1112\",\"params\":{},\"projectId\":4,\"remark\":\"333\",\"status\":\"unallocated\"}',NULL,1,'\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'status\' at row 1\r\n### The error may exist in file [D:\\label-system\\ruoyi-system\\target\\classes\\mapper\\system\\SysTaskPackageMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysTaskPackageMapper.insertSysTaskPackage-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_task_package          ( create_by,             create_time,                                       remark,             project_id,             name,             status )           values ( ?,             ?,                                       ?,             ?,             ?,             ? )\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'status\' at row 1\n; Data truncation: Data too long for column \'status\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Data too long for column \'status\' at row 1','2025-10-03 22:10:41',4),(165,'任务包',1,'com.ruoyi.web.controller.system.SysTaskPackageController.add()','POST',1,'admin','研发部门','/system/package','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-03 22:11:37\",\"name\":\"1112\",\"params\":{},\"projectId\":4,\"remark\":\"333\",\"status\":\"unallocated\",\"taskPackageId\":1}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-03 22:11:37',12),(166,'任务包',1,'com.ruoyi.web.controller.system.SysTaskPackageController.add()','POST',1,'admin','研发部门','/system/package','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-03 22:12:05\",\"name\":\"55\",\"params\":{},\"projectId\":4,\"remark\":\"5555\",\"status\":\"unallocated\",\"taskPackageId\":2}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-03 22:12:05',6),(167,'任务包',2,'com.ruoyi.web.controller.system.SysTaskPackageController.edit()','PUT',1,'admin','研发部门','/system/package','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-03 22:12:06\",\"name\":\"55\",\"params\":{},\"projectId\":4,\"remark\":\"555566\",\"status\":\"unallocated\",\"taskPackageId\":2,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-03 22:15:01\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-03 22:15:01',6),(168,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"sys_task\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-04 10:10:58',77),(169,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"task\",\"className\":\"SysTask\",\"columns\":[{\"capJavaField\":\"TaskId\",\"columnComment\":\"任务ID\",\"columnId\":20,\"columnName\":\"task_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"taskId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"PackageId\",\"columnComment\":\"所属包的ID\",\"columnId\":21,\"columnName\":\"package_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"1\",\"javaField\":\"packageId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"AudioFileName\",\"columnComment\":\"音频文件名\",\"columnId\":22,\"columnName\":\"audio_file_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"fileUpload\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"audioFileName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"AudioFilePath\",\"columnComment\":\"音频文件在服务器的路径\",\"columnId\":23,\"columnName\":\"audio_file_path\",\"columnType\":\"varchar(500)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"is','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-04 10:14:50',39),(170,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_task\"}',NULL,0,NULL,'2025-10-04 10:14:57',148),(171,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"task\",\"className\":\"SysTask\",\"columns\":[{\"capJavaField\":\"TaskId\",\"columnComment\":\"任务ID\",\"columnId\":20,\"columnName\":\"task_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"taskId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-10-04 10:14:50\",\"usableColumn\":false},{\"capJavaField\":\"PackageId\",\"columnComment\":\"所属包的ID\",\"columnId\":21,\"columnName\":\"package_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":false,\"insert\":false,\"isEdit\":\"0\",\"isIncrement\":\"0\",\"isInsert\":\"0\",\"isList\":\"0\",\"isPk\":\"0\",\"isQuery\":\"0\",\"isRequired\":\"1\",\"javaField\":\"packageId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":false,\"query\":false,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-10-04 10:14:50\",\"usableColumn\":false},{\"capJavaField\":\"AudioFileName\",\"columnComment\":\"音频文件名\",\"columnId\":22,\"columnName\":\"audio_file_name\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"fileUpload\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"audioFileName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2025-10-04 10:14:50\",\"usableColumn\":false},{\"capJavaField\":\"AudioFilePath\",\"columnComment\":\"音频文件在服务器的路径\",\"columnId\":23,\"columnName\":\"audio_file_path\",\"columnType\":\"varchar(500)\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 10:10:58\",\"dictType\":\"\",\"edit\":false','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-04 10:18:11',36),(172,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_task\"}',NULL,0,NULL,'2025-10-04 10:18:18',39),(173,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"annotator\":\"\",\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004133004A001.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:30:15\",\"params\":{},\"remark\":\"1222\",\"status\":\"unstart\"}',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'package_id\' doesn\'t have a default value\r\n### The error may exist in file [D:\\label-system\\ruoyi-system\\target\\classes\\mapper\\system\\SysTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysTaskMapper.insertSysTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_task          ( audio_file_name,                          status,             annotator,                          create_by,             create_time,                                       remark )           values ( ?,                          ?,             ?,                          ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLException: Field \'package_id\' doesn\'t have a default value\n; Field \'package_id\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'package_id\' doesn\'t have a default value','2025-10-04 13:30:15',46),(174,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"annotator\":\"\",\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004133004A001.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:30:28\",\"params\":{},\"remark\":\"1222\",\"status\":\"unstart\"}',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'package_id\' doesn\'t have a default value\r\n### The error may exist in file [D:\\label-system\\ruoyi-system\\target\\classes\\mapper\\system\\SysTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysTaskMapper.insertSysTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_task          ( audio_file_name,                          status,             annotator,                          create_by,             create_time,                                       remark )           values ( ?,                          ?,             ?,                          ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLException: Field \'package_id\' doesn\'t have a default value\n; Field \'package_id\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'package_id\' doesn\'t have a default value','2025-10-04 13:30:28',4),(175,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"annotator\":\"\",\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004133443A002.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:36:14\",\"packageId\":1,\"params\":{},\"remark\":\"324\",\"status\":\"unstart\"}',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'audio_file_path\' doesn\'t have a default value\r\n### The error may exist in file [D:\\label-system\\ruoyi-system\\target\\classes\\mapper\\system\\SysTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysTaskMapper.insertSysTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_task          ( package_id,             audio_file_name,                          status,             annotator,                          create_by,             create_time,                                       remark )           values ( ?,             ?,                          ?,             ?,                          ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLException: Field \'audio_file_path\' doesn\'t have a default value\n; Field \'audio_file_path\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'audio_file_path\' doesn\'t have a default value','2025-10-04 13:36:14',5),(176,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"annotator\":\"\",\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004133443A002.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:36:26\",\"packageId\":1,\"params\":{},\"remark\":\"324\",\"status\":\"unstart\"}',NULL,1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'audio_file_path\' doesn\'t have a default value\r\n### The error may exist in file [D:\\label-system\\ruoyi-system\\target\\classes\\mapper\\system\\SysTaskMapper.xml]\r\n### The error may involve com.ruoyi.system.mapper.SysTaskMapper.insertSysTask-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into sys_task          ( package_id,             audio_file_name,                          status,             annotator,                          create_by,             create_time,                                       remark )           values ( ?,             ?,                          ?,             ?,                          ?,             ?,                                       ? )\r\n### Cause: java.sql.SQLException: Field \'audio_file_path\' doesn\'t have a default value\n; Field \'audio_file_path\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'audio_file_path\' doesn\'t have a default value','2025-10-04 13:36:26',2),(177,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"annotator\":\"\",\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004134543A004.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:45:45\",\"packageId\":1,\"params\":{},\"remark\":\"324\",\"status\":\"unstart\",\"taskId\":1}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-04 13:45:45',9),(178,'任务',2,'com.ruoyi.web.controller.system.SysTaskController.edit()','PUT',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"annotator\":\"\",\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004134608A005.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:45:45\",\"packageId\":1,\"params\":{},\"remark\":\"324\",\"status\":\"unstart\",\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-04 13:46:09\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-04 13:46:09',7),(179,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"audioFileName\":\"/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004135553A006.wav\",\"createBy\":\"admin\",\"createTime\":\"2025-10-04 13:56:07\",\"packageId\":1,\"params\":{},\"remark\":\"3213\",\"status\":\"unstart\",\"taskId\":2}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-04 13:56:07',7),(180,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/index\",\"createTime\":\"2025-09-30 15:05:52\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"项目管理\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"project\",\"perms\":\"label:project:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-09 10:44:19',0),(181,'任务',1,'com.ruoyi.web.controller.system.SysTaskController.add()','POST',1,'admin','研发部门','/system/task','127.0.0.1','内网IP','{\"audioFileName\":\"/profile/upload/2025/10/10/8月6日(1)_20251010104635A001.WAV\",\"createBy\":\"admin\",\"createTime\":\"2025-10-10 10:46:39\",\"packageId\":1,\"params\":{},\"remark\":\"222\",\"status\":\"unstart\",\"taskId\":3}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 10:46:39',13),(182,'字典类型',3,'com.ruoyi.web.controller.system.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/122','127.0.0.1','内网IP','[122]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 15:02:39',18),(183,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"审核不通过\",\"dictSort\":5,\"dictType\":\"package_status\",\"dictValue\":\"no-go\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 15:03:58',18),(184,'任务包',1,'com.ruoyi.web.controller.label.SysTaskPackageController.add()','POST',1,'admin','研发部门','/label/package','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-10 15:23:02\",\"name\":\"111\",\"params\":{},\"projectId\":5,\"remark\":\"222\",\"status\":\"unallocated\",\"taskPackageId\":3}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 15:23:02',17),(185,'任务包',2,'com.ruoyi.web.controller.label.SysTaskPackageController.assignPackageToUser()','POST',1,'admin','研发部门','/label/package/assign','127.0.0.1','内网IP','{\"assigner\":\"ry\",\"params\":{},\"status\":\"ALLOCATED\",\"taskPackageId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-10 16:47:57\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 16:47:57',18),(186,'任务包',2,'com.ruoyi.web.controller.label.SysTaskPackageController.assignPackageToUser()','POST',1,'admin','研发部门','/label/package/assign','127.0.0.1','内网IP','{\"assigner\":\"ry\",\"params\":{},\"status\":\"allocated\",\"taskPackageId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-10 16:51:56\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 16:51:56',15),(187,'任务包',2,'com.ruoyi.web.controller.label.SysTaskPackageController.assignPackageToUser()','POST',1,'admin','研发部门','/label/package/assign','127.0.0.1','内网IP','{\"assigner\":\"ry\",\"params\":{},\"status\":\"allocated\",\"taskPackageId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-10 16:56:16\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 16:56:16',6),(188,'任务包',3,'com.ruoyi.web.controller.label.SysTaskPackageController.remove()','DELETE',1,'admin','研发部门','/label/package/2','127.0.0.1','内网IP','[2]','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-10 17:40:13',23),(189,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已接收\",\"dictSort\":3,\"dictType\":\"package_status\",\"dictValue\":\"reception\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-11 09:34:19',28),(190,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-11 09:34:18\",\"default\":false,\"dictCode\":126,\"dictLabel\":\"已接收\",\"dictSort\":2,\"dictType\":\"package_status\",\"dictValue\":\"reception\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-11 09:34:28',14),(191,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/annotator\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"我的任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"label/annotator\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-11 10:51:15',16),(192,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/annotator\",\"createTime\":\"2025-10-11 10:51:15\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2007,\"menuName\":\"我的任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"annotator\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-11 10:52:11',0),(193,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/annotator\",\"createTime\":\"2025-10-11 10:51:15\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2007,\"menuName\":\"我的任务\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"annotator\",\"perms\":\"label:project:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-11 10:52:24',16),(194,'角色管理',2,'com.ruoyi.web.controller.system.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"admin\":false,\"createTime\":\"2025-09-28 15:57:08\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117,2000,2001,2002,2003,2004,2005,2006,2007,4],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-11 10:55:16',37),(195,'任务包',2,'com.ruoyi.web.controller.label.SysTaskPackageController.assignPackageToUser()','POST',1,'admin','研发部门','/label/package/assign','127.0.0.1','内网IP','{\"assigner\":\"ry\",\"params\":{},\"status\":\"allocated\",\"taskPackageId\":3,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-13 15:11:48\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-13 15:11:48',22),(196,'代码生成',6,'com.ruoyi.generator.controller.GenController.importTableSave()','POST',1,'admin','研发部门','/tool/gen/importTable','127.0.0.1','内网IP','{\"tables\":\"sys_annotation_data\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 10:55:58',141),(197,'代码生成',2,'com.ruoyi.generator.controller.GenController.synchDb()','GET',1,'admin','研发部门','/tool/gen/synchDb/sys_annotation_data','127.0.0.1','内网IP','{}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 10:56:19',33),(198,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_annotation_data\"}',NULL,0,NULL,'2025-10-14 11:02:55',149),(199,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"data\",\"className\":\"SysAnnotationData\",\"columns\":[{\"capJavaField\":\"DataId\",\"columnComment\":\"id主键\",\"columnId\":32,\"columnName\":\"data_id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2025-10-14 10:55:58\",\"dictType\":\"\",\"edit\":false,\"increment\":false,\"insert\":true,\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"dataId\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-10-14 10:56:18\",\"usableColumn\":false},{\"capJavaField\":\"TaskId\",\"columnComment\":\"关联的task id\",\"columnId\":33,\"columnName\":\"task_id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2025-10-14 10:55:58\",\"dictType\":\"\",\"edit\":true,\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"taskId\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-10-14 10:56:18\",\"usableColumn\":false},{\"capJavaField\":\"Data\",\"columnComment\":\"标注数据（类型longtext）\",\"columnId\":34,\"columnName\":\"data\",\"columnType\":\"longtext\",\"createBy\":\"admin\",\"createTime\":\"2025-10-14 10:55:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"data\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-10-14 10:56:18\",\"usableColumn\":false},{\"capJavaField\":\"Version\",\"columnComment\":\"数据版本号，每次保存递增\",\"columnId\":35,\"columnName\":\"version\",\"columnType\":\"int unsigned\",\"createBy\":\"admin\",\"createTime\":\"2025-10-14 10:55:58\",\"dictType\":\"\",\"edit\":true,\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrem','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 11:03:51',26),(200,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"sys_annotation_data\"}',NULL,0,NULL,'2025-10-14 11:04:03',35),(201,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-01 15:28:53\",\"default\":false,\"dictCode\":123,\"dictLabel\":\"待审核\",\"dictSort\":3,\"dictType\":\"package_status\",\"dictValue\":\"check\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"1\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 15:06:29',9),(202,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-01 15:29:11\",\"default\":false,\"dictCode\":124,\"dictLabel\":\"审核通过\",\"dictSort\":4,\"dictType\":\"package_status\",\"dictValue\":\"pass\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"1\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 15:06:33',7),(203,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2025-10-10 15:03:58\",\"default\":false,\"dictCode\":125,\"dictLabel\":\"审核不通过\",\"dictSort\":5,\"dictType\":\"package_status\",\"dictValue\":\"no-go\",\"isDefault\":\"N\",\"listClass\":\"default\",\"params\":{},\"status\":\"1\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 15:06:35',6),(204,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/auditTask\",\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"我的审核\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2007,\"path\":\"auditTask\",\"perms\":\"label:project:list\",\"routeName\":\"auditTask\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 15:25:47',82),(205,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"component\":\"label/auditTask\",\"createTime\":\"2025-10-14 15:25:47\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2008,\"menuName\":\"我的审核\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2000,\"path\":\"auditTask\",\"perms\":\"label:project:list\",\"routeName\":\"auditTask\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 15:26:01',17),(206,'任务',2,'com.ruoyi.web.controller.label.SysTaskController.audit()','PUT',1,'admin','研发部门','/label/task/audit','127.0.0.1','内网IP','{\"params\":{},\"status\":\"reject\",\"taskId\":1,\"updateBy\":\"admin\",\"updateTime\":\"2025-10-14 15:58:33\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2025-10-14 15:58:33',15);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
                            `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
                            `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
                            `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
                            `post_sort` int NOT NULL COMMENT '显示顺序',
                            `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2025-09-28 15:57:08','',NULL,''),(2,'se','项目经理',2,'0','admin','2025-09-28 15:57:08','',NULL,''),(3,'hr','人力资源',3,'0','admin','2025-09-28 15:57:08','',NULL,''),(4,'user','普通员工',4,'0','admin','2025-09-28 15:57:08','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_project`
--

DROP TABLE IF EXISTS `sys_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_project` (
                               `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
                               `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                               `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
                               `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                               `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                               `project_id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目ID',
                               `name` varchar(255) NOT NULL COMMENT '项目名称',
                               `status` varchar(10) DEFAULT '0' COMMENT '状态（0正常 1停用）',
                               PRIMARY KEY (`project_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='项目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_project`
--

LOCK TABLES `sys_project` WRITE;
/*!40000 ALTER TABLE `sys_project` DISABLE KEYS */;
INSERT INTO `sys_project` VALUES (NULL,'2025-09-30 16:05:34','admin','2025-10-03 20:15:41','22',4,'1122333','underway'),('admin','2025-10-03 19:44:50',NULL,NULL,'2222',5,'22','underway');
/*!40000 ALTER TABLE `sys_project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
                            `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
                            `role_name` varchar(30) NOT NULL COMMENT '角色名称',
                            `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
                            `role_sort` int NOT NULL COMMENT '显示顺序',
                            `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
                            `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
                            `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
                            `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2025-09-28 15:57:08','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2025-09-28 15:57:08','admin','2025-10-11 10:55:16','普通角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 `dept_id` bigint NOT NULL COMMENT '部门ID',
                                 PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 `menu_id` bigint NOT NULL COMMENT '菜单ID',
                                 PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (2,1),(2,2),(2,3),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(2,2000),(2,2001),(2,2002),(2,2003),(2,2004),(2,2005),(2,2006),(2,2007);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_task`
--

DROP TABLE IF EXISTS `sys_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_task` (
                            `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
                            `package_id` bigint NOT NULL COMMENT '所属包的ID',
                            `audio_file_name` varchar(255) NOT NULL COMMENT '音频文件名',
                            `audio_file_path` varchar(500) DEFAULT NULL COMMENT '音频文件在服务器的路径',
                            `status` varchar(20) DEFAULT NULL COMMENT '任务状态',
                            `annotator` varchar(20) DEFAULT NULL COMMENT '分配人账户名',
                            `auditor` varchar(20) DEFAULT NULL COMMENT '审核人员账户名',
                            `create_by` varchar(20) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(20) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`task_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_task`
--

LOCK TABLES `sys_task` WRITE;
/*!40000 ALTER TABLE `sys_task` DISABLE KEYS */;
INSERT INTO `sys_task` VALUES (1,1,'/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004134608A005.wav',NULL,'reject','',NULL,'admin','2025-10-04 13:45:45','admin','2025-10-14 15:58:34','324'),(2,1,'/profile/upload/2025/10/04/Thai_STHB_250906_30_0000_20251004135553A006.wav',NULL,'unstart',NULL,NULL,'admin','2025-10-04 13:56:07','',NULL,'3213'),(3,1,'/profile/upload/2025/10/10/8月6日(1)_20251010104635A001.WAV',NULL,'unstart',NULL,NULL,'admin','2025-10-10 10:46:40','',NULL,'222');
/*!40000 ALTER TABLE `sys_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_task_package`
--

DROP TABLE IF EXISTS `sys_task_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_task_package` (
                                    `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                    `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                    `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                    `task_package_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务包id',
                                    `project_id` bigint DEFAULT NULL COMMENT '关联的项目id',
                                    `name` varchar(255) NOT NULL COMMENT '任务包名',
                                    `status` varchar(20) DEFAULT NULL COMMENT '任务包状态',
                                    `assigner` varchar(64) DEFAULT NULL COMMENT '分配人账户名',
                                    `auditor` varchar(64) DEFAULT NULL COMMENT '审核人账户名',
                                    PRIMARY KEY (`task_package_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务包表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_task_package`
--

LOCK TABLES `sys_task_package` WRITE;
/*!40000 ALTER TABLE `sys_task_package` DISABLE KEYS */;
INSERT INTO `sys_task_package` VALUES ('admin','2025-10-03 22:11:38','admin','2025-10-10 16:56:16','333',1,4,'1112','allocated','ry',NULL),('admin','2025-10-10 15:23:03','admin','2025-10-13 15:11:49','222',3,5,'111','allocated','ry',NULL);
/*!40000 ALTER TABLE `sys_task_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
                            `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                            `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
                            `user_name` varchar(30) NOT NULL COMMENT '用户账号',
                            `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
                            `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
                            `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
                            `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
                            `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
                            `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
                            `password` varchar(100) DEFAULT '' COMMENT '密码',
                            `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
                            `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
                            `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2025-10-14 15:05:42','2025-09-28 15:57:08','admin','2025-09-28 15:57:08','',NULL,'管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2025-10-14 15:00:29','2025-09-28 15:57:08','admin','2025-09-28 15:57:08','',NULL,'测试员');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
                                 `user_id` bigint NOT NULL COMMENT '用户ID',
                                 `post_id` bigint NOT NULL COMMENT '岗位ID',
                                 PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
                                 `user_id` bigint NOT NULL COMMENT '用户ID',
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-14 17:00:18
