<?php

require_once('Database.php');

class Heatmap{

	public static function getAll() {
		try{
			$db = Database::Instance();

			$select = "SELECT SUM(intensity) as intensity, TIMESTAMP(MAX(created_time)) as created_time, TRUNCATE(latitude, 8) as latitude, TRUNCATE(longitude, 8) as longitude FROM heatmap WHERE scope_id = 1 GROUP BY TRUNCATE(latitude, 8), TRUNCATE(longitude, 8)";
			//$res = $db->query($select);
			$results = $db::$connection->query($select);
			$heatmaps = array();
			while($row = $results->fetch_assoc())
			{
				$heatmaps[] = $row;
			}
			$results->close();
			return $heatmaps;
		}catch(Exception $e){
			return array();
		}
	}
}
