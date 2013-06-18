<?php
// uses the ip2location service to get initial map info (center the user on the map)
include('lib/ip2locationlite.class.php');
$apiKey = "e21591d300c4bac16c24c588069000db95b0137bfbe4e5a7b9c6a10a0a685c87";


 
//Load the class
$ipLite = new ip2location_lite;
$ipLite->setKey($apiKey);
 
//Get errors and locations
$locations = $ipLite->getCity($_SERVER['REMOTE_ADDR']);
$errors = $ipLite->getError();
 
//Getting the result
echo "<p>\n";
echo "<strong>First result</strong><br />\n";
if (!empty($locations) && is_array($locations)) {
  foreach ($locations as $field => $val) {
    echo $field . ' : ' . $val . "<br />\n";
  }
}
echo "</p>\n";
 
//Show errors
echo "<p>\n";
echo "<strong>Dump of all errors</strong><br />\n";
if (!empty($errors) && is_array($errors)) {
  foreach ($errors as $error) {
    echo var_dump($error) . "<br /><br />\n";
  }
} else {
  echo "No errors" . "<br />\n";
}
echo "</p>\n";