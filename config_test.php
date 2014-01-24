<?php
$confText = json_decode(file_get_contents("/etc/conf/local.conf"));
echo("config loaded: <b>GOOD</b><br />");
$con=mysqli_connect($conf["host"],$conf["mysql-user"],$conf["mysql-password"],$conf["db-name"]) or die("db connection: <b>BAD</b>" . mysqli_connect_error());
echo("db connection: <b>GOOD</b><br />");

// Check connection

?>