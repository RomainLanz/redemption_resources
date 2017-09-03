USE `essentialmode`;

CREATE TABLE `licenses` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,

  PRIMARY KEY (`id`)
);

CREATE TABLE `user_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `since` datetime NOT NULL,

  PRIMARY KEY (`id`)
);

INSERT INTO `licenses` (name, label) VALUES
  ('weapon', 'Port d\'arme')
;
