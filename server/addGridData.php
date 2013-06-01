<?php
include('Grid.php');

$data = json_decode($_POST['data']);

foreach($data as $point)
{
	Grid::incrementTime($point['lat'], $point['long'], $point['secondsSpent']);
}

?>