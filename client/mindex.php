<?php
// use our local config to get the path so that we can both work
// and each use our own settings
$confText = json_decode(file_get_contents("/etc/conf/local.conf"), 1);
echo "<script>window.PROXY = '".$confText['proxy-path']."';console.log(window.PROXY);";
echo "window.UAGENT = '".$_SERVER['HTTP_USER_AGENT']."';";
echo "window.IP = '".$_SERVER['SERVER_ADDR']."'</script>";

if(stripos($_SERVER['HTTP_USER_AGENT'], "phone") === false && stripos($_SERVER['HTTP_USER_AGENT'], "android") === false ){
    if(!isset($_GET['frame'])){
//            header("Location: welcome.html");
    }
}


?>

<!DOCTYPE html>
<html>
<head>
    <!--    <meta name="viewport" content="width=device-width, initial-scale=1, target-densityDpi=96"/>-->
    <meta name="viewport" content="height=device-height,width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no">

    <!-- Prototype fonts -->
    <link href='http://fonts.googleapis.com/css?family=Armata' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Roboto' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="css/mstyles.css">

    <script type="text/javascript"
            src="http://maps.googleapis.com/maps/api/js?libraries=visualization&key=AIzaSyDlth022D4txU5HqXdDs1OZyGX0KdwKXIg&sensor=false"></script>
    <script src="js/markerwithlabel.js"></script>
    <script type="text/javascript" src="js/lawnchair-js.js"></script>
    <script type="text/javascript" src="js/JSON.js"></script>
    <script type="text/javascript" src="js/ApiConnector.js"></script>
    <script>
        window.DEBUG = true;
        window.LOGGER = new ClientLogger();
        console.log("user agent: ");
        console.log(window.UAGENT);

        document.body.addEventListener('touchmove', function(e) {
            // This prevents native scrolling from happening.
            e.preventDefault();
        }, false);

    </script>
</head>

<body>
<div class=”TOP_TOOLBAR”>
    ... toolbar content ...
</div>
<div class=”SCROLLER_FRAME”>
    <div class=”SCROLLER”>
        ... scrollable content ...
    </div>
</div>
<div class=”BOTTOM_TOOLBAR”>
    ... toolbar content ...
</div>
</body>

