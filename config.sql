INSERT INTO `flarum`.`settings`(`key`,`value`) VALUES
  ('mail_host','{{ MAIL_HOST }}'),
  ('mail_port','{{ MAIL_PORT }}'),
  ('mail_username','{{ MAIL_USER }}'),
  ('mail_password','{{ MAIL_PASS }}'),
  ('mail_encryption','{{ MAIL_ENCR }}');

UPDATE `flarum`.`settings` SET `value`='smtp' WHERE `key`='mail_driver';
UPDATE `flarum`.`settings` SET `value`='{{ MAIL_FROM }}' WHERE `key`='mail_from';
