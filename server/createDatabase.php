<?php
	require_once('config.php');

	$dbh = new PDO('mysql:host='.HOST, DB_USER, DB_PASS);

	//Create the database if it doesn't exist
	echo $dbh->exec("CREATE DATABASE IF NOT EXISTS " . DB_NAME);
	echo $dbh->exec("USE " . DB_NAME);

	//Create Tables if they don't exist
	echo $dbh->exec("CREATE TABLE IF NOT EXISTS `types` (pkId INT(10) AUTO_INCREMENT PRIMARY KEY, description VARCHAR(20) );");
	echo $dbh->exec("CREATE TABLE IF NOT EXISTS `pins` ( pkId INT(10) AUTO_INCREMENT PRIMARY KEY, lon VARCHAR(64), lat VARCHAR(64), fkType INT(10) REFERENCES types(pkId));");
	echo $dbh->exec("CREATE TABLE IF NOT EXISTS `grid` ( pkLat FLOAT(5,10), pkLon FLOAT(5,10), secondsWorked FLOAT(6), PRIMARY KEY(pkLat,pkLon) );") ;
	echo $dbh->exec("CREATE TABLE IF NOT EXISTS `talk` ( pkId INT(16) AUTO_INCREMENT PRIMARY KEY, message TEXT, timeSent TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP );");
	echo $dbh->query("CREATE PROCEDURE incrementTime(lat_pk FLOAT(10),long_pk FLOAT(10),time_spent_new FLOAT(6)) BEGIN INSERT INTO grid (pkLat, pkLong, secondsWorked) VALUES (lat_pk, long_pk, time_spent_new) ON DUPLICATE KEY UPDATE secondsWorked = secondsWorked+time_spent_new; END;");
?>