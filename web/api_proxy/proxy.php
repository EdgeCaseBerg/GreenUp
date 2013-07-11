<?php

$apiBase = "http://greenupapi.appspot.com/api";


switch($_SERVER['REQUEST_METHOD']){
	case "POST":
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $_POST);
	break;
	case "PUT":
	// http://greenup.xenonapps.com/api/heatmap
	break;
	default:
	// default is GET
		
		$queryString = $apiBase."/".$_SERVER['QUERY_STRING'];
		$ch = curl_init($queryString);
		// $requestUri = $_SERVER['REQUEST_URI'];
		curl_setopt($ch, CURLOPT_HTTPGET, true);
		// echo $queryString."\n";
	// /api/pins
	// http://greenup.xenonapps.com/api/comments?type=needs
	// http://greenup.xenonapps.com/api/heatmap?latDegrees=23.45&latOffset=2.0&lonDegrees=40.3&lonOffset=5.12
	break;
}


// $apiBase = "http://greenupapi.appspot.com/api";
curl_setopt($ch, CURLOPT_HEADER, 0);
// curl_setopt($ch, CURLOPT_POSTFIELDS, $_POST);
// header('Content-type: application/json');
$response = curl_exec($ch);
curl_close($ch);





// echo json_encode($response);
?>