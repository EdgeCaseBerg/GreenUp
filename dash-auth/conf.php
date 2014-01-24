<?php
$conf = json_decode(file_get_contents("/etc/conf/local.conf"));
define("DB_USER", $config["mysql-user");
define("DB_HOST", $config["host"]);
define("DB_PASS", $config["mysql-password"]);
define("DB_NAME", $config["db-name"]);

//define("DB_USER", "mysqlUser");
//define("DB_HOST", "dev.xenonapps.com");
//define("DB_PASS", "1k23k4k55j");
//define("DB_NAME", "green_up_vt");
define("BASE_INCLUDE", dirname(__FILE__) );
?>
