<?php
if(stripos($_SERVER['SERVER_NAME'], "greenup") !== false){
	header("location: http://greenup.xenonapps.com/green-web/dash/");
}else{
	echo $_SERVER['SERVER_NAME'];
}

?>
