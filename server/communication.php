<?php
	require_once('config.php');

	if(isset($_GET['add'])){
		if(isset($_GET['message'])){
			//Add message
			$dbh = new PDO('mysql:host='.HOST.';dbname='.DB_NAME.';', DB_USER, DB_PASS);

			$message = $_GET['message'];
			//Remove any "s from the screen or things will break
			str_replace('"', '', $message);

			$topic=0;
			if(isset($_GET['topic'])){
				$top = intval($_GET['topic']);
				if($top == 0 || $top ==1 || $top==2){
					//Acceptable value
					$topic=$top;
				}
			}

			$sql = "INSERT INTO `talk` (message,fkType) VALUES (:message,:topic);";
			$q = $dbh->prepare($sql);
			$q->execute(array(':message' =>$message,':topic'=>$topic));

		}

		header('location:/client/cardsUI.html');
	}

	$start = 0;
	$end = 20;
	$dbh = new PDO('mysql:host='.HOST.';dbname='.DB_NAME.';', DB_USER, DB_PASS);
	$result = '';
	//Use GET to set the limits of the query for pagination purposes
	if(isset($_GET['start']) && isset($_GET['end'])){
		//Check for numeric value of start and end
		$start = intval($_GET['start']);
		$end = intval($_GET['end']);
	}

	$SQL = 'SELECT message FROM `talk` ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end;
	if(isset($_GET['where'])){
		switch ($_GET['where']) {
			case 'messages':
				$SQL = 'SELECT message FROM `talk` ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end . ' where talk.fkType=0';
				break;
			case 'help':
				$SQL = 'SELECT message FROM `talk` ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end . ' where talk.fkType=1';
				break;
			case 'trash':
				$SQL = 'SELECT message FROM `talk` ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end . ' where talk.fkType=2';
				break;
			default:
				//No Change
				break;
		}
	}
	
	$statement = $dbh->prepare($SQL);
	$statement->execute();

	$results = $statement->fetchAll(PDO::FETCH_COLUMN, 0);

	//Construct the JSON to send to the comm page
	foreach ($results as $key => $message) {
		$result .= '"' . $message . '",';
	}

	//Default No messages message:
	
	if(strcmp($result,'')==0){
		//The random comma the end
		$result = '"There no messages to load",'; 
	}

	//Remove the last ,
	$output = '[' . substr($result, 0, -1) . ']';
	
	echo $output;

?>