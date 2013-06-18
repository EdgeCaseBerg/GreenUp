
var map, pointarray, heatmap, pickupMarkers, markerFlag;
var markerType = -1;
var markerEvent;
var HELP_TRASH = 1;
var TRASH_DROP = 2;
var COMMENT_LOC = 3;
var MOUSEDOWN_TIME;
var MOUSEUP_TIME;
var logging = false;
var centerPoint = null;


pickupMarkers = [];

google.maps.event.addDomListener(window, 'load', initialize);
google.maps.event.addDomListener(window, 'load', initIcons);

function initialize() {
    var heatmapData = getHeatmapData();
    // initMap(lat, lon, zoom)
    getIpGeo();
    // initMap(dataArr[0], dataArr[1], dataArr[2]);
    initMap(37.774546, -122.433523, 17);
    initHeatMap(heatmapData);
} // end initialize


function initializeGPS(){
    db = Lawnchair({name : 'db'}, function(store) {
        lawnDB = store;
        setInterval(function() {runUpdate(store)},5000);//update user location every 5 seconds
        setInterval(function() {upload(store)},3000);//upload locations to the server every 30 seconds
    });
}

function start(){
    logging = true;
    initializeGPS();
    console.log("starting...");
    document.getElementById('startButton').style.display = 'none';
    document.getElementById('stopButton').style.display = 'block';
    //document.getElementById('panel1').style.backgroundImage = 'url(/client/img/icons/leaf.png)';


    navigator.geolocation.getCurrentPosition(function(p){
        var newcenter = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);
        centerPoint = newcenter;
        map.panTo(newcenter);
    });
    
}

function recenterMap(lat, lon){
    console.log(lat);
    var newcenter = new google.maps.LatLng(lat, lon);
        centerPoint = newcenter;
        map.panTo(newcenter);
}


function stop(){
    upload(lawnDB);
    logging = false;
    console.log("stopping...")
    //document.getElementById('panel1').style.backgroundImage = '';
    document.getElementById('startButton').style.display = 'block';
    document.getElementById('stopButton').style.display= 'none';
}

//Runs the update script:

function runUpdate(database){
    //Grab the geolocation data from the local machine
    navigator.geolocation.getCurrentPosition(function(position) {
          updateLocation(database, position.coords.latitude, position.coords.longitude);
    });
}

//Uploads all local database entries to the Server
//Clears the local storage after upload
function upload(database){
    if(logging){
        //server/addgriddata.php
    
        database.all(function(data){
            console.log(data);
            $.ajax({
                type:'POST',
                url: '../server/addGridData.php',
                dataType:"json",
                data: {data : data},
                failure: function(errMsg){alert(errMsg);}
            });//Ajax
        
            //Remove all uploaded database records
            for(var i=1;i<data.length;i++){
                database.remove(i);
            }
        });
    }
}

//Updates the local couch DB with the current info
function updateLocation(database, latitude, longitude){
    if(logging){
        var datetime = new Date().getTime();//generate timestamp
        var location = {
                "latitude" : latitude,
                "longitude" : longitude,
                "datetime" : datetime,
        }
    
        database.save({value:location});//Save the record
    }
};


function findME(){
    var coords = new array();
    lawnDB.all(function(obj){
        coords.push(obj[obj.length - 1].value.latitude);
        coords.push(obj[obj.length - 1].value.longitude);
    });
    
    return coords;
}


// resolve our ip to a geolocation for initial map setup
function getIpGeo(){
    dataArr =[];
    var query = "../server/locationByIp.php";
    Lib.ajax.getJSON({
        url: query,
        type: "json"
        },function(data){
            // dataArr = data;
            // // var dataArr = eval("("+data+")");
            // console.log("working");
            // console.log();
            // recenterMap(data);
        }
    );
    // return dataArr;
}




// we should be supplying the 4 lat/lons to frame the map and only download what we need
// gets heatmap data and formats it for initHeatMap() 
function getHeatmapData(){
    var heatmapData = [];
    var query = "../server/getHeatmapPoints.php";
    Lib.ajax.getJSON({
        url: query,
        type: "json"
        }, function(data){
            // console.log(data);
            var dataArr = eval("("+data+")");

            for(ii=0; ii<dataArr.length; ii++){
                // var dataA = dataArr[ii].split(",");
                heatmapData.push({location: new google.maps.LatLng(dataArr[ii][0], dataArr[ii][1]), weight: dataArr[ii][2]});
            }
            console.log("working");
            console.log(heatmapData);
        }
    );
    return heatmapData;
} // end getHeatmapData

// @argument heatData = array returned by getHeatMapData()
function initHeatMap(heatData){
  var pointArray = new google.maps.MVCArray(heatData);
  heatmap = new google.maps.visualization.HeatmapLayer({
    data: pointArray,
    dissipating: true, 
    radius: 5
  });

  heatmap.setMap(null);
}


// fire up our google map
function initMap(centerpointLat, centerpointLon, zoom){
    // define the initial location of our map
    centerPoint = new google.maps.LatLng(centerpointLat, centerpointLon); 
    var mapOptions = {
    zoom: zoom,
    center: centerPoint,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById('map-canvas'),mapOptions);
  google.maps.event.addListener(map, 'mousedown', markerSelectDown);
  google.maps.event.addListener(map, 'mouseup', markerSelectUp);

}

function initIcons(){
    var pickupIcon = "img/icons/greenCircle.png";
    pickupMarkers = [];

  $.getJSON("../server/getPointsOfInterest.php", function(data) {
    // Lib.ajax.getJSON({
        // url:"/server/getPointsOfInterest.php",
        // type: "json"
        // }, function(data){
       for (var i = data.length - 1; i >= 0; i--) {
           var types = [null, "img/icons/blueCircle.png" ,"img/icons/redCircle.png" ,"img/icons/greenCircle.png" ];
           var marker =  new google.maps.Marker({position: new google.maps.LatLng(data[i].lat,data[i].lon), 
                                                map: map, 
                                                icon: types[data[i].fkType]
                                            });

           pickupMarkers.push(marker);
       };
       for (var i = pickupMarkers.length - 1; i >= 0; i--) {
            pickupMarkers[i].setVisible(false);
            //Add a custom field to the markers so we can have the information that goes in the infobox
            pickupMarkers[i].messageData = data[i].message;

            google.maps.event.addListener(pickupMarkers[i], "click", function () {
                var info = new google.maps.InfoWindow();
                info.setContent(this.messageData);
                info.setPosition(this.position);
                info.open(map);
                
            });
        }
    });

    

    markerFlag = false;
}

function toggleHeatmap() {
    heatmap.setMap(heatmap.getMap() ? null : map);
}

function toggleIcons(){
    var newState;
    if(markerFlag){
        newState = false;
        markerFlag = false;
    }else{
        newState = true;
        markerFlag = true;
    }
    for (var i = 0; i < pickupMarkers.length; i++){
        pickupMarkers[i].setVisible(newState);
    }
}

// add an icon for a pickup
function addPickupMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/greenCircle.png"
    });
    pickupMarkers.push(marker);

    var info = new google.maps.InfoWindow();
    info.setContent('<form id="hook" class="infowindow pickup" method="GET" action="../server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><textarea name="message"/></textarea><input type="hidden" name="topic" value="3" /><input type="hidden" name="add" /><input type="submit"  onmousedown="showToggleContainer" />');
    info.setPosition(marker.position);
    info.open(map);
}

// add an icon for a Comment location
function addCommentMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/blueCircle.png"
    });
    pickupMarkers.push(marker);

    var info = new google.maps.InfoWindow();
    info.setContent('<form id="hook" class="infowindow comment" method="GET" action="../server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><textarea name="message"/></textarea><input type="hidden" name="topic" value="1" /><input type="hidden" name="add" /><input type="submit"  onmousedown="showToggleContainer" />');
    info.setPosition(marker.position);
    info.open(map);
}

// add an icon to indicate where trash was found
function addTrashMarker(){
    var marker = new google.maps.Marker({
        position: markerEvent.latLng,
        map: map,
        icon: "img/icons/redCircle.png"
    });
    pickupMarkers.push(marker);

    //corresponds to the help needed
    var info = new google.maps.InfoWindow();
    info.setContent('<form id="hook" class="infowindow helpme" method="GET" action="../server/communication.php"><input type="hidden" name="lat" value="'+marker.position.lat()+'"/><input type="hidden" name="lon" value="'+marker.position.lng()+'" /><textarea name="message"/></textarea><input type="hidden" name="topic" value="2" /><input type="hidden" name="add" /><input type="submit"  onmousedown="showToggleContainer" />');
    info.setPosition(marker.position);
    info.open(map);
}

function showToggleContainer(){
    // $('.toggleContainer').show();
    document.getElementById("toggleContainer").className = "showBlock";
}

function markerSelectUp(event){
    markerEvent = event;
    MOUSEUP_TIME = new Date().getTime() / 1000;
    if((MOUSEUP_TIME - MOUSEDOWN_TIME) < 0.3){
        // alert((MOUSEUP_TIME - MOUSEDOWN_TIME));
        $('#markerTypeDialog').toggle();
        MOUSEDOWN_TIME =0;
        MOUSEDOWN_TIME =0;
    }else{
        MOUSEDOWN_TIME =0;
        MOUSEDOWN_TIME =0;
    }
}

// native javascript version of $.getJSON
// http://gabrieleromanato.name/javascript-implementing-getjson-from-scratch/

   

function markerSelectDown(event){
    markerEvent = event;
    MOUSEDOWN_TIME = new Date().getTime() / 1000;
    // if((MOUSEUP_TIME - MOUSEDOWN_TIME) < 2){
    //     $('#markerTypeDialog').toggle();
    //     MOUSEDOWN_TIME =0;
    //     MOUSEDOWN_TIME =0;
    // }else{
    //     MOUSEDOWN_TIME =0;
    //     MOUSEDOWN_TIME =0;
    // }
}


function changeRadius() {
  heatmap.setOptions({radius: heatmap.get('radius') ? null : 20});
}

function changeOpacity() {
  heatmap.setOptions({opacity: heatmap.get('opacity') ? null : 0.2});
}



// $(document).ready(function(){
document.addEventListener('DOMContentLoaded',function(){

    // our native replacement for jquery.getJSON
    var Lib = {
            ajax: {
                xhr: function() {
                    var instance = new XMLHttpRequest();
                    return instance;
                },
            
                getJSON: function(options, callback) {
                    var xhttp = this.xhr();
                    options.url = options.url || location.href;
                    options.data = options.data || null;
                    callback = callback ||
                    function() {};
                    options.type = options.type || 'json';
                    var url = options.url;
                    if (options.type == 'jsonp') {
                        window.jsonCallback = callback;
                        var $url = url.replace('callback=?', 'callback=jsonCallback');
                        var script = document.createElement('script');
                        script.src = $url;
                        document.body.appendChild(script);
                    }
                    xhttp.open('GET', options.url, true);
                    xhttp.send(options.data);
                    xhttp.onreadystatechange = function() {
                        if (xhttp.status == 200 && xhttp.readyState == 4) {
                            callback(xhttp.responseText);
                        }
                    };
                }
            }
        };

    window.Lib = Lib;

    document.addEventListener("touchmove", function(e){
        e.preventDefault();
    }, false);

    // var scrollable = document.getElementByClassName('scrollable');
    var toggleHeat = document.getElementById('toggleHeat');
    var toggleIco = document.getElementById('toggleIcons');
    var selectPickup = document.getElementById('selectPickup');
    var selectComment = document.getElementById('selectComment');
    var selectTrash = document.getElementById('selectTrash');

    var mapInit = document.getElementById('mapInit');
    var startButton = document.getElementById('startButton');
    var stopButton = document.getElementById('stopButton');


    toggleHeat.addEventListener('click', function() {
        toggleHeatmap();
    }, false);

    toggleIco.addEventListener('click', function() {
        toggleIcons();
    }, false);

    selectPickup.addEventListener('click', function() {
        $('#markerTypeDialog').toggle();
        // $('.toggleContainer').hide();
        document.getElementById("toggleContainer").className = "hidden";

        addPickupMarker();
    }, false);

    selectComment.addEventListener('click', function() {
        $('#markerTypeDialog').toggle();
        // $('.toggleContainer').hide();
        document.getElementById("toggleContainer").className = "hidden";
        addCommentMarker();
    }, false);

    selectTrash.addEventListener('click', function() {
        $('#markerTypeDialog').toggle();
        // $('.toggleContainer').hide();
        document.getElementById("toggleContainer").className = "hidden";
        addTrashMarker();
    }, false);

    mapInit.addEventListener('mousedown', function() {
         $('.mapDecoyContainer').hide(function(){
            $('.mapContainer').show();
        });
    }, false);

    startButton.addEventListener('mousedown', function() {
        start();
    }, false);

    stopButton.addEventListener('mousedown', function() {
        stop();
    }, false);


    var pr1 = document.getElementById("pr1");
    pr1.addEventListener('mousedown', function() {
        document.getElementById("container").className = "";
        document.getElementById("container").className = "panel2Center";
    }, false);

    var prr1 = document.getElementById("prr1");
    prr1.addEventListener('mousedown', function() {
        document.getElementById("container").className = "";
        document.getElementById("container").className = "panel3Center";
    }, false);

    var pr2 = document.getElementById("pr2");
    pr2.addEventListener('mousedown', function() {
        document.getElementById("container").className = "";
        document.getElementById("container").className = "panel3Center";
    }, false);

    var pl2 = document.getElementById("pl2");
    pl2.addEventListener('mousedown', function() {
        document.getElementById("container").className = "";
        document.getElementById("container").className = "panel1Center";
    }, false);

    var pl3 = document.getElementById("pl3");
    pl3.addEventListener('mousedown', function() {
        document.getElementById("container").className = "";
        document.getElementById("container").className = "panel2Center";
    }, false);

    var pll3 = document.getElementById("pll3");
    pll3.addEventListener('mousedown', function() {
        document.getElementById("container").className = "";
        document.getElementById("container").className = "panel1Center";
    }, false);

    //Get the parameters in the get url and expose them
    var prmstr = window.location.search.substr(1);
    var prmarr = prmstr.split ("&");
    var params = {};

    for ( var i = 0; i < prmarr.length; i++) {
        var tmparr = prmarr[i].split("=");
        params[tmparr[0]] = tmparr[1];
    }

    //Check the param and look for pane
    if(params.pane != "undefined"){
        switch(params.pane){
            case "2":
                document.getElementById("container").className = "";
                document.getElementById("container").className = "panel2Center";
                break;
            case "3":
                document.getElementById("container").className = "";
                document.getElementById("container").className = "panel3Center";
                break;
        }
    }


    // $('#map-canvas').mousedown(function(){
    //     MOUSEDOWN_TIME = new Date().getTime() / 1000;
    // });
    // $('#map-canvas').mouseup(function(){
    //     MOUSEUP_TIME = new Date().getTime() / 1000;
    // });

    recenterMap(parseFloat($('#initLat').val()), parseFloat($('#initLon').val()));

});
