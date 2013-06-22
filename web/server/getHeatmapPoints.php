<?php
include('Grid.php');
$grid = new Grid();
header('Content-Type: application/json');
echo $grid->getHeatmapPoints();
?>