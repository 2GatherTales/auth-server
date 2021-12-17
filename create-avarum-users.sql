-- -----------------------------------------------------
-- Schema avarum_users
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS avarum_users CASCADE;
DROP TABLE IF EXISTS avarum_users.oauth_client_details CASCADE;
DROP TABLE IF EXISTS avarum_users.permission CASCADE;
DROP TABLE IF EXISTS avarum_users.permission CASCADE;
DROP TABLE IF EXISTS avarum_users.permission_role CASCADE;
DROP TABLE IF EXISTS avarum_users.user CASCADE;
DROP TABLE IF EXISTS avarum_users.role_user CASCADE;


CREATE SCHEMA avarum_users;
SHOW search_path;
SET search_path TO avarum_users;

-- -----------------------------------------------------
-- Table avarum_users.oauth_client_details
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS avarum_users.oauth_client_details (
  CLIENT_ID VARCHAR(255) PRIMARY KEY NOT NULL,
  CLIENT_SECRET VARCHAR(255) NOT NULL,
  RESOURCE_IDS VARCHAR(255) DEFAULT NULL,
  SCOPE VARCHAR(255) DEFAULT NULL,
  AUTHORIZED_GRANT_TYPES VARCHAR(255) DEFAULT NULL,
  WEB_SERVER_REDIRECT_URI VARCHAR(255) DEFAULT NULL,
  AUTHORITIES VARCHAR(255) DEFAULT NULL,
  ACCESS_TOKEN_VALIDITY INTEGER DEFAULT NULL,
  REFRESH_TOKEN_VALIDITY INTEGER DEFAULT NULL,
  ADDITIONAL_INFORMATION VARCHAR(4096) DEFAULT NULL,
  AUTOAPPROVE VARCHAR(255) DEFAULT NULL
);

-- -----------------------------------------------------
-- Table avarum_users.permission
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS avarum_users.permission (
  ID BIGSERIAL PRIMARY KEY NOT NULL,
  NAME VARCHAR(60) UNIQUE);

-- -----------------------------------------------------
-- Table avarum_users.role
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS avarum_users.role (
  ID BIGSERIAL PRIMARY KEY NOT NULL,
  NAME VARCHAR(60) UNIQUE);

-- -----------------------------------------------------
-- Table avarum_users.permission_role
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS avarum_users.permission_role (
  ID BIGSERIAL PRIMARY KEY NOT NULL,
  permission_ID BIGINT,
  CONSTRAINT FK_permission_ID FOREIGN KEY (permission_ID) REFERENCES avarum_users.permission (ID),
  role_ID BIGINT,
  CONSTRAINT FK_role_ID FOREIGN KEY (role_ID) REFERENCES avarum_users.role (ID)
);


-- -----------------------------------------------------
-- Table avarum_users.user
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS avarum_users.user (
  ID BIGSERIAl PRIMARY KEY NOT NULL,
  userNAME VARCHAR(24)  UNIQUE NOT NULL,
  PASSWORD VARCHAR(255) NOT NULL,
  EMAIL VARCHAR(255) NOT NULL,
  ENABLED SMALLINT NOT NULL,
  GENDER SMALLINT,
  DISCORDID VARCHAR(255),
  ACCOUNT_EXPIRED SMALLINT NOT NULL,
  CREDENTIALS_EXPIRED SMALLINT NOT NULL,
  ACCOUNT_LOCKED SMALLINT NOT NULL
);


-- -----------------------------------------------------
-- Table avarum_users.role_user
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS avarum_users.role_user
(
    ID BIGSERIAl PRIMARY KEY NOT NULL,
    role_ID BIGINT,
    CONSTRAINT FK_role_ID FOREIGN KEY (role_ID) REFERENCES avarum_users.role (ID),
    user_ID BIGINT,
    CONSTRAINT FK_user_ID FOREIGN KEY (user_ID) REFERENCES avarum_users.user (ID)
);


-- -----------------------------------------------------
-- Add sample data
-- -----------------------------------------------------

 INSERT INTO OAUTH_CLIENT_DETAILS (
	CLIENT_ID,CLIENT_SECRET,
	RESOURCE_IDS,
	SCOPE,
	AUTHORIZED_GRANT_TYPES,
	WEB_SERVER_REDIRECT_URI,AUTHORITIES,
	ACCESS_TOKEN_VALIDITY,REFRESH_TOKEN_VALIDITY,
	ADDITIONAL_INFORMATION,AUTOAPPROVE)
	VALUES(
    'USER_CLIENT_APP','{bcrypt}$2a$10$EOs8VROb14e7ZnydvXECA.4LoIhPOoFHKvVF/iBZ/ker17Eocz4Vi',
	'USER_CLIENT_RESOURCE,USER_ADMIN_RESOURCE',
	'role_admin,role_user',
	'authorization_code,password,refresh_token,implicit',
	NULL,NULL,
	900,3600,
	'{}',NULL);

INSERT INTO permission (NAME) VALUES
('can_create_user'),
('can_update_user'),
('can_read_user'),
('can_delete_user');

INSERT INTO role (NAME) VALUES
('role_admin'),('role_user');

INSERT INTO permission_role (permission_ID, role_ID) VALUES
(1,1), /* can_create_user assigned to role_admin */
(2,1), /* can_update_user assigned to role_admin */
(3,1), /* can_read_user assigned to role_admin */
(4,1), /* can_delete_user assigned to role_admin */
(3,2);  /* can_read_user assigned to role_user */

INSERT INTO avarum_users.user (
userNAME,PASSWORD,
EMAIL, GENDER, ENABLED,ACCOUNT_EXPIRED,CREDENTIALS_EXPIRED,ACCOUNT_LOCKED) VALUES (
'admin', '{bcrypt}$2a$10$EOs8VROb14e7ZnydvXECA.4LoIhPOoFHKvVF/iBZ/ker17Eocz4Vi',
'william@gmail.com', '-1', '1','0','0','0'),
('user', '{bcrypt}$2a$10$EOs8VROb14e7ZnydvXECA.4LoIhPOoFHKvVF/iBZ/ker17Eocz4Vi',
'john@gmail.com', '-1', '1','0','0','0'),
('gui_user', '{bcrypt}$2a$10$EOs8VROb14e7ZnydvXECA.4LoIhPOoFHKvVF/iBZ/ker17Eocz4Vi',
'gui@gmail.com', '1', '1','0','0','0'),
('ani_user', '{bcrypt}$2a$10$EOs8VROb14e7ZnydvXECA.4LoIhPOoFHKvVF/iBZ/ker17Eocz4Vi',
'ani@gmail.com', '0', '1','0','0','0');

INSERT INTO role_user (role_ID, user_ID)
VALUES
(1, 1) /* role_admin assigned to admin user */,
(2, 2) /* role_user assigned to user user */ ,
(2, 3) /* role_user assigned to user user */ ,
(2, 4) /* role_user assigned to user user */ ;
