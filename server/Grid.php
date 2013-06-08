<?php
include('config.php');

class Grid{

	public function __construct(){
		$this->dbh = new PDO('mysql:host='.HOST, DB_USER, DB_PASS);
		$this->dbh->exec("USE " . DB_NAME);
	}

	public function incrementTime($lat, $long, $time_spent){
		$lat_key = round($lat, 4);
		$long_key = round($long, 4);
		$query = "CALL incrementTime ($lat_key, $long_key, $time_spent)";
		error_log($this->dbh->exec($query));
		error_log($query);
	}

	public function getHeatmapPoints(){
		$query = "SELECT * FROM grid";
		$statement = $this->dbh->query($query);
		$mapData = array();
		$returnArr = $statement->fetchAll();
		$arrSize =  count($returnArr);
		for($ii=0; $ii<$arrSize; $ii++){
			$dataStr = "{location: new google.maps.LatLng(".$returnArr[$ii]['pkLat'].", ".$returnArr[$ii]['pkLon']."), weight: ".$returnArr[$ii]['secondsWorked']."}";
			array_push($mapData, $dataStr);
		}
		return json_encode($mapData);
	}
}

