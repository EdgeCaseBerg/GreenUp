<?php
	require_once('config.php');

	if(isset($_GET['add'])){

		if(isset($_GET['lat'])){
			//We are recieving a message from the maps page of someone adding a comment
			$dbh = new PDO('mysql:host='.HOST.';dbname='.DB_NAME.';', DB_USER, DB_PASS);

			$message = $_GET['message'];
			//Remove any "s from the screen or things will break
			str_replace('"', '', $message);

			$topic=0;
			$topic= $_GET['topic'];

			$sql = "INSERT INTO `talk` (message,fkType) VALUES (:message,:topic);";
			$q = $dbh->prepare($sql);
			$q->execute(array(':message' =>$message,':topic'=>$topic));

			$getId = "SELECT pkId from talk where message = '".$message."' and fkType = " . $topic; ;
			$statment = $dbh->query($getId);

			$returned = $statment->fetchAll();

			error_log(print_r($returned,1));

			$pinQ = "INSERT INTO `pins` (lon,lat,fkType,fkTalkId) VALUES (:lon,:lat,:fkType,:fkTalkId);";

			//Put in the foreign link to the pins table for this comment
			$p= $dbh->prepare($pinQ);
			$p->execute(array(':lon' => $_GET['lon'], ':lat' => $_GET['lat'],':fkType' => $topic, ':fkTalkId' => $returned[0]['pkId'] ));

			


			header('location:/client/index.php?pane=2');
		}else{
			//Handling adding a message from the communication panel
			if(isset($_GET['message'])){
				//Add message
				$dbh = new PDO('mysql:host='.HOST.';dbname='.DB_NAME.';', DB_USER, DB_PASS);

				$message = $_GET['message'];
				//Remove any "s from the screen or things will break
				str_replace('"', '', $message);

				$topic=0;
				if(isset($_GET['topic'])){
					$top = intval($_GET['topic']);
					if($top == 1 || $top ==2 || $top==3){
						//Acceptable value
						$topic=$top;
					}
				}

				$sql = "INSERT INTO `talk` (message,fkType) VALUES (:message,:topic);";
				$q = $dbh->prepare($sql);
				$q->execute(array(':message' =>$message,':topic'=>$topic));

			}

			header('location:/client/index.html');
		}
	}

	$start = 0;
	$end = 10;
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
				$SQL = 'SELECT message FROM `talk` where fkType=1 ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end ;
				break;
			case 'help':
				$SQL = 'SELECT message FROM `talk` where fkType=2 ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end ;
				break;
			case 'trash':
				$SQL = 'SELECT message FROM `talk` where fkType=3 ORDER BY timeSent DESC LIMIT ' . $start . ',' . $end ;
				break;
			default:
				//No Change
				break;
		}
	}
	
	//error_log($SQL);

	$statement = $dbh->prepare($SQL);
	$derp = $statement->execute();

	$results = $statement->fetchAll(PDO::FETCH_COLUMN, 0);



	//Construct the JSON to send to the comm page
	foreach ($results as $key => $message) {
		$result .= '"' . $message . '",';
	}

	//Default No messages message:
	
	if(strcmp($result,'')==0){
		//The random comma the end is because we substr it below
		$result = '"There are no messages to load",'; 
	}

	//Remove the last ,
	$output = '[' . substr($result, 0, -1) . ']';
	
	echo $output;

?>