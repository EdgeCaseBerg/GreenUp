<?php

require_once('Database.php');

class Markers{

	public static function getAll() {
		try{
			$db = Database::Instance();

			$select = "SELECT m.id, m.created_time, m.latitude, m.longitude, m.addressed, c.content as message, c.comment_type
						FROM markers m
						LEFT JOIN comments c
						ON m.comment_id = c.id
						WHERE m.scope_id = 1 ";
			$results = $db::$connection->query($select);
			$markers = array();
			while($row = $results->fetch_assoc())
			{
				$markers[] = $row;
			}
			$results->close();
			return $markers;
		}catch(Exception $e){
			return array();
		}
	}
}
