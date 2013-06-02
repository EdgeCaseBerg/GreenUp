<?php
include('Grid.php');

$data = json_decode($_POST['data']);
$grid = new Grid();
$previousPoint = $data[0];
for($i=1; $i<sizeof($data); $i++)
{	
	if(round($data[$i]['latitude'],4) !== round($previousPoint['latitude'],4) || round($data[$i]['longitude'],4) !== round($previousPoint['longitude'],4) || $i = (sizeof($data)-1))
	{
		$grid->incrementTime($previousPoint['latitude'], $previousPoint['longitude'], ($data[$i]['timestamp']- $previousPoint['timestamp']));
		$previousPoint = $data[$i];
	}
	
}

echo json_encode(true);

?>