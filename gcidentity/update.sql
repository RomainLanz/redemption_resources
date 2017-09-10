USE `essentialmode`;

ALTER TABLE users
    ADD COLUMN firstname varchar(128) NOT NULL DEFAULT '' ,
    ADD COLUMN lastname varchar(128) NOT NULL DEFAULT '' ,
    ADD COLUMN dateofbirth varchar(128) NOT NULL DEFAULT '' ,
    ADD COLUMN sex varchar(1) NOT NULL DEFAULT 'f' ,
    ADD COLUMN height int(10) unsigned NOT NULL DEFAULT '0' ;