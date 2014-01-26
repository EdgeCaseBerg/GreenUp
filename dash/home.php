<?php

require "../dash-auth/conf.php";


// check if we used HTTPS, if not, redirect to https
if(!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off'){}else{
    //        header("Location: https://".HOST."/green-web/dash/index.php");
}

// login creds
if(isset($_POST['username']) && isset($_POST['password'])){
    // call up the auth server with CURL
    $ch = curl_init();
    $arr = array();
    $arr['id'] = $_POST['username'];
    $arr['us'] = $_POST['password'];
    $str = json_encode($arr);

    curl_setopt($ch, CURLOPT_URL,            "http://".HOST."/green-web/dash-auth/api/auth.php" );
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1 );
    curl_setopt($ch, CURLOPT_POST,           1 );
    curl_setopt($ch, CURLOPT_POSTFIELDS, $str);
    curl_setopt($ch, CURLOPT_HTTPHEADER,     array('Content-Type: application/json'));
    $res = curl_exec($ch);
    // check our results, then redirect if need be, with error codes.
    $result=json_decode($res);
    if(!isset($result->token)){
        header('Location: index.php?errorno=2');
    }
}else{
    header('Location: index.php?errorno=1');
}

if(!isset($_COOKIE[session_name()])){
    session_start();
}

?>



<!DOCTYPE html>
<html style="height: 100%; background: #eee">
<head>
    <title>GreenUp-VT Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap -->
    <link href="bootstrap-3.0.0/dist/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="styles.css" rel="stylesheet" media="screen">
    <link href="js/lib/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet" media="screen">
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/lib/jquery/jquery.js"></script>
    <script src="js/lib/BigNumber.js"></script>


    <script src="js/lib/jquery-ui-1.10.3/ui/jquery-ui.js"> </script>
    <script src="js/lib/jquery-ui-1.10.3/ui/jquery.ui.widget.js"> </script>
    <script src="js/lib/jquery-ui-1.10.3/ui/jquery.ui.datepicker.js"> </script>

    <script src="js/Helper.js"></script>

    <script src="js/apiConnector.js"></script>
    <script src="js/greenUpMap.js"></script>
    <script src="js/greenUpComments.js"></script>

    <script src="js/greenUpUi.js"></script>
    <script src="js/main.js"></script>




    <script type="text/javascript"
            src="https://maps.googleapis.com/maps/api/js?libraries=visualization&key=AIzaSyDlth022D4txU5HqXdDs1OZyGX0KdwKXIg&sensor=false"></script>



    <!-- Include all compiled plugins (below), or include individual files as needed
  <script src="bootstrap-3.0.0/dist/js/bootstrap.min.js"></script> -->

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript"
            src="https://www.google.com/jsapi?autoload={'modules':[{'name':'visualization','version':'1','packages':['corechart'],'language':'ru'}]}"></script>

    <!--<script src="https://apis.google.com/js/client.js?onload=loadAnalytics"></script>-->

    <script src="js/lib/jquery.cookie.js"></script>




    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="../../assets/js/html5shiv.js"></script>
    <script src="../../assets/js/respond.min.js"></script>
    <![endif]-->

    <script>

        $(document).ready(function(){
            //
            window.TOKEN = getParameterByName("token");
            window.userID = getParameterByName("user");
            console.log(window.TOKEN);
            console.log(window.userID);

            window.HELPER = new Helper();
            console.log("window helper");
            window.LOGGER = new ClientLogger();
            window.INPUT_TYPE = new INPUT_TYPE();



            // instansiate the api
            window.ApiConnector = new ApiConnector();
            window.ApiConnector.authenticateToken(window.userID, window.TOKEN);
            // instansiate the forum
            window.Comments = new CommentsHandle();
            // instansiate /initialize the UI controls
            window.UI = new UiHandle();
            window.UI.init();
            // build out the google map

            window.MAP = new MapHandle();
            if(!window.DEBUG){
                window.MAP.initMap();
            }
            // grab our comments, map markers, and heatmap data
            window.ApiConnector.pullCommentData();
            window.ApiConnector.pullMarkerData();
            window.ApiConnector.pullHeatmapData();
            window.ApiConnector.pullRawHeatmapData();


            $('#loginButton').mouseenter(function(){
                $('#loginButton').text("Logout");
            });

            $('#loginButton').mouseleave(function(){
                $('#loginButton').text("Administrative Dashboard");
            });

            $('#loginButton').click(function(){
                window.location = "index.php?logout=true"
            });
        });

        function getParameterByName(name) {
            var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
            return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
        }



    </script>
</head>

<body>
<nav class="navbar navbar-default" role="navigation">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="#"><img src="images/greenup-logo-redux.png" height="50" id="navLogo" /></a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse navbar-ex1-collapse">
        <ul class="nav navbar-nav">
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><button type="button"  id="loginButton" class="btn btn-default btn-md">Administrative Dashboard</button></li>
        </ul>
    </div><!-- /.navbar-collapse -->
</nav>


<div class="row mapAdminContainer">
    <div id="iconContainer">
        <img id="infoIcon" src="images/info-icon-dark.png" height="40" width="40"/>

        <img id="commentsIcon" src="images/comment-icon.png" height="40" width="40"/>
    </div>
    <div id="map-canvas">
    </div>
    <div id="markerTypeDialog" class="markerTypeSelectDialog">

        <div id="extendedAnalyticsDialog">
            <div class="analyticsColumnContainer">

                <div class="nestedAnalyticsColumn row2AnalyticsColumn">
                    <div class="analyticsHeader extendedAnalyticsHeader">
                        Total Time Worked
                    </div>
                    <div class="analyticsData">
                        <div class="timeComponentNest">
                            <div class="timeComponent" id="totalDaysWorked"></div>
                            <!-- <div class="timeComponent">100</div> -->
                            <div class="timeComponentLabel">DAYS</div>
                        </div>

                        <div class="timeComponentNest">
                            <div class="timeComponent" id="totalHoursWorked">00</div>
                            <div class="timeComponentLabel">
                                HRS
                            </div>
                        </div>

                        <div class="timeComponentNest">
                            <div class="timeComponent" id="totalMinutesWorked">00</div>
                            <div class="timeComponentLabel">
                                MINS
                            </div>
                        </div>

                        <div class="timeComponentNest">
                            <div class="timeComponent" id="totalSecondsWorked">00</div>
                            <div class="timeComponentLabel">
                                SECS
                            </div>
                        </div>

                    </div>
                </div>


                <div class="nestedAnalyticsColumn row2AnalyticsColumn">
                    <div class="analyticsHeader extendedAnalyticsHeader">
                        Total Acres Cleaned
                    </div>
                    <div class="analyticsData">

                        <div id="acresWorked"></div>

                    </div>
                </div>
            </div>

        </div> <!-- end extendedAnalyticsDialog -->

        <div id="analyticsDialog">
            <div class="analyticsColumnContainer">

                <div class="nestedAnalyticsColumn row1AnalyticsColumn">
                    <div class="analyticsHeader">
                        Analytics Sample Period
                    </div>
                    <div class="analyticsData">
                        <ul>
                            <li>Start Date:&nbsp;<input type="text" class="datePicker" id="startDateInput"/></li>
                            <li> End Date: &nbsp;&nbsp;<input type="text" class="datePicker" id="endDateInput"/></li>
                            <li><input type="button" value="update" id="updateAnalyticsButton" /></li>
                        </ul>
                    </div>
                </div>

                <div class="nestedAnalyticsColumn row1AnalyticsColumn">
                    <div class="analyticsHeader">
                        User Device Breakdown
                    </div>
                    <div class="analyticsData">
                        <div class="analyticsDataNestColumn usageDataNestColumn">
                            <ul>
                                <li>iPhone  <span class="analyticsDataPoint" id="pctIphone"></span></li>
                                <li>Android <span class="analyticsDataPoint" id="pctAndroid"></span></li>
                                <li>Web <span class="analyticsDataPoint" id="pctOther"></span></li>
                            </ul>
                        </div>
                        <div class="analyticsDataNestColumn usageDataNestColumn usageDataChart" id="usageDataPieChart"></div>
                    </div>
                </div>

                <div class="nestedAnalyticsColumn row1AnalyticsColumn">
                    <div class="analyticsHeader">
                        Users Per Day
                    </div>
                    <div class="analyticsData">
                        <div class="usageDataChart" id="usageDataLineChart"></div>
                    </div>
                </div>
            </div>
        </div> <!-- end analyticsDialog -->



    </div>
</div>

<div id="commentsDialog">
    <div id="bubbleContainer">
    </div>
</div>

<div id="addMarkerDashContainer">
    <div id="addMarkerDashNest">
        <div id="addMarkerDashHeader">
            <img src="images/icons/new_trash1.png" />
            Add a marker to the map
        </div>
        <div id="addMarkerDashContent">
            <ul>
                <li class="inputLocationTypeLi">
                    <input type="radio" name="group" class="locationTypeMenuItem" id="latLonSelect" checked>&nbsp;&nbsp;&nbsp;Latitude / Longitude
                </li>
                <li class="inputLocationTypeLi">
                    <input type="radio" name="group" class="locationTypeMenuItem" id="streetSelect">&nbsp;&nbsp;&nbsp;Street Address
                </li>
            </ul>

            <div id="coordsInputContainer" class="locationTypeInputContainer">
                <ul id="coordsInputNest" class="markerInputNest">
                    <li>
                        <div class="inputLabel">Latitude</div>
                        <div class="inputInput">
                            <input type="text" name="coords" id="markerLat" />
                        </div>
                    <li>
                        <div class="inputLabel">Longitude</div>
                        <div class="inputInput">
                            <input type="text" name="coords" id="markerLng" />
                        </div>
                </ul>
            </div>

            <div id="streetInputContainer" class="locationTypeInputContainer">
                <form id="streetInputForm">
                    <ul id="streetInputNest" class="markerInputNest">
                        <li>
                            <div class="inputLabel">Address 1</div>
                            <div class="inputInput">
                                <input type="text" name="streetAddress1" />
                            </div>
                        </li>
                        <li>
                            <div class="inputLabel">Address 2</div>
                            <div class="inputInput">
                                <input type="text" name="streetAddress2" />
                            </div>
                        <li>
                            <div class="inputLabel">City</div>
                            <div class="inputInput">
                                <input type="text" name="streetAddressCity" />
                            </div>
                        <li>
                            <div class="inputLabel">State</div>
                            <div class="inputInput">
                                <input type="text" name="streetAddressState" />
                            </div>
                        <li>
                            <div class="inputLabel">Zip</div>
                            <div class="inputInput">
                                <input type="text" name="streetAddressZip" />
                            </div>
                    </ul>
            </div>
            <ul>
                <li>Comment</li>
                <li><textarea id="markerTextarea"></textarea></li>
                <li><input type="button" value="Add Marker" id="addMarkerGoButton"/><input type="button" id="addMarkerCaneclButton" value="Cancel" /></li>
            </ul>
            </form>
        </div>
    </div>
</div>



</body>


</html>
