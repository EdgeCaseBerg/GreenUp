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
    <link rel="stylesheet" href="css/styles.css">

    <script type="text/javascript"
            src="http://maps.googleapis.com/maps/api/js?libraries=visualization&key=AIzaSyDlth022D4txU5HqXdDs1OZyGX0KdwKXIg&sensor=false"></script>
    <script src="js/markerwithlabel.js"></script>
    <script type="text/javascript" src="js/lawnchair-js.js"></script>
    <script type="text/javascript" src="js/lib/scrollability.js"></script>
    <script type="text/javascript" src="js/JSON.js"></script>
    <script type="text/javascript" src="js/ApiConnector.js"></script>
    <script>
        window.DEBUG = false;
        window.LOGGER = new ClientLogger();
        console.log("user agent: ");
        console.log(window.UAGENT);
    </script>

    <style type="text/css">
        #loadingScreen{
            float:left;
            position:absolute;
            top:0px;
            left:0px;
            width:100%;
            height:100%;
            z-index:1000;
            border:solid 1px green;
            background:url("img/backgrounds/90_percent_black.png");
            display:none;
        }

        #loadingGif{
            height:70px;
            width:60px;
            margin:auto;
            padding-top:35%;
            /*border:solid 1px red;*/
        }
    </style>

</head>

<body >
<!-- <div id="loading">
    <img src="img/startup/ajax-loader.gif">
</div> -->

<div id="container">
    <input type="hidden" id="initLat" value="23" />
    <input type="hidden" id="initLon" value=="22" />
    <div class="panel" id="panel1">
        <!-- Main Page Content -->
        <div id="bodyContainer">
            <img src="img/greenup_logo.png" id="greenupLogo">

            <div id="bodyText">
                <h3>Help keep Vermont green.</h3>
                <ul>
                    <li>Track clean up progress.</li>
                    <li>See what areas need the most help.</li>
                    <li>Find an area to drop off what you pick up.</li>
                </ul>

                <br />
                <br />
                To start greening up VT, hit "start clean up." To find a drop off point or to flag an area, go to the maps page.

                <div id="timeSpentClock">
                    <span id="timeSpentClockDigits"></span>
                    <p class="clockDetail">time spent cleaning up</p>
                </div>


                <div id="startButton" class="bigStartButton">
                    Start Cleaning Up
                </div>
            </div>
        </div>
    </div>

    <!-- map panel -->
    <div class="panel" id="panel2">
        <!-- <div id="mapContainer" class="contentContainer"> -->
        <!-- <div class="mobileContainer"> -->

        <!-- </div> -->

        <div class="mapContainer">
            <input type="hidden" value="0" id="startCoords" />
            <div id="map-canvas"></div>
        </div>
    </div>

    <div class="panel" id="panel3">
        <div id="commentContainer">
            <div id="bubbleContainer" class="scrollable vertical">
                <!-- comments populate here dynamically -->
            </div>
        </div>
    </div>
</div>

<div id="topSlideDown" class="sliderUp">
    <div id="slideContentContainer">
        <div id="panel1SlideDownContent" class="panelSlideDownContent"></div>
        <div id="panel2SlideDownContent" class="panelSlideDownContent"> <!-- map slide down content -->
            <div class="slideDownNest">
                <ul>
                    <li>
                        <label id="toggleHeatLabel" class="filterButton buttonShadow">
                            <input type="checkbox" value="None" id="toggleHeat" onchange="window.MAP.toggleHeatmap()" class="checkboxUnder" name="check"  checked />
                            <p></p>
                            <span>Heat Map</span>
                        </label>
                    </li>

                    <li>
                        <label id="toggleMarkerLabel" class="filterButton buttonShadow">
                            <input type="checkbox" value="None" id="toggleIcons" onchange="window.MAP.toggleIcons()" class="checkboxUnder" name="check"  checked />
                            <p></p>
                            <span>Markers</span>
                        </label>
                    </li>
                </ul>
            </div> <!-- end slide down nest -->
        </div><!-- end map slide down content -->

        <div id="panel3SlideDownContent" class="panelSlideDownContent"> <!-- comments slide down content -->
            <div class="slideDownNest">
                <ul>
                    <li class="filterType">
                        <label id="toggleForumLabel" class="filterButton buttonShadow">
                            <input type="checkbox" value="None" id="toggleForum" onchange="window.Comments.toggleComments('forum')" class="checkboxUnder" name="check"  checked />
                            Forum
                        </label>
                    </li>
                    <li class="filterType">
                        <label id ="toggleNeedsLabel" class="filterButton buttonShadow">
                            <input type="checkbox" value="None" id="toggleNeeds" onchange="window.Comments.toggleComments('needs')" class="checkboxUnder" name="check" checked />
                            Needs
                        </label>
                    </li>
                    <li class="filterType">
                        <label id="toggleMessagesLabel" class="filterButton buttonShadow">
                            <input type="checkbox" value="None" id="toggleMessages" onchange="window.Comments.toggleComments('message')" class="checkboxUnder" name="check" checked />
                            Messages
                        </label>
                    </li>
                    <li><div class="addCommentButton commentButton" id="addCommentButton" onclick="window.UI.showMarkerTypeSelect('comment')">+ New Comment</div></li>
                    <input type="hidden" id="commentTypeToBePosted" value="null" />
                    <input type="hidden" id="commentToBePosted" value="null" />
                </ul>
            </div>
        </div><!-- end comments slide down content -->
    </div>

    <div id="hamburgerNest">
        <div id="hamburger" class="hamburger"></div>
    </div>
</div>

<div id="loadingScreen">
    <div id="loadingGif">
        <img src="img/ajax-loader.gif" />
    </div>
    <div id="loadingText" style="color:white; width:100%; text-align:center;"></div>
</div>

<div id="markerTypeDialog">
    <div class="tileContainer">
        <div class="tile tile1" id="selectBlueComment">Admin</div>
        <div class="tile tile2" id="selectYellowComment">Hazard</div>
        <div class="tile tile3" id="selectGreenComment">Comment</div>
        <div class="tile tile4" id="cancel">Cancel</div>
    </div>
</div>

<div id="dialogSlider">
    <div id="dialogSliderNest">
        <textarea id="dialogSliderTextarea" class="dialogSliderContents" maxlength="140"></textarea>
        <div class="dialogSliderContents" id="dialogSliderContents">
            <input type="hidden" id="comment_type" value="forum" />
            <input type="hidden" id="comment_message" value="null" />
            <input type="hidden" id="input_purpose"/>
            <div class="dialogSliderButton dialogButtonOk"><div id="dialogCommentOk" class="buttonText">Ok</div></div>
            <div class="dialogSliderButton dialogButtonCancel"><div id="dialogCommentCancel" class="buttonText">Cancel</div></div>
        </div>
    </div>
</div>

<div id="navPullUpNest">
    <div id="navbarPullUpTab"></div>
</div>
<div id="navContainer">
    <ul class="nav" id="navbar">
        <li><a id="homeNavButton" class="nav1">Home</a></li>
        <li><a id="mapsNavButton" class="nav2">Maps</a></li>
        <li><a id="commentsNavButton" class="nav3">Comments</a></li>
    </ul>
</div>


</body>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-47079120-3', 'xenonapps.com');
  ga('send', 'pageview');

</script>
</html>
