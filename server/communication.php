<?php
	require_once('config.php');

	$start = 0;
	$end = 40;
	$dbh = new PDO('mysql:host='.HOST.';dbname='.DB_NAME.';', DB_USER, DB_PASS);
	$result = '[';
	//Use GET to set the limits of the query for pagination purposes
	if(isset($_GET['start']) && isset($_GET['end'])){
		//Check for numeric value of start and end
		$start = intval($_GET['start']);
		$end = intval($_GET['end']);




	}else{
		//Default


	}


?>