<?php
include('Config.php');

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
		$this->dbh->exec($query);

		$mapdata = array();
		foreach($this->dbh->fetchAll() as $pointData){
			array_push($mapData, "{location: new google.maps.LatLng(".$pointData['pkLat'].", ".$pointData['pkLon']."), weight: ".$pointData['secondsWorked']."}");
		}

		return json_encode($mapData);
	}
}