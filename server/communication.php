<?php
	require_once('config.php');

	$start = 0;
	$end = 40;
	$dbh = new PDO('mysql:host='.HOST.';dbname='.DB_NAME.';', DB_USER, DB_PASS);
	$result = '';
	//Use GET to set the limits of the query for pagination purposes
	if(isset($_GET['start']) && isset($_GET['end'])){
		//Check for numeric value of start and end
		$start = intval($_GET['start']);
		$end = intval($_GET['end']);
	}

	$statement = $dbh->prepare('SELECT message FROM `talk` ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end);
	$statement->execute();

	$results = $statement->fetchAll(PDO::FETCH_COLUMN, 0);

	//Construct the JSON to send to the comm page
	foreach ($results as $key => $message) {
		$result .= '"' . $message . '",';
	}

	//Remove the last ,
	$output = '[' . substr($result, 0, -1) . ']';
	error_log($start . '  to ' . $end);
	echo $output;

?>