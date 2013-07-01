

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, target-densityDpi=96"/>
<!-- <link rel="stylesheet" href="css/homepage.css"> -->
<!-- <link rel="stylesheet" href="css/mapUI.css"> -->
<!-- <link rel="stylesheet" href="css/homeUI.css"> -->
<!-- <link rel="stylesheet" href="css/cardsUI.css"> -->
<!-- <link rel="stylesheet" href="css/messages.css"> -->
<link rel="stylesheet" href="css/styles.css">

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.0/jquery.min.js"></script>
<script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?libraries=visualization&key=AIzaSyDlth022D4txU5HqXdDs1OZyGX0KdwKXIg&sensor=false"></script>
<script src="js/markerwithlabel.js"></script>
<script type="text/javascript" src="js/lawnchair-js.js"></script>
<!-- <script type="text/javascript" src="js/app.js"></script> -->
<!-- <script type="text/javascript" src="js/mapsUI.js"></script> -->
<script type="text/javascript" src="js/ApiConnector.js"></script>


</head>

<body>
	<!-- <div id="loading">
		<img src="img/startup/ajax-loader.gif">
	</div> -->

	<div id="container">
        <input type="hidden" id="initLat" value="23" />
        <input type="hidden" id="initLon" value=="22" />
		<div class="panel" id="panel1">

            <!-- Main Page Content -->

            <h1> Green Up Vermont </h1>   
            <div id="bodyText"> 
                <p> Help keep Vermont green. Track your clean up progress, see what areas need the 
                    most help, and find an area to drop off what you pick up.
                        <br />
                        <br />
                    To start greening up VT, hit "start clean up." To find a drop off point or to flag an area, go to the maps page. 
                </p>


                <div class="start" id="startButton">
                    <a id="startbutton" onclick="start">Start Cleaning Up</a>
                </div>


                <div class="stop" id="stopButton" style="display: none;">   
                    <a id="stopButton">Stop Cleaning Up</a>
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
                	<div class="toggleContainer" id="toggleContainer">
                    	<ul>
                        	<li><input type="checkbox" id="toggleHeat" /><span class="checkboxlabel">Heat Map</span></li>
                        	<li><input type="checkbox" id="toggleIcons" /><span class="checkboxlabel">Points of Interest</span></li>
                    	</ul>
                	</div>
        		</div>

                <div class="mapDecoyContainer">
                    <input type="button" value="Go Map" id="mapInit" />
                </div>

		        <div id="markerTypeDialog">
		            <div id="markerTypeDialogNest">
		                <input type="button" value="Pickup point" id="selectPickup" />
		                <input type="button" value="Comment point" id="selectComment" />
		                <input type="button" value="Trash point" id="selectTrash" />
                        <input type="button" value="Close" onclick="$('#markerTypeDialog').toggle();" />
		            </div>
		          <!--   <input type="button" value="Lots of Trash" onClick="addTrashMarker">
		            <input type="button" value="Comment point" onClick="addCommentMarker"> -->
		        <!-- </div> -->
			</div>
			<!-- <input type="button" value="panel left" id="pl2">
			<input type="button" value="panel right" id="pr2"> -->
        </div>

		<div class="panel" id="panel3">
                <div>
                <form action="/server/communication.php" method="GET">
                    <input type="hidden" name="add" value="true" />
                       <div>
                        
                        <h1>Recent Messages From the Green Up Community</h1>
                        <div>
                            <h3>Post your message</h3>
                        <select name="topic">
                          <option value="1">Forum Message</option>
                          <option value="2">Volunteers Needed</option>
                          <option value="3">Trash Pickup</option>
                        </select>
                        </div>  

                        <textarea name="message" id="message"></textarea>

                        <div>
                        <input type="submit" name="Submit" value="Submit" />
                        <input type="reset" name="Submit2" value="Reset" />
                        </div>

                        </div>

                </form>
                </div>


                <ul class="filter">
                    <li><a onclick='showAll("messages"); return false;'>Show Messages</a></li>
                    <li><a  onclick='showAll("help"); return false;'>Show Needs</a></li>
                    <li><a  onclick='showAll("trash"); return false;'>Show Trash</a></li>
                    <li><a  onclick='showAll("All"); return false;'>Show All</a></li>
                </ul>

            <div >
            	
            	<ul id="messages" class="message"></ul>
            </div>

            <div id="moar">
            	<a href="#moar" onclick=moar();><h2>Load More</h2></a>
            </div>
		</div>
	</div>
    <ul class="nav">
        <li><a id="pan1">Home</a></li>
        <li><a id="pan2">Maps</a></li>
        <li><a id="pan3">Comments</a></li>
    </ul>
</body>

</html>
