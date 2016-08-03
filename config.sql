INSERT INTO `{{ DB_NAME }}`.`settings`(`key`,`value`) VALUES
  ('mail_host','{{ MAIL_HOST }}'),
  ('mail_port','{{ MAIL_PORT }}'),
  ('mail_username','{{ MAIL_USER }}'),
  ('mail_password','{{ MAIL_PASS }}'),
  ('mail_encryption','{{ MAIL_ENCR }}');

UPDATE `{{ DB_NAME }}`.`settings` SET `value`='smtp' WHERE `key`='mail_driver';
UPDATE `{{ DB_NAME }}`.`settings` SET `value`='{{ MAIL_FROM }}' WHERE `key`='mail_from';
