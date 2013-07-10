<?php
$apiBase = "http://greenupapi.appspot.com/api";
$ch = curl_init($apiBase);
curl_setopt($ch, CURLOPT_HTTPGET, true);
curl_setopt($ch, CURLOPT_HEADER, 0);
// curl_setopt($ch, CURLOPT_POSTFIELDS, $_POST);
header('Content-type: application/json');
$response = curl_exec($ch);
curl_close($ch);


// echo json_encode($response);
?>