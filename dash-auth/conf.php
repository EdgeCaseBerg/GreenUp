<?php
require "../LocalConfig.php";
$config = new LocalConfig();

define("DB_USER", $config->DB_USER);
define("DB_HOST", $config->HOST);
define("DB_PASS", $config->DB_PASS);
define("DB_NAME", $config->DB_NAME);
define("BASE_INCLUDE", dirname(__FILE__) );
?>
