<?php


class Grid{

	public static function incrementTime($lat, $long, $time_spent){
		$lat_key = round($lat, 4);
		$long_key = round($long, 4);
		$dbh = new PDO('mysql:host='.HOST, DB_USER, DB_PASS);
		$query = "CALL incrementTime ($lat_key, $long_key, $time_spent)";
		return $dbh->query($query);
	}

	public static function getTimeSpent(){
		$dbh = new PDO('mysql:host='.HOST, DB_USER, DB_PASS);
		$query = "SELECT * FROM grid";
		$dbh->query($query);

		$mapdata = array();
		foreach($dbh->fetchAll() as $pointData){
			array_push($mapData, "{location: new google.maps.LatLng(".$pointData['pkLat'].", ".$pointData['pkLong']."), weight: ".$pointData['secondsWorked']."}");
		}

		return json_encode($mapData);
	}
}