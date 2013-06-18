<?php
include '../server/locationByIp.php';
$dataArr = ipGeo();
?>

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
<script type="text/javascript" src="js/mapsUI.js"></script>


</head>

<body>
	<!-- <div id="loading">
		<img src="img/startup/ajax-loader.gif">
	</div> -->

	<div id="container">
        <input type="hidden" id="initLat" value=<? echo "'".$dataArr[0]."'"; ?> />
        <input type="hidden" id="initLon" value=<? echo "'".$dataArr[1]."'"; ?> />
		<div class="panel" id="panel1">
			<ul class="nav">
                <li><a>Home</a></li>
                <li><a id="pr1">Maps</a></li>
                <li><a id="prr1">Comments</a></li>
            </ul>

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
            		<ul class="nav">
                		<li><a id="pl2">Home</a></li>
                		<li><a >Maps</a></li>
               			<li><a id="pr2">Comments</a></li>
            		</ul>
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
			      
            <ul class="nav">
                <li><a id="pll3">Home</a></li>
                <li><a id="pl3">Maps</a></li>
                <li><a>Comments</a></li>
            </ul>



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
            	<script type="text/javascript">
            		var beginLimit = 0;
            		var endLimit = 10;

            		//Get the parameters in the get url
            		var prmstr = window.location.search.substr(1);
					var prmarr = prmstr.split ("&");
					var params = {};

					for ( var i = 0; i < prmarr.length; i++) {
    					var tmparr = prmarr[i].split("=");
    					params[tmparr[0]] = tmparr[1];
					}

                    function showAll(where){
                        var toAddTo = document.getElementById('messages');
                        
                        toAddTo.innerHTML = '';
                        
                        beginLimit = 0;
                        endLimit = 20;
                        httpGet('/server/communication.php?start='+beginLimit+'&end='+endLimit+'&where='+where);

                        params.where = where;

                        return false;
                    }


            		function addMessages(xmlHttp){
            			//Yes I'm using eval. Deal.
            			var messages = eval(xmlHttp.responseText);
            			var toAddTo = document.getElementById('messages');

            			if(typeof messages != "undefined"){
	            			for (var i = 0; i < messages.length; i++) {
	            				var message = document.createElement("li");
	            				message.innerHTML = messages[i];
	            				message.className = "message"
	            				toAddTo.appendChild(message);
	            				message.appendChild(document.createElement('hr'));
	            			};
            			}
            		}

            		function moar(){
            			beginLimit = beginLimit + 10;
			    		endLimit = endLimit + 10;
			    		httpGet('/server/communication.php?start='+beginLimit+'&end='+endLimit+'&where='+params.where);
            		}

            		//Helper function to fetch URL contents
					function httpGet(theUrl){
						
			    		var xmlHttp = null;
			    		xmlHttp = new XMLHttpRequest();
			    		xmlHttp.onreadystatechange = function(){addMessages(xmlHttp)};
			    		xmlHttp.open( "GET", theUrl, true );
			    		xmlHttp.send( null );
					}

                    recenterMap(parseFloat($('#initLat').val()), parseFloat($('#initLon').val()), map);


                    
                    //httpGet('/server/communication.php?start='+beginLimit+'&end='+endLimit);
                    
            	</script>
            </div>

            <div id="moar">
            	<a href="#moar" onclick=moar();><h2>Load More</h2></a>
            </div>

      
		</div>
	</div>
</body>

</html>