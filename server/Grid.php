<?php
include('config.php');

class Grid{

	public function __construct(){
		$this->dbh = new PDO('mysql:host='.HOST, DB_USER, DB_PASS);
	}

	public function incrementTime($lat, $long, $time_spent){
		$lat_key = round($lat, 4);
		$long_key = round($long, 4);
		$query = "CALL incrementTime ($lat_key, $long_key, $time_spent)";
		return $this->dbh->exec($query);
	}

	public function getHeatmapPoints(){
		$query = "SELECT * FROM grid";
		$this->dbh->exec($query);

		$mapdata = array();
		foreach($this->dbh->fetchAll() as $pointData){
			array_push($mapData, "{location: new google.maps.LatLng(".$pointData['pkLat'].", ".$pointData['pkLong']."), weight: ".$pointData['secondsWorked']."}");
		}

		return json_encode($mapData);
	}
}