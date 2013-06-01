<?php
include('Grid.php');

$data = json_decode($_POST['data']);
$grid = new Grid();
foreach($data as $point)
{
	$grid->incrementTime($point['lat'], $point['long'], $point['secondsSpent']);
}

?>