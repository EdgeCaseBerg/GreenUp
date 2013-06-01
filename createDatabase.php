<?php
	require_once('config.php');

	$dbh = new PDO('mysql:host='.HOST, DB_USER, DB_PASS);

	//Create the database if it doesn't exist
	$dbh->query("CREATE DATABASE IF NOT EXISTS " . DB_NAME);
	$dbh->query("USE " . DB_NAME);

	//Create Tables if they don't exist
	$dbh->query("CREATE TABLE IF NOT EXISTS `types` (pkId INT(10) AUTO_INCREMENT PRIMARY KEY, description VARCHAR(20) );");
	$dbh->query("CREATE TABLE IF NOT EXISTS `pins` ( pkId INT(10) AUTO_INCREMENT PRIMARY KEY, lon VARCHAR(64), lat VARCHAR(64), fkType INT(10) REFERENCES types(pkId));");
	$dbh->query("CREATE TABLE IF NOT EXISTS `grid` ( pkZone CHAR(8) PRIMARY KEY, secondsWorked FLOAT(6) );") ;
	$dbh->query("CREATE TABLE IF NOT EXISTS `talk` ( pkId INT(16) AUTO_INCREMENT PRIMARY KEY, message TEXT );");



?>