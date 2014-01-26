<?php
$conf = json_decode(file_get_contents("/etc/conf/local.conf"), 1);
define("DB_USER", $conf["mysql-user"]);
define("DB_HOST", $conf["host"]);
define("HOST", $conf["host"]);
define("DB_PASS", $conf["mysql-password"]);
define("DB_NAME", $conf["db-name"]);

//define("DB_USER", "mysqlUser");
//define("DB_HOST", "dev.xenonapps.com");
//define("DB_PASS", "1k23k4k55j");
//define("DB_NAME", "green_up_vt");
define("BASE_INCLUDE", dirname(__FILE__) );
?>
