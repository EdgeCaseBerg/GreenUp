<?php

require_once('Database.php');

class Comments{

	public static function getAll() {
		try{
			$db = Database::Instance();

			$select = "SELECT comments.id as comment_id, comments.pin_id, comments.content, comments.scope_id, comments.created_time,comments.comment_type, markers.addressed FROM comments LEFT JOIN markers ON comment_id = comments.id WHERE comments.scope_id = 1";
			//$res = $db->query($select);
			$results = $db::$connection->query($select);
			$comments = array();
			while($row = $results->fetch_assoc())
			{
				$comments[] = $row;
			}
			$results->close();
			return $comments;
		}catch(Exception $e){
			return array();
		}
	}
}
