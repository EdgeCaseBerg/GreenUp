<?php
include('Grid.php');


// $dataPoint['lat']= 47.1234;
// $dataPoint['long']= -73.9877;
// $dataPoint['seconds']=1300;
// error_log("Json Data Points");
// error_log(json_encode(array($dataPoint, $dataPoint)));


$data = $_POST['data'];
$grid = new Grid();
$previousPoint = $data[0];

for($i=1; $i<sizeof($data); $i++){

	if(round($data[$i]['value']['latitude'],4) !== round($previousPoint['value']['latitude'],4) || round($data[$i]['value']['longitude'],4) !== round($previousPoint['value']['longitude'],4) || $i = (sizeof($data)-1))
	{
		$grid->incrementTime($previousPoint['value']['latitude'], $previousPoint['value']['longitude'], ($data[$i]['value']['datetime'] - $previousPoint['value']['datetime']));
		$previousPoint = $data[$i];
	}
}

echo json_encode(true);

?>