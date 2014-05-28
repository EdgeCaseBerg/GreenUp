<?php

// $apiBase = "http://greenupapi.appspot.com/api";

// // error_log($_GET);
// switch($_SERVER['REQUEST_METHOD']){
	
// 	case "POST":
// 		$jsonObj = json_decode($_POST['json']);
// 		// $jsonObj = $_POST['json'];
// 		error_log($_POST['json']);
// 		$ch = curl_init($apiBase."/pins");
// 		curl_setopt($ch, CURLOPT_POST, true);
// 		// curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonObj);
// 		curl_setopt($handle, CURLOPT_POSTFIELDS, urlencode($POST));
// 		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
// 		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));          
//     	// curl_setopt($ch, CURLOPT_HTTPHEADER,     array('Content-Type: text/plain'));                                                              
// 	break;
// 	case "PUT":
// 		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//         curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
//         parse_str(file_get_contents("php://input"),$put_vars);
//         curl_setopt($ch, CURLOPT_POSTFIELDS,http_build_query($put_vars));
// 	// http://greenup.xenonapps.com/api/heatmap
// 	break;
// 	default:
// 	// default is GET
		
// 		$queryString = $apiBase."/".$_SERVER['QUERY_STRING'];
// 		$ch = curl_init($queryString);
// 		// $requestUri = $_SERVER['REQUEST_URI'];
// 		curl_setopt($ch, CURLOPT_HTTPGET, true);
// 		// echo $queryString."\n";
// 	// /api/pins
// 	// http://greenup.xenonapps.com/api/comments?type=needs
// 	// http://greenup.xenonapps.com/api/heatmap?latDegrees=23.45&latOffset=2.0&lonDegrees=40.3&lonOffset=5.12
// 	break;
// }


// // $apiBase = "http://greenupapi.appspot.com/api";
// curl_setopt($ch, CURLOPT_HEADER, 0);
// // curl_setopt($ch, CURLOPT_POSTFIELDS, $_POST);
// // header('Content-type: application/json');
// $response = curl_exec($ch);
// curl_close($ch);





// echo json_encode($response);
?>