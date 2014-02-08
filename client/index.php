<?php
if(stripos($_SERVER['HTTP_USER_AGENT'], "phone") === false && stripos($_SERVER['HTTP_USER_AGENT'], "android") === false ){
    if(!isset($_GET['frame'])){
//            header("Location: welcome.html");
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, target-densityDpi=96"/>


    <!-- Prototype fonts -->
    <link href='https://fonts.googleapis.com/css?family=Armata' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Roboto' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="css/styles.css">

    <script type="text/javascript"
            src="https://maps.googleapis.com/maps/api/js?libraries=visualization&key=AIzaSyDlth022D4txU5HqXdDs1OZyGX0KdwKXIg&sensor=false"></script>
    <script src="js/markerwithlabel.js"></script>
    <script type="text/javascript" src="js/lawnchair-js.js"></script>
    <script type="text/javascript" src="js/JSON.js"></script>
    <script type="text/javascript" src="js/ApiConnector.js"></script>
    <script>
        window.DEBUG = true;
        window.LOGGER = new ClientLogger();
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
                <p><h3>Help keep Vermont green.</h3>Track clean up progress.<br />See what areas need the
                most help.<br /> Find an area to drop off what you pick up.
                <br />
                <br />
                To start greening up VT, hit "start clean up." To find a drop off point or to flag an area, go to the maps page.
                </p>

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

    <div class="panel" id="panel3" onscroll="window.Comments.updateScroll(this)">
        <div id="commentContainer">
            <div id="bubbleContainer">
                <!-- comments populate here dynamically -->
            </div>
        </div>
    </div>
</div>

<div id="topSlideDown" class="sliderUp">
    <div id="slideContentContainer">
        <div id="panel1SlideDownContent" class="panelSlideDownContent">
            1111111111
        </div>
        <div id="panel2SlideDownContent" class="panelSlideDownContent">
            <div class="slideDownNest">
                <div id="heatChoice" class="mapToggleContainer">
                    <div class="roundedTwo">
                        <input type="checkbox" value="None" id="toggleHeat" onchange="window.MAP.toggleHeatmap()" class="checkboxUnder" name="check" checked />
                        <label for="toggleHeat"></label>
                    </div>
                    <span>Heat Map</span>
                </div>
                <div id="markerChoice" class="mapToggleContainer">
                    <div class="roundedTwo">
                        <input type="checkbox" value="None" id="toggleIcons" onchange="window.MAP.toggleIcons()" class="checkboxUnder" name="check" checked />
                        <label for="toggleIcons"></label>
                    </div>
                    <span>Markers</span>
                </div>
            </div>
        </div>
        <div id="panel3SlideDownContent" class="panelSlideDownContent">
            <div class="slideDownNest">
                <ul>
                    <li>
                        <div class="roundedTwo">
                            <input type="checkbox" value="None" id="toggleForum" onchange="window.Comments.toggleComments('forum')" class="checkboxUnder" name="check" checked />
                            <label for="toggleForum"></label>
                        </div>
                        <span>Forum</span>
                    </li>
                    <li>
                        <div class="roundedTwo">
                            <input type="checkbox" value="None" id="toggleNeeds" onchange="window.Comments.toggleComments('needs')" class="checkboxUnder" name="check" checked />
                            <label for="toggleNeeds"></label>
                        </div>
                        <span>Needs</span>
                    </li>
                    <li>
                        <div class="roundedTwo">
                            <input type="checkbox" value="None" id="toggleMessages" onchange="window.Comments.toggleComments('message')" class="checkboxUnder" name="check" checked />
                            <label for="toggleMessages"></label>
                        </div>
                        <span>Messages</span>
                    </li>
                    <li><div class="addCommentButton commentButton" id="addCommentButton" onclick="window.UI.showMarkerTypeSelect('comment')">+ New Comment</div></li>
                    <input type="hidden" id="commentTypeToBePosted" value="null" />
                    <input type="hidden" id="commentToBePosted" value="null" />
                </ul>
            </div>
        </div>
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
        <div class="tile tile1" id="selectPickup">Pickup</div>
        <div class="tile tile2" id="selectComment">Comment</div>
        <div class="tile tile3" id="selectTrash">Trash</div>
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
        <li><a id="homeNavButton">Home</a></li>
        <li><a id="mapsNavButton">Maps</a></li>
        <li><a id="commentsNavButton">Comments</a></li>
    </ul>
</div>


</body>

</html>
